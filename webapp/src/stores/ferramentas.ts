import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { uid } from '@/lib/uid';

export const TIPOS_FERRAMENTA = ['Fresa', 'Broca', 'Inserto', 'Macho', 'Alargador', 'Mandril', 'Outro'];

export interface Ferramenta {
  id: string;
  nome: string;
  tipo: string;
  diametro: string;
  material: string; // HSS, Metal duro, CBN, Cerâmica...
  vidaMaxPecas: number;
  pecasFeitas: number;
  alertaPct: number; // % em que alerta troca (ex.: 80)
}

interface FerramentasStore {
  ferramentas: Ferramenta[];
  add: (f: Omit<Ferramenta, 'id'>) => void;
  update: (id: string, patch: Partial<Ferramenta>) => void;
  remove: (id: string) => void;
}

export const useFerramentasStore = create<FerramentasStore>()(
  persist(
    (set) => ({
      ferramentas: [],
      add: (f) => set((s) => ({ ferramentas: [{ ...f, id: uid() }, ...s.ferramentas] })),
      update: (id, patch) =>
        set((s) => ({ ferramentas: s.ferramentas.map((f) => (f.id === id ? { ...f, ...patch } : f)) })),
      remove: (id) => set((s) => ({ ferramentas: s.ferramentas.filter((f) => f.id !== id) })),
    }),
    { name: 'cncia_ferramentas' },
  ),
);

// Percentual de vida consumida e status derivado.
export function pctVida(f: Ferramenta): number {
  return f.vidaMaxPecas > 0 ? Math.min(100, (f.pecasFeitas / f.vidaMaxPecas) * 100) : 0;
}

export function statusFerramenta(f: Ferramenta): { label: string; cor: string } {
  const pct = pctVida(f);
  if (pct >= 100) return { label: 'TROCAR', cor: '#D94040' };
  if (pct >= f.alertaPct) return { label: 'ATENÇÃO', cor: '#E8A020' };
  return { label: 'OK', cor: '#0F6E56' };
}
