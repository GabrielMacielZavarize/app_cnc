import { Link, useLocation } from 'react-router-dom';
import { AlertTriangle, BookOpen, House, LayoutGrid, Sparkles } from 'lucide-react';
import { useT } from '@/stores/idioma';
import { cx } from '@/lib/cx';

const ITENS = [
  { to: '/', key: 'inicio', icon: House, label: 'nav.inicio' },
  { to: '/biblioteca', key: 'biblioteca', icon: BookOpen, label: 'nav.biblioteca' },
  { to: '/alarmes', key: 'alarmes', icon: AlertTriangle, label: 'nav.alarmes' },
  { to: '/ia', key: 'ia', icon: Sparkles, label: 'nav.ia' },
  { to: '/mais', key: 'mais', icon: LayoutGrid, label: 'nav.mais' },
] as const;

function abaAtiva(pathname: string): string {
  if (pathname === '/') return 'inicio';
  if (pathname.startsWith('/biblioteca')) return 'biblioteca';
  if (pathname.startsWith('/alarmes')) return 'alarmes';
  if (pathname.startsWith('/ia')) return 'ia';
  return 'mais'; // telas internas são alcançadas pelo menu "Mais"/Home
}

export function BottomNav() {
  const t = useT();
  const { pathname } = useLocation();
  const ativa = abaAtiva(pathname);

  return (
    <nav className="flex shrink-0 items-stretch border-t border-white/10 bg-cnc-dark">
      {ITENS.map(({ to, key, icon: Icon, label }) => {
        const isActive = key === ativa;
        return (
          <Link
            key={key}
            to={to}
            className={cx(
              'flex flex-1 flex-col items-center gap-1 py-2.5 text-[10px] font-medium transition',
              isActive ? 'text-cnc-amber' : 'text-gray-400 hover:text-gray-200',
            )}
          >
            <Icon size={22} strokeWidth={isActive ? 2.4 : 2} />
            {t(label)}
          </Link>
        );
      })}
    </nav>
  );
}
