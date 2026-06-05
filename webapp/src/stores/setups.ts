import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { uid } from '@/lib/uid';

export interface Setup {
  id: string;
  maquina: string;
  numeroProg: string;
  nomePeca: string;
  operacao: string;
  material: string;
  offsetX: string;
  offsetY: string;
  offsetZ: string;
  ferramentas: string; // texto livre, ex.: "T1 Fresa Ø10 H01\nT2 Broca Ø8 H02"
  observacoes: string;
  criadoEm: number;
}

interface SetupsStore {
  setups: Setup[];
  add: (s: Omit<Setup, 'id' | 'criadoEm'>) => void;
  update: (id: string, patch: Partial<Setup>) => void;
  remove: (id: string) => void;
}

export const useSetupsStore = create<SetupsStore>()(
  persist(
    (set) => ({
      setups: [],
      add: (s) => set((st) => ({ setups: [{ ...s, id: uid(), criadoEm: Date.now() }, ...st.setups] })),
      update: (id, patch) =>
        set((st) => ({ setups: st.setups.map((s) => (s.id === id ? { ...s, ...patch } : s)) })),
      remove: (id) => set((st) => ({ setups: st.setups.filter((s) => s.id !== id) })),
    }),
    { name: 'cncia_setups' },
  ),
);
