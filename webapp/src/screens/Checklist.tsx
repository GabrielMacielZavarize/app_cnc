import { useMemo, useState } from 'react';
import { Check, CheckSquare, RotateCcw } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { checklistItens } from '@/data/checklist';
import { useChecklistStore } from '@/stores/checklist';
import { cx } from '@/lib/cx';

const COR_CAT: Record<string, string> = {
  'Pré-Partida': '#185FA5',
  'Referência e Setup': '#534AB7',
  'Primeiro Ciclo': '#0F6E56',
  'Durante a Operação': '#E8A020',
  Inspeção: '#BA7517',
  'Fim de Turno': '#A32D2D',
};

const CATEGORIAS = ['Todos', ...[...new Set(checklistItens.map((i) => i.categoria))]];

export function Checklist() {
  const [cat, setCat] = useState('Todos');
  const concluidos = useChecklistStore((s) => s.concluidos);
  const toggle = useChecklistStore((s) => s.toggle);
  const reset = useChecklistStore((s) => s.reset);

  const lista = useMemo(
    () => (cat === 'Todos' ? checklistItens : checklistItens.filter((i) => i.categoria === cat)),
    [cat],
  );

  const total = checklistItens.length;
  const feitos = concluidos.length;
  const pct = total > 0 ? (feitos / total) * 100 : 0;

  return (
    <>
      <TopBar
        title="Checklist do Operador"
        subtitle={`${feitos}/${total} concluído`}
        icon={CheckSquare}
        back
        right={
          <button type="button" onClick={reset} className="rounded-full p-1.5 text-white/80 hover:bg-white/10" aria-label="Reiniciar">
            <RotateCcw size={18} />
          </button>
        }
      />

      <div className="bg-cnc-dark px-4 pb-3">
        <div className="h-1.5 w-full overflow-hidden rounded-full bg-white/10">
          <div className="h-full rounded-full bg-cnc-amber transition-all" style={{ width: `${pct}%` }} />
        </div>
      </div>

      <div className="space-y-3 p-4">
        <div className="no-scrollbar -mx-4 flex gap-2 overflow-x-auto px-4">
          {CATEGORIAS.map((c) => (
            <button
              key={c}
              type="button"
              onClick={() => setCat(c)}
              className={cx(
                'whitespace-nowrap rounded-full border px-3 py-1 text-xs font-medium transition',
                cat === c ? 'border-cnc-amber bg-cnc-amber/15 text-cnc-amberDark' : 'border-black/10 bg-white text-gray-500',
              )}
            >
              {c}
            </button>
          ))}
        </div>

        <div className="space-y-2">
          {lista.map((item) => {
            const feito = concluidos.includes(item.titulo);
            const cor = COR_CAT[item.categoria] ?? '#185FA5';
            return (
              <button
                key={item.titulo}
                type="button"
                onClick={() => toggle(item.titulo)}
                className="flex w-full items-start gap-3 rounded-2xl border border-black/[0.06] bg-white p-3 text-left shadow-sm"
              >
                <span
                  className={cx(
                    'mt-0.5 flex h-6 w-6 shrink-0 items-center justify-center rounded-md border-2 transition',
                    feito ? 'border-cnc-green bg-cnc-green text-white' : 'border-gray-300',
                  )}
                >
                  {feito && <Check size={15} strokeWidth={3} />}
                </span>
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2">
                    <span className="text-base">{item.icone}</span>
                    <span className={cx('text-sm font-semibold', feito ? 'text-gray-400 line-through' : 'text-cnc-dark')}>
                      {item.titulo}
                    </span>
                  </div>
                  <p className={cx('mt-0.5 text-xs leading-relaxed', feito ? 'text-gray-300' : 'text-gray-500')}>
                    {item.detalhe}
                  </p>
                  <span className="mt-1 inline-block text-[10px] font-semibold uppercase tracking-wide" style={{ color: cor }}>
                    {item.categoria}
                  </span>
                </div>
              </button>
            );
          })}
        </div>
      </div>
    </>
  );
}
