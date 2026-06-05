import { useMemo, useState } from 'react';
import { Ruler } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { AJUSTES_COMUNS, GRAUS_IT, linhaIT, valorIT, type Ajuste } from '@/lib/iso286';
import { cx } from '@/lib/cx';

const num = (s: string) => parseFloat(s.replace(',', '.')) || 0;

const COR_TIPO: Record<Ajuste['tipo'], string> = {
  Folga: '#185FA5',
  Incerto: '#E8A020',
  Interferência: '#D94040',
};

export function Tolerancias() {
  const [diametro, setDiametro] = useState('50');
  const [grau, setGrau] = useState(7);

  const d = num(diametro);
  const it = useMemo(() => valorIT(d, grau), [d, grau]);
  const linha = useMemo(() => linhaIT(d), [d]);

  return (
    <>
      <TopBar title="Tolerâncias ISO" subtitle="ISO 286 — graus IT" icon={Ruler} back />

      <div className="space-y-4 p-4">
        <div className="grid grid-cols-2 gap-3">
          <label className="block">
            <span className="mb-1 block text-xs font-medium text-gray-500">Diâmetro nominal</span>
            <div className="flex items-center rounded-xl border border-black/10 bg-white px-3 py-2.5 focus-within:border-cnc-amber">
              <input
                inputMode="decimal"
                value={diametro}
                onChange={(e) => setDiametro(e.target.value)}
                className="min-w-0 flex-1 bg-transparent text-sm text-cnc-dark outline-none"
              />
              <span className="ml-2 text-xs text-gray-400">mm</span>
            </div>
          </label>
          <label className="block">
            <span className="mb-1 block text-xs font-medium text-gray-500">Grau de tolerância</span>
            <select
              value={grau}
              onChange={(e) => setGrau(Number(e.target.value))}
              className="w-full rounded-xl border border-black/10 bg-white px-3 py-2.5 text-sm text-cnc-dark outline-none focus:border-cnc-amber"
            >
              {GRAUS_IT.map((g) => (
                <option key={g} value={g}>
                  IT{g}
                </option>
              ))}
            </select>
          </label>
        </div>

        <div className="rounded-2xl bg-cnc-dark p-4 text-white">
          <p className="text-xs uppercase tracking-wider text-gray-400">
            Tolerância IT{grau} para Ø{d || '—'} mm
          </p>
          {it === null ? (
            <p className="mt-1 text-sm text-gray-300">Diâmetro fora da faixa (0–500 mm).</p>
          ) : (
            <p className="mt-1">
              <span className="text-3xl font-bold text-cnc-amber">{it}</span>
              <span className="ml-2 text-sm text-gray-300">µm</span>
              <span className="ml-3 text-sm text-gray-400">= {(it / 1000).toFixed(3)} mm</span>
            </p>
          )}
        </div>

        {linha.length > 0 && (
          <div>
            <p className="mb-1.5 text-xs font-bold uppercase tracking-wide text-gray-400">
              Todos os graus para Ø{d} mm (µm)
            </p>
            <div className="no-scrollbar overflow-x-auto rounded-xl border border-black/[0.06] bg-white">
              <div className="flex min-w-max">
                {linha.map(({ grau: g, um }) => (
                  <button
                    key={g}
                    type="button"
                    onClick={() => setGrau(g)}
                    className={cx(
                      'flex w-16 flex-col items-center border-r border-black/[0.05] py-2 last:border-0',
                      g === grau ? 'bg-cnc-amber/15' : '',
                    )}
                  >
                    <span className="text-[11px] font-bold text-cnc-blue">IT{g}</span>
                    <span className="mt-0.5 text-sm text-cnc-dark">{um}</span>
                  </button>
                ))}
              </div>
            </div>
          </div>
        )}

        <div>
          <p className="mb-1.5 text-xs font-bold uppercase tracking-wide text-gray-400">Ajustes comuns (furo-base H)</p>
          <div className="space-y-2">
            {AJUSTES_COMUNS.map((a) => {
              const cor = COR_TIPO[a.tipo];
              return (
                <div key={a.classe} className="rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm">
                  <div className="flex items-center gap-2">
                    <span className="font-mono font-bold text-cnc-dark">{a.classe}</span>
                    <span
                      className="rounded-md px-2 py-0.5 text-[11px] font-semibold"
                      style={{ color: cor, backgroundColor: `${cor}1A` }}
                    >
                      {a.tipo}
                    </span>
                  </div>
                  <p className="mt-1 text-xs leading-relaxed text-gray-600">{a.desc}</p>
                </div>
              );
            })}
          </div>
        </div>
      </div>
    </>
  );
}
