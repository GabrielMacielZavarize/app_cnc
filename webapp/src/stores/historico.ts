import { create } from 'zustand';
import { persist } from 'zustand/middleware';

// Porta os modelos do HistoricoManager. Datas guardadas como epoch ms (number).
export interface ItemHistorico {
  id: string;
  titulo: string;
  subtitulo: string;
  tipo: string; // 'Código G' | 'Código M' | 'Alarme' | 'Material' | 'Programa' | 'Cálculo'
  data: number;
}

export interface NotaPessoal {
  id: string;
  titulo: string;
  conteudo: string;
  data: number;
  cor: string; // hex
}

interface HistoricoState {
  historico: ItemHistorico[];
  notas: NotaPessoal[];
  addHistorico: (item: Omit<ItemHistorico, 'data'> & { data?: number }) => void;
  limparHistorico: () => void;
  addNota: (nota: Omit<NotaPessoal, 'id' | 'data'> & { id?: string; data?: number }) => void;
  editarNota: (id: string, titulo: string, conteudo: string) => void;
  deletarNota: (id: string) => void;
}

export const useHistoricoStore = create<HistoricoState>()(
  persist(
    (set) => ({
      historico: [],
      notas: [],
      addHistorico: (item) =>
        set((s) => {
          const semDuplicata = s.historico.filter((h) => h.id !== item.id);
          const novo: ItemHistorico = { data: Date.now(), ...item };
          return { historico: [novo, ...semDuplicata].slice(0, 50) };
        }),
      limparHistorico: () => set({ historico: [] }),
      addNota: (nota) =>
        set((s) => ({
          notas: [
            { id: String(Date.now()), data: Date.now(), ...nota },
            ...s.notas,
          ],
        })),
      editarNota: (id, titulo, conteudo) =>
        set((s) => ({
          notas: s.notas.map((n) =>
            n.id === id ? { ...n, titulo, conteudo, data: Date.now() } : n,
          ),
        })),
      deletarNota: (id) => set((s) => ({ notas: s.notas.filter((n) => n.id !== id) })),
    }),
    { name: 'cncia_historico' },
  ),
);
