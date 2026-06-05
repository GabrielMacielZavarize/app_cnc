import { useState } from 'react';
import { BookText, ChevronDown } from 'lucide-react';
import { TopBar } from '@/components/layout/TopBar';
import { DiagramaCNC } from '@/components/diagrama/DiagramaCNC';
import { cx } from '@/lib/cx';

interface Topico {
  id: string;
  titulo: string;
  intro: string;
  diagrama?: string;
  pontos: string[];
  parametros?: { sigla: string; desc: string }[];
}

const TOPICOS: Topico[] = [
  {
    id: 'interpolacao',
    titulo: 'Interpolação Circular (G02 / G03)',
    intro:
      'G02 faz um arco no sentido horário e G03 no anti-horário, sempre no plano ativo (G17 = XY). O arco pode ser definido pelo raio (R) ou pelo centro relativo (I, J, K).',
    diagrama: 'circular_cw',
    pontos: [
      'R positivo = arco menor que 180°; R negativo = arco maior que 180°.',
      'I, J, K são a distância do ponto inicial ao centro do arco (incremental).',
      'O sentido (CW/CCW) é visto olhando o plano de frente, contra o eixo da ferramenta.',
    ],
    parametros: [
      { sigla: 'X Y', desc: 'Ponto final do arco' },
      { sigla: 'R', desc: 'Raio do arco' },
      { sigla: 'I J', desc: 'Centro relativo ao início' },
    ],
  },
  {
    id: 'furacao',
    titulo: 'Ciclos de Furação (G81 / G83 / G84)',
    intro:
      'Ciclos fixos automatizam a furação. G81 fura direto, G83 (pica-pau) retrai para quebrar o cavaco em furos profundos, e G84 faz o rosqueamento com macho.',
    diagrama: 'furar',
    pontos: [
      'G81: furação simples até Z, ideal para furos rasos.',
      'G83: furação profunda com retração total a cada incremento Q — essencial acima de 3× o diâmetro.',
      'G84: rosqueamento rígido; use G97 (RPM fixo) e F = passo × RPM.',
      'G80 cancela qualquer ciclo fixo.',
    ],
    parametros: [
      { sigla: 'Z', desc: 'Profundidade final' },
      { sigla: 'R', desc: 'Plano de retorno (aproximação)' },
      { sigla: 'Q', desc: 'Incremento por passo (G83)' },
      { sigla: 'F', desc: 'Avanço' },
    ],
  },
  {
    id: 'compensacao',
    titulo: 'Compensação de Raio (G41 / G42)',
    intro:
      'Permite programar o perfil exato da peça — a máquina desloca a trajetória pelo raio da ferramenta automaticamente. G41 compensa à esquerda do perfil; G42 à direita.',
    diagrama: 'compensacao',
    pontos: [
      'O valor do raio fica no offset D (ex.: D01). Trocar de fresa = mudar só o D.',
      'Ative/desligue (G40) sempre em um trecho linear, com entrada/saída tangencial.',
      'G41/G42 dependem do sentido de avanço e do lado em que a peça fica.',
    ],
    parametros: [
      { sigla: 'D', desc: 'Offset com o raio da ferramenta' },
      { sigla: 'G40', desc: 'Cancela a compensação' },
    ],
  },
  {
    id: 'coordenadas',
    titulo: 'Coordenadas e Zero-Peça (G54–G59)',
    intro:
      'G54 a G59 são os sistemas de coordenadas da peça (zero-peça). G90 usa coordenadas absolutas (a partir do zero) e G91 incrementais (a partir da posição atual).',
    diagrama: 'coordenadas',
    pontos: [
      'No torno, X é o diâmetro (não o raio) e Z o comprimento.',
      'G90 (absoluto) é o padrão e o mais seguro para a maioria dos casos.',
      'Confira o zero-peça antes do primeiro ciclo — erro de G54 causa colisão.',
    ],
  },
  {
    id: 'spindle',
    titulo: 'Spindle e M-Codes essenciais',
    intro:
      'As funções miscelâneas (M) controlam a máquina: rotação, troca de ferramenta e fim de programa.',
    diagrama: 'spindle_cw',
    pontos: [
      'M03 liga o spindle horário, M04 anti-horário, M05 desliga.',
      'M06 troca a ferramenta (precedido de T).',
      'M30 encerra o programa e rebobina; M00 é parada opcional.',
    ],
    parametros: [
      { sigla: 'M03/M04', desc: 'Liga spindle CW / CCW' },
      { sigla: 'M05', desc: 'Desliga spindle' },
      { sigla: 'M06', desc: 'Troca de ferramenta' },
      { sigla: 'M30', desc: 'Fim de programa' },
    ],
  },
  {
    id: 'refrigeracao',
    titulo: 'Refrigeração (M08 / M09)',
    intro:
      'O fluido de corte refrigera, lubrifica e remove o cavaco. M08 liga a refrigeração e M09 desliga.',
    diagrama: 'refrigeracao',
    pontos: [
      'Inox e titânio exigem fluido abundante para evitar encruamento.',
      'Alumínio pode ser usinado a seco ou com MQL (mínima quantidade).',
      'Ferro fundido geralmente é usinado a seco (cavaco em pó).',
    ],
  },
  {
    id: 'velocidades',
    titulo: 'Velocidade de Corte e Avanço',
    intro:
      'A velocidade de corte (Vc) é convertida em rotação (n) pelo diâmetro. O avanço da mesa (Vf) depende do avanço por dente, do número de dentes e da rotação.',
    pontos: [
      'n = (Vc × 1000) ÷ (π × D) — rotação em RPM.',
      'Vf = fz × Z × n — avanço da mesa em mm/min.',
      'G96 mantém Vc constante (torno); G97 fixa a rotação.',
      'Use a Calculadora do app para esses cálculos.',
    ],
  },
  {
    id: 'ferramentas',
    titulo: 'Materiais de Ferramenta',
    intro:
      'A escolha do material da ferramenta define velocidade, vida útil e acabamento.',
    pontos: [
      'HSS (aço rápido): barato e tenaz, para baixas velocidades e máquinas menos rígidas.',
      'Metal duro (carbide): padrão atual, alta Vc, exige rigidez e bom fluido.',
      'Cerâmica / CBN: altíssimas velocidades em materiais duros, frágeis a impacto.',
      'Revestimentos (TiAlN, TiN) aumentam a vida e permitem mais velocidade.',
    ],
  },
];

export function Manual() {
  const [aberto, setAberto] = useState<string | null>(TOPICOS[0].id);

  return (
    <>
      <TopBar title="Manual Ilustrado" subtitle="Guias visuais de CNC" icon={BookText} back />
      <div className="space-y-2 p-4">
        {TOPICOS.map((t) => {
          const open = aberto === t.id;
          return (
            <div key={t.id} className="overflow-hidden rounded-2xl border border-black/[0.06] bg-white shadow-sm">
              <button
                type="button"
                onClick={() => setAberto(open ? null : t.id)}
                className="flex w-full items-center gap-2 p-3.5 text-left"
              >
                <span className="min-w-0 flex-1 text-sm font-semibold text-cnc-dark">{t.titulo}</span>
                <ChevronDown size={18} className={cx('shrink-0 text-gray-400 transition', open && 'rotate-180')} />
              </button>
              {open && (
                <div className="space-y-3 border-t border-black/[0.05] px-3.5 py-3.5">
                  <p className="text-sm leading-relaxed text-gray-700">{t.intro}</p>
                  {t.diagrama && <DiagramaCNC tipo={t.diagrama} />}
                  <ul className="space-y-1.5">
                    {t.pontos.map((p, i) => (
                      <li key={i} className="flex gap-2 text-sm text-gray-700">
                        <span className="mt-0.5 shrink-0 text-cnc-amber">•</span>
                        <span className="leading-relaxed">{p}</span>
                      </li>
                    ))}
                  </ul>
                  {t.parametros && (
                    <div className="overflow-hidden rounded-xl border border-black/[0.06]">
                      {t.parametros.map((p, i) => (
                        <div key={i} className={cx('flex gap-3 px-3 py-1.5 text-xs', i > 0 && 'border-t border-black/[0.05]')}>
                          <span className="w-16 shrink-0 font-mono font-semibold text-cnc-blue">{p.sigla}</span>
                          <span className="text-gray-600">{p.desc}</span>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              )}
            </div>
          );
        })}
      </div>
    </>
  );
}
