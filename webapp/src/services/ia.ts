// Camada de acesso à IA. Todas as chamadas passam pelo backend FastAPI (server.py),
// acessado via proxy do Vite em /api → http://localhost:8000.
// Assim a chave do Gemini fica só no backend (.env), nunca no navegador.

export interface ChatMsg {
  role: 'user' | 'model';
  text: string;
}

const TIMEOUT_MS = 30_000;

async function postJson(path: string, body: unknown): Promise<any> {
  const ctrl = new AbortController();
  const timer = setTimeout(() => ctrl.abort(), TIMEOUT_MS);
  try {
    const resp = await fetch(`/api${path}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body),
      signal: ctrl.signal,
    });
    if (!resp.ok) throw new Error(`HTTP ${resp.status}`);
    return await resp.json();
  } finally {
    clearTimeout(timer);
  }
}

/**
 * Consulta o "Mestre CNC" (endpoint /gerar-programa do backend).
 * Usado pela tela Agente. `historico` no formato legado {role, text}.
 */
export async function consultarAgente(historico: ChatMsg[], prompt?: string): Promise<string> {
  const data = await postJson('/gerar-programa', { historico, prompt });
  return (data?.resposta as string) ?? '';
}

export type TipoAnalise = 'geral' | 'erro' | 'peca' | 'programa' | 'ferramenta' | 'parametros';

/**
 * Análise por IA (tela IA). Envia tipo + texto + imagem (base64 sem prefixo)
 * para o backend, que monta o prompt e chama o Gemini multimodal.
 */
export async function analisarIA(tipo: TipoAnalise, texto: string, imagem?: string): Promise<string> {
  const data = await postJson('/analisar', { tipo, texto, imagem });
  return (data?.resposta as string) ?? '';
}

/** Indica se o backend está acessível (para o banner de status). */
export async function backendDisponivel(): Promise<boolean> {
  try {
    const resp = await fetch('/api/docs', { method: 'GET' });
    return resp.ok;
  } catch {
    return false;
  }
}
