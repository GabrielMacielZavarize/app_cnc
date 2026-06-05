import { useState } from 'react';
import { Waves } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { Tabs } from '@/components/ui/Tabs';
import { Badge } from '@/components/ui/Badge';

interface Grau {
  n: string;
  ra: number;
  desc: string;
}

// Graus de rugosidade N e Ra correspondente (ISO 1302).
const GRAUS: Grau[] = [
  { n: 'N1', ra: 0.025, desc: 'Espelhado — superfície óptica' },
  { n: 'N2', ra: 0.05, desc: 'Espelhado' },
  { n: 'N3', ra: 0.1, desc: 'Polido fino' },
  { n: 'N4', ra: 0.2, desc: 'Polido' },
  { n: 'N5', ra: 0.4, desc: 'Retificado fino' },
  { n: 'N6', ra: 0.8, desc: 'Retificado / mandrilado fino' },
  { n: 'N7', ra: 1.6, desc: 'Acabamento fino (torno/fresa)' },
  { n: 'N8', ra: 3.2, desc: 'Acabamento normal' },
  { n: 'N9', ra: 6.3, desc: 'Semi-acabamento' },
  { n: 'N10', ra: 12.5, desc: 'Desbaste' },
  { n: 'N11', ra: 25, desc: 'Desbaste grosseiro' },
  { n: 'N12', ra: 50, desc: 'Bruto / fundição' },
];

const PROCESSOS = [
  { nome: 'Lapidação / Brunimento', ra: '0,025–0,2', n: 'N1–N4' },
  { nome: 'Retificação fina', ra: '0,1–0,4', n: 'N4–N5' },
  { nome: 'Retificação', ra: '0,4–1,6', n: 'N5–N7' },
  { nome: 'Mandrilamento fino', ra: '0,4–1,6', n: 'N5–N7' },
  { nome: 'Torneamento (acabamento)', ra: '0,8–3,2', n: 'N6–N8' },
  { nome: 'Fresamento (acabamento)', ra: '0,8–3,2', n: 'N6–N8' },
  { nome: 'Furação', ra: '1,6–6,3', n: 'N7–N9' },
  { nome: 'Eletroerosão (EDM)', ra: '0,4–6,3', n: 'N5–N9' },
  { nome: 'Torneamento (desbaste)', ra: '3,2–12,5', n: 'N8–N10' },
  { nome: 'Fresamento (desbaste)', ra: '3,2–12,5', n: 'N8–N10' },
  { nome: 'Serramento', ra: '6,3–25', n: 'N9–N11' },
  { nome: 'Fundição / Forjamento', ra: '12,5–50', n: 'N10–N12' },
];

const LOG_MIN = Math.log10(0.025);
const LOG_MAX = Math.log10(50);

function corGrau(ra: number): string {
  if (ra <= 0.2) return '#0F6E56';
  if (ra <= 3.2) return '#E8A020';
  return '#D94040';
}

export function Acabamento() {
  const [aba, setAba] = useState('graus');

  return (
    <>
      <TopBar title="Acabamento Superficial" subtitle="Ra / Rz · graus N" icon={Waves} back />

      <div className="space-y-3 p-4">
        <Tabs
          tabs={[
            { key: 'graus', label: 'Graus N' },
            { key: 'processos', label: 'Por processo' },
          ]}
          active={aba}
          onChange={setAba}
        />

        {aba === 'graus' ? (
          <div className="space-y-2">
            {GRAUS.map((g) => {
              const cor = corGrau(g.ra);
              const pct = ((Math.log10(g.ra) - LOG_MIN) / (LOG_MAX - LOG_MIN)) * 100;
              return (
                <div key={g.n} className="rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm">
                  <div className="flex items-center gap-3">
                    <span className="w-9 shrink-0 font-bold text-cnc-dark">{g.n}</span>
                    <div className="min-w-0 flex-1">
                      <p className="text-sm text-gray-700">{g.desc}</p>
                      <div className="mt-1.5 h-1.5 w-full overflow-hidden rounded-full bg-gray-100">
                        <div className="h-full rounded-full" style={{ width: `${pct}%`, background: cor }} />
                      </div>
                    </div>
                    <span className="shrink-0 text-right">
                      <span className="font-mono text-sm font-semibold" style={{ color: cor }}>
                        {g.ra.toString().replace('.', ',')}
                      </span>
                      <span className="block text-[10px] text-gray-400">Ra µm</span>
                    </span>
                  </div>
                </div>
              );
            })}
            <p className="px-1 text-[11px] text-gray-400">Rz ≈ 4 a 7 × Ra (depende do processo).</p>
          </div>
        ) : (
          <div className="overflow-hidden rounded-2xl border border-black/[0.06] bg-white shadow-sm">
            <div className="grid grid-cols-[1fr_auto_auto] gap-3 bg-gray-50 px-4 py-2 text-[10px] font-bold uppercase tracking-wide text-gray-400">
              <span>Processo</span>
              <span className="text-right">Ra (µm)</span>
              <span className="text-right">Grau N</span>
            </div>
            {PROCESSOS.map((p) => (
              <div
                key={p.nome}
                className="grid grid-cols-[1fr_auto_auto] items-center gap-3 border-t border-black/[0.05] px-4 py-2.5"
              >
                <span className="text-sm text-gray-700">{p.nome}</span>
                <span className="text-right font-mono text-sm text-cnc-dark">{p.ra}</span>
                <span className="text-right">
                  <Badge color="#185FA5">{p.n}</Badge>
                </span>
              </div>
            ))}
          </div>
        )}
      </div>
    </>
  );
}
