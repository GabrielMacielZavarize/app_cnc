import { create } from 'zustand';
import { persist } from 'zustand/middleware';

// Porta o purchaseService. Na web não há Google Play Billing: o serviço original
// libera premium automaticamente fora de Android/iOS, então o padrão aqui é `true`.
// Mantido como store para, no futuro, plugar Stripe/Paddle sem mudar a UI.
interface BillingState {
  isPremium: boolean;
  setPremium: (v: boolean) => void;
}

export const useBillingStore = create<BillingState>()(
  persist(
    (set) => ({
      isPremium: true,
      setPremium: (isPremium) => set({ isPremium }),
    }),
    { name: 'cncia_billing' },
  ),
);
