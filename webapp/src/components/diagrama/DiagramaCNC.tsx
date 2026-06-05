import { type ReactNode } from 'react';

// Porta os CustomPainter de lib/widgets/diagrama_*.dart para SVG.
// Cada tipo desenha o movimento/função do código. Tipos ainda não portados
// retornam null (a tela simplesmente não mostra diagrama — fallback seguro).

const AMBER = '#E8A020';
const GREEN = '#13A06E';
const BLUE = '#3B82F6';
const GRID = '#4B5563';
const LABEL = '#9CA3AF';

function Defs() {
  return (
    <defs>
      {[
        ['arrowAmber', AMBER],
        ['arrowGreen', GREEN],
        ['arrowWhite', '#FFFFFF'],
      ].map(([id, color]) => (
        <marker
          key={id}
          id={id}
          viewBox="0 0 10 10"
          refX="7"
          refY="5"
          markerWidth="6"
          markerHeight="6"
          orient="auto-start-reverse"
        >
          <path d="M0,0 L10,5 L0,10 z" fill={color} />
        </marker>
      ))}
    </defs>
  );
}

function Eixos() {
  return (
    <g>
      <line x1={28} y1={18} x2={28} y2={126} stroke={GRID} strokeWidth={1.5} />
      <line x1={28} y1={126} x2={218} y2={126} stroke={GRID} strokeWidth={1.5} />
      <text x={16} y={24} fill={LABEL} fontSize={11}>Z</text>
      <text x={212} y={138} fill={LABEL} fontSize={11}>X</text>
    </g>
  );
}

// Cada entrada: legenda + desenho SVG.
const DIAGRAMAS: Record<string, { legenda: string; draw: ReactNode }> = {
  rapido: {
    legenda: 'Posicionamento rápido (sem corte)',
    draw: (
      <g>
        <Eixos />
        <line x1={52} y1={104} x2={188} y2={42} stroke={AMBER} strokeWidth={2.5} strokeDasharray="7 5" markerEnd="url(#arrowAmber)" />
        <circle cx={52} cy={104} r={4} fill="#fff" />
        <text x={150} y={34} fill={LABEL} fontSize={10}>G00</text>
      </g>
    ),
  },
  linear: {
    legenda: 'Interpolação linear com avanço F',
    draw: (
      <g>
        <Eixos />
        <line x1={52} y1={104} x2={188} y2={52} stroke={GREEN} strokeWidth={3} markerEnd="url(#arrowGreen)" />
        <circle cx={52} cy={104} r={4} fill="#fff" />
        <text x={150} y={44} fill={LABEL} fontSize={10}>G01 F</text>
      </g>
    ),
  },
  circular_cw: {
    legenda: 'Arco no sentido horário (CW)',
    draw: (
      <g>
        <Eixos />
        <path d="M62,112 A66,66 0 0,1 176,58" fill="none" stroke={AMBER} strokeWidth={3} markerEnd="url(#arrowAmber)" />
        <circle cx={62} cy={112} r={4} fill="#fff" />
        <text x={150} y={50} fill={LABEL} fontSize={10}>CW</text>
      </g>
    ),
  },
  circular_ccw: {
    legenda: 'Arco no sentido anti-horário (CCW)',
    draw: (
      <g>
        <Eixos />
        <path d="M62,58 A66,66 0 0,0 176,112" fill="none" stroke={AMBER} strokeWidth={3} markerEnd="url(#arrowAmber)" />
        <circle cx={62} cy={58} r={4} fill="#fff" />
        <text x={150} y={50} fill={LABEL} fontSize={10}>CCW</text>
      </g>
    ),
  },
  furar: {
    legenda: 'Ciclo de furação — avanço no eixo Z',
    draw: (
      <g>
        <rect x={64} y={84} width={120} height={44} rx={2} fill="#374151" stroke="#6B7280" />
        <rect x={116} y={22} width={16} height={66} fill={AMBER} />
        <polygon points="116,88 132,88 124,104" fill={AMBER} />
        <line x1={156} y1={30} x2={156} y2={96} stroke="#fff" strokeWidth={2} markerEnd="url(#arrowWhite)" />
        <text x={162} y={66} fill={LABEL} fontSize={10}>Z</text>
      </g>
    ),
  },
  spindle_cw: {
    legenda: 'Liga spindle no sentido horário (M03)',
    draw: (
      <g>
        <line x1={120} y1={14} x2={120} y2={136} stroke={GRID} strokeWidth={1.5} strokeDasharray="3 4" />
        <circle cx={120} cy={75} r={34} fill="none" stroke={AMBER} strokeWidth={3} />
        <path d="M120,32 A43,43 0 1,1 77,75" fill="none" stroke={AMBER} strokeWidth={2.5} markerEnd="url(#arrowAmber)" />
        <text x={120} y={80} textAnchor="middle" fill="#fff" fontSize={12} fontWeight={700}>CW</text>
      </g>
    ),
  },
  spindle_ccw: {
    legenda: 'Liga spindle no sentido anti-horário (M04)',
    draw: (
      <g>
        <line x1={120} y1={14} x2={120} y2={136} stroke={GRID} strokeWidth={1.5} strokeDasharray="3 4" />
        <circle cx={120} cy={75} r={34} fill="none" stroke={AMBER} strokeWidth={3} />
        <path d="M120,32 A43,43 0 1,0 163,75" fill="none" stroke={AMBER} strokeWidth={2.5} markerEnd="url(#arrowAmber)" />
        <text x={120} y={80} textAnchor="middle" fill="#fff" fontSize={12} fontWeight={700}>CCW</text>
      </g>
    ),
  },
  rosca: {
    legenda: 'Rosca — avanço F igual ao passo',
    draw: (
      <g>
        <line x1={28} y1={78} x2={214} y2={78} stroke={GRID} strokeWidth={1.5} strokeDasharray="3 4" />
        <polyline
          points="44,96 60,56 76,96 92,56 108,96 124,56 140,96 156,56 172,96 188,56"
          fill="none"
          stroke={AMBER}
          strokeWidth={2.5}
          strokeLinejoin="round"
        />
        <line x1={60} y1={42} x2={92} y2={42} stroke="#fff" strokeWidth={1.5} markerEnd="url(#arrowWhite)" markerStart="url(#arrowWhite)" />
        <text x={62} y={36} fill={LABEL} fontSize={10}>passo</text>
      </g>
    ),
  },
  refrigeracao: {
    legenda: 'Fluido de corte ligado (M08)',
    draw: (
      <g>
        <rect x={98} y={16} width={44} height={16} rx={2} fill="#374151" stroke="#6B7280" />
        <polygon points="110,32 130,32 120,44" fill="#374151" stroke="#6B7280" />
        {[
          [116, 58], [124, 70], [112, 84], [128, 96], [120, 110], [108, 100], [132, 120],
        ].map(([cx, cy], i) => (
          <circle key={i} cx={cx} cy={cy} r={3.5} fill={BLUE} opacity={0.85} />
        ))}
        <rect x={60} y={120} width={120} height={10} rx={2} fill="#374151" />
      </g>
    ),
  },
  troca_ferramenta: {
    legenda: 'Troca automática de ferramenta (M06)',
    draw: (
      <g>
        <circle cx={120} cy={72} r={38} fill="none" stroke={GRID} strokeWidth={2} strokeDasharray="5 5" />
        <rect x={112} y={26} width={16} height={26} rx={2} fill={AMBER} />
        <rect x={158} y={64} width={16} height={26} rx={2} fill="#6B7280" />
        <rect x={66} y={64} width={16} height={26} rx={2} fill="#6B7280" />
        <path d="M150,40 A38,38 0 0,1 158,60" fill="none" stroke={AMBER} strokeWidth={2.5} markerEnd="url(#arrowAmber)" />
      </g>
    ),
  },
  compensacao: {
    legenda: 'Compensação de raio: G41 (esquerda) e G42 (direita)',
    draw: (
      <g>
        {/* perfil programado */}
        <path d="M40,110 L40,50 L200,50" fill="none" stroke="#fff" strokeWidth={2} />
        {/* trajetória compensada (deslocada) */}
        <path d="M58,110 L58,68 L200,68" fill="none" stroke={AMBER} strokeWidth={2} strokeDasharray="6 4" />
        <circle cx={58} cy={88} r={10} fill="none" stroke={GREEN} strokeWidth={2} />
        <text x={64} y={120} fill={LABEL} fontSize={10}>fresa (raio)</text>
        <text x={150} y={44} fill="#fff" fontSize={10}>perfil</text>
        <text x={150} y={82} fill={AMBER} fontSize={10}>centro</text>
      </g>
    ),
  },
  coordenadas: {
    legenda: 'Zero-peça (G54) e sistema de coordenadas',
    draw: (
      <g>
        <rect x={70} y={60} width={110} height={60} rx={3} fill="#374151" stroke="#6B7280" />
        <line x1={70} y1={120} x2={210} y2={120} stroke={AMBER} strokeWidth={2} markerEnd="url(#arrowAmber)" />
        <line x1={70} y1={120} x2={70} y2={20} stroke={AMBER} strokeWidth={2} markerEnd="url(#arrowAmber)" />
        <circle cx={70} cy={120} r={4} fill={GREEN} />
        <text x={56} y={134} fill={GREEN} fontSize={10}>X0 Y0</text>
        <text x={200} y={134} fill={LABEL} fontSize={11}>X+</text>
        <text x={56} y={26} fill={LABEL} fontSize={11}>Y+</text>
      </g>
    ),
  },
};

// Quando o CodigoItem não traz diagramaTipo, inferimos pelo código (porta a
// seleção por código do diagrama_codigo.dart).
const POR_CODIGO: Record<string, string> = {
  G00: 'rapido',
  G01: 'linear',
  G02: 'circular_cw',
  G03: 'circular_ccw',
  G73: 'furar',
  G81: 'furar',
  G82: 'furar',
  G83: 'furar',
  G32: 'rosca',
  G74: 'rosca',
  G76: 'rosca',
  G84: 'rosca',
  G92: 'rosca',
  M03: 'spindle_cw',
  M04: 'spindle_ccw',
  M08: 'refrigeracao',
  M06: 'troca_ferramenta',
};

interface DiagramaCNCProps {
  codigo?: string;
  tipo?: string | null;
}

export function DiagramaCNC({ codigo, tipo }: DiagramaCNCProps) {
  const chave = tipo || (codigo ? POR_CODIGO[codigo] : undefined);
  const d = chave ? DIAGRAMAS[chave] : undefined;
  if (!d) return null;

  return (
    <div className="rounded-2xl bg-cnc-dark p-3">
      <svg viewBox="0 0 240 150" className="w-full" role="img" aria-label={d.legenda}>
        <Defs />
        {d.draw}
      </svg>
      <p className="mt-1 text-center text-[11px] text-gray-400">{d.legenda}</p>
    </div>
  );
}

/** Indica se há diagrama disponível para o código/tipo (porta DiagramaCodigo.has). */
export function temDiagrama(codigo?: string, tipo?: string | null): boolean {
  const chave = tipo || (codigo ? POR_CODIGO[codigo] : undefined);
  return !!chave && chave in DIAGRAMAS;
}
