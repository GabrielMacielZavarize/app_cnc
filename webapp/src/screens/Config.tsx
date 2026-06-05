import { Check, Settings } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { useIdiomaStore, useT } from '@/stores/idioma';
import { IDIOMAS } from '@/i18n';
import { cx } from '@/lib/cx';

export function Config() {
  const t = useT();
  const idioma = useIdiomaStore((s) => s.idioma);
  const setIdioma = useIdiomaStore((s) => s.setIdioma);

  return (
    <>
      <TopBar title={t('config.titulo')} back icon={Settings} />
      <div className="space-y-6 p-5">
        <section>
          <h2 className="mb-2 px-1 text-xs font-bold uppercase tracking-wider text-gray-500">
            {t('config.idioma')}
          </h2>
          <div className="overflow-hidden rounded-2xl border border-black/[0.06] bg-white shadow-sm">
            {IDIOMAS.map((l, i) => (
              <button
                key={l.code}
                type="button"
                onClick={() => setIdioma(l.code)}
                className={cx(
                  'flex w-full items-center gap-3 px-4 py-3.5 text-left transition hover:bg-gray-50',
                  i > 0 && 'border-t border-black/[0.05]',
                )}
              >
                <span className="text-xl">{l.flag}</span>
                <span className="flex-1 text-sm font-medium text-cnc-dark">{l.label}</span>
                {idioma === l.code && <Check size={18} className="text-cnc-amber" />}
              </button>
            ))}
          </div>
        </section>

        <section>
          <h2 className="mb-2 px-1 text-xs font-bold uppercase tracking-wider text-gray-500">
            {t('config.sobre')}
          </h2>
          <div className="rounded-2xl border border-black/[0.06] bg-white p-4 shadow-sm">
            <p className="font-bold text-cnc-dark">
              CNC<span className="text-cnc-amber">IA</span> — Assistente CNC
            </p>
            <p className="mt-1 text-sm text-gray-600">
              {t('config.versao')} 1.0.0
            </p>
            <p className="mt-3 text-[11px] uppercase tracking-wider text-gray-400">
              {t('app.slogan')}
            </p>
          </div>
        </section>
      </div>
    </>
  );
}
