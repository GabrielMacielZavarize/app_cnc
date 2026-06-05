import { type ReactNode } from 'react';
import { ChevronLeft, type LucideIcon } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

interface TopBarProps {
  title: string;
  subtitle?: string;
  /** Mostra a seta de voltar. `true` = voltar no histórico; ou passe um callback. */
  back?: boolean | (() => void);
  right?: ReactNode;
  icon?: LucideIcon;
}

/** Cabeçalho escuro padrão das telas (porta o AppBar do Flutter). */
export function TopBar({ title, subtitle, back, right, icon: Icon }: TopBarProps) {
  const navigate = useNavigate();
  const onBack = back === true ? () => navigate(-1) : typeof back === 'function' ? back : undefined;

  return (
    <header className="bg-cnc-dark px-4 pb-4 pt-6 text-white">
      <div className="flex items-center gap-3">
        {onBack && (
          <button
            type="button"
            onClick={onBack}
            className="-ml-1 rounded-full p-1 text-white/90 hover:bg-white/10"
            aria-label="Voltar"
          >
            <ChevronLeft size={24} />
          </button>
        )}
        {Icon && (
          <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg bg-cnc-blue">
            <Icon size={18} />
          </div>
        )}
        <div className="min-w-0 flex-1">
          <h1 className="truncate text-lg font-semibold leading-tight">{title}</h1>
          {subtitle && (
            <p className="truncate text-[11px] uppercase tracking-wider text-gray-400">{subtitle}</p>
          )}
        </div>
        {right}
      </div>
    </header>
  );
}
