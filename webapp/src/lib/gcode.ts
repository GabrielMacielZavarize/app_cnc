import { todosCodigos } from '@/data/codigos';

// Parser/explicador de blocos G/M (porta a lógica do simulador_screen.dart).

const ENDERECOS: Record<string, string> = {
  X: 'Posição/coordenada no eixo X',
  Y: 'Posição/coordenada no eixo Y',
  Z: 'Posição/profundidade no eixo Z',
  A: 'Eixo rotativo A',
  B: 'Eixo rotativo B',
  C: 'Eixo rotativo C',
  I: 'Centro do arco em X (relativo ao início)',
  J: 'Centro do arco em Y (relativo ao início)',
  K: 'Centro do arco em Z (relativo ao início)',
  R: 'Raio do arco / plano de retorno (ciclos)',
  F: 'Avanço (mm/min ou mm/rot)',
  S: 'Rotação do spindle (RPM) ou Vc',
  T: 'Seleção de ferramenta',
  H: 'Offset de comprimento da ferramenta',
  D: 'Offset de raio da ferramenta',
  P: 'Parâmetro: tempo, subprograma ou bloco inicial',
  Q: 'Passo de ciclo / profundidade incremental',
  E: 'Avanço fino / passo de rosca',
  L: 'Número de repetições',
};

export type TipoToken = 'G' | 'M' | 'N' | 'endereco' | 'outro';

export interface Token {
  letra: string;
  valor: string;
  descricao: string;
  tipo: TipoToken;
}

export interface LinhaParse {
  original: string;
  tokens: Token[];
  avisos: string[];
}

function normCod(cod: string): string {
  const m = cod.match(/^([A-Za-z]+)0*(\d.*)$/);
  return m ? m[1].toUpperCase() + m[2] : cod.toUpperCase();
}

function buscaCodigo(letra: 'G' | 'M', valor: string) {
  const alvo = normCod(letra + valor);
  return todosCodigos.find((c) => c.isG === (letra === 'G') && normCod(c.codigo) === alvo);
}

function montaToken(letra: string, valor: string): Token {
  if (letra === 'G' || letra === 'M') {
    const cod = buscaCodigo(letra, valor);
    return {
      letra,
      valor,
      tipo: letra,
      descricao: cod ? `${cod.codigo} — ${cod.nome}` : `Código ${letra}${valor} (não catalogado)`,
    };
  }
  if (letra === 'N') return { letra, valor, tipo: 'N', descricao: 'Número do bloco (linha)' };
  return { letra, valor, tipo: ENDERECOS[letra] ? 'endereco' : 'outro', descricao: ENDERECOS[letra] ?? `Endereço ${letra}` };
}

function analisaAvisos(tokens: Token[]): string[] {
  const avisos: string[] = [];
  const gcodes = tokens.filter((t) => t.tipo === 'G').map((t) => normCod('G' + t.valor));
  const mcodes = tokens.filter((t) => t.tipo === 'M').map((t) => normCod('M' + t.valor));
  const z = tokens.find((t) => t.letra === 'Z');

  if (gcodes.includes('G0') && z && parseFloat(z.valor) < 0) {
    avisos.push('G00 (avanço rápido) com Z negativo — risco de mergulhar no material em velocidade máxima. Use G01 com F.');
  }
  if (gcodes.includes('G1') && !tokens.some((t) => t.letra === 'F')) {
    avisos.push('G01 sem avanço F neste bloco — confirme se um F já está ativo.');
  }
  if ((mcodes.includes('M3') || mcodes.includes('M4')) && !tokens.some((t) => t.letra === 'S')) {
    avisos.push('Spindle acionado (M03/M04) sem rotação S definida neste bloco.');
  }
  return avisos;
}

function parseLinha(linha: string): LinhaParse {
  const tokens: Token[] = [];
  const re = /([A-Za-z])\s*([-+]?\d*\.?\d+)/g;
  let m: RegExpExecArray | null;
  while ((m = re.exec(linha)) !== null) {
    tokens.push(montaToken(m[1].toUpperCase(), m[2]));
  }
  return { original: linha, tokens, avisos: analisaAvisos(tokens) };
}

export function parseBloco(texto: string): LinhaParse[] {
  return texto
    .split('\n')
    .filter((l) => l.trim().length > 0)
    .map(parseLinha);
}
