import { type LucideIcon } from 'lucide-react';

interface EmptyStateProps {
  icon: LucideIcon;
  title: string;
  subtitle?: string;
}

export function EmptyState({ icon: Icon, title, subtitle }: EmptyStateProps) {
  return (
    <div className="flex flex-col items-center justify-center px-8 py-16 text-center">
      <Icon size={52} className="mb-3 text-gray-300" />
      <p className="text-base font-semibold text-cnc-dark">{title}</p>
      {subtitle && <p className="mt-1.5 text-sm leading-relaxed text-gray-500">{subtitle}</p>}
    </div>
  );
}
