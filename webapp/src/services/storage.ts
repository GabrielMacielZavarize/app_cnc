// Wrapper fino sobre localStorage (substitui SharedPreferences) para usos
// que não passam pelo middleware persist do Zustand — ex.: contadores da IA.
export const storage = {
  get<T>(chave: string, padrao: T): T {
    try {
      const raw = localStorage.getItem(chave);
      return raw === null ? padrao : (JSON.parse(raw) as T);
    } catch {
      return padrao;
    }
  },
  set<T>(chave: string, valor: T): void {
    try {
      localStorage.setItem(chave, JSON.stringify(valor));
    } catch {
      /* quota cheia ou indisponível — ignora silenciosamente */
    }
  },
  remove(chave: string): void {
    try {
      localStorage.removeItem(chave);
    } catch {
      /* ignora */
    }
  },
};
