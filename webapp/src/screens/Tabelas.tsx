import { useMemo, useState } from 'react';
import { Table } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { SearchBar } from '@/components/ui/SearchBar';
import { Tabs } from '@/components/ui/Tabs';
import { roscasMetricas } from '@/data/tabelas';
import { norm } from '@/lib/busca';

const numIn = (s: string) => parseFloat(s.replace(',', '.'));

export function Tabelas() {
  const [aba, setAba] = useState('roscas');
  return (
    <>
      <TopBar title="Tabelas Técnicas" subtitle="Roscas e conversões" icon={Table} back />
      <div className="space-y-3 p-4">
        <Tabs
          tabs={[
            { key: 'roscas', label: 'Roscas Métricas' },
            { key: 'conversoes', label: 'Conversões' },
          ]}
          active={aba}
          onChange={setAba}
        />
        {aba === 'roscas' ? <AbaRoscas /> : <AbaConversoes />}
      </div>
    </>
  );
}

function AbaRoscas() {
  const [busca, setBusca] = useState('');
  const lista = useMemo(() => {
    const q = norm(busca.trim());
    if (!q) return roscasMetricas;
    return roscasMetricas.filter((r) => norm(r.nome).includes(q) || norm(r.chave).includes(q));
  }, [busca]);

  return (
    <div className="space-y-3">
      <SearchBar value={busca} onChange={setBusca} placeholder="Buscar rosca (ex: M10)..." />
      <div className="space-y-2">
        {lista.map((r) => (
          <div key={r.nome} className="rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm">
            <div className="flex items-center justify-between">
              <span className="text-base font-bold text-cnc-dark">{r.nome}</span>
              <span className="text-xs text-gray-400">passo {r.passo} mm</span>
            </div>
            <div className="mt-2 grid grid-cols-2 gap-x-4 gap-y-1 text-xs sm:grid-cols-4">
              <Item label="Broca (furo)" valor={`Ø${r.furoBroca}`} destaque />
              <Item label="Ø médio" valor={r.diametroMedio} />
              <Item label="Ø externo" valor={r.diametroExterno} />
              <Item label="Chave" valor={r.chave} />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

function Item({ label, valor, destaque }: { label: string; valor: string; destaque?: boolean }) {
  return (
    <div className="flex justify-between gap-2 sm:block">
      <span className="text-gray-400">{label}</span>
      <span className={destaque ? 'font-mono font-semibold text-cnc-amberDark' : 'font-mono text-cnc-dark'}>{valor}</span>
    </div>
  );
}

// ── Conversor de unidades ──
// Fator = quanto vale 1 unidade na unidade base.
const CATEGORIAS: Record<string, Record<string, number>> = {
  Comprimento: { mm: 1, cm: 10, m: 1000, pol: 25.4, pé: 304.8 },
  Pressão: { bar: 1, psi: 0.0689476, MPa: 0.1, kPa: 0.01, atm: 1.01325 },
  Velocidade: { 'm/min': 1, SFM: 0.3048, 'mm/s': 0.06 },
  Força: { N: 1, kgf: 9.80665, lbf: 4.44822 },
  Torque: { 'N·m': 1, 'kgf·m': 9.80665, 'lbf·ft': 1.35582 },
};

function AbaConversoes() {
  const cats = [...Object.keys(CATEGORIAS), 'Temperatura'];
  const [cat, setCat] = useState('Comprimento');
  const [valor, setValor] = useState('1');
  const v = numIn(valor);

  const unidades = cat === 'Temperatura' ? ['°C', '°F', 'K'] : Object.keys(CATEGORIAS[cat]);
  const [origem, setOrigem] = useState(unidades[0]);
  const orig = unidades.includes(origem) ? origem : unidades[0];

  const resultados = useMemo(() => {
    if (!Number.isFinite(v)) return [];
    if (cat === 'Temperatura') {
      const c = orig === '°C' ? v : orig === '°F' ? ((v - 32) * 5) / 9 : v - 273.15;
      return [
        { u: '°C', val: c },
        { u: '°F', val: (c * 9) / 5 + 32 },
        { u: 'K', val: c + 273.15 },
      ].filter((r) => r.u !== orig);
    }
    const fatores = CATEGORIAS[cat];
    const base = v * fatores[orig];
    return Object.entries(fatores)
      .filter(([u]) => u !== orig)
      .map(([u, f]) => ({ u, val: base / f }));
  }, [cat, orig, v]);

  return (
    <div className="space-y-3">
      <div className="no-scrollbar -mx-4 flex gap-2 overflow-x-auto px-4">
        {cats.map((c) => (
          <button
            key={c}
            type="button"
            onClick={() => {
              setCat(c);
              const us = c === 'Temperatura' ? ['°C', '°F', 'K'] : Object.keys(CATEGORIAS[c]);
              setOrigem(us[0]);
            }}
            className={
              cat === c
                ? 'whitespace-nowrap rounded-full border border-cnc-amber bg-cnc-amber/15 px-3 py-1 text-xs font-medium text-cnc-amberDark'
                : 'whitespace-nowrap rounded-full border border-black/10 bg-white px-3 py-1 text-xs font-medium text-gray-500'
            }
          >
            {c}
          </button>
        ))}
      </div>

      <div className="grid grid-cols-[1fr_auto] gap-2">
        <label className="block">
          <span className="mb-1 block text-xs font-medium text-gray-500">Valor</span>
          <input
            inputMode="decimal"
            value={valor}
            onChange={(e) => setValor(e.target.value)}
            className="w-full rounded-xl border border-black/10 bg-white px-3 py-2.5 text-sm text-cnc-dark outline-none focus:border-cnc-amber"
          />
        </label>
        <label className="block">
          <span className="mb-1 block text-xs font-medium text-gray-500">De</span>
          <select
            value={orig}
            onChange={(e) => setOrigem(e.target.value)}
            className="rounded-xl border border-black/10 bg-white px-3 py-2.5 text-sm text-cnc-dark outline-none focus:border-cnc-amber"
          >
            {unidades.map((u) => (
              <option key={u} value={u}>
                {u}
              </option>
            ))}
          </select>
        </label>
      </div>

      <div className="overflow-hidden rounded-2xl border border-black/[0.06] bg-white shadow-sm">
        {resultados.map((r) => (
          <div key={r.u} className="flex items-center justify-between border-b border-black/[0.05] px-4 py-2.5 last:border-0">
            <span className="text-sm text-gray-500">{r.u}</span>
            <span className="font-mono text-sm font-semibold text-cnc-dark">
              {r.val.toLocaleString('pt-BR', { maximumFractionDigits: 4 })}
            </span>
          </div>
        ))}
      </div>
    </div>
  );
}
