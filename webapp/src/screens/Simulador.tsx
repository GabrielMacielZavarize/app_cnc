import { useMemo, useState } from 'react';
import { AlertTriangle, Terminal } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { parseBloco, type TipoToken } from '@/lib/gcode';
import { cx } from '@/lib/cx';

const EXEMPLO = ['G54 G90 G21', 'S2000 M03', 'G00 X0 Y0 Z5.', 'G01 Z-3. F100', 'G00 Z50. M05'].join('\n');

const COR_TIPO: Record<TipoToken, string> = {
  G: 'text-blue-600 bg-blue-50',
  M: 'text-emerald-600 bg-emerald-50',
  N: 'text-purple-600 bg-purple-50',
  endereco: 'text-cnc-amberDark bg-amber-50',
  outro: 'text-gray-600 bg-gray-100',
};

export function Simulador() {
  const [texto, setTexto] = useState(EXEMPLO);
  const linhas = useMemo(() => parseBloco(texto), [texto]);

  return (
    <>
      <TopBar title="Simulador de Bloco" subtitle="Entenda um bloco G/M" icon={Terminal} back />

      <div className="space-y-4 p-4">
        <div>
          <p className="mb-1 text-xs font-medium text-gray-500">Digite o(s) bloco(s) de programa</p>
          <textarea
            value={texto}
            onChange={(e) => setTexto(e.target.value)}
            rows={5}
            spellCheck={false}
            className="w-full rounded-xl border border-black/10 bg-cnc-dark px-3 py-3 font-mono text-sm text-gray-100 outline-none focus:border-cnc-amber"
          />
        </div>

        {linhas.length === 0 ? (
          <p className="text-center text-sm text-gray-400">Digite um bloco acima para analisar.</p>
        ) : (
          <div className="space-y-3">
            {linhas.map((linha, i) => (
              <div key={i} className="overflow-hidden rounded-2xl border border-black/[0.06] bg-white shadow-sm">
                <div className="border-b border-black/[0.05] bg-gray-50 px-3 py-2 font-mono text-sm text-cnc-dark">
                  {linha.original}
                </div>
                <div className="space-y-1.5 p-3">
                  {linha.tokens.map((tk, j) => (
                    <div key={j} className="flex items-start gap-2 text-sm">
                      <span
                        className={cx(
                          'shrink-0 rounded px-1.5 py-0.5 font-mono text-xs font-bold',
                          COR_TIPO[tk.tipo],
                        )}
                      >
                        {tk.letra}
                        {tk.valor}
                      </span>
                      <span className="leading-snug text-gray-600">{tk.descricao}</span>
                    </div>
                  ))}
                </div>
                {linha.avisos.length > 0 && (
                  <div className="space-y-1.5 border-t border-black/[0.05] bg-red-50 px-3 py-2.5">
                    {linha.avisos.map((a, k) => (
                      <p key={k} className="flex gap-2 text-xs leading-relaxed text-red-800">
                        <AlertTriangle size={14} className="mt-0.5 shrink-0 text-cnc-red" />
                        {a}
                      </p>
                    ))}
                  </div>
                )}
              </div>
            ))}
          </div>
        )}
      </div>
    </>
  );
}
