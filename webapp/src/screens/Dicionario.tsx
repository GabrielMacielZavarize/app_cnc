import { useMemo, useState } from 'react';
import { ChevronDown, Languages } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { SearchBar } from '@/components/ui/SearchBar';
import { Badge } from '@/components/ui/Badge';
import { EmptyState } from '@/components/ui/EmptyState';
import { termos } from '@/data/dicionario';
import { norm } from '@/lib/busca';
import { cx } from '@/lib/cx';

const CATEGORIAS = ['Todos', ...[...new Set(termos.map((t) => t.categoria))].sort()];

export function Dicionario() {
  const [busca, setBusca] = useState('');
  const [cat, setCat] = useState('Todos');
  const [aberto, setAberto] = useState<string | null>(null);

  const lista = useMemo(() => {
    const q = norm(busca.trim());
    return termos.filter((t) => {
      if (cat !== 'Todos' && t.categoria !== cat) return false;
      if (!q) return true;
      return (
        norm(t.pt).includes(q) ||
        norm(t.en).includes(q) ||
        norm(t.es).includes(q) ||
        norm(t.descricao).includes(q)
      );
    });
  }, [busca, cat]);

  return (
    <>
      <TopBar title="Dicionário Técnico" subtitle="PT · EN · ES" icon={Languages} back />

      <div className="space-y-3 p-4">
        <SearchBar value={busca} onChange={setBusca} placeholder="Buscar termo em PT, EN ou ES..." />

        <div className="no-scrollbar -mx-4 flex gap-2 overflow-x-auto px-4">
          {CATEGORIAS.map((c) => (
            <button
              key={c}
              type="button"
              onClick={() => setCat(c)}
              className={cx(
                'whitespace-nowrap rounded-full border px-3 py-1 text-xs font-medium transition',
                cat === c
                  ? 'border-cnc-amber bg-cnc-amber/15 text-cnc-amberDark'
                  : 'border-black/10 bg-white text-gray-500',
              )}
            >
              {c}
            </button>
          ))}
        </div>

        <p className="px-1 text-xs text-gray-400">{lista.length} termos</p>

        {lista.length === 0 ? (
          <EmptyState icon={Languages} title="Nenhum termo encontrado" subtitle="Tente outro termo ou categoria." />
        ) : (
          <div className="space-y-2">
            {lista.map((t) => {
              const expandido = aberto === t.pt;
              return (
                <div key={t.pt} className="overflow-hidden rounded-2xl border border-black/[0.06] bg-white shadow-sm">
                  <button
                    type="button"
                    onClick={() => setAberto(expandido ? null : t.pt)}
                    className="flex w-full items-center gap-2 p-3 text-left"
                  >
                    <div className="min-w-0 flex-1">
                      <div className="flex items-center gap-2">
                        <span className="font-semibold text-cnc-dark">{t.pt}</span>
                        <Badge color="#185FA5">{t.categoria}</Badge>
                      </div>
                      <p className="mt-0.5 truncate text-xs text-gray-500">
                        🇺🇸 {t.en} · 🇪🇸 {t.es}
                      </p>
                    </div>
                    <ChevronDown
                      size={18}
                      className={cx('shrink-0 text-gray-400 transition', expandido && 'rotate-180')}
                    />
                  </button>
                  {expandido && (
                    <div className="border-t border-black/[0.05] px-3 py-3">
                      <p className="text-sm leading-relaxed text-gray-700">{t.descricao}</p>
                      {t.exemplo && (
                        <p className="mt-2 rounded-lg bg-gray-50 px-3 py-2 font-mono text-xs text-gray-600">
                          {t.exemplo}
                        </p>
                      )}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        )}
      </div>
    </>
  );
}
