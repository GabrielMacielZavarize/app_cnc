import os
import re
import time
import logging
from pathlib import Path
from typing import List, Optional
from dotenv import load_dotenv
from fastapi import FastAPI, HTTPException, Header
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import google.generativeai as genai

# Carrega variáveis do .env antes de qualquer outra inicialização
load_dotenv()

# Configuração de logs para monitoramento do servidor
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("AgenteCNC")

# Pré-configura o SDK do Gemini na inicialização do servidor se a chave já estiver disponível
_api_key_global = os.getenv("GEMINI_API_KEY")
if _api_key_global:
    genai.configure(api_key=_api_key_global)
    logger.info("Gemini API Key carregada do .env com sucesso.")

# -------------------------------------------------------------------------
# BASE DE CONHECIMENTO - EQUIVALÊNCIAS DE NORMAS INTERNACIONAIS
# -------------------------------------------------------------------------

_EQUIVALENCIAS_PATH = Path(__file__).parent / "base_conhecimento" / "tabelas" / "materiais" / "equivalencias.txt"

# Padrões de norma estrangeira que disparam a injeção de contexto
_PADROES_NORMA = re.compile(
    r'\b('
    # DIN / ISO aceros carbono
    r'C45|C22|C80|C60|C35'
    r'|42CrMo4|25CrMo4|20NiCrMo2|100Cr6'
    r'|X5CrNi18-10|X5CrNiMo17-12-2|X6Cr17|X20Cr13'
    # JIS
    r'|S45C|S20C|S80C|SCM440|SCM430|SNCM220|SUJ2'
    r'|SUS304|SUS316|SUS430|SUS420'
    # Alumínio ISO/DIN
    r'|AlMg1SiCu|AlMgSi1|AlZn5\.5MgCu|AlZnMgCu1\.5|AlCu4Mg1|AlCuMg2|AlMg0\.7Si'
    # Ferro fundido DIN antigo / novo
    r'|GG25|GG20|GG30|GGG50|GGG40|GJL-250|GJS-500'
    # Séries numéricas de alumínio isoladas
    r'|6061|7075|2024|6063'
    # Norma AISI/SAE só quando escritas com prefixo explícito ou isoladas de forma ambígua
    r'|AISI\s*304|AISI\s*316|AISI\s*4140|AISI\s*1045|SAE\s*1045|SAE\s*4140'
    r')\b',
    re.IGNORECASE
)


def _carregar_equivalencias() -> str:
    """Lê o arquivo de equivalências uma única vez e retorna o conteúdo."""
    try:
        return _EQUIVALENCIAS_PATH.read_text(encoding="utf-8")
    except FileNotFoundError:
        logger.warning("Arquivo equivalencias.txt não encontrado em %s", _EQUIVALENCIAS_PATH)
        return ""


def _montar_contexto_normas(texto_prompt: str) -> str:
    """Varre normas estrangeiras e injeta a tabela de equivalências quando detectadas."""
    if _PADROES_NORMA.search(texto_prompt):
        conteudo = _carregar_equivalencias()
        if conteudo:
            codigos = list({m.group(0).upper() for m in _PADROES_NORMA.finditer(texto_prompt)})
            logger.info("Normas detectadas: %s — injetando equivalências.", codigos)
            return (
                "\n\n[CONTEXTO TECNICO — EQUIVALENCIAS DE NORMAS INTERNACIONAIS]\n"
                + conteudo
                + "\n[FIM DO CONTEXTO DE NORMAS]\n"
            )
    return ""


# -------------------------------------------------------------------------
# FILTRO DE CONTROLADORES CNC (Fanuc, Siemens, Haas, etc.)
# -------------------------------------------------------------------------

_PADROES_CONTROLADOR = re.compile(
    r'\b(fanuc|siemens|sinumerik|haas|gsk|romi|mazak|mazatrol|hurco|winmax)\b',
    re.IGNORECASE
)

_CONTEXTO_CONTROLADOR = {
    "fanuc":     "O operador está utilizando o comando FANUC. Forneça a sintaxe de ciclo e os códigos G estritamente compatíveis com FANUC (ex: G71/G72 para torneamento, G83 para peck drilling, G84 para roscamento rígido, G73 para ciclo de repetição).",
    "siemens":   "O operador está utilizando o comando SIEMENS SINUMERIK. Forneça a sintaxe estritamente compatível com SIEMENS (ex: CYCLE95 para desbaste, CYCLE97 para rosca, CYCLE83 para furação profunda, CYCLE84 para roscamento rígido, TRANS/ATRANS para deslocamentos).",
    "sinumerik": "O operador está utilizando o comando SIEMENS SINUMERIK. Forneça a sintaxe estritamente compatível com SINUMERIK (ex: CYCLE95, CYCLE97, CYCLE83, CYCLE84, TRANS/ATRANS).",
    "haas":      "O operador está utilizando o comando HAAS. A sintaxe HAAS é baseada em FANUC com extensões próprias (ex: G83 peck drilling, G84 tapping, G187 para controle de acabamento, macros O9000+).",
    "gsk":       "O operador está utilizando o comando GSK (fabricante chinês). Forneça a sintaxe de ciclo compatível com GSK, que segue o padrão ISO com variações próprias (ex: G71 para desbaste, G76 para rosca).",
    "romi":      "O operador está utilizando o comando ROMI. A sintaxe ROMI é baseada em FANUC — aplique os mesmos ciclos padrão FANUC (G71, G83, G84) verificando o manual específico do modelo.",
    "mazak":     "O operador está utilizando o comando MAZAK (MAZATROL ou ISO). Se for MAZATROL, oriente em linguagem conversacional MAZATROL; se for modo ISO, aplique a sintaxe FANUC-compatível (G71, G83, G84).",
    "mazatrol":  "O operador está utilizando o comando MAZATROL (linguagem conversacional MAZAK). Oriente em parâmetros de unidade de processo MAZATROL, não em código G ISO.",
    "hurco":     "O operador está utilizando o comando HURCO WinMax. Forneça a sintaxe compatível com HURCO WinMax (programação conversacional ou ISO, ciclos de furação, contorno e bolso nativos do WinMax).",
    "winmax":    "O operador está utilizando o comando HURCO WinMax. Forneça a sintaxe compatível com WinMax (ciclos conversacionais nativos HURCO).",
}


def _montar_contexto_controlador(texto_prompt: str) -> str:
    """Detecta marca de CNC e injeta instrução de compatibilidade de sintaxe."""
    match = _PADROES_CONTROLADOR.search(texto_prompt)
    if match:
        chave = match.group(1).lower()
        instrucao = _CONTEXTO_CONTROLADOR.get(chave, "")
        if instrucao:
            logger.info("Controlador detectado: %s — injetando contexto de sintaxe.", chave.upper())
            return (
                f"\n\n[CONTEXTO DE CONTROLADOR CNC]\n{instrucao}\n[FIM DO CONTEXTO DE CONTROLADOR]\n"
            )
    return ""


# -------------------------------------------------------------------------
# CONVERSOR DE UNIDADES — SFM → m/min
# -------------------------------------------------------------------------

_PADROES_SFM = re.compile(
    r'(\d+[\.,]?\d*)\s*(?:SFM|p[eé]s?\s+por\s+minuto|p[eé]s?\/min|ft\/min)',
    re.IGNORECASE
)


def _montar_contexto_sfm(texto_prompt: str) -> str:
    """Detecta valores em SFM e injeta a conversão exata para m/min."""
    match = _PADROES_SFM.search(texto_prompt)
    if match:
        sfm = float(match.group(1).replace(',', '.'))
        m_min = round(sfm * 0.3048, 2)
        logger.info("SFM detectado: %.1f SFM → %.2f m/min — injetando conversão.", sfm, m_min)
        return (
            f"\n\n[CONVERSAO DE UNIDADES AUTOMATICA]\n"
            f"{sfm} SFM = {m_min} m/min (fator de conversao: 1 SFM = 0.3048 m/min).\n"
            f"Utilize Vc = {m_min} m/min como velocidade de corte para calcular o RPM em milimetros.\n"
            f"[FIM DA CONVERSAO]\n"
        )
    return ""


# -------------------------------------------------------------------------
# ORQUESTRADOR DE CONTEXTO — combina todos os módulos de enriquecimento
# -------------------------------------------------------------------------

def _montar_contexto_enriquecido(texto_prompt: str) -> str:
    """Agrega todos os blocos de contexto técnico para injeção no prompt."""
    blocos = [
        _montar_contexto_normas(texto_prompt),
        _montar_contexto_controlador(texto_prompt),
        _montar_contexto_sfm(texto_prompt),
    ]
    return "".join(b for b in blocos if b)

app = FastAPI(
    title="Agente CNC - Motor de Inteligência de Usinagem",
    description="Backend de alta performance para suporte a operadores e programadores CNC"
)

# Configuração de CORS para permitir conexões do aplicativo Flutter (Web/Mobile)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# -------------------------------------------------------------------------
# CONFIGURAÇÃO DE SEGURANÇA E MODELO DE DADOS PYDANTIC
# -------------------------------------------------------------------------

class MessagePart(BaseModel):
    text: str

class ChatMessage(BaseModel):
    role: str  # 'user' ou 'model'
    parts: List[MessagePart]

class ConsultaRequest(BaseModel):
    prompt: Optional[str] = None
    pergunta: Optional[str] = None
    history: Optional[List[ChatMessage]] = None
    historico: Optional[List[dict]] = None  # formato legado do Flutter: [{'role':..,'text':..}]

class ConsultaResponse(BaseModel):
    resposta: str = Field(..., description="Texto limpo e estruturado da resposta técnica do Mestre CNC")

# -------------------------------------------------------------------------
# PROMPT DO SISTEMA (Mestre CNC - Engenheiro de Aplicação Sênior)
# -------------------------------------------------------------------------
SYSTEM_PROMPT = (
    "Você é o \"Mestre CNC\", um Engenheiro de Aplicação e Programador CNC Sênior Multi-Comando com mais de 20 anos de chão de fábrica. "
    "Você é sério, preciso, altamente técnico, direto e focado em produtividade e segurança de máquina. "
    "Você se comunica usando a terminologia correta de engenharia de usinagem e evita linguagens excessivamente informais ou gírias forçadas.\n"
    "Seu objetivo é guiar o operador ou programador de forma rápida, eliminando qualquer margem para erro.\n\n"
    "DIRETRIZ DE ADAPTAÇÃO DE COMANDO (REGRA ABSOLUTA DE PRIORIDADE):\n"
    "Você domina nativamente todos os principais comandos CNC do mercado. Adapte sua resposta estritamente ao fabricante "
    "mencionado pelo operador, sem jamais substituir a sintaxe correta por outra:\n"
    "- SIEMENS SINUMERIK: use exclusivamente a estrutura nativa Siemens (ex: CYCLE83 para furação profunda, CYCLE95 para desbaste, "
    "CYCLE97 para rosca, CYCLE84 para roscamento rígido, TRANS/ATRANS para deslocamentos de zero).\n"
    "- FANUC / HAAS / ROMI: use a estrutura ISO Fanuc-compatível (ex: G71/G72 para torneamento, G83 para peck drilling, G84 para roscamento).\n"
    "- GSK: aplique a sintaxe ISO padrão GSK (G71 para desbaste, G76 para rosca).\n"
    "- MAZAK MAZATROL: oriente em linguagem conversacional MAZATROL, não em código G ISO.\n"
    "- HURCO WINMAX: forneça a sintaxe conversacional nativa WinMax.\n"
    "Se o operador NÃO mencionar nenhum fabricante, pergunte antes de fornecer código — nunca assuma Fanuc como padrão.\n\n"
    "DIRETRIZES DE INTELIGÊNCIA TÉCNICA:\n"
    "1. CONFRONTO E ANÁLISE IMEDIATA: Sempre que houver comparações entre códigos (ex: G83 vs G74), processos ou ferramentas, "
    "a primeira frase de sua resposta deve expor o confronto físico direto e a diferença funcional crucial entre eles na prática.\n"
    "2. CÁLCULO E INTEGRIDADE DE DADOS: Todos os dados de corte recomendados (RPM, Avanço F, passos ap) devem estar rigidamente "
    "associados e validados para os materiais específicos solicitados (ex: Aço 1045, Inox 316, Alumínio 6061) e compatíveis com a ferramenta.\n"
    "3. DIRETRIZ ANTI-ADIVINHAÇÃO ABSOLUTA: Se o operador omitir dados críticos para a tomada de decisão (como diâmetro, material da peça, "
    "geometria do inserto ou rigidez da máquina), NÃO chute parâmetros médios sob hipótese alguma. Responda imediatamente indicando de "
    "forma profissional e direta quais dados faltam para concluir a análise de forma segura.\n"
    "4. DIAGNÓSTICO DE FALHAS: Em perguntas de problemas (vibração, desgaste, rugosidade), aborde causas mecânicas práticas "
    "(balanço da ferramenta, fixação, geometria do quebra-cavaco, avanço ap/ae).\n\n"
    "REGRAS RÍGIDAS DE FORMATO E SINTAXE:\n"
    "- PROIBIÇÃO ABSOLUTA DE MARKDOWN: É terminantemente proibido o uso de qualquer marcação Markdown, tais como hashtags (###), "
    "asteriscos de negrito (**) ou crases de bloco de código (```). O texto deve ser retornado puramente limpo e fluido.\n"
    "- PADRÃO DE CÓDIGO G: Ao fornecer códigos, use numeração de blocos sequenciais (N10, N20...) com comentários em "
    "LETRAS MAIÚSCULAS estritamente entre parênteses (ex: N10 G00 X0 Y0 M03 S1200 (POSICIONA E LIGA EIXO))."
)

# Schema de saída do Gemini declarado como dicionário nativo (JSON Schema padrão)
gemini_response_schema = {
    "type": "OBJECT",
    "properties": {
        "resposta": {
            "type": "STRING",
            "description": "Texto corrido sem formatação Markdown",
        }
    },
    "required": ["resposta"],
}

# -------------------------------------------------------------------------
# ENDPOINT DE PROCESSAMENTO DA REQUISIÇÃO
# -------------------------------------------------------------------------

@app.post("/gerar-programa", response_model=ConsultaResponse)
async def gerar_programa(request: ConsultaRequest, api_key_header: Optional[str] = Header(None, alias="X-API-Key")):
    # 1. Recuperação e validação da chave API
    api_key = os.environ.get("GEMINI_API_KEY", "")
    if api_key_header:
        api_key = api_key_header

    if not api_key:
        logger.error("Chave API do Gemini não configurada.")
        raise HTTPException(
            status_code=401,
            detail="Chave API não encontrada. Configure o ambiente ou envie o cabeçalho X-API-Key."
        )

    # Inicializa a biblioteca do Google
    genai.configure(api_key=api_key)

    # 2. Definição do Prompt do usuário / Histórico
    prompt_usuario = request.prompt or request.pergunta
    contents = []

    if request.history:
        # Formato estruturado (ChatMessage com parts)
        for msg in request.history:
            parts_list = [{"text": part.text} for part in msg.parts]
            contents.append({"role": msg.role, "parts": parts_list})
        if prompt_usuario:
            contents.append({"role": "user", "parts": [{"text": prompt_usuario}]})

    elif request.historico:
        # Formato legado do Flutter: [{'role': 'user'|'model', 'text': '...'}]
        for msg in request.historico:
            texto = msg.get("text", "") or msg.get("content", "")
            role = msg.get("role", "user")
            if texto:
                contents.append({"role": role, "parts": [{"text": texto}]})
        if prompt_usuario:
            contents.append({"role": "user", "parts": [{"text": prompt_usuario}]})

    else:
        # Sem histórico — interação simples de turno único
        if not prompt_usuario:
            raise HTTPException(status_code=400, detail="Nenhum prompt ou histórico de mensagens fornecido.")
        contents = [{"role": "user", "parts": [{"text": prompt_usuario}]}]

    if not contents:
        raise HTTPException(status_code=400, detail="Nenhum conteúdo válido para processar.")

    # 2a. Injeção de contexto de normas internacionais
    # Varre todas as mensagens do usuário em busca de códigos de norma estrangeira
    texto_completo_usuario = " ".join(
        p["text"]
        for entry in contents
        if entry.get("role") == "user"
        for p in entry.get("parts", [])
    )
    contexto_enriquecido = _montar_contexto_enriquecido(texto_completo_usuario)
    if contexto_enriquecido:
        ultima_msg = contents[-1]
        if ultima_msg.get("role") == "user" and ultima_msg.get("parts"):
            ultima_msg["parts"][-1]["text"] += contexto_enriquecido

    # 3. Execução da chamada à API com Retentativa e Exponential Backoff
    try:
        model = genai.GenerativeModel(
            model_name="gemini-2.5-flash",
            system_instruction=SYSTEM_PROMPT,
        )

        # Configuração rígida de saída estruturada para evitar erros de leitura no Flutter
        generation_config = {
            "response_mime_type": "application/json",
            "response_schema": gemini_response_schema,
            "temperature": 0.2,
        }

        response_text = ""
        delay = 1.0  # Tempo de espera inicial

        for tentativa in range(5):
            try:
                response = model.generate_content(
                    contents=contents,
                    generation_config=generation_config
                )
                response_text = response.text
                break
            except Exception as e:
                logger.warning(f"Tentativa {tentativa + 1} falhou. Erro: {str(e)}")
                if tentativa == 4:
                    raise e
                time.sleep(delay)
                delay *= 2  # Backoff exponencial (1s, 2s, 4s, 8s, 16s)

        # 4. Tratamento e decodificação do retorno estruturado
        import json
        try:
            dados_saida = json.loads(response_text)
            resposta_limpa = dados_saida.get("resposta", "")
        except json.JSONDecodeError:
            # Fallback seguro caso a saída estruturada falhe por algum motivo de rede
            resposta_limpa = response_text.replace("```json", "").replace("```", "").strip()

        logger.info("Requisição processada com sucesso 200 OK")
        return ConsultaResponse(resposta=resposta_limpa)

    except Exception as e:
        logger.error(f"Exceção capturada no processamento: {str(e)}")
        # Nunca retorna HTTP 500 bruto. Devolvemos uma resposta amigável estruturada para o Flutter
        fallback_error_msg = (
            "Não foi possível processar sua solicitação no momento devido a uma instabilidade de conexão com a API de inteligência. "
            "Por favor, verifique sua conexão com a internet e tente novamente."
        )
        return ConsultaResponse(resposta=fallback_error_msg)


# -------------------------------------------------------------------------
# ENDPOINT DE ANÁLISE COM IA (texto + imagem) — usado pela tela de IA do app
# -------------------------------------------------------------------------

class AnaliseRequest(BaseModel):
    tipo: str = "geral"
    texto: Optional[str] = None
    imagem: Optional[str] = None  # imagem em base64 (sem o prefixo data:image/...)


_PROMPTS_ANALISE = {
    "geral": "Faça um diagnóstico técnico CNC completo do que foi enviado: identifique o contexto, "
             "as possíveis causas e as ações corretivas, com terminologia profissional.",
    "erro": "Diagnostique este alarme/erro de CNC. Identifique o fabricante (Fanuc, Siemens, Haas, Mazak, "
            "Mitsubishi...), o código e a descrição oficial, a urgência, liste as causas prováveis com "
            "probabilidade aproximada, os passos de solução na ordem correta e quando chamar o técnico.",
    "peca": "Analise esta peça/setup de CNC. Identifique o material específico (liga e grau, ex.: Alumínio "
            "6061-T6), o tipo de peça e as operações, estime dimensões e acabamento (Ra), recomende parâmetros "
            "de corte (Vc, fz, ap, ae, RPM) e ferramentas adequadas, e aponte os pontos de atenção e a "
            "sequência de operações.",
    "programa": "Revise este programa CNC. Aponte erros de sintaxe, riscos de colisão, faltas de segurança "
                "(avanço, refrigeração, plano de retorno) e sugira melhorias de produtividade.",
    "ferramenta": "Avalie o estado desta ferramenta de corte. Identifique o tipo e o desgaste visível (flanco, "
                  "cratera, lascamento, aresta postiça), diga se deve ser trocada e recomende parâmetros ou "
                  "correções para prolongar a vida útil.",
    "parametros": "Sugira parâmetros de corte para a situação descrita: velocidade de corte (Vc), avanço "
                  "(fz e F), profundidade (ap e ae) e RPM, justificando com base no material e na ferramenta. "
                  "Se faltarem dados críticos (material, diâmetro, ferramenta), peça-os antes de concluir.",
}


def _chamar_gemini_multimodal(contents: list) -> str:
    """Chama o Gemini com retry/backoff e devolve o texto (sem schema JSON)."""
    model = genai.GenerativeModel(model_name="gemini-2.5-flash", system_instruction=SYSTEM_PROMPT)
    delay = 1.0
    for tentativa in range(5):
        try:
            response = model.generate_content(contents=contents, generation_config={"temperature": 0.3})
            return response.text
        except Exception as e:  # noqa: BLE001
            logger.warning(f"Análise — tentativa {tentativa + 1} falhou: {e}")
            if tentativa == 4:
                raise
            time.sleep(delay)
            delay *= 2
    return ""


@app.post("/analisar", response_model=ConsultaResponse)
async def analisar(request: AnaliseRequest):
    api_key = os.environ.get("GEMINI_API_KEY", "")
    if not api_key:
        raise HTTPException(status_code=401, detail="Chave API do Gemini não configurada no servidor.")
    genai.configure(api_key=api_key)

    if not request.texto and not request.imagem:
        raise HTTPException(status_code=400, detail="Envie um texto ou uma imagem para análise.")

    prompt = _PROMPTS_ANALISE.get(request.tipo, _PROMPTS_ANALISE["geral"])
    if request.texto:
        prompt += f"\n\nInformações do operador:\n{request.texto}"
        prompt += _montar_contexto_enriquecido(request.texto)

    parts: list = [{"text": prompt}]
    if request.imagem:
        parts.append({"inline_data": {"mime_type": "image/jpeg", "data": request.imagem}})

    try:
        resposta = _chamar_gemini_multimodal([{"role": "user", "parts": parts}])
        logger.info("Análise IA (%s) processada com sucesso 200 OK", request.tipo)
        return ConsultaResponse(resposta=resposta.strip())
    except Exception as e:  # noqa: BLE001
        logger.error(f"Falha na análise de IA: {e}")
        return ConsultaResponse(
            resposta="Não foi possível concluir a análise no momento devido a uma instabilidade na conexão "
                     "com a IA. Verifique sua internet e tente novamente."
        )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("server:app", host="0.0.0.0", port=8000, reload=True)
