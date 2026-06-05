import { type ReactNode } from 'react';
import { cx } from '@/lib/cx';

interface BadgeProps {
  children: ReactNode;
  /** Cor do texto/destaque (hex). O fundo é derivado com baixa opacidade. */
  color?: string;
  className?: string;
}

/** Pílula pequena de categoria/etiqueta. */
export function Badge({ children, color = '#185FA5', className }: BadgeProps) {
  return (
    <span
      className={cx(
        'inline-flex items-center rounded-md px-2 py-0.5 text-[11px] font-semibold',
        className,
      )}
      style={{ color, backgroundColor: `${color}1A` /* ~10% alpha */ }}
    >
      {children}
    </span>
  );
}
