import { useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import {
  BookOpen,
  Check,
  Copy,
  Crosshair,
  Gauge,
  Hash,
  Heart,
  Layers,
  Move,
  RotateCw,
  Ruler,
  Settings2,
  Wrench,
  type LucideIcon,
} from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { SearchBar } from '@/components/ui/SearchBar';
import { Tabs } from '@/components/ui/Tabs';
import { BottomSheet } from '@/components/ui/BottomSheet';
import { Badge } from '@/components/ui/Badge';
import { EmptyState } from '@/components/ui/EmptyState';
import { GcodeView } from '@/components/ui/GcodeView';
import { DiagramaCNC, temDiagrama } from '@/components/diagrama/DiagramaCNC';
import { todosCodigos } from '@/data/codigos';
import { buscarCodigos } from '@/lib/busca';
import { useFavoritosStore } from '@/stores/favoritos';
import { useHistoricoStore } from '@/stores/historico';
import { cx } from '@/lib/cx';
import type { CodigoItem } from '@/types';

const CAT_ICONS: Record<string, { icon: LucideIcon; cor: string }> = {
  Movimento: { icon: Move, cor: '#185FA5' },
  Planos: { icon: Crosshair, cor: '#185FA5' },
  Compensação: { icon: Ruler, cor: '#534AB7' },
  'Ciclos Fixos': { icon: Crosshair, cor: '#BA7517' },
  'Ciclos Torno': { icon: RotateCw, cor: '#BA7517' },
  Furação: { icon: Crosshair, cor: '#BA7517' },
  Spindle: { icon: RotateCw, cor: '#E8A020' },
  Refrigeração: { icon: Gauge, cor: '#185FA5' },
  Velocidade: { icon: Gauge, cor: '#0F6E56' },
  Avanço: { icon: Gauge, cor: '#0F6E56' },
  'Zero-Peça': { icon: Crosshair, cor: '#0F6E56' },
  Referência: { icon: Crosshair, cor: '#0F6E56' },
  Programação: { icon: Settings2, cor: '#185FA5' },
  Configuração: { icon: Settings2, cor: '#6B7280' },
  Transformação: { icon: Layers, cor: '#534AB7' },
  Controle: { icon: Wrench, cor: '#A32D2D' },
  Macro: { icon: Hash, cor: '#534AB7' },
};

function catInfo(categoria: string) {
  return CAT_ICONS[categoria] ?? { icon: Hash, cor: '#185FA5' };
}

export function Biblioteca() {
  const [params] = useSearchParams();
  const termoInicial = params.get('q') ?? '';
  const [aba, setAba] = useState<'G' | 'M'>(termoInicial.trim().toUpperCase().startsWith('M') ? 'M' : 'G');
  const [busca, setBusca] = useState(termoInicial);
  const [fab, setFab] = useState('Todos');
  const [sel, setSel] = useState<CodigoItem | null>(null);

  const favCodigos = useFavoritosStore((s) => s.codigos);
  const toggleCodigo = useFavoritosStore((s) => s.toggleCodigo);
  const addHistorico = useHistoricoStore((s) => s.addHistorico);

  const daAba = useMemo(
    () => todosCodigos.filter((c) => (aba === 'G' ? c.isG : !c.isG)),
    [aba],
  );

  const fabricantes = useMemo(() => {
    const set = new Set<string>();
    daAba.forEach((c) => set.add(c.fabricante ?? 'Universal'));
    return ['Todos', ...[...set].sort()];
  }, [daAba]);

  const lista = useMemo(() => {
    let l = daAba;
    if (fab !== 'Todos') l = l.filter((c) => (c.fabricante ?? 'Universal') === fab);
    return buscarCodigos(l, busca);
  }, [daAba, fab, busca]);

  function abrir(c: CodigoItem) {
    setSel(c);
    addHistorico({
      id: `cod-${c.codigo}`,
      titulo: `${c.codigo} — ${c.nome}`,
      subtitulo: c.categoria,
      tipo: c.isG ? 'Código G' : 'Código M',
    });
  }

  return (
    <>
      <TopBar title="Biblioteca CNC" subtitle="Códigos G e M completos" icon={BookOpen} />

      <div className="space-y-3 p-4">
        <SearchBar value={busca} onChange={setBusca} placeholder="Buscar G00, M03, furo fundo, rosca..." />

        <Tabs
          tabs={[
            { key: 'G', label: 'Códigos G' },
            { key: 'M', label: 'Códigos M' },
          ]}
          active={aba}
          onChange={(k) => {
            setAba(k as 'G' | 'M');
            setFab('Todos');
          }}
        />

        <div className="no-scrollbar -mx-4 flex gap-2 overflow-x-auto px-4">
          {fabricantes.map((f) => (
            <button
              key={f}
              type="button"
              onClick={() => setFab(f)}
              className={cx(
                'whitespace-nowrap rounded-full border px-3 py-1 text-xs font-medium transition',
                fab === f
                  ? 'border-cnc-amber bg-cnc-amber/15 text-cnc-amberDark'
                  : 'border-black/10 bg-white text-gray-500',
              )}
            >
              {f}
            </button>
          ))}
        </div>

        <p className="px-1 text-xs text-gray-400">{lista.length} códigos</p>

        {lista.length === 0 ? (
          <EmptyState icon={BookOpen} title="Nenhum código encontrado" subtitle="Tente outro termo ou fabricante." />
        ) : (
          <div className="space-y-2">
            {lista.map((c) => {
              const info = catInfo(c.categoria);
              const fav = favCodigos.includes(c.codigo);
              return (
                <div
                  key={`${c.codigo}-${c.fabricante ?? ''}-${c.nome}`}
                  onClick={() => abrir(c)}
                  className="flex cursor-pointer items-center gap-3 rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm transition hover:border-black/10"
                >
                  <div
                    className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl"
                    style={{ background: `${info.cor}1A`, color: info.cor }}
                  >
                    <info.icon size={20} />
                  </div>
                  <div className="min-w-0 flex-1">
                    <div className="flex items-baseline gap-2">
                      <span className="font-bold text-cnc-dark">{c.codigo}</span>
                      <span className="truncate text-sm text-gray-700">{c.nome}</span>
                    </div>
                    <p className="truncate text-xs text-gray-500">{c.descricao}</p>
                  </div>
                  <button
                    type="button"
                    onClick={(e) => {
                      e.stopPropagation();
                      toggleCodigo(c.codigo);
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

      <DetalheCodigo
        codigo={sel}
        onClose={() => setSel(null)}
        favorito={sel ? favCodigos.includes(sel.codigo) : false}
        onToggleFav={() => sel && toggleCodigo(sel.codigo)}
      />
    </>
  );
}

function DetalheCodigo({
  codigo: c,
  onClose,
  favorito,
  onToggleFav,
}: {
  codigo: CodigoItem | null;
  onClose: () => void;
  favorito: boolean;
  onToggleFav: () => void;
}) {
  const [copiado, setCopiado] = useState(false);

  function copiar(texto: string) {
    navigator.clipboard?.writeText(texto).then(() => {
      setCopiado(true);
      setTimeout(() => setCopiado(false), 1500);
    });
  }

  if (!c) return null;

  return (
    <BottomSheet
      open={!!c}
      onClose={onClose}
      title={
        <span className="flex items-center gap-2">
          <span className="text-cnc-amber">{c.codigo}</span>
          <span className="text-sm font-normal text-gray-500">{c.nome}</span>
        </span>
      }
    >
      <div className="space-y-4">
        <div className="flex flex-wrap gap-2">
          <Badge color="#185FA5">{c.categoria}</Badge>
          {c.fabricante && c.fabricante !== 'Universal' && <Badge color="#534AB7">{c.fabricante}</Badge>}
          {c.maquina && <Badge color="#0F6E56">{c.maquina}</Badge>}
        </div>

        <p className="text-sm leading-relaxed text-gray-700">{c.descricaoCompleta}</p>

        {temDiagrama(c.codigo, c.diagramaTipo) && <DiagramaCNC codigo={c.codigo} tipo={c.diagramaTipo} />}

        <div>
          <p className="mb-1 text-xs font-bold uppercase tracking-wide text-gray-400">Sintaxe</p>
          <code className="block rounded-lg bg-gray-100 px-3 py-2 font-mono text-sm text-cnc-dark">{c.sintaxe}</code>
        </div>

        {c.parametros.length > 0 && (
          <div>
            <p className="mb-1.5 text-xs font-bold uppercase tracking-wide text-gray-400">Parâmetros</p>
            <ul className="space-y-1">
              {c.parametros.map((p, i) => (
                <li key={i} className="flex gap-2 text-sm">
                  <span className="w-12 shrink-0 font-mono font-semibold text-cnc-blue">{p.letra}</span>
                  <span className="text-gray-600">{p.descricao}</span>
                </li>
              ))}
            </ul>
          </div>
        )}

        <div>
          <div className="mb-1 flex items-center justify-between">
            <p className="text-xs font-bold uppercase tracking-wide text-gray-400">Exemplo</p>
            <button
              type="button"
              onClick={() => copiar(c.exemplo)}
              className="flex items-center gap-1 text-xs font-medium text-cnc-blue"
            >
              {copiado ? <Check size={14} /> : <Copy size={14} />}
              {copiado ? 'Copiado' : 'Copiar'}
            </button>
          </div>
          <GcodeView code={c.exemplo} />
          <p className="mt-2 text-xs leading-relaxed text-gray-500">{c.explicacaoExemplo}</p>
        </div>

        {c.dicaProfissional && (
          <div className="rounded-xl bg-amber-50 p-3">
            <p className="text-xs font-bold uppercase tracking-wide text-cnc-amberDark">💡 Dica profissional</p>
            <p className="mt-1 text-sm leading-relaxed text-amber-900">{c.dicaProfissional}</p>
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
