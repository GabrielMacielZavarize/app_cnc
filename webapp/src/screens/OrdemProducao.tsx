import { useMemo, useState } from 'react';
import { ClipboardList, Plus, Trash2 } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { EmptyState } from '@/components/ui/EmptyState';
import { BottomSheet } from '@/components/ui/BottomSheet';
import { Field, FieldWrap } from '@/components/ui/Field';
import { COR_STATUS, STATUS_ORDEM, useOrdensStore, type Ordem, type StatusOrdem } from '@/stores/ordens';
import { cx } from '@/lib/cx';

const VAZIO = {
  nomePeca: '',
  numeroProg: '',
  material: '',
  maquina: '',
  qtdTotal: '',
  qtdProduzida: '0',
  qtdRejeitada: '0',
  status: 'Pendente' as StatusOrdem,
  operador: '',
  observacao: '',
};

export function OrdemProducao() {
  const ordens = useOrdensStore((s) => s.ordens);
  const add = useOrdensStore((s) => s.add);
  const update = useOrdensStore((s) => s.update);
  const remove = useOrdensStore((s) => s.remove);

  const [filtro, setFiltro] = useState('Todas');
  const [edicao, setEdicao] = useState<Ordem | 'nova' | null>(null);
  const [f, setF] = useState(VAZIO);
  const set = (k: keyof typeof VAZIO) => (v: string) => setF((p) => ({ ...p, [k]: v }));

  const lista = useMemo(
    () => (filtro === 'Todas' ? ordens : ordens.filter((o) => o.status === filtro)),
    [ordens, filtro],
  );

  function abrirNova() {
    setF(VAZIO);
    setEdicao('nova');
  }
  function abrirEdicao(o: Ordem) {
    setF({
      nomePeca: o.nomePeca,
      numeroProg: o.numeroProg,
      material: o.material,
      maquina: o.maquina,
      qtdTotal: String(o.qtdTotal),
      qtdProduzida: String(o.qtdProduzida),
      qtdRejeitada: String(o.qtdRejeitada),
      status: o.status,
      operador: o.operador,
      observacao: o.observacao,
    });
    setEdicao(o);
  }
  function salvar() {
    if (!f.nomePeca.trim()) return;
    const dados = {
      ...f,
      qtdTotal: Number(f.qtdTotal) || 0,
      qtdProduzida: Number(f.qtdProduzida) || 0,
      qtdRejeitada: Number(f.qtdRejeitada) || 0,
    };
    if (edicao === 'nova') add(dados);
    else if (edicao) update(edicao.id, dados);
    setEdicao(null);
  }

  return (
    <>
      <TopBar
        title="Ordens de Produção"
        subtitle="Controle de peças e ciclos"
        icon={ClipboardList}
        back
        right={
          <button type="button" onClick={abrirNova} className="rounded-full p-1.5 text-white/90 hover:bg-white/10" aria-label="Nova ordem">
            <Plus size={20} />
          </button>
        }
      />

      <div className="space-y-3 p-4">
        <div className="no-scrollbar -mx-4 flex gap-2 overflow-x-auto px-4">
          {['Todas', ...STATUS_ORDEM].map((s) => (
            <button
              key={s}
              type="button"
              onClick={() => setFiltro(s)}
              className={cx(
                'whitespace-nowrap rounded-full border px-3 py-1 text-xs font-medium transition',
                filtro === s ? 'border-cnc-amber bg-cnc-amber/15 text-cnc-amberDark' : 'border-black/10 bg-white text-gray-500',
              )}
            >
              {s}
            </button>
          ))}
        </div>

        {lista.length === 0 ? (
          <EmptyState icon={ClipboardList} title="Nenhuma ordem" subtitle="Toque em + para criar uma ordem de produção." />
        ) : (
          <div className="space-y-2">
            {lista.map((o) => {
              const pct = o.qtdTotal > 0 ? Math.min(100, (o.qtdProduzida / o.qtdTotal) * 100) : 0;
              const cor = COR_STATUS[o.status];
              return (
                <div
                  key={o.id}
                  onClick={() => abrirEdicao(o)}
                  className="cursor-pointer rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm"
                >
                  <div className="flex items-center justify-between gap-2">
                    <span className="truncate text-sm font-semibold text-cnc-dark">{o.nomePeca}</span>
                    <span className="shrink-0 rounded-md px-2 py-0.5 text-[11px] font-semibold" style={{ color: cor, background: `${cor}1A` }}>
                      {o.status}
                    </span>
                  </div>
                  <p className="text-xs text-gray-500">
                    {o.numeroProg} · {o.maquina} {o.operador && `· ${o.operador}`}
                  </p>
                  <div className="mt-2 flex items-center gap-2">
                    <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-gray-100">
                      <div className="h-full rounded-full" style={{ width: `${pct}%`, background: cor }} />
                    </div>
                    <span className="shrink-0 text-xs font-medium text-gray-600">
                      {o.qtdProduzida}/{o.qtdTotal}
                      {o.qtdRejeitada > 0 && <span className="text-cnc-red"> ({o.qtdRejeitada} rej.)</span>}
                    </span>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      <BottomSheet open={edicao !== null} onClose={() => setEdicao(null)} title={edicao === 'nova' ? 'Nova ordem' : 'Editar ordem'}>
        <div className="space-y-3">
          <Field label="Nome da peça" value={f.nomePeca} onChange={set('nomePeca')} placeholder="Ex.: Flange Ø120" />
          <div className="grid grid-cols-2 gap-3">
            <Field label="Programa" value={f.numeroProg} onChange={set('numeroProg')} placeholder="O1234" />
            <Field label="Máquina" value={f.maquina} onChange={set('maquina')} placeholder="Centro 01" />
          </div>
          <Field label="Material" value={f.material} onChange={set('material')} placeholder="Aço 1045" />
          <div className="grid grid-cols-3 gap-3">
            <Field label="Qtd total" value={f.qtdTotal} onChange={set('qtdTotal')} inputMode="numeric" />
            <Field label="Produzidas" value={f.qtdProduzida} onChange={set('qtdProduzida')} inputMode="numeric" />
            <Field label="Rejeitadas" value={f.qtdRejeitada} onChange={set('qtdRejeitada')} inputMode="numeric" />
          </div>
          <FieldWrap label="Status">
            <select
              value={f.status}
              onChange={(e) => set('status')(e.target.value)}
              className="w-full rounded-xl border border-black/10 bg-white px-3 py-2.5 text-sm text-cnc-dark outline-none focus:border-cnc-amber"
            >
              {STATUS_ORDEM.map((s) => (
                <option key={s} value={s}>
                  {s}
                </option>
              ))}
            </select>
          </FieldWrap>
          <Field label="Operador" value={f.operador} onChange={set('operador')} />
          <Field label="Observação" value={f.observacao} onChange={set('observacao')} />
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
