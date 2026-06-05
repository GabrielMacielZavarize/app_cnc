import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { uid } from '@/lib/uid';
import type { TipoAnalise } from '@/services/ia';

export interface AnaliseHistorico {
  id: string;
  tipo: TipoAnalise;
  entrada: string;
  resposta: string;
  comImagem: boolean;
  data: number;
}

interface IAStore {
  historico: AnaliseHistorico[];
  add: (a: Omit<AnaliseHistorico, 'id' | 'data'>) => void;
  limpar: () => void;
}

export const useIAStore = create<IAStore>()(
  persist(
    (set) => ({
      historico: [],
      add: (a) =>
        set((s) => ({ historico: [{ ...a, id: uid(), data: Date.now() }, ...s.historico].slice(0, 30) })),
      limpar: () => set({ historico: [] }),
    }),
    { name: 'cncia_ia_historico' },
  ),
);
