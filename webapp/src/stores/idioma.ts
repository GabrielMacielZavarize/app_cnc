import { create } from 'zustand';
import { persist } from 'zustand/middleware';
import { type Idioma, traduzir } from '@/i18n';

// Porta o IdiomaManager (singleton ChangeNotifier) para um store Zustand persistido.
interface IdiomaState {
  idioma: Idioma;
  setIdioma: (idioma: Idioma) => void;
}

export const useIdiomaStore = create<IdiomaState>()(
  persist(
    (set) => ({
      idioma: 'pt',
      setIdioma: (idioma) => set({ idioma }),
    }),
    { name: 'cncia_idioma' },
  ),
);

/**
 * Hook de tradução reativo — equivalente a idiomaManager.tr(chave).
 * Componentes que o usam re-renderizam automaticamente ao trocar de idioma.
 */
export function useT(): (chave: string) => string {
  const idioma = useIdiomaStore((s) => s.idioma);
  return (chave: string) => traduzir(idioma, chave);
}
