import { create } from 'zustand';

// Porta o ConectividadeManager. Os listeners são registrados uma vez no AppShell.
interface ConectividadeState {
  online: boolean;
  setOnline: (online: boolean) => void;
}

export const useConectividadeStore = create<ConectividadeState>((set) => ({
  online: typeof navigator !== 'undefined' ? navigator.onLine : true,
  setOnline: (online) => set({ online }),
}));
