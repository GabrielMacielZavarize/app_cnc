import { type ReactNode } from 'react';
import { cx } from '@/lib/cx';

interface CardProps {
  children: ReactNode;
  onClick?: () => void;
  className?: string;
}

/** Cartão branco arredondado — o container visual padrão do app. */
export function Card({ children, onClick, className }: CardProps) {
  if (onClick) {
    return (
      <button
        type="button"
        onClick={onClick}
        className={cx(
          'block w-full text-left bg-white rounded-2xl border border-black/[0.06] shadow-sm',
          'transition active:scale-[0.99] hover:border-black/10',
          className,
        )}
      >
        {children}
      </button>
    );
  }
  return (
    <div
      className={cx(
        'bg-white rounded-2xl border border-black/[0.06] shadow-sm',
        className,
      )}
    >
      {children}
    </div>
  );
}
