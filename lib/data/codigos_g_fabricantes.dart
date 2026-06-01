import '../models.dart';

// ═══════════════════════════════════════════════════════════════
// CÓDIGOS G ESPECÍFICOS POR FABRICANTE
// Siemens SINUMERIK 840D/828D, Haas, Fanuc (especiais),
// Heidenhain iTNC/TNC 640, Mazak Mazatrol
// ═══════════════════════════════════════════════════════════════

const codigosGFabricantes = [

  // ══════════════════════════════════════════════
  // SIEMENS SINUMERIK 840D / 828D
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'CYCLE82', nome: 'Ciclo de Centramento / Furação Simples', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Siemens', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação simples ou centramento com temporização no fundo.',
    descricaoCompleta:
      'CYCLE82 é o ciclo básico de furação do Siemens SINUMERIK. Perfura até a profundidade final com avanço constante e permite uma pausa (dwell) no fundo para melhorar o acabamento. '
      'Equivale ao G81 do Fanuc mas com sintaxe de parâmetros por posição. '
      'Parâmetros: RTP = plano de retorno, RFP = plano de referência, SDIS = distância de segurança, DP = profundidade final, DPR = profundidade relativa, DTB = tempo de pausa no fundo (segundos).',
    sintaxe: 'CYCLE82(RTP, RFP, SDIS, DP, DPR, DTB)',
    parametros: [
      Parametro('RTP', 'Plano de retorno (absoluto, ex: 50.0)'),
      Parametro('RFP', 'Plano de referência — superfície da peça (ex: 0.0)'),
      Parametro('SDIS', 'Distância de segurança acima do RFP (ex: 3.0)'),
      Parametro('DP', 'Profundidade final absoluta (ex: -20.0)'),
      Parametro('DPR', 'Profundidade relativa ao RFP (alternativa ao DP)'),
      Parametro('DTB', 'Tempo de pausa no fundo em segundos (ex: 0.5)'),
    ],
    exemplo:
      'T1 D1\nS1200 M3\nG0 X30. Y20.\nCYCLE82(50., 0., 3., -18., , 0.3)\nM30',
    explicacaoExemplo:
      'Fura em X30 Y20: retorna ao plano 50, referência 0, segurança 3mm, profundidade -18mm, pausa 0.3s no fundo para acabamento limpo.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'CYCLE83', nome: 'Furação Profunda com Quebra de Cavaco', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Siemens', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação profunda com pecking — quebra ou retira cavacos em passos.',
    descricaoCompleta:
      'CYCLE83 é o ciclo de furação profunda do Siemens. Fura em incrementos (pecking) e pode apenas quebrar o cavaco (retrocede um pouco e continua) ou retrair completamente para expulsar o cavaco. '
      'Parâmetros principais: FDEP = primeira profundidade de peck, FDPR = redução de peck a cada passe, DAM = profundidade mínima de peck, DTB = pausa no fundo, DTS = pausa no retorno, FRF = fator de avanço no primeiro peck, VARI = modo (0=quebra, 1=retira cavaco).',
    sintaxe: 'CYCLE83(RTP, RFP, SDIS, DP, DPR, FDEP, FDPR, DAM, DTB, DTS, FRF, VARI)',
    parametros: [
      Parametro('RTP', 'Plano de retorno'),
      Parametro('RFP', 'Plano de referência (superfície)'),
      Parametro('SDIS', 'Distância de segurança'),
      Parametro('DP', 'Profundidade total final'),
      Parametro('FDEP', 'Primeira profundidade de peck'),
      Parametro('FDPR', 'Redução do incremento a cada peck'),
      Parametro('DAM', 'Profundidade mínima do peck'),
      Parametro('VARI', '0 = quebra de cavaco / 1 = retira cavaco completamente'),
    ],
    exemplo:
      'T3 D1 ; Broca Ø10\nS900 M3 M8\nG0 X50. Y50.\nCYCLE83(50.,0.,3.,-60.,,-15.,2.,5.,0.2,0.,1.,1)\nM9 M5\nM30',
    explicacaoExemplo:
      'Fura 60mm de profundidade em passos de 15mm, reduzindo 2mm/peck até mínimo de 5mm, retirando cavaco completamente a cada peck (VARI=1). Ideal para furos acima de 5x diâmetro.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'CYCLE84', nome: 'Rosqueamento Rígido e com Flutuante', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Siemens', diagramaTipo: 'rosca',
    descricao: 'Ciclo de rosqueamento com macho — rígido ou com mandril flutuante.',
    descricaoCompleta:
      'CYCLE84 executa rosqueamento com macho no Siemens SINUMERIK. Suporta tanto modo rígido (sincronização eletrônica spindle-Z) quanto mandril flutuante. '
      'O parâmetro SDAC define a direção do spindle (3=horário M3, 4=anti-horário M4). '
      'MPIT define o passo pela bitola da rosca (M3=0.5, M6=1.0, M10=1.5) — alternativa ao parâmetro PIT.',
    sintaxe: 'CYCLE84(RTP, RFP, SDIS, DP, DPR, DTB, SDAC, MPIT, PIT, POSS, SST, SST1)',
    parametros: [
      Parametro('RTP', 'Plano de retorno'),
      Parametro('RFP', 'Plano de referência'),
      Parametro('DP', 'Profundidade final da rosca'),
      Parametro('SDAC', 'Direção spindle: 3=M03 (direita), 4=M04 (esquerda)'),
      Parametro('MPIT', 'Passo por bitola M (ex: 10.0 para M10 = passo 1.5mm automático)'),
      Parametro('PIT', 'Passo manual em mm (alternativa ao MPIT)'),
      Parametro('SST', 'Velocidade para rosquear (RPM)'),
      Parametro('SST1', 'Velocidade para retrair (RPM — pode ser mais rápido)'),
    ],
    exemplo:
      'T5 D1 ; Macho M8\nG0 X25. Y25.\nCYCLE84(50.,0.,3.,-25.,,0.3,3,8.,,,300,600)\nM30',
    explicacaoExemplo:
      'Rosqueia M8 (MPIT=8 → passo 1.25mm automático), 25mm profundidade, 300 RPM para entrar, 600 RPM para retrair.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'CYCLE85', nome: 'Mandrilamento / Alargamento 1', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Siemens', diagramaTipo: 'furar',
    descricao: 'Ciclo de mandrilamento — entra e sai com avanço controlado.',
    descricaoCompleta:
      'CYCLE85 realiza mandrilamento ou alargamento com controle de avanço tanto na entrada quanto na saída. '
      'FFR é o avanço de entrada (furar), RFF é o avanço de retorno. Permite avanço de retorno diferente do de entrada — importante para não riscar o furo ao retrair.',
    sintaxe: 'CYCLE85(RTP, RFP, SDIS, DP, DPR, DTB, FFR, RFF)',
    parametros: [
      Parametro('RTP', 'Plano de retorno'),
      Parametro('RFP', 'Plano de referência'),
      Parametro('DP', 'Profundidade final'),
      Parametro('DTB', 'Pausa no fundo (s)'),
      Parametro('FFR', 'Avanço de furação (mm/min)'),
      Parametro('RFF', 'Avanço de retorno (mm/min — geralmente maior que FFR)'),
    ],
    exemplo:
      'T7 D1 ; Mandril ajustável Ø20\nS800 M3\nG0 X60. Y30.\nCYCLE85(50.,0.,3.,-40.,,0.5,80.,400.)\nM30',
    explicacaoExemplo:
      'Mandrilamento Ø20: entra a 80 mm/min, pausa 0.5s no fundo para acabamento, retorna a 400 mm/min (5x mais rápido, sem risco de marca).',
    isG: false,
  ),

  CodigoItem(
    codigo: 'CYCLE93', nome: 'Ciclo de Canal (Grooving)', categoria: 'Torneamento',
    maquina: 'Torno CNC', fabricante: 'Siemens', diagramaTipo: 'linear',
    descricao: 'Ciclo de retificação de canal/ranhura em tornos Siemens SINUMERIK.',
    descricaoCompleta:
      'CYCLE93 executa usinagem de canais (grooves) em tornos com controle Siemens. '
      'Define a posição, largura, profundidade e ângulos do canal. Suporta canais externos e internos, axiais e radiais. '
      'SPD = posição de partida em X, SPL = posição de partida em Z, WIDG = largura do canal, DIAG = profundidade, STA1 = ângulo do flanco direito, ANG1 = ângulo do flanco esquerdo.',
    sintaxe: 'CYCLE93(SPD, SPL, WIDG, DIAG, STA1, ANG1, RCO1, RCO2, RCI1, RCI2, FAL1, FAL2, IDEP, DTB, VARI)',
    parametros: [
      Parametro('SPD', 'Posição inicial em X (diâmetro)'),
      Parametro('SPL', 'Posição inicial em Z'),
      Parametro('WIDG', 'Largura total do canal (mm)'),
      Parametro('DIAG', 'Profundidade do canal (mm)'),
      Parametro('STA1', 'Ângulo do flanco direito (°) — 0 = reto'),
      Parametro('ANG1', 'Ângulo do flanco esquerdo (°)'),
      Parametro('DTB', 'Pausa no fundo (s)'),
      Parametro('VARI', '1=externo, 2=interno, +axial/radial'),
    ],
    exemplo:
      'G0 X52. Z-30.\nCYCLE93(52.,_30.,5.,3.,0.,0.,0.4,0.4,0.2,0.2,0.1,0.1,1.,0.2,1)\nM30',
    explicacaoExemplo:
      'Canal externo em Z-30: 5mm largo, 3mm profundo, flancos retos, raios de canto 0.4mm externos e 0.2mm internos, sobremetal 0.1mm para acabamento.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'CYCLE95', nome: 'Ciclo de Desbaste / Acabamento por Perfil', categoria: 'Torneamento',
    maquina: 'Torno CNC', fabricante: 'Siemens', diagramaTipo: 'linear',
    descricao: 'Ciclo de torneamento de contorno — desbaste e acabamento por perfil programado.',
    descricaoCompleta:
      'CYCLE95 é o ciclo mais poderoso do Siemens para torneamento de contornos complexos. '
      'O perfil é definido em um subprograma separado (contorno) e o CYCLE95 faz desbaste em passes paralelos e depois acabamento seguindo o perfil exato. '
      'NPP = nome do subprograma de perfil, MID = profundidade de corte por passe, FALZ/FALX = sobremetal de acabamento em Z e X.',
    sintaxe: 'CYCLE95(NPP, MID, FALZ, FALX, FAL, FF1, FF2, FF3, VARI, DT, DAM, _VRT)',
    parametros: [
      Parametro('NPP', 'Nome do subprograma de perfil (string, ex: "CONTORNO1")'),
      Parametro('MID', 'Profundidade máxima de corte por passe (mm)'),
      Parametro('FALZ', 'Sobremetal de acabamento em Z (mm)'),
      Parametro('FALX', 'Sobremetal de acabamento em X (mm)'),
      Parametro('FF1', 'Avanço de desbaste (mm/rot)'),
      Parametro('FF2', 'Avanço de mergulho (mm/rot)'),
      Parametro('FF3', 'Avanço de acabamento (mm/rot)'),
      Parametro('VARI', '1=desbaste ext, 2=desbaste int, 3=acab ext, 4=acab int, +5=ext+int'),
    ],
    exemplo:
      'DEF STRING[32] NPP = "PERFIL1"\nCYCLE95(NPP, 2., 0.2, 0.1, , 0.25, 0.15, 0.1, 1)\n\n; Subprograma PERFIL1.SPF:\nG1 X20. Z0.\nX30. Z-15.\nX30. Z-40.\nX50. Z-55.\nM17',
    explicacaoExemplo:
      'Desbaste externo em passes de 2mm com sobremetal 0.2mm em Z e 0.1mm em X, depois acabamento seguindo o perfil definido em PERFIL1.SPF.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'CYCLE97', nome: 'Ciclo de Rosca em Torno', categoria: 'Rosqueamento',
    maquina: 'Torno CNC', fabricante: 'Siemens', diagramaTipo: 'rosca',
    descricao: 'Ciclo completo de rosqueamento em torno — externo, interno, cônico e múltiplas entradas.',
    descricaoCompleta:
      'CYCLE97 é o ciclo de rosqueamento em torno do Siemens. Suporta rosca externa e interna, cônica, passo métrico e polegada, múltiplas entradas (multi-start), variação de passo e perfil completo do flanco. '
      'PIT = passo em mm, MPIT = passo por bitola M, KDIAM = diâmetro de início, FDIAM = diâmetro final, APP = comprimento de aproximação, ROP = comprimento de saída, TDEP = profundidade de rosca.',
    sintaxe: 'CYCLE97(PIT, MPIT, SPL, FPL, DM1, DM2, APP, ROP, TDEP, FAL, IANG, NSP, NRC, NID, VARI, NUMT)',
    parametros: [
      Parametro('PIT', 'Passo da rosca em mm (ex: 1.5 para M10)'),
      Parametro('MPIT', 'Bitola M para passo automático (ex: 10.0 para M10)'),
      Parametro('SPL', 'Posição Z de início'),
      Parametro('FPL', 'Posição Z final'),
      Parametro('DM1', 'Diâmetro de início em X'),
      Parametro('DM2', 'Diâmetro final em X (igual ao DM1 para rosca cilíndrica)'),
      Parametro('TDEP', 'Profundidade total da rosca (mm)'),
      Parametro('NRC', 'Número de passes de desbaste'),
      Parametro('VARI', '1=externa, 2=interna'),
      Parametro('NUMT', 'Número de entradas (multi-start, ex: 2 para rosca dupla)'),
    ],
    exemplo:
      'S800 M4\nCYCLE97(,10.,0.,-30.,9.9,9.9,3.,2.,0.92,0.05,-30.,0.,5,2,1,1)\nM30',
    explicacaoExemplo:
      'Rosca M10 externa: Z0 até Z-30mm, diâmetro 9.9mm, profundidade 0.92mm (passo 1.5mm automático), 5 passes de desbaste, 2 passes de acabamento, saída 2mm.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'G33', nome: 'Rosqueamento de Passo Constante (Siemens)', categoria: 'Rosqueamento',
    maquina: 'Torno CNC', fabricante: 'Siemens', diagramaTipo: 'rosca',
    descricao: 'Rosqueamento linear de passo constante — interpolação spindle + eixo.',
    descricaoCompleta:
      'G33 no Siemens SINUMERIK executa rosqueamento por sincronização eletrônica do spindle com o eixo de avanço. '
      'Diferente do Fanuc onde G33 é rosca de passo variável — no Siemens G33 é a rosca de passo FIXO, equivalente ao G32 do Fanuc. '
      'K = passo axial em mm/rotação. SF = ângulo de início para múltiplas entradas.',
    sintaxe: 'G33 Z[fim] K[passo] SF=[ângulo_início]',
    parametros: [
      Parametro('Z', 'Posição final do eixo Z'),
      Parametro('K', 'Passo da rosca em mm/rotação'),
      Parametro('SF', 'Ângulo de início do spindle para rosca multi-entrada (0–360°)'),
    ],
    exemplo:
      'G97 S600 M3\nG0 X29.8 Z3.\nG33 Z-28. K1.5\nG0 X35.\nZ3.\nX29.4\nG33 Z-28. K1.5\nG0 X35.\nM30',
    explicacaoExemplo:
      'Dois passes de rosca M30×1.5: primeiro X29.8mm depois X29.4mm. Cada passe sincroniza spindle com avanço de 1.5mm/rot.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G64', nome: 'Modo Contínuo / Suavização de Trajetória', categoria: 'Movimento',
    maquina: 'Centro de Usinagem', fabricante: 'Siemens', diagramaTipo: 'linear',
    descricao: 'Ativa modo de trajetória contínua — suaviza cantos e mantém velocidade máxima.',
    descricaoCompleta:
      'G64 no Siemens ativa o modo de avanço contínuo (continuous path mode). O CNC não para nos pontos de transição entre blocos, mas suaviza a trajetória mantendo a velocidade programada. '
      'Oposto ao G60 (posicionamento exato) e G9 (parada exata por bloco). '
      'Fundamental em usinagem de superfícies 3D e moldes onde paradas criam marcas. '
      'No Siemens pode ser combinado com SOFT (suavização de jerk) e FFWOF/FFWON (feedforward).',
    sintaxe: 'G64',
    parametros: [],
    exemplo:
      'G64\nG1 X0. Y0. F3000\nX50. Y30.\nX80. Y10.\nX100. Y50.\nG60\nG1 X120. Y50. F500',
    explicacaoExemplo:
      'G64 ativa trajetória suave para fresamento de contorno a 3000mm/min (sem marcar cantos). G60 volta ao modo exato para a operação de precisão final.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G74', nome: 'Retorno ao Ponto de Referência (Siemens)', categoria: 'Referência',
    maquina: 'Ambos', fabricante: 'Siemens', diagramaTipo: 'referencia',
    descricao: 'Move o eixo para o ponto de referência da máquina (zero máquina).',
    descricaoCompleta:
      'G74 no Siemens SINUMERIK equivale ao G28 do Fanuc — retorna ao zero máquina (ponto de referência). '
      'A sintaxe usa X1=0 Y1=0 Z1=0 para indicar quais eixos devem referenciar. '
      'Diferente do Fanuc, não passa por um ponto intermediário — vai direto ao zero máquina.',
    sintaxe: 'G74 X1=0 Y1=0 Z1=0',
    parametros: [
      Parametro('X1=0', 'Inclui eixo X no retorno ao zero máquina'),
      Parametro('Y1=0', 'Inclui eixo Y no retorno ao zero máquina'),
      Parametro('Z1=0', 'Inclui eixo Z no retorno ao zero máquina (sempre primeiro!)'),
    ],
    exemplo:
      'G74 Z1=0\nG74 X1=0 Y1=0',
    explicacaoExemplo:
      'Primeiro retorna Z ao zero máquina (segurança), depois retorna X e Y. Sempre Z primeiro para evitar colisão com peça.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // HAAS CNC — G CODES ESPECÍFICOS
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G12', nome: 'Fresamento Circular de Bolso (Horário)', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'circular_cw',
    descricao: 'Fresar um bolsão circular CW a partir do centro — específico Haas.',
    descricaoCompleta:
      'G12 (Haas) fresa um bolsão circular completo no sentido horário partindo do centro. '
      'A ferramenta espirala do centro para fora até o diâmetro programado com I (raio). '
      'F = avanço, I = raio final do bolsão, Q = incremento radial por volta (se omitido, faz em uma única passada com raio I). '
      'Muito mais fácil que programar com G02/G03 + macros.',
    sintaxe: 'G12 I[raio] Q[incremento] F[avanço]',
    parametros: [
      Parametro('I', 'Raio final do bolsão circular (mm)'),
      Parametro('Q', 'Incremento radial por espiral — omitir para passada única'),
      Parametro('F', 'Avanço em mm/min'),
    ],
    exemplo:
      'T1 M6 ; Fresa Ø10\nS3500 M3\nG0 X50. Y50. Z5.\nG1 Z-8. F500\nG12 I25. Q4. F1200\nG0 Z50.\nM30',
    explicacaoExemplo:
      'Fresar bolsão circular Ø50mm (raio 25mm), 8mm profundo. Entra no centro, espirala 4mm por volta até raio 25mm no sentido horário.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G13', nome: 'Fresamento Circular de Bolso (Anti-Horário)', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'circular_ccw',
    descricao: 'Fresar um bolsão circular CCW a partir do centro — específico Haas.',
    descricaoCompleta:
      'G13 (Haas) é idêntico ao G12 mas no sentido anti-horário (CCW). '
      'Use G12 para fresamento convencional (conventional milling) e G13 para fresamento a favor (climb milling), dependendo da estratégia desejada.',
    sintaxe: 'G13 I[raio] Q[incremento] F[avanço]',
    parametros: [
      Parametro('I', 'Raio final do bolsão circular (mm)'),
      Parametro('Q', 'Incremento radial por espiral'),
      Parametro('F', 'Avanço em mm/min'),
    ],
    exemplo:
      'G0 X0. Y0. Z5.\nG1 Z-5. F400\nG13 I20. Q5. F1000\nG0 Z50.\nM30',
    explicacaoExemplo:
      'Bolsão circular Ø40mm, sentido anti-horário (climb milling), 5mm profundo, espiral de 5mm por volta.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G150', nome: 'Fresamento de Bolsão Geral (General Pocket)', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'linear',
    descricao: 'Ciclo de fresamento de bolsão de qualquer forma definida por subprograma.',
    descricaoCompleta:
      'G150 (Haas) é o ciclo de pocketing geral — fresa qualquer forma de bolsão cujo contorno é definido em um subprograma. '
      'P = número do subprograma que define o contorno, Q = incremento de profundidade por passe, R = distância de retorno, E = tolerância de contorno, '
      'F = avanço de fresamento, H = corretor de comprimento, D = corretor de diâmetro. '
      'O subprograma descreve o contorno do bolsão com G0/G1/G2/G3.',
    sintaxe: 'G150 P[subprog] Q[incremento_Z] R[retorno] E[tolerância] F[avanço] H[corretor_comp] D[corretor_diam]',
    parametros: [
      Parametro('P', 'Número do subprograma de contorno'),
      Parametro('Q', 'Profundidade de corte por passe (mm)'),
      Parametro('R', 'Posição do plano de retorno (Z absoluto)'),
      Parametro('E', 'Tolerância de contorno (mm, ex: 0.01)'),
      Parametro('F', 'Avanço de fresamento (mm/min)'),
      Parametro('H', 'Número do corretor de comprimento de ferramenta'),
      Parametro('D', 'Número do corretor de diâmetro da fresa'),
    ],
    exemplo:
      'T5 M6 ; Fresa Ø16\nG0 G90 X0 Y0 S2500 M3\nG43 H5 Z50.\nG150 P100 Q5. R5. E.01 F1500 H5 D5\nG0 Z50.\nM30\n\nO100 (CONTORNO DO BOLSÃO)\nG0 X-30. Y-20.\nG1 X30.\nY20.\nX-30.\nY-20.\nM99',
    explicacaoExemplo:
      'Fresa bolsão retangular 60×40mm definido no subprograma O100, passes de 5mm profundidade, tolerância 0.01mm.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G187', nome: 'Controle de Suavidade de Trajetória (Haas)', categoria: 'Controle',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'linear',
    descricao: 'Define o nível de suavização de cantos e precisão de trajetória no Haas.',
    descricaoCompleta:
      'G187 (Haas) controla o trade-off entre velocidade e precisão de cantos. '
      'P1 = alta precisão (para medição e cantos vivos), P2 = padrão, P3 = alta velocidade (para superfícies suaves em moldes). '
      'E = tolerância máxima de desvio de contorno em mm — valores menores = mais preciso mas mais lento. '
      'Equivalente ao G64 com parâmetros no Siemens.',
    sintaxe: 'G187 P[modo] E[tolerância]',
    parametros: [
      Parametro('P1', 'Alta precisão — para furação e operações de posicionamento exato'),
      Parametro('P2', 'Padrão — equilibrio velocidade/precisão (padrão liga no M30)'),
      Parametro('P3', 'Alta velocidade — para superfícies 3D e moldagem'),
      Parametro('E', 'Tolerância de contorno em mm (ex: E0.01 para alta precisão)'),
    ],
    exemplo:
      '; Fresamento de molde 3D — alta velocidade\nG187 P3 E0.025\nG1 X0. Y0. F5000\nX100. Y50.\nX200. Y0.\n; Voltar ao padrão\nG187 P2',
    explicacaoExemplo:
      'G187 P3 ativa modo de alta velocidade com 0.025mm de tolerância de contorno — ideal para superfícies 3D de moldes onde marcas de parada são inaceitáveis.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // FANUC — G CODES ESPECIAIS / AVANÇADOS
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G65', nome: 'Chamada de Macro (Fanuc)', categoria: 'Macro / Subprograma',
    maquina: 'Ambos', fabricante: 'Fanuc',
    descricao: 'Chama uma macro customizada (programa O9xxx) com passagem de parâmetros.',
    descricaoCompleta:
      'G65 chama um programa de macro Fanuc (O9000–O9999). Permite passar variáveis locais (#1–#33) como parâmetros nomeados (A, B, C, D, E, F, H, I, J, K, L, M, Q, R, S, T, U, V, W, X, Y, Z). '
      'As macros possibilitam programação com lógica (IF/THEN/GOTO), loops, cálculos matemáticos e parametrização de ciclos. '
      'P = número do programa de macro, os demais são parâmetros.',
    sintaxe: 'G65 P[macro_num] [parâmetros...]',
    parametros: [
      Parametro('P', 'Número do programa de macro (O9000–O9999)'),
      Parametro('A', 'Parâmetro A → variável local #1 na macro'),
      Parametro('B', 'Parâmetro B → variável local #2 na macro'),
      Parametro('X', 'Parâmetro X → variável local #24 na macro'),
      Parametro('Z', 'Parâmetro Z → variável local #26 na macro'),
    ],
    exemplo:
      '; Chama macro de furo com chanfro\nG65 P9010 X50. Y30. Z-20. R3. A45. D5.\n\n; Macro O9010:\nO9010\nG81 X#24 Y#25 Z#26 R#18\n; ... lógica de chanfro ...\nM99',
    explicacaoExemplo:
      'Chama macro O9010 passando posição X50 Y30, profundidade Z-20, retorno R3, ângulo de chanfro A=45°, diâmetro D=5mm como variáveis locais.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G68', nome: 'Rotação do Sistema de Coordenadas', categoria: 'Transformação',
    maquina: 'Centro de Usinagem', fabricante: 'Fanuc', diagramaTipo: 'espelhamento',
    descricao: 'Rotaciona o sistema de coordenadas para usinar padrões em ângulos diferentes.',
    descricaoCompleta:
      'G68 rotaciona o sistema de coordenadas de usinagem em torno de um ponto central. '
      'Extremamente útil para usinar o mesmo contorno em múltiplos ângulos sem reprogramar. '
      'X, Y = centro de rotação, R = ângulo de rotação em graus (sentido anti-horário positivo). '
      'Cancelar com G69. Pode ser aninhado em múltiplas rotações.',
    sintaxe: 'G68 X[centro_X] Y[centro_Y] R[ângulo]\n...\nG69',
    parametros: [
      Parametro('X', 'Coordenada X do centro de rotação'),
      Parametro('Y', 'Coordenada Y do centro de rotação'),
      Parametro('R', 'Ângulo de rotação em graus (positivo = anti-horário)'),
    ],
    exemplo:
      '; Usinar furo em 0°, 90°, 180°, 270° em volta do centro\nG68 X0. Y0. R0.\nG81 X50. Y0. Z-10. R3. F100\nG69\nG68 X0. Y0. R90.\nG81 X50. Y0. Z-10. R3.\nG69\nG68 X0. Y0. R180.\nG81 X50. Y0. Z-10. R3.\nG69\nG68 X0. Y0. R270.\nG81 X50. Y0. Z-10. R3.\nG69',
    explicacaoExemplo:
      'Quatro furos equidistantes (raio 50mm) a 0°, 90°, 180° e 270° em torno da origem, usando a mesma linha G81 com rotação de coordenadas — muito mais simples que calcular as 4 posições.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G51', nome: 'Escalonamento (Scaling)', categoria: 'Transformação',
    maquina: 'Centro de Usinagem', fabricante: 'Fanuc', diagramaTipo: 'espelhamento',
    descricao: 'Escala (amplia ou reduz) o programa de usinagem por um fator.',
    descricaoCompleta:
      'G51 aplica um fator de escala ao programa. Pode escalar uniformemente em todos os eixos ou diferente em cada eixo. '
      'X, Y, Z = centro do escalonamento, P = fator de escala (ex: P2000 = fator 2.0, P500 = fator 0.5). '
      'Cancelar com G50. Útil para adaptar programas a peças de tamanhos diferentes.',
    sintaxe: 'G51 X[centro] Y[centro] Z[centro] P[fator×1000]',
    parametros: [
      Parametro('X/Y/Z', 'Centro do escalonamento (ponto fixo)'),
      Parametro('P', 'Fator de escala ×1000 (ex: P2000 = 2×, P500 = 0.5×)'),
    ],
    exemplo:
      '; Programa de quadrado 50×50, escalar para 100×100\nG51 X0. Y0. P2000\nG0 X0. Y0.\nG1 X50. F500\nY50.\nX0.\nY0.\nG50 ; cancela escala',
    explicacaoExemplo:
      'G51 P2000 duplica todas as coordenadas — o quadrado de 50mm vira 100mm automaticamente sem alterar o programa original.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // HEIDENHAIN iTNC / TNC 640
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'CYCL 1', nome: 'Furação Profunda (Heidenhain)', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Heidenhain', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação com peck — define distância de incremento e retorno.',
    descricaoCompleta:
      'CYCL DEF 1 (Heidenhain) define o ciclo de furação profunda em formato conversacional Heidenhain. '
      'A sintaxe é completamente diferente do Fanuc/Siemens — usa CYCL DEF para definir e CYCL CALL para chamar. '
      'Parâmetros: profundidade total, profundidade de peck, distância de segurança, avanço. '
      'Q1 = profundidade total, Q2 = peck (incremento), Q3 = distância de segurança, Q4 = tempo no fundo, Q5 = avanço.',
    sintaxe:
      'CYCL DEF 1.0 PECKING\nCYCL DEF 1.1 DEPTH Q1=-[prof]\nCYCL DEF 1.2 PECKG Q2=[peck]\nCYCL DEF 1.3 DWELL Q3=[pausa]\nCYCL DEF 1.4 DR+ Q4=[segurança]\nCYCL DEF 1.5 F Q5=[avanço]\nL X+[X] Y+[Y] R0 FMAX M99',
    parametros: [
      Parametro('Q1', 'Profundidade total (negativa, ex: -30)'),
      Parametro('Q2', 'Incremento de peck (positivo, ex: 8)'),
      Parametro('Q3', 'Tempo de pausa no fundo (s, ex: 0)'),
      Parametro('Q4', 'Distância de segurança (ex: 2)'),
      Parametro('Q5', 'Avanço de furação (mm/min)'),
    ],
    exemplo:
      'CYCL DEF 1.0 PECKING\nCYCL DEF 1.1 DEPTH Q1=-35\nCYCL DEF 1.2 PECKG Q2=8\nCYCL DEF 1.3 DWELL Q3=0\nCYCL DEF 1.4 DR+ Q4=2\nCYCL DEF 1.5 F Q5=180\nL X+50 Y+30 R0 FMAX M99\nL X+80 Y+30 R0 FMAX M99',
    explicacaoExemplo:
      'Define ciclo de furação 35mm profundo em pecks de 8mm, 180mm/min. Executa em X50Y30 e depois X80Y30 com FMAX para posicionamento rápido.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'CYCL 2', nome: 'Rosqueamento com Macho (Heidenhain)', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Heidenhain', diagramaTipo: 'rosca',
    descricao: 'Ciclo de rosqueamento Heidenhain — define profundidade e passo da rosca.',
    descricaoCompleta:
      'CYCL DEF 2 (Heidenhain) é o ciclo de rosqueamento com macho. '
      'No Heidenhain, o passo da rosca é inserido diretamente como avanço F calculado: F = RPM × passo. '
      'Ou seja, para M10×1.5 a 300 RPM: F = 300 × 1.5 = 450mm/min. '
      'O ciclo sincroniza automaticamente spindle e eixo Z.',
    sintaxe:
      'CYCL DEF 2.0 TAPPING\nCYCL DEF 2.1 DEPTH Q1=-[prof]\nCYCL DEF 2.2 DWELL Q2=[pausa]\nCYCL DEF 2.3 F Q3=[rpm×passo]\nL X+[X] Y+[Y] R0 FMAX M3 M99',
    parametros: [
      Parametro('Q1', 'Profundidade da rosca (negativa)'),
      Parametro('Q2', 'Tempo de pausa no fundo (geralmente 0)'),
      Parametro('Q3', 'Avanço = RPM × passo (ex: 300 RPM × 1.5mm = 450)'),
    ],
    exemplo:
      'S300 M3\nCYCL DEF 2.0 TAPPING\nCYCL DEF 2.1 DEPTH Q1=-20\nCYCL DEF 2.2 DWELL Q2=0\nCYCL DEF 2.3 F Q3=450\nL X+30 Y+20 R0 FMAX M99',
    explicacaoExemplo:
      'Rosca M10×1.5: 300 RPM × 1.5 = 450 mm/min. Rosqueia 20mm de profundidade em X30Y20.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'CYCL 17', nome: 'Fresamento de Rosca Interna (Heidenhain)', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Heidenhain', diagramaTipo: 'rosca',
    descricao: 'Ciclo de fresamento de rosca com fresa de rosca — faz rosca sem macho.',
    descricaoCompleta:
      'CYCL DEF 17 (Heidenhain) fresa rosca interna com fresa de rosca helicoidal — dispensa o uso de macho. '
      'A fresa entra no centro, executa uma hélice e sai. Vantagem: uma só fresa faz várias bitolas, menos quebra de ferramenta em materiais difíceis. '
      'Q1 = profundidade da rosca, Q2 = passo em mm, Q3 = diâmetro nominal da rosca.',
    sintaxe:
      'CYCL DEF 17.0 THREAD MILLING\nCYCL DEF 17.1 DEPTH Q1=-[prof]\nCYCL DEF 17.2 PITCH Q2=[passo]\nCYCL DEF 17.3 NOMINAL DIA Q3=[diam_nom]\nL X+[X] Y+[Y] R0 FMAX M99',
    parametros: [
      Parametro('Q1', 'Profundidade da rosca (mm)'),
      Parametro('Q2', 'Passo da rosca (mm)'),
      Parametro('Q3', 'Diâmetro nominal da rosca (mm)'),
    ],
    exemplo:
      'CYCL DEF 17.0 THREAD MILLING\nCYCL DEF 17.1 DEPTH Q1=-18\nCYCL DEF 17.2 PITCH Q2=1.5\nCYCL DEF 17.3 NOMINAL DIA Q3=10\nL X+40 Y+40 R0 FMAX M99',
    explicacaoExemplo:
      'Fresa rosca M10×1.5 com 18mm de profundidade usando fresa de rosca. A ferramenta executa movimento helicoidal sem necessidade de macho.',
    isG: false,
  ),

  // ══════════════════════════════════════════════
  // MAZAK MAZATROL
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G10', nome: 'Entrada de Dados por Programa (Mazak/Fanuc)', categoria: 'Corretor',
    maquina: 'Ambos', fabricante: 'Fanuc', diagramaTipo: 'referencia',
    descricao: 'Define valores de corretores de ferramenta e coordenadas de trabalho diretamente no programa.',
    descricaoCompleta:
      'G10 permite definir ou alterar corretores de ferramenta (comprimento, raio) e offsets de trabalho (G54–G59) diretamente via programa CNC, sem acessar o painel. '
      'L1 = corretor de geometria, L2 = corretor de desgaste, L10 = offset de trabalho. '
      'P = número do corretor, R = valor. Muito usado em automação para atualizar desgaste de ferramenta automaticamente.',
    sintaxe:
      'G10 L[tipo] P[num] R[valor]\n\nG10 L1 P[tool] R[comp_Z] ; corretor comprimento\nG10 L2 P[54-59] X[x] Y[y] Z[z] ; offset trabalho',
    parametros: [
      Parametro('L1', 'Corretor de geometria de ferramenta'),
      Parametro('L2', 'Corretor de desgaste de ferramenta'),
      Parametro('L10', 'Offset de sistema de coordenadas (G54=P1, G55=P2...)'),
      Parametro('P', 'Número do corretor ou offset'),
      Parametro('R', 'Valor a definir (mm)'),
    ],
    exemplo:
      '; Definir offset G54 via programa\nG10 L2 P1 X-250.5 Y-180.3 Z-320.8\n\n; Atualizar desgaste ferramenta T1\nG10 L11 P1 R-0.05\n\nG54\nG0 X0. Y0.',
    explicacaoExemplo:
      'Define o offset G54 (P1) com os valores de X, Y, Z da origem da peça. Depois ajusta -0.05mm de desgaste no corretor da ferramenta 1 — tudo via programa sem operador.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // MAZAK — MAZATROL SmoothX / Matrix / Fusion
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G100', nome: 'Macro Call — Mazatrol Macro', categoria: 'Macro',
    maquina: 'Ambos', fabricante: 'Mazak',
    descricao: 'Chamada de macro de usuário no Mazatrol. Equivale ao G65 Fanuc.',
    descricaoCompleta:
      'G100 chama um subprograma de macro Mazak. No SmoothX permite passar até 26 variáveis (A–Z). '
      'As variáveis são acessadas internamente como #1–#26. Muito usado em ciclos customizados de furação, '
      'rosqueamento e medição na linha.',
    sintaxe: 'G100 P[número] A[val] B[val] C[val]...',
    parametros: [
      Parametro('P', 'Número do subprograma macro (ex: P1000)'),
      Parametro('A–Z', 'Variáveis a passar para o macro (#1–#26)'),
    ],
    exemplo: '; Chama macro de furação customizado\nG100 P1000 A25.0 B10.0 C-30.0\n; A=diâmetro, B=passo, C=prof.',
    explicacaoExemplo: 'Executa macro 1000 passando diâmetro 25mm, passo 10mm e profundidade -30mm.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G10.9', nome: 'Programação de Geometria de Ferramenta', categoria: 'Ferramenta',
    maquina: 'Centro de Usinagem', fabricante: 'Mazak',
    descricao: 'Define ou modifica dados de geometria da ferramenta diretamente via programa.',
    descricaoCompleta:
      'G10.9 permite definir comprimento, raio e desgaste de ferramentas diretamente no programa CNC '
      'no Mazak SmoothX/Matrix. Equivalente ao G10 do Fanuc mas com sintaxe estendida para o Mazatrol. '
      'Muito usado para automação de setup e troca de insertos sem intervenção do operador.',
    sintaxe: 'G10.9 T[num] H[comp] R[raio] WL[desgaste_comp] WR[desgaste_raio]',
    parametros: [
      Parametro('T', 'Número da ferramenta'),
      Parametro('H', 'Comprimento da ferramenta (mm)'),
      Parametro('R', 'Raio da ferramenta (mm)'),
      Parametro('WL', 'Desgaste de comprimento (positivo = subtrai material)'),
      Parametro('WR', 'Desgaste de raio'),
    ],
    exemplo: '; Atualiza ferramenta T5 após medição\nG10.9 T5 H125.485 R5.000 WL0.000 WR0.000',
    explicacaoExemplo: 'Define T5 com comprimento medido 125.485mm e raio 5mm, zerando desgastes.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G200', nome: 'Ciclo de Furação Profunda — Mazak', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Mazak', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação profunda com pecking nativo do Mazatrol SmoothX.',
    descricaoCompleta:
      'G200 é o ciclo de furação profunda do Mazatrol. Semelhante ao G83 Fanuc, mas com parâmetros '
      'de redução automática de peck e controle de fluido integrado. No SmoothX, aceita parâmetros '
      'adicionais para controle de alta velocidade e refrigeração.',
    sintaxe: 'G200 X[x] Y[y] Z[prof] R[ref] Q[peck] F[avanço]',
    parametros: [
      Parametro('X, Y', 'Posição do furo'),
      Parametro('Z', 'Profundidade final'),
      Parametro('R', 'Plano de referência (distância de segurança)'),
      Parametro('Q', 'Profundidade de cada peck (positivo)'),
      Parametro('F', 'Avanço de furação (mm/min)'),
    ],
    exemplo: 'S1200 M3 M8\nG200 X50. Y30. Z-45. R3. Q8. F180',
    explicacaoExemplo: 'Fura em X50 Y30 até -45mm em passo de 8mm a 180mm/min, com refrigeração ativa.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G201', nome: 'Ciclo de Rosqueamento — Mazak', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Mazak', diagramaTipo: 'rosca',
    descricao: 'Ciclo de rosqueamento rígido com sincronização spindle-eixo Z no Mazatrol.',
    descricaoCompleta:
      'G201 executa rosqueamento rígido sincronizando a rotação do spindle com o avanço em Z. '
      'No SmoothX, suporta aceleração/desaceleração otimizada para roscas de alta velocidade. '
      'O passo é calculado por: F = S × passo.',
    sintaxe: 'G201 X[x] Y[y] Z[prof] R[ref] F[avanço]',
    parametros: [
      Parametro('Z', 'Profundidade da rosca (negativo)'),
      Parametro('R', 'Plano de aproximação'),
      Parametro('F', 'Avanço = RPM × passo (ex: M10 a 800rpm → F800)'),
    ],
    exemplo: '; M10 × 1.5mm — Rosca métrica\nS800 M3\nG201 X100. Y50. Z-25. R3. F1200\n; F = 800 × 1.5 = 1200',
    explicacaoExemplo: 'Rosqueia M10×1.5 a 800rpm até -25mm. F=1200 = 800rpm × 1.5mm de passo.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G206', nome: 'Ciclo de Fresamento de Furo (Helical) — Mazak', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'Mazak', diagramaTipo: 'circular_cw',
    descricao: 'Ciclo de fresamento helicoidal de furos no Mazatrol SmoothX.',
    descricaoCompleta:
      'G206 executa um ciclo de fresamento helicoidal (helical interpolation) para abrir ou acabar furos '
      'com fresa de topo. Elimina a necessidade de broca em furos grandes. Permite controlar diâmetro '
      'final, profundidade e passo helicoidal.',
    sintaxe: 'G206 X[x] Y[y] Z[prof] R[ref] I[raio_fresa] Q[passo_z] F[avanço]',
    parametros: [
      Parametro('I', 'Raio de interpolação helicoidal'),
      Parametro('Q', 'Passo axial por volta (mm/revolução)'),
      Parametro('Z', 'Profundidade total'),
      Parametro('F', 'Avanço de corte mm/min'),
    ],
    exemplo: '; Furo Ø50mm com fresa Ø12mm\nG206 X0 Y0 Z-20. R2. I19. Q2. F300',
    explicacaoExemplo: 'Fresa furo Ø50mm (I=19 = (50-12)/2) em hélice de 2mm/volta até -20mm de profundidade.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // OKUMA — OSP-P300 / P200 / P500
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G1026', nome: 'Compensação Dinâmica de Ferramenta — Okuma', categoria: 'Compensação',
    maquina: 'Centro de Usinagem', fabricante: 'Okuma',
    descricao: 'Compensação dinâmica de raio de fresa com controle de avanço adaptativo.',
    descricaoCompleta:
      'G1026 é uma função exclusiva do OSP-P300 (Okuma) que aplica compensação de raio de fresa '
      'com ajuste automático de avanço nos cantos e arcos. Garante velocidade de corte constante '
      'ao redor do contorno, melhorando acabamento superficial. Substitui o par G41/G42 em programação avançada.',
    sintaxe: 'G1026 D[num_offset] F[avanço_nominal]',
    parametros: [
      Parametro('D', 'Número do offset de raio da fresa'),
      Parametro('F', 'Avanço nominal de referência'),
    ],
    exemplo: 'G1026 D1 F300\nG1 X100. Y0 F300\nG3 X0 Y100. R100.\nG1027 ; cancelar',
    explicacaoExemplo: 'Ativa compensação dinâmica Okuma com D1, percorre contorno e cancela com G1027.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G28.1', nome: 'Retorno ao Ponto de Referência — Okuma OSP', categoria: 'Referência',
    maquina: 'Ambos', fabricante: 'Okuma', diagramaTipo: 'referencia',
    descricao: 'Retorno ao ponto de referência da máquina via ponto intermediário no OSP.',
    descricaoCompleta:
      'No Okuma OSP, G28.1 executa o zero return via um ponto intermediário de forma segura. '
      'Semelhante ao G28 Fanuc mas com controle de velocidade de aproximação independente. '
      'Aceita parâmetros de velocidade de busca de home e tolerância de posicionamento.',
    sintaxe: 'G28.1 X[x] Y[y] Z[z]',
    parametros: [
      Parametro('X, Y, Z', 'Coordenadas do ponto intermediário antes de ir ao home'),
    ],
    exemplo: '; Retorno via ponto seguro\nG28.1 Z50.\nG28.1 X0. Y0.',
    explicacaoExemplo: 'Sobe Z para 50mm (seguro), depois faz home de X e Y pelo OSP.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G2001', nome: 'Ciclo de Furação Profunda OSP', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Okuma', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação profunda com pecking no controle OSP-P300/P500.',
    descricaoCompleta:
      'G2001 é o ciclo de furação profunda do Okuma OSP. Funciona com pecking controlado, '
      'retração para limpeza de cavaco e redução automática de incremento. O OSP-P500 aceita '
      'parâmetros adicionais para refrigeração de alta pressão e controle adaptativo de carga.',
    sintaxe: 'G2001 X[x] Y[y] Z[prof] D[peck] R[ref] F[av]',
    parametros: [
      Parametro('Z', 'Profundidade total'),
      Parametro('D', 'Profundidade do peck'),
      Parametro('R', 'Plano de referência'),
      Parametro('F', 'Avanço de furação'),
    ],
    exemplo: 'S1500 M3 M8\nG2001 X80. Y40. Z-60. D12. R3. F200',
    explicacaoExemplo: 'Fura 60mm em passos de 12mm a 200mm/min com refrigeração no OSP Okuma.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G205', nome: 'Ciclo de Mandrilamento OSP', categoria: 'Mandrilamento',
    maquina: 'Centro de Usinagem', fabricante: 'Okuma',
    descricao: 'Ciclo de mandrilamento com parada spindle e retração no OSP.',
    descricaoCompleta:
      'G205 executa mandrilamento fino no Okuma: avança até a profundidade, para o spindle '
      '(orientação precisa), recua levemente em XY (clearance) antes de retrair Z, '
      'evitando marcar a superfície interna. Exige função de parada de spindle orientado.',
    sintaxe: 'G205 X[x] Y[y] Z[prof] R[ref] Q[desvio_xy] F[av]',
    parametros: [
      Parametro('Z', 'Profundidade de mandrilamento'),
      Parametro('Q', 'Desvio de retração em XY para não marcar (ex: 0.1mm)'),
      Parametro('F', 'Avanço de mandrilamento (lento para qualidade)'),
    ],
    exemplo: 'S800 M3 M8\nG205 X50. Y50. Z-30. R3. Q0.1 F40',
    explicacaoExemplo: 'Mandrilamento fino a 800rpm, 40mm/min, retrai 0.1mm antes de subir — acabamento H7.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G253', nome: 'Ciclo de Torneamento Contorno — Okuma', categoria: 'Torneamento',
    maquina: 'Torno CNC', fabricante: 'Okuma',
    descricao: 'Ciclo de desbaste de contorno no torno Okuma OSP.',
    descricaoCompleta:
      'G253 executa desbaste de contorno em tornos Okuma. Similar ao G71 Fanuc mas com '
      'parâmetros no estilo OSP. Define o contorno final em um subprograma e o ciclo '
      'faz os passes de desbaste automaticamente com ap e offset lateral configuráveis.',
    sintaxe: 'G253 P[prog_contorno] D[ap] F[av] S[rpm]',
    parametros: [
      Parametro('P', 'Número do subprograma com o contorno final'),
      Parametro('D', 'Profundidade de corte por passe (ap)'),
      Parametro('F', 'Avanço de desbaste'),
    ],
    exemplo: 'G253 P100 D1.5 F0.25 S1200',
    explicacaoExemplo: 'Desbaste de contorno com 1.5mm de ap e 0.25mm/rot de avanço, lendo perfil do subprog. 100.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // MITSUBISHI — M700 / M800 / M80 Series
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G120', nome: 'Ciclo de Fresamento de Ranhura — Mitsubishi', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'Mitsubishi',
    descricao: 'Ciclo de fresamento de ranhura (slot) no M700/M800.',
    descricaoCompleta:
      'G120 é o ciclo de fresamento de ranhura do Mitsubishi CNC. Define comprimento, largura, '
      'profundidade e estratégia de remoção de material automaticamente. Elimina a necessidade de '
      'programar passe a passe. Disponível a partir do M700V.',
    sintaxe: 'G120 X[x] Y[y] Z[prof] I[comp] J[larg] Q[passo] F[av]',
    parametros: [
      Parametro('X, Y', 'Centro da ranhura'),
      Parametro('Z', 'Profundidade final'),
      Parametro('I', 'Comprimento da ranhura'),
      Parametro('J', 'Largura da ranhura'),
      Parametro('Q', 'Profundidade por passe (ap)'),
    ],
    exemplo: 'S2000 M3 M8\nG120 X50. Y30. Z-10. I60. J12. Q2. F200',
    explicacaoExemplo: 'Fresa ranhura 60×12mm com 2mm de passe até -10mm no centro X50 Y30.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G180', nome: 'Ciclo de Rosqueamento — Mitsubishi M700', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Mitsubishi', diagramaTipo: 'rosca',
    descricao: 'Ciclo de rosqueamento rígido sincronizado no Mitsubishi M700/M800.',
    descricaoCompleta:
      'G180 executa rosqueamento rígido no Mitsubishi CNC com sincronização total entre spindle '
      'e eixo Z. O M800 suporta aceleração/desaceleração otimizada S-curve para minimizar '
      'estresse nas machos. Requer função de spindle encoder instalada.',
    sintaxe: 'G180 X[x] Y[y] Z[prof] R[ref] F[passo_×_RPM]',
    parametros: [
      Parametro('Z', 'Profundidade da rosca'),
      Parametro('R', 'Plano de aproximação'),
      Parametro('F', 'F = RPM × passo da rosca'),
    ],
    exemplo: '; M8 × 1.25 a 600 RPM\nS600 M3\nG180 X50. Y50. Z-20. R3. F750\n; F = 600 × 1.25 = 750',
    explicacaoExemplo: 'Rosca M8×1.25 a 600rpm, F=750mm/min. Plano de retorno R3mm acima da peça.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G76', nome: 'Ciclo de Rosca Fina (Torno) — Mitsubishi', categoria: 'Rosqueamento',
    maquina: 'Torno CNC', fabricante: 'Mitsubishi', diagramaTipo: 'rosca',
    descricao: 'Ciclo de rosqueamento de torneamento multi-passe no M700.',
    descricaoCompleta:
      'G76 no Mitsubishi M700/M800 executa rosqueamento externo/interno em múltiplos passes '
      'com redução automática de profundidade. Parâmetros de ângulo de entrada (0° ou 29°/30°) '
      'para rosca métrica ou NPT. Compatível com Fanuc G76 mas com parâmetros adicionais.',
    sintaxe: 'G76 P[passes_ângulo_mínimo] Q[prof_mín] R[folga_acabamento]\nG76 X[diâm_menor] Z[prof] P[altura_rosca] Q[1ºpasse] F[passo]',
    parametros: [
      Parametro('P (1ª linha)', 'Número de passes acabamento + ângulo + profundidade mínima'),
      Parametro('X', 'Diâmetro menor da rosca'),
      Parametro('F', 'Passo da rosca em mm'),
    ],
    exemplo: '; Rosca M30 × 3.5\nG76 P021060 Q100 R100\nG76 X27.402 Z-45. P1299 Q400 F3.5',
    explicacaoExemplo: 'Rosca M30×3.5: 2 passes de acabamento, ângulo 60°, diâmetro menor 27.402mm, prof. total 1.299mm, 1° passe 0.4mm.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G37', nome: 'Medição Automática de Ferramenta — Mitsubishi', categoria: 'Medição',
    maquina: 'Centro de Usinagem', fabricante: 'Mitsubishi',
    descricao: 'Ciclo de medição automática do comprimento de ferramenta no M700/M800.',
    descricaoCompleta:
      'G37 aciona o ciclo de medição automática de comprimento de ferramenta no Mitsubishi. '
      'Move a ferramenta até o sensor TLS (Tool Length Sensor) e registra automaticamente o '
      'offset H no registro de ferramentas. Elimina erros de setup manual.',
    sintaxe: 'G37 H[num_offset] Z[pos_sensor]',
    parametros: [
      Parametro('H', 'Número do offset a ser atualizado'),
      Parametro('Z', 'Posição Z aproximada do sensor de comprimento'),
    ],
    exemplo: 'T5 M6\nG37 H5 Z-350.\n; Offset H5 atualizado automaticamente',
    explicacaoExemplo: 'Após troca da ferramenta T5, G37 move até sensor em Z-350 e atualiza H5 automaticamente.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // BROTHER — Speedio S700X1 / M300X3 / R450X1
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G341', nome: 'Ciclo de Rosqueamento — Brother Speedio', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', diagramaTipo: 'rosca',
    descricao: 'Rosqueamento rígido de alta velocidade no Brother Speedio.',
    descricaoCompleta:
      'G341 é o ciclo de rosqueamento rígido do Brother Speedio. Otimizado para alta velocidade, '
      'com spindle que pode atingir 16.000 RPM. O sincronismo spindle-Z é tão preciso que machos '
      'rígidos sem compensação axial são usados em produção. Muito usado em linhas de usinagem de alumínio.',
    sintaxe: 'G341 X[x] Y[y] Z[prof] R[ref] F[avanço]',
    parametros: [
      Parametro('Z', 'Profundidade da rosca'),
      Parametro('R', 'Plano de aproximação'),
      Parametro('F', 'Avanço = RPM × passo'),
    ],
    exemplo: '; Rosca M5 × 0.8 a 4000 RPM — Alumínio\nS4000 M3\nG341 X25. Y25. Z-15. R2. F3200\n; F = 4000 × 0.8 = 3200',
    explicacaoExemplo: 'Rosqueia M5×0.8 a 4000rpm em alumínio. F=3200mm/min. Máx. velocidade é diferencial do Speedio.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G343', nome: 'Ciclo de Furação Profunda — Brother', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação profunda com peck no controle Brother CNC-C00.',
    descricaoCompleta:
      'G343 executa furação profunda com pecking no Brother Speedio. Projetado para máquinas de '
      'alta velocidade, o ciclo otimiza a aceleração/desaceleração do eixo Z para minimizar tempo '
      'de ciclo. Aceita Q para peck mínimo e retração parcial para quebra de cavaco.',
    sintaxe: 'G343 X[x] Y[y] Z[prof] R[ref] Q[peck] F[av]',
    parametros: [
      Parametro('Z', 'Profundidade total'),
      Parametro('Q', 'Profundidade do peck'),
      Parametro('R', 'Plano de referência'),
      Parametro('F', 'Avanço de furação'),
    ],
    exemplo: 'S5000 M3 M8\nG343 X50. Y50. Z-30. R2. Q5. F600',
    explicacaoExemplo: 'Fura 30mm em passos de 5mm a 5000rpm/600mm/min no Speedio — alumínio em alta velocidade.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G241', nome: 'Ciclo de Furação Simples — Brother Speedio', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação direta de alta velocidade no Brother Speedio.',
    descricaoCompleta:
      'G241 é o ciclo de furação direta (sem peck) do Brother Speedio. Otimizado para ciclos '
      'curtos em alumínio — a máquina pode executar mais de 600 furos/minuto em determinadas '
      'condições. A aceleração do eixo Z é gerenciada pelo controle CNC-C00 para máximo throughput.',
    sintaxe: 'G241 X[x] Y[y] Z[prof] R[ref] F[av]',
    parametros: [
      Parametro('Z', 'Profundidade do furo'),
      Parametro('R', 'Plano de referência'),
      Parametro('F', 'Avanço de furação'),
    ],
    exemplo: 'S8000 M3 M8\nG241 Z-8. R2. F1200\nX10. Y10.\nX20. Y10.\nX30. Y10.',
    explicacaoExemplo: 'Fura posições múltiplas a 8000rpm/1200mm/min — ciclo puro sem peck para furos rasos em alumínio.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // DMG MORI — Heidenhain iTNC 530 / TNC 640
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'CYCL DEF 20', nome: 'Dados do Contorno — DMG TNC 640', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'DMG',
    descricao: 'Define dados globais para ciclos de fresamento de contorno no TNC 640.',
    descricaoCompleta:
      'CYCL DEF 20 define parâmetros globais usados pelos ciclos de contorno (CYCL 21, 22, 23, 24) '
      'no Heidenhain TNC 640 (controle padrão dos centros DMG MORI de 5 eixos). '
      'Parâmetros: profundidade total, sobremedida de acabamento, passo (ap), velocidade de retração. '
      'Deve ser programado antes de CYCL DEF 21/22.',
    sintaxe: 'CYCL DEF 20.0 DADOS DO CONTORNO\nCYCL DEF 20.1 PROF=-[z] ~\n    PASSO=[ap] ~\n    SOBREMEDIDA=[delta]',
    parametros: [
      Parametro('PROF', 'Profundidade total de fresamento (negativo)'),
      Parametro('PASSO', 'Profundidade por passe (ap)'),
      Parametro('SOBREMEDIDA', 'Sobremedida para acabamento posterior (geralmente 0.2-0.5mm)'),
    ],
    exemplo: 'CYCL DEF 20.0 DADOS DO CONTORNO\nCYCL DEF 20.1 PROF=-25 ~\n    PASSO=4 ~\n    SOBREMEDIDA=0.3\n\nCYCL DEF 22.0 DESBASTE\nCYCL DEF 22.1 PROF=-25 ~\n    PASSO=4',
    explicacaoExemplo: 'Define desbaste a -25mm em passos de 4mm com 0.3mm de sobremedida para acabamento final.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'CYCL DEF 22', nome: 'Desbaste de Cavidade — DMG TNC 640', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'DMG', diagramaTipo: 'linear',
    descricao: 'Ciclo de desbaste de cavidade (bolsão) no TNC 640 dos centros DMG MORI.',
    descricaoCompleta:
      'CYCL DEF 22 executa desbaste de bolsões e contornos no TNC 640. Usa a estratégia de '
      'trocoidal ou zig-zag automaticamente. Deve ser antecedido pelo CYCL DEF 20 (dados do contorno) '
      'e o contorno deve ser definido com LBL (label) no programa.',
    sintaxe: 'CYCL DEF 22.0 DESBASTE\nCYCL DEF 22.1 PROF=-[z] ~\n    PASSO=[ap] ~\n    FRESA-RAIO-ACABAM.=[delta]',
    parametros: [
      Parametro('PROF', 'Profundidade total'),
      Parametro('PASSO', 'Passo axial por nível'),
      Parametro('FRESA-RAIO-ACABAM.', 'Raio da fresa de acabamento (para calcular sobremedida lateral)'),
    ],
    exemplo: 'CYCL DEF 22.0 DESBASTE\nCYCL DEF 22.1 PROF=-20 ~\n    PASSO=5 ~\n    FRESA-RAIO-ACABAM.=6\n\nLBL 1 ; Contorno do bolsão\nL X-30 Y-20 RL\nL X+30 Y-20\nL X+30 Y+20\nL X-30 Y+20\nL X-30 Y-20\nLBL 0\n\nCYCL CALL',
    explicacaoExemplo: 'Desbaste bolsão 60×40mm a -20mm em passos de 5mm, com fresa de acabamento Ø12mm para calcular sobremedida lateral.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'CYCL DEF 251', nome: 'Fresamento de Bolsão Retangular — DMG', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'DMG', diagramaTipo: 'linear',
    descricao: 'Ciclo de bolsão retangular completo (desbaste + acabamento) no TNC 640.',
    descricaoCompleta:
      'CYCL DEF 251 é um ciclo completo de bolsão retangular no Heidenhain TNC 640. '
      'Faz desbaste e acabamento (lateral e fundo) em um único ciclo. Aceita cantos com raio, '
      'ângulo de rotação do bolsão e sobrepasse. Excelente para plaquinhas de fixação e cavidades retangulares.',
    sintaxe: 'CYCL DEF 251.0 BOLSÃO RETANGULAR\nCYCL DEF 251.1 COMP.=[l] ~\n    LARGURA=[w] ~\n    PROF.=[z] ~\n    RAIO=[r] ~\n    ANG.=[ang]',
    parametros: [
      Parametro('COMP.', 'Comprimento do bolsão (eixo X)'),
      Parametro('LARGURA', 'Largura do bolsão (eixo Y)'),
      Parametro('PROF.', 'Profundidade total (negativo)'),
      Parametro('RAIO', 'Raio de canto do bolsão'),
      Parametro('ANG.', 'Ângulo de rotação do bolsão (°)'),
    ],
    exemplo: 'CYCL DEF 251.0 BOLSÃO RETANGULAR\nCYCL DEF 251.1 COMP.=80 ~\n    LARGURA=50 ~\n    PROF.=-15 ~\n    RAIO=5 ~\n    ANG.=0\n\nL X+0 Y+0 FMAX\nCYCL CALL',
    explicacaoExemplo: 'Bolsão retangular 80×50mm, profundidade 15mm, cantos R5, ângulo 0° — ciclo completo desbaste+acabamento.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'CYCL DEF 253', nome: 'Fresamento de Ranhura — DMG TNC 640', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'DMG',
    descricao: 'Ciclo de fresamento de ranhura (slot) no TNC 640 dos centros DMG MORI.',
    descricaoCompleta:
      'CYCL DEF 253 fresa ranhuras retas no TNC 640. Define comprimento, largura e profundidade '
      'automaticamente. A estratégia de corte pode ser pendular (passo a passo) ou helicoidal. '
      'Acabamento lateral e de fundo incluídos no mesmo ciclo.',
    sintaxe: 'CYCL DEF 253.0 FRESAMENTO RANHURA\nCYCL DEF 253.1 COMP.=[l] ~\n    PROF.=[z] ~\n    PASSO=[ap] ~\n    ANG.=[ang]',
    parametros: [
      Parametro('COMP.', 'Comprimento da ranhura'),
      Parametro('PROF.', 'Profundidade'),
      Parametro('PASSO', 'Profundidade por passe'),
      Parametro('ANG.', 'Ângulo de orientação da ranhura'),
    ],
    exemplo: 'CYCL DEF 253.0 FRESAMENTO RANHURA\nCYCL DEF 253.1 COMP.=60 ~\n    PROF.=-10 ~\n    PASSO=3 ~\n    ANG.=0\n\nL X+50 Y+30 FMAX\nCYCL CALL',
    explicacaoExemplo: 'Fresa ranhura 60mm de comprimento, -10mm de profundidade em passos de 3mm, ângulo 0°.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'PLANE SPATIAL', nome: 'Inclinação de Plano 5 Eixos — DMG TNC 640', categoria: 'Multi-eixo',
    maquina: 'Centro de Usinagem', fabricante: 'DMG',
    descricao: 'Define plano de usinagem inclinado por ângulos espaciais no TNC 640 (5 eixos).',
    descricaoCompleta:
      'PLANE SPATIAL é a função principal de inclinação de plano do Heidenhain TNC 640, '
      'padrão nos centros DMG MORI de 5 eixos. Define o plano de trabalho por ângulos de rotação '
      'espacial (SPA, SPB, SPC) permitindo usinar superfícies inclinadas sem recalcular coordenadas. '
      'O TNC 640 calcula automaticamente as posições A/B/C dos eixos rotativos.',
    sintaxe: 'PLANE SPATIAL SPA+[a] SPB+[b] SPC+[c] TURN FMAX',
    parametros: [
      Parametro('SPA', 'Rotação espacial em torno do eixo X (°)'),
      Parametro('SPB', 'Rotação espacial em torno do eixo Y (°)'),
      Parametro('SPC', 'Rotação espacial em torno do eixo Z (°)'),
      Parametro('TURN', 'Move os eixos rotativos para a posição calculada'),
    ],
    exemplo: '; Usinar face inclinada 45° em Y\nPLANE SPATIAL SPA+0 SPB+45 SPC+0 TURN FMAX\n; Coordenadas agora no plano inclinado\nL X+0 Y+0 Z+5 FMAX\nL Z-5 F300',
    explicacaoExemplo: 'Inclina o plano de trabalho 45° em torno de Y. As coordenadas programadas após passam a ser relativas ao plano inclinado.',
    isG: false,
  ),

  // ══════════════════════════════════════════════
  // FANUC — CICLOS E FUNÇÕES ESPECIAIS
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G10', nome: 'Entrada de Dados por Programa (Fanuc)', categoria: 'Offsets',
    maquina: 'Ambos', fabricante: 'Fanuc', diagramaTipo: 'referencia',
    descricao: 'Define ou corrige offsets de ferramenta e work offsets diretamente dentro do programa NC.',
    descricaoCompleta:
      'G10 permite que o programa CNC escreva valores diretamente nas tabelas de offsets (compensação de ferramenta, work offsets G54-G59, parâmetros). '
      'Essencial em sistemas com apalpadores — o macro mede a peça e usa G10 para corrigir o offset automaticamente sem intervenção humana. '
      'L: seleciona a tabela (1=geom.tool, 10=wear, 20=work offset). '
      'P: número do offset (P1=H1, P54=G54...). '
      'R: valor a definir. '
      'Q: eixo (1=X, 2=Y, 3=Z).',
    sintaxe: 'G10 L[n] P[offset] X[val] Y[val] Z[val] R[val]',
    parametros: [
      Parametro('L1', 'Tabela de geometria de ferramenta (Length H)'),
      Parametro('L10', 'Tabela de desgaste de ferramenta'),
      Parametro('L2', 'Work offset — G54 a G59 (P1=G54, P2=G55 … P6=G59)'),
      Parametro('P', 'Número do offset na tabela selecionada'),
      Parametro('X/Y/Z/R', 'Valor absoluto a gravar no offset'),
    ],
    exemplo:
      '; Corrigir G54 Z-offset automaticamente\n'
      'G10 L2 P1 Z-152.450  ; Grava Z=-152.45 no G54\n\n'
      '; Corrigir desgaste da ferramenta T1\n'
      'G10 L10 P1 R0.05      ; Adiciona 0.05mm ao wear H1',
    explicacaoExemplo:
      'Primeiro comando atualiza G54 Z sem ir para a página de offsets. Segundo ajusta desgaste de T1 em 0.05mm. Muito usado em sistemas com medição automática (skip G31).',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G31', nome: 'Função Skip (Apalpador / Probe)', categoria: 'Apalpador',
    maquina: 'Ambos', fabricante: 'Fanuc', diagramaTipo: 'referencia',
    descricao: 'Move o eixo até que o sinal de skip (apalpador) seja recebido, armazenando a posição em variáveis de macro.',
    descricaoCompleta:
      'G31 é o código de movimento com skip usado com apalpadores de toque. O eixo move na direção programada com o avanço especificado. '
      'Quando o apalpador encosta na peça e gera o sinal de skip, o movimento para e a posição é salva em variáveis de macro (#5061=X, #5062=Y, #5063=Z). '
      'Essa posição pode ser usada para calcular o offset ou compensação automaticamente. '
      'Essencial em sistemas de medição na máquina (Renishaw, Marposs, Blum).',
    sintaxe: 'G31 X[destino] Y[destino] Z[destino] F[avanço]',
    parametros: [
      Parametro('X/Y/Z', 'Posição de destino (o movimento para antes se houver skip)'),
      Parametro('F', 'Avanço de apalpação (tipicamente 50-200 mm/min)'),
      Parametro('#5061', 'Macro: posição X no momento do skip'),
      Parametro('#5062', 'Macro: posição Y no momento do skip'),
      Parametro('#5063', 'Macro: posição Z no momento do skip'),
    ],
    exemplo:
      'G91 G31 Z-50. F100    ; Move Z até skip (máx 50mm)\n'
      '#100 = #5063          ; Salva posição Z do toque\n'
      'G10 L2 P1 Z[#100]     ; Atualiza G54 Z com valor medido',
    explicacaoExemplo:
      'O apalpador toca a superfície da peça em Z. A posição é capturada em #5063 e imediatamente gravada em G54 Z com G10. Elimina erro humano no setup.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G65', nome: 'Chamada de Macro (Fanuc Custom Macro B)', categoria: 'Macro',
    maquina: 'Ambos', fabricante: 'Fanuc', diagramaTipo: 'referencia',
    descricao: 'Chama uma subrotina de macro com passagem de argumentos — permite loops, cálculos e programação paramétrica.',
    descricaoCompleta:
      'G65 chama um programa O (subprograma de macro) passando argumentos pelas letras A-Z. '
      'As variáveis de macro (#1-#26) recebem os valores dos argumentos dentro da subrotina. '
      'Diferente de M98 (subprograma simples), o G65 permite passar parâmetros. '
      'Usado para ciclos customizados, furação em padrão, apalpação, cálculos trigonométricos, etc. '
      'Variáveis locais #1-#33, comuns #100-#149, globais #500-#599, do sistema #5001+.',
    sintaxe: 'G65 P[Oprog] A[val] B[val] C[val] ... Z[val]',
    parametros: [
      Parametro('P', 'Número do programa de macro a chamar (ex: P9010)'),
      Parametro('A→Z', 'Argumentos — A=#1, B=#2, C=#3, I=#4, J=#5, K=#6, D=#7, E=#8, F=#9...'),
      Parametro('#1-#26', 'Variáveis locais que recebem os argumentos'),
      Parametro('#100-#149', 'Variáveis comuns — persistem entre chamadas'),
    ],
    exemplo:
      '; Chamar macro O9010 para furar PCD\n'
      'G65 P9010 A50. B6 C0.  ; Diâm=50, N furos=6, Ang inicial=0\n\n'
      '; Dentro do O9010:\n'
      '; #1=diâmetro PCD, #2=N furos, #3=ângulo inicial\n'
      '; #10 = 360 / #2  ; passo angular\n'
      '; WHILE [#4 LE #2] DO1 ...',
    explicacaoExemplo:
      'Chama macro O9010 passando diâmetro 50mm, 6 furos e ângulo 0°. A macro calcula posições e fura automaticamente.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G68', nome: 'Rotação de Coordenadas (Fanuc)', categoria: 'Transformação',
    maquina: 'Centro de Usinagem', fabricante: 'Fanuc', diagramaTipo: 'espelhamento',
    descricao: 'Rotaciona o sistema de coordenadas pelo ângulo especificado — usina contornos rotacionados sem reprogramar.',
    descricaoCompleta:
      'G68 ativa a rotação do sistema de coordenadas. Todos os movimentos programados após G68 são executados com o sistema rotacionado. '
      'O centro de rotação é definido por X e Y. O ângulo R define a rotação (positivo = anti-horário). '
      'Cancelado por G69. Permite usar o mesmo contorno em diferentes ângulos sem duplicar código. '
      'Combinado com G51 (escala) cria peças simétricas com variações de tamanho.',
    sintaxe: 'G68 X[cx] Y[cy] R[ângulo]  ...código...  G69',
    parametros: [
      Parametro('X', 'Coordenada X do centro de rotação'),
      Parametro('Y', 'Coordenada Y do centro de rotação'),
      Parametro('R', 'Ângulo de rotação em graus (+ = anti-horário, - = horário)'),
      Parametro('G69', 'Cancela a rotação de coordenadas'),
    ],
    exemplo:
      'G68 X0 Y0 R45.   ; Rotaciona 45° em torno da origem\n'
      'G0 X30. Y0\n'
      'G1 Z-5. F200\n'
      'G1 X50. Y20.\n'
      'G69               ; Cancela rotação',
    explicacaoExemplo:
      'Rotaciona o sistema 45°. O perfil programado em X/Y é executado com esse giro. Ideal para peças com ranhuras anguladas ou simetria rotacional.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // SIEMENS — FUNÇÕES ADICIONAIS
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'CYCLE840', nome: 'Rosqueamento com Compensação — Siemens', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Siemens', diagramaTipo: 'rosca',
    descricao: 'Ciclo de rosqueamento com macho com mandril de compensação — sincronizado ou flutuante.',
    descricaoCompleta:
      'CYCLE840 é o ciclo de rosqueamento por macho do Siemens 828D/840D. Suporta dois modos: '
      'VARI=0 = mandril flutuante (compensador), onde o spindle e o avanço não precisam ser perfeitamente sincronizados. '
      'VARI=1 = rosqueamento rígido — spindle e eixo Z sincronizados (M29 no Fanuc). '
      'SDR define a direção: 0=horário (M03), 1=anti-horário (M04). '
      'SDAC mantém o spindle após o ciclo. '
      'MPIT define o passo pela denominação M (M6=passo 1mm, M8=1.25mm, etc.) OU PIT define passo direto.',
    sintaxe: 'CYCLE840(RTP, RFP, SDIS, DP, DPR, DTB, SDR, SDAC, ENC, MPIT, PIT)',
    parametros: [
      Parametro('RTP', 'Plano de retorno'),
      Parametro('RFP', 'Plano de referência (superfície)'),
      Parametro('SDIS', 'Distância de segurança'),
      Parametro('DP / DPR', 'Profundidade final / relativa'),
      Parametro('SDR', 'Sentido: 0=M03 (direita), 1=M04 (esquerda)'),
      Parametro('SDAC', 'Estado do spindle ao fim: 3=M03, 4=M04, 5=M05'),
      Parametro('ENC', '0=mandril flutuante, 1=rosqueamento rígido'),
      Parametro('MPIT/PIT', 'Tamanho M (MPIT) ou passo em mm (PIT)'),
    ],
    exemplo:
      'T2 D1\nS600 M3\nG0 X0. Y0.\nCYCLE840(50.,0.,3.,-20.,,0.5,0,3,1,,1.5)\nM30',
    explicacaoExemplo:
      'Rosqueia M??×1.5 em modo rígido (ENC=1), direção horária, profundidade 20mm, pausa 0.5s no fundo. Spindle continua M03 após o ciclo.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'TRANS / ATRANS', nome: 'Translação de Coordenadas — Siemens', categoria: 'Transformação',
    maquina: 'Ambos', fabricante: 'Siemens', diagramaTipo: 'referencia',
    descricao: 'Desloca a origem do sistema de coordenadas — TRANS absoluto, ATRANS adicional (acumula).',
    descricaoCompleta:
      'TRANS desloca absolutamente a origem de trabalho. ATRANS adiciona um deslocamento sobre o atual. '
      'Equivale ao G52 do Fanuc (local coordinate system). '
      'Permite programar um contorno na origem e depois deslocá-lo para múltiplas posições sem reprogramar. '
      'TRANS com todos zeros cancela o deslocamento ativo (como G52 X0 Y0 Z0 no Fanuc). '
      'Pode ser combinado com ROT (rotação) e SCALE (escala) na mesma linha.',
    sintaxe: 'TRANS X[dx] Y[dy] Z[dz]\nATRANS X[dx] Y[dy] Z[dz]',
    parametros: [
      Parametro('TRANS X/Y/Z', 'Define deslocamento absoluto da origem'),
      Parametro('ATRANS X/Y/Z', 'Adiciona deslocamento ao atual (acumulativo)'),
      Parametro('TRANS', 'Sem parâmetros — cancela todos os frames ativos'),
    ],
    exemplo:
      'TRANS X50. Y30.       ; Origem em X50 Y30\n'
      '; Programar furo na "nova origem"\n'
      'G0 X0 Y0\nCYCLE82(10.,0.,3.,-15.,,0.)\n'
      'ATRANS X30.           ; Desloca +30mm em X\n'
      'CYCLE82(10.,0.,3.,-15.,,0.)\n'
      'TRANS                 ; Cancela translação',
    explicacaoExemplo:
      'Furos idênticos em duas posições deslocadas 30mm em X. O código do ciclo é escrito uma única vez.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'CYCLE95', nome: 'Ciclo de Desbaste de Contorno — Siemens Torno', categoria: 'Torneamento',
    maquina: 'Torno CNC', fabricante: 'Siemens', diagramaTipo: 'linear',
    descricao: 'Ciclo de desbaste de contorno para torno CNC Siemens — equivale ao G71 do Fanuc.',
    descricaoCompleta:
      'CYCLE95 faz o desbaste de um perfil definido por um subprograma ou contorno embutido. '
      'Equivale ao G71/G72 do Fanuc. '
      'NPP = nome do subprograma que define o contorno final. '
      'MID = profundidade de corte por passada (ap). '
      'FALZ = sobremedida axial para acabamento. '
      'FALX = sobremedida radial para acabamento. '
      'FAL = sobremedida geral se FALZ/FALX não usados. '
      'FF1 = avanço de desbaste, FF2 = avanço de chanfro/raio, FF3 = avanço de acabamento. '
      'VARI = modo de usinagem (1=ext.long., 2=ext.front., 3=int.long., 4=int.front., +8=acabamento).',
    sintaxe: 'CYCLE95(NPP, MID, FALZ, FALX, FAL, FF1, FF2, FF3, VARI, DT, DAM, VRT)',
    parametros: [
      Parametro('NPP', 'Nome do subprograma/label do contorno (string entre aspas)'),
      Parametro('MID', 'Profundidade de corte por passe (ap)'),
      Parametro('FALZ', 'Sobremedida axial para acabamento'),
      Parametro('FALX', 'Sobremedida radial para acabamento'),
      Parametro('FF1', 'Avanço de desbaste (mm/rot)'),
      Parametro('VARI', '1=ext.longitudinal, 2=ext.frontal, +8=só acabamento'),
    ],
    exemplo:
      'T1 D1\nG96 S200 LIMS=2500 M4\nG0 X82. Z5.\n'
      'CYCLE95("PERFIL",2.,0.2,0.15,,0.3,,0.1,1)\n\n'
      'PERFIL:\nG1 X20. Z0\nG1 X20. Z-30.\nG1 X40. Z-45.\nG1 X40. Z-70.\nG1 X80. Z-80.\nRET',
    explicacaoExemplo:
      'Desbaste externo longitudinal com ap=2mm, sobremedida Z=0.2, X=0.15mm. O contorno "PERFIL" define o perfil final com chanfro e escalonamento.',
    isG: false,
  ),

  // ══════════════════════════════════════════════
  // HAAS — FUNÇÕES E MACROS
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G47', nome: 'Gravação de Texto — Haas', categoria: 'Especial',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'linear',
    descricao: 'Grava texto alfanumérico diretamente na peça usando uma ferramenta de gravação.',
    descricaoCompleta:
      'G47 é exclusivo das máquinas Haas e permite gravar texto, números e caracteres especiais diretamente na peça. '
      'A ferramenta (tipicamente uma ponta de gravação cônica ou fresa de letra) percorre as letras automaticamente. '
      'A altura do texto é controlada pelo endereço H. '
      'O texto é colocado entre aspas após o endereço E. '
      'Útil para gravar número de série, código da peça ou data de fabricação diretamente no ciclo CNC.',
    sintaxe: 'G47 P[modo] E"[TEXTO]" X[x] Y[y] Z[z] F[av] H[altura]',
    parametros: [
      Parametro('P1', 'Modo de gravação padrão'),
      Parametro('E"TEXTO"', 'Texto a gravar (alfanumérico entre aspas)'),
      Parametro('X/Y', 'Posição inicial do texto'),
      Parametro('Z', 'Profundidade de gravação (negativo)'),
      Parametro('F', 'Avanço de gravação'),
      Parametro('H', 'Altura das letras em mm'),
    ],
    exemplo:
      'T5 M6 ; Fresa de gravação Ø3\nS3000 M3\nG0 G90 G54 X0 Y0\nG43 H5 Z20.\n'
      'G47 P1 E"SN-2024-001" X10. Y15. Z-0.3 F500 H5.',
    explicacaoExemplo:
      'Grava o número de série "SN-2024-001" a partir de X10 Y15, profundidade 0.3mm, letras de 5mm de altura. Ótimo para rastreabilidade de peças.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G188', nome: 'Tool Life Management — Haas', categoria: 'Gerenciamento',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'referencia',
    descricao: 'Habilita o gerenciamento de vida de ferramenta por número de peças ou minutos de corte no controle Haas.',
    descricaoCompleta:
      'G188 ativa o gerenciamento de vida de ferramenta do Haas. Trabalha com a tabela de ferramentas do controle '
      '(Tool Life Management). Cada ferramenta tem um contador de uso. Quando atinge o limite, '
      'o Haas troca automaticamente por uma ferramenta irmã (sister tool) ou emite alerta. '
      'O limite pode ser em número de usos (peças) ou tempo de corte. '
      'Requer configuração prévia na página de ferramentas do controle Haas.',
    sintaxe: 'T[n] M6\nG188          ; Ativa verificação de vida\n...\nG189          ; Cancela verificação',
    parametros: [
      Parametro('G188', 'Ativa o controle de vida de ferramenta'),
      Parametro('G189', 'Cancela o controle de vida de ferramenta'),
      Parametro('Tool Life', 'Configurado na página de ferramentas do controle Haas'),
    ],
    exemplo:
      'T1 M6        ; Chama ferramenta T1\nG188         ; Verifica vida — troca para irmã se necessário\nG0 G90 G54 X0 Y0\nG43 H1 Z20.\n...\nG189         ; Fim da verificação de vida',
    explicacaoExemplo:
      'Após T1 M6, G188 verifica se T1 ainda está dentro da vida. Se já esgotada, o Haas usa a ferramenta irmã configurada automaticamente.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G116', nome: 'Fresamento de Rosca Helicoidal — Haas', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'rosca',
    descricao: 'Fresa uma rosca helicoidal em material sólido usando interpolação helicoidal — alternativa ao macho.',
    descricaoCompleta:
      'G116 realiza fresamento de rosca: a fresa de rosca (thread mill) interpola helicoidalmente dentro do furo '
      'para criar a rosca. Permite roscar materiais difíceis (inox, titânio) onde macho quebraria. '
      'Um único passe cria a rosca completa (fresa multilinha) ou múltiplos passes (fresa de 1 linha). '
      'O passo da rosca = pitch = deslocamento Z por volta. '
      'Vantagens: fura e rosqueia em sequência; se fresa quebrar, não trava; '
      'uma fresa cobre múltiplos tamanhos de rosca (diferente do macho).',
    sintaxe: 'G116 X[x] Y[y] Z[z] I[raio] P[passo] F[avanço]',
    parametros: [
      Parametro('X/Y', 'Centro do furo a rosquear'),
      Parametro('Z', 'Profundidade final da rosca'),
      Parametro('I', 'Raio de aproximação helicoidal'),
      Parametro('P', 'Passo da rosca (pitch) em mm ou polegadas'),
      Parametro('F', 'Avanço de fresamento de rosca'),
    ],
    exemplo:
      '; Fresar rosca M16×2 em furo Ø14 pré-furado\n'
      'T3 M6    ; Thread mill Ø12\n'
      'S1200 M3\nG0 G54 X50. Y50.\nG43 H3 Z5.\n'
      'G116 X50. Y50. Z-22. I2.0 P2.0 F400',
    explicacaoExemplo:
      'Fresa rosca M16×2 (passo 2mm) a 22mm de profundidade no centro X50 Y50. Raio de entrada helicoidal 2mm. Usado para roscas em inox e titânio.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // MAZAK — FUNÇÕES ADICIONAIS
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G161', nome: 'Usinagem de Alta Velocidade (HSM) — Mazak', categoria: 'Alta Velocidade',
    maquina: 'Centro de Usinagem', fabricante: 'Mazak',
    descricao: 'Ativa modo de alta velocidade com suavização de trajetória e look-ahead — Mazak SmoothG.',
    descricaoCompleta:
      'G161 ativa o modo de alta velocidade (HSM) do Mazak SmoothG. '
      'O controle usa look-ahead de até 200 blocos para antecipar mudanças de direção e calcular a trajetória mais suave. '
      'A desaceleração em cantos é automática. '
      'G162 ativa o modo de alta precisão (contrário — prioriza precisão, não velocidade). '
      'G160 cancela G161/G162 voltando ao modo padrão. '
      'Em moldes e peças de forma complexa, G161 pode reduzir o tempo de usinagem em 40-60%.',
    sintaxe: 'G161  ; Modo alta velocidade\nG162  ; Modo alta precisão\nG160  ; Cancela',
    parametros: [
      Parametro('G161', 'Ativa suavização de trajetória para alta velocidade'),
      Parametro('G162', 'Ativa controle de precisão (menor erro de contorno)'),
      Parametro('G160', 'Cancela G161/G162 — modo padrão'),
    ],
    exemplo:
      'G161           ; Ativar HSM\n'
      'S12000 M3\n'
      'G0 G54 X0 Y0\n'
      'G43 H1 Z5.\n'
      '; ... Código de usinagem de superfície ...\n'
      'G160           ; Desativar HSM',
    explicacaoExemplo:
      'Ativa HSM antes de usinagem de superfície de forma livre. O Mazak antecipa curvas e mantém o avanço programado mesmo em geometrias complexas.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // HEIDENHAIN — FUNÇÕES ADICIONAIS
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'CYCL DEF 220', nome: 'Padrão Circular de Furos — Heidenhain', categoria: 'Padrão',
    maquina: 'Centro de Usinagem', fabricante: 'Heidenhain', diagramaTipo: 'furar',
    descricao: 'Define e executa um padrão circular de furos (PCD — Pitch Circle Diameter) no TNC.',
    descricaoCompleta:
      'CYCL DEF 220 define um PCD (Pitch Circle Diameter) — conjunto de furos igualmente espaçados em círculo. '
      'Após definir o ciclo de furação (CYCL DEF 200 ou CYCL DEF 83 por exemplo), '
      'o CYCL DEF 220 executa-o em todos os pontos do padrão circular. '
      'Parâmetros: centro do círculo, raio, ângulo inicial, número de furos. '
      'Extremamente eficiente para flange, tampas, bases com furos de fixação em círculo.',
    sintaxe:
      'CYCL DEF 220.0 PADRÃO CIRCULAR\n'
      'CYCL DEF 220.1 CENTRO X=[cx] ~\n'
      '    CENTRO Y=[cy] ~\n'
      '    RAIO=[r] ~\n'
      '    ANG.=[ang0] ~\n'
      '    QUANTIDADE=[n]',
    parametros: [
      Parametro('CENTRO X/Y', 'Centro do círculo do padrão'),
      Parametro('RAIO', 'Raio do PCD (não diâmetro)'),
      Parametro('ANG.', 'Ângulo do primeiro furo (°)'),
      Parametro('QUANTIDADE', 'Número de furos igualmente espaçados'),
    ],
    exemplo:
      '; Primeiro definir ciclo de furação\n'
      'CYCL DEF 200.0 FURAÇÃO\n'
      'CYCL DEF 200.1 PROF.=-20 ~\n'
      '    AVANÇO=250 ~\n'
      '    SEG.=3\n\n'
      '; Depois definir e executar o PCD\n'
      'CYCL DEF 220.0 PADRÃO CIRCULAR\n'
      'CYCL DEF 220.1 CENTRO X+50 ~\n'
      '    CENTRO Y+50 ~\n'
      '    RAIO=40 ~\n'
      '    ANG.=0 ~\n'
      '    QUANTIDADE=8\n'
      'CYCL CALL',
    explicacaoExemplo:
      '8 furos de 20mm de profundidade em PCD Ø80mm (raio 40mm) centrado em X50 Y50, iniciando em 0°. Espaçamento automático de 45°.',
    isG: false,
  ),

  CodigoItem(
    codigo: 'FN 0 / FN 1', nome: 'Atribuição e Cálculo de Variáveis — Heidenhain', categoria: 'Macro',
    maquina: 'Ambos', fabricante: 'Heidenhain', diagramaTipo: 'referencia',
    descricao: 'Programação paramétrica Heidenhain — atribuição de valores a variáveis Q e cálculos aritméticos.',
    descricaoCompleta:
      'No Heidenhain TNC, as variáveis Q (Q0–Q1999) são o equivalente das variáveis macro do Fanuc. '
      'FN 0 atribui um valor constante a uma variável. '
      'FN 1 soma dois valores. FN 2 subtrai. FN 3 multiplica. FN 4 divide. '
      'FN 5 = seno. FN 6 = co-seno. FN 7 = raiz. FN 18 = função IF. '
      'As variáveis Q são usadas como parâmetros em qualquer bloco: L X+Q1 Y+Q2. '
      'Q100-Q199 = variáveis de resultado. Q200+ = para programação livre.',
    sintaxe: 'FN 0: Q[n] = [valor]\nFN 1: Q[n] = Q[a] + Q[b]\nFN 5: Q[n] = SIN Q[ang]',
    parametros: [
      Parametro('FN 0', 'Atribuição: Q1 = 50 → Q1 recebe valor 50'),
      Parametro('FN 1 / FN 2', 'Soma / Subtração de variáveis'),
      Parametro('FN 3 / FN 4', 'Multiplicação / Divisão'),
      Parametro('FN 5 / FN 6', 'Seno / Co-seno (ângulo em graus)'),
      Parametro('FN 18', 'Desvio condicional IF — FN 18: IF Q1 > 0 GOTO LBL 10'),
    ],
    exemplo:
      'FN 0: Q1 = 50.     ; Diâmetro PCD\n'
      'FN 0: Q2 = 8.      ; Número de furos\n'
      'FN 4: Q3 = 360 / Q2  ; Passo angular\n'
      'FN 0: Q4 = 0.      ; Ângulo atual\n'
      'LBL 1\n'
      'FN 5: Q10 = SIN Q4  ; X = R×sen(ang)\n'
      'FN 6: Q11 = COS Q4  ; Y = R×cos(ang)\n'
      'L X+Q10 Y+Q11 FMAX\n'
      'FN 18: IF Q4 < 360 GOTO LBL 1',
    explicacaoExemplo:
      'Calcula e percorre posições de 8 furos em PCD Ø50mm usando funções trigonométricas Heidenhain. Sem precisar calcular manualmente cada coordenada.',
    isG: false,
  ),

  // ══════════════════════════════════════════════
  // OKUMA — FUNÇÕES ADICIONAIS
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G7.1', nome: 'Interpolação Cilíndrica — Okuma', categoria: 'Multi-eixo',
    maquina: 'Torno CNC', fabricante: 'Okuma', diagramaTipo: 'linear',
    descricao: 'Interpola movimento rotacional (C) com linear (Z) para usinar ranhuras/cames em torno CNC.',
    descricaoCompleta:
      'G7.1 ativa a interpolação cilíndrica no OSP da Okuma. Permite programar contornos na superfície '
      'cilíndrica da peça como se fosse um plano planificado. '
      'O eixo C (rotacional) é tratado como deslocamento linear equivalente ao arco no raio especificado. '
      'G7.1 C[raio]: ativa com raio de conversão. '
      'G7.1 C0: cancela. '
      'Usado para ranhuras helicoidais, came de tambor, roscas especiais em torno.',
    sintaxe: 'G7.1 C[raio]   ; Ativa\n...\nG7.1 C0        ; Cancela',
    parametros: [
      Parametro('C[raio]', 'Raio da superfície cilíndrica (mm) — define conversão angular/linear'),
      Parametro('G7.1 C0', 'Cancela o modo de interpolação cilíndrica'),
    ],
    exemplo:
      '; Ranhura helicoidal em cilindro Ø50 (raio 25)\n'
      'G7.1 C25.    ; Ativa interp. cilíndrica raio 25mm\n'
      'G1 C0. Z0. F100\n'
      'G1 C90. Z-20.  ; 90° = ≈39.3mm arco, Z desce 20mm\n'
      'G1 C180. Z-40.\n'
      'G1 C360. Z-80.\n'
      'G7.1 C0      ; Cancela',
    explicacaoExemplo:
      'Fresa ranhura helicoidal de 360° ao longo de 80mm de comprimento em cilindro Ø50mm. Perfeito para cames de tambor e porcas de rosca trapezoidal especial.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G140', nome: 'Seleção de Cabeçote — Okuma Torno Bimandrino', categoria: 'Torno',
    maquina: 'Torno CNC', fabricante: 'Okuma',
    descricao: 'Seleciona qual spindle (principal ou sub-spindle) será ativo em tornos Okuma bimandrino (LB, Multus).',
    descricaoCompleta:
      'Em tornos Okuma de dois cabeçotes (LB-3000 EX II, Multus B), G140 e G141 selecionam qual cabeçote está ativo. '
      'G140 = cabeçote principal (S1). G141 = cabeçote secundário (S2). '
      'Cada cabeçote tem seus próprios offsets de ferramentas e work zeros. '
      'A transferência de peça entre cabeçotes usa G141 + G99 (avanço por rev) + M14 (fixar sub-spindle) + G74 (recuar ao zero). '
      'Fundamental para usinagem completa (OpA + OpB) sem reposicionamento manual.',
    sintaxe: 'G140  ; Seleciona spindle principal\nG141  ; Seleciona sub-spindle\nM14   ; Fixa sub-spindle para transferência',
    parametros: [
      Parametro('G140', 'Ativa controle do cabeçote principal (S1/C1)'),
      Parametro('G141', 'Ativa controle do sub-spindle (S2/C2)'),
      Parametro('M14', 'Clampeia o sub-spindle — necessário para transferência de peça'),
      Parametro('M15', 'Desclampeia o sub-spindle'),
    ],
    exemplo:
      '; Operação no cabeçote principal\n'
      'G140\nT101 ; Ferra T1 cabeçote 1\nS1500 M3\n'
      'G1 Z-50. F0.2\n\n'
      '; Transferir peça para sub-spindle\n'
      'G141  ; Selecionar sub-spindle\nM14   ; Fixar sub-spindle\n'
      'G0 Z2.  ; Aproximar sub-spindle\n'
      'M15   ; Liberar placa principal\n'
      '; Usinar face B no sub-spindle\n'
      'T201 S1200 M13',
    explicacaoExemplo:
      'Sequência de torneamento no cabeçote principal, transferência para sub-spindle e usinagem da face traseira — tudo em um ciclo automático.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // MITSUBISHI — FUNÇÕES ADICIONAIS
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G05 P10000', nome: 'Modo de Alta Precisão — Mitsubishi M800', categoria: 'Alta Velocidade',
    maquina: 'Centro de Usinagem', fabricante: 'Mitsubishi',
    descricao: 'Ativa modo de alta velocidade e alta precisão (HSPB) no controle Mitsubishi M700/M800.',
    descricaoCompleta:
      'G05 P10000 ativa o modo HSPB (High Speed Processing B) do Mitsubishi M700/M800. '
      'O controle aumenta o número de blocos em look-ahead (pré-leitura) para suavizar trajetórias. '
      'A aceleração/desaceleração em cantos é automática. '
      'G05 P10001 = modo de alta precisão (tolerância de contorno mais apertada). '
      'G05 P0 = cancela. '
      'Comparável ao G05.1 Q1 do Fanuc. '
      'Em moldes e superfícies livres, aumenta velocidade de usinagem mantendo acabamento.',
    sintaxe: 'G05 P10000   ; Alta velocidade\nG05 P10001   ; Alta precisão\nG05 P0       ; Cancela',
    parametros: [
      Parametro('P10000', 'Ativa modo de alta velocidade (HSPB)'),
      Parametro('P10001', 'Ativa modo de alta precisão com tolerância mais fina'),
      Parametro('P0', 'Cancela G05 — retorna ao modo de interpolação padrão'),
    ],
    exemplo:
      'G05 P10000      ; Ativar HSPB\n'
      'S15000 M3\n'
      'G0 G90 G54 X0 Y0\n'
      'G43 H1 Z5. M8\n'
      '; Usinagem de molde com muitos pontos\n'
      '...\n'
      'G05 P0          ; Desativar HSPB\n'
      'M5 M9',
    explicacaoExemplo:
      'HSPB ativado antes de usinagem de forma livre. O controle Mitsubishi lê até 200 blocos à frente, suavizando curvas e mantendo o avanço programado constante.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // BROTHER — FUNÇÕES ADICIONAIS
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G00.1', nome: 'Posicionamento Rápido com Suavização — Brother', categoria: 'Movimento',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', diagramaTipo: 'linear',
    descricao: 'Move em rápido com trajetória suavizada (não angular) — reduz vibração e tempo em Brother Speedio.',
    descricaoCompleta:
      'G00.1 é exclusivo das máquinas Brother Speedio e realiza posicionamento rápido com trajetória curvilínea suavizada '
      'em vez da trajetória em L (angular) do G00 convencional. '
      'Em peças com muitos furos próximos, elimina as acelerações bruscas do G00 convencional. '
      'Reduz vibração estrutural e melhora a vida dos fusos. '
      'O tempo de ciclo pode ser menor que G00 padrão porque evita picos de aceleração. '
      'Recomendado em fresamento de alta velocidade com trocas de ferramenta frequentes.',
    sintaxe: 'G00.1 X[x] Y[y] Z[z]',
    parametros: [
      Parametro('X/Y/Z', 'Posição de destino — trajetória suavizada automática'),
    ],
    exemplo:
      '; Furação rápida com múltiplos furos\n'
      'G00.1 X10. Y10.   ; Rapid suavizado\n'
      'G83 Z-20. R3. Q3. F400\n'
      'G00.1 X30. Y10.\n'
      'G83 Z-20. R3. Q3. F400\n'
      'G00.1 X50. Y10.\n'
      'G83 Z-20. R3. Q3. F400',
    explicacaoExemplo:
      'Três furos com G83 e deslocamentos por G00.1 suavizado. O Brother Speedio evita paradas bruscas entre furos mantendo dinamismo do ciclo.',
    isG: true,
  ),

  // ══════════════ CÓDIGOS G UNIVERSAIS ESSENCIAIS ══════════════

  CodigoItem(
    codigo: 'G04', nome: 'Temporização — Dwell', categoria: 'Movimento',
    maquina: 'Fresadora / Torno', fabricante: 'Universal',
    descricao: 'Pausa o movimento por tempo definido mantendo o spindle girando. Usado para garantir piso limpo em furos e melhorar acabamento no escareamento.',
    descricaoCompleta:
      'G04 para o avanço por um tempo especificado enquanto o spindle continua girando. '
      'Muito útil no fundo de furos cegos — garante que o piso seja completamente usinado. '
      'Em escareamento (G82), a pausa no fundo melhora o acabamento do ângulo de 90°. '
      'Fanuc: G04 X1.5 (segundos) ou G04 P1500 (milissegundos) — ambos pausam 1.5 seg. '
      'Em tornos com G75 (ranhura), G04 garante fundo de ranhura completamente cortado.',
    sintaxe: 'G04 X[seg]\nG04 P[ms]',
    parametros: [
      Parametro('X', 'Tempo em segundos — ex: X1.5 pausa 1,5 segundos'),
      Parametro('P', 'Tempo em milissegundos — ex: P1500 pausa 1500ms = 1,5 segundos'),
    ],
    exemplo:
      'G01 Z-20. F100.   ; Desce ao fundo\n'
      'G04 X1.5          ; Pausa 1.5 seg no fundo\n'
      'G00 Z5.           ; Retrai',
    explicacaoExemplo:
      'Pausa de 1.5 segundos no fundo do furo cego. O spindle continua a 100% da rotação — limpa o fundo e melhora o acabamento do rebaixo.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G17 / G18 / G19', nome: 'Seleção de Plano de Trabalho', categoria: 'Configuração',
    maquina: 'Fresadora / Torno', fabricante: 'Universal',
    descricao: 'Define o plano para arcos G02/G03 e compensação G41/G42. G17=XY (fresadora), G18=XZ (torno), G19=YZ.',
    descricaoCompleta:
      'O plano de trabalho define em qual plano os arcos G02/G03 e G41/G42 são calculados. '
      'G17 (XY): padrão em fresadoras. Arcos no plano horizontal — vista de cima. '
      'G18 (XZ): padrão em tornos. Arcos no plano do perfil longitudinal. '
      'G19 (YZ): usinagem lateral em 5 eixos ou fixações especiais. '
      'Erro clássico: usar G02/G03 sem declarar o plano — o controle usa o plano modal anterior, podendo causar arco no plano errado.',
    sintaxe: 'G17  ; plano XY\nG18  ; plano XZ\nG19  ; plano YZ',
    parametros: [
      Parametro('G17', 'Plano XY — padrão fresadoras, arcos em vista superior'),
      Parametro('G18', 'Plano XZ — padrão tornos, arcos no perfil longitudinal'),
      Parametro('G19', 'Plano YZ — 5 eixos ou fixações especiais'),
    ],
    exemplo:
      '; Fresadora\n'
      'G17\n'
      'G02 X50. Y30. R20. F200.   ; Arco no plano XY\n'
      '\n'
      '; Torno\n'
      'G18\n'
      'G03 X30. Z-15. R10. F0.2   ; Arco no plano XZ',
    explicacaoExemplo:
      'Na fresadora G17 precede G02. No torno G18 precede G03 para arredondamento de canto no perfil XZ.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G20 / G21', nome: 'Unidade — Polegada / Métrico', categoria: 'Configuração',
    maquina: 'Fresadora / Torno', fabricante: 'Universal',
    descricao: 'G21=métrico (mm). G20=polegadas. Define unidade para coordenadas, avanços e offsets. Deve ser a primeira linha do programa.',
    descricaoCompleta:
      'G21 seleciona mm — coordenadas, avanços e offsets em milímetros. '
      'G20 seleciona polegadas — coordenadas e avanços em in/min ou in/rot. '
      'CRÍTICO: declarar no início de todo programa — nunca mudar no meio da usinagem. '
      'No Brasil: sempre G21. Programas importados dos EUA podem ter G20 — converter antes. '
      'Offsets G54-G59 também são afetados — requerem nova medição se a unidade for alterada.',
    sintaxe: 'G21  ; métrico (mm)\nG20  ; imperial (polegadas)',
    parametros: [
      Parametro('G21', 'Sistema métrico (mm) — padrão no Brasil'),
      Parametro('G20', 'Sistema imperial (polegadas) — padrão nos EUA'),
    ],
    exemplo:
      'O0001\n'
      '%\n'
      'G90 G17 G21        ; Absoluto, XY, métrico\n'
      'G28 G91 Z0.\n'
      'G90\n'
      'T01 M06            ; Programa continua em mm',
    explicacaoExemplo:
      'G21 na linha de inicialização garante modo métrico independente de o operador ter mudado. Boa prática em todo programa.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G40 / G41 / G42', nome: 'Compensação de Raio de Corte (CRC)', categoria: 'Compensação',
    maquina: 'Fresadora', fabricante: 'Universal',
    descricao: 'G41=compensação esquerda, G42=direita. Ajusta trajetória pelo raio da fresa. Para ajustar medida: mudar valor D sem alterar programa.',
    descricaoCompleta:
      'CRC (Cutter Radius Compensation) permite programar o perfil real da peça — o controle compensa o raio automaticamente. '
      'G41: ferramenta à esquerda do contorno (no sentido de avanço). '
      'G42: ferramenta à direita — mais comum no fresamento em concordância (climb). '
      'D01 = raio no offset. Para afinar cota: diminuir D. Para alargar: aumentar D. '
      'REGRA: ativar só com movimento de entrada tangencial antes do perfil — nunca dentro do material.',
    sintaxe: 'G41 D[n]  ; esquerda\nG42 D[n]  ; direita\nG40       ; cancela',
    parametros: [
      Parametro('D', 'Número do offset (raio da fresa + correção de medida)'),
      Parametro('G41', 'Ferramenta à esquerda do avanço'),
      Parametro('G42', 'Ferramenta à direita do avanço'),
    ],
    exemplo:
      'G42 D01\n'
      'G01 X0. Y-8. F280.  ; Entrada tangencial\n'
      'G01 X80.            ; Lado 1\n'
      'G01 Y50.            ; Lado 2\n'
      'G01 X0.             ; Lado 3\n'
      'G01 X-5. Y-5.       ; Saída antes do G40\n'
      'G40',
    explicacaoExemplo:
      'Contorno retangular com G42. D01=5.0mm (raio da fresa). Se peça ficou 0.1mm grande, mudar D01 para 5.1mm corrige sem alterar programa.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G43 / G44 / G49', nome: 'Compensação de Comprimento de Ferramenta (TLO)', categoria: 'Compensação',
    maquina: 'Centro de Usinagem', fabricante: 'Universal',
    descricao: 'G43=compensação positiva (padrão), G49=cancela. H-code indica registro do offset de comprimento. Obrigatório após troca de ferramenta.',
    descricaoCompleta:
      'TLO (Tool Length Offset) com G43 adiciona o valor de H ao eixo Z — ferramentas diferentes atingem Z=0 correto sem reprogramar. '
      'G43 H01: usa o valor armazenado em H01. '
      'Método de medição: apalpador de comprimento no spindle (mais preciso) ou método de papel. '
      'G43 deve aparecer na primeira movimentação Z após M06. '
      'G49 cancela — evitar usar G49 no meio do programa pois o Z vai à posição real da máquina.',
    sintaxe: 'G43 H[n] Z[cota]\nG49  ; cancela',
    parametros: [
      Parametro('H', 'Registro do offset (H01=T01, H02=T02 etc)'),
      Parametro('Z', 'Cota Z inicial com compensação já ativa'),
    ],
    exemplo:
      'T01 M06\n'
      'G43 H01 Z50. M03 S3000  ; TLO ativo + sobe Z\n'
      'G00 X0. Y0.\n'
      'G01 Z-5. F100.',
    explicacaoExemplo:
      'G43 H01 ativa o offset da ferramenta T01 ao mesmo tempo que comanda Z50. O controle soma o valor H01 a qualquer coordenada Z programada a seguir.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G52', nome: 'Coordenadas Locais — LCS (Local Coordinate System)', categoria: 'Coordenadas',
    maquina: 'Fresadora', fabricante: 'Fanuc / Haas',
    descricao: 'Deslocamento temporário da origem sem alterar G54. Ideal para subprogramas com características repetidas em posições diferentes.',
    descricaoCompleta:
      'G52 cria deslocamento temporário somado ao G54 ativo. '
      'Uso clássico: subprograma escrito em torno de X0Y0 local; G52 desloca para cada grupo de características. '
      'Cancelar: G52 X0. Y0. Z0. — retorna ao G54 sem offset. '
      'Diferença vs G91: G91 acumula deslocamentos; G52 define posição absoluta do offset local.',
    sintaxe: 'G52 X[dx] Y[dy]\nG52 X0. Y0.  ; cancela',
    parametros: [
      Parametro('X/Y/Z', 'Deslocamento da nova origem local relativo ao G54 ativo'),
    ],
    exemplo:
      'G52 X10. Y10.   ; Grupo 1\n'
      'M98 P9010       ; Usina padrão\n'
      'G52 X50. Y10.   ; Grupo 2\n'
      'M98 P9010       ; Mesmo padrão\n'
      'G52 X0. Y0.     ; Cancela LCS',
    explicacaoExemplo:
      'Subprograma O9010 reutilizado 2 vezes em posições diferentes apenas mudando o G52. Elimina repetição de código.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G90 / G91', nome: 'Modo Absoluto / Incremental', categoria: 'Coordenadas',
    maquina: 'Fresadora / Torno', fabricante: 'Universal',
    descricao: 'G90=absoluto (relativo ao zero da peça). G91=incremental (relativo à posição atual). Modal — permanece até ser alterado.',
    descricaoCompleta:
      'G90: coordenadas relativas à origem do sistema ativo (G54 etc). Padrão e mais seguro. '
      'G91: cada valor é um deslocamento a partir da posição atual. '
      'Uso clássico do G91: G28 G91 Z0 — retorno seguro ao home Z sem mover XY. '
      'ARMADILHA: misturar G90 e G91 inadvertidamente — verificar o modo após trechos em G91. '
      'No torno Fanuc: G90 tem significado DIFERENTE (ciclo de torneamento). Usar G00/G01 explicitamente.',
    sintaxe: 'G90  ; absoluto\nG91  ; incremental',
    parametros: [
      Parametro('G90', 'Absoluto — X10. = ir para X=10 na peça'),
      Parametro('G91', 'Incremental — X10. = mover +10mm da posição atual'),
    ],
    exemplo:
      'G90\n'
      'G00 X50. Y30.      ; Vai para X50, Y30 absoluto\n'
      '\n'
      'G91\n'
      'G00 X10. Y5.       ; Desloca +10mm em X, +5mm em Y\n'
      '\n'
      'G28 G91 Z0.        ; Retorno seguro ao home Z',
    explicacaoExemplo:
      'G28 G91 Z0 é o retorno padrão antes de M06. Em G91, Z0 significa "mover Z zero distância incremental" — o controle interpreta como retornar ao referencial.',
    isG: true,
  ),

  CodigoItem(
    codigo: 'G96 / G97', nome: 'CSS — Velocidade de Corte Constante / RPM Fixo', categoria: 'Velocidade',
    maquina: 'Torno CNC', fabricante: 'Universal',
    descricao: 'G96=CSS (m/min constante, RPM varia). G97=RPM fixo. G50 define RPM máximo com G96. Essencial para acabamento de qualidade no torno.',
    descricaoCompleta:
      'G96 mantém V_c constante — RPM varia automaticamente com o diâmetro. '
      'Resultado: acabamento (Ra) uniforme em todo o perfil, vida de ferramenta otimizada. '
      'G50 S[max]: OBRIGATÓRIO com G96 — limita RPM máximo ao se aproximar do centro. '
      'G97: RPM fixo — obrigatório em roscas G32/G76 (sincronismo encoder-eixo) e mandrilamento. '
      'Fórmula manual: RPM = (V_c × 1000) / (π × Ø). Com G96 o CNC calcula automaticamente.',
    sintaxe: 'G96 S[m/min] M03\nG50 S[RPMmax]\nG97 S[RPM] M03',
    parametros: [
      Parametro('S (G96)', 'Velocidade de corte em m/min (Vc)'),
      Parametro('G50 S', 'RPM máximo — obrigatório com G96'),
      Parametro('S (G97)', 'Rotação em RPM — constante'),
    ],
    exemplo:
      'G96 S200 M03    ; CSS: 200 m/min\n'
      'G50 S3000       ; Máximo 3000 RPM\n'
      'G01 X0. F0.15   ; Facear com RPM variando\n'
      '\n'
      'G97 S600 M03    ; RPM fixo para rosca\n'
      'G76 P020060 Q100 R30  ; Ciclo de rosca',
    explicacaoExemplo:
      'Faceamento com G96: RPM sobe conforme Ø diminui, mantendo 200 m/min. G50 S3000 evita RPM excessivo. Na rosca G76, G97 garante sincronismo perfeito com o encoder.',
    isG: true,
  ),

  // ══════════════════════════════════════════════
  // DMG MORI (Fanuc/Siemens + ciclos proprietários)
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'M68 / M69', nome: 'Castanha — Fechar / Abrir (DMG Torno)', categoria: 'Fixação',
    maquina: 'Torno CNC', fabricante: 'DMG', isG: false,
    descricao: 'M68 fecha a castanha (chuck clamp). M69 abre a castanha. Usados em automação com carregamento de peças.',
    descricaoCompleta:
      'Em tornos DMG Mori, M68 comanda o fechamento hidráulico/pneumático da castanha e M69 o abre. '
      'Fundamentais em células de automação onde um robô carrega/descarrega peças. '
      'Sequência padrão: M69 (abre) → robô coloca peça → M68 (fecha) → M03 (gira) → usina → M05 → M69 → robô retira. '
      'Alguns modelos usam M10/M11 para castanha principal e M68/M69 para contra-cabeçote ou castanha secundária.',
    sintaxe: 'M68  ; Fechar castanha\nM69  ; Abrir castanha',
    parametros: [
      Parametro('M68', 'Fecha castanha — confirma pressão mínima antes de continuar'),
      Parametro('M69', 'Abre castanha — aguarda confirmação de aberto'),
    ],
    exemplo:
      'M69          ; Abre castanha\nG4 P2.0      ; Aguarda 2s (robô carrega)\nM68          ; Fecha castanha\nM03 S800     ; Liga spindle\nG00 X100. Z5.\nG01 Z-50. F0.2\nM05\nM69          ; Abre — robô retira\nM30',
    explicacaoExemplo:
      'Ciclo completo de célula automática: abre → peça carregada → fecha → usina → abre → peça retirada. G4 P2.0 garante tempo para confirmação do robô.',
  ),

  CodigoItem(
    codigo: 'M78 / M79', nome: 'Luneta — Avançar / Recuar (DMG)', categoria: 'Fixação',
    maquina: 'Torno CNC', fabricante: 'DMG', isG: false,
    descricao: 'M78 avança a luneta (steady rest). M79 recua. Essencial para peças longas e finas que vibrariam sem suporte.',
    descricaoCompleta:
      'A luneta (steady rest) é um suporte fixo que apoia peças longas no meio do comprimento, evitando deflexão e vibração. '
      'M78 avança a luneta até a posição programada e M79 a recua. '
      'Regra prática: usar luneta quando L/D (comprimento/diâmetro) > 6. Sem luneta em L/D > 8 é quase impossível manter tolerâncias. '
      'Importante: luneta deve ser ajustada ao diâmetro da peça antes de M78 — o operador posiciona manualmente.',
    sintaxe: 'M78  ; Avança luneta\nM79  ; Recua luneta',
    parametros: [
      Parametro('M78', 'Avança luneta para posição de trabalho'),
      Parametro('M79', 'Retrai luneta — libera peça'),
    ],
    exemplo:
      'M03 S400\nG00 Z-200.     ; Posiciona no meio da peça\nM78            ; Ativa luneta\nG01 X28. F0.15 ; Torneia com suporte\nM79            ; Recua luneta\nM05',
    explicacaoExemplo:
      'Para eixo de 400mm/Ø30mm (L/D=13): luneta ativada no centro. Sem ela, deflexão seria ~0.3mm → peça fora de tolerância.',
  ),

  CodigoItem(
    codigo: 'M200 / M201', nome: 'Sub-spindle — Transferir Peça (DMG)', categoria: 'Sub-Spindle',
    maquina: 'Torno CNC', fabricante: 'DMG', isG: false,
    descricao: 'M200 transfere a peça do spindle principal para o sub-spindle. M201 sincroniza os dois spindles para transferência.',
    descricaoCompleta:
      'Tornos DMG com contra-cabeçote sincronizado (sub-spindle) permitem usinar ambas as faces sem reposicionamento manual. '
      'M201: sincroniza velocidades dos dois spindles. '
      'M200: executa a transferência — aproxima o sub-spindle, fecha sua castanha, abre a principal. '
      'Após transferência, o programa continua no lado B da peça, usando G-codes normais mas em orientação invertida. '
      'Reduz setup de horas para segundos em peças que precisam de dois lados.',
    sintaxe: 'M201  ; Sincroniza spindles\nM200  ; Transfere peça',
    parametros: [
      Parametro('M201', 'Sincroniza RPM principal = sub-spindle (fase de transferência)'),
      Parametro('M200', 'Comanda transferência completa: sub avança, fecha, principal abre'),
    ],
    exemplo:
      '; ===== LADO A =====\nM03 S800\nG01 X0. Z-45. F0.15  ; Usina lado A completo\nM05\n; ===== TRANSFERÊNCIA =====\nM201         ; Sincroniza spindles\nM200         ; Transfere peça ao sub\n; ===== LADO B =====\nM04 S800     ; Sub gira inverso (já é normal)\nG01 X0. Z-30. F0.15  ; Usina lado B\nM30',
    explicacaoExemplo:
      'Peça usinada dos dois lados sem toque manual. M04 no lado B porque o sub-spindle segura a peça invertida — o sentido de corte parece invertido no programa.',
  ),

  CodigoItem(
    codigo: 'M38 / M39', nome: 'Contra-ponto — Avançar / Recuar (DMG)', categoria: 'Fixação',
    maquina: 'Torno CNC', fabricante: 'DMG', isG: false,
    descricao: 'M38 avança o contra-ponto pneumático/hidráulico. M39 recua. Para suporte de peças em ponta.',
    descricaoCompleta:
      'O contra-ponto (tailstock) suporta a extremidade livre de peças longas tornadas entre pontas. '
      'M38 avança até a peça com força programada. M39 recua. '
      'Força de avanço é ajustada por parâmetro de máquina (típico: 150–800 N). '
      'Diferente da luneta (posição fixa), o contra-ponto segue o eixo Z se necessário. '
      'Usar quando: L/D > 4 e a peça tem furo de centro.',
    sintaxe: 'M38  ; Avança contra-ponto\nM39  ; Recua contra-ponto',
    parametros: [
      Parametro('M38', 'Avança contra-ponto com força controlada por parâmetro'),
      Parametro('M39', 'Recua contra-ponto — libera extremidade da peça'),
    ],
    exemplo:
      'G00 Z5.      ; Aproxima de Z\nM38          ; Avança contra-ponto\nM03 S600\nG01 Z-380. F0.20 ; Desbaste em comprimento total\nM05\nM39          ; Recua contra-ponto\nG00 Z200. M30',
    explicacaoExemplo:
      'Para eixo longo Ø40mm × 380mm: contra-ponto suporta durante desbaste. M39 antes de retornar Z para evitar colisão.',
  ),

  CodigoItem(
    codigo: 'G361 / G364', nome: 'TRANSMIT / TRACYL — Interpolação (DMG 5X)', categoria: 'Interpolação',
    maquina: 'Torno CNC', fabricante: 'DMG', isG: true,
    descricao: 'TRANSMIT: transforma eixo C+X em coordenadas cartesianas para fresamento de face. TRACYL: fresamento cilíndrico no torno.',
    descricaoCompleta:
      'TRANSMIT (G364) permite usinar formas planas na face do torno usando fresas — o controle converte X/Y cartesiano em X+C polar automaticamente. '
      'TRACYL (G365) desdobra a superfície cilíndrica da peça em um plano para gravar ou fresar ao longo do cilindro. '
      'Esses são recursos do Siemens SINUMERIK em tornos-centros DMG. '
      'Equivalente no Fanuc: G12.1 (face) e G07.1 (cilíndrico). '
      'Requer torno com eixo C motorizado (live tooling).',
    sintaxe: 'TRANSMIT  ; Ativa fresamento de face\nTRACYL(D)  ; D = diâmetro cilindro\nTRANS OFF  ; Desativa',
    parametros: [
      Parametro('TRANSMIT', 'Ativa transformação polar → cartesiana na face da peça'),
      Parametro('TRACYL(D)', 'D = diâmetro do cilindro a fresar em mm'),
      Parametro('TRANS OFF', 'Desativa a transformação — retorna modo torno normal'),
    ],
    exemplo:
      'G97 S1500 M03\nTRANSMIT     ; Ativa face milling\nG17          ; Plano XY ativo\nG01 X10. Y10. F200  ; Move em cartesiano\nG03 X-10. Y10. CR=10. ; Arco\nTRANS OFF    ; Desativa\nG18          ; Retorna plano ZX',
    explicacaoExemplo:
      'Com TRANSMIT ativo, o programa usa X/Y como um centro de usinagem — o CNC converte automaticamente para C+X do torno. Ideal para sextavados, chavetas e furos radiais na face.',
  ),

  // ══════════════════════════════════════════════
  // BROTHER SPEEDIO (Centro de Usinagem de Alta Vel.)
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G100', nome: 'Skip Function — Pular Bloco (Brother)', categoria: 'Controle',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', isG: true,
    descricao: 'Pula para um bloco específico se sinal externo ativo. Usado com apalpadores e células automáticas.',
    descricaoCompleta:
      'G100 no controle Brother executa um salto condicional para o número de bloco especificado se o sinal de skip (entrada digital) estiver ativo. '
      'Útil para: apalpadores de presença de peça, detecção de quebra de ferramenta, células robóticas. '
      'Diferente do G31 (skip com gravação de posição) — G100 é um pulo puro para um label/número de bloco. '
      'Parâmetro P define o número do bloco destino.',
    sintaxe: 'G100 P[bloco]',
    parametros: [
      Parametro('P', 'Número do bloco de destino do salto'),
    ],
    exemplo:
      'G100 P100    ; Se skip ativo: pula para bloco N100\nG01 Z-50. F300 ; Executa se peça presente\nN100\nM30          ; Fim — skip pula aqui se sem peça',
    explicacaoExemplo:
      'Verifica presença de peça: se apalpador não tocou (skip=1), pula direto para M30 sem usinar. Protege contra usinagem em vazio.',
  ),

  CodigoItem(
    codigo: 'G113', nome: 'Interpolação Polar — Face (Brother)', categoria: 'Interpolação',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', isG: true,
    descricao: 'Interpola eixo C como eixo linear para fresamento polar na face da peça. Brother Speedio com eixo de indexação.',
    descricaoCompleta:
      'G113 ativa interpolação polar no Brother Speedio com mesa giratória (eixo A/B). '
      'Converte rotação do eixo giratório em deslocamento linear equivalente para usinagem de perfis curvos na face. '
      'Permite usar programação G01/G02/G03 normalmente em coordenadas retangulares sobre a face girada. '
      'G114 desativa. '
      'Brother Speedio série S1000X1 e R650X1 suportam esse recurso com mesa de 4º eixo integrada.',
    sintaxe: 'G113  ; Ativa interpolação polar\nG114  ; Desativa',
    parametros: [
      Parametro('G113', 'Ativa modo de interpolação polar — converte A em linear'),
      Parametro('G114', 'Desativa — retorna modo de posicionamento por ângulo'),
    ],
    exemplo:
      'G113         ; Ativa polar\nG17          ; Plano XY\nG01 X50. Y0. F500\nG02 X0. Y50. R50.\nG114         ; Desativa polar',
    explicacaoExemplo:
      'Fresa um arco de 90° na peça posicionada no 4º eixo usando G02 normal — G113 faz a conversão automática para o eixo giratório.',
  ),

  CodigoItem(
    codigo: 'M60', nome: 'Troca de Pallet ATC — Brother', categoria: 'Automação',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', isG: false,
    descricao: 'Comanda a troca de pallet no Brother Speedio. Executa o ciclo completo de troca: abre mesa, troca, fecha, confirma.',
    descricaoCompleta:
      'M60 no Brother Speedio ativa o sistema de troca de pallet (Automatic Pallet Changer — APC). '
      'Quando executado: spindle para na posição de origem, mesa desloca para posição de troca, pallets são trocados, confirmação é enviada ao programa. '
      'Brother Speedio são conhecidos por trocas de pallet ultrarrápidas (< 4 segundos). '
      'Depois do M60, o programa reinicia do início do código de peça para o novo pallet. '
      'Pode-se usar M60 no final de cada ciclo de peça para automatizar produção em série.',
    sintaxe: 'M60  ; Troca de pallet',
    parametros: [
      Parametro('M60', 'Executa ciclo completo de troca de pallet APC Brother'),
    ],
    exemplo:
      'O0001 (LADO A)\nT1 M06\nG54 G90\n; ... usinagem ...\nM60          ; Troca pallet — próxima peça\nM30\n\nO0002 (LADO B)\n; (M60 recarrega automaticamente O0001)',
    explicacaoExemplo:
      'No Brother, M60 é o coração da produção contínua. Uma peça bruta entra enquanto a acabada sai — aproveitamento de máquina > 80%.',
  ),

  CodigoItem(
    codigo: 'M200 / M201', nome: 'Travamento do 4º Eixo — Brother Speedio', categoria: 'Eixos',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', isG: false,
    descricao: 'M200 trava o 4º eixo (mesa giratória) para usinagem. M201 libera o trava para indexação.',
    descricaoCompleta:
      'No Brother Speedio com 4º eixo integrado: antes de usinar, o eixo rotativo deve ser travado para absorver forças de corte. '
      'M200 aplica o freio mecânico/hidráulico do 4º eixo. M201 libera para nova indexação. '
      'Sequência correta: G00 A[ângulo] → M200 (trava) → usina → M201 (libera) → próximo ângulo. '
      'Sem M200, corte com alta força lateral pode mover o eixo → peça fora de tolerância angular.',
    sintaxe: 'G00 A[ângulo]\nM200  ; Trava 4º eixo\n; ... usina ...\nM201  ; Libera',
    parametros: [
      Parametro('M200', 'Aplica freio no 4º eixo — confirma travamento antes de continuar'),
      Parametro('M201', 'Libera freio — permite nova indexação angular'),
    ],
    exemplo:
      'G00 A0.         ; 0° — face 1\nM200            ; Trava\nG81 Z-12. R3. F200  ; Fura face 1\nM201            ; Libera\nG00 A60.        ; 60°\nM200            ; Trava\nG81 Z-12. R3. F200  ; Fura face 2\nM201 M30',
    explicacaoExemplo:
      'Furação em 6 faces de um hexagonal: indexa 60°, trava, fura, libera, repete. M200/M201 garantem que as forças da broca não girem a mesa.',
  ),

  CodigoItem(
    codigo: 'M84', nome: 'B-Axis Lock / Spindle Clamp — Brother', categoria: 'Eixos',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', isG: false,
    descricao: 'Trava o eixo B (inclinação do spindle) na posição atual. M85 libera. Necessário para usinagem 3+2.',
    descricaoCompleta:
      'No Brother Speedio série T (com eixo B), M84 trava o spindle na posição angular atual do eixo B. '
      'Fundamental para usinagem 3+2: posiciona B no ângulo desejado, trava com M84 e realiza cortes 3 eixos nessa orientação. '
      'Sem M84, vibrações do corte podem causar microdesvios angulares no eixo B. '
      'M85 libera o eixo B para nova posição. '
      'Para usinagem 5 eixos contínua: não usar M84 (deixar livre para interpolação simultânea).',
    sintaxe: 'G00 B[ângulo]\nM84  ; Trava eixo B\n; ... usinagem 3 eixos ...\nM85  ; Libera B',
    parametros: [
      Parametro('M84', 'Trava eixo B na posição atual com freio mecânico'),
      Parametro('M85', 'Libera eixo B para movimento'),
    ],
    exemplo:
      'G00 B45.        ; Inclina spindle 45°\nM84             ; Trava B\nG54\nG01 X50. Y0. Z-10. F300  ; Usina com spindle inclinado\nM85             ; Libera B\nG00 B0.         ; Retorna vertical',
    explicacaoExemplo:
      'Furação angulada a 45° em uma peça sem precisar de dispositivo especial. Posiciona B45°, trava, fura com G81 normal, libera B.',
  ),

  // ══════════════════════════════════════════════
  // MITSUBISHI CNC M800 / M700
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'G70', nome: 'Ciclo de Acabamento — Torno (Mitsubishi)', categoria: 'Ciclos',
    maquina: 'Torno CNC', fabricante: 'Mitsubishi', isG: true,
    descricao: 'Ciclo de acabamento após desbaste G71/G72. Segue o perfil programado com uma passada final.',
    descricaoCompleta:
      'No Mitsubishi M800/M700, G70 funciona de forma idêntica ao Fanuc — executa o acabamento do perfil após o desbaste com G71 ou G72. '
      'O P define o primeiro bloco do perfil e Q o último. '
      'F e S programados dentro do perfil (entre P e Q) são usados pelo G70. '
      'Importante: o G70 Mitsubishi aceita os mesmos parâmetros que o G70 Fanuc, facilitando a migração de programas entre controles.',
    sintaxe: 'G70 P[início] Q[fim]',
    parametros: [
      Parametro('P', 'Número do bloco inicial do perfil de acabamento'),
      Parametro('Q', 'Número do bloco final do perfil'),
    ],
    exemplo:
      'G71 U2.0 R1.0\nG71 P100 Q200 U0.3 W0.1 F0.3\nG70 P100 Q200    ; Acabamento\n\nN100 G00 X20.\nG01 X30. Z-10. F0.12\nG01 Z-40.\nN200 G01 X50.',
    explicacaoExemplo:
      'G71 desbasta com 2mm de passe, sobremetal 0.3mm. G70 remove os 0.3mm em acabamento seguindo o mesmo perfil P100-Q200 com F0.12.',
  ),

  CodigoItem(
    codigo: 'G74', nome: 'Ciclo de Furação / Canal Axial — Mitsubishi', categoria: 'Ciclos',
    maquina: 'Torno CNC', fabricante: 'Mitsubishi', isG: true,
    descricao: 'Ciclo de furação com peck em Z (eixo principal) ou canal na face. Equivalente ao G74 Fanuc.',
    descricaoCompleta:
      'G74 no Mitsubishi M800: ciclo de furação profunda na face do torno (direção Z) ou canais axiais. '
      'Parâmetro R = afastamento de retorno a cada peck. '
      'Q = profundidade de cada incremento (peck). '
      'Se X e P não são programados: somente furação em Z. Se programados: canais múltiplos na face. '
      'Sintaxe muito similar ao Fanuc G74 — programas podem ser portados com mínimas alterações.',
    sintaxe: 'G74 R[recuo]\nG74 Z[prof] Q[peck] F[av]',
    parametros: [
      Parametro('R', 'Distância de retrocesso a cada peck (mm)'),
      Parametro('Z', 'Profundidade total do furo'),
      Parametro('Q', 'Incremento por peck (µm — ex: Q5000 = 5mm)'),
      Parametro('F', 'Avanço de furação (mm/rot)'),
    ],
    exemplo:
      'G97 S800 M03 M08\nG00 X0. Z5.      ; Centro da peça\nG74 R1.0\nG74 Z-60. Q8000 F0.12\nG00 Z100. M09 M30',
    explicacaoExemplo:
      'Furo central de 60mm em passos de 8mm (Q8000 = 8.0mm). R1.0 = recua 1mm a cada peck para evacuar cavaco. F0.12 mm/rot.',
  ),

  CodigoItem(
    codigo: 'M10 / M11', nome: 'Castanha — Fechar / Abrir (Mitsubishi)', categoria: 'Fixação',
    maquina: 'Torno CNC', fabricante: 'Mitsubishi', isG: false,
    descricao: 'M10 fecha a castanha (chuck clamp). M11 abre. Padrão nos tornos Mitsubishi M800.',
    descricaoCompleta:
      'Nos tornos Mitsubishi M800/M700, M10 fecha a castanha e M11 a abre. '
      'Diferente dos DMG (M68/M69), o Mitsubishi usa numeração mais baixa. '
      'Muitos controles Mitsubishi têm a pressão de aperto programável por parâmetro. '
      'Confirmar no manual da máquina: alguns modelos usam M68/M69 para compatibilidade Fanuc. '
      'A sequência de automação é a mesma: M11 → carga → M10 → usina → M11 → descarga.',
    sintaxe: 'M10  ; Fecha castanha\nM11  ; Abre castanha',
    parametros: [
      Parametro('M10', 'Fecha castanha — aguarda sinal de confirmação de pressão'),
      Parametro('M11', 'Abre castanha — aguarda confirmação de aberto'),
    ],
    exemplo:
      'M11         ; Abre para troca de peça\nM00         ; Parada programada (operador carrega)\nM10         ; Fecha\nM03 S600\nG00 X52. Z2.\nG71 U1.5 R0.5\nG71 P10 Q80 U0.3 F0.25\nG70 P10 Q80\nM05\nM11\nM30',
    explicacaoExemplo:
      'M00 para o programa para o operador colocar a peça. M10 fecha após confirmação. Ciclo completo de torno manual assistido por CNC.',
  ),

  CodigoItem(
    codigo: 'G68.2', nome: 'Inclinação do Plano de Trabalho — Mitsubishi', categoria: 'Coordenadas',
    maquina: 'Centro de Usinagem', fabricante: 'Mitsubishi', isG: true,
    descricao: 'Define plano de trabalho inclinado por ângulos Euler ou vetores. Permite usinagem 3+2 e 5 eixos contínuos no M800.',
    descricaoCompleta:
      'G68.2 no Mitsubishi M800 (idêntico ao Fanuc 31i) define um sistema de coordenadas inclinado. '
      'Permite programar em coordenadas do plano inclinado como se fosse um plano horizontal normal. '
      'Tipos de especificação: '
      'G68.2 X Y Z I J K (vetor normal ao plano) ou '
      'G68.2 X Y Z Q1 Q2 Q3 (ângulos Euler). '
      'G69 cancela o plano inclinado. '
      'Essencial para 5 eixos: programa em 3 eixos, máquina interpola 5.',
    sintaxe: 'G68.2 X[cx] Y[cy] Z[cz] I[a1] J[a2] K[a3]\nG69  ; Cancela',
    parametros: [
      Parametro('X Y Z', 'Ponto de origem do sistema inclinado'),
      Parametro('I J K', 'Ângulos de rotação em X, Y, Z respectivamente (graus)'),
      Parametro('G69', 'Cancela G68.2 — retorna ao plano original'),
    ],
    exemplo:
      'G68.2 X0. Y0. Z0. I0. J30. K0.  ; Inclina 30° em Y\nG54\nG00 X50. Y0. Z10.  ; Coord. do plano inclinado\nG81 Z-15. R3. F200\nG69  ; Cancela inclinação\nG00 Z100.',
    explicacaoExemplo:
      'Fura furo inclinado 30° sem necessidade de dispositivo especial. G68.2 faz a matemática — programa como se fosse furo vertical.',
  ),

  CodigoItem(
    codigo: 'M96 / M97', nome: 'Espelho — Ativar / Cancelar (Mitsubishi)', categoria: 'Transformações',
    maquina: 'Centro de Usinagem', fabricante: 'Mitsubishi', isG: false,
    descricao: 'M96 ativa espelho nos eixos programados. M97 cancela. Duplica peça espelhada sem reprogramação.',
    descricaoCompleta:
      'Nos centros de usinagem Mitsubishi M800, M96 ativa imagem espelho em eixos especificados. '
      'Exemplo: M96 X0. espelha em relação ao eixo X=0 (inverte direção de Y). '
      'Combina com G54 para espelhar peças em gabaritos com layout espelhado. '
      'M97 cancela o espelho e retorna ao modo normal. '
      'Útil para: peças simétricas (esquerda/direita), gabaritos duplos, redução de programação.',
    sintaxe: 'M96 X[val] Y[val]  ; Ativa espelho\nM97               ; Cancela espelho',
    parametros: [
      Parametro('X', 'Posição do eixo de espelho em X (omitir se não espelhar X)'),
      Parametro('Y', 'Posição do eixo de espelho em Y (omitir se não espelhar Y)'),
    ],
    exemplo:
      'G54\nM98 P1000    ; Usina lado esquerdo\nM96 X0.      ; Ativa espelho em X\nG55          ; Offset da peça direita\nM98 P1000    ; Mesmo programa — espelhado\nM97          ; Cancela espelho\nM30',
    explicacaoExemplo:
      'O subprograma P1000 é usado para ambas as peças. M96 X0 espelha automaticamente todos os movimentos X — peça direita sai espelhada da esquerda.',
  ),

  // ══════════════════════════════════════════════
  // OKUMA OSP-P300 / OSP-P200
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'CALL / CALLSUB', nome: 'Chamada de Subprograma — Okuma OSP', categoria: 'Subprogramas',
    maquina: 'Ambos', fabricante: 'Okuma', isG: false,
    descricao: 'No Okuma OSP, subprogramas são chamados com CALL e encerrados com RTS. Diferente do M98/M99 Fanuc.',
    descricaoCompleta:
      'O controle Okuma OSP-P300/P200 usa sintaxe própria para subprogramas. '
      'CALL O[nome] L[repetições]: chama subprograma pelo nome. '
      'O subprograma termina com RTS (Return from Subroutine) — equivalente ao M99 Fanuc. '
      'Programas no Okuma podem ter nomes alfanuméricos (não só números) — ex: CALL O"FURO_M6". '
      'Variáveis locais e globais: V1-V99 locais ao subprograma, V100+ globais. '
      'Muito mais flexível que o M98/M99 do Fanuc.',
    sintaxe: 'CALL O[número/nome] L[repetições]\n; No subprograma:\nRTS  ; Fim do subprograma',
    parametros: [
      Parametro('O', 'Número ou nome do subprograma (ex: O100 ou O"PERFIL")'),
      Parametro('L', 'Número de repetições (padrão: 1)'),
      Parametro('RTS', 'Return from Subroutine — substitui M99 do Fanuc'),
    ],
    exemplo:
      '; PROGRAMA PRINCIPAL\nCALL O200 L3  ; Chama O200 — 3 vezes\nM02           ; Fim\n\n; SUBPROGRAMA O200\nG01 X50. F300\nG01 Z-30.\nG01 X60.\nRTS           ; Retorna ao principal',
    explicacaoExemplo:
      'CALL O200 L3 executa o subprograma 3 vezes consecutivamente. RTS retorna após cada execução. L3 = economiza 3 cópias do mesmo código.',
  ),

  CodigoItem(
    codigo: 'G330', nome: 'Ciclo de Furação Profunda — Okuma OSP', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Okuma', isG: true,
    descricao: 'Ciclo de peck drilling do Okuma OSP. Equivalente ao G83 Fanuc mas com sintaxe própria e mais parâmetros.',
    descricaoCompleta:
      'G330 é o ciclo de furação profunda no Okuma OSP-P300. '
      'Parâmetros: Z = profundidade total, D = incremento de peck, B = afastamento de retorno, F = avanço. '
      'O Okuma OSP tem ciclos numerados diferentemente do Fanuc: '
      'G330=furação peck, G331=rosqueamento, G332=mandrilamento, G333=alargamento. '
      'Importante: o cancelamento é G300 (equivalente ao G80 Fanuc).',
    sintaxe: 'G330 X[x] Y[y] Z[z] D[peck] B[retorno] F[av]',
    parametros: [
      Parametro('Z', 'Profundidade total do furo'),
      Parametro('D', 'Profundidade do incremento (peck) em mm'),
      Parametro('B', 'Distância de retrocesso a cada peck'),
      Parametro('F', 'Avanço de furação (mm/min)'),
    ],
    exemplo:
      'T3\nS900 M3\nG0 X50. Y30.\nG330 Z-80. D15. B1. F120\nG300      ; Cancela ciclo (= G80 Fanuc)\nM30',
    explicacaoExemplo:
      'Furo de 80mm em passos de 15mm, recuando 1mm a cada peck. G300 cancela o ciclo — equivalente ao G80. Adaptar F de mm/rot (Fanuc) para mm/min (Okuma).',
  ),

  CodigoItem(
    codigo: 'G110 / G111', nome: 'Offset de Ferramenta — Okuma OSP', categoria: 'Ferramenta',
    maquina: 'Centro de Usinagem', fabricante: 'Okuma', isG: true,
    descricao: 'G110 ativa offset de comprimento de ferramenta. G111 cancela. Equivalente ao G43/G49 no Fanuc.',
    descricaoCompleta:
      'No Okuma OSP, o offset de comprimento de ferramenta é chamado com G110 H[número]. '
      'G111 cancela (equivalente ao G49). '
      'O Okuma usa uma lógica diferente: o número H corresponde ao registro de ferramenta completo (comprimento + raio + desgaste). '
      'Muitos Okuma modernos (OSP-P300) já ativam automaticamente o offset quando T[n] é chamado — G110 é confirmação adicional. '
      'Verificar no manual: em alguns modelos G110 é substituído por G43 para compatibilidade.',
    sintaxe: 'G110 H[número]  ; Ativa TLO\nG111           ; Cancela TLO',
    parametros: [
      Parametro('H', 'Número do registro de offset de ferramenta'),
      Parametro('G111', 'Cancela offset de comprimento — equivalente G49 Fanuc'),
    ],
    exemplo:
      'T5           ; Chama fresa T5\nG110 H5      ; Ativa offset comprimento T5\nG0 Z100.\nG0 X0. Y0.\nG0 Z10.\nG1 Z-20. F200\nG111         ; Cancela TLO\nG0 Z100.\nM30',
    explicacaoExemplo:
      'Sequência padrão Okuma: T5 seleciona, G110 H5 aplica o offset de comprimento registrado para a ferramenta 5. G111 cancela ao final.',
  ),

  CodigoItem(
    codigo: 'M31 / M32', nome: 'Castanha Principal — Fechar / Abrir (Okuma)', categoria: 'Fixação',
    maquina: 'Torno CNC', fabricante: 'Okuma', isG: false,
    descricao: 'M31 fecha a castanha do torno Okuma. M32 abre. Padrão no OSP-P300/P200 para tornos série LB/LT.',
    descricaoCompleta:
      'Nos tornos Okuma série LB-EX, LT, e MULTUS, M31 fecha a castanha principal e M32 a abre. '
      'Nos modelos com sub-spindle: M33/M34 controlam a castanha do contra-spindle. '
      'A pressão de aperto pode ser programada por parâmetro ou por código específico antes de M31. '
      'Importante: no Okuma, M31 verifica pressão mínima antes de continuar o programa — segurança automática. '
      'Em peças frágeis, ajustar pressão por parâmetro P9103 (dependendo do modelo).',
    sintaxe: 'M31  ; Fecha castanha\nM32  ; Abre castanha\nM33  ; Fecha sub-spindle\nM34  ; Abre sub-spindle',
    parametros: [
      Parametro('M31', 'Fecha castanha principal — aguarda pressão OK'),
      Parametro('M32', 'Abre castanha principal'),
      Parametro('M33', 'Fecha castanha do sub-spindle (se equipado)'),
      Parametro('M34', 'Abre castanha do sub-spindle'),
    ],
    exemplo:
      'M32         ; Abre para carga\nM00         ; Parada — operador carrega peça\nM31         ; Fecha\nM03 S1000\nG00 X55. Z2.\nG71 U2. R0.5\nG71 P10 Q90 U0.4 W0.1 F0.3\nG70 P10 Q90\nM05 M32 M30',
    explicacaoExemplo:
      'Ciclo com carga manual: M32 abre, M00 para para o operador, M31 fecha com verificação de pressão. M05 M32 M30 finaliza seguro.',
  ),

  CodigoItem(
    codigo: 'G2001', nome: 'Interpolação de Alta Velocidade — Okuma', categoria: 'Velocidade',
    maquina: 'Centro de Usinagem', fabricante: 'Okuma', isG: true,
    descricao: 'Ativa modo de usinagem de alta velocidade (HSM) no Okuma OSP. Equivalente ao G05.1 Q1 do Fanuc.',
    descricaoCompleta:
      'G2001 é o código de usinagem de alta velocidade do controle Okuma OSP-P300. '
      'Ativa o processamento antecipado de blocos (look-ahead), suavização de trajetória e controle de aceleração adaptativo. '
      'Parâmetros específicos do Okuma permitem controlar: '
      'Nível de suavização (1-10), tolerância de corda, aceleração máxima. '
      'G2000 desativa o modo HSM. '
      'Equivalentes em outros controles: Fanuc G05.1 Q1, Siemens CYCLE832, Heidenhain FUNCTION TCPM.',
    sintaxe: 'G2001  ; Ativa HSM\n; ... blocos de usinagem ...\nG2000  ; Desativa HSM',
    parametros: [
      Parametro('G2001', 'Ativa modo High Speed Machining — Okuma OSP'),
      Parametro('G2000', 'Desativa HSM — retorna modo padrão'),
    ],
    exemplo:
      'G2001        ; Ativa HSM\nG01 X100. F8000\nG03 X80. Y20. R30.\nG01 X60. Y50.\nG02 X40. Y70. R15.\nG2000        ; Desativa\nG00 Z100.',
    explicacaoExemplo:
      'Alta velocidade ativada: o OSP suaviza automaticamente as transições entre G01/G02/G03 sem parar. F8000 (8m/min) possível com G2001 — sem ele, a máquina frenaria em cada mudança de direção.',
  ),

  // ══════════════════════════════════════════════
  // HEIDENHAIN iTNC 530 / TNC 640 — Extras
  // ══════════════════════════════════════════════

  CodigoItem(
    codigo: 'CYCL DEF 6', nome: 'Ciclo 6 — Rosqueamento com Macho (Heidenhain)', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Heidenhain', isG: false,
    descricao: 'Define o ciclo de rosqueamento rígido com macho no iTNC/TNC 640. Parâmetros: profundidade, passo, fator de velocidade.',
    descricaoCompleta:
      'CYCL DEF 6 no Heidenhain define um ciclo de rosqueamento com macho (tapping). '
      'Q239 = passo da rosca em mm (positivo = direita, negativo = esquerda). '
      'Q203/Q204 = coordenada da superfície e 2º plano de segurança. '
      'Q206 = avanço de retração (geralmente maior que de entrada). '
      'Para executar: CYCL CALL (posição única) ou L X Y FMAX CYCL CALL (com posicionamento). '
      'Heidenhain suporta rosqueamento rígido desde iTNC 530 — sem mandril flutuante necessário.',
    sintaxe:
      'CYCL DEF 6.0 ROSQUEAMENTO\nCYCL DEF 6.1 DIST+5\nCYCL DEF 6.2 TIEFE-20\nCYCL DEF 6.3 PASSO+1.25\nCYCL DEF 6.4 F_ENTR600\n\nL X50 Y30 FMAX\nCYCL CALL',
    parametros: [
      Parametro('DIST', 'Distância de segurança acima da peça (positivo)'),
      Parametro('TIEFE', 'Profundidade de rosca (negativo)'),
      Parametro('PASSO', 'Passo da rosca (+ direita, - esquerda)'),
      Parametro('F_ENTR', 'Avanço de entrada (mm/min)'),
    ],
    exemplo:
      'CYCL DEF 6.0 ROSQUEAMENTO\nCYCL DEF 6.1 DIST+3\nCYCL DEF 6.2 TIEFE-25\nCYCL DEF 6.3 PASSO+1.0\nCYCL DEF 6.4 F600\n\nTOOL CALL 8 Z S600\nL X30 Y30 FMAX M3\nCYCL CALL\nL X60 Y30 FMAX\nCYCL CALL\nM30',
    explicacaoExemplo:
      'Rosqueia M6×1.0 a 25mm de profundidade em 2 posições. Passo 1.0mm com S600 RPM → F = 600 × 1.0 = 600 mm/min automaticamente calculado pelo controle.',
  ),

  CodigoItem(
    codigo: 'CYCL DEF 220', nome: 'Ciclo 220 — Padrão Circular (Heidenhain)', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Heidenhain', isG: false,
    descricao: 'Distribui o ciclo de furação ativo em N furos igualmente espaçados num círculo. Dispensa programar cada posição.',
    descricaoCompleta:
      'CYCL DEF 220 distribui qualquer ciclo previamente definido (CYCL DEF 1-27) em posições distribuídas num círculo. '
      'Q216/Q217 = centro do círculo X e Y. Q244 = diâmetro do padrão. '
      'Q245 = ângulo do primeiro furo. Q246 = ângulo do último furo. Q247 = passo angular entre furos. Q241 = número de repetições. '
      'Extremamente eficiente: defina o ciclo uma vez (ex: CYCL DEF 1 furação) e chame o 220 para distribuí-lo.',
    sintaxe:
      'CYCL DEF 1.0 FURACAO  ; ciclo base\nCYCL DEF 220.0 PADRAO CIRCULAR\nCYCL DEF 220.1 Q216=50  ; centro X\nCYCL DEF 220.2 Q217=50  ; centro Y\nCYCL DEF 220.3 Q244=60  ; Ø padrão\nCYCL DEF 220.4 Q245=0   ; ângulo 1°\nCYCL DEF 220.5 Q246=360 ; ângulo final\nCYCL DEF 220.6 Q241=6   ; 6 furos\nCYCL CALL',
    parametros: [
      Parametro('Q216/Q217', 'Coordenadas XY do centro do padrão circular'),
      Parametro('Q244', 'Diâmetro do padrão (círculo dos furos)'),
      Parametro('Q245/Q246', 'Ângulo do primeiro e último furo'),
      Parametro('Q241', 'Número de furos/posições'),
    ],
    exemplo:
      '; 6 furos em círculo Ø60mm, centro X50 Y50\nCYCL DEF 1.0 FURACAO\nCYCL DEF 1.1 DIST+3\nCYCL DEF 1.2 TIEFE-15\nCYCL DEF 1.3 F200\nCYCL DEF 220.0 PADRAO CIRC\nCYCL DEF 220.1 Q216=50\nCYCL DEF 220.2 Q217=50\nCYCL DEF 220.3 Q244=60\nCYCL DEF 220.5 Q246=360\nCYCL DEF 220.6 Q241=6\nCYCL CALL',
    explicacaoExemplo:
      '6 furos a cada 60° num círculo de Ø60mm, centro em X50 Y50. Sem o 220, seriam 6 blocos L X Y + CYCL CALL. Com o 220: um bloco faz tudo.',
  ),

  CodigoItem(
    codigo: 'G54.1 / G54 P', nome: 'Offsets de Trabalho Estendidos', categoria: 'Coordenadas',
    maquina: 'Centro de Usinagem', fabricante: 'Fanuc / Haas',
    descricao: 'Expande os 6 offsets básicos para até 300 (Fanuc G54.1 P1-P300) ou 99 (Haas G54 P1-P99). Essencial para sistemas pallet.',
    descricaoCompleta:
      'Fanuc G54.1 P1 a P300: expande além dos G54-G59 básicos (com opção de memória). '
      'Haas G54 P1 a P99: extensão proprietária. '
      'Aplicação: sistemas pallet com múltiplas fixações, gabaritos com muitas peças, células robotizadas. '
      'Offsets persistentes — mantêm valores após desligar a máquina. '
      'Funcionam exatamente como G54-G59 em termos de uso no programa.',
    sintaxe: 'G54.1 P[1-300]  ; Fanuc\nG54 P[1-99]     ; Haas',
    parametros: [
      Parametro('P', 'Número do offset estendido'),
    ],
    exemplo:
      'G54.1 P1    ; Pallet 1\n'
      'M98 P1000   ; Usina\n'
      'G54.1 P2    ; Pallet 2\n'
      'M98 P1000   ; Mesmo programa\n'
      'G54.1 P3    ; Pallet 3\n'
      'M98 P1000',
    explicacaoExemplo:
      'O subprograma M98 P1000 usina 3 pallets diferentes apenas trocando G54.1 P— sem alterar o programa de usinagem.',
    isG: true,
  ),
];
