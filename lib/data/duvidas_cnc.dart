// ════════════════════════════════════════════════════════════════
// BANCO DE DÚVIDAS CNC — Base de conhecimento local
// Responde dúvidas de programadores e operadores sem internet
// ════════════════════════════════════════════════════════════════

class DuvidaCNC {
  final String id;
  final String pergunta;
  final String resposta;
  final List<String> tags;
  final String categoria;
  const DuvidaCNC({
    required this.id, required this.pergunta,
    required this.resposta, required this.tags, required this.categoria,
  });
}

const listaDuvidasCNC = <DuvidaCNC>[

  // ══════════════════════════════════════
  // PROGRAMAÇÃO — FUNDAMENTOS
  // ══════════════════════════════════════

  DuvidaCNC(
    id: 'prog_001',
    pergunta: 'Qual a diferença entre G90 e G91?',
    categoria: 'Programação',
    tags: ['G90', 'G91', 'absoluto', 'incremental', 'coordenadas'],
    resposta: '''
🔍 G90 vs G91 — Absoluto vs Incremental

▸ G90 — Coordenadas ABSOLUTAS (padrão)
Todos os movimentos são relativos ao ZERO PEÇA (origem do sistema de coordenadas).
Exemplo: G90 G01 X50. Y30. → vai EXATAMENTE para X=50, Y=30 da peça.

▸ G91 — Coordenadas INCREMENTAIS
Cada movimento é relativo à POSIÇÃO ATUAL da ferramenta.
Exemplo: G91 G01 X10. Y5. → desloca +10mm em X e +5mm em Y a partir de onde está.

📋 QUANDO USAR CADA UM:

G90 (Absoluto) — usar na maioria dos programas:
• Mais seguro — um erro não acumula para os blocos seguintes
• Fácil de editar — cada posição é clara e independente
• Padrão em todos os centros de usinagem

G91 (Incremental) — usar em situações específicas:
• Furos igualmente espaçados (repetição de passo)
• Retorno seguro: G28 G91 Z0.
• Subprogramas que se repetem com deslocamento

⚠️ ATENÇÃO: G91 é modal — fica ativo até ser cancelado por G90.
Sempre coloque G90 no início do programa para garantir o modo absoluto.

💡 DICA: G90 e G91 podem ser misturados no mesmo programa, mas com cuidado.
''',
  ),

  DuvidaCNC(
    id: 'prog_002',
    pergunta: 'Como calcular o RPM para uma fresa?',
    categoria: 'Cálculos',
    tags: ['RPM', 'velocidade', 'fresa', 'cálculo', 'Vc', 'rotação'],
    resposta: '''
📐 CÁLCULO DE RPM PARA FRESAMENTO

FÓRMULA:
n (RPM) = (Vc × 1000) / (π × Ø)

Onde:
• Vc = velocidade de corte em m/min (ver tabela por material)
• Ø  = diâmetro da fresa em mm
• π  = 3,14159

EXEMPLOS PRÁTICOS:

Fresa Ø10mm em Aço 1045, Vc = 100 m/min:
n = (100 × 1000) / (3,14 × 10) = 3185 RPM → programar S3180

Fresa Ø20mm em Alumínio, Vc = 300 m/min:
n = (300 × 1000) / (3,14 × 20) = 4775 RPM → programar S4800

Fresa Ø6mm em Inox 304, Vc = 60 m/min:
n = (60 × 1000) / (3,14 × 6) = 3185 RPM → programar S3200

CÁLCULO DO AVANÇO:
Vf (mm/min) = n × fz × Z
• fz = avanço por dente (ver tabela por material/ferramenta)
• Z  = número de dentes da fresa

Exemplo: n=3185 RPM, fz=0,04 mm, Z=4 dentes:
Vf = 3185 × 0,04 × 4 = 510 mm/min → programar F500

💡 REGRA PRÁTICA: Comece com 70-80% do Vc teórico no primeiro teste.
''',
  ),

  DuvidaCNC(
    id: 'prog_003',
    pergunta: 'O que é G41 e G42? Para que servem?',
    categoria: 'Programação',
    tags: ['G41', 'G42', 'compensação', 'raio', 'ferramenta', 'CRC'],
    resposta: '''
🔧 G41 / G42 — Compensação de Raio de Ferramenta (CRC)

CONCEITO:
Ao programar um contorno, você programa o perfil da PEÇA.
G41/G42 faz o CNC deslocar a trajetória automaticamente pelo raio da fresa.

▸ G41 — Compensação à ESQUERDA do contorno
  Ferramenta fica à esquerda na direção do avanço.
  Usar para: contorno externo (sentido anti-horário) e fresamento concordante.

▸ G42 — Compensação à DIREITA do contorno
  Ferramenta fica à direita na direção do avanço.
  Usar para: contorno externo (sentido horário) e bolsões.

▸ G40 — CANCELA a compensação (obrigatório no fim)

COMO USAR:

; Ativa CRC — SEMPRE no movimento de aproximação, não no contorno
G41 D01 G01 X10. Y5. F300  ; D01 = registro do raio da fresa no offset

; Contorno da peça (não precisa somar o raio — o CNC faz sozinho)
G01 X80. Y5.
G01 X80. Y50.
G01 X10. Y50.
G01 X10. Y5.

; Cancela — SEMPRE no movimento de afastamento
G40 G01 X0. Y0.

⚠️ REGRAS IMPORTANTES:
• Ativar e cancelar SEMPRE em G01 (nunca em G00 ou G02/G03)
• O valor D (raio) deve estar cadastrado na tabela de offsets
• Nunca ativar sobre um ponto do próprio contorno

💡 SEM G41/G42: você teria que somar/subtrair o raio manualmente em cada ponto.
''',
  ),

  DuvidaCNC(
    id: 'prog_004',
    pergunta: 'Qual a diferença entre M98 e M99?',
    categoria: 'Programação',
    tags: ['M98', 'M99', 'subprograma', 'chamada', 'retorno'],
    resposta: '''
📋 M98 / M99 — Subprogramas

▸ M98 — CHAMA um subprograma
Sintaxe: M98 P[número] L[repetições]
• P = número do subprograma (ex: P1000 chama O1000)
• L = quantas vezes repetir (omitir = 1 vez)

▸ M99 — FIM do subprograma (retorna ao programa principal)
No subprograma, substitui o M30. Retorna para o bloco após o M98.

EXEMPLO:

; === PROGRAMA PRINCIPAL O0001 ===
M98 P5000 L3   ; Chama O5000 3 vezes
G00 X0. Y0.
M30

; === SUBPROGRAMA O5000 ===
G01 Z-10. F200
G01 X50.
G01 Z5.
G00 X0.
M99            ; Retorna ao principal

RESULTADO: o subprograma executa 3 vezes consecutivas antes do G00 X0. Y0.

USOS PRÁTICOS:
• Mesma operação em vários offsets (G54, G55, G56...)
• Padrão de furos repetidos
• Usinagem de múltiplas peças no mesmo fixture

💡 M99 com P[número]: volta para um bloco específico (não o seguinte ao M98).
''',
  ),

  DuvidaCNC(
    id: 'prog_005',
    pergunta: 'Como programar um ciclo de rosca no torno? G76',
    categoria: 'Torneamento',
    tags: ['G76', 'rosca', 'torno', 'ciclo', 'thread'],
    resposta: '''
🔩 G76 — Ciclo de Rosqueamento no Torno (Fanuc)

SINTAXE COMPLETA:
G76 P[m][r][a] Q[dmin] R[d]
G76 X[xfinal] Z[zfinal] R[i] P[k] Q[d1] F[L]

PARÂMETROS (1ª linha):
• m  = número de passadas de acabamento (01-99, ex: 02)
• r  = chanfro no fim da rosca × 0,1L (00-99, ex: 10 = 1× passo)
• a  = ângulo do flanco (60 para rosca métrica)
• Q dmin = profundidade mínima por passada em µm (ex: Q100 = 0,1mm)
• R d = sobremetal de acabamento em mm (ex: R0.05)

PARÂMETROS (2ª linha):
• X  = diâmetro final do fundo da rosca
• Z  = comprimento final da rosca
• R i = diferença de raio início/fim (0 para rosca cilíndrica)
• P k = altura do filete em µm (ex: P1299 = 1,299mm para M20)
• Q d1 = primeira profundidade de corte em µm (ex: Q300 = 0,3mm)
• F  = passo da rosca em mm (ex: F1.5 para M20×1.5)

EXEMPLO PRÁTICO — Rosca M20×1.5:
G97 S600 M03          ; RPM FIXO (não G96!) para rosca
G00 X22. Z5.          ; Posiciona
G76 P021060 Q100 R0.05
G76 X17.9 Z-40. R0. P975 Q300 F1.5
G00 X100. Z100.

ALTURA DO FILETE para roscas métricas = passo × 0,6495:
• M6×1.0  → P649
• M8×1.25 → P812
• M10×1.5 → P974
• M12×1.75 → P1137
• M16×2.0 → P1299
• M20×2.5 → P1624

⚠️ SEMPRE usar G97 (RPM fixo) para roscas — nunca G96.
''',
  ),

  DuvidaCNC(
    id: 'prog_006',
    pergunta: 'O que significa o número depois do G54? G54 G55 G56...',
    categoria: 'Programação',
    tags: ['G54', 'G55', 'G56', 'offset', 'zero', 'fixação', 'WCS'],
    resposta: '''
📍 G54 a G59 — Sistemas de Coordenadas de Trabalho (WCS)

CONCEITO:
Cada G54-G59 é um "zero peça" diferente, salvo na memória da máquina.
Permite usinar várias peças ou vários setups sem reprogramar o código CNC.

G54 → Zero peça 1 (mais usado — padrão)
G55 → Zero peça 2
G56 → Zero peça 3
G57 → Zero peça 4
G58 → Zero peça 5
G59 → Zero peça 6

COMO FUNCIONA:
1. Operador faz o setup, toca as superfícies de referência
2. Insere os valores X, Y, Z em G54 (ou G55, G56...)
3. O programa usa o G5X desejado — o CNC soma automaticamente o offset

EXEMPLO COM MÚLTIPLAS PEÇAS:
G54          ; Peça 1
M98 P1000    ; Usina peça 1
G55          ; Peça 2
M98 P1000    ; Mesmo programa, outra peça
G56          ; Peça 3
M98 P1000    ; Mesmo programa, outra peça

OFFSETS ESTENDIDOS (quando precisar de mais de 6):
• Fanuc: G54.1 P1 a P300
• Haas:  G54 P1 a P99

💡 DICA PRÁTICA: Sempre começar o programa com G54 explícito — nunca assumir
que o offset está ativo do programa anterior. Um G54 errado = peça errada.
''',
  ),

  DuvidaCNC(
    id: 'prog_007',
    pergunta: 'Como fazer um furo no centro de usinagem? G81 G83',
    categoria: 'Furação',
    tags: ['G81', 'G83', 'furo', 'furação', 'ciclo', 'peck', 'broca'],
    resposta: '''
🔩 CICLOS DE FURAÇÃO — G81 e G83

▸ G81 — Furação Simples (furo raso, até 3× diâmetro)
G81 X[x] Y[y] Z[profundidade] R[plano_segurança] F[avanço]

Exemplo — furo em X50 Y30, profundidade -20mm:
S1200 M03 M08
G81 X50. Y30. Z-20. R3. F150
G80          ; CANCELA o ciclo (obrigatório)
M30

▸ G83 — Furação Profunda com Peck (furo > 3× diâmetro)
G83 X[x] Y[y] Z[profundidade] R[segurança] Q[peck] F[avanço]
• Q = profundidade de cada incremento (peck) — broca retrai para limpar cavaco

Exemplo — furo profundo, broca Ø10 em aço, profundidade -60mm:
S900 M03 M08
G83 X50. Y30. Z-60. R3. Q5. F100
G80
M30

Regra do Q (peck): Q = 1/3 do diâmetro da broca
• Broca Ø10: Q=3.0 a 3.5
• Broca Ø8:  Q=2.5 a 3.0
• Broca Ø6:  Q=2.0 a 2.5

MÚLTIPLOS FUROS (ciclo fica ativo):
G83 X10. Y10. Z-40. R3. Q4. F100  ; Primeiro furo
X30. Y10.                          ; Segundo furo (mesmo Z, R, Q, F)
X50. Y10.                          ; Terceiro furo
X70. Y10.                          ; Quarto furo
G80                                ; Cancela

⚠️ NUNCA esquecer o G80 para cancelar o ciclo fixo.
''',
  ),

  DuvidaCNC(
    id: 'prog_008',
    pergunta: 'O que é G28? Como usar retorno ao zero máquina?',
    categoria: 'Programação',
    tags: ['G28', 'zero', 'máquina', 'home', 'referência', 'retorno'],
    resposta: '''
🏠 G28 — Retorno ao Zero Máquina (Home)

CONCEITO:
G28 move os eixos para o ponto de referência da máquina (zero máquina / home).
Obrigatório antes de trocar ferramenta (M06) em muitas máquinas.

SINTAXE:
G28 G91 Z0.    ; Retorna Z ao home (passando pelo ponto intermediário Z0 incremental)
G28 G91 X0. Y0. ; Retorna X e Y ao home

POR QUE G91 Z0.?
G91 = incremental. Z0. incremental significa "mova Z zero mm a partir de agora" →
o CNC entende como "vá direto ao home sem ponto intermediário".
É o modo mais seguro: retorna Z sem risco de colisão lateral.

SEQUÊNCIA PADRÃO DE TROCA DE FERRAMENTA:
G49           ; Cancela TLO (length offset)
G91 G28 Z0.   ; Retorna Z ao home
G28 X0. Y0.   ; Retorna XY ao home (se necessário)
T2 M06        ; Troca para ferramenta 2
G90 G54       ; Restaura modo absoluto e WCS
G43 H02 Z50.  ; Aplica TLO da nova ferramenta

⚠️ ATENÇÃO: G28 sem G91 usa ponto intermediário nas coordenadas absolutas programadas.
Exemplo: G28 X0. Y0. Z0. (absoluto) move para X=0 Y=0 Z=0 ANTES de ir ao home → risco de colisão.
Por isso: SEMPRE usar G28 G91 Z0. para segurança.

💡 G30: vai para o segundo ponto de referência (usado em tornos para troca de ferramenta).
''',
  ),

  DuvidaCNC(
    id: 'prog_009',
    pergunta: 'Como usar G43 e G49? O que é TLO?',
    categoria: 'Ferramentas',
    tags: ['G43', 'G49', 'TLO', 'comprimento', 'ferramenta', 'offset', 'H'],
    resposta: '''
📏 G43 / G49 — Offset de Comprimento de Ferramenta (TLO)

CONCEITO:
Cada ferramenta tem um comprimento diferente. O TLO é o valor salvo na máquina
que representa o comprimento real da ferramenta, medido no setup.

G43 H[n]  → ATIVA o offset da ferramenta n
G49       → CANCELA o offset (ferramenta "sem comprimento")

▸ G43 H01 → usa o offset positivo da tabela (ferramenta mais longa que a referência)
▸ G44 H01 → usa o offset negativo (raramente usado)

COMO FUNCIONA NA PRÁTICA:
1. No setup: operador mede o comprimento da ferramenta (ex: T1 = 120.345mm)
2. Insere esse valor na tabela: H01 = 120.345
3. No programa: G43 H01 → o CNC soma 120.345mm ao eixo Z automaticamente
4. Resultado: Z0 no programa = topo da peça, sem importar o comprimento da ferramenta

EXEMPLO COMPLETO:
T1 M06               ; Troca para fresa T1
G43 H01 Z50. F-      ; Ativa TLO da T1, posiciona em Z=50mm acima da peça
G54 G90              ; WCS e absoluto
S2000 M03
G00 X0. Y0.
G01 Z-5. F200        ; Fresa entra 5mm na peça (Z0 é o topo)
...
G49 G00 Z100.        ; Cancela TLO antes de trocar ferramenta

⚠️ Nunca trocar ferramenta sem cancelar G43 com G49 primeiro.
💡 Em muitas máquinas modernas, a troca M06 já cancela o G43 automaticamente.
''',
  ),

  DuvidaCNC(
    id: 'prog_010',
    pergunta: 'Como programar arcos e círculos? G02 G03',
    categoria: 'Programação',
    tags: ['G02', 'G03', 'arco', 'círculo', 'raio', 'I', 'J', 'R'],
    resposta: '''
⭕ G02 / G03 — Interpolação Circular

▸ G02 — Arco no sentido HORÁRIO (↻)
▸ G03 — Arco no sentido ANTI-HORÁRIO (↺)

DOIS MODOS DE PROGRAMAR:

MODO 1 — COM RAIO (R) — mais simples:
G02 X[xfinal] Y[yfinal] R[raio] F[avanço]
Arco < 180°: R positivo | Arco > 180°: R negativo

Exemplo (arco horário de R20, de X0 Y0 para X20 Y20):
G01 X0. Y0.
G02 X20. Y20. R20. F300

MODO 2 — COM I, J, K — mais preciso (centro do arco):
I = distância do PONTO ATUAL ao CENTRO em X
J = distância do PONTO ATUAL ao CENTRO em Y
K = distância do PONTO ATUAL ao CENTRO em Z (para arcos 3D)

Exemplo (mesmo arco, ponto atual X0 Y0, centro em X0 Y20):
I = 0 - 0 = 0
J = 20 - 0 = 20
G02 X20. Y20. I0. J20. F300

CÍRCULO COMPLETO (ponto final = ponto inicial):
G03 I25.   ; Círculo Ø50mm anti-horário (centro a 25mm em X)

DICA PARA ESCOLHER G02 ou G03:
Imagine que você está na ferramenta olhando para onde ela avança.
O arco curva para a direita? → G02. Para a esquerda? → G03.

⚠️ Certifique-se do plano ativo: G17=XY (padrão), G18=XZ (torno), G19=YZ
''',
  ),

  // ══════════════════════════════════════
  // TORNEAMENTO
  // ══════════════════════════════════════

  DuvidaCNC(
    id: 'torn_001',
    pergunta: 'Como programar G71 ciclo de desbaste no torno?',
    categoria: 'Torneamento',
    tags: ['G71', 'torno', 'desbaste', 'ciclo', 'perfil', 'P', 'Q'],
    resposta: '''
🔄 G71 — Ciclo de Desbaste de Perfil (Torno Fanuc)

SINTAXE (2 linhas obrigatórias):
G71 U[ap] R[recuo]
G71 P[início] Q[fim] U[sobremetal_X] W[sobremetal_Z] F[avanço]

PARÂMETROS:
• U (1ª linha) = profundidade de cada passada (ap) em mm
• R = recuo entre passadas em mm (0.5 a 1.0mm)
• P = número do primeiro bloco do perfil de acabamento
• Q = número do último bloco do perfil
• U (2ª linha) = sobremetal em X para o acabamento (diâmetro)
• W = sobremetal em Z para o acabamento
• F = avanço de desbaste em mm/rot

EXEMPLO COMPLETO:
T0101
G96 S180 M03       ; CSS 180 m/min
G50 S2500          ; RPM máximo
G00 X55. Z2.       ; Posiciona fora da peça

; CICLO DE DESBASTE
G71 U2.0 R0.5                    ; 2mm por passada, recuo 0.5mm
G71 P10 Q80 U0.4 W0.1 F0.25     ; Perfil entre N10 e N80, sobremetal 0.4mm/0.1mm

; CICLO DE ACABAMENTO (remove o sobremetal)
G70 P10 Q80

; PERFIL DE ACABAMENTO (entre N10 e N80)
N10 G00 X20.         ; Diâmetro inicial (ponta)
G01 Z0. F0.12        ; Toca a face
G01 X30. Z-5.        ; Chanfro ou cone
G01 Z-40.            ; Cilindro Ø30
G01 X45. Z-60.       ; Cone Ø30→Ø45
G01 Z-80.            ; Cilindro Ø45
N80 G01 X55.         ; Sai do diâmetro da peça

G00 X100. Z100.
M30

💡 O G70 executa apenas o perfil P10-Q80 uma vez com parâmetros de acabamento.
''',
  ),

  DuvidaCNC(
    id: 'torn_002',
    pergunta: 'O que é G96 e G50 no torno? CSS',
    categoria: 'Torneamento',
    tags: ['G96', 'G50', 'CSS', 'velocidade', 'constante', 'RPM', 'torno'],
    resposta: '''
⚡ G96 / G97 / G50 — Velocidade de Corte no Torno

▸ G96 S[m/min] — CSS (Velocidade de Corte Constante)
O CNC varia o RPM automaticamente conforme o diâmetro muda.
Resultado: acabamento superficial uniforme em toda a peça.
Usar em: torneamento de perfis, faceamento.

▸ G97 S[RPM] — RPM FIXO
Rotação constante, independente do diâmetro.
Usar SEMPRE em: roscas (G32, G76, G92) — sincronismo com encoder.

▸ G50 S[RPM_max] — LIMITA o RPM máximo com G96
OBRIGATÓRIO quando usar G96!
Sem G50: ao se aproximar do centro (X→0), o RPM subiria ao infinito → PERIGO.

EXEMPLO CORRETO:
G96 S200 M03    ; CSS: mantém 200 m/min
G50 S3000       ; Máximo 3000 RPM (segurança ao faceamento X→0)
G01 X0. Z0. F0.15   ; Faceamento — RPM sobe automaticamente

; Para rosca: obrigatório G97
G97 S500 M03    ; 500 RPM fixos
G76 P021060 Q100 R0.05
G76 X17.9 Z-40. R0. P974 Q300 F1.5

FÓRMULA MANUAL (quando precisar calcular):
RPM = (Vc × 1000) / (π × Ø)
Vc=200, Ø=50mm: RPM = (200×1000)/(3,14×50) = 1274 RPM

💡 Com G96 ativo, você programa em m/min e a máquina calcula o RPM sozinha.
''',
  ),

  DuvidaCNC(
    id: 'torn_003',
    pergunta: 'Como programar rosca no torno sem ciclo? G32',
    categoria: 'Torneamento',
    tags: ['G32', 'rosca', 'torno', 'passo', 'thread'],
    resposta: '''
🔩 G32 — Rosqueamento Linear Simples (Torno)

CONCEITO: G32 corta rosca em UMA passada. Para roscas completas usa-se múltiplas
passadas com profundidade crescente. Alternativa ao G76 (que é automático).

SINTAXE:
G32 Z[posição] F[passo]   ; F = passo da rosca em mm

EXEMPLO — Rosca M30×3.5 (desbaste + acabamento manual):
G97 S400 M03      ; RPM FIXO — fundamental para rosca
G00 X31. Z5.      ; Posiciona fora da rosca (X > diâmetro nominal)

; === PASSADAS DE DESBASTE ===
G00 X29.4         ; 1ª passada: ap = 0.3mm
G32 Z-45. F3.5   ; Corta rosca com passo 3.5mm
G00 X32.          ; Sai em X rapidamente
G00 Z5.           ; Retorna em Z

G00 X28.9         ; 2ª passada
G32 Z-45. F3.5
G00 X32.
G00 Z5.

G00 X28.5         ; 3ª passada
G32 Z-45. F3.5
G00 X32.
G00 Z5.

; === PASSADA DE ACABAMENTO ===
G00 X28.35        ; Diâmetro final M30 = 28.35mm aprox.
G32 Z-45. F3.5
G00 X32. Z100.
M30

💡 PREFERIR G76 (automático) — G32 é usado quando precisa de controle total
de cada passada (roscas de perfil especial, passo variável com Macro B).
''',
  ),

  // ══════════════════════════════════════
  // ALARMES E DIAGNÓSTICO
  // ══════════════════════════════════════

  DuvidaCNC(
    id: 'alarm_001',
    pergunta: 'Alarme 410 Fanuc — o que é servo alarm? Como resolver?',
    categoria: 'Alarmes',
    tags: ['410', 'servo', 'alarm', 'fanuc', 'eixo', 'motor'],
    resposta: '''
🚨 ALARME 410 FANUC — Servo Alarm (Detection Error Excess)

SIGNIFICADO:
O eixo se moveu mais do que o esperado — diferença entre posição real e programada
ultrapassou o limite (detection error excess).

CAUSAS MAIS PROVÁVEIS:
1. Sobrecarga mecânica — colisão ou carga excessiva no eixo
2. Encoder danificado ou cabo do encoder com problema
3. Parâmetro de limite de erro muito pequeno (parâmetro 1828)
4. Correia ou acoplamento partido — motor gira mas eixo não move
5. Guias travadas ou com folga excessiva

COMO RESOLVER (passo a passo):
1. Desligar e religar a máquina — testa se é falha momentânea
2. Verificar se há dano físico visível na máquina (colisão, objeto preso)
3. Mover o eixo manualmente no modo JOG — verifica se está livre
4. Verificar cabo do encoder no motor (pode estar mal encaixado)
5. Checar temperatura do driver servo (gabinete elétrico) — superaquecimento
6. Verificar parâmetro 1828 (distância de erro máxima) — aumentar com cuidado
7. Monitorar a carga no servo com diagnóstico — se > 80%, problema mecânico

⚠️ ATENÇÃO: Nunca aumentar parâmetro 1828 sem investigar a causa real.
Esse parâmetro é uma proteção — aumentá-lo mascara o problema.

Chamar técnico de manutenção se: cabo do encoder danificado, driver com falha interna.
''',
  ),

  DuvidaCNC(
    id: 'alarm_002',
    pergunta: 'Alarme 300 Fanuc — APC Alarm. O que fazer?',
    categoria: 'Alarmes',
    tags: ['300', 'APC', 'bateria', 'alarme', 'fanuc', 'memória'],
    resposta: '''
🔋 ALARME 300 FANUC — APC (Absolute Pulse Coder) Alarm

SIGNIFICADO:
Alarme de bateria do encoder absoluto. A bateria que mantém a posição absoluta
dos eixos quando a máquina está desligada está fraca ou descarregada.

CAUSAS:
• Bateria descarregada (vida útil: 2-3 anos)
• Máquina ficou desligada por muito tempo sem a bateria ser trocada
• Conector da bateria desconectado

COMO RESOLVER:
1. COM A MÁQUINA LIGADA, trocar a bateria (importante: não desligar antes)
   • Bateria padrão Fanuc: Li-Ion 3V modelo A98L-0031-0012
   • Localização: geralmente no painel do operador ou na caixa do encoder

2. Fazer o ZEROING (referência de eixo):
   • Após troca, a máquina perde a posição absoluta
   • Ir ao modo REF (Reference / ZRN)
   • Mover cada eixo até o zero máquina (home)

3. Verificar se alarme 300 some — se persistir, bateria pode estar conectada errada

⚠️ NÃO desligar a máquina antes de trocar a bateria:
Se desligar sem trocar, o encoder perde completamente a posição e precisará de
re-calibração completa (mais demorada).

💡 Trocar a bateria preventivamente a cada 2 anos, mesmo sem alarme.
''',
  ),

  DuvidaCNC(
    id: 'alarm_003',
    pergunta: 'Alarm 445 Fanuc — overtravel. O que fazer?',
    categoria: 'Alarmes',
    tags: ['445', 'overtravel', 'limite', 'eixo', 'fanuc', 'soft limit'],
    resposta: '''
⛔ ALARME 445/OT FANUC — Over Travel (Limite de Eixo)

SIGNIFICADO:
O eixo ultrapassou o limite de curso programado (soft limit) ou tocou o limite
físico de hardware (chave fim-de-curso).

TIPOS:
• 500/501: Soft limit (limite por parâmetro)
• 506/507: Hard OT (chave fim-de-curso física acionada)

COMO RESOLVER:

Para SOFT LIMIT (alarme 500/501):
1. Anotar em qual eixo (X, Y, Z) e sentido (+ ou -)
2. No painel: selecionar modo MDI
3. Digitar: G91 G00 [eixo] [movimento na direção contrária]
   Exemplo: G91 G00 Z10. (move Z 10mm para cima)
4. Executar (CYCLE START)
5. O eixo deve se libertar do limite

Para HARD OT (fim-de-curso físico):
1. Modo manual (JOG ou HANDLE)
2. Segurar override de eixo e mover manualmente no sentido CONTRÁRIO ao alarme
3. Atenção: a função de override de OT deve estar habilitada no painel

⚠️ CAUSAS DO OVERTRAVEL:
• Erro no programa: movimento maior que o curso da máquina
• Zero peça configurado fora da área de trabalho
• Parâmetros de soft limit incorretos (parâmetro 1320/1321)

💡 Verificar o programa: sempre simular com DRY RUN antes de usinar peça.
''',
  ),

  // ══════════════════════════════════════
  // SETUP E OPERAÇÃO
  // ══════════════════════════════════════

  DuvidaCNC(
    id: 'setup_001',
    pergunta: 'Como fazer o zero peça? Como setar o G54?',
    categoria: 'Setup',
    tags: ['zero', 'peça', 'G54', 'setup', 'apalpador', 'offset', 'zerar'],
    resposta: '''
🎯 COMO FAZER O ZERO PEÇA (Setar G54)

MÉTODO 1 — COM APALPADOR (mais preciso):
1. Monte o apalpador na árvore (ex: Renishaw)
2. Posicione a ferramenta tocando a superfície de referência
3. Pressione o botão de medição — a máquina salva automaticamente
4. Verificar em: OFFSET → WORK (G54)

MÉTODO 2 — COM BORDAS DE FURO (método manual):
Centro de usinagem:
1. Monte um localizador de borda (edge finder) Ø10mm
2. Toque a face X- da peça: anote X atual. Somar metade do Ø do localizador
   Ex: toca em X=-100.000, localizador Ø10: X real = -100.000 + 5.0 = -95.000
3. Toque a face X+ da peça: calcule o centro (se for centralizar em X)
4. Repita para Y
5. Para Z: toque a superfície superior com ferramenta ou calibre
6. Digite os valores em OFFSET → WORK → G54

MÉTODO 3 — TORNO (zero em Z):
1. Tornear a face da peça com passada leve
2. Sem mover Z, ir em OFFSET SETTING → WORK → G54 → Z → digitar 0 → MEASURE
3. Para X: tornear um diâmetro, medir com paquímetro, digitar valor medido → MEASURE

VERIFICAÇÃO (fundamental):
Após setar, programar:
G54 G90 G00 X0. Y0.   ; Deve ir para o zero peça visual
G00 Z5.                ; Z5 deve ser 5mm acima da peça

⚠️ Sempre verificar VISUALMENTE antes de ligar o spindle.
''',
  ),

  DuvidaCNC(
    id: 'setup_002',
    pergunta: 'Como medir e setar o comprimento da ferramenta? H offset',
    categoria: 'Setup',
    tags: ['TLO', 'comprimento', 'ferramenta', 'H', 'offset', 'medir', 'setup'],
    resposta: '''
📏 COMO SETAR O COMPRIMENTO DA FERRAMENTA (H Offset)

MÉTODO 1 — COM SENSOR DE MEDIÇÃO (automático):
1. Montar a ferramenta no spindle
2. Chamar o ciclo de medição automática (ex: G37 em alguns controles)
3. A ferramenta desce e toca o sensor — valor salvo automaticamente

MÉTODO 2 — TOQUE MANUAL COM FOLHA DE PAPEL:
1. Colocar uma folha de papel (0.1mm) sobre a superfície da peça
2. Usar JOG para descer a ferramenta até SENTIR resistência ao mover o papel
3. Ir em OFFSET → GEOMETRY → H[n] → digitar Z atual → INPUT
   (Ou usar o botão C.INPUT/MEASURE dependendo do controle)

MÉTODO 3 — REFERÊNCIA PELA PRIMEIRA FERRAMENTA:
1. T1 (ferramenta de referência) → H1 = 0
2. Para cada ferramenta seguinte, calcular diferença de comprimento
3. Ferramenta mais longa: valor positivo. Mais curta: valor negativo.

DOIS TIPOS DE OFFSET (verificar no manual da máquina):
• GEOMETRY (H): comprimento absoluto da ferramenta
• WEAR (D): compensação de desgaste — ajuste fino sem mudar o H

VERIFICAÇÃO NO PROGRAMA:
T1 M06
G43 H01 Z100.   ; Deve posicionar Z a 100mm acima da peça programada

⚠️ Sempre verificar com Z alto (ex: Z50) antes de descer para usinagem.
''',
  ),

  DuvidaCNC(
    id: 'setup_003',
    pergunta: 'Qual a diferença entre offset de geometria e desgaste?',
    categoria: 'Setup',
    tags: ['geometry', 'wear', 'offset', 'desgaste', 'geometria', 'compensação'],
    resposta: '''
🔧 GEOMETRY vs WEAR OFFSET — Diferença

▸ GEOMETRY OFFSET (Comprimento / Raio):
• Valor real do comprimento ou raio da ferramenta
• Medido no setup, antes de usinar
• Muda raramente — só quando a ferramenta é trocada
• Para comprimento: G43 H[n] usa este valor
• Para raio: usado pelo G41/G42

▸ WEAR OFFSET (Desgaste):
• Ajuste FINO que se soma ao geometry
• Usado para corrigir dimensões durante a produção
• Não apaga o geometry — é um delta (diferença)
• Operador ajusta sem mexer no valor base

EXEMPLO PRÁTICO:
Geometry H01 = 150.345 (comprimento real)
Wear H01 = -0.020 (ajuste: ferramenta desgastou 0.02mm)
TLO efetivo = 150.345 - 0.020 = 150.325mm

QUANDO USAR WEAR:
• Diâmetro da peça ficou 0.05mm maior que o nominal
• Ao invés de mudar o geometry, adiciona wear D = -0.025 (raio)
• Resultado: fresa entra 0.025mm a mais → diâmetro correto

💡 REGRA PRÁTICA:
Geometry → mexer só no setup ou troca de ferramenta
Wear     → mexer durante a produção para ajuste dimensional

⚠️ Em alguns controles (Siemens, Okuma): chamado de "base" e "fine adjustment".
''',
  ),

  // ══════════════════════════════════════
  // MATERIAIS E FERRAMENTAS
  // ══════════════════════════════════════

  DuvidaCNC(
    id: 'mat_001',
    pergunta: 'Por que a ferramenta quebra rápido no inox?',
    categoria: 'Materiais',
    tags: ['inox', 'ferramenta', 'quebra', 'desgaste', 'aço inox', '304', '316'],
    resposta: '''
⚡ INOX — Por Que a Ferramenta Quebra Rápido

PROBLEMA PRINCIPAL — Encruamento (Work Hardening):
O inox austenítco (304, 316) endurece quando trabalhado plasticamente.
Se a ferramenta para ou hesita durante o corte → encruamento → ferramenta enfrenta
material muito mais duro que o original → quebra.

CAUSAS COMUNS DE QUEBRA:
1. Ferramenta parou no material (M01, pausa, avanço zero)
2. Velocidade de corte alta demais → temperatura → adesão (BUE)
3. Pastilha muito desgastada → atrito > corte → calor excessivo
4. Sem refrigeração ou refrigeração insuficiente
5. ap ou ae muito grandes → deflexão → vibração → quebra

SOLUÇÕES PRÁTICAS:

✅ NUNCA parar a ferramenta dentro do inox — saída rápida obrigatória
✅ Usar Vc BAIXA (50-80 m/min para fresa MD) — menos calor
✅ fz adequado — não muito pequeno (rubbing = esquenta sem cortar)
✅ Refrigeração ABUNDANTE e contínua — óleo integral melhor que emulsão
✅ Ferramenta nova ou afiada — pastilha cega agrava o encruamento
✅ Revestimento AlTiN ou AlCrN — resistem à temperatura
✅ Em fresamento: ae = 5-10% do Ø (trocóide/HSM) — menos calor por passe

💡 TEMPERATURA é o inimigo #1 no inox.
Vc baixa + avanço correto + refrigeração = vida longa de ferramenta.
''',
  ),

  DuvidaCNC(
    id: 'mat_002',
    pergunta: 'Como calcular o furo correto para um macho M8?',
    categoria: 'Ferramentas',
    tags: ['macho', 'furo', 'pré-furo', 'rosca', 'M8', 'broca', 'cálculo'],
    resposta: '''
🔩 CÁLCULO DO PRÉ-FURO PARA MACHOS

FÓRMULA:
Ø pré-furo = Ø nominal - passo

TABELA COMPLETA (roscas métricas padrão):

Rosca    | Passo | Pré-furo | Profundidade mínima
---------|-------|----------|--------------------
M3×0.5   | 0.5   | Ø 2.5mm  | rosca + 3mm
M4×0.7   | 0.7   | Ø 3.3mm  | rosca + 3mm
M5×0.8   | 0.8   | Ø 4.2mm  | rosca + 4mm
M6×1.0   | 1.0   | Ø 5.0mm  | rosca + 4mm
M8×1.25  | 1.25  | Ø 6.75mm | rosca + 5mm
M10×1.5  | 1.5   | Ø 8.5mm  | rosca + 5mm
M12×1.75 | 1.75  | Ø 10.2mm | rosca + 6mm
M14×2.0  | 2.0   | Ø 12.0mm | rosca + 7mm
M16×2.0  | 2.0   | Ø 14.0mm | rosca + 7mm
M20×2.5  | 2.5   | Ø 17.5mm | rosca + 8mm
M24×3.0  | 3.0   | Ø 21.0mm | rosca + 10mm

PARA M8 ESPECIFICAMENTE:
• Pré-furo: Ø 6.75mm
• Para rosca passante: furar completamente
• Para rosca cega: pré-furo = profundidade da rosca + 3-5mm de folga

💡 DICA: O pré-furo deve ser 2-3mm mais fundo que a rosca desejada.
O cone da broca ocupa espaço no fundo — a rosca não entra até o fundo.

Para rosca M8 de 20mm de profundidade:
Pré-furo Ø6.75mm com 25mm de profundidade.
''',
  ),

  DuvidaCNC(
    id: 'mat_003',
    pergunta: 'O que significa pastilha CNMG, DNMG, VCGT?',
    categoria: 'Ferramentas',
    tags: ['pastilha', 'CNMG', 'DNMG', 'VCGT', 'ISO', 'inserto', 'código'],
    resposta: '''
🔧 CÓDIGO ISO DE PASTILHAS DE TORNEAMENTO

ESTRUTURA: ex. C N M G 12 04 08

① FORMA (1ª letra):
C = Losango 80° (uso geral, resistente)
D = Losango 55° (perfis complexos, frágil)
S = Quadrada 90° (muito resistente, desbaste)
T = Triangular 60° (versátil)
V = Losango 35° (perfis internos, muito frágil)
W = Hexagonal 80° (robusto)

② FOLGA DO FLANCO (2ª letra):
N = 0° (sem folga — usa suporte)
A = 3° | B = 5° | C = 7° | P = 11°

③ TOLERÂNCIA (3ª letra):
M = ±0.08mm (padrão)
G = ±0.025mm (precisão)
U = ±0.13mm (econômica)

④ TIPO DE QUEBRA-CAVACO (4ª letra):
G = com furo + quebra-cavaco lateral
N = sem furo (solda ou pressão)
M = com furo duplo + quebra-cavaco

⑤⑥ COMPRIMENTO do gume (12 = 12mm)
⑦⑧ ESPESSURA (04 = 4mm)
⑨⑩ RAIO DE PONTA (08 = 0.8mm)

GUIA RÁPIDO DE SELEÇÃO:
CNMG → Desbaste externo geral (aço, inox)
DCMT → Acabamento fino, perfis
VCGT → Alumínio (ângulo positivo)
WNMG → Desbaste pesado, ferro fundido
DNMG → Contornos complexos, bicos finos

💡 CNMG 12 04 08 = o "rei" do torneamento de aço.
''',
  ),

  // ══════════════════════════════════════
  // QUALIDADE E MEDIÇÃO
  // ══════════════════════════════════════

  DuvidaCNC(
    id: 'qual_001',
    pergunta: 'O que significa tolerância H7/h6? Como usinar?',
    categoria: 'Qualidade',
    tags: ['H7', 'h6', 'tolerância', 'ISO', 'ajuste', 'furo', 'eixo'],
    resposta: '''
📏 TOLERÂNCIA H7/h6 — Sistema ISO 286

LEITURA: Ø30 H7/h6
• 30 = diâmetro nominal em mm
• H7 = tolerância do FURO (maiúscula = furo)
• h6 = tolerância do EIXO (minúscula = eixo)

PARA Ø30 H7/h6:
Furo H7:  30.000 a 30.021mm (sempre começa no nominal, sobe +21µm)
Eixo h6:  29.987 a 30.000mm (sempre termina no nominal, desce -13µm)
Folga resultante: 0 a 34µm → AJUSTE DESLIZANTE FINO

COMO USINAR O FURO H7:
1. Fresar ou tornear com sobremetal (ex: Ø29.7mm)
2. Mandrilar para Ø29.9mm
3. Alargador H7 Ø30mm → resultado: 30.000 a 30.021mm ✅
   OU Mandrilamento de precisão com passe fino

COMO USINAR O EIXO h6:
1. Tornear com sobremetal (ex: Ø30.3mm)
2. Retificar cilíndrica para Ø30.000 a 29.987mm ✅
   OU Torneamento de acabamento com pastilha NOVA e parâmetros finos

VALORES PARA OUTROS DIÂMETROS H7:
Ø10 H7: +0/+0.015mm
Ø20 H7: +0/+0.021mm
Ø30 H7: +0/+0.021mm
Ø50 H7: +0/+0.025mm

💡 H7 é o ajuste mais pedido em projetos — alojamentos de rolamentos,
pinos de precisão, fusos lineares.
''',
  ),

  DuvidaCNC(
    id: 'qual_002',
    pergunta: 'Como melhorar o acabamento superficial Ra? A peça saiu rugosa.',
    categoria: 'Qualidade',
    tags: ['Ra', 'rugosidade', 'acabamento', 'superfície', 'rugoso', 'polimento'],
    resposta: '''
✨ MELHORAR ACABAMENTO SUPERFICIAL — Diagnóstico e Solução

Ra TÍPICO POR PROCESSO:
• Torneamento bruto:    Ra 6.3–12.5µm
• Torneamento fino:     Ra 0.8–3.2µm
• Fresamento normal:    Ra 1.6–3.2µm
• Fresamento fino:      Ra 0.4–1.6µm
• Retificação:          Ra 0.2–0.8µm

CAUSAS DE ACABAMENTO RUIM (e soluções):

1. VIBRAÇÃO (chatter) → superfície ondulada:
   ✅ Reduzir ap e ae | Aumentar Vc | Usar fresa com menos dentes
   ✅ Verificar fixação da peça | Reduzir balanço da ferramenta

2. AVANÇO MUITO ALTO → marcas visíveis de avanço:
   ✅ Reduzir fz (avanço por dente) | Usar raio de ponta maior (RE ≥ 0.8mm)
   Fórmula Ra teórico no torno: Ra ≈ (f²) / (8 × RE)

3. FERRAMENTA DESGASTADA → arrancha e vibra:
   ✅ Trocar pastilha/fresa antes do acabamento

4. VELOCIDADE BAIXA → BUE (aresta postiça):
   ✅ Aumentar Vc | Usar pastilha com PVD (TiAlN)

5. SEM REFRIGERAÇÃO adequada:
   ✅ Aumentar refrigeração | Óleo integral para metais não ferrosos

PARÂMETROS PARA ACABAMENTO FINO (torneamento):
• Vc: alta (G96 S250+ para aço)
• f: baixo (0.05–0.10 mm/rot)
• ap: mínimo (0.1–0.3mm)
• RE: ≥ 0.8mm

💡 Para Ra < 0.8µm em torno: pastilha nova + alta Vc + baixo avanço + refrigeração.
''',
  ),

  // ══════════════════════════════════════
  // PROBLEMAS COMUNS
  // ══════════════════════════════════════

  DuvidaCNC(
    id: 'prob_001',
    pergunta: 'A peça saiu com medida errada, fora do tolerância. O que verificar?',
    categoria: 'Problemas',
    tags: ['medida', 'dimensão', 'tolerância', 'erro', 'offset', 'ajuste'],
    resposta: '''
🔍 PEÇA FORA DE TOLERÂNCIA — Diagnóstico Sistemático

PASSO 1 — IDENTIFICAR O TIPO DE ERRO:
• Erro em X/Y? → Problema de raio/offset/compensação
• Erro em Z? → Problema de comprimento de ferramenta ou zero Z
• Erro em todos? → Zero peça (G54) errado
• Erro só em uma posição? → Problema de posicionamento

PASSO 2 — VERIFICAR OS OFFSETS:
• G54 (zero peça): verificar X, Y, Z
• H (TLO): comprimento da ferramenta correto?
• D (raio): raio cadastrado correto? Desgaste acumulado?
• Wear offset: acumulado de ajustes anteriores?

PASSO 3 — VERIFICAR A MÁQUINA:
• Backlash (folga de retorno) no eixo afetado
• Temperatura: máquina quente faz diferença de 0.02-0.05mm
• Fixação da peça: peça se moveu durante usinagem?

PASSO 4 — VERIFICAR O PROGRAMA:
• Tolerância G01 vs G00 (parada exata G09/G61?)
• Compensação G41/G42: valor do raio correto?
• Deflexão de ferramenta: fresa comprida flex

AJUSTE RÁPIDO PELO WEAR OFFSET:
Peça ficou 0.06mm maior em diâmetro (X):
→ Wear D[n] = D atual - 0.03 (raio = metade do diâmetro)

💡 REGRA: medir 3 peças consecutivas. Se o erro é constante = offset.
Se o erro varia = vibração, folga ou fixação.
''',
  ),

  DuvidaCNC(
    id: 'prob_002',
    pergunta: 'A fresa está quebrando. Como diagnosticar?',
    categoria: 'Problemas',
    tags: ['fresa', 'quebra', 'ferramenta', 'parâmetros', 'diagnóstico'],
    resposta: '''
🔧 FRESA QUEBRANDO — Diagnóstico e Solução

ANALISE O MOMENTO DA QUEBRA:

1. QUEBRA NA ENTRADA (mergulho/rampa):
   ✅ Reduzir avanço de mergulho (F de ramp)
   ✅ Usar rampa helicoidal ao invés de mergulho direto
   ✅ Ângulo de rampa: máx 3° para fresas padrão

2. QUEBRA NO FRESAMENTO PLENO (ae = 100%):
   ✅ Nunca usar ae = 100% em aço/inox
   ✅ ae máximo: 50% do Ø (início de corte), depois reduzir
   ✅ Usar trocóide: ae = 5-10% do Ø, fz maior

3. QUEBRA EM CANTOS/QUINAS:
   ✅ Reduzir F 50% na entrada no canto (F de canto)
   ✅ Usar arco de entrada no canto (G02/G03 pequeno)

4. QUEBRA POR VIBRAÇÃO (chatter):
   ✅ Reduzir ap/ae | Mudar RPM (tentar +20% ou -20%)
   ✅ Usar fresa com diferente número de dentes
   ✅ Reduzir balanço (saída da fresa)

5. QUEBRA POR CAVACO PRESO NO BOLSÃO:
   ✅ Aumentar refrigeração (ar comprimido + óleo)
   ✅ Em alumínio: fresa 2-3 dentes (espaço para cavaco)
   ✅ G83 (peck) em rebaixos profundos

PARÂMETROS DE EMERGÊNCIA (reduzir tudo 50%):
Se a fresa continua quebrando com parâmetros normais:
→ Vc -30%, fz -20%, ap -50%, ae -50%
Se funcionar, aumentar gradualmente até encontrar o limite.
''',
  ),

  DuvidaCNC(
    id: 'prob_003',
    pergunta: 'O programa não roda. Aparece alarme PS0010 / syntax error.',
    categoria: 'Problemas',
    tags: ['PS0010', 'syntax', 'erro', 'programa', 'CNC', 'edição'],
    resposta: '''
💻 ALARME PS0010 FANUC — Syntax Error (Erro de Sintaxe)

SIGNIFICADO:
O controle encontrou um código G, M ou endereço que não reconhece ou
está mal formatado no bloco indicado.

CAUSAS COMUNS:

1. CÓDIGO G INVÁLIDO para esta máquina:
   Ex: G12.1 (torno com eixo C) em máquina sem esse eixo
   ✅ Verificar se o código existe neste controle específico

2. PARÂMETRO OBRIGATÓRIO FALTANDO:
   Ex: G81 Z-20. F200 (sem R → alarme)
   ✅ Adicionar R: G81 Z-20. R3. F200

3. ENDEREÇO REPETIDO NO MESMO BLOCO:
   Ex: G00 G01 X50. (dois modais de movimento no mesmo bloco)
   ✅ Separar em blocos diferentes

4. CARACTERES INVÁLIDOS:
   Letras fora do alfabeto CNC, acentos, ç, espaços extras
   ✅ Verificar se o arquivo tem caracteres especiais do português

5. NÚMERO DE PROGRAMA DUPLICADO:
   Dois programas com o mesmo O-number na memória
   ✅ Verificar e renomear um deles

6. FALTA DE PONTO DECIMAL:
   Ex: G01 X50 (correto: G01 X50.)
   ✅ Sempre usar ponto decimal em coordenadas

COMO ENCONTRAR O ERRO:
• O controle indica o número do bloco — ir direto a ele
• Verificar o bloco anterior (pode ser erro de continuação)
• Usar DNC para transmitir e verificar no computador

💡 Sempre verificar o programa com simulação/DRY RUN antes de usinar.
''',
  ),

  DuvidaCNC(
    id: 'prob_004',
    pergunta: 'Como evitar colisão na máquina CNC?',
    categoria: 'Segurança',
    tags: ['colisão', 'segurança', 'DRY RUN', 'simulação', 'checklist'],
    resposta: '''
⚠️ PREVENÇÃO DE COLISÕES NA CNC — Checklist Completo

ANTES DE APERTAR CYCLE START:

✅ CHECKLIST PRÉ-START:
□ Zero peça (G54) confirmado visualmente
□ Comprimentos de ferramenta verificados (H offsets)
□ Raios de ferramenta corretos (D offsets)
□ Ferramenta certa montada (T1=fresa, T2=broca...)
□ Peça fixada corretamente (apertos verificados)
□ Área de trabalho limpa (sem ferramentas apoiadas na mesa)
□ Porta da máquina fechada

PROCEDIMENTO PADRÃO PARA PROGRAMA NOVO:
1. DRY RUN (sem peça): rodar o programa com F muito baixo sem material
2. SINGLE BLOCK: executar bloco a bloco no primeiro uso
3. FEED OVERRIDE a 0%: avançar manualmente controlando a velocidade
4. OPTIONAL STOP (M01): pausar em pontos críticos para verificação

PONTOS CRÍTICOS NO PROGRAMA:
• Troca de ferramenta: Z deve estar alto (G28 G91 Z0.)
• Primeira descida: G43 H[n] + Z alto antes de ir para XY
• Entrada em material: confirmar Z antes de F
• Cantos internos: velocidade reduz automaticamente?

APÓS COLISÃO:
1. PARAR IMEDIATAMENTE (E-STOP)
2. Não tentar "desfazer" manualmente sem verificar
3. Verificar eixos (geométrico): medir com comparador
4. Verificar ferramentas e porta-ferramentas
5. Chamar manutenção se houver impacto severo

💡 1 colisão = horas de downtime + custo de reparo.
5 minutos de checklist evita 5 horas de problema.
''',
  ),

  // ── ALARMES FANUC ADICIONAIS ─────────────────────────────
  DuvidaCNC(
    id: 'alm_fanuc_090',
    categoria: 'Alarmes',
    pergunta: 'Alarme 090 Fanuc — Reference Return Not Completed',
    tags: ['alarme 090', '090', 'reference return', 'zero return', 'referência'],
    resposta: '''
🚨 ALARME 090 FANUC — REFERENCE RETURN NOT COMPLETED

📋 SIGNIFICADO:
A máquina não completou o retorno ao ponto de referência (Home/Zero Machine).
Nenhuma operação de movimento automático é permitida até resolver.

🔍 CAUSAS MAIS PROVÁVEIS:
1. Máquina ligada sem executar o Zero Return (G28)
2. Tentativa de rodar programa antes do Home
3. Perda de posição após queda de energia
4. Encoder com problema (em alguns casos)

🔧 COMO RESOLVER:
1. Ir para modo JOG ou HANDLE (manivela)
2. Mover eixos para longe dos fins de curso
3. Selecionar modo REF (Reference Return)
4. Pressionar cada eixo na direção indicada (+X, +Y, +Z)
5. Aguardar LED de referência acender para cada eixo
6. Confirmar no painel que referência está completa

⚠️ ATENÇÃO:
• Sempre referenciar Z antes de X e Y
• Nunca correr para a referência em alta velocidade (use avanço reduzido)
• Se o problema persistir após referenciar: verificar encoder

💡 DICA: Crie uma rotina de macro para executar o Zero Return automaticamente ao ligar.
''',
  ),

  DuvidaCNC(
    id: 'alm_fanuc_414',
    categoria: 'Alarmes',
    pergunta: 'Alarme 414 Fanuc — Servo Alarm eixo X/Y/Z',
    tags: ['alarme 414', '414', 'servo alarm', 'servo', 'eixo travado'],
    resposta: '''
🚨 ALARME 414 FANUC — SERVO ALARM (ERRO DE SEGUIMENTO DE EIXO)

📋 SIGNIFICADO:
O eixo não conseguiu seguir o comando de movimento. A diferença entre posição comandada e real (erro de seguimento) ultrapassou o limite.

🔍 CAUSAS:
1. Carga excessiva no eixo (peça pesada, colisão)
2. Prendimento mecânico (guias sujas, travamento)
3. Falha no motor servo ou driver
4. Cabo de encoder danificado
5. Parâmetro de seguimento muito restritivo (1828)

🔧 RESOLUÇÃO PASSO A PASSO:
1. Resetar o alarme
2. Mover o eixo manualmente em JOG — está travado?
3. Verificar lubrificação das guias
4. Reduzir velocidade de avanço e testar
5. Se persistir: verificar driver servo (LEDs de status)
6. Checar parâmetro 1828 (limite erro de seguimento)

⚠️ NÃO FORÇAR o eixo manualmente sem desligar o servo.

💡 PARÂMETROS RELACIONADOS:
• 1828: In-position width (tolerância de posicionamento)
• 1826: In-position band
''',
  ),

  DuvidaCNC(
    id: 'alm_fanuc_701',
    categoria: 'Alarmes',
    pergunta: 'Alarme 700 701 Fanuc — overheat spindle motor',
    tags: ['alarme 700', 'alarme 701', '700', '701', 'superaquecimento', 'spindle temperatura'],
    resposta: '''
🚨 ALARME 700/701 FANUC — SUPERAQUECIMENTO DO SPINDLE

📋 SIGNIFICADO:
• 700: Temperatura do motor spindle acima do limite
• 701: Temperatura do driver (amplificador) do spindle acima do limite

🔍 CAUSAS:
1. Velocidade muito alta por muito tempo contínuo
2. Corte pesado sem pausas suficientes
3. Filtro de ar do painel elétrico entupido
4. Ventilador do motor com defeito
5. Ambiente da máquina com temperatura alta (>40°C)
6. Fluido de corte bloqueado no spindle

🔧 RESOLUÇÃO:
1. Parar imediatamente — deixar resfriar 15-30 minutos
2. Verificar ventilação do painel elétrico
3. Limpar filtros de ar do painel (mensal obrigatório)
4. Reduzir override do spindle em 20-30%
5. Adicionar pausas M00 no programa se ciclo longo
6. Verificar temperatura ambiente da fábrica

💡 PREVENÇÃO:
• Ciclos longos em alta rotação: programar M05 a cada 30 min por 2 min de descanso
• Limpar filtros todo mês
• Monitorar temperatura no painel do CNC
''',
  ),

  // ── PROGRAMAÇÃO AVANÇADA ─────────────────────────────────
  DuvidaCNC(
    id: 'prog_g68',
    categoria: 'Programação',
    pergunta: 'Como usar G68 rotação de sistema de coordenadas',
    tags: ['G68', 'G69', 'rotação', 'sistema coordenadas', 'rotation'],
    resposta: '''
💻 G68 — ROTAÇÃO DO SISTEMA DE COORDENADAS

📋 SINTAXE:
G68 X__ Y__ R__   → ativa rotação
G69               → cancela rotação

Onde:
• X Y = centro de rotação (ponto pivô)
• R   = ângulo em graus (positivo = anti-horário)

✅ EXEMPLO — furar 6 furos em círculo (a cada 60°):
N10 G54 G90
N20 G68 X0 Y0 R0        (0° — posição inicial)
N30 M98 P1000           (chama subprograma de furação)
N40 G68 X0 Y0 R60       (rotaciona 60°)
N50 M98 P1000
N60 G68 X0 Y0 R120
N70 M98 P1000
... (repetir até 300°)
N120 G69                (cancela rotação)

⚠️ ATENÇÃO:
• G68 acumula com G54: o zero já está no centro do círculo
• Sempre cancelar G69 antes de mudar de peça
• Funciona com fresamento e torneamento (em alguns controles)
• Verificar bit de parâmetro do controle para G68 incremental

💡 DICA: Use com M98 subprograma + variável #1 para rotação automática em macro.
''',
  ),

  DuvidaCNC(
    id: 'prog_macro_b',
    categoria: 'Programação',
    pergunta: 'Como usar variáveis macro #1 #100 #500 Fanuc',
    tags: ['macro', 'variável', '#1', '#100', '#500', 'macro b', 'variavel macro'],
    resposta: '''
💻 MACRO B FANUC — VARIÁVEIS

📊 TIPOS DE VARIÁVEIS:
• #1 a #33    → Variáveis locais (perdem valor ao sair do subprograma)
• #100 a #149 → Variáveis comuns (mantidas durante operação)
• #500 a #999 → Variáveis de sistema (mantidas mesmo ao desligar)
• #1000+       → Variáveis de sistema (leitura de hardware)

✅ EXEMPLOS DE USO:

1. Calcular RPM:
#1 = 200.0         (Vc em m/min)
#2 = 50.0          (diâmetro mm)
#3 = [#1 * 1000] / [3.1416 * #2]   (fórmula RPM)
S#3 M03

2. Loop de furação em linha:
#100 = 0.0         (posição X inicial)
WHILE [#100 LE 100.0] DO 1
  G81 X#100 Y0 Z-20 R2 F100
  #100 = #100 + 20.0
END 1
G80

3. Leitura de offset:
#5001 = pos. atual X
#5002 = pos. atual Y
#5003 = pos. atual Z

⚠️ OPERADORES:
• + - * /   → aritméticos
• EQ NE GT LT GE LE → comparação
• AND OR NOT → lógicos
• SIN COS TAN SQRT ABS → funções

💡 Use #500+ para guardar dados que devem sobreviver ao desligamento (ex: contador de peças).
''',
  ),

  DuvidaCNC(
    id: 'prog_g73_g83',
    categoria: 'Programação',
    pergunta: 'Diferença G73 e G83 ciclo de furação com quebra de cavaco',
    tags: ['G73', 'G83', 'furação', 'peck drilling', 'quebra cavaco', 'furação profunda'],
    resposta: '''
💻 G73 vs G83 — FURAÇÃO PROFUNDA

🔧 G73 — CHIP BREAKING (Quebra de Cavaco):
• Fura em incrementos pequenos (Q)
• Retrai apenas 1-2mm entre passadas (recuo parcial)
• Mais RÁPIDO — não sobe até R
• Ideal para materiais que formam cavaco longo (aço, inox)

Sintaxe: G73 X__ Y__ Z__ R__ Q__ F__

Exemplo:
G73 G99 X50 Y30 Z-80 R2 Q3 F120
(fura 80mm de profundidade, quebrando cavaco a cada 3mm)

🔧 G83 — DEEP HOLE PECK (Furação Profunda):
• Fura em incrementos (Q) e RETORNA até R entre cada passo
• Mais LENTO — mas limpa cavaco completamente
• Ideal para furos > 5×D, plásticos, alumínio, furos cegos onde limpeza é crítica

Sintaxe: G83 X__ Y__ Z__ R__ Q__ F__

Exemplo:
G83 G99 X50 Y30 Z-80 R2 Q5 F100

📊 QUANDO USAR QUAL:
| Situação           | Usar  |
|--------------------|-------|
| Aço profundidade moderada | G73 |
| Furos > 5×D        | G83   |
| Alumínio/Plástico  | G83   |
| Inox (cav. longo)  | G73   |
| Quebra inserto     | G83   |

💡 Parâmetro Q: comece com Q = 0.5×D da broca. Reduza se cavaco acumular.
''',
  ),

  // ── SETUP E FERRAMENTAS ──────────────────────────────────
  DuvidaCNC(
    id: 'setup_troca_inserto',
    categoria: 'Setup',
    pergunta: 'Quando trocar pastilha inserto de torno ou fresa',
    tags: ['inserto', 'pastilha', 'troca', 'desgaste', 'vida ferramenta', 'VB', 'flanco'],
    resposta: '''
🔧 QUANDO TROCAR INSERTO/PASTILHA

📊 CRITÉRIOS DE DESGASTE (ISO 3685):

DESGASTE DE FLANCO (VB):
• VB < 0.3mm → OK para continuar
• VB = 0.3mm → TROCAR (acabamento)
• VB > 0.3mm → TROCAR (desbaste ainda ok até 0.6mm)

SINAIS VISUAIS DE TROCA NECESSÁRIA:
✅ Aresta brilhante (espelho) no flanco → desgaste normal
❌ Lascar (chipping) na aresta → impacto, vibração
❌ Deformação plástica → temperatura alta demais
❌ Cratera no rosto → Vc muito alta
❌ Trinca térmica → variação de refrigeração

SINAIS OPERACIONAIS:
• Ra (rugosidade) piorou visivelmente
• Peça saindo fora da tolerância
• Ruído anormal / vibração aumentou
• Temperatura do cavaco elevou (cavaco azulado)
• Força de corte aumentou (motor sobrecarregado)

💡 REGRA PRÁTICA:
1. Monitore sempre o PRIMEIRO sinal
2. Troque antes de quebrar — quebra danifica porta-ferramenta
3. Rotacione o inserto quando aparecer desgaste (4 arestas disponíveis)
4. Anote o tempo de vida para estabelecer preventivo

⚠️ NUNCA use inserto com lascar em peças de precisão — o erro se propaga.
''',
  ),

  DuvidaCNC(
    id: 'setup_rpm_fresa',
    categoria: 'Setup',
    pergunta: 'Como calcular RPM e avanço para fresa de topo',
    tags: ['RPM', 'avanço', 'fresa topo', 'Vc', 'fz', 'Vf', 'calculo rpm', 'velocidade corte'],
    resposta: '''
📐 CÁLCULO DE RPM E AVANÇO — FRESA DE TOPO

🔢 FÓRMULAS:

n (RPM) = (Vc × 1000) / (π × D)
Vf (mm/min) = fz × z × n

Onde:
• Vc  = velocidade de corte (m/min) — ver tabela do fabricante
• D   = diâmetro da fresa (mm)
• fz  = avanço por dente (mm/dente)
• z   = número de dentes

📊 TABELA RÁPIDA DE Vc (fresa HSS-Co / Carbide):

| Material          | HSS (m/min) | Carbide (m/min) |
|-------------------|-------------|-----------------|
| Aço 1020         | 25-35       | 80-120          |
| Aço 4140 (têmp.) | 15-20       | 50-80           |
| Inox 304         | 12-18       | 60-90           |
| Alumínio 6061    | 100-200     | 300-500         |
| Latão            | 60-100      | 150-250         |

✅ EXEMPLO — Fresa Ø10mm carbide 4 cortes, aço 1020:
• Vc = 100 m/min
• n = (100 × 1000) / (3.14 × 10) = 3185 RPM
• fz = 0.03 mm/dente
• Vf = 0.03 × 4 × 3185 = 382 mm/min

💡 DICA: Reduza Vf em 30-50% no primeiro passe em material novo.
Para cantos internos: reduza avanço em 50%.
''',
  ),

  // ── QUALIDADE E MEDIÇÃO ──────────────────────────────────
  DuvidaCNC(
    id: 'qual_rugosidade_causas',
    categoria: 'Qualidade',
    pergunta: 'Peça com rugosidade ruim acabamento riscado linhas marcas',
    tags: ['rugosidade', 'acabamento', 'Ra', 'marcas', 'riscado', 'vibração', 'chatter'],
    resposta: '''
🔍 DIAGNÓSTICO: ACABAMENTO SUPERFICIAL RUIM

📋 CAUSAS E SOLUÇÕES:

1️⃣ MARCAS REGULARES / PADRÃO DE ONDA
→ Vibração (chatter) de ferramenta
✅ Solução: Reduzir avanço ou ap, aumentar Vc, reduzir balanço da fresa

2️⃣ MARCAS EM ESPIRAL (TORNO)
→ Avanço muito alto ou inserto gasto
✅ Solução: Reduzir f (mm/rot), trocar inserto, verificar Rε (raio de ponta)

3️⃣ MARCAS TRANSVERSAIS / CRUZADAS
→ Folga em guias, fuso com backlash
✅ Solução: Ajustar backlash no parâmetro CNC, verificar guias

4️⃣ SUPERFICIE COM STRIAÇÕES IRREGULARES
→ Cavaco se reacumulando sobre a superfície
✅ Solução: Aumentar fluido de corte, usar G83 (peck) em furos, limpar com ar comprimido

5️⃣ ACABAMENTO OK MAS DIMENSÃO ERRADA
→ Desgaste de ferramenta, compensação errada
✅ Solução: Ajustar wear offset (G), medir e compensar

6️⃣ TODA A SUPERFÍCIE OPACA / QUEIMADA
→ Temperatura alta (Vc muito alta, sem refrigeração)
✅ Solução: Reduzir Vc em 20%, garantir refrigeração na zona de corte

📐 VALORES DE REFERÊNCIA Ra:
• Desbaste: Ra 6.3–12.5 µm
• Semi-acabamento: Ra 1.6–3.2 µm
• Acabamento: Ra 0.8 µm
• Espelho: Ra < 0.4 µm

💡 Regra: Ra ≈ fz² / (8 × Rε)  → Menor avanço e maior raio = melhor acabamento.
''',
  ),

  // ── SIEMENS SINUMERIK ────────────────────────────────────
  DuvidaCNC(
    id: 'siem_cycle81',
    categoria: 'Programação',
    pergunta: 'CYCLE81 CYCLE83 Siemens ciclo furação',
    tags: ['CYCLE81', 'CYCLE83', 'Siemens', 'Sinumerik', 'ciclo furação', 'siemens furação'],
    resposta: '''
💻 CICLOS DE FURAÇÃO SIEMENS SINUMERIK

🔧 CYCLE81 — FURAÇÃO SIMPLES:
CYCLE81(RTP, RFP, SDIS, DP, DPR)

Parâmetros:
• RTP  = plano de retração (Z seguro)
• RFP  = plano de referência (Z de aproximação)
• SDIS = distância de segurança
• DP   = profundidade final (absoluto)
• DPR  = profundidade relativa (opcional)

Exemplo:
CYCLE81(5, 0, 2, -30)
(retorna a Z5, ref Z0, seg 2mm, fura até Z-30)

🔧 CYCLE83 — FURAÇÃO PROFUNDA (peck):
CYCLE83(RTP, RFP, SDIS, DP, DPR, FDEP, FDPR, DAM, DTB, DTS, FRF, VARI)

Parâmetros principais:
• FDEP = 1ª profundidade de peck
• DAM  = decremento entre pecks
• DTB  = tempo de espera no fundo (seg)
• VARI = 0=chip break, 1=full retract

Exemplo:
CYCLE83(5, 0, 2, -60, , 10, , 1, 0.5, 0, 1, 1)
(fura 60mm, peck 10mm, chip break)

📋 OUTROS CICLOS COMUNS:
• CYCLE82 = Furação com espera (counter boring)
• CYCLE84 = Rosqueamento rígido
• CYCLE85 = Mandrilamento
• CYCLE86 = Mandrilamento com orientação

💡 No Sinumerik 840D: acesse os ciclos no painel pela softkey "Drilling" para geração gráfica assistida.
''',
  ),
];

// ── Função de busca local ─────────────────────────────────────
List<ResultadoBusca> buscarDuvidasCNC(String consulta) {
  if (consulta.trim().isEmpty) return [];
  final query = consulta.toLowerCase();
  final palavras = query.split(RegExp(r'\s+')).where((p) => p.length > 2).toList();

  final resultados = <ResultadoBusca>[];

  for (final d in listaDuvidasCNC) {
    int score = 0;
    final texto = '${d.pergunta} ${d.resposta} ${d.tags.join(' ')} ${d.categoria}'.toLowerCase();

    // Pergunta exata = alta pontuação
    if (d.pergunta.toLowerCase().contains(query)) score += 50;

    // Tags exatas
    for (final tag in d.tags) {
      if (query.contains(tag.toLowerCase())) score += 20;
      for (final p in palavras) {
        if (tag.toLowerCase().contains(p)) score += 10;
      }
    }

    // Palavras no texto
    for (final p in palavras) {
      final count = RegExp(p, caseSensitive: false).allMatches(texto).length;
      score += count * 3;
    }

    // Categoria match
    if (d.categoria.toLowerCase().contains(query)) score += 15;

    if (score > 5) resultados.add(ResultadoBusca(duvidaCNC: d, score: score));
  }

  resultados.sort((a, b) => b.score.compareTo(a.score));
  return resultados.take(5).toList();
}

class ResultadoBusca {
  final DuvidaCNC duvidaCNC;
  final int score;
  const ResultadoBusca({required this.duvidaCNC, required this.score});
}
