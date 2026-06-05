import { Cog } from 'lucide-react';

/** Tela de abertura — porta a SplashScreen animada do Flutter. */
export function Splash() {
  return (
    <div className="relative flex h-screen flex-col items-center justify-center bg-cnc-dark text-white">
      <div className="flex h-24 w-24 animate-[pop_0.5s_ease] items-center justify-center rounded-3xl bg-cnc-amber shadow-xl">
        <Cog size={56} className="animate-spin text-cnc-dark [animation-duration:6s]" />
      </div>
      <h1 className="mt-6 text-3xl font-bold tracking-tight">
        CNC<span className="text-cnc-amber">IA</span>
      </h1>
      <p className="mt-1 text-[11px] uppercase tracking-[0.25em] text-gray-400">
        Assistente CNC Inteligente
      </p>
      <div className="mt-8 h-1 w-40 overflow-hidden rounded-full bg-white/10">
        <div className="h-full origin-left animate-[load_2s_ease-out] bg-cnc-amber" />
      </div>
      <p className="absolute bottom-6 text-[11px] text-gray-500">v1.0.0</p>
    </div>
  );
}
