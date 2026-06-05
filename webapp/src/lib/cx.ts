// Concatenador de classes condicionais (mini-clsx, sem dependência).
export function cx(...parts: Array<string | false | null | undefined>): string {
  return parts.filter(Boolean).join(' ');
}
