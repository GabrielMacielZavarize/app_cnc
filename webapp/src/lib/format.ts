/** "agora", "há 5min", "há 2h", "há 3d" ou data curta. */
export function tempoRelativo(ms: number): string {
  const diff = Date.now() - ms;
  const min = Math.floor(diff / 60000);
  if (min < 1) return 'agora';
  if (min < 60) return `há ${min}min`;
  const h = Math.floor(min / 60);
  if (h < 24) return `há ${h}h`;
  const d = Math.floor(h / 24);
  if (d < 7) return `há ${d}d`;
  const data = new Date(ms);
  return `${data.getDate()}/${data.getMonth() + 1}`;
}
