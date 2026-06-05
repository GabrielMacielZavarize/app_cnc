import { Construction } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { EmptyState } from '@/components/ui/EmptyState';

interface PlaceholderProps {
  title: string;
  back?: boolean;
}

/** Tela temporária para módulos ainda não migrados (substituída onda a onda). */
export function Placeholder({ title, back = true }: PlaceholderProps) {
  return (
    <>
      <TopBar title={title} back={back} />
      <EmptyState
        icon={Construction}
        title="Em construção"
        subtitle="Esta tela será migrada nas próximas ondas da reescrita para React."
      />
    </>
  );
}
