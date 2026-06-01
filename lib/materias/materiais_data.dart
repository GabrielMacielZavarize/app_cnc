import 'package:flutter/material.dart';

// ─────────────────────────────────────────
// MODELOS
// ─────────────────────────────────────────
class MaterialCNC {
  final String nome, norma, descricao, dureza, resistencia, densidade, maquinabilidade, aplicacoes;
  final int vcMin, vcMax;
  final Color cor;
  final IconData icone;
  final List<ParamCorte> fresamento, torneamento, furacao;
  final String fluido, concentracaoFluido, dicaFluido;
  final List<String> dicas;
  const MaterialCNC({
    required this.nome, required this.norma, required this.descricao,
    required this.dureza, required this.resistencia, required this.densidade,
    required this.maquinabilidade, required this.aplicacoes,
    required this.vcMin, required this.vcMax,
    required this.cor, required this.icone,
    required this.fresamento, required this.torneamento, required this.furacao,
    required this.fluido, required this.concentracaoFluido, required this.dicaFluido,
    required this.dicas,
  });
}

class ParamCorte {
  final String operacao, vc, fz, ap;
  const ParamCorte(this.operacao, this.vc, this.fz, this.ap);
}

// ─────────────────────────────────────────
// FRESAMENTO — 12 MATERIAIS
// ─────────────────────────────────────────
const materiaisFresamento = [
  MaterialCNC(
    nome: 'Aço Carbono (1020/1045)', norma: 'ABNT/SAE',
    descricao: 'Aço de uso geral — o mais comum na usinagem brasileira',
    dureza: '120-200 HB', resistencia: '420-620 MPa', densidade: '7.85 g/cm³',
    maquinabilidade: 'Boa (70-80%)', aplicacoes: 'Eixos, pinos, flanges, engrenagens simples',
    vcMin: 150, vcMax: 250, cor: Color(0xFF185FA5), icone: Icons.settings,
    fresamento: [
      ParamCorte('Desbaste', '150-200', '0.10-0.20', '3-8'),
      ParamCorte('Semi-acabamento', '180-220', '0.08-0.15', '1-3'),
      ParamCorte('Acabamento', '200-250', '0.05-0.10', '0.3-1'),
      ParamCorte('Fresa topo Ø10mm', '180-220', '0.04-0.08', '0.5-2'),
      ParamCorte('Fresa topo Ø20mm', '180-220', '0.06-0.12', '1-4'),
    ],
    torneamento: [], furacao: [],
    fluido: 'Emulsão solúvel 5-8%', concentracaoFluido: '5-8%',
    dicaFluido: 'Fluido abundante no desbaste. No acabamento pode usar mínima quantidade.',
    dicas: [
      'Usar fresas de metal duro com revestimento TiAlN para melhor resultado',
      'Aço 1020 é mais dúctil — cuidado com aresta postiça em baixas velocidades',
      'Para acabamento espelhado: usar Vc > 220 m/min com fz < 0.06 mm/d',
      'Aço 1045 exige parâmetros 10-15% mais conservadores que o 1020',
    ]),

  MaterialCNC(
    nome: 'Aço Inoxidável (304/316)', norma: 'AISI',
    descricao: 'Aço inox austenítico — difícil de usinar, exige cuidado especial',
    dureza: '180-220 HB', resistencia: '515-620 MPa', densidade: '7.93 g/cm³',
    maquinabilidade: 'Difícil (30-50%)', aplicacoes: 'Indústria alimentícia, química, naval, médica',
    vcMin: 80, vcMax: 150, cor: Color(0xFF0F6E56), icone: Icons.water_drop,
    fresamento: [
      ParamCorte('Desbaste', '80-120', '0.06-0.12', '1.5-4'),
      ParamCorte('Semi-acabamento', '100-130', '0.05-0.10', '0.5-1.5'),
      ParamCorte('Acabamento', '120-150', '0.03-0.07', '0.2-0.5'),
      ParamCorte('Fresa topo Ø10mm', '90-120', '0.03-0.06', '0.3-1'),
      ParamCorte('Fresamento trochoidal', '120-160', '0.05-0.08', '0.2-0.5'),
    ],
    torneamento: [], furacao: [],
    fluido: 'Óleo inteiro ou emulsão concentrada', concentracaoFluido: '8-12%',
    dicaFluido: 'ESSENCIAL — inox sem fluido gripa e endurece (encruamento).',
    dicas: [
      'NUNCA parar a ferramenta dentro do corte — causa encruamento',
      'Usar ângulo de saída positivo nas ferramentas (>15°)',
      'Evitar passes muito leves — mínimo 0.5mm para não friccionar',
      'Inox 316 é mais difícil que 304 — reduzir Vc em 15-20%',
      'Fresamento trochoidal é ideal para inox — menos calor gerado',
    ]),

  MaterialCNC(
    nome: 'Alumínio (6061/7075)', norma: 'ABNT/AA',
    descricao: 'Liga de alumínio — fácil de usinar, altíssimas velocidades possíveis',
    dureza: '60-150 HB', resistencia: '280-570 MPa', densidade: '2.70 g/cm³',
    maquinabilidade: 'Excelente (300-1000%)', aplicacoes: 'Aeroespacial, automotivo, eletrônico, moldes',
    vcMin: 300, vcMax: 1000, cor: Color(0xFFBA7517), icone: Icons.bolt,
    fresamento: [
      ParamCorte('Desbaste', '400-700', '0.10-0.25', '5-15'),
      ParamCorte('Semi-acabamento', '500-800', '0.08-0.18', '2-6'),
      ParamCorte('Acabamento', '600-1000', '0.05-0.12', '0.3-1.5'),
      ParamCorte('Fresa topo Ø10mm', '500-800', '0.06-0.15', '1-5'),
      ParamCorte('Fresa topo Ø20mm', '500-800', '0.10-0.20', '2-8'),
    ],
    torneamento: [], furacao: [],
    fluido: 'MQL ou ar comprimido', concentracaoFluido: 'MQL: 10-50 ml/h',
    dicaFluido: 'Alumínio pode ser usinado a seco com ar. MQL melhora acabamento e vida da ferramenta.',
    dicas: [
      'Usar fresa de 3 flutes para alumínio — melhor evacuação de cavaco',
      'Alto RPM é aliado no alumínio — quanto mais rápido, melhor o acabamento',
      'Ligas 7075 são mais duras — reduzir Vc em 20% em relação ao 6061',
      'Revestimento NÃO recomendado — usar fresa polida ou com revestimento DLC',
    ]),

  MaterialCNC(
    nome: 'Ferro Fundido Cinzento (FC200)', norma: 'ABNT',
    descricao: 'Ferro fundido — frágil, cavaco curto, altamente abrasivo',
    dureza: '180-240 HB', resistencia: '200-350 MPa', densidade: '7.20 g/cm³',
    maquinabilidade: 'Boa (50-70%)', aplicacoes: 'Blocos de motor, carcaças, tampas, bases de máquinas',
    vcMin: 100, vcMax: 200, cor: Color(0xFF444441), icone: Icons.hardware,
    fresamento: [
      ParamCorte('Desbaste', '100-150', '0.15-0.25', '3-8'),
      ParamCorte('Semi-acabamento', '130-180', '0.10-0.18', '1-3'),
      ParamCorte('Acabamento', '150-200', '0.05-0.12', '0.3-1'),
      ParamCorte('Fresa topo Ø10mm', '120-160', '0.06-0.12', '0.5-2'),
    ],
    torneamento: [], furacao: [],
    fluido: 'Seco (obrigatório)', concentracaoFluido: 'Sem fluido',
    dicaFluido: 'Ferro fundido DEVE ser usinado a seco. Fluido causa choque térmico e trinca.',
    dicas: [
      'NUNCA usar fluido — usinar sempre a seco com ar para remover pó',
      'Cavaco em pó — usar proteção respiratória adequada (máscara PFF2)',
      'Usar pastilha CBN para acabamento de alta qualidade',
      'A crosta superficial é muito abrasiva — primeiro passe profundo',
      'Ferro fundido nodular (FE45) exige Vc 20% menor',
    ]),

  MaterialCNC(
    nome: 'Titânio (Ti-6Al-4V)', norma: 'ASTM Grade 5',
    descricao: 'Liga de titânio — muito difícil de usinar, conduz mal o calor',
    dureza: '300-370 HB', resistencia: '900-1100 MPa', densidade: '4.43 g/cm³',
    maquinabilidade: 'Muito difícil (20-30%)', aplicacoes: 'Aeroespacial, implantes médicos, petroquímica',
    vcMin: 40, vcMax: 80, cor: Color(0xFF534AB7), icone: Icons.rocket_launch,
    fresamento: [
      ParamCorte('Desbaste', '40-60', '0.04-0.08', '0.5-2'),
      ParamCorte('Semi-acabamento', '50-70', '0.03-0.06', '0.3-1'),
      ParamCorte('Acabamento', '60-80', '0.02-0.05', '0.1-0.5'),
      ParamCorte('Trochoidal (recomendado)', '60-90', '0.04-0.07', '0.1-0.3'),
    ],
    torneamento: [], furacao: [],
    fluido: 'Emulsão alta pressão 10-15%', concentracaoFluido: '10-15%',
    dicaFluido: 'Titânio EXIGE fluido abundante e de alta pressão. Sem fluido a ferramenta dura minutos.',
    dicas: [
      'Baixas velocidades são OBRIGATÓRIAS — titânio conduz mal o calor',
      'Estratégia trochoidal é a melhor para titânio — reduz calor drasticamente',
      'Revestimento TiAlN NÃO recomendado — usar AlCrN ou carbono amorfo (DLC)',
      'NUNCA parar dentro do corte — causa microsolda da ferramenta',
      'Pastilhas novas a cada operação em peças críticas aeroespaciais',
    ]),

  MaterialCNC(
    nome: 'Aço Ferramenta (D2/H13)', norma: 'ABNT/AISI',
    descricao: 'Aço ferramenta temperado — muito duro, exige ferramentas premium',
    dureza: '58-64 HRC', resistencia: '1800-2200 MPa', densidade: '7.70 g/cm³',
    maquinabilidade: 'Muito difícil (10-20%)', aplicacoes: 'Moldes, matrizes, punções, ferramentas de corte',
    vcMin: 30, vcMax: 70, cor: Color(0xFFA32D2D), icone: Icons.construction,
    fresamento: [
      ParamCorte('Desbaste', '30-50', '0.04-0.08', '0.3-1'),
      ParamCorte('Semi-acabamento', '40-60', '0.03-0.06', '0.1-0.5'),
      ParamCorte('Acabamento', '50-70', '0.01-0.04', '0.05-0.2'),
      ParamCorte('Micro-acabamento', '60-80', '0.005-0.02', '0.02-0.1'),
    ],
    torneamento: [], furacao: [],
    fluido: 'MQL ou emulsão 10-15%', concentracaoFluido: '10-15%',
    dicaFluido: 'MQL em acabamento evita choque térmico. Evitar fluido abundante em peças temperadas.',
    dicas: [
      'Usar SOMENTE fresas de metal duro micro-grão de alta qualidade',
      'Estratégia de fresamento com ap e ae pequenos — reduz calor gerado',
      'Para HRC > 62: considerar retífica ou eletroerosão (EDM)',
      'Passes de acabamento muito leves (0.02-0.05mm) para superfície espelhada',
      'Verificar aresta a cada 10-15 minutos de corte efetivo',
    ]),

  MaterialCNC(
    nome: 'Inconel 718', norma: 'ASTM B637',
    descricao: 'Superliga de níquel — extremamente difícil, endurece durante corte',
    dureza: '350-444 HB', resistencia: '1275-1520 MPa', densidade: '8.19 g/cm³',
    maquinabilidade: 'Extremamente difícil (8-12%)', aplicacoes: 'Turbinas a gás, reatores nucleares, petroquímica de alta temperatura',
    vcMin: 20, vcMax: 50, cor: Color(0xFF6B3FA0), icone: Icons.whatshot,
    fresamento: [
      ParamCorte('Desbaste', '20-35', '0.03-0.06', '0.3-1.5'),
      ParamCorte('Semi-acabamento', '30-45', '0.02-0.05', '0.2-0.8'),
      ParamCorte('Acabamento', '40-55', '0.01-0.03', '0.1-0.4'),
      ParamCorte('Trochoidal (ideal)', '40-60', '0.03-0.05', '0.1-0.3'),
    ],
    torneamento: [], furacao: [],
    fluido: 'Emulsão alta pressão 10-15% ou óleo inteiro', concentracaoFluido: '10-15%',
    dicaFluido: 'Alta pressão de fluido (70+ bar) pelo interior da ferramenta é fundamental para Inconel.',
    dicas: [
      'Inconel endurece por deformação — NUNCA friccionar sem cortar',
      'Ferramentas de cerâmica SiAlON para desbaste de alta velocidade (Vc: 200-300 m/min)',
      'Metal duro com revestimento AlTiN para operações convencionais',
      'Trocar pastilhas frequentemente — vida muito curta nesse material',
      'Fresamento trochoidal é ESSENCIAL para produtividade aceitável',
      'Temperatura de corte controla vida da ferramenta — fluido frio é aliado',
    ]),

  MaterialCNC(
    nome: 'Cobre Puro (Cu)', norma: 'ABNT/ASTM',
    descricao: 'Cobre puro — dúctil, adere na ferramenta, exige ferramentas afiadas',
    dureza: '40-80 HB', resistencia: '200-350 MPa', densidade: '8.96 g/cm³',
    maquinabilidade: 'Moderada (60-80%)', aplicacoes: 'Eletrodos EDM, barramentos elétricos, bobinas, dissipadores',
    vcMin: 200, vcMax: 600, cor: Color(0xFFB87333), icone: Icons.electric_bolt,
    fresamento: [
      ParamCorte('Desbaste', '200-400', '0.08-0.18', '2-6'),
      ParamCorte('Semi-acabamento', '300-500', '0.06-0.12', '0.5-2'),
      ParamCorte('Acabamento', '400-600', '0.03-0.08', '0.1-0.5'),
      ParamCorte('Eletrodo EDM (fino)', '300-500', '0.02-0.05', '0.05-0.2'),
    ],
    torneamento: [], furacao: [],
    fluido: 'Seco ou MQL leve', concentracaoFluido: 'MQL: 5-15 ml/h',
    dicaFluido: 'Cobre pode ser usinado a seco. MQL leve melhora o acabamento.',
    dicas: [
      'Cobre puro adere na aresta (BUE) — usar fresa extremamente afiada',
      'Ângulo de saída MUITO positivo (>20°) é essencial',
      'Para eletrodos EDM: acabamento espelhado exige Vc alta e fz mínimo',
      'Evitar revestimentos que reduzem afiação — preferir fresa polida',
      'Cobre mole — cuidado com marcas de fixação na peça',
    ]),

  MaterialCNC(
    nome: 'Plásticos (Nylon/POM/PEEK)', norma: 'ISO/ASTM',
    descricao: 'Polímeros técnicos — fáceis de usinar, mas exigem cuidados',
    dureza: '80-120 Shore D', resistencia: '60-200 MPa', densidade: '1.10-1.45 g/cm³',
    maquinabilidade: 'Excelente (200-500%)', aplicacoes: 'Engrenagens plásticas, buchas, guias, peças médicas',
    vcMin: 100, vcMax: 500, cor: Color(0xFF2E7D32), icone: Icons.science,
    fresamento: [
      ParamCorte('Nylon — Desbaste', '100-200', '0.08-0.18', '2-6'),
      ParamCorte('Nylon — Acabamento', '150-300', '0.04-0.10', '0.2-1'),
      ParamCorte('POM (Delrin) — Desbaste', '150-250', '0.10-0.20', '2-8'),
      ParamCorte('POM — Acabamento', '200-350', '0.05-0.12', '0.2-1'),
      ParamCorte('PEEK — Desbaste', '80-150', '0.06-0.14', '1-4'),
      ParamCorte('PEEK — Acabamento', '120-200', '0.03-0.08', '0.1-0.5'),
    ],
    torneamento: [], furacao: [],
    fluido: 'Ar comprimido (preferencial)', concentracaoFluido: 'Sem fluido aquoso',
    dicaFluido: 'NÃO usar emulsão aquosa — plásticos absorvem água e deformam. Usar ar ou MQL com óleo mineral.',
    dicas: [
      'Ferramentas AFIADAS são essenciais — ferramenta cega amassa ao invés de cortar',
      'Fixação cuidadosa — plástico deforma com pressão excessiva',
      'PEEK é o mais difícil dos plásticos técnicos — similar ao alumínio em termos de força',
      'Nylon absorve umidade — usinar logo após abrir embalagem para melhor precisão',
      'Usar refrigeração a ar para evitar fusão do plástico em altas velocidades',
    ]),

  MaterialCNC(
    nome: 'Ferro Fundido Nodular (FE45)', norma: 'ABNT',
    descricao: 'Ferro fundido nodular — mais tenaz que o cinzento, cavaco mais longo',
    dureza: '140-300 HB', resistencia: '420-800 MPa', densidade: '7.10 g/cm³',
    maquinabilidade: 'Moderada (40-60%)', aplicacoes: 'Virabrequins, cubos de roda, suportes estruturais',
    vcMin: 80, vcMax: 160, cor: Color(0xFF5D4037), icone: Icons.circle,
    fresamento: [
      ParamCorte('Desbaste', '80-120', '0.12-0.22', '2-6'),
      ParamCorte('Semi-acabamento', '100-140', '0.08-0.15', '0.8-2.5'),
      ParamCorte('Acabamento', '130-160', '0.04-0.10', '0.2-0.8'),
    ],
    torneamento: [], furacao: [],
    fluido: 'Seco (preferencial)', concentracaoFluido: 'Sem fluido',
    dicaFluido: 'Preferir usinar a seco. Se usar fluido, deve ser contínuo para evitar choque térmico.',
    dicas: [
      'Mais tenaz que o cinzento — gera cavaco mais longo, não em pó',
      'Crosta de fundição extremamente abrasiva — primeiro passe profundo',
      'Dureza variável — verificar dureza antes de definir parâmetros',
      'Pastilha com raio de ponta maior (0.8-1.2mm) para melhor vida',
    ]),

  MaterialCNC(
    nome: 'Aço Rápido (HSS/M2)', norma: 'ABNT/AISI M2',
    descricao: 'Aço rápido para fabricação de ferramentas de corte',
    dureza: '62-66 HRC (pós-tempera)', resistencia: '2100-2500 MPa', densidade: '8.15 g/cm³',
    maquinabilidade: 'Difícil — usinar antes do tratamento térmico', aplicacoes: 'Fabricação de brocas, fresas, alargadores, machos',
    vcMin: 20, vcMax: 60, cor: Color(0xFF37474F), icone: Icons.build,
    fresamento: [
      ParamCorte('Desbaste (recozido)', '20-40', '0.04-0.08', '0.5-2'),
      ParamCorte('Semi-acabamento (recozido)', '30-50', '0.03-0.06', '0.2-0.8'),
      ParamCorte('Acabamento (recozido)', '40-60', '0.02-0.04', '0.05-0.3'),
    ],
    torneamento: [], furacao: [],
    fluido: 'Emulsão 8-12% ou óleo inteiro', concentracaoFluido: '8-12%',
    dicaFluido: 'Fluido abundante é essencial. HSS gera muito calor durante o corte.',
    dicas: [
      'SEMPRE usinar no estado recozido (antes da tempera)',
      'Após tempera: usar retífica ou eletroerosão (EDM)',
      'M2 é o HSS mais comum — M35 (cobalto) é mais difícil de usinar',
      'Profundidade de corte pequena evita aquecimento excessivo',
    ]),

  MaterialCNC(
    nome: 'Compósito / Fibra de Carbono (CFRP)', norma: 'ASTM D3039',
    descricao: 'Material compósito com fibras de carbono — altamente abrasivo',
    dureza: 'N/A (abrasivo)', resistencia: '600-1500 MPa', densidade: '1.55-1.60 g/cm³',
    maquinabilidade: 'Difícil (abrasivo)', aplicacoes: 'Aeroespacial, automotivo esportivo, drones, estruturas leves',
    vcMin: 150, vcMax: 400, cor: Color(0xFF212121), icone: Icons.layers,
    fresamento: [
      ParamCorte('Fresamento contorno', '150-300', '0.05-0.12', '1-3'),
      ParamCorte('Fresamento de topo', '200-350', '0.04-0.10', '0.5-2'),
      ParamCorte('Acabamento', '250-400', '0.02-0.06', '0.2-0.8'),
    ],
    torneamento: [], furacao: [],
    fluido: 'Ar comprimido de alta pressão', concentracaoFluido: 'Sem fluido aquoso',
    dicaFluido: 'NÃO usar fluido aquoso — fibra de carbono é higroscópica e pode delaminar. Usar apenas ar.',
    dicas: [
      'Ferramenta de diamante (PCD) tem vida 10-20x maior que metal duro',
      'Delaminação é o maior problema — avanço controlado e ferramenta afiada',
      'NUNCA usinar sem proteção respiratória — fibras de carbono são cancerígenas',
      'Furação requer brocas especiais para CFRP (ponta 135° dupla)',
      'Verificar delaminação na entrada e saída — usar placa de suporte',
    ]),
];

// ─────────────────────────────────────────
// TORNEAMENTO — 10 MATERIAIS
// ─────────────────────────────────────────
const materiaisTorneamento = [
  MaterialCNC(
    nome: 'Aço Carbono (1020/1045)', norma: 'ABNT/SAE',
    descricao: 'Mais usado em torneamento — eixos, pinos e porcas',
    dureza: '120-200 HB', resistencia: '420-620 MPa', densidade: '7.85 g/cm³',
    maquinabilidade: 'Boa (75%)', aplicacoes: 'Eixos de transmissão, parafusos, pinos, buchas',
    vcMin: 180, vcMax: 320, cor: Color(0xFF185FA5), icone: Icons.settings,
    fresamento: [], furacao: [],
    torneamento: [
      ParamCorte('Desbaste externo', '180-280', '0.20-0.50', '2-6'),
      ParamCorte('Acabamento externo', '250-320', '0.05-0.15', '0.2-0.8'),
      ParamCorte('Faceamento desbaste', '200-280', '0.20-0.40', '2-4'),
      ParamCorte('Faceamento acabamento', '250-320', '0.05-0.12', '0.2-0.6'),
      ParamCorte('Torneamento interno', '150-220', '0.10-0.25', '0.5-3'),
      ParamCorte('Sangramento/Corte', '80-120', '0.05-0.12', '-'),
      ParamCorte('Rosqueamento ext.', '80-120', '0.10-0.30', '-'),
      ParamCorte('Rosqueamento int.', '60-100', '0.10-0.25', '-'),
    ],
    fluido: 'Emulsão 5-8%', concentracaoFluido: '5-8%',
    dicaFluido: 'Fluido abundante no desbaste. Acabamento pode ser a seco.',
    dicas: [
      'Pastilha CNMG/TNMG para desbaste — ângulo 80° para resistência',
      'Pastilha DCMT/VCMT para acabamento — menor ângulo, melhor acabamento',
      'Velocidade acima de 250 m/min melhora muito o acabamento',
      'Eixo comprido (L/D > 4): usar luneta ou contraponta para evitar vibração',
    ]),

  MaterialCNC(
    nome: 'Aço Inoxidável 304/316', norma: 'AISI',
    descricao: 'Inox austenítico — torneamento exige cuidados especiais',
    dureza: '180-220 HB', resistencia: '515-620 MPa', densidade: '7.93 g/cm³',
    maquinabilidade: 'Difícil (35%)', aplicacoes: 'Eixos para indústria alimentícia, química e naval',
    vcMin: 100, vcMax: 200, cor: Color(0xFF0F6E56), icone: Icons.water_drop,
    fresamento: [], furacao: [],
    torneamento: [
      ParamCorte('Desbaste externo', '100-150', '0.15-0.35', '1.5-4'),
      ParamCorte('Acabamento externo', '140-200', '0.05-0.12', '0.2-0.6'),
      ParamCorte('Faceamento', '120-160', '0.10-0.25', '1-2.5'),
      ParamCorte('Torneamento interno', '80-130', '0.08-0.20', '0.3-2'),
      ParamCorte('Sangramento', '60-90', '0.04-0.10', '-'),
      ParamCorte('Rosqueamento externo', '60-90', '0.10-0.20', '-'),
    ],
    fluido: 'Emulsão concentrada 8-12%', concentracaoFluido: '8-12%',
    dicaFluido: 'Fluido OBRIGATÓRIO e abundante. Inox sem fluido endurece e quebra ferramentas.',
    dicas: [
      'NUNCA parar a pastilha dentro do corte — encruamento imediato',
      'Raio de ponta pequeno (0.4mm) para acabamento — evita vibração',
      'Profundidade mínima 0.5mm — passes rasos friccionam sem cortar',
      'Pastilha com ângulo de saída positivo (+15° a +20°)',
      'Inox 316 tem Mo — mais difícil que 304, reduzir Vc 15%',
    ]),

  MaterialCNC(
    nome: 'Alumínio — Torneamento', norma: 'ABNT/AA',
    descricao: 'Alumínio no torno — muito rápido e fácil de usinar',
    dureza: '60-150 HB', resistencia: '280-570 MPa', densidade: '2.70 g/cm³',
    maquinabilidade: 'Excelente (300-800%)', aplicacoes: 'Eixos leves, polias, buchas, componentes aeroespaciais',
    vcMin: 400, vcMax: 1200, cor: Color(0xFFBA7517), icone: Icons.bolt,
    fresamento: [], furacao: [],
    torneamento: [
      ParamCorte('Desbaste externo', '400-700', '0.20-0.50', '2-6'),
      ParamCorte('Acabamento externo', '600-1200', '0.05-0.15', '0.1-0.8'),
      ParamCorte('Faceamento', '500-900', '0.15-0.35', '1-4'),
      ParamCorte('Torneamento interno', '300-600', '0.10-0.25', '0.3-3'),
      ParamCorte('Sangramento', '200-400', '0.05-0.12', '-'),
      ParamCorte('Rosqueamento', '150-300', '0.15-0.30', '-'),
    ],
    fluido: 'Seco ou MQL', concentracaoFluido: 'MQL: 10-20 ml/h',
    dicaFluido: 'Alumínio pode ser torneado a seco com excelentes resultados.',
    dicas: [
      'Pastilha de PCD (diamante policristalino) para acabamento espelhado',
      'Ângulo de saída positivo alto (+20° a +30°) evita aderência',
      'RPM muito alto — verificar balanceamento da peça e do chuck',
      'Ligas 2xxx e 7xxx são mais difíceis — reduzir Vc em 20-30%',
    ]),

  MaterialCNC(
    nome: 'Bronze e Latão', norma: 'ABNT/CDA',
    descricao: 'Ligas de cobre — excelente maquinabilidade no torno',
    dureza: '80-120 HB', resistencia: '300-500 MPa', densidade: '8.40-8.90 g/cm³',
    maquinabilidade: 'Excelente (100-200%)', aplicacoes: 'Buchas, mancais, conexões hidráulicas, válvulas, engrenagens',
    vcMin: 200, vcMax: 500, cor: Color(0xFFB87333), icone: Icons.circle,
    fresamento: [], furacao: [],
    torneamento: [
      ParamCorte('Desbaste', '200-350', '0.20-0.50', '2-5'),
      ParamCorte('Acabamento', '300-500', '0.05-0.15', '0.2-0.8'),
      ParamCorte('Faceamento', '250-400', '0.15-0.35', '1-3'),
      ParamCorte('Rosqueamento', '100-180', '0.10-0.25', '-'),
      ParamCorte('Sangramento', '120-200', '0.04-0.10', '-'),
    ],
    fluido: 'Seco ou MQL', concentracaoFluido: 'MQL: 10-20 ml/h',
    dicaFluido: 'Bronze pode ser usinado a seco com bons resultados.',
    dicas: [
      'Ângulo de saída positivo elevado (>20°) para corte limpo',
      'Latão é mais fácil que bronze — permite Vc mais alto',
      'Bronze fosforo é mais abrasivo — reduzir Vc em 30%',
      'Cuidado com cavaco longo no latão — pode enrolar na ferramenta',
    ]),

  MaterialCNC(
    nome: 'Ferro Fundido — Torneamento', norma: 'ABNT',
    descricao: 'Torneamento de ferro fundido — sempre a seco',
    dureza: '180-240 HB', resistencia: '200-350 MPa', densidade: '7.20 g/cm³',
    maquinabilidade: 'Boa (50-70%)', aplicacoes: 'Tambores de freio, polias, buchas, carcaças',
    vcMin: 120, vcMax: 250, cor: Color(0xFF444441), icone: Icons.hardware,
    fresamento: [], furacao: [],
    torneamento: [
      ParamCorte('Desbaste externo', '120-180', '0.25-0.50', '2-5'),
      ParamCorte('Acabamento externo', '180-250', '0.08-0.15', '0.2-0.8'),
      ParamCorte('Faceamento', '150-220', '0.20-0.40', '1-3'),
      ParamCorte('Torneamento interno', '100-160', '0.12-0.25', '0.5-2.5'),
      ParamCorte('Acabamento CBN', '300-600', '0.05-0.10', '0.1-0.4'),
    ],
    fluido: 'Seco (obrigatório)', concentracaoFluido: 'Sem fluido',
    dicaFluido: 'Ferro fundido DEVE ser torneado a seco. Fluido causa choque térmico.',
    dicas: [
      'NUNCA usar fluido — sempre a seco',
      'Pastilha CBN para acabamento de alta qualidade e vida longa',
      'Crosta de fundição muito abrasiva — primeiro passe profundo',
      'Cavaco em pó — usar proteção respiratória',
    ]),

  MaterialCNC(
    nome: 'Titânio — Torneamento', norma: 'ASTM Grade 5',
    descricao: 'Torneamento de titânio — baixas velocidades obrigatórias',
    dureza: '300-370 HB', resistencia: '900-1100 MPa', densidade: '4.43 g/cm³',
    maquinabilidade: 'Muito difícil (20-30%)', aplicacoes: 'Implantes, parafusos aeroespaciais, eixos de bombas',
    vcMin: 50, vcMax: 100, cor: Color(0xFF534AB7), icone: Icons.rocket_launch,
    fresamento: [], furacao: [],
    torneamento: [
      ParamCorte('Desbaste externo', '50-80', '0.10-0.25', '1-3'),
      ParamCorte('Acabamento externo', '70-100', '0.05-0.12', '0.2-0.6'),
      ParamCorte('Faceamento', '50-80', '0.08-0.20', '0.5-2'),
      ParamCorte('Torneamento interno', '40-70', '0.06-0.15', '0.3-1.5'),
      ParamCorte('Sangramento', '30-50', '0.03-0.08', '-'),
    ],
    fluido: 'Emulsão alta pressão 10-15%', concentracaoFluido: '10-15%',
    dicaFluido: 'Fluido de alta pressão (50+ bar) pelo interior é ideal para titanio.',
    dicas: [
      'Baixas velocidades são OBRIGATÓRIAS — titânio conduz mal o calor',
      'Raio de ponta pequeno (0.4-0.8mm) para acabamento',
      'NUNCA parar dentro do corte — microsolda da ferramenta',
      'Trocar pastilha antes de sinal de desgaste — evitar catastróficos',
    ]),

  MaterialCNC(
    nome: 'Cobre — Torneamento', norma: 'ABNT/ASTM',
    descricao: 'Cobre puro no torno — macio e aderente',
    dureza: '40-80 HB', resistencia: '200-350 MPa', densidade: '8.96 g/cm³',
    maquinabilidade: 'Moderada (60-80%)', aplicacoes: 'Eletrodos, contatos elétricos, bucha condutora',
    vcMin: 200, vcMax: 600, cor: Color(0xFFB87333), icone: Icons.electric_bolt,
    fresamento: [], furacao: [],
    torneamento: [
      ParamCorte('Desbaste', '200-350', '0.15-0.35', '1.5-5'),
      ParamCorte('Acabamento', '350-600', '0.04-0.10', '0.1-0.6'),
      ParamCorte('Rosqueamento', '80-150', '0.08-0.18', '-'),
    ],
    fluido: 'Seco ou MQL', concentracaoFluido: 'MQL: 5-15 ml/h',
    dicaFluido: 'Cobre pode ser torneado a seco. MQL melhora o acabamento superficial.',
    dicas: [
      'Ângulo de saída muito positivo (>20°) é obrigatório',
      'Pastilha afiada — ferramenta cega amassa ao invés de cortar',
      'Cobre puro adere na aresta (BUE) — aumentar Vc resolve',
      'Pastilha de PCD ideal para acabamento espelhado',
    ]),

  MaterialCNC(
    nome: 'Plástico — Torneamento', norma: 'ISO',
    descricao: 'Torneamento de plásticos técnicos (POM, Nylon, PEEK)',
    dureza: '80-120 Shore D', resistencia: '60-200 MPa', densidade: '1.10-1.45 g/cm³',
    maquinabilidade: 'Excelente', aplicacoes: 'Roscas plásticas, buchas, vedações, pinhões',
    vcMin: 100, vcMax: 600, cor: Color(0xFF2E7D32), icone: Icons.science,
    fresamento: [], furacao: [],
    torneamento: [
      ParamCorte('POM — Desbaste', '150-300', '0.15-0.35', '1-4'),
      ParamCorte('POM — Acabamento', '250-500', '0.05-0.12', '0.1-0.6'),
      ParamCorte('Nylon — Desbaste', '100-200', '0.12-0.25', '1-3'),
      ParamCorte('Nylon — Acabamento', '150-350', '0.04-0.10', '0.1-0.5'),
      ParamCorte('PEEK — Desbaste', '80-150', '0.10-0.22', '0.5-2'),
      ParamCorte('PEEK — Acabamento', '120-250', '0.03-0.08', '0.1-0.4'),
    ],
    fluido: 'Ar comprimido', concentracaoFluido: 'Sem fluido aquoso',
    dicaFluido: 'NÃO usar emulsão — usar apenas ar comprimido para remover cavaco.',
    dicas: [
      'Ferramentas muito afiadas — ferramenta cega deforma o plástico',
      'POM (Delrin) é o mais fácil — acabamento espelhado com alta Vc',
      'Nylon absorve água — diferença dimensional após usinagem',
      'PEEK é o mais difícil — similar ao alumínio em comportamento',
      'Cuidado com fixação — plástico deforma com pressão do chuck',
    ]),

  MaterialCNC(
    nome: 'Inconel — Torneamento', norma: 'ASTM B637',
    descricao: 'Torneamento de Inconel — operação crítica de alto custo',
    dureza: '350-444 HB', resistencia: '1275-1520 MPa', densidade: '8.19 g/cm³',
    maquinabilidade: 'Extremamente difícil (8-12%)', aplicacoes: 'Pás de turbina, eixos de bombas de alta temp.',
    vcMin: 15, vcMax: 45, cor: Color(0xFF6B3FA0), icone: Icons.whatshot,
    fresamento: [], furacao: [],
    torneamento: [
      ParamCorte('Desbaste externo', '15-30', '0.10-0.20', '0.5-2'),
      ParamCorte('Acabamento externo', '25-45', '0.05-0.10', '0.2-0.6'),
      ParamCorte('Faceamento', '15-30', '0.08-0.18', '0.3-1.5'),
      ParamCorte('Cerâmica — desbaste', '150-250', '0.10-0.20', '0.5-2'),
    ],
    fluido: 'Emulsão alta pressão 10-15%', concentracaoFluido: '10-15%',
    dicaFluido: 'Alta pressão (70+ bar) OBRIGATÓRIA. Sem pressão alta a ferramenta dura minutos.',
    dicas: [
      'Ferramentas cerâmicas SiAlON permitem Vc 5-8x maior — verificar rigidez',
      'Desgaste muito rápido — monitorar vida da ferramenta a cada peça',
      'Encruamento severo — NUNCA friccionar ou parar dentro do corte',
      'Pastilha com cobertura de óxido de alumínio (Al₂O₃) para temperaturas altas',
    ]),

  MaterialCNC(
    nome: 'Aço Endurecido (45-65 HRC)', norma: 'ABNT/AISI',
    descricao: 'Torneamento a duro — substitui retífica em muitos casos',
    dureza: '45-65 HRC', resistencia: '1500-2500 MPa', densidade: '7.75 g/cm³',
    maquinabilidade: 'Muito difícil (5-15%)', aplicacoes: 'Matrizes, punções, eixos endurecidos, rolamentos',
    vcMin: 80, vcMax: 200, cor: Color(0xFFA32D2D), icone: Icons.construction,
    fresamento: [], furacao: [],
    torneamento: [
      ParamCorte('Desbaste CBN (45-55HRC)', '80-150', '0.10-0.20', '0.2-0.8'),
      ParamCorte('Acabamento CBN (55-65HRC)', '120-200', '0.05-0.12', '0.05-0.3'),
      ParamCorte('Cerâmica (45-55HRC)', '100-200', '0.08-0.15', '0.1-0.5'),
    ],
    fluido: 'Seco (recomendado com CBN)', concentracaoFluido: 'Sem fluido',
    dicaFluido: 'CBN pode ser usado a seco. Fluido pode causar choque térmico na pastilha cerâmica.',
    dicas: [
      'CBN (Nitreto de Boro Cúbico) é a única ferramenta viável acima de 55 HRC',
      'Torneamento a duro substitui retífica em Ra 0.4-0.8μm',
      'Rigidez da máquina é fundamental — qualquer vibração quebra a pastilha',
      'Raio de ponta 0.4-0.8mm para acabamento — maior raio melhora acabamento',
      'Verificar concentricidade antes — excentricidade quebra CBN imediatamente',
    ]),
];

// ─────────────────────────────────────────
// FURAÇÃO — 8 MATERIAIS
// ─────────────────────────────────────────
const materiaisFuracao = [
  MaterialCNC(
    nome: 'Aço Geral — Furação', norma: 'Geral',
    descricao: 'Parâmetros de furação para aços em geral',
    dureza: '120-250 HB', resistencia: '400-800 MPa', densidade: '7.85 g/cm³',
    maquinabilidade: 'Boa', aplicacoes: 'Furos passantes, cegos, roscados, alargados',
    vcMin: 20, vcMax: 100, cor: Color(0xFF185FA5), icone: Icons.radio_button_unchecked,
    fresamento: [], torneamento: [],
    furacao: [
      ParamCorte('Broca HSS Ø5mm', '20-28', '0.08-0.15', '-'),
      ParamCorte('Broca HSS Ø10mm', '22-30', '0.12-0.22', '-'),
      ParamCorte('Broca HSS Ø20mm', '25-32', '0.18-0.30', '-'),
      ParamCorte('Broca MD Ø5mm', '60-90', '0.10-0.18', '-'),
      ParamCorte('Broca MD Ø10mm', '70-100', '0.15-0.25', '-'),
      ParamCorte('Broca MD Ø20mm', '80-110', '0.20-0.35', '-'),
      ParamCorte('Alargador Ø10mm', '6-12', '0.10-0.20', '-'),
      ParamCorte('Macho M6x1.0', 'N=350rpm', '0.15-0.25', '-'),
      ParamCorte('Macho M8x1.25', 'N=280rpm', '0.18-0.30', '-'),
      ParamCorte('Macho M10x1.5', 'N=220rpm', '0.20-0.30', '-'),
      ParamCorte('Macho M12x1.75', 'N=180rpm', '0.20-0.30', '-'),
      ParamCorte('Macho M16x2.0', 'N=130rpm', '0.22-0.35', '-'),
    ],
    fluido: 'Emulsão 5-8%', concentracaoFluido: '5-8%',
    dicaFluido: 'Fluido de alta pressão pelo interior da broca melhora evacuação de cavaco em furos profundos.',
    dicas: [
      'RPM = (Vc × 1000) ÷ (π × D) — fórmula universal',
      'Furos profundos (L/D > 3): usar G83 com retração para limpar cavaco',
      'Pré-furo de centrar antes de brocas grandes melhora precisão',
      'Alargamento: velocidade baixa, avanço alto — oposto da furação',
      'Rosqueamento: F = RPM × passo da rosca',
    ]),

  MaterialCNC(
    nome: 'Alumínio — Furação', norma: 'ABNT/AA',
    descricao: 'Furação em alumínio — altas velocidades e avanços generosos',
    dureza: '60-150 HB', resistencia: '280-570 MPa', densidade: '2.70 g/cm³',
    maquinabilidade: 'Excelente', aplicacoes: 'Furos em peças aeroespaciais, moldes, estruturais',
    vcMin: 60, vcMax: 250, cor: Color(0xFFBA7517), icone: Icons.radio_button_unchecked,
    fresamento: [], torneamento: [],
    furacao: [
      ParamCorte('Broca HSS Ø5mm', '40-70', '0.12-0.25', '-'),
      ParamCorte('Broca HSS Ø10mm', '60-100', '0.20-0.40', '-'),
      ParamCorte('Broca MD Ø10mm', '150-250', '0.25-0.45', '-'),
      ParamCorte('Broca MD Ø20mm', '180-280', '0.35-0.55', '-'),
      ParamCorte('Alargador Ø10mm', '15-25', '0.15-0.30', '-'),
      ParamCorte('Macho M8x1.25', 'N=800rpm', '0.18-0.30', '-'),
      ParamCorte('Macho M10x1.5', 'N=600rpm', '0.20-0.30', '-'),
      ParamCorte('Macho M12x1.75', 'N=450rpm', '0.22-0.35', '-'),
    ],
    fluido: 'MQL ou ar comprimido', concentracaoFluido: 'MQL: 10-30 ml/h',
    dicaFluido: 'Ar comprimido funciona bem para furos curtos. MQL para furos profundos.',
    dicas: [
      'Broca de 2 flutes com ângulo de hélice alto (35-40°) para alumínio',
      'Alumínio gruda nas arestas — usar broca com revestimento DLC',
      'Aumentar avanço reduz risco de grudamento (BUE)',
      'Furos de precisão em alumínio: alargamento obrigatório',
    ]),

  MaterialCNC(
    nome: 'Aço Inox — Furação', norma: 'AISI 304/316',
    descricao: 'Furação em inox — operação mais crítica do inox',
    dureza: '180-220 HB', resistencia: '515-620 MPa', densidade: '7.93 g/cm³',
    maquinabilidade: 'Difícil', aplicacoes: 'Furos em peças para indústria alimentícia e química',
    vcMin: 8, vcMax: 40, cor: Color(0xFF0F6E56), icone: Icons.radio_button_unchecked,
    fresamento: [], torneamento: [],
    furacao: [
      ParamCorte('Broca HSS-Co Ø5mm', '8-12', '0.06-0.10', '-'),
      ParamCorte('Broca HSS-Co Ø10mm', '10-15', '0.08-0.14', '-'),
      ParamCorte('Broca MD Ø5mm', '25-40', '0.08-0.14', '-'),
      ParamCorte('Broca MD Ø10mm', '30-45', '0.10-0.18', '-'),
      ParamCorte('Broca MD Ø20mm', '35-50', '0.15-0.25', '-'),
      ParamCorte('Alargador Ø10mm', '4-8', '0.06-0.12', '-'),
      ParamCorte('Macho M8x1.25', 'N=100rpm', '0.10-0.18', '-'),
      ParamCorte('Macho M10x1.5', 'N=80rpm', '0.10-0.18', '-'),
    ],
    fluido: 'Emulsão 10-15%', concentracaoFluido: '10-15%',
    dicaFluido: 'ESSENCIAL: fluido abundante e de alta pressão. Sem fluido a broca cola e quebra.',
    dicas: [
      'Broca HSS-Cobalto (HSS-Co) é OBRIGATÓRIA para inox com HSS',
      'Avanço constante — hesitar dentro do furo causa encruamento',
      'G73 recomendado — inox gera cavaco longo e perigoso',
      'Ângulo de ponta 135° para inox (melhor que 118° padrão)',
    ]),

  MaterialCNC(
    nome: 'Ferro Fundido — Furação', norma: 'ABNT',
    descricao: 'Furação em ferro fundido — sempre a seco',
    dureza: '180-240 HB', resistencia: '200-350 MPa', densidade: '7.20 g/cm³',
    maquinabilidade: 'Boa (abrasivo)', aplicacoes: 'Furos em blocos de motor, carcaças, bases',
    vcMin: 20, vcMax: 80, cor: Color(0xFF444441), icone: Icons.radio_button_unchecked,
    fresamento: [], torneamento: [],
    furacao: [
      ParamCorte('Broca HSS Ø10mm', '15-22', '0.15-0.25', '-'),
      ParamCorte('Broca MD Ø10mm', '50-80', '0.18-0.30', '-'),
      ParamCorte('Broca MD Ø20mm', '60-90', '0.25-0.40', '-'),
      ParamCorte('Alargador Ø10mm', '6-10', '0.10-0.20', '-'),
      ParamCorte('Macho M10x1.5', 'N=150rpm', '0.15-0.25', '-'),
    ],
    fluido: 'Seco (obrigatório)', concentracaoFluido: 'Sem fluido',
    dicaFluido: 'Ferro fundido DEVE ser furado a seco. Usar ar comprimido para remover pó.',
    dicas: [
      'NUNCA usar fluido — sempre a seco',
      'Crosta de fundição muito abrasiva — broca desgasta rápido',
      'Broca com revestimento TiN ou TiAlN tem vida 3-5x maior',
      'Usar proteção respiratória — pó de ferro fundido é nocivo',
    ]),

  MaterialCNC(
    nome: 'Titânio — Furação', norma: 'ASTM Grade 5',
    descricao: 'Furação em titânio — operação crítica e cara',
    dureza: '300-370 HB', resistencia: '900-1100 MPa', densidade: '4.43 g/cm³',
    maquinabilidade: 'Muito difícil', aplicacoes: 'Furos em implantes, estruturas aeroespaciais',
    vcMin: 10, vcMax: 30, cor: Color(0xFF534AB7), icone: Icons.radio_button_unchecked,
    fresamento: [], torneamento: [],
    furacao: [
      ParamCorte('Broca MD Ø5mm', '10-18', '0.04-0.08', '-'),
      ParamCorte('Broca MD Ø10mm', '15-25', '0.05-0.10', '-'),
      ParamCorte('Broca MD Ø20mm', '18-30', '0.06-0.12', '-'),
      ParamCorte('Alargador Ø10mm', '5-10', '0.04-0.08', '-'),
      ParamCorte('Macho M8x1.25', 'N=50rpm', '0.06-0.12', '-'),
    ],
    fluido: 'Emulsão alta pressão 10-15%', concentracaoFluido: '10-15%',
    dicaFluido: 'Alta pressão de fluido OBRIGATÓRIA. Fluido pelo interior da broca é ideal.',
    dicas: [
      'Velocidades MUITO baixas são obrigatórias',
      'G83 (peck drilling) é OBRIGATÓRIO — retrair a cada 1-2× o diâmetro',
      'Broca nova a cada conjunto de furos em peças críticas',
      'Geometria especial para titânio: ângulo de hélice 30-40°',
    ]),

  MaterialCNC(
    nome: 'Bronze — Furação', norma: 'ABNT/CDA',
    descricao: 'Furação em bronze e latão — fácil mas cuide do cavaco',
    dureza: '80-120 HB', resistencia: '300-500 MPa', densidade: '8.40-8.90 g/cm³',
    maquinabilidade: 'Excelente', aplicacoes: 'Furos em buchas, válvulas, mancais',
    vcMin: 30, vcMax: 120, cor: Color(0xFFB87333), icone: Icons.radio_button_unchecked,
    fresamento: [], torneamento: [],
    furacao: [
      ParamCorte('Broca HSS Ø10mm', '30-50', '0.15-0.30', '-'),
      ParamCorte('Broca MD Ø10mm', '80-120', '0.18-0.35', '-'),
      ParamCorte('Alargador Ø10mm', '8-15', '0.12-0.22', '-'),
      ParamCorte('Macho M10x1.5', 'N=250rpm', '0.18-0.30', '-'),
    ],
    fluido: 'Seco ou MQL', concentracaoFluido: 'MQL: 5-15 ml/h',
    dicaFluido: 'Bronze pode ser furado a seco. MQL melhora o acabamento.',
    dicas: [
      'Latão tem tendência a puxar a broca — usar avanço manual controlado',
      'Broca com ângulo de ponta 118° para latão',
      'Bronze é mais abrasivo que latão — vida da ferramenta menor',
      'Cuidado com cavaco longo no latão — pode travar',
    ]),

  MaterialCNC(
    nome: 'Plástico — Furação', norma: 'ISO',
    descricao: 'Furação em plásticos técnicos',
    dureza: '80-120 Shore D', resistencia: '60-200 MPa', densidade: '1.10-1.45 g/cm³',
    maquinabilidade: 'Excelente', aplicacoes: 'Furos em peças plásticas técnicas',
    vcMin: 30, vcMax: 200, cor: Color(0xFF2E7D32), icone: Icons.radio_button_unchecked,
    fresamento: [], torneamento: [],
    furacao: [
      ParamCorte('POM — Broca Ø10mm', '60-120', '0.20-0.40', '-'),
      ParamCorte('Nylon — Broca Ø10mm', '40-80', '0.15-0.30', '-'),
      ParamCorte('PEEK — Broca Ø10mm', '30-60', '0.12-0.25', '-'),
      ParamCorte('Macho M8 em POM', 'N=400rpm', '0.15-0.25', '-'),
    ],
    fluido: 'Ar comprimido', concentracaoFluido: 'Sem fluido aquoso',
    dicaFluido: 'Usar apenas ar comprimido. Fluido aquoso deteriora plásticos higroscópicos.',
    dicas: [
      'Broca com ângulo de ponta 90-120° para plástico — evita lascar',
      'Reduzir avanço na saída do furo para evitar quebra',
      'PEEK requer fixação cuidadosa e temperatura controlada',
      'Nylon pode deformar se aquecido — controlar Vc',
    ]),

  MaterialCNC(
    nome: 'Inconel — Furação', norma: 'ASTM B637',
    descricao: 'Furação em Inconel — extremamente difícil e cara',
    dureza: '350-444 HB', resistencia: '1275-1520 MPa', densidade: '8.19 g/cm³',
    maquinabilidade: 'Extremamente difícil', aplicacoes: 'Furos em pás de turbina, câmaras de combustão',
    vcMin: 5, vcMax: 20, cor: Color(0xFF6B3FA0), icone: Icons.radio_button_unchecked,
    fresamento: [], torneamento: [],
    furacao: [
      ParamCorte('Broca MD Ø5mm', '5-10', '0.02-0.05', '-'),
      ParamCorte('Broca MD Ø10mm', '8-15', '0.03-0.07', '-'),
      ParamCorte('Broca MD Ø20mm', '10-20', '0.04-0.08', '-'),
      ParamCorte('Macho M8x1.25', 'N=30rpm', '0.04-0.08', '-'),
    ],
    fluido: 'Emulsão alta pressão 10-15%', concentracaoFluido: '10-15%',
    dicaFluido: 'Alta pressão de fluido (70+ bar) pelo interior da broca é OBRIGATÓRIA para Inconel.',
    dicas: [
      'G83 com passo mínimo (0.5× diâmetro) é OBRIGATÓRIO',
      'Broca nova a cada 3-5 furos em Inconel',
      'Alta pressão de fluido é mais importante que a velocidade',
      'Encruamento severo — avanço constante sem paradas',
      'Considerar furação orbital (circular interpolation) para furos maiores',
    ]),

  // ══════ MATERIAIS EXÓTICOS NOVOS ══════

  MaterialCNC(
    nome: 'Hastelloy C-276', norma: 'UNS N10276',
    descricao: 'Liga de níquel-molibdênio-cromo de alta resistência à corrosão',
    dureza: '240-280 HB', resistencia: '690-1000 MPa', densidade: '8.89 g/cm³',
    maquinabilidade: 'Muito difícil (25-30% do aço)', aplicacoes: 'Equipamentos químicos, dessalinizadores, trocadores de calor offshore',
    vcMin: 15, vcMax: 40, cor: const Color(0xFF5C4D7D), icone: Icons.hexagon_outlined,
    fresamento: [
      ParamCorte('Fresa topo Ø10mm carbeto', '20-35', '0.03-0.06', 'ap≤0.3D'),
      ParamCorte('Fresa topo Ø20mm carbeto', '25-40', '0.04-0.07', 'ap≤0.25D'),
      ParamCorte('Fresa de face Ø63mm', '30-45', '0.05-0.10', 'ap≤1.5mm'),
    ],
    torneamento: [
      ParamCorte('Pastilha CNMG cermet', '20-30', '0.05-0.10', '0.5-2.0mm'),
      ParamCorte('Pastilha DCMT CBN', '25-40', '0.04-0.08', '0.3-1.5mm'),
    ],
    furacao: [
      ParamCorte('Broca MD Ø6mm', '10-20', '0.02-0.04', 'G83 Q=1×D'),
      ParamCorte('Broca MD Ø12mm', '15-25', '0.03-0.06', 'G83 Q=0.5×D'),
    ],
    fluido: 'Emulsão sintética 8-12% alta pressão',
    concentracaoFluido: '8-12%',
    dicaFluido: 'Alta pressão de fluido obrigatória. Mínimo 70 bar para furação.',
    dicas: [
      'Hastelloy encrustra mais que Inconel — avanço constante NUNCA parar no corte',
      'Ferramentas de carbeto submicrograno com cobertura AlTiN ou TiAlN',
      'Refrigeração interna obrigatória em furação',
      'Vida de ferramenta muito curta — trocar preventivamente',
      'Evitar vibrações — fixação rígida e mínima saliência',
    ]),

  MaterialCNC(
    nome: 'PEEK (Poliéter Éter Cetona)', norma: 'ASTM D6262',
    descricao: 'Termoplástico de alta performance — substitui metais em aplicações leves',
    dureza: '35-40 Shore D', resistencia: '100 MPa', densidade: '1.32 g/cm³',
    maquinabilidade: 'Boa (80-100% do alumínio)', aplicacoes: 'Implantes médicos, peças aeroespaciais, isoladores elétricos, engrenagens',
    vcMin: 100, vcMax: 400, cor: const Color(0xFF8B6914), icone: Icons.hexagon,
    fresamento: [
      ParamCorte('Fresa topo Ø10mm HSS', '200-350', '0.05-0.15', 'ap≤5mm'),
      ParamCorte('Fresa topo Ø16mm carbeto', '250-400', '0.08-0.20', 'ap≤8mm'),
      ParamCorte('Fresa de face Ø50mm', '200-350', '0.10-0.25', 'ap≤2mm'),
    ],
    torneamento: [
      ParamCorte('Pastilha CCMT 80° carbeto', '150-350', '0.10-0.25', '0.5-3.0mm'),
      ParamCorte('Ferramenta HSS afiada', '100-200', '0.05-0.15', '0.5-2.0mm'),
    ],
    furacao: [
      ParamCorte('Broca HSS Ø6mm', '150-300', '0.05-0.15', 'sem G83'),
      ParamCorte('Broca MD Ø12mm', '200-350', '0.08-0.20', 'Q=3×D'),
    ],
    fluido: 'Ar comprimido seco (sem fluido) ou seco',
    concentracaoFluido: '0% (ar seco)',
    dicaFluido: 'Usar ar comprimido para evacuação de cavaco. Fluido de corte pode deformar o PEEK.',
    dicas: [
      'PEEK é abrasivo para ferramentas — preferir carbeto com cobertura DLC',
      'Temperatura máxima de usinagem: 150°C — PEEK amolece acima',
      'Fixação delicada — evitar pressão excessiva que deforme a peça',
      'Aresta de corte muito afiada — ângulo de saída positivo (15-20°)',
      'PEEK reforçado com carbono (PEEK-CF) é mais abrasivo — vida de ferramenta 50% menor',
    ]),

  MaterialCNC(
    nome: 'Titânio Ti-6Al-4V (Fresamento)', norma: 'AMS 4928 / ASTM B265',
    descricao: 'Liga alfa-beta mais usada na indústria aeroespacial e médica',
    dureza: '320-380 HB', resistencia: '900-1100 MPa', densidade: '4.43 g/cm³',
    maquinabilidade: 'Difícil (30-40% do aço)', aplicacoes: 'Estruturas aeroespaciais, implantes ortopédicos, parafusos de aviões',
    vcMin: 40, vcMax: 80, cor: const Color(0xFF1565C0), icone: Icons.hexagon,
    fresamento: [
      ParamCorte('Fresa topo Ø10mm 4FL carbeto', '40-60', '0.03-0.07', 'ap≤0.5D, ae≤0.5D'),
      ParamCorte('Fresa topo Ø16mm 4FL carbeto', '45-70', '0.04-0.08', 'ap≤0.5D, ae≤0.4D'),
      ParamCorte('Fresa de face Ø63mm', '50-80', '0.06-0.12', 'ap≤1.5mm'),
      ParamCorte('High-Feed Ø16mm (HFM)', '80-120', '0.20-0.50', 'ap≤0.3mm, ae=D'),
    ],
    torneamento: [],
    furacao: [
      ParamCorte('Broca MD Ø6mm', '25-40', '0.02-0.05', 'G83 Q=1×D'),
      ParamCorte('Broca MD Ø12mm', '30-50', '0.03-0.07', 'G83 Q=0.5×D'),
    ],
    fluido: 'Emulsão sintética 8-10% alta pressão obrigatória',
    concentracaoFluido: '8-10%',
    dicaFluido: 'Alta pressão (70+ bar) é essencial. Titânio gera calor extremo — fluido remove calor e evita incêndio.',
    dicas: [
      'ae MÁXIMO = 0.5×D — nunca fresar com D cheio em titânio',
      'Estratégia de alta velocidade com pequena profundidade (HPC) é preferida',
      'Evitar paradas no corte — encruamento intenso',
      'Ferramenta sempre afiada — pastilha nova a cada 30-60 min de corte',
      'Risco de incêndio com cavaco quente — ter extintor CO₂ próximo',
    ]),

  MaterialCNC(
    nome: 'Aço Inoxidável Duplex 2205', norma: 'UNS S31803 / EN 1.4462',
    descricao: 'Inox bifásico (austenita+ferrita) — alta resistência e anticorrosão',
    dureza: '260-310 HB', resistencia: '620-860 MPa', densidade: '7.82 g/cm³',
    maquinabilidade: 'Difícil (45-55% do aço)', aplicacoes: 'Indústria química, offshore, petroquímica, plataformas marítimas',
    vcMin: 60, vcMax: 140, cor: const Color(0xFF006064), icone: Icons.hexagon_outlined,
    fresamento: [
      ParamCorte('Fresa topo Ø10mm carbeto AlTiN', '70-100', '0.04-0.08', 'ap≤0.5D'),
      ParamCorte('Fresa topo Ø20mm carbeto', '80-120', '0.05-0.10', 'ap≤0.5D'),
      ParamCorte('Fresa de face Ø80mm', '90-140', '0.08-0.16', 'ap≤2mm'),
    ],
    torneamento: [
      ParamCorte('Pastilha CNMG cermet', '80-120', '0.08-0.15', '0.5-2.5mm'),
      ParamCorte('Pastilha DCMT CVD', '90-140', '0.06-0.12', '0.3-2.0mm'),
    ],
    furacao: [
      ParamCorte('Broca MD Ø8mm', '50-80', '0.03-0.07', 'G83 Q=1.5×D'),
      ParamCorte('Broca MD Ø16mm', '60-90', '0.05-0.10', 'G83 Q=1×D'),
    ],
    fluido: 'Emulsão semissintética 7-10%',
    concentracaoFluido: '7-10%',
    dicaFluido: 'Boa quantidade de fluido. Duplex encrustra como inox 316 — manter avanço constante.',
    dicas: [
      'Duplex 2205 encrustra rapidamente — NUNCA parar a ferramenta no corte',
      'Ferramentas com geometria de inox (alto ângulo de saída)',
      'Vida de ferramenta 30-40% menor que inox 316',
      'Monitorar desgaste de flanco — substitui antes de 0.3mm VB',
      'Fluido de boa qualidade — emulsão semissintética com EP',
    ]),

  MaterialCNC(
    nome: 'Aço Maraging 300', norma: 'AMS 6514 / ASTM A538',
    descricao: 'Aço ultrarrígido para ferramentas, moldes e aeroespacial',
    dureza: '52-56 HRC (após envelhecimento)', resistencia: '1800-2100 MPa', densidade: '8.0 g/cm³',
    maquinabilidade: 'Muito difícil endurecido / Médio recozido', aplicacoes: 'Moldes de injeção, eixos de turbinas, componentes de foguetes',
    vcMin: 30, vcMax: 80, cor: const Color(0xFF37474F), icone: Icons.hexagon,
    fresamento: [
      ParamCorte('Fresa topo Ø6mm carbeto CBN', '40-60', '0.02-0.04', 'ap≤0.2D endurecido'),
      ParamCorte('Fresa topo Ø10mm CBN', '50-80', '0.03-0.05', 'ap≤0.2D endurecido'),
      ParamCorte('Fresa bola Ø8mm CBN', '60-90', '0.02-0.04', 'ap≤0.1mm acabamento'),
    ],
    torneamento: [
      ParamCorte('Pastilha CBN (endurecido)', '50-80', '0.05-0.10', '0.1-0.5mm'),
      ParamCorte('Pastilha cermet (recozido)', '100-150', '0.10-0.20', '0.5-2.0mm'),
    ],
    furacao: [
      ParamCorte('Broca MD Ø6mm (recozido)', '40-60', '0.03-0.06', 'G83 Q=1×D'),
      ParamCorte('Broca MD Ø10mm (recozido)', '50-70', '0.04-0.08', 'G83 Q=0.8×D'),
    ],
    fluido: 'Óleo de corte integral (endurecido) / Emulsão 8% (recozido)',
    concentracaoFluido: '100% óleo ou 8%',
    dicaFluido: 'Usinar preferencialmente recozido (28-32 HRC). Após envelhecimento: apenas acabamento com CBN.',
    dicas: [
      'Usinar SEMPRE antes do envelhecimento (desbaste e semiacabamento)',
      'Após envelhecimento (52+ HRC): apenas CBN para acabamento fino',
      'Tolerâncias apertadas: considerar deformação no envelhecimento (~0.03-0.05%)',
      'Refrigeração abundante no recozido — calor causa distorção',
      'Velocidade de corte baixa com CBN — gera calor que ajuda o corte',
    ]),
];