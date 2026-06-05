import { useMemo, useState } from 'react';
import { Check, Code2, Copy, Wrench } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { SearchBar } from '@/components/ui/SearchBar';
import { Tabs } from '@/components/ui/Tabs';
import { BottomSheet } from '@/components/ui/BottomSheet';
import { Badge } from '@/components/ui/Badge';
import { EmptyState } from '@/components/ui/EmptyState';
import { GcodeView } from '@/components/ui/GcodeView';
import { programasFresamento, programasTorneamento, programasEspeciais } from '@/data/programas';
import { norm } from '@/lib/busca';
import { useHistoricoStore } from '@/stores/historico';
import { cx } from '@/lib/cx';
import type { ProgramaCNC } from '@/types';

const ABAS = [
  { key: 'fre', label: 'Fresamento', lista: programasFresamento },
  { key: 'tor', label: 'Torneamento', lista: programasTorneamento },
  { key: 'esp', label: 'Especiais', lista: programasEspeciais },
] as const;

const COR_NIVEL: Record<string, string> = {
  Básico: '#0F6E56',
  Intermediário: '#185FA5',
  Avançado: '#A32D2D',
};

export function Programas() {
  const [aba, setAba] = useState<'fre' | 'tor' | 'esp'>('fre');
  const [busca, setBusca] = useState('');
  const [sel, setSel] = useState<ProgramaCNC | null>(null);
  const addHistorico = useHistoricoStore((s) => s.addHistorico);

  const listaAba = ABAS.find((a) => a.key === aba)!.lista;
  const lista = useMemo(() => {
    const q = norm(busca.trim());
    if (!q) return listaAba;
    return listaAba.filter(
      (p) => norm(p.titulo).includes(q) || norm(p.subtitulo).includes(q) || p.tags.some((t) => norm(t).includes(q)),
    );
  }, [listaAba, busca]);

  function abrir(p: ProgramaCNC) {
    setSel(p);
    addHistorico({ id: `prog-${p.titulo}`, titulo: p.titulo, subtitulo: p.subtitulo, tipo: 'Programa' });
  }

  return (
    <>
      <TopBar title="Programas CNC" subtitle="Exemplos e templates" icon={Code2} back />
      <div className="space-y-3 p-4">
        <SearchBar value={busca} onChange={setBusca} placeholder="Buscar programa..." />
        <Tabs
          tabs={ABAS.map((a) => ({ key: a.key, label: a.label, count: a.lista.length }))}
          active={aba}
          onChange={(k) => setAba(k as 'fre' | 'tor' | 'esp')}
        />

        {lista.length === 0 ? (
          <EmptyState icon={Code2} title="Nenhum programa encontrado" subtitle="Tente outro termo." />
        ) : (
          <div className="space-y-2">
            {lista.map((p) => (
              <div
                key={p.titulo}
                onClick={() => abrir(p)}
                className="flex cursor-pointer items-center gap-3 rounded-2xl border border-black/[0.06] bg-white p-3 shadow-sm"
              >
                <div
                  className="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl"
                  style={{ background: `${p.cor}1A`, color: p.cor }}
                >
                  <Code2 size={20} />
                </div>
                <div className="min-w-0 flex-1">
                  <p className="truncate text-sm font-semibold text-cnc-dark">{p.titulo}</p>
                  <p className="truncate text-xs text-gray-500">{p.subtitulo}</p>
                </div>
                <Badge color={COR_NIVEL[p.nivel] ?? '#6B7280'}>{p.nivel}</Badge>
              </div>
            ))}
          </div>
        )}
      </div>

      <DetalhePrograma programa={sel} onClose={() => setSel(null)} />
    </>
  );
}

function DetalhePrograma({ programa: p, onClose }: { programa: ProgramaCNC | null; onClose: () => void }) {
  const [copiado, setCopiado] = useState(false);
  if (!p) return null;

  function copiar() {
    navigator.clipboard?.writeText(p!.codigo).then(() => {
      setCopiado(true);
      setTimeout(() => setCopiado(false), 1500);
    });
  }

  return (
    <BottomSheet open={!!p} onClose={onClose} title={p.titulo}>
      <div className="space-y-4">
        <div className="flex flex-wrap gap-2">
          <Badge color={COR_NIVEL[p.nivel] ?? '#6B7280'}>{p.nivel}</Badge>
          <Badge color="#185FA5">{p.subtitulo}</Badge>
        </div>

        <p className="text-sm leading-relaxed text-gray-700">{p.descricao}</p>

        {p.ferramentas.length > 0 && <Lista titulo="Ferramentas" itens={p.ferramentas} icon={Wrench} cor="#185FA5" />}
        {p.setup.length > 0 && <Lista titulo="Setup" itens={p.setup} cor="#534AB7" />}

        <div>
          <div className="mb-1 flex items-center justify-between">
            <p className="text-xs font-bold uppercase tracking-wide text-gray-400">Programa completo</p>
            <button type="button" onClick={copiar} className="flex items-center gap-1 text-xs font-medium text-cnc-blue">
              {copiado ? <Check size={14} /> : <Copy size={14} />}
              {copiado ? 'Copiado' : 'Copiar'}
            </button>
          </div>
          <GcodeView code={p.codigo} />
        </div>

        {p.linhasExplicadas.length > 0 && (
          <div>
            <p className="mb-1.5 text-xs font-bold uppercase tracking-wide text-gray-400">Linha a linha</p>
            <div className="overflow-hidden rounded-xl border border-black/[0.06]">
              {p.linhasExplicadas.map((l, i) => (
                <div
                  key={i}
                  className={cx(
                    'grid grid-cols-[1fr_1fr] gap-2 px-3 py-1.5 text-xs',
                    i > 0 && 'border-t border-black/[0.05]',
                    l.isComentario && 'bg-gray-50',
                  )}
                >
                  <code className={cx('font-mono', l.isComentario ? 'text-gray-400' : 'text-cnc-dark')}>{l.codigo}</code>
                  <span className="text-gray-500">{l.explicacao}</span>
                </div>
              ))}
            </div>
          </div>
        )}

        {p.dicas.length > 0 && (
          <div className="rounded-xl bg-amber-50 p-3">
            <p className="text-xs font-bold uppercase tracking-wide text-cnc-amberDark">💡 Dicas</p>
            <ul className="mt-1 space-y-1">
              {p.dicas.map((d, i) => (
                <li key={i} className="flex gap-2 text-sm text-amber-900">
                  <span className="mt-0.5 shrink-0">•</span>
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

function Lista({
  titulo,
  itens,
  icon: Icon,
  cor,
}: {
  titulo: string;
  itens: string[];
  icon?: typeof Wrench;
  cor: string;
}) {
  return (
    <div>
      <p className="mb-1.5 flex items-center gap-1.5 text-xs font-bold uppercase tracking-wide" style={{ color: cor }}>
        {Icon && <Icon size={14} />}
        {titulo}
      </p>
      <ul className="space-y-1">
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
