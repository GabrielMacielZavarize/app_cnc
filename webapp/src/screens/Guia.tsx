import { useMemo, useState } from 'react';
import { ChevronDown, Lightbulb } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { SearchBar } from '@/components/ui/SearchBar';
import { Tabs } from '@/components/ui/Tabs';
import { Badge } from '@/components/ui/Badge';
import { GcodeView } from '@/components/ui/GcodeView';
import { problemas, equivalencias, grupos } from '@/data/guia';
import { norm } from '@/lib/busca';
import { cx } from '@/lib/cx';

export function Guia() {
  const [aba, setAba] = useState('problemas');
  return (
    <>
      <TopBar title="Guia do Operador" subtitle="Dicas e boas práticas" icon={Lightbulb} back />
      <div className="space-y-3 p-4">
        <Tabs
          tabs={[
            { key: 'problemas', label: 'Por problema' },
            { key: 'equivalencias', label: 'Equivalências' },
            { key: 'enderecos', label: 'Endereços' },
          ]}
          active={aba}
          onChange={setAba}
        />
        {aba === 'problemas' && <AbaProblemas />}
        {aba === 'equivalencias' && <AbaEquivalencias />}
        {aba === 'enderecos' && <AbaEnderecos />}
      </div>
    </>
  );
}

function AbaProblemas() {
  const [busca, setBusca] = useState('');
  const [aberto, setAberto] = useState<number | null>(0);

  const lista = useMemo(() => {
    const q = norm(busca.trim());
    if (!q) return problemas;
    return problemas.filter(
      (p) => norm(p.problema).includes(q) || norm(p.solucao).includes(q) || p.tags.some((t) => norm(t).includes(q)),
    );
  }, [busca]);

  return (
    <div className="space-y-3">
      <SearchBar value={busca} onChange={setBusca} placeholder="Buscar problema (ex: rosca, furo profundo)..." />
      <div className="space-y-2">
        {lista.map((p, i) => {
          const aberta = aberto === i;
          return (
            <div key={p.problema} className="overflow-hidden rounded-2xl border border-black/[0.06] bg-white shadow-sm">
              <button
                type="button"
                onClick={() => setAberto(aberta ? null : i)}
                className="flex w-full items-center gap-3 p-3 text-left"
              >
                <div
                  className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg"
                  style={{ background: `${p.cor}1A`, color: p.cor }}
                >
                  <Lightbulb size={18} />
                </div>
                <span className="min-w-0 flex-1 text-sm font-semibold text-cnc-dark">{p.problema}</span>
                <ChevronDown size={18} className={cx('shrink-0 text-gray-400 transition', aberta && 'rotate-180')} />
              </button>
              {aberta && (
                <div className="space-y-3 border-t border-black/[0.05] px-3 py-3">
                  <p className="text-sm leading-relaxed text-gray-700">{p.solucao}</p>
                  {p.codigo && <GcodeView code={p.codigo} />}
                  <div className="rounded-xl bg-amber-50 p-3">
                    <p className="text-xs font-bold uppercase tracking-wide text-cnc-amberDark">💡 Dica</p>
                    <p className="mt-1 text-sm leading-relaxed text-amber-900">{p.dica}</p>
                  </div>
                  <div className="space-y-1">
                    {Object.entries(p.comandos).map(([fab, cmd]) => (
                      <div key={fab} className="flex gap-2 text-xs">
                        <span className="w-16 shrink-0 font-bold text-cnc-blue">{fab}</span>
                        <span className="font-mono text-gray-600">{cmd}</span>
                      </div>
                    ))}
                  </div>
                  <div className="flex flex-wrap gap-1.5">
                    {p.tags.map((t) => (
                      <span key={t} className="rounded-md bg-gray-100 px-2 py-0.5 text-[11px] text-gray-500">
                        {t}
                      </span>
                    ))}
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}

function AbaEquivalencias() {
  const [busca, setBusca] = useState('');
  const lista = useMemo(() => {
    const q = norm(busca.trim());
    if (!q) return equivalencias;
    return equivalencias.filter(
      (e) => e.operacao.startsWith('──') || norm(e.operacao).includes(q) || norm(e.descricao).includes(q),
    );
  }, [busca]);

  return (
    <div className="space-y-3">
      <SearchBar value={busca} onChange={setBusca} placeholder="Buscar operação..." />
      <div className="overflow-hidden rounded-2xl border border-black/[0.06] bg-white shadow-sm">
        <div className="grid grid-cols-[1.6fr_1fr_1fr_1fr] gap-2 bg-cnc-dark px-3 py-2 text-[10px] font-bold uppercase tracking-wide text-gray-300">
          <span>Operação</span>
          <span>Fanuc</span>
          <span>Siemens</span>
          <span>Haas</span>
        </div>
        {lista.map((e, i) => {
          if (e.operacao.startsWith('──')) {
            return (
              <div key={i} className="bg-gray-50 px-3 py-1.5 text-[11px] font-bold uppercase tracking-wide text-gray-400">
                {e.operacao.replace(/──/g, '').trim()}
              </div>
            );
          }
          return (
            <div key={i} className="grid grid-cols-[1.6fr_1fr_1fr_1fr] gap-2 border-t border-black/[0.05] px-3 py-2 text-xs">
              <span className="text-gray-700">{e.operacao}</span>
              <span className="font-mono text-cnc-blue">{e.fanuc}</span>
              <span className="font-mono text-cnc-green">{e.siemens}</span>
              <span className="font-mono text-cnc-amberDark">{e.haas}</span>
            </div>
          );
        })}
      </div>
    </div>
  );
}

function AbaEnderecos() {
  return (
    <div className="space-y-4">
      {grupos.map((g) => (
        <div key={g.nome}>
          <div className="mb-1.5 flex items-center gap-2">
            <span className="h-3 w-3 rounded-full" style={{ background: g.cor }} />
            <h3 className="text-xs font-bold uppercase tracking-wide text-gray-500">{g.nome}</h3>
          </div>
          <div className="overflow-hidden rounded-2xl border border-black/[0.06] bg-white shadow-sm">
            {g.enderecos.map((e, i) => (
              <div key={e.letra + i} className={cx('flex gap-3 px-3 py-2.5', i > 0 && 'border-t border-black/[0.05]')}>
                <span
                  className="flex h-7 w-7 shrink-0 items-center justify-center rounded-md font-mono text-sm font-bold text-white"
                  style={{ background: g.cor }}
                >
                  {e.letra}
                </span>
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2">
                    <span className="text-sm font-semibold text-cnc-dark">{e.nome}</span>
                    <Badge color="#6B7280">{e.maquina}</Badge>
                  </div>
                  <p className="mt-0.5 text-xs leading-relaxed text-gray-500">{e.descricao}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      ))}
    </div>
  );
}
