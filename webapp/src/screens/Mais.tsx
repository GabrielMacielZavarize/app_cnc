import { useNavigate } from 'react-router-dom';
import {
  Bot,
  BookText,
  Calculator,
  CheckSquare,
  ClipboardList,
  Code2,
  Heart,
  History,
  Languages,
  Layers,
  Lightbulb,
  Ruler,
  Settings,
  Table,
  Terminal,
  Timer,
  Waves,
  type LucideIcon,
} from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { useT } from '@/stores/idioma';

interface Modulo {
  icon: LucideIcon;
  label: string;
  sub: string;
  to: string;
  color: string;
}

const GRUPOS: { titulo: string; itens: Modulo[] }[] = [
  {
    titulo: 'mais.ferramentas',
    itens: [
      { icon: Calculator, label: 'Calculadora CNC', sub: 'RPM, avanço, potência, rosca', to: '/calculadora', color: '#0F6E56' },
      { icon: Layers, label: 'Materiais', sub: '30 materiais de usinagem', to: '/materiais', color: '#E8A020' },
      { icon: Table, label: 'Tabelas Técnicas', sub: 'Roscas, conversões, parafusos', to: '/tabelas', color: '#185FA5' },
      { icon: Ruler, label: 'Tolerâncias ISO', sub: 'H7/h6, IT, ajustes comuns', to: '/tolerancias', color: '#534AB7' },
      { icon: Waves, label: 'Acabamento', sub: 'Ra/Rz, graus N1–N12', to: '/acabamento', color: '#BA7517' },
      { icon: Timer, label: 'Vida da Ferramenta', sub: 'Contador e alerta de troca', to: '/vida-ferramenta', color: '#D94040' },
    ],
  },
  {
    titulo: 'mais.programacao',
    itens: [
      { icon: Code2, label: 'Programas CNC', sub: 'Exemplos e templates', to: '/programas', color: '#2E7D32' },
      { icon: Lightbulb, label: 'Guia do Operador', sub: 'Dicas e boas práticas', to: '/guia', color: '#E8A020' },
      { icon: Terminal, label: 'Simulador de Bloco', sub: 'Entenda um bloco G/M', to: '/simulador', color: '#185FA5' },
      { icon: BookText, label: 'Manual Ilustrado', sub: 'Guias visuais de CNC', to: '/manual', color: '#534AB7' },
      { icon: Languages, label: 'Dicionário Técnico', sub: 'PT · EN · ES', to: '/dicionario', color: '#0F6E56' },
      { icon: Bot, label: 'Agente CNC', sub: 'Assistente conversacional', to: '/agente', color: '#BA7517' },
    ],
  },
  {
    titulo: 'mais.pessoal',
    itens: [
      { icon: Heart, label: 'Favoritos', sub: 'Códigos e alarmes salvos', to: '/favoritos', color: '#D94040' },
      { icon: History, label: 'Histórico & Notas', sub: 'Consultas e anotações', to: '/historico', color: '#185FA5' },
      { icon: CheckSquare, label: 'Checklist do Operador', sub: '28 passos de turno', to: '/checklist', color: '#0F6E56' },
      { icon: ClipboardList, label: 'Ordens de Produção', sub: 'Controle de peças e ciclos', to: '/ordens', color: '#534AB7' },
      { icon: History, label: 'Histórico de Setup', sub: 'Offsets G54–G59 e ferramentas', to: '/setup', color: '#BA7517' },
      { icon: Settings, label: 'Configurações', sub: 'Idioma e sobre o app', to: '/config', color: '#6B7280' },
    ],
  },
];

export function Mais() {
  const t = useT();
  const navigate = useNavigate();

  return (
    <>
      <TopBar title={t('mais.titulo')} icon={Settings} />
      <div className="space-y-6 p-5">
        {GRUPOS.map((grupo) => (
          <section key={grupo.titulo}>
            <h2 className="mb-2 px-1 text-xs font-bold uppercase tracking-wider text-gray-500">
              {t(grupo.titulo)}
            </h2>
            <div className="overflow-hidden rounded-2xl border border-black/[0.06] bg-white shadow-sm">
              {grupo.itens.map((m, i) => (
                <button
                  key={m.to + m.label}
                  type="button"
                  onClick={() => navigate(m.to)}
                  className={`flex w-full items-center gap-3 px-4 py-3 text-left transition hover:bg-gray-50 ${
                    i > 0 ? 'border-t border-black/[0.05]' : ''
                  }`}
                >
                  <div
                    className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg"
                    style={{ background: `${m.color}1A`, color: m.color }}
                  >
                    <m.icon size={18} />
                  </div>
                  <div className="min-w-0 flex-1">
                    <p className="text-sm font-semibold text-cnc-dark">{m.label}</p>
                    <p className="truncate text-[11px] text-gray-500">{m.sub}</p>
                  </div>
                </button>
              ))}
            </div>
          </section>
        ))}
      </div>
    </>
  );
}
