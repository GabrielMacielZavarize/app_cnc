import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { uid } from '@/lib/uid';

export type StatusOrdem = 'Pendente' | 'Em Andamento' | 'Concluída' | 'Pausada' | 'Reprovada';

export const STATUS_ORDEM: StatusOrdem[] = ['Pendente', 'Em Andamento', 'Concluída', 'Pausada', 'Reprovada'];

export const COR_STATUS: Record<StatusOrdem, string> = {
  Pendente: '#6B7280',
  'Em Andamento': '#185FA5',
  Concluída: '#0F6E56',
  Pausada: '#E8A020',
  Reprovada: '#D94040',
};

export interface Ordem {
  id: string;
  nomePeca: string;
  numeroProg: string;
  material: string;
  maquina: string;
  qtdTotal: number;
  qtdProduzida: number;
  qtdRejeitada: number;
  status: StatusOrdem;
  operador: string;
  observacao: string;
  criadaEm: number;
}

interface OrdensStore {
  ordens: Ordem[];
  add: (o: Omit<Ordem, 'id' | 'criadaEm'>) => void;
  update: (id: string, patch: Partial<Ordem>) => void;
  remove: (id: string) => void;
}

export const useOrdensStore = create<OrdensStore>()(
  persist(
    (set) => ({
      ordens: [],
      add: (o) => set((s) => ({ ordens: [{ ...o, id: uid(), criadaEm: Date.now() }, ...s.ordens] })),
      update: (id, patch) =>
        set((s) => ({ ordens: s.ordens.map((o) => (o.id === id ? { ...o, ...patch } : o)) })),
      remove: (id) => set((s) => ({ ordens: s.ordens.filter((o) => o.id !== id) })),
    }),
    { name: 'cncia_ordens' },
  ),
);
