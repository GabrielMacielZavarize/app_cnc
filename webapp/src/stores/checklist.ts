import { create } from 'zustand';
import { persist } from 'zustand/middleware';

// Marca quais itens do checklist estão concluídos (id = título do item).
interface ChecklistStore {
  concluidos: string[];
  toggle: (id: string) => void;
  reset: () => void;
}

export const useChecklistStore = create<ChecklistStore>()(
  persist(
    (set) => ({
      concluidos: [],
      toggle: (id) =>
        set((s) => ({
          concluidos: s.concluidos.includes(id)
            ? s.concluidos.filter((c) => c !== id)
            : [...s.concluidos, id],
        })),
      reset: () => set({ concluidos: [] }),
    }),
    { name: 'cncia_checklist' },
  ),
);
