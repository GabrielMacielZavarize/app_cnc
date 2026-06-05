import { Check, Crown, Sparkles } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { useBillingStore } from '@/stores/billing';

const BENEFICIOS = [
  'Análise inteligente com Gemini 2.5 Flash',
  'Diagnóstico por foto da peça ou do alarme',
  'Consulta por texto e chat com o Mestre CNC',
  '6 tipos de análise especializada',
  'Sugestão de parâmetros de corte por material',
  'Suporte a 3 idiomas (PT · EN · ES)',
];

export function Paywall() {
  const isPremium = useBillingStore((s) => s.isPremium);
  const setPremium = useBillingStore((s) => s.setPremium);

  return (
    <>
      <TopBar title="CNCIA PRO" back icon={Crown} />

      <div className="space-y-5 p-5">
        <div className="rounded-3xl bg-gradient-to-br from-cnc-amber to-cnc-amberDark p-6 text-center text-white">
          <div className="mx-auto flex h-14 w-14 items-center justify-center rounded-2xl bg-white/20">
            <Sparkles size={30} />
          </div>
          <h2 className="mt-3 text-2xl font-bold">
            CNC<span className="text-cnc-dark">IA</span> PRO
          </h2>
          <p className="mt-1 text-sm text-white/90">Inteligência artificial para o seu chão de fábrica</p>
        </div>

        <div className="rounded-2xl border border-black/[0.06] bg-white p-4 shadow-sm">
          <ul className="space-y-2.5">
            {BENEFICIOS.map((b) => (
              <li key={b} className="flex items-start gap-2.5 text-sm text-gray-700">
                <span className="mt-0.5 flex h-5 w-5 shrink-0 items-center justify-center rounded-full bg-cnc-green/15 text-cnc-green">
                  <Check size={13} strokeWidth={3} />
                </span>
                <span className="leading-relaxed">{b}</span>
              </li>
            ))}
          </ul>
        </div>

        {isPremium ? (
          <div className="rounded-2xl border border-cnc-green/30 bg-cnc-green/10 p-4 text-center">
            <p className="flex items-center justify-center gap-2 font-semibold text-cnc-green">
              <Crown size={18} /> PRO ativo
            </p>
            <p className="mt-1 text-xs text-gray-500">Todos os recursos de IA estão liberados nesta versão web.</p>
          </div>
        ) : (
          <button
            type="button"
            onClick={() => setPremium(true)}
            className="w-full rounded-xl bg-cnc-dark py-3.5 text-sm font-bold text-white"
          >
            Desbloquear o PRO
          </button>
        )}

        <p className="px-2 text-center text-[11px] leading-relaxed text-gray-400">
          Na versão web os recursos de IA são liberados diretamente. A cobrança por loja (Google Play / App Store)
          fica disponível nas versões mobile. Ao continuar, você concorda com os Termos de Uso e a Política de
          Privacidade.
        </p>
      </div>
    </>
  );
}
