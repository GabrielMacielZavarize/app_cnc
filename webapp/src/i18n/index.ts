import { pt } from './pt';
import { en } from './en';
import { es } from './es';

export type Idioma = 'pt' | 'en' | 'es';

export const traducoes: Record<Idioma, Record<string, string>> = { pt, en, es };

// Porta IdiomaManager.tr(): tenta o idioma atual, cai para PT, e por fim a própria chave.
export function traduzir(idioma: Idioma, chave: string): string {
  return traducoes[idioma]?.[chave] ?? traducoes.pt[chave] ?? chave;
}

export const IDIOMAS: { code: Idioma; label: string; flag: string }[] = [
  { code: 'pt', label: 'Português', flag: '🇧🇷' },
  { code: 'en', label: 'English', flag: '🇺🇸' },
  { code: 'es', label: 'Español', flag: '🇪🇸' },
];
