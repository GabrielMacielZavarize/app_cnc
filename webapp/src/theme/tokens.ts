// Tokens de design espelhando lib/constants.dart do app Flutter original.
// Usados onde o Tailwind não alcança (SVG, cores dinâmicas por categoria/gravidade).
export const colors = {
  dark: '#1A1A2E', // kDark
  amber: '#E8A020', // kAmber
  bg: '#F5F5F5', // kBg
  blue: '#185FA5', // kBlue
  red: '#D94040', // kRed
  green: '#0F6E56', // kGreen
  amberDark: '#BA7517',
  redDark: '#A32D2D',
  purple: '#534AB7',
} as const;

// Cor por tipo de item (histórico, favoritos) — espelha _corTipo do HistoricoManager.
export function corPorTipo(tipo: string): string {
  switch (tipo) {
    case 'Código G':
      return colors.amberDark;
    case 'Código M':
      return colors.green;
    case 'Alarme':
      return colors.redDark;
    case 'Material':
      return colors.blue;
    case 'Programa':
      return '#2E7D32';
    case 'Cálculo':
      return colors.purple;
    default:
      return '#9E9E9E';
  }
}

// Cor por gravidade de alarme (gravidades dos dados: CRÍTICO, GRAVE, MÉDIO, BAIXO, INFO...).
export function corPorGravidade(gravidade: string): string {
  const g = gravidade.toLowerCase();
  if (g.includes('crí') || g.includes('cri') || g.includes('grav') || g.includes('alto')) return colors.red;
  if (g.includes('méd') || g.includes('med') || g.includes('avis') || g.includes('warn')) return colors.amber;
  return colors.blue;
}
