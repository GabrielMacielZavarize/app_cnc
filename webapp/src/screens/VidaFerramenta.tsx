import { useState } from 'react';
import { Plus, Timer, Trash2 } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { EmptyState } from '@/components/ui/EmptyState';
import { BottomSheet } from '@/components/ui/BottomSheet';
import { Field, FieldWrap } from '@/components/ui/Field';
import {
  pctVida,
  statusFerramenta,
  TIPOS_FERRAMENTA,
  useFerramentasStore,
  type Ferramenta,
} from '@/stores/ferramentas';

const VAZIO = {
  nome: '',
  tipo: 'Fresa',
  diametro: '',
  material: 'Metal duro',
  vidaMaxPecas: '',
  pecasFeitas: '0',
  alertaPct: '80',
};

export function VidaFerramenta() {
  const ferramentas = useFerramentasStore((s) => s.ferramentas);
  const add = useFerramentasStore((s) => s.add);
  const update = useFerramentasStore((s) => s.update);
  const remove = useFerramentasStore((s) => s.remove);

  const [edicao, setEdicao] = useState<Ferramenta | 'nova' | null>(null);
  const [f, setF] = useState(VAZIO);
  const set = (k: keyof typeof VAZIO) => (v: string) => setF((p) => ({ ...p, [k]: v }));

  function abrirNova() {
    setF(VAZIO);
    setEdicao('nova');
  }
  function abrirEdicao(t: Ferramenta) {
    setF({
      nome: t.nome,
      tipo: t.tipo,
      diametro: t.diametro,
      material: t.material,
      vidaMaxPecas: String(t.vidaMaxPecas),
      pecasFeitas: String(t.pecasFeitas),
      alertaPct: String(t.alertaPct),
    });
    setEdicao(t);
  }
  function salvar() {
    if (!f.nome.trim()) return;
    const dados = {
      ...f,
      vidaMaxPecas: Number(f.vidaMaxPecas) || 0,
      pecasFeitas: Number(f.pecasFeitas) || 0,
      alertaPct: Number(f.alertaPct) || 80,
    };
    if (edicao === 'nova') add(dados);
    else if (edicao) update(edicao.id, dados);
    setEdicao(null);
  }

  return (
    <>
      <TopBar
        title="Vida da Ferramenta"
        subtitle="Contador e alerta de troca"
        icon={Timer}
        back
        right={
          <button type="button" onClick={abrirNova} className="rounded-full p-1.5 text-white/90 hover:bg-white/10" aria-label="Nova ferramenta">
            <Plus size={20} />
          </button>
        }
      />

      <div className="space-y-2 p-4">
        {ferramentas.length === 0 ? (
          <EmptyState icon={Timer} title="Nenhuma ferramenta" subtitle="Toque em + para cadastrar e acompanhar a vida útil." />
        ) : (
          ferramentas.map((t) => {
            const pct = pctVida(t);
            const st = statusFerramenta(t);
            return (
              <div key={t.id} onClick={() => abrirEdicao(t)} className="cursor-pointer rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm">
                <div className="flex items-center justify-between gap-2">
                  <span className="truncate text-sm font-semibold text-cnc-dark">{t.nome}</span>
                  <span className="shrink-0 rounded-md px-2 py-0.5 text-[11px] font-semibold" style={{ color: st.cor, background: `${st.cor}1A` }}>
                    {st.label}
                  </span>
                </div>
                <p className="text-xs text-gray-500">
                  {t.tipo}
                  {t.diametro && ` Ø${t.diametro}`} · {t.material}
                </p>
                <div className="mt-2 flex items-center gap-2">
                  <div className="h-1.5 flex-1 overflow-hidden rounded-full bg-gray-100">
                    <div className="h-full rounded-full" style={{ width: `${pct}%`, background: st.cor }} />
                  </div>
                  <span className="shrink-0 text-xs font-medium text-gray-600">
                    {t.pecasFeitas}/{t.vidaMaxPecas} pç
                  </span>
                </div>
              </div>
            );
          })
        )}
      </div>

      <BottomSheet open={edicao !== null} onClose={() => setEdicao(null)} title={edicao === 'nova' ? 'Nova ferramenta' : 'Editar ferramenta'}>
        <div className="space-y-3">
          <Field label="Nome / identificação" value={f.nome} onChange={set('nome')} placeholder="Ex.: Fresa topo Ø10 4 cortes" />
          <div className="grid grid-cols-2 gap-3">
            <FieldWrap label="Tipo">
              <select
                value={f.tipo}
                onChange={(e) => set('tipo')(e.target.value)}
                className="w-full rounded-xl border border-black/10 bg-white px-3 py-2.5 text-sm text-cnc-dark outline-none focus:border-cnc-amber"
              >
                {TIPOS_FERRAMENTA.map((tp) => (
                  <option key={tp} value={tp}>
                    {tp}
                  </option>
                ))}
              </select>
            </FieldWrap>
            <Field label="Diâmetro (mm)" value={f.diametro} onChange={set('diametro')} inputMode="decimal" />
          </div>
          <Field label="Material da ferramenta" value={f.material} onChange={set('material')} placeholder="Metal duro, HSS, CBN..." />
          <div className="grid grid-cols-3 gap-3">
            <Field label="Vida (peças)" value={f.vidaMaxPecas} onChange={set('vidaMaxPecas')} inputMode="numeric" />
            <Field label="Peças feitas" value={f.pecasFeitas} onChange={set('pecasFeitas')} inputMode="numeric" />
            <Field label="Alerta (%)" value={f.alertaPct} onChange={set('alertaPct')} inputMode="numeric" />
          </div>
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
