import { useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { AlertTriangle, Heart, Lightbulb, ShieldAlert } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { SearchBar } from '@/components/ui/SearchBar';
import { Tabs } from '@/components/ui/Tabs';
import { BottomSheet } from '@/components/ui/BottomSheet';
import { Badge } from '@/components/ui/Badge';
import { EmptyState } from '@/components/ui/EmptyState';
import { alarmesPorFabricante } from '@/data/alarmes';
import { buscarAlarmes } from '@/lib/busca';
import { corPorGravidade } from '@/theme/tokens';
import { useFavoritosStore } from '@/stores/favoritos';
import { useHistoricoStore } from '@/stores/historico';
import { cx } from '@/lib/cx';
import type { AlarmeItem } from '@/types';

const FABRICANTES = Object.keys(alarmesPorFabricante);

export function Diagnostico() {
  const [params] = useSearchParams();
  const termoInicial = params.get('q') ?? '';
  // Seleciona o fabricante que contém o termo buscado (vindo da Home).
  const fabInicial = termoInicial
    ? FABRICANTES.find((f) => buscarAlarmes(alarmesPorFabricante[f], termoInicial).length > 0) ?? FABRICANTES[0]
    : FABRICANTES[0];
  const [fab, setFab] = useState(fabInicial);
  const [busca, setBusca] = useState(termoInicial);
  const [sel, setSel] = useState<AlarmeItem | null>(null);

  const favAlarmes = useFavoritosStore((s) => s.alarmes);
  const toggleAlarme = useFavoritosStore((s) => s.toggleAlarme);
  const addHistorico = useHistoricoStore((s) => s.addHistorico);

  const lista = useMemo(
    () => buscarAlarmes(alarmesPorFabricante[fab] ?? [], busca),
    [fab, busca],
  );

  function abrir(a: AlarmeItem) {
    setSel(a);
    addHistorico({ id: `al-${a.codigo}`, titulo: `${a.codigo} — ${a.titulo}`, subtitulo: fab, tipo: 'Alarme' });
  }

  return (
    <>
      <TopBar title="Diagnóstico de Alarmes" subtitle="7 fabricantes catalogados" icon={AlertTriangle} />

      <div className="space-y-3 p-4">
        <SearchBar value={busca} onChange={setBusca} placeholder="Buscar código ou descrição do alarme..." />

        <Tabs
          tabs={FABRICANTES.map((f) => ({ key: f, label: f, count: alarmesPorFabricante[f].length }))}
          active={fab}
          onChange={setFab}
        />

        <p className="px-1 text-xs text-gray-400">{lista.length} alarmes</p>

        {lista.length === 0 ? (
          <EmptyState icon={AlertTriangle} title="Nenhum alarme encontrado" subtitle="Tente outro código ou fabricante." />
        ) : (
          <div className="space-y-2">
            {lista.map((a) => {
              const cor = corPorGravidade(a.gravidade);
              const fav = favAlarmes.includes(a.codigo);
              return (
                <div
                  key={`${fab}-${a.codigo}-${a.titulo}`}
                  onClick={() => abrir(a)}
                  className="flex cursor-pointer items-center gap-3 rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm transition hover:border-black/10"
                >
                  <div className="w-1 self-stretch rounded-full" style={{ background: cor }} />
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-2">
                      <span className="font-mono font-bold text-cnc-dark">{a.codigo}</span>
                      <Badge color={cor}>{a.gravidade}</Badge>
                    </div>
                    <p className="truncate text-sm text-gray-700">{a.titulo}</p>
                    <p className="truncate text-xs text-gray-500">{a.descricao}</p>
                  </div>
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      toggleAlarme(a.codigo);
                    }}
                    className="shrink-0 p-1"
                    aria-label="Favoritar"
                  >
                    <Heart size={18} className={fav ? 'fill-cnc-red text-cnc-red' : 'text-gray-300'} />
                  </button>
                </div>
              );
            })}
          </div>
        )}
      </div>

      <DetalheAlarme
        alarme={sel}
        onClose={() => setSel(null)}
        favorito={sel ? favAlarmes.includes(sel.codigo) : false}
        onToggleFav={() => sel && toggleAlarme(sel.codigo)}
      />
    </>
  );
}

function DetalheAlarme({
  alarme: a,
  onClose,
  favorito,
  onToggleFav,
}: {
  alarme: AlarmeItem | null;
  onClose: () => void;
  favorito: boolean;
  onToggleFav: () => void;
}) {
  if (!a) return null;
  const cor = corPorGravidade(a.gravidade);

  return (
    <BottomSheet
      open={!!a}
      onClose={onClose}
      title={
        <span className="flex items-center gap-2">
          <span className="font-mono">{a.codigo}</span>
          <Badge color={cor}>{a.gravidade}</Badge>
        </span>
      }
    >
      <div className="space-y-4">
        <div>
          <p className="text-base font-semibold text-cnc-dark">{a.titulo}</p>
          <Badge color="#185FA5" className="mt-1">
            {a.categoria}
          </Badge>
        </div>

        <p className="text-sm leading-relaxed text-gray-700">{a.descricaoCompleta}</p>

        <Secao titulo="Causas prováveis" icon={ShieldAlert} cor="#A32D2D" itens={a.causas} />
        <Secao titulo="Soluções" icon={Lightbulb} cor="#0F6E56" itens={a.solucoes} />

        {a.atencao && (
          <div className="rounded-xl bg-red-50 p-3">
            <p className="text-xs font-bold uppercase tracking-wide text-cnc-red">⚠️ Atenção</p>
            <p className="mt-1 text-sm leading-relaxed text-red-900">{a.atencao}</p>
          </div>
        )}

        <button
          type="button"
          onClick={onToggleFav}
          className={cx(
            'flex w-full items-center justify-center gap-2 rounded-xl py-3 text-sm font-semibold transition',
            favorito ? 'bg-cnc-red/10 text-cnc-red' : 'bg-cnc-dark text-white',
          )}
        >
          <Heart size={18} className={favorito ? 'fill-cnc-red' : ''} />
          {favorito ? 'Remover dos favoritos' : 'Adicionar aos favoritos'}
        </button>
      </div>
    </BottomSheet>
  );
}

function Secao({
  titulo,
  icon: Icon,
  cor,
  itens,
}: {
  titulo: string;
  icon: typeof ShieldAlert;
  cor: string;
  itens: string[];
}) {
  if (!itens?.length) return null;
  return (
    <div>
      <p className="mb-1.5 flex items-center gap-1.5 text-xs font-bold uppercase tracking-wide" style={{ color: cor }}>
        <Icon size={14} />
        {titulo}
      </p>
      <ul className="space-y-1.5">
        {itens.map((item, i) => (
          <li key={i} className="flex gap-2 text-sm text-gray-700">
            <span className="mt-0.5 shrink-0" style={{ color: cor }}>
              •
            </span>
            <span className="leading-relaxed">{item}</span>
          </li>
        ))}
      </ul>
    </div>
  );
}
