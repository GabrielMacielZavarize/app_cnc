import { useMemo, useState } from 'react';
import { History, Plus, Trash2 } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { EmptyState } from '@/components/ui/EmptyState';
import { BottomSheet } from '@/components/ui/BottomSheet';
import { Field } from '@/components/ui/Field';
import { useSetupsStore, type Setup } from '@/stores/setups';
import { tempoRelativo } from '@/lib/format';
import { cx } from '@/lib/cx';

const VAZIO = {
  maquina: '',
  numeroProg: '',
  nomePeca: '',
  operacao: '',
  material: '',
  offsetX: '',
  offsetY: '',
  offsetZ: '',
  ferramentas: '',
  observacoes: '',
};

export function SetupHistorico() {
  const setups = useSetupsStore((s) => s.setups);
  const add = useSetupsStore((s) => s.add);
  const update = useSetupsStore((s) => s.update);
  const remove = useSetupsStore((s) => s.remove);

  const [filtro, setFiltro] = useState('Todas');
  const [edicao, setEdicao] = useState<Setup | 'nova' | null>(null);
  const [f, setF] = useState(VAZIO);
  const set = (k: keyof typeof VAZIO) => (v: string) => setF((p) => ({ ...p, [k]: v }));

  const maquinas = useMemo(() => ['Todas', ...new Set(setups.map((s) => s.maquina).filter(Boolean))], [setups]);
  const lista = useMemo(
    () => (filtro === 'Todas' ? setups : setups.filter((s) => s.maquina === filtro)),
    [setups, filtro],
  );

  function abrirNova() {
    setF(VAZIO);
    setEdicao('nova');
  }
  function abrirEdicao(s: Setup) {
    setF({ ...VAZIO, ...s });
    setEdicao(s);
  }
  function salvar() {
    if (!f.nomePeca.trim() && !f.maquina.trim()) return;
    if (edicao === 'nova') add(f);
    else if (edicao) update(edicao.id, f);
    setEdicao(null);
  }

  return (
    <>
      <TopBar
        title="Histórico de Setup"
        subtitle="Offsets e ferramentas"
        icon={History}
        back
        right={
          <button type="button" onClick={abrirNova} className="rounded-full p-1.5 text-white/90 hover:bg-white/10" aria-label="Novo setup">
            <Plus size={20} />
          </button>
        }
      />

      <div className="space-y-3 p-4">
        {maquinas.length > 1 && (
          <div className="no-scrollbar -mx-4 flex gap-2 overflow-x-auto px-4">
            {maquinas.map((m) => (
              <button
                key={m}
                type="button"
                onClick={() => setFiltro(m)}
                className={cx(
                  'whitespace-nowrap rounded-full border px-3 py-1 text-xs font-medium transition',
                  filtro === m ? 'border-cnc-amber bg-cnc-amber/15 text-cnc-amberDark' : 'border-black/10 bg-white text-gray-500',
                )}
              >
                {m}
              </button>
            ))}
          </div>
        )}

        {lista.length === 0 ? (
          <EmptyState icon={History} title="Nenhum setup salvo" subtitle="Toque em + para registrar offsets e ferramentas." />
        ) : (
          <div className="space-y-2">
            {lista.map((s) => (
              <div key={s.id} onClick={() => abrirEdicao(s)} className="cursor-pointer rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm">
                <div className="flex items-center justify-between gap-2">
                  <span className="truncate text-sm font-semibold text-cnc-dark">{s.nomePeca || '(sem peça)'}</span>
                  <span className="shrink-0 text-[11px] text-gray-400">{tempoRelativo(s.criadoEm)}</span>
                </div>
                <p className="text-xs text-gray-500">
                  {s.maquina} {s.numeroProg && `· ${s.numeroProg}`} {s.operacao && `· ${s.operacao}`}
                </p>
                {(s.offsetX || s.offsetY || s.offsetZ) && (
                  <p className="mt-1 font-mono text-[11px] text-cnc-blue">
                    G54 X{s.offsetX || '—'} Y{s.offsetY || '—'} Z{s.offsetZ || '—'}
                  </p>
                )}
              </div>
            ))}
          </div>
        )}
      </div>

      <BottomSheet open={edicao !== null} onClose={() => setEdicao(null)} title={edicao === 'nova' ? 'Novo setup' : 'Editar setup'}>
        <div className="space-y-3">
          <div className="grid grid-cols-2 gap-3">
            <Field label="Máquina" value={f.maquina} onChange={set('maquina')} placeholder="Centro 01" />
            <Field label="Programa" value={f.numeroProg} onChange={set('numeroProg')} placeholder="O1234" />
          </div>
          <Field label="Peça" value={f.nomePeca} onChange={set('nomePeca')} placeholder="Ex.: Flange Ø120" />
          <div className="grid grid-cols-2 gap-3">
            <Field label="Operação" value={f.operacao} onChange={set('operacao')} placeholder="Desbaste" />
            <Field label="Material" value={f.material} onChange={set('material')} placeholder="Aço 1045" />
          </div>
          <div>
            <span className="mb-1 block text-xs font-medium text-gray-500">Offsets G54 (mm)</span>
            <div className="grid grid-cols-3 gap-3">
              <Field label="X" value={f.offsetX} onChange={set('offsetX')} inputMode="decimal" />
              <Field label="Y" value={f.offsetY} onChange={set('offsetY')} inputMode="decimal" />
              <Field label="Z" value={f.offsetZ} onChange={set('offsetZ')} inputMode="decimal" />
            </div>
          </div>
          <label className="block">
            <span className="mb-1 block text-xs font-medium text-gray-500">Ferramentas</span>
            <textarea
              value={f.ferramentas}
              onChange={(e) => set('ferramentas')(e.target.value)}
              rows={3}
              placeholder={'T1 Fresa Ø10 H01\nT2 Broca Ø8 H02'}
              className="w-full rounded-xl border border-black/10 bg-white px-3 py-2.5 font-mono text-xs text-cnc-dark outline-none focus:border-cnc-amber"
            />
          </label>
          <Field label="Observações" value={f.observacoes} onChange={set('observacoes')} />
          <div className="flex gap-2 pt-1">
            <button type="button" onClick={salvar} className="flex-1 rounded-xl bg-cnc-dark py-3 text-sm font-semibold text-white">
              Salvar
            </button>
            {edicao !== 'nova' && edicao && (
              <button
                type="button"
                onClick={() => {
                  remove(edicao.id);
                  setEdicao(null);
                }}
                className="flex items-center justify-center rounded-xl bg-cnc-red/10 px-4 text-cnc-red"
                aria-label="Excluir"
              >
                <Trash2 size={18} />
              </button>
            )}
          </div>
        </div>
      </BottomSheet>
    </>
  );
}
