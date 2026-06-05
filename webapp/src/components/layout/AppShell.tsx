import { Suspense, useEffect } from 'react';
import { Outlet } from 'react-router-dom';
import { Loader2 } from 'lucide-react';
import { BottomNav } from './BottomNav';
import { useConectividadeStore } from '@/stores/conectividade';
import { useT } from '@/stores/idioma';

/**
 * Casca do app: container centralizado (mobile-first), área rolável com <Outlet />
 * e BottomNav fixo. Também registra os listeners de conectividade (online/offline).
 */
export function AppShell() {
  const t = useT();
  const online = useConectividadeStore((s) => s.online);
  const setOnline = useConectividadeStore((s) => s.setOnline);

  useEffect(() => {
    const on = () => setOnline(true);
    const off = () => setOnline(false);
    window.addEventListener('online', on);
    window.addEventListener('offline', off);
    return () => {
      window.removeEventListener('online', on);
      window.removeEventListener('offline', off);
    };
  }, [setOnline]);

  return (
    <div className="flex h-screen justify-center bg-cnc-dark">
      <div className="flex h-screen w-full max-w-[480px] flex-col overflow-hidden bg-cnc-bg shadow-2xl">
        {!online && (
          <div className="bg-cnc-red px-3 py-1.5 text-center text-xs text-white">
            {t('geral.offline.msg')}
          </div>
        )}
        <main className="flex-1 overflow-y-auto">
          <Suspense
            fallback={
              <div className="flex h-full items-center justify-center py-20">
                <Loader2 size={28} className="animate-spin text-cnc-amber" />
              </div>
            }
          >
            <Outlet />
          </Suspense>
        </main>
        <BottomNav />
      </div>
    </div>
  );
}
