import { useMemo, useState } from 'react';
import {
  Circle,
  Droplet,
  FlaskConical,
  Flame,
  Hammer,
  Hexagon,
  Layers,
  Rocket,
  Settings,
  Wrench,
  Zap,
  type LucideIcon,
} from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { SearchBar } from '@/components/ui/SearchBar';
import { Tabs } from '@/components/ui/Tabs';
import { BottomSheet } from '@/components/ui/BottomSheet';
import { Badge } from '@/components/ui/Badge';
import { EmptyState } from '@/components/ui/EmptyState';
import { materiaisFresamento, materiaisFuracao, materiaisTorneamento } from '@/data/materiais';
import { norm } from '@/lib/busca';
import { useHistoricoStore } from '@/stores/historico';
import type { MaterialCNC, ParamCorte } from '@/types';

const ICONES: Record<string, LucideIcon> = {
  bolt: Zap,
  electric_bolt: Zap,
  build: Wrench,
  hardware: Wrench,
  circle: Circle,
  radio_button_unchecked: Circle,
  construction: Hammer,
  hexagon: Hexagon,
  hexagon_outlined: Hexagon,
  layers: Layers,
  rocket_launch: Rocket,
  science: FlaskConical,
  settings: Settings,
  water_drop: Droplet,
  whatshot: Flame,
};

const ABAS = [
  { key: 'fresamento', label: 'Fresamento', lista: materiaisFresamento },
  { key: 'torneamento', label: 'Torneamento', lista: materiaisTorneamento },
  { key: 'furacao', label: 'Furação', lista: materiaisFuracao },
] as const;

type AbaKey = (typeof ABAS)[number]['key'];

export function Materiais() {
  const [aba, setAba] = useState<AbaKey>('fresamento');
  const [busca, setBusca] = useState('');
  const [sel, setSel] = useState<MaterialCNC | null>(null);
  const addHistorico = useHistoricoStore((s) => s.addHistorico);

  const listaAba = ABAS.find((a) => a.key === aba)!.lista;

  const lista = useMemo(() => {
    const q = norm(busca.trim());
    if (!q) return listaAba;
    return listaAba.filter(
      (m) =>
        norm(m.nome).includes(q) ||
        norm(m.norma).includes(q) ||
        norm(m.descricao).includes(q) ||
        norm(m.aplicacoes).includes(q),
    );
  }, [listaAba, busca]);

  function abrir(m: MaterialCNC) {
    setSel(m);
    addHistorico({ id: `mat-${m.nome}`, titulo: m.nome, subtitulo: m.norma, tipo: 'Material' });
  }

  return (
    <>
      <TopBar title="Materiais" subtitle="30 materiais de usinagem" icon={Layers} back />

      <div className="space-y-3 p-4">
        <SearchBar value={busca} onChange={setBusca} placeholder="Buscar material, norma ou aplicação..." />
        <Tabs tabs={ABAS.map((a) => ({ key: a.key, label: a.label }))} active={aba} onChange={(k) => setAba(k as AbaKey)} />

        {lista.length === 0 ? (
          <EmptyState icon={Layers} title="Nenhum material encontrado" subtitle="Tente outro termo." />
        ) : (
          <div className="space-y-2">
            {lista.map((m) => {
              const Icone = ICONES[m.icone] ?? Layers;
              return (
                <div
                  key={m.nome}
                  onClick={() => abrir(m)}
                  className="flex cursor-pointer items-center gap-3 rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm transition hover:border-black/10"
                >
                  <div
                    className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl"
                    style={{ background: `${m.cor}1A`, color: m.cor }}
                  >
                    <Icone size={20} />
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="truncate text-sm font-semibold text-cnc-dark">{m.nome}</p>
                    <p className="truncate text-xs text-gray-500">{m.maquinabilidade}</p>
                  </div>
                  <div className="shrink-0 text-right">
                    <p className="text-xs font-semibold text-cnc-dark">
                      {m.vcMin}–{m.vcMax}
                    </p>
                    <p className="text-[10px] text-gray-400">Vc m/min</p>
                  </div>
                </div>
              );
            })}
          </div>
        )}
      </div>

      <DetalheMaterial material={sel} aba={aba} onClose={() => setSel(null)} />
    </>
  );
}

function DetalheMaterial({
  material: m,
  aba,
  onClose,
}: {
  material: MaterialCNC | null;
  aba: AbaKey;
  onClose: () => void;
}) {
  if (!m) return null;
  const params: ParamCorte[] = m[aba];

  return (
    <BottomSheet open={!!m} onClose={onClose} title={m.nome}>
      <div className="space-y-4">
        <div className="flex flex-wrap gap-2">
          <Badge color="#185FA5">{m.norma}</Badge>
          <Badge color="#0F6E56">{m.maquinabilidade}</Badge>
        </div>

        <p className="text-sm leading-relaxed text-gray-700">{m.descricao}</p>

        <div className="grid grid-cols-2 gap-2">
          <Prop label="Dureza" valor={m.dureza} />
          <Prop label="Resistência" valor={m.resistencia} />
          <Prop label="Densidade" valor={m.densidade} />
          <Prop label="Vc recomendada" valor={`${m.vcMin}–${m.vcMax} m/min`} />
        </div>

        <div>
          <p className="mb-1 text-xs font-bold uppercase tracking-wide text-gray-400">Aplicações</p>
          <p className="text-sm text-gray-700">{m.aplicacoes}</p>
        </div>

        {params.length > 0 && (
          <div>
            <p className="mb-1.5 text-xs font-bold uppercase tracking-wide text-gray-400">
              Parâmetros de corte ({ABAS.find((a) => a.key === aba)!.label})
            </p>
            <div className="overflow-hidden rounded-xl border border-black/[0.06]">
              <div className="grid grid-cols-4 bg-gray-50 px-3 py-1.5 text-[10px] font-bold uppercase tracking-wide text-gray-400">
                <span>Operação</span>
                <span className="text-right">Vc</span>
                <span className="text-right">fz</span>
                <span className="text-right">ap</span>
              </div>
              {params.map((p, i) => (
                <div key={i} className="grid grid-cols-4 border-t border-black/[0.05] px-3 py-1.5 text-xs">
                  <span className="text-gray-700">{p.operacao}</span>
                  <span className="text-right font-mono text-cnc-dark">{p.vc}</span>
                  <span className="text-right font-mono text-cnc-dark">{p.fz}</span>
                  <span className="text-right font-mono text-cnc-dark">{p.ap}</span>
                </div>
              ))}
            </div>
            <p className="mt-1 text-[10px] text-gray-400">Vc em m/min · fz em mm/dente · ap em mm</p>
          </div>
        )}

        <div className="rounded-xl bg-blue-50 p-3">
          <p className="text-xs font-bold uppercase tracking-wide text-cnc-blue">💧 Fluido de corte</p>
          <p className="mt-1 text-sm text-blue-900">
            {m.fluido} ({m.concentracaoFluido})
          </p>
          <p className="mt-1 text-xs leading-relaxed text-blue-800">{m.dicaFluido}</p>
        </div>

        {m.dicas.length > 0 && (
          <div>
            <p className="mb-1.5 text-xs font-bold uppercase tracking-wide text-cnc-amberDark">💡 Dicas</p>
            <ul className="space-y-1.5">
              {m.dicas.map((d, i) => (
                <li key={i} className="flex gap-2 text-sm text-gray-700">
                  <span className="mt-0.5 shrink-0 text-cnc-amber">•</span>
                  <span className="leading-relaxed">{d}</span>
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
    </BottomSheet>
  );
}

function Prop({ label, valor }: { label: string; valor: string }) {
  return (
    <div className="rounded-xl bg-gray-50 p-2.5">
      <p className="text-[10px] uppercase tracking-wide text-gray-400">{label}</p>
      <p className="mt-0.5 text-sm font-semibold text-cnc-dark">{valor}</p>
    </div>
  );
}
