import type { CodigoItem } from '@/types';

// Mapa de sinônimos de chão de fábrica → códigos (porta a busca inteligente da
// biblioteca_screen.dart). Ex.: "furo fundo" encontra G83.
const SINONIMOS: Record<string, string[]> = {
  'furo fundo': ['G83'],
  'furo profundo': ['G83'],
  'pica pau': ['G83'],
  peck: ['G83'],
  rosca: ['G84', 'G76', 'G92', 'G32', 'G74'],
  roscar: ['G84', 'G76'],
  desbaste: ['G71', 'G72', 'G73'],
  acabamento: ['G70'],
  'ligar spindle': ['M03', 'M04'],
  'liga arvore': ['M03', 'M04'],
  refrigeracao: ['M08'],
  fluido: ['M08'],
  'fluido de corte': ['M08'],
  compensacao: ['G41', 'G42', 'G43'],
  'zero peca': ['G54', 'G55', 'G56', 'G57', 'G58', 'G59'],
  circulo: ['G02', 'G03'],
  arco: ['G02', 'G03'],
  furacao: ['G81', 'G82', 'G83', 'G73'],
  troca: ['M06'],
};

/** Remove acentos e baixa caixa, para busca tolerante. */
export function norm(s: string): string {
  return s
    .toLowerCase()
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '');
}

export function buscarCodigos(lista: CodigoItem[], termo: string): CodigoItem[] {
  const q = norm(termo.trim());
  if (!q) return lista;

  const alvos = new Set<string>();
  for (const [chave, codigos] of Object.entries(SINONIMOS)) {
    const k = norm(chave);
    if (k.includes(q) || q.includes(k)) codigos.forEach((c) => alvos.add(c));
  }

  return lista.filter((c) => {
    if (alvos.has(c.codigo)) return true;
    return (
      norm(c.codigo).includes(q) ||
      norm(c.nome).includes(q) ||
      norm(c.descricao).includes(q) ||
      norm(c.categoria).includes(q)
    );
  });
}

export function buscarAlarmes<T extends { codigo: string; titulo: string; descricao: string; categoria: string }>(
  lista: T[],
  termo: string,
): T[] {
  const q = norm(termo.trim());
  if (!q) return lista;
  return lista.filter(
    (a) =>
      norm(a.codigo).includes(q) ||
      norm(a.titulo).includes(q) ||
      norm(a.descricao).includes(q) ||
      norm(a.categoria).includes(q),
  );
}
