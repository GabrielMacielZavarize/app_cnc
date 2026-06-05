// Modelos de domínio — portados de lib/models.dart, lib/materias/materiais_data.dart
// e lib/database/cnc_local_db.dart. Campos com valor-padrão no Dart são opcionais aqui.

export interface Parametro {
  letra: string;
  descricao: string;
}

export interface CodigoItem {
  codigo: string;
  nome: string;
  descricao: string;
  descricaoCompleta: string;
  sintaxe: string;
  exemplo: string;
  explicacaoExemplo: string;
  categoria: string;
  parametros: Parametro[];
  isG: boolean;
  /** default 'Ambos' no Flutter */
  maquina?: string;
  /** default 'Universal' no Flutter */
  fabricante?: string;
  diagramaTipo?: string | null;
  imagemUrl?: string | null;
  imagemLegenda?: string | null;
  dicaProfissional?: string | null;
}

export interface AlarmeItem {
  codigo: string;
  titulo: string;
  descricao: string;
  descricaoCompleta: string;
  gravidade: string;
  categoria: string;
  causas: string[];
  solucoes: string[];
  atencao?: string | null;
}

export interface ParamCorte {
  operacao: string;
  vc: string;
  fz: string;
  ap: string;
}

export interface MaterialCNC {
  nome: string;
  norma: string;
  descricao: string;
  dureza: string;
  resistencia: string;
  densidade: string;
  maquinabilidade: string;
  aplicacoes: string;
  vcMin: number;
  vcMax: number;
  cor: string; // hex (convertido de Color)
  icone: string; // nome do ícone (convertido de IconData)
  fresamento: ParamCorte[];
  torneamento: ParamCorte[];
  furacao: ParamCorte[];
  fluido: string;
  concentracaoFluido: string;
  dicaFluido: string;
  dicas: string[];
}

export interface DuvidaCNC {
  id: string;
  pergunta: string;
  resposta: string;
  tags: string[];
  categoria: string;
}

export interface ItemBuscaOffline {
  termo: string;
  titulo: string;
  descricao: string;
  categoria: string;
}

export interface Termo {
  pt: string;
  en: string;
  es: string;
  descricao: string;
  exemplo?: string;
  categoria: string;
}

// ── Guia do operador ──
export interface Problema {
  problema: string;
  solucao: string;
  codigo: string;
  dica: string;
  tags: string[];
  comandos: Record<string, string>;
  cor: string;
  icone: string;
}

export interface Equivalencia {
  operacao: string;
  fanuc: string;
  siemens: string;
  haas: string;
  descricao: string;
  nota: string;
}

export interface Endereco {
  letra: string;
  nome: string;
  descricao: string;
  maquina: string;
}

export interface GrupoEnderecos {
  nome: string;
  cor: string;
  enderecos: Endereco[];
}

// ── Programas CNC ──
export interface LinhaExplicada {
  codigo: string;
  explicacao?: string;
  isComentario?: boolean;
}

export interface ProgramaCNC {
  titulo: string;
  subtitulo: string;
  descricao: string;
  codigo: string;
  nivel: string;
  ferramentas: string[];
  setup: string[];
  dicas: string[];
  tags: string[];
  linhasExplicadas: LinhaExplicada[];
  cor: string;
  icone: string;
}

// ── Checklist do operador ──
export interface CheckItem {
  titulo: string;
  detalhe: string;
  categoria: string;
  icone: string; // emoji
}

// ── Tabelas técnicas ──
export interface RoscaMetrica {
  nome: string;
  passo: string;
  furoBroca: string;
  diametroMedio: string;
  diametroExterno: string;
  alturaFilete: string;
  chave: string;
  passoFino: string;
}
