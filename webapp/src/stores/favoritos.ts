import { create } from 'zustand';
import { persist } from 'zustand/middleware';

// Porta o FavoritosManager. Usa arrays (em vez de Set) para serializar no localStorage.
interface FavoritosState {
  codigos: string[];
  alarmes: string[];
  toggleCodigo: (codigo: string) => void;
  toggleAlarme: (codigo: string) => void;
  isCodigoFavorito: (codigo: string) => boolean;
  isAlarmeFavorito: (codigo: string) => boolean;
}

export const useFavoritosStore = create<FavoritosState>()(
  persist(
    (set, get) => ({
      codigos: [],
      alarmes: [],
      toggleCodigo: (codigo) =>
        set((s) => ({
          codigos: s.codigos.includes(codigo)
            ? s.codigos.filter((c) => c !== codigo)
            : [...s.codigos, codigo],
        })),
      toggleAlarme: (codigo) =>
        set((s) => ({
          alarmes: s.alarmes.includes(codigo)
            ? s.alarmes.filter((c) => c !== codigo)
            : [...s.alarmes, codigo],
        })),
      isCodigoFavorito: (codigo) => get().codigos.includes(codigo),
      isAlarmeFavorito: (codigo) => get().alarmes.includes(codigo),
    }),
    { name: 'cncia_favoritos' },
  ),
);

// Seletor do total de favoritos (para o badge do menu).
export const selectTotalFavoritos = (s: FavoritosState) => s.codigos.length + s.alarmes.length;
