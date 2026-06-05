import { useEffect, useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  AlertTriangle,
  BookOpen,
  Bot,
  Calculator,
  ChevronRight,
  Layers,
  Lightbulb,
  Sparkles,
  Wifi,
  WifiOff,
  type LucideIcon,
} from 'lucide-react';
import { SearchBar } from '@/components/ui/SearchBar';
import { useT } from '@/stores/idioma';
import { useConectividadeStore } from '@/stores/conectividade';
import { buscarAlarmes, buscarCodigos } from '@/lib/busca';
import { cx } from '@/lib/cx';
import type { AlarmeItem, CodigoItem } from '@/types';

type Sugestao = { tipo: 'cod' | 'al'; codigo: string; titulo: string };

export function Home() {
  const t = useT();
  const navigate = useNavigate();
  const online = useConectividadeStore((s) => s.online);
  const [busca, setBusca] = useState('');
  // Dados de busca carregados sob demanda (mantém o bundle inicial enxuto).
  const [dados, setDados] = useState<{ codigos: CodigoItem[]; alarmes: AlarmeItem[] } | null>(null);

  useEffect(() => {
    if (busca.trim().length >= 2 && !dados) {
      Promise.all([import('@/data/codigos'), import('@/data/alarmes')]).then(([c, a]) =>
        setDados({ codigos: c.todosCodigos, alarmes: a.todosAlarmes }),
      );
    }
  }, [busca, dados]);

  const sugestoes = useMemo<Sugestao[]>(() => {
    const q = busca.trim();
    if (q.length < 2 || !dados) return [];
    const cods = buscarCodigos(dados.codigos, q)
      .slice(0, 5)
      .map((c): Sugestao => ({ tipo: 'cod', codigo: c.codigo, titulo: c.nome }));
    const als = buscarAlarmes(dados.alarmes, q)
      .slice(0, 3)
      .map((a): Sugestao => ({ tipo: 'al', codigo: a.codigo, titulo: a.titulo }));
    return [...cods, ...als];
  }, [busca, dados]);

  function irPara(s: Sugestao) {
    const destino =
      s.tipo === 'cod'
        ? `/biblioteca?q=${encodeURIComponent(s.codigo)}`
        : `/alarmes?q=${encodeURIComponent(s.codigo)}`;
    setBusca('');
    navigate(destino);
  }

  const atalhos: { icon: LucideIcon; label: string; sub: string; color: string; to: string }[] = [
    { icon: BookOpen, label: t('mod.biblioteca'), sub: t('mod.biblioteca.sub'), color: '#185FA5', to: '/biblioteca' },
    { icon: AlertTriangle, label: t('mod.alarmes'), sub: t('mod.alarmes.sub'), color: '#D94040', to: '/alarmes' },
    { icon: Calculator, label: t('mod.calculadora'), sub: t('mod.calculadora.sub'), color: '#0F6E56', to: '/calculadora' },
    { icon: Layers, label: t('mod.materiais'), sub: t('mod.materiais.sub'), color: '#E8A020', to: '/materiais' },
  ];

  return (
    <div className="pb-4">
      {/* Cabeçalho */}
      <header className="bg-cnc-dark px-5 pb-6 pt-6 text-white">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <div className="flex h-9 w-9 items-center justify-center rounded-xl bg-cnc-amber text-lg font-black text-cnc-dark">
              C
            </div>
            <div>
              <p className="text-sm font-bold leading-none">
                CNC<span className="text-cnc-amber">IA</span>
              </p>
              <p className="mt-0.5 text-[10px] uppercase tracking-wider text-gray-400">
                {t('app.subtitulo')}
              </p>
            </div>
          </div>
          <span
            className={cx(
              'flex items-center gap-1 rounded-full px-2.5 py-1 text-[10px] font-semibold',
              online ? 'bg-emerald-500/20 text-emerald-300' : 'bg-red-500/20 text-red-300',
            )}
          >
            {online ? <Wifi size={12} /> : <WifiOff size={12} />}
            {online ? t('home.online') : t('home.offline')}
          </span>
        </div>

        <p className="mt-5 text-xl font-semibold">
          {t('home.bemvindo')} <span className="text-cnc-amber">{t('home.operador')}</span>
        </p>

        <div className="relative mt-3">
          <SearchBar value={busca} onChange={setBusca} placeholder={t('home.buscar')} />
          {sugestoes.length > 0 && (
            <div className="absolute inset-x-0 top-full z-20 mt-1 overflow-hidden rounded-xl border border-black/10 bg-white shadow-xl">
              {sugestoes.map((s) => (
                <button
                  key={s.tipo + s.codigo}
                  type="button"
                  onClick={() => irPara(s)}
                  className="flex w-full items-center gap-2 border-b border-black/5 px-3 py-2.5 text-left last:border-0 hover:bg-gray-50"
                >
                  <span
                    className={cx(
                      'shrink-0 rounded px-1.5 py-0.5 font-mono text-[10px] font-bold',
                      s.tipo === 'cod' ? 'bg-cnc-blue/10 text-cnc-blue' : 'bg-cnc-red/10 text-cnc-red',
                    )}
                  >
                    {s.codigo}
                  </span>
                  <span className="min-w-0 flex-1 truncate text-sm text-cnc-dark">{s.titulo}</span>
                  <span className="shrink-0 text-[10px] uppercase tracking-wide text-gray-400">
                    {s.tipo === 'cod' ? 'código' : 'alarme'}
                  </span>
                </button>
              ))}
            </div>
          )}
        </div>
      </header>

      <div className="space-y-6 px-5 py-5">
        {/* Acesso rápido */}
        <section>
          <h2 className="mb-3 text-sm font-bold text-cnc-dark">{t('home.acessorapido')}</h2>
          <div className="grid grid-cols-2 gap-3">
            {atalhos.map((a) => (
              <button
                key={a.to}
                type="button"
                onClick={() => navigate(a.to)}
                className="flex flex-col gap-2.5 rounded-2xl border border-black/[0.06] bg-white p-4 text-left shadow-sm transition active:scale-[0.98]"
              >
                <div
                  className="flex h-10 w-10 items-center justify-center rounded-xl"
                  style={{ background: `${a.color}1A`, color: a.color }}
                >
                  <a.icon size={22} />
                </div>
                <div>
                  <p className="text-sm font-semibold text-cnc-dark">{a.label}</p>
                  <p className="text-[11px] leading-tight text-gray-500">{a.sub}</p>
                </div>
              </button>
            ))}
          </div>
        </section>

        {/* Cards destaque */}
        <section className="space-y-3">
          <HeroCard
            icon={Sparkles}
            title={t('home.analisaria')}
            subtitle={t('home.analisaria.sub')}
            onClick={() => navigate('/ia')}
            gradient="from-cnc-amber to-cnc-amberDark"
            badge={t('home.novo')}
          />
          <HeroCard
            icon={Bot}
            title="Agente CNC"
            subtitle="Tire dúvidas em linguagem natural"
            onClick={() => navigate('/agente')}
            gradient="from-cnc-blue to-cnc-dark"
          />
          <HeroCard
            icon={Lightbulb}
            title={t('home.guia')}
            subtitle={t('home.guia.sub')}
            onClick={() => navigate('/guia')}
            gradient="from-cnc-green to-cnc-dark"
          />
        </section>
      </div>
    </div>
  );
}

function HeroCard({
  icon: Icon,
  title,
  subtitle,
  onClick,
  gradient,
  badge,
}: {
  icon: LucideIcon;
  title: string;
  subtitle: string;
  onClick: () => void;
  gradient: string;
  badge?: string;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={cx(
        'flex w-full items-center gap-3.5 rounded-2xl bg-gradient-to-r p-4 text-left text-white shadow-sm transition active:scale-[0.99]',
        gradient,
      )}
    >
      <div className="flex h-11 w-11 shrink-0 items-center justify-center rounded-xl bg-white/20">
        <Icon size={24} />
      </div>
      <div className="min-w-0 flex-1">
        <div className="flex items-center gap-2">
          <p className="font-semibold">{title}</p>
          {badge && (
            <span className="rounded bg-white/25 px-1.5 py-0.5 text-[9px] font-bold tracking-wide">
              {badge}
            </span>
          )}
        </div>
        <p className="text-xs text-white/85">{subtitle}</p>
      </div>
      <ChevronRight size={20} className="shrink-0 text-white/70" />
    </button>
  );
}
