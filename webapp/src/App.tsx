import { lazy, useEffect, useState } from 'react';
import { Route, Routes } from 'react-router-dom';
import { AppShell } from '@/components/layout/AppShell';
import { Splash } from '@/screens/Splash';
import { Home } from '@/screens/Home';
import { Mais } from '@/screens/Mais';
import { Placeholder } from '@/screens/Placeholder';

// Telas carregadas sob demanda (code-splitting) — cada uma vira um chunk próprio,
// junto com os dados pesados que importa (programas, materiais, alarmes...).
const Biblioteca = lazy(() => import('@/screens/Biblioteca').then((m) => ({ default: m.Biblioteca })));
const Diagnostico = lazy(() => import('@/screens/Diagnostico').then((m) => ({ default: m.Diagnostico })));
const Calculadora = lazy(() => import('@/screens/Calculadora').then((m) => ({ default: m.Calculadora })));
const Materiais = lazy(() => import('@/screens/Materiais').then((m) => ({ default: m.Materiais })));
const Tabelas = lazy(() => import('@/screens/Tabelas').then((m) => ({ default: m.Tabelas })));
const Tolerancias = lazy(() => import('@/screens/Tolerancias').then((m) => ({ default: m.Tolerancias })));
const Acabamento = lazy(() => import('@/screens/Acabamento').then((m) => ({ default: m.Acabamento })));
const Dicionario = lazy(() => import('@/screens/Dicionario').then((m) => ({ default: m.Dicionario })));
const Simulador = lazy(() => import('@/screens/Simulador').then((m) => ({ default: m.Simulador })));
const Guia = lazy(() => import('@/screens/Guia').then((m) => ({ default: m.Guia })));
const Favoritos = lazy(() => import('@/screens/Favoritos').then((m) => ({ default: m.Favoritos })));
const Historico = lazy(() => import('@/screens/Historico').then((m) => ({ default: m.Historico })));
const Checklist = lazy(() => import('@/screens/Checklist').then((m) => ({ default: m.Checklist })));
const OrdemProducao = lazy(() => import('@/screens/OrdemProducao').then((m) => ({ default: m.OrdemProducao })));
const VidaFerramenta = lazy(() => import('@/screens/VidaFerramenta').then((m) => ({ default: m.VidaFerramenta })));
const SetupHistorico = lazy(() => import('@/screens/SetupHistorico').then((m) => ({ default: m.SetupHistorico })));
const Programas = lazy(() => import('@/screens/Programas').then((m) => ({ default: m.Programas })));
const Manual = lazy(() => import('@/screens/Manual').then((m) => ({ default: m.Manual })));
const IA = lazy(() => import('@/screens/IA').then((m) => ({ default: m.IA })));
const Agente = lazy(() => import('@/screens/Agente').then((m) => ({ default: m.Agente })));
const Paywall = lazy(() => import('@/screens/Paywall').then((m) => ({ default: m.Paywall })));
const Config = lazy(() => import('@/screens/Config').then((m) => ({ default: m.Config })));

export default function App() {
  // Splash inicial (porta a SplashScreen do Flutter).
  const [splash, setSplash] = useState(true);
  useEffect(() => {
    const id = setTimeout(() => setSplash(false), 2200);
    return () => clearTimeout(id);
  }, []);

  if (splash) return <Splash />;

  return (
    <Routes>
      <Route element={<AppShell />}>
        {/* Abas principais */}
        <Route index element={<Home />} />
        <Route path="biblioteca" element={<Biblioteca />} />
        <Route path="alarmes" element={<Diagnostico />} />
        <Route path="ia" element={<IA />} />
        <Route path="mais" element={<Mais />} />

        {/* Telas internas */}
        <Route path="calculadora" element={<Calculadora />} />
        <Route path="materiais" element={<Materiais />} />
        <Route path="tabelas" element={<Tabelas />} />
        <Route path="tolerancias" element={<Tolerancias />} />
        <Route path="acabamento" element={<Acabamento />} />
        <Route path="vida-ferramenta" element={<VidaFerramenta />} />
        <Route path="programas" element={<Programas />} />
        <Route path="guia" element={<Guia />} />
        <Route path="simulador" element={<Simulador />} />
        <Route path="manual" element={<Manual />} />
        <Route path="dicionario" element={<Dicionario />} />
        <Route path="agente" element={<Agente />} />
        <Route path="favoritos" element={<Favoritos />} />
        <Route path="historico" element={<Historico />} />
        <Route path="checklist" element={<Checklist />} />
        <Route path="ordens" element={<OrdemProducao />} />
        <Route path="setup" element={<SetupHistorico />} />
        <Route path="paywall" element={<Paywall />} />
        <Route path="config" element={<Config />} />

        <Route path="*" element={<Placeholder title="Página não encontrada" />} />
      </Route>
    </Routes>
  );
}
