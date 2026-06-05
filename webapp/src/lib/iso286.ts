// Tabela de tolerâncias IT (ISO 286-1) em micrômetros.
// Colunas = faixas de diâmetro nominal (mm); valores padrão da norma.

export const FAIXAS: { ate: number; label: string }[] = [
  { ate: 3, label: '≤3' },
  { ate: 6, label: '3–6' },
  { ate: 10, label: '6–10' },
  { ate: 18, label: '10–18' },
  { ate: 30, label: '18–30' },
  { ate: 50, label: '30–50' },
  { ate: 80, label: '50–80' },
  { ate: 120, label: '80–120' },
  { ate: 180, label: '120–180' },
  { ate: 250, label: '180–250' },
  { ate: 315, label: '250–315' },
  { ate: 400, label: '315–400' },
  { ate: 500, label: '400–500' },
];

export const GRAUS_IT = [5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];

// IT[grau] = valores em µm por faixa (mesma ordem de FAIXAS).
const IT: Record<number, number[]> = {
  5: [4, 5, 6, 8, 9, 11, 13, 15, 18, 20, 23, 25, 27],
  6: [6, 8, 9, 11, 13, 16, 19, 22, 25, 29, 32, 36, 40],
  7: [10, 12, 15, 18, 21, 25, 30, 35, 40, 46, 52, 57, 63],
  8: [14, 18, 22, 27, 33, 39, 46, 54, 63, 72, 81, 89, 97],
  9: [25, 30, 36, 43, 52, 62, 74, 87, 100, 115, 130, 140, 155],
  10: [40, 48, 58, 70, 84, 100, 120, 140, 160, 185, 210, 230, 250],
  11: [60, 75, 90, 110, 130, 160, 190, 220, 250, 290, 320, 360, 400],
  12: [100, 120, 150, 180, 210, 250, 300, 350, 400, 460, 520, 570, 630],
  13: [140, 180, 220, 270, 330, 390, 460, 540, 630, 720, 810, 890, 970],
  14: [250, 300, 360, 430, 520, 620, 740, 870, 1000, 1150, 1300, 1400, 1550],
  15: [400, 480, 580, 700, 840, 1000, 1200, 1400, 1600, 1850, 2100, 2300, 2500],
  16: [600, 750, 900, 1100, 1300, 1600, 1900, 2200, 2500, 2900, 3200, 3600, 4000],
};

export function faixaIndex(d: number): number {
  if (d <= 0) return -1;
  return FAIXAS.findIndex((f) => d <= f.ate);
}

/** Valor da tolerância IT em µm para o diâmetro e grau, ou null se fora de faixa. */
export function valorIT(diametro: number, grau: number): number | null {
  const i = faixaIndex(diametro);
  if (i < 0) return null;
  return IT[grau]?.[i] ?? null;
}

/** Linha completa de valores IT (todos os graus) para um diâmetro. */
export function linhaIT(diametro: number): { grau: number; um: number }[] {
  const i = faixaIndex(diametro);
  if (i < 0) return [];
  return GRAUS_IT.map((g) => ({ grau: g, um: IT[g][i] }));
}

export interface Ajuste {
  classe: string;
  tipo: 'Folga' | 'Incerto' | 'Interferência';
  desc: string;
}

// Ajustes comuns no sistema furo-base (H).
export const AJUSTES_COMUNS: Ajuste[] = [
  { classe: 'H7/g6', tipo: 'Folga', desc: 'Folga pequena — encaixe deslizante com lubrificação (mancais, guias).' },
  { classe: 'H7/h6', tipo: 'Folga', desc: 'Folga mínima — encaixe justo, montagem e desmontagem à mão.' },
  { classe: 'H8/f7', tipo: 'Folga', desc: 'Folga livre — eixos girando em buchas, boa lubrificação.' },
  { classe: 'H11/c11', tipo: 'Folga', desc: 'Folga ampla — peças sem precisão, grande movimento.' },
  { classe: 'H7/k6', tipo: 'Incerto', desc: 'Ajuste incerto — leve aperto, centragem precisa, pouca carga.' },
  { classe: 'H7/n6', tipo: 'Interferência', desc: 'Prensado leve — exige prensa; transmite carga moderada.' },
  { classe: 'H7/p6', tipo: 'Interferência', desc: 'Prensado — fixo, transmite torque sem chaveta.' },
  { classe: 'H7/s6', tipo: 'Interferência', desc: 'Prensado forte — montagem a quente, alta carga.' },
];
