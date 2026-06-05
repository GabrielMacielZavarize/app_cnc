import { cx } from '@/lib/cx';

export interface TabItem {
  key: string;
  label: string;
  count?: number;
}

interface TabsProps {
  tabs: TabItem[];
  active: string;
  onChange: (key: string) => void;
  className?: string;
}

/** Faixa de abas horizontal rolável — sublinhado âmbar na ativa. */
export function Tabs({ tabs, active, onChange, className }: TabsProps) {
  return (
    <div className={cx('no-scrollbar flex gap-1 overflow-x-auto', className)}>
      {tabs.map((t) => {
        const isActive = t.key === active;
        return (
          <button
            key={t.key}
            type="button"
            onClick={() => onChange(t.key)}
            className={cx(
              'relative whitespace-nowrap px-3 py-2 text-sm font-medium transition',
              isActive ? 'text-cnc-amber' : 'text-gray-500 hover:text-gray-700',
            )}
          >
            {t.label}
            {typeof t.count === 'number' && (
              <span className="ml-1 text-xs opacity-70">({t.count})</span>
            )}
            {isActive && (
              <span className="absolute inset-x-2 -bottom-px h-0.5 rounded-full bg-cnc-amber" />
            )}
          </button>
        );
      })}
    </div>
  );
}
