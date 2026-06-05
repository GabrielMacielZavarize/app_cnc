import { useMemo, useState, type ReactNode } from 'react';
import { Calculator } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { Tabs } from '@/components/ui/Tabs';

const PI = Math.PI;
const num = (s: string) => parseFloat(s.replace(',', '.')) || 0;
const fmt = (v: number, casas = 1) =>
  Number.isFinite(v) ? v.toLocaleString('pt-BR', { maximumFractionDigits: casas }) : '—';

const ABAS = [
  { key: 'rpm', label: 'RPM' },
  { key: 'avanco', label: 'Avanço' },
  { key: 'potencia', label: 'Potência' },
  { key: 'tempo', label: 'Tempo' },
  { key: 'rosca', label: 'Rosca' },
  { key: 'forca', label: 'Força' },
  { key: 'vida', label: 'Vida' },
  { key: 'furos', label: 'Furos' },
];

export function Calculadora() {
  const [aba, setAba] = useState('rpm');
  return (
    <>
      <TopBar title="Calculadora CNC" subtitle="Parâmetros de corte" icon={Calculator} back />
      <div className="border-b border-black/5 bg-white px-2">
        <Tabs tabs={ABAS} active={aba} onChange={setAba} />
      </div>
      <div className="p-4">
        {aba === 'rpm' && <AbaRpm />}
        {aba === 'avanco' && <AbaAvanco />}
        {aba === 'potencia' && <AbaPotencia />}
        {aba === 'tempo' && <AbaTempo />}
        {aba === 'rosca' && <AbaRosca />}
        {aba === 'forca' && <AbaForca />}
        {aba === 'vida' && <AbaVida />}
        {aba === 'furos' && <AbaFuros />}
      </div>
    </>
  );
}

// ── componentes base ───────────────────────────────────────────
function Campo({
  label,
  unidade,
  value,
  onChange,
}: {
  label: string;
  unidade?: string;
  value: string;
  onChange: (v: string) => void;
}) {
  return (
    <label className="block">
      <span className="mb-1 block text-xs font-medium text-gray-500">{label}</span>
      <div className="flex items-center rounded-xl border border-black/10 bg-white px-3 py-2.5 focus-within:border-cnc-amber">
        <input
          inputMode="decimal"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          className="min-w-0 flex-1 bg-transparent text-sm text-cnc-dark outline-none"
        />
        {unidade && <span className="ml-2 text-xs text-gray-400">{unidade}</span>}
      </div>
    </label>
  );
}

function Resultado({ label, valor, unidade }: { label: string; valor: string; unidade: string }) {
  return (
    <div className="rounded-2xl bg-cnc-dark p-4 text-white">
      <p className="text-xs uppercase tracking-wider text-gray-400">{label}</p>
      <p className="mt-1">
        <span className="text-3xl font-bold text-cnc-amber">{valor}</span>
        <span className="ml-2 text-sm text-gray-300">{unidade}</span>
      </p>
    </div>
  );
}

function Formula({ children }: { children: ReactNode }) {
  return (
    <p className="rounded-lg bg-gray-100 px-3 py-2 text-center font-mono text-xs text-gray-500">{children}</p>
  );
}

function Bloco({ children }: { children: ReactNode }) {
  return <div className="space-y-3">{children}</div>;
}

// ── abas ───────────────────────────────────────────────────────
function AbaRpm() {
  const [vc, setVc] = useState('100');
  const [d, setD] = useState('50');
  const rpm = useMemo(() => (num(vc) * 1000) / (PI * num(d)), [vc, d]);
  return (
    <Bloco>
      <Resultado label="Rotação do eixo-árvore" valor={fmt(rpm, 0)} unidade="RPM" />
      <Formula>n = (Vc × 1000) ÷ (π × D)</Formula>
      <Campo label="Velocidade de corte (Vc)" unidade="m/min" value={vc} onChange={setVc} />
      <Campo label="Diâmetro (D)" unidade="mm" value={d} onChange={setD} />
    </Bloco>
  );
}

function AbaAvanco() {
  const [fz, setFz] = useState('0.1');
  const [z, setZ] = useState('4');
  const [rpm, setRpm] = useState('1000');
  const vf = useMemo(() => num(fz) * num(z) * num(rpm), [fz, z, rpm]);
  return (
    <Bloco>
      <Resultado label="Avanço da mesa (Vf)" valor={fmt(vf, 0)} unidade="mm/min" />
      <Formula>Vf = fz × Z × n</Formula>
      <Campo label="Avanço por dente (fz)" unidade="mm" value={fz} onChange={setFz} />
      <Campo label="Número de dentes (Z)" unidade="" value={z} onChange={setZ} />
      <Campo label="Rotação (n)" unidade="RPM" value={rpm} onChange={setRpm} />
    </Bloco>
  );
}

function AbaPotencia() {
  const [kc, setKc] = useState('2000');
  const [ap, setAp] = useState('3');
  const [ae, setAe] = useState('10');
  const [vf, setVf] = useState('400');
  // Pc = (ap × ae × vf × kc) / (60 × 10^6)  [kW]
  const pc = useMemo(() => (num(ap) * num(ae) * num(vf) * num(kc)) / (60 * 1e6), [ap, ae, vf, kc]);
  return (
    <Bloco>
      <Resultado label="Potência de corte (Pc)" valor={fmt(pc, 2)} unidade="kW" />
      <Formula>Pc = (ap × ae × Vf × Kc) ÷ (60·10⁶)</Formula>
      <Campo label="Força específica de corte (Kc)" unidade="N/mm²" value={kc} onChange={setKc} />
      <Campo label="Profundidade (ap)" unidade="mm" value={ap} onChange={setAp} />
      <Campo label="Largura de corte (ae)" unidade="mm" value={ae} onChange={setAe} />
      <Campo label="Avanço da mesa (Vf)" unidade="mm/min" value={vf} onChange={setVf} />
    </Bloco>
  );
}

function AbaTempo() {
  const [l, setL] = useState('100');
  const [vf, setVf] = useState('400');
  const [passes, setPasses] = useState('1');
  const tMin = useMemo(() => (num(l) * num(passes)) / num(vf), [l, vf, passes]);
  return (
    <Bloco>
      <Resultado label="Tempo de corte" valor={fmt(tMin, 2)} unidade="min" />
      <Formula>t = (L × passes) ÷ Vf</Formula>
      <p className="text-center text-xs text-gray-500">≈ {fmt(tMin * 60, 0)} segundos</p>
      <Campo label="Comprimento de corte (L)" unidade="mm" value={l} onChange={setL} />
      <Campo label="Avanço da mesa (Vf)" unidade="mm/min" value={vf} onChange={setVf} />
      <Campo label="Número de passes" unidade="" value={passes} onChange={setPasses} />
    </Bloco>
  );
}

function AbaRosca() {
  const [d, setD] = useState('10');
  const [p, setP] = useState('1.5');
  const broca = useMemo(() => num(d) - num(p), [d, p]);
  const menor = useMemo(() => num(d) - 1.0825 * num(p), [d, p]);
  return (
    <Bloco>
      <Resultado label="Diâmetro da broca (furo)" valor={fmt(broca, 2)} unidade="mm" />
      <Formula>Ø broca = D − passo</Formula>
      <div className="rounded-xl bg-white p-3 text-sm shadow-sm">
        <div className="flex justify-between">
          <span className="text-gray-500">Diâmetro menor (raiz)</span>
          <span className="font-semibold text-cnc-dark">{fmt(menor, 3)} mm</span>
        </div>
      </div>
      <Campo label="Diâmetro nominal da rosca (D)" unidade="mm" value={d} onChange={setD} />
      <Campo label="Passo (P)" unidade="mm" value={p} onChange={setP} />
    </Bloco>
  );
}

function AbaForca() {
  const [kc, setKc] = useState('2000');
  const [ap, setAp] = useState('3');
  const [fz, setFz] = useState('0.1');
  // Fc = Kc × ap × fz  (seção de cavaco)
  const fc = useMemo(() => num(kc) * num(ap) * num(fz), [kc, ap, fz]);
  return (
    <Bloco>
      <Resultado label="Força de corte (Fc)" valor={fmt(fc, 0)} unidade="N" />
      <Formula>Fc = Kc × ap × fz</Formula>
      <Campo label="Força específica de corte (Kc)" unidade="N/mm²" value={kc} onChange={setKc} />
      <Campo label="Profundidade (ap)" unidade="mm" value={ap} onChange={setAp} />
      <Campo label="Avanço por dente (fz)" unidade="mm" value={fz} onChange={setFz} />
    </Bloco>
  );
}

function AbaVida() {
  const [vc, setVc] = useState('120');
  const [c, setC] = useState('250');
  const [n, setN] = useState('0.25');
  // Taylor: Vc × T^n = C  →  T = (C / Vc)^(1/n)
  const t = useMemo(() => Math.pow(num(c) / num(vc), 1 / num(n)), [vc, c, n]);
  return (
    <Bloco>
      <Resultado label="Vida estimada da ferramenta (T)" valor={fmt(t, 1)} unidade="min" />
      <Formula>Vc × Tⁿ = C (Taylor)</Formula>
      <Campo label="Velocidade de corte (Vc)" unidade="m/min" value={vc} onChange={setVc} />
      <Campo label="Constante de Taylor (C)" unidade="" value={c} onChange={setC} />
      <Campo label="Expoente (n)" unidade="" value={n} onChange={setN} />
      <p className="text-center text-[11px] text-gray-400">
        n típico: 0,1–0,2 (HSS) · 0,2–0,4 (metal duro) · 0,4–0,6 (cerâmica)
      </p>
    </Bloco>
  );
}

function AbaFuros() {
  const [d, setD] = useState('100');
  const [qtd, setQtd] = useState('6');
  const [ang0, setAng0] = useState('0');
  const furos = useMemo(() => {
    const n = Math.max(1, Math.round(num(qtd)));
    const r = num(d) / 2;
    return Array.from({ length: n }, (_, i) => {
      const ang = (num(ang0) + (i * 360) / n) * (PI / 180);
      return { i: i + 1, x: r * Math.cos(ang), y: r * Math.sin(ang) };
    });
  }, [d, qtd, ang0]);
  return (
    <Bloco>
      <Formula>X = R·cos(θ) · Y = R·sen(θ)</Formula>
      <div className="grid grid-cols-3 gap-2">
        <Campo label="Ø do círculo" unidade="mm" value={d} onChange={setD} />
        <Campo label="Nº de furos" unidade="" value={qtd} onChange={setQtd} />
        <Campo label="Ângulo inicial" unidade="°" value={ang0} onChange={setAng0} />
      </div>
      <div className="overflow-hidden rounded-2xl border border-black/[0.06] bg-white shadow-sm">
        <div className="grid grid-cols-3 bg-gray-50 px-4 py-2 text-xs font-bold uppercase tracking-wide text-gray-400">
          <span>Furo</span>
          <span className="text-right">X</span>
          <span className="text-right">Y</span>
        </div>
        {furos.map((f) => (
          <div key={f.i} className="grid grid-cols-3 border-t border-black/[0.05] px-4 py-2 text-sm">
            <span className="font-semibold text-cnc-dark">#{f.i}</span>
            <span className="text-right font-mono text-gray-700">{fmt(f.x, 3)}</span>
            <span className="text-right font-mono text-gray-700">{fmt(f.y, 3)}</span>
          </div>
        ))}
      </div>
    </Bloco>
  );
}
