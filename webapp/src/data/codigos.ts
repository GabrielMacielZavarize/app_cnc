import type { CodigoItem } from '@/types';
// Gerado por scripts/convert_dart_data.py — não editar à mão.

export const codigosG: CodigoItem[] = [

  
  {codigo: 'G00', nome: 'Posicionamento Rápido', categoria: 'Movimento', maquina: 'Ambos',
    descricao: 'Move todos os eixos na velocidade máxima sem cortar.',
    descricaoCompleta: 'G00 move a ferramenta até a posição programada na velocidade máxima sem corte. Modal — permanece ativo até ser substituído. Todos os eixos se movem simultaneamente.',
    sintaxe: 'G00 X[val] Y[val] Z[val]',
    parametros: [{ letra: 'X', descricao: 'Posição final X' }, { letra: 'Y', descricao: 'Posição final Y' }, { letra: 'Z', descricao: 'Posição final Z' }],
    exemplo: 'G00 Z5.0\nG00 X0 Y0',
    explicacaoExemplo: 'Sobe Z para segurança e move para origem em velocidade máxima.',
    dicaProfissional: 'NUNCA programe G00 para dentro do material — use G01 com F programado. Sempre suba Z antes de mover em X/Y com G00 para evitar colisão com fixadores e ressaltos da peça.',
    isG: true},

  {codigo: 'G01', nome: 'Interpolação Linear', categoria: 'Movimento', maquina: 'Ambos',
    descricao: 'Movimento linear com corte a velocidade controlada por F.',
    descricaoCompleta: 'G01 realiza movimento linear cortando o material. Velocidade definida por F. Modal. O código de corte mais usado em CNC.',
    sintaxe: 'G01 X[val] Y[val] Z[val] F[avanço]',
    parametros: [{ letra: 'X', descricao: 'Posição final X' }, { letra: 'Y', descricao: 'Posição final Y' }, { letra: 'Z', descricao: 'Profundidade' }, { letra: 'F', descricao: 'Avanço mm/min ou mm/rot' }],
    exemplo: 'G01 Z-3.0 F100\nG01 X50.0 F200',
    explicacaoExemplo: 'Desce 3mm a 100mm/min e corta até X=50mm a 200mm/min.',
    dicaProfissional: 'Para fresamento em rampa (ramp-in), combine G01 X e Z simultaneamente para evitar furar direto no material: G01 X30. Z-3. F150. Reduz carga axial na fresa.',
    isG: true},

  {codigo: 'G02', nome: 'Interpolação Circular Horária', categoria: 'Movimento', maquina: 'Ambos',
    descricao: 'Arco no sentido horário com corte. Pode usar R ou I,J,K.',
    descricaoCompleta: 'G02 executa arco horário (CW). R = raio direto. I,J = distância ao centro. O plano deve ser selecionado com G17/G18/G19.',
    sintaxe: 'G02 X[fim] Y[fim] R[raio] F[av]\nG02 X[fim] Y[fim] I[dx] J[dy] F[av]',
    parametros: [{ letra: 'R', descricao: 'Raio (+ = arco <180°, - = arco >180°)' }, { letra: 'I', descricao: 'Distância ao centro em X' }, { letra: 'J', descricao: 'Distância ao centro em Y' }],
    exemplo: 'G02 X30.0 Y0 R15.0 F150\nG02 X30.0 Y0 I15.0 J0 F150',
    explicacaoExemplo: 'Arco horário raio 15mm — R e I,J produzem o mesmo resultado.',
    dicaProfissional: 'Para círculo completo (360°) NUNCA use R — use I,J. Com R o CNC não sabe qual caminho tomar no círculo completo. Exemplo: G02 I15. (circulo completo raio 15mm partindo da posição atual).',
    isG: true},

  {codigo: 'G03', nome: 'Interpolação Circular Anti-horária', categoria: 'Movimento', maquina: 'Ambos',
    descricao: 'Arco no sentido anti-horário com corte.',
    descricaoCompleta: 'G03 é igual ao G02 mas no sentido anti-horário (CCW). Usado para raios internos, bolsões e perfis côncavos.',
    sintaxe: 'G03 X[fim] Y[fim] R[raio] F[av]',
    parametros: [{ letra: 'R', descricao: 'Raio mm' }, { letra: 'I/J', descricao: 'Coordenadas do centro' }],
    exemplo: 'G03 X0 Y30.0 R15.0 F150',
    explicacaoExemplo: 'Arco anti-horário raio 15mm para perfis internos.', isG: true},

  {codigo: 'G04', nome: 'Pausa Temporizada (Dwell)', categoria: 'Movimento', maquina: 'Ambos',
    descricao: 'Para todos os movimentos por um tempo determinado.',
    descricaoCompleta: 'G04 provoca pausa no programa pelo tempo especificado. Útil para garantir que a ferramenta complete o corte antes de retrair.',
    sintaxe: 'G04 P[ms] ou G04 X[seg]',
    parametros: [{ letra: 'P', descricao: 'Tempo em milissegundos (P1000 = 1s)' }, { letra: 'X', descricao: 'Tempo em segundos' }],
    exemplo: 'G01 Z-10. F100\nG04 P500\nG00 Z5.',
    explicacaoExemplo: 'Perfura, pausa 0.5s para limpar o fundo e retrai.', isG: true},

  
  {codigo: 'G17', nome: 'Plano XY — Fresamento', categoria: 'Planos', maquina: 'Ambos',
    descricao: 'Seleciona plano XY para arcos e compensação de raio. Padrão fresamento.',
    descricaoCompleta: 'G17 seleciona o plano XY. Padrão para centros de usinagem verticais. Obrigatório antes de G02/G03 e G41/G42.',
    sintaxe: 'G17', parametros: [],
    exemplo: 'G17\nG02 X30. Y0 R15. F150',
    explicacaoExemplo: 'Plano XY ativo — padrão fresamento vertical.', isG: true},

  {codigo: 'G18', nome: 'Plano XZ — Torneamento', categoria: 'Planos', maquina: 'Ambos',
    descricao: 'Seleciona plano XZ para arcos. Padrão para tornos CNC.',
    descricaoCompleta: 'G18 seleciona o plano XZ. Padrão para tornos. Necessário para arcos G02/G03 no perfil longitudinal.',
    sintaxe: 'G18', parametros: [],
    exemplo: 'G18\nG02 X30. Z-5. R10. F100',
    explicacaoExemplo: 'Plano XZ — arco no torneamento.', isG: true},

  {codigo: 'G19', nome: 'Plano YZ', categoria: 'Planos', maquina: 'Ambos',
    descricao: 'Seleciona plano YZ para arcos em fresamento lateral.',
    descricaoCompleta: 'G19 seleciona o plano YZ. Usado em fresamento lateral e máquinas 5 eixos.',
    sintaxe: 'G19', parametros: [],
    exemplo: 'G19\nG02 Y20. Z-5. R10. F100',
    explicacaoExemplo: 'Plano YZ para 5 eixos.', isG: true},

  
  {codigo: 'G20', nome: 'Unidade em Polegadas', categoria: 'Configuração', maquina: 'Ambos',
    descricao: 'Define todas as medidas em polegadas (sistema imperial).',
    descricaoCompleta: 'Com G20, todos os valores são em polegadas. Nunca misture G20 e G21 no mesmo programa.',
    sintaxe: 'G20', parametros: [],
    exemplo: 'G20\nG00 X1.0 Y0.5',
    explicacaoExemplo: 'X1.0 = 25.4mm — sistema imperial.', isG: true},

  {codigo: 'G21', nome: 'Unidade em Milímetros', categoria: 'Configuração', maquina: 'Ambos',
    descricao: 'Define todas as medidas em mm. Padrão mundial.',
    descricaoCompleta: 'Com G21, todos os valores são em mm. Sempre declarar no início do programa.',
    sintaxe: 'G21', parametros: [],
    exemplo: 'G21\nG00 X50. Y25.',
    explicacaoExemplo: 'Padrão no Brasil e no mundo.', isG: true},

  
  {codigo: 'G40', nome: 'Cancela Compensação de Raio', categoria: 'Compensação', maquina: 'Centro de Usinagem',
    descricao: 'Desativa G41 ou G42.',
    descricaoCompleta: 'G40 cancela compensação de raio. Deve ser usado com movimento G00 ou G01 para saída correta.',
    sintaxe: 'G40 G00 X[val]', parametros: [],
    exemplo: 'G01 X50. F200\nG40 G00 X60.',
    explicacaoExemplo: 'Cancela compensação e afasta — sempre com movimento.', isG: true},

  {codigo: 'G41', nome: 'Compensação de Raio — Esquerda', categoria: 'Compensação', maquina: 'Centro de Usinagem',
    descricao: 'Posiciona fresa à esquerda do perfil. Compensa o raio automaticamente.',
    descricaoCompleta: 'G41 desloca o centro da fresa para a esquerda da trajetória pelo valor D. Permite trocar a fresa sem reprogramar o perfil.',
    sintaxe: 'G41 D[n] G01 X[val] F[av]',
    parametros: [{ letra: 'D', descricao: 'Offset de raio na tabela — valor = raio da fresa' }],
    exemplo: 'G41 D01 G01 X10. F200\nG01 Y50.\nG40 G00 X60.',
    explicacaoExemplo: 'Ativa D01, usina contorno e cancela com G40.', isG: true},

  {codigo: 'G42', nome: 'Compensação de Raio — Direita', categoria: 'Compensação', maquina: 'Centro de Usinagem',
    descricao: 'Posiciona fresa à direita do perfil.',
    descricaoCompleta: 'G42 é igual ao G41 mas à direita da trajetória.',
    sintaxe: 'G42 D[n] G01 X[val] F[av]',
    parametros: [{ letra: 'D', descricao: 'Offset de raio' }],
    exemplo: 'G42 D01 G01 X10. F200\nG40 G00 X60.',
    explicacaoExemplo: 'Fresa pelo lado direito do perfil.', isG: true},

  {codigo: 'G43', nome: 'Compensação de Comprimento +', categoria: 'Compensação', maquina: 'Ambos',
    descricao: 'Ativa compensação de comprimento de ferramenta. Essencial após troca.',
    descricaoCompleta: 'G43 soma o valor H ao eixo Z. Permite usar ferramentas de comprimentos diferentes sem reprogramar.',
    sintaxe: 'G43 H[n] Z[val]',
    parametros: [{ letra: 'H', descricao: 'Número do offset de comprimento' }, { letra: 'Z', descricao: 'Posição Z inicial' }],
    exemplo: 'T01 M06\nG43 H01 Z100.',
    explicacaoExemplo: 'Troca T1 e ativa compensação H01.', isG: true},

  {codigo: 'G44', nome: 'Compensação de Comprimento —', categoria: 'Compensação', maquina: 'Ambos',
    descricao: 'Ativa compensação negativa de comprimento.',
    descricaoCompleta: 'G44 subtrai o valor H do eixo Z. Menos comum — para casos onde compensação é negativa.',
    sintaxe: 'G44 H[n] Z[val]',
    parametros: [{ letra: 'H', descricao: 'Offset' }, { letra: 'Z', descricao: 'Posição Z' }],
    exemplo: 'G44 H02 Z50.',
    explicacaoExemplo: 'Compensação negativa.', isG: true},

  {codigo: 'G49', nome: 'Cancela Compensação de Comprimento', categoria: 'Compensação', maquina: 'Centro de Usinagem',
    descricao: 'Desativa G43 ou G44.',
    descricaoCompleta: 'G49 cancela a compensação de comprimento ativa.',
    sintaxe: 'G49', parametros: [],
    exemplo: 'G28 Z0\nG49',
    explicacaoExemplo: 'Retorna ao zero e cancela compensação.', isG: true},

  
  {codigo: 'G73', nome: 'Furação com Quebra de Cavaco', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Furação profunda com retrações parciais para quebrar cavaco. Mais rápido que G83.',
    descricaoCompleta: 'G73 faz furação profunda com pequenas retrações (não sai do furo) a cada passo Q para quebrar o cavaco. Ideal para materiais de cavaco longo como inox.',
    sintaxe: 'G73 X[pos] Y[pos] Z[prof] R[plano] Q[passo] F[av]',
    parametros: [{ letra: 'Z', descricao: 'Profundidade final' }, { letra: 'R', descricao: 'Plano de retorno' }, { letra: 'Q', descricao: 'Passo por perfurada' }, { letra: 'F', descricao: 'Avanço' }],
    exemplo: 'G73 X20. Y15. Z-30. R2. Q5. F80\nG80',
    explicacaoExemplo: 'Furo 30mm — desce 5mm por vez quebrando cavaco.', isG: true},

  {codigo: 'G74', nome: 'Rosqueamento Esquerdo', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Ciclo automático de rosqueamento com macho esquerdo (M04).',
    descricaoCompleta: 'G74 executa rosqueamento anti-horário. Spindle inverte automaticamente na retração. F = passo × RPM.',
    sintaxe: 'G74 X[pos] Y[pos] Z[prof] R[plano] F[av]',
    parametros: [{ letra: 'Z', descricao: 'Profundidade' }, { letra: 'F', descricao: 'Passo × RPM' }],
    exemplo: 'S500 M04\nG74 X20. Y15. Z-20. R2. F0.75\nG80',
    explicacaoExemplo: 'Rosca esquerda passo 0.75 a 500 RPM.', isG: true},

  {codigo: 'G76', nome: 'Mandrilamento Fino', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Mandrilamento com recuo orientado — não risca a superfície do furo.',
    descricaoCompleta: 'G76 para o spindle em posição angular (M19) antes de retrair, deslocando para não riscar. Para furos de alta precisão Ra < 0.8μm.',
    sintaxe: 'G76 X[pos] Y[pos] Z[prof] R[plano] Q[desl] F[av]',
    parametros: [{ letra: 'Q', descricao: 'Deslocamento de recuo em μm' }, { letra: 'F', descricao: 'Avanço' }],
    exemplo: 'G76 X50. Y30. Z-25. R2. Q100 F50\nG80',
    explicacaoExemplo: 'Mandrila, orienta spindle, desloca 0.1mm e retrai sem riscar.', isG: true},

  {codigo: 'G80', nome: 'Cancela Ciclo Fixo', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Cancela qualquer ciclo fixo ativo (G73 a G89). SEMPRE usar ao final.',
    descricaoCompleta: 'G80 desativa o ciclo fixo. Sem G80, o CNC continua executando o ciclo em cada novo bloco de posicionamento.',
    sintaxe: 'G80', parametros: [],
    exemplo: 'G81 X10. Z-15. R2. F100\nX20. X30.\nG80',
    explicacaoExemplo: 'Faz furos e cancela o ciclo.', isG: true},

  {codigo: 'G81', nome: 'Furação Simples', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Ciclo básico de furação — desce, fura e retrai rapidamente.',
    descricaoCompleta: 'G81 é o ciclo de furação mais usado. Desce com F até Z, retrai em G00 até R. Ideal para furos rasos (L/D < 3).',
    sintaxe: 'G81 X[pos] Y[pos] Z[prof] R[plano] F[av]',
    parametros: [{ letra: 'Z', descricao: 'Profundidade' }, { letra: 'R', descricao: 'Plano de retorno' }, { letra: 'F', descricao: 'Avanço' }],
    exemplo: 'G81 X10. Y10. Z-15. R2. F100\nX20. Y10.\nG80',
    explicacaoExemplo: 'Faz furos de 15mm de profundidade.', isG: true},

  {codigo: 'G82', nome: 'Furação com Pausa (Counterbore)', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Furação com pausa P no fundo — ideal para rebaixos e escareados.',
    descricaoCompleta: 'G82 é igual ao G81 mas com pausa P no fundo. Melhora o acabamento e limpa o fundo do furo. Muito usado para rebaixos.',
    sintaxe: 'G82 X[pos] Y[pos] Z[prof] R[plano] P[pausa] F[av]',
    parametros: [{ letra: 'P', descricao: 'Pausa ms (P500 = 0.5s)' }, { letra: 'F', descricao: 'Avanço' }],
    exemplo: 'G82 X15. Y20. Z-10. R2. P500 F80\nG80',
    explicacaoExemplo: 'Fura, pausa 0.5s limpando fundo do rebaixo.', isG: true},

  {codigo: 'G83', nome: 'Furação Profunda (Peck Drilling)', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Furação profunda com retração total a cada passo — evacua cavaco.',
    descricaoCompleta: 'G83 sai completamente do furo a cada passo Q para evacuação total do cavaco. Obrigatório para furos profundos (L/D > 5).',
    sintaxe: 'G83 X[pos] Y[pos] Z[prof] R[plano] Q[passo] F[av]',
    parametros: [{ letra: 'Q', descricao: 'Passo de perfuração' }, { letra: 'F', descricao: 'Avanço' }],
    exemplo: 'G83 X25. Y25. Z-50. R2. Q8. F60\nG80',
    explicacaoExemplo: 'Furo 50mm: desce 8mm, retrai totalmente, repete.', isG: true},

  {codigo: 'G84', nome: 'Rosqueamento Direito (Tapping)', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Rosqueamento automático com macho direito. F = passo × RPM — CRÍTICO.',
    descricaoCompleta: 'G84 executa rosqueamento horário. Inverte automaticamente para retrair. F = passo × RPM. Use M49 para travar override.',
    sintaxe: 'G84 X[pos] Y[pos] Z[prof] R[plano] F[av]',
    parametros: [{ letra: 'F', descricao: 'CRÍTICO: F = passo × RPM (ex: M10×1.5 a 300RPM → F=450)' }],
    exemplo: 'M49\nS300 M03\nG84 X20. Y15. Z-20. R5. F450\nG80\nM48',
    explicacaoExemplo: 'M10×1.5 a 300RPM: F=300×1.5=450mm/min.', isG: true},

  {codigo: 'G85', nome: 'Mandrilamento (entrada e saída com avanço)', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Mandrila descendo e sobe também com avanço F.',
    descricaoCompleta: 'G85 entra e sai com mesmo avanço F. Acabamento em ambas as direções.',
    sintaxe: 'G85 X[pos] Y[pos] Z[prof] R[plano] F[av]',
    parametros: [{ letra: 'F', descricao: 'Avanço entrada e saída' }],
    exemplo: 'G85 X30. Y20. Z-20. R2. F60\nG80',
    explicacaoExemplo: 'Mandrila e retrai com F60 nos dois sentidos.', isG: true},

  {codigo: 'G86', nome: 'Mandrilamento (para spindle ao subir)', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Mandrila, para o spindle e retrai rapidamente.',
    descricaoCompleta: 'G86 mandrila até Z, para spindle (M05) e retrai em G00.',
    sintaxe: 'G86 X[pos] Y[pos] Z[prof] R[plano] F[av]',
    parametros: [{ letra: 'F', descricao: 'Avanço' }],
    exemplo: 'G86 X40. Y20. Z-15. R2. F50\nG80',
    explicacaoExemplo: 'Mandrila, para spindle e retrai.', isG: true},

  {codigo: 'G89', nome: 'Mandrilamento com Pausa', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Mandrila com pausa no fundo e retração com avanço.',
    descricaoCompleta: 'G89 combina G85 com pausa P no fundo para melhor acabamento.',
    sintaxe: 'G89 X[pos] Y[pos] Z[prof] R[plano] P[pausa] F[av]',
    parametros: [{ letra: 'P', descricao: 'Pausa ms' }, { letra: 'F', descricao: 'Avanço' }],
    exemplo: 'G89 X30. Y20. Z-20. R2. P300 F50\nG80',
    explicacaoExemplo: 'Mandrila, pausa 300ms e retrai com avanço.', isG: true},

  {codigo: 'G98', nome: 'Retorno ao Plano Inicial (ciclos)', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Após cada furo, retorna ao plano inicial. Mais seguro.',
    descricaoCompleta: 'G98 faz Z retornar ao plano onde estava antes do ciclo. Mais seguro quando há obstáculos entre furos.',
    sintaxe: 'G98\nG81 X[pos] Z[prof] R[plano] F[av]',
    parametros: [],
    exemplo: 'G98\nG81 X10. Z-15. R2. F100\nX50.\nG80',
    explicacaoExemplo: 'Seguro para furos com obstáculos entre eles.', isG: true},

  {codigo: 'G99', nome: 'Retorno ao Plano R (ciclos)', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Após cada furo, retorna apenas ao plano R. Mais rápido.',
    descricaoCompleta: 'G99 faz Z retornar apenas ao plano R entre furos. Mais rápido para furos próximos sem obstáculos.',
    sintaxe: 'G99\nG81 X[pos] Z[prof] R[plano] F[av]',
    parametros: [],
    exemplo: 'G99\nG81 X10. Z-15. R2. F100\nX20.\nG80',
    explicacaoExemplo: 'Mais rápido entre furos próximos sem obstáculos.', isG: true},

  
  {codigo: 'G28', nome: 'Retorno ao Zero Máquina', categoria: 'Referência', maquina: 'Ambos',
    descricao: 'Retorna eixos ao zero da máquina via ponto intermediário.',
    descricaoCompleta: 'G28 envia eixos ao ponto de referência (home) passando por ponto intermediário. Sempre Z primeiro.',
    sintaxe: 'G28 Z0\nG28 X0 Y0',
    parametros: [],
    exemplo: 'G28 Z0\nG28 X0 Y0',
    explicacaoExemplo: 'Z primeiro para evitar colisão com a peça.', isG: true},

  {codigo: 'G30', nome: 'Retorno ao 2º Ponto de Referência', categoria: 'Referência', maquina: 'Torno CNC',
    descricao: 'Vai ao segundo ponto de referência — posição de troca no torno.',
    descricaoCompleta: 'G30 vai ao segundo ponto de referência. Usado em tornos para posição de troca de ferramenta.',
    sintaxe: 'G30 Z0', parametros: [],
    exemplo: 'G30 Z0\nT0202',
    explicacaoExemplo: 'Posição de troca e seleciona T2.', isG: true},

  {codigo: 'G52', nome: 'Sistema de Coordenadas Local', categoria: 'Zero-Peça', maquina: 'Centro de Usinagem',
    descricao: 'Cria offset temporário de coordenadas dentro do programa.',
    descricaoCompleta: 'G52 define zero temporário deslocado do atual. Útil para features repetitivas em posições diferentes.',
    sintaxe: 'G52 X[off] Y[off] Z[off]',
    parametros: [{ letra: 'X/Y/Z', descricao: 'Deslocamento do novo zero temporário' }],
    exemplo: 'G52 X50. Y30.\nG81 X0 Y0 Z-10. R2. F100\nG52 X0 Y0',
    explicacaoExemplo: 'Move zero para X50,Y30, faz operação e restaura.', isG: true},

  {codigo: 'G53', nome: 'Coordenadas da Máquina', categoria: 'Zero-Peça', maquina: 'Ambos',
    descricao: 'Move em coordenadas absolutas da máquina ignorando offsets.',
    descricaoCompleta: 'G53 usa coordenadas absolutas da máquina. Não modal — válido apenas no bloco programado.',
    sintaxe: 'G53 G00 Z[val]', parametros: [],
    exemplo: 'G53 G00 Z0',
    explicacaoExemplo: 'Vai ao Z zero absoluto ignorando G54-G59.', isG: true},

  {codigo: 'G54', nome: 'Zero-Peça 1', categoria: 'Zero-Peça', maquina: 'Ambos',
    descricao: 'Ativa o primeiro sistema de coordenadas de trabalho. O mais usado.',
    descricaoCompleta: 'G54 é o zero-peça mais usado. Armazena a posição do zero da peça configurada no setup.',
    sintaxe: 'G54', parametros: [],
    exemplo: 'G54\nG00 X0 Y0 Z5.',
    explicacaoExemplo: 'Ativa zero-peça 1 e vai à origem.', isG: true},

  {codigo: 'G55', nome: 'Zero-Peça 2', categoria: 'Zero-Peça', maquina: 'Ambos',
    descricao: 'Segundo sistema de coordenadas — segunda fixação ou peça.',
    descricaoCompleta: 'G55 para segunda fixação. Cada G5x tem seus próprios offsets X,Y,Z.',
    sintaxe: 'G55', parametros: [],
    exemplo: 'G54  ; Peça 1\nG55  ; Peça 2\nG00 X0 Y0',
    explicacaoExemplo: 'Troca para segunda fixação sem alterar programa.', isG: true},

  {codigo: 'G56', nome: 'Zero-Peça 3', categoria: 'Zero-Peça', maquina: 'Ambos',
    descricao: 'Terceiro sistema de coordenadas.', descricaoCompleta: 'Terceiro offset de zero-peça.',
    sintaxe: 'G56', parametros: [], exemplo: 'G56\nG00 X0 Y0', explicacaoExemplo: 'Terceira fixação.', isG: true},

  {codigo: 'G57', nome: 'Zero-Peça 4', categoria: 'Zero-Peça', maquina: 'Ambos',
    descricao: 'Quarto sistema de coordenadas.', descricaoCompleta: 'Quarto offset.',
    sintaxe: 'G57', parametros: [], exemplo: 'G57\nG00 X0 Y0', explicacaoExemplo: 'Quarta fixação.', isG: true},

  {codigo: 'G58', nome: 'Zero-Peça 5', categoria: 'Zero-Peça', maquina: 'Ambos',
    descricao: 'Quinto sistema de coordenadas.', descricaoCompleta: 'Quinto offset.',
    sintaxe: 'G58', parametros: [], exemplo: 'G58\nG00 X0 Y0', explicacaoExemplo: 'Quinta fixação.', isG: true},

  {codigo: 'G59', nome: 'Zero-Peça 6', categoria: 'Zero-Peça', maquina: 'Ambos',
    descricao: 'Sexto sistema de coordenadas padrão.', descricaoCompleta: 'Sexto offset. Para mais: G54.1 P1-P48.',
    sintaxe: 'G59', parametros: [], exemplo: 'G59\nG00 X0 Y0', explicacaoExemplo: 'Sexta fixação.', isG: true},

  {codigo: 'G54.1', nome: 'Zero-Peça Estendido P1-P48', categoria: 'Zero-Peça', maquina: 'Centro de Usinagem',
    descricao: 'Até 48 zeros-peça adicionais. Ideal para paletes e automação.',
    descricaoCompleta: 'G54.1 P1-P48 permite até 48 sistemas adicionais. Para linhas automáticas e paletes.',
    sintaxe: 'G54.1 P[1-48]',
    parametros: [{ letra: 'P', descricao: 'Número do zero-peça adicional (1-48)' }],
    exemplo: 'G54.1 P1\nG54.1 P10',
    explicacaoExemplo: 'Zeros-peça extras para linha automática.', isG: true},

  
  {codigo: 'G90', nome: 'Programação Absoluta', categoria: 'Programação', maquina: 'Ambos',
    descricao: 'Coordenadas medidas do zero-peça. Modo padrão e mais usado.',
    descricaoCompleta: 'No G90, cada coordenada é medida do zero-peça. X50 = ir para 50mm do zero.',
    sintaxe: 'G90', parametros: [],
    exemplo: 'G90\nG00 X50. Y30.',
    explicacaoExemplo: 'X50 = 50mm do zero, independente de onde está.', isG: true},

  {codigo: 'G91', nome: 'Programação Incremental', categoria: 'Programação', maquina: 'Ambos',
    descricao: 'Coordenadas relativas à posição atual da ferramenta.',
    descricaoCompleta: 'No G91, cada coordenada é deslocamento da posição atual. Útil para padrões repetitivos.',
    sintaxe: 'G91', parametros: [],
    exemplo: 'G91\nG01 X10. F200\nG01 X10.',
    explicacaoExemplo: 'Anda 10mm, depois mais 10mm.', isG: true},

  {codigo: 'G92', nome: 'Define Coordenada / Limita RPM Torno', categoria: 'Programação', maquina: 'Ambos',
    descricao: 'Redefine coordenadas sem mover ou limita RPM máximo no torno com G96.',
    descricaoCompleta: 'G92: (1) Redefine coordenadas sem mover. (2) No torno com G96, G92 S[RPM] limita RPM máximo.',
    sintaxe: 'G92 X[val] Z[val]  ; Redefine\nG92 S[RPM]          ; Limita RPM (torno)',
    parametros: [{ letra: 'S', descricao: 'RPM máximo com G96 ativo no torno' }],
    exemplo: 'G96 S200\nG92 S3000  ; Nunca passa de 3000 RPM',
    explicacaoExemplo: 'Protege spindle de velocidade excessiva em diâmetros pequenos.', isG: true},

  
  {codigo: 'G93', nome: 'Avanço por Tempo Inverso (5 eixos)', categoria: 'Avanço', maquina: 'Centro de Usinagem',
    descricao: 'F = movimentos completos por minuto. Usado em usinagem de 5 eixos.',
    descricaoCompleta: 'G93 define avanço como número de movimentos completos por minuto. Necessário em 5 eixos para manter velocidade constante quando o comprimento do vetor varia.',
    sintaxe: 'G93 G01 X[val] F[n]',
    parametros: [{ letra: 'F', descricao: 'Movimentos por minuto — quanto maior F, mais rápido' }],
    exemplo: 'G93 G01 X100. Y50. Z-10. A30. F10\n; F10 = 10 movimentos completos/min',
    explicacaoExemplo: 'Essencial em 5 eixos para velocidade de corte constante.', isG: true},

  {codigo: 'G94', nome: 'Avanço por Minuto (mm/min)', categoria: 'Avanço', maquina: 'Ambos',
    descricao: 'F em milímetros por minuto. Padrão para fresamento.',
    descricaoCompleta: 'G94 é o modo padrão para centros de usinagem. F = mm/min diretamente.',
    sintaxe: 'G94', parametros: [],
    exemplo: 'G94\nG01 X50. F200',
    explicacaoExemplo: '200mm por minuto — padrão de fresamento.', isG: true},

  {codigo: 'G95', nome: 'Avanço por Rotação (mm/rot)', categoria: 'Avanço', maquina: 'Torno CNC',
    descricao: 'F em milímetros por rotação. Padrão para torneamento.',
    descricaoCompleta: 'G95 define F como mm por rotação. Garante avanço proporcional ao RPM — se RPM muda, avanço em mm/min muda mas mm/rot é constante.',
    sintaxe: 'G95', parametros: [],
    exemplo: 'G95\nG01 Z-50. F0.2',
    explicacaoExemplo: '0.2mm a cada rotação — padrão torneamento.', isG: true},

  {codigo: 'G96', nome: 'Velocidade de Corte Constante CSS', categoria: 'Velocidade', maquina: 'Torno CNC',
    descricao: 'Mantém Vc constante variando RPM automaticamente. Essencial no torno.',
    descricaoCompleta: 'G96 varia RPM para manter S (m/min) constante enquanto diâmetro muda. Garante acabamento uniforme do centro à borda.',
    sintaxe: 'G96 S[m/min]',
    parametros: [{ letra: 'S', descricao: 'Velocidade de corte em m/min' }],
    exemplo: 'G96 S200\nG92 S3000\nG01 X0 F0.15',
    explicacaoExemplo: 'Mantém 200m/min — RPM sobe quando diâmetro reduz.', isG: true},

  {codigo: 'G97', nome: 'RPM Constante — cancela G96', categoria: 'Velocidade', maquina: 'Ambos',
    descricao: 'S em RPM fixo. Padrão para fresamento. OBRIGATÓRIO em rosqueamento.',
    descricaoCompleta: 'G97 cancela G96 e define RPM fixo. S = RPM diretamente. Sempre usar em rosqueamento.',
    sintaxe: 'G97 S[RPM]',
    parametros: [{ letra: 'S', descricao: 'RPM desejado' }],
    exemplo: 'G97 S1500\nG01 X50. F200',
    explicacaoExemplo: 'Fixa 1500 RPM — padrão fresamento e rosqueamento.', isG: true},

  
  {codigo: 'G32', nome: 'Rosca Direta — Passe Único (Torno)', categoria: 'Ciclos Torno', maquina: 'Torno CNC',
    descricao: 'Executa um único passe de rosca. Sem retorno automático — posicionamento manual.',
    descricaoCompleta: 'G32 realiza um único passe de rosca. Diferente do G92 (retorno automático) e G76 (multiciclo): o programador controla cada movimento manualmente. F = passo da rosca. RPM FIXO obrigatório (G97). Mais trabalhoso, mas permite roscas cônicas, multi-lead e passo variável.',
    sintaxe: 'G32 X[diâm] Z[compr] F[passo]',
    parametros: [{ letra: 'X', descricao: 'Diâmetro do passe' }, { letra: 'Z', descricao: 'Comprimento da rosca' }, { letra: 'F', descricao: 'Passo da rosca em mm — IGUAL ao passo físico' }],
    exemplo: 'G97 S400 M03  ; RPM fixo obrigatório\nG00 X19.4\nG32 Z-40. F2.5  ; Passe 1\nG00 X25. Z5.    ; Retira e volta\nX18.9\nG32 Z-40. F2.5  ; Passe 2\nG00 X25. Z5.\nX16.93\nG32 Z-40. F2.5  ; Passe final\nG00 X25.',
    explicacaoExemplo: 'G32 faz só o corte — G00 cuida do recuo e reposicionamento manualmente. Para rosca M20×2.5.',
    dicaProfissional: 'Prefira G92 (retorno auto) ou G76 (multiciclo completo). Use G32 quando precisar de trajetória customizada: rosca cônica (X e Z simultâneos), rosca multi-lead (offset Z entre leads) ou passo variável — impossíveis com G76.',
    isG: true},

  {codigo: 'G70', nome: 'Ciclo de Acabamento — Torno Fanuc', categoria: 'Ciclos Torno', maquina: 'Torno CNC',
    descricao: 'Executa passe de acabamento após desbaste com G71/G72/G73.',
    descricaoCompleta: 'G70 faz o passe fino seguindo o perfil definido entre P e Q. Usar sempre após G71 ou G72 com pastilha de acabamento.',
    sintaxe: 'G70 P[início] Q[fim]',
    parametros: [{ letra: 'P', descricao: 'Bloco inicial do perfil' }, { letra: 'Q', descricao: 'Bloco final do perfil' }],
    exemplo: 'G71 U2. R0.5\nG71 P10 Q20 U0.4 W0.1 F0.3\n...\nG70 P10 Q20',
    explicacaoExemplo: 'G71 faz desbaste, G70 faz acabamento no mesmo perfil com outra pastilha.', isG: true},

  {codigo: 'G71', nome: 'Desbaste Longitudinal — Torno Fanuc', categoria: 'Ciclos Torno', maquina: 'Torno CNC',
    descricao: 'Desbaste automático paralelo ao eixo Z. O ciclo mais usado em torneamento.',
    descricaoCompleta: 'G71 executa passes de desbaste paralelos ao Z automaticamente, seguindo o perfil entre P e Q. Fundamental para torneamento Fanuc.',
    sintaxe: 'G71 U[ap] R[recuo]\nG71 P[ini] Q[fim] U[sobr X] W[sobr Z] F[av]',
    parametros: [{ letra: 'U', descricao: 'Profundidade por passe ap' }, { letra: 'R', descricao: 'Recuo entre passes' }, { letra: 'P/Q', descricao: 'Blocos do perfil' }, { letra: 'U sobr.', descricao: 'Sobremetal em X para G70' }, { letra: 'W', descricao: 'Sobremetal em Z' }],
    exemplo: 'G71 U2. R0.5\nG71 P100 Q200 U0.4 W0.1 F0.25\nN100 G00 X22.\nG01 Z-30.\nN200 X62.',
    explicacaoExemplo: 'Desbaste em passes de 2mm, deixa 0.4mm para G70.', isG: true},

  {codigo: 'G72', nome: 'Desbaste Transversal — Torno Fanuc', categoria: 'Ciclos Torno', maquina: 'Torno CNC',
    descricao: 'Desbaste automático paralelo ao eixo X — faceamento de discos.',
    descricaoCompleta: 'G72 executa passes paralelos ao X. Para faceamento de peças com grande diâmetro e pouca profundidade axial.',
    sintaxe: 'G72 W[ap] R[recuo]\nG72 P[ini] Q[fim] U[sobr] W[sobr] F[av]',
    parametros: [{ letra: 'W', descricao: 'Profundidade axial por passe' }, { letra: 'R', descricao: 'Recuo' }],
    exemplo: 'G72 W1.5 R0.5\nG72 P100 Q200 U0.3 W0.1 F0.20',
    explicacaoExemplo: 'Desbaste transversal para faceamento de disco grande.', isG: true},

  {codigo: 'G73', nome: 'Desbaste por Cópia de Perfil — Torno Fanuc', categoria: 'Ciclos Torno', maquina: 'Torno CNC',
    descricao: 'Desbaste paralelo ao perfil — ideal para fundidos e forjados.',
    descricaoCompleta: 'G73 (torno) executa passes paralelos ao perfil. Ideal para peças pré-formadas onde o sobremetal é uniforme. DIFERENTE do G73 de furação!',
    sintaxe: 'G73 U[deslocX] W[deslocZ] R[passes]\nG73 P[ini] Q[fim] U[sobr] W[sobr] F[av]',
    parametros: [{ letra: 'U', descricao: 'Deslocamento X da 1ª passada' }, { letra: 'W', descricao: 'Deslocamento Z' }, { letra: 'R', descricao: 'Número de passes' }],
    exemplo: 'G73 U10. W5. R5\nG73 P100 Q200 U0.4 W0.1 F0.25',
    explicacaoExemplo: 'Desbaste de fundido: 5 passes copiando o perfil.', isG: true},

  {codigo: 'G75', nome: 'Ciclo de Canal/Ranhura — Torno Fanuc', categoria: 'Ciclos Torno', maquina: 'Torno CNC',
    descricao: 'Ciclo de sangramento e ranhuras no torno. Executa canais automáticos.',
    descricaoCompleta: 'G75 executa ciclo de ranhuras (grooves) no torno. Pode fazer múltiplos canais igualmente espaçados. Muito usado para sangrias, retentores e canais de anel.',
    sintaxe: 'G75 R[recuo]\nG75 X[prof] Z[pos] P[passo X] Q[passo Z] F[av]',
    parametros: [{ letra: 'X', descricao: 'Diâmetro final do canal (profundidade)' }, { letra: 'Z', descricao: 'Posição Z final' }, { letra: 'P', descricao: 'Passo de incremento em X (μm)' }, { letra: 'Q', descricao: 'Espaçamento entre canais em Z (μm)' }, { letra: 'F', descricao: 'Avanço de sangramento' }],
    exemplo: '; CANAL SIMPLES:\nG75 R0.5\nG75 X16. Z-25. P1000 Q0 F0.05\n;\n; MÚLTIPLOS CANAIS:\nG75 R0.5\nG75 X16. Z-35. P1000 Q5000 F0.05\n; Q5000 = 5mm entre canais',
    explicacaoExemplo: 'Canal único em X=16mm (prof.) em Z=-25mm. Para múltiplos: Q define espaçamento em μm.', isG: true},

  {codigo: 'G76', nome: 'Ciclo Automático de Rosca — Torno Fanuc', categoria: 'Ciclos Torno', maquina: 'Torno CNC',
    descricao: 'Ciclo completo de rosca com passes automáticos. Mais prático que G92.',
    descricaoCompleta: 'G76 executa todos os passes de rosca automaticamente. Dois blocos definem o ciclo completo. Mais prático que G92 mas com menos controle por passe.',
    sintaxe: 'G76 P[m][r][a] Q[prof min] R[sobr]\nG76 X[diâm final] Z[compr] P[altura filete] Q[1º passe] F[passo]',
    parametros: [{ letra: 'P', descricao: '1º bloco: m=passes limpeza, r=chanfro, a=ângulo (60°=60)' }, { letra: 'X', descricao: 'Diâmetro final da rosca' }, { letra: 'Z', descricao: 'Comprimento' }, { letra: 'P 2ºbloco', descricao: 'Altura total do filete em μm' }, { letra: 'Q', descricao: '1º passe de profundidade em μm' }, { letra: 'F', descricao: 'Passo da rosca em mm' }],
    exemplo: '; ROSCA M20×2.5\nG76 P021060 Q100 R0.1\nG76 X16.93 Z-40. P1534 Q300 F2.5\n;\n; P021060: 2 passes limpeza, chanfro r, ângulo 60°\n; P1534: altura filete M20×2.5 = 1534μm\n; Q300: 1º passe = 0.3mm',
    explicacaoExemplo: 'Ciclo completo rosca M20×2.5 — todos os passes automáticos!', isG: true},

  {codigo: 'G92', nome: 'Ciclo de Rosca Passe a Passe — Torno', categoria: 'Ciclos Torno', maquina: 'Torno CNC',
    descricao: 'Rosqueamento no torno — cada bloco = um passe. F = passo da rosca.',
    descricaoCompleta: 'G92 executa um passe de rosca por bloco. F é o passo da rosca. RPM FIXO obrigatório (G97). Passes progressivos do maior para menor diâmetro.',
    sintaxe: 'G92 X[diâm] Z[compr] F[passo]',
    parametros: [{ letra: 'X', descricao: 'Diâmetro do passe' }, { letra: 'Z', descricao: 'Comprimento da rosca' }, { letra: 'F', descricao: 'IGUAL AO PASSO da rosca em mm' }],
    exemplo: 'G97 S400 M03  ; RPM FIXO!\nG92 X19.4 Z-40. F2.5\nG92 X18.9 Z-40. F2.5\nG92 X16.93 Z-40. F2.5  ; Final\nG92 X16.93 Z-40. F2.5  ; Limpeza',
    explicacaoExemplo: 'Passes progressivos de rosca — do maior para menor diâmetro.', isG: true},

  
  {codigo: 'G68', nome: 'Rotação de Coordenadas', categoria: 'Transformação', maquina: 'Centro de Usinagem',
    descricao: 'Rotaciona o sistema de coordenadas em torno de um ponto.',
    descricaoCompleta: 'G68 rotaciona o sistema em torno de X,Y pelo ângulo R. Para features anguladas sem recalcular coordenadas.',
    sintaxe: 'G68 X[cx] Y[cy] R[ângulo]',
    parametros: [{ letra: 'X/Y', descricao: 'Centro de rotação' }, { letra: 'R', descricao: 'Ângulo graus (positivo=anti-horário)' }],
    exemplo: 'G68 X0 Y0 R45.\nG01 X50. F200\nG69',
    explicacaoExemplo: 'Rotaciona 45° para usinar feature angulada.', isG: true},

  {codigo: 'G69', nome: 'Cancela Rotação', categoria: 'Transformação', maquina: 'Centro de Usinagem',
    descricao: 'Cancela G68 e retorna ao sistema original.',
    descricaoCompleta: 'G69 cancela rotação de coordenadas ativada pelo G68.',
    sintaxe: 'G69', parametros: [],
    exemplo: 'G68 X0 Y0 R30.\n; operações\nG69',
    explicacaoExemplo: 'Retorna ao sistema original após feature angulada.', isG: true},

  {codigo: 'G51', nome: 'Escala (Scaling)', categoria: 'Transformação', maquina: 'Centro de Usinagem',
    descricao: 'Aplica fator de escala ao programa.',
    descricaoCompleta: 'G51 amplia ou reduz coordenadas pelo fator P. P2000 = fator 2.0 (dobra tudo).',
    sintaxe: 'G51 X[cx] Y[cy] P[fator]',
    parametros: [{ letra: 'P', descricao: 'Fator × 1000 (P2000=2.0, P500=0.5)' }],
    exemplo: 'G51 X0 Y0 P2000\nG01 X10. F200\nG50',
    explicacaoExemplo: 'P2000 = dobra todas as coordenadas.', isG: true},

  {codigo: 'G50', nome: 'Cancela Escala / Limita RPM', categoria: 'Transformação', maquina: 'Ambos',
    descricao: 'Cancela G51 ou define RPM máximo no torno com G96.',
    descricaoCompleta: 'G50: (1) Cancela escalonamento G51. (2) No torno com G96, G50 S[RPM] limita RPM máximo.',
    sintaxe: 'G50\nG50 S[RPM]  ; Limita RPM (torno)',
    parametros: [{ letra: 'S', descricao: 'RPM máximo (só torno com G96)' }],
    exemplo: 'G96 S200\nG50 S3000',
    explicacaoExemplo: 'Protege spindle de RPM excessivo em diâmetros pequenos.', isG: true},

  {codigo: 'G51.1', nome: 'Espelhamento (Mirror Image)', categoria: 'Transformação', maquina: 'Centro de Usinagem',
    descricao: 'Espelha o programa em torno de um eixo — para peças simétricas.',
    descricaoCompleta: 'G51.1 ativa espelhamento. Permite usinar peças simétricas sem reprogramar. Cancela com G50.1.',
    sintaxe: 'G51.1 X[val]  ; Espelha em X\nG51.1 Y[val]  ; Espelha em Y',
    parametros: [{ letra: 'X', descricao: 'Posição do eixo espelho em X' }, { letra: 'Y', descricao: 'Posição do eixo espelho em Y' }],
    exemplo: 'G51.1 X0\nG01 X-30. F200\nG50.1 X0',
    explicacaoExemplo: 'Espelha para usinar lado simétrico sem reprogramar.', isG: true},

  {codigo: 'G50.1', nome: 'Cancela Espelhamento', categoria: 'Transformação', maquina: 'Centro de Usinagem',
    descricao: 'Cancela G51.1 e restaura sistema original.',
    descricaoCompleta: 'G50.1 desativa o espelhamento do G51.1.',
    sintaxe: 'G50.1 X0', parametros: [],
    exemplo: 'G51.1 X0\n; operações\nG50.1 X0',
    explicacaoExemplo: 'Cancela espelhamento após operação simétrica.', isG: true},

  
  {codigo: 'G65', nome: 'Chamada de Macro (Custom Macro)', categoria: 'Macro', maquina: 'Ambos',
    descricao: 'Chama programa macro com passagem de parâmetros. Programação paramétrica.',
    descricaoCompleta: 'G65 chama macro O[número] passando argumentos A-Z que viram variáveis #1-#26. Permite loops, condicionais e cálculos dentro do CNC.',
    sintaxe: 'G65 P[prog] A[val] B[val] ... Z[val]',
    parametros: [{ letra: 'P', descricao: 'Número do programa macro' }, { letra: 'A-Z', descricao: 'Argumentos → variáveis #1-#26' }],
    exemplo: 'G65 P9001 A20. B25. C4. I3. D15.',
    explicacaoExemplo: 'Chama O9001 com parâmetros para operação parametrizada.', isG: true},
];
export const codigosM: CodigoItem[] = [
  {codigo: 'M00', nome: 'Parada de Programa', categoria: 'Controle', maquina: 'Ambos',
    descricao: 'Para o programa e aguarda CYCLE START. Spindle e fluido param.',
    descricaoCompleta: 'M00 interrompe completamente o programa. Operador pode medir, verificar, limpar. Continua ao pressionar CYCLE START.',
    sintaxe: 'M00', parametros: [],
    exemplo: 'G01 Z-5. F100\nM00\nG01 Z-10.',
    explicacaoExemplo: 'Para para verificação entre operações.', isG: false},

  {codigo: 'M01', nome: 'Parada Opcional', categoria: 'Controle', maquina: 'Ambos',
    descricao: 'Para apenas se a chave Optional Stop estiver ligada no painel.',
    descricaoCompleta: 'M01 é condicional à chave do painel. Em setup: para. Em produção série: ignora automaticamente.',
    sintaxe: 'M01', parametros: [],
    exemplo: 'G01 X50. F200\nM01',
    explicacaoExemplo: 'Flexível — controla pelo painel se para ou não.', isG: false},

  {codigo: 'M02', nome: 'Fim de Programa', categoria: 'Controle', maquina: 'Ambos',
    descricao: 'Encerra o programa. Geralmente não rebobina o cursor.',
    descricaoCompleta: 'M02 encerra o programa. Diferente do M30, geralmente não volta o cursor ao início.',
    sintaxe: 'M02', parametros: [],
    exemplo: 'G28 Z0\nM05\nM02',
    explicacaoExemplo: 'Menos usado que M30 — não rebobina.', isG: false},

  {codigo: 'M03', nome: 'Liga Spindle Horário (CW)', categoria: 'Spindle', maquina: 'Ambos',
    descricao: 'Liga spindle sentido horário. Padrão para fresas e brocas.',
    descricaoCompleta: 'M03 liga spindle CW. Sentido padrão para fresas, brocas e maioria das ferramentas. Sempre programar S antes do M03 ou no mesmo bloco.',
    sintaxe: 'S[RPM] M03',
    parametros: [{ letra: 'S', descricao: 'Rotação em RPM' }],
    exemplo: 'S2000 M03\nG01 Z-3. F200',
    explicacaoExemplo: 'Liga 2000 RPM horário e inicia corte.',
    dicaProfissional: 'Sempre programe S e M03 no mesmo bloco ou S antes. Aguarde alguns segundos após M03 antes do primeiro corte para o spindle atingir a velocidade nominal — especialmente importante em altas rotações (acima de 10.000 RPM).',
    diagramaTipo: 'spindle_cw',
    isG: false},

  {codigo: 'M04', nome: 'Liga Spindle Anti-horário (CCW)', categoria: 'Spindle', maquina: 'Ambos',
    descricao: 'Liga spindle sentido anti-horário.',
    descricaoCompleta: 'M04 liga spindle CCW. Para rosca esquerda, rosqueamento reverso e ferramentas especiais.',
    sintaxe: 'S[RPM] M04',
    parametros: [{ letra: 'S', descricao: 'RPM' }],
    exemplo: 'S800 M04',
    explicacaoExemplo: 'Liga anti-horário para ferramenta especial.',
    dicaProfissional: 'M04 é usado para: rosca esquerda (M84 anti-horária), machos com reversão interna, e ferramentas de torneamento com pastilhas configuradas para CCW. Confirme no catálogo da ferramenta qual sentido é correto.',
    diagramaTipo: 'spindle_ccw',
    isG: false},

  {codigo: 'M05', nome: 'Para Spindle', categoria: 'Spindle', maquina: 'Ambos',
    descricao: 'Para a rotação do spindle completamente.',
    descricaoCompleta: 'M05 para o spindle. Aguarda parada completa antes do próximo bloco. Usar antes de M06.',
    sintaxe: 'M05', parametros: [],
    exemplo: 'G00 Z50.\nM05\nM06 T02',
    explicacaoExemplo: 'Para spindle antes da troca de ferramenta.',
    dicaProfissional: 'Em muitas máquinas, M06 já inclui M05 automaticamente. Mas é boa prática programar M05 explicitamente antes de M06 para garantir parada completa. O tempo de parada depende da inércia do spindle — spindles de alta rotação demoram mais.',
    isG: false},

  {codigo: 'M06', nome: 'Troca Automática de Ferramenta (ATC)', categoria: 'Ferramenta', maquina: 'Centro de Usinagem',
    descricao: 'Executa troca automática de ferramenta. Sempre retorne ao zero antes.',
    descricaoCompleta: 'M06 aciona o ATC. Sempre retorne ao ponto seguro (G28 Z0) e pare o spindle (M05) antes. É boa prática pré-selecionar a próxima ferramenta (T) com antecedência para reduzir tempo de ciclo.',
    sintaxe: 'T[n] M06',
    parametros: [{ letra: 'T', descricao: 'Número da ferramenta (T01-T60+)' }],
    exemplo: 'G28 Z0\nT02 M06\nS2000 M03\nG43 H02 Z100.',
    explicacaoExemplo: 'Troca T2, liga spindle e ativa compensação H02.',
    dicaProfissional: 'Para reduzir tempo de ciclo: pré-selecione a PRÓXIMA ferramenta no final de cada operação. Exemplo: ao terminar com T01, programe T02 antes do G28. Assim o carrossel já posiciona T02 enquanto a máquina ainda está usinando com T01.',
    diagramaTipo: 'troca_ferramenta',
    isG: false},

  {codigo: 'M07', nome: 'Liga Refrigeração de Névoa', categoria: 'Refrigeração', maquina: 'Ambos',
    descricao: 'Liga sistema de névoa (mist coolant). Para alumínio e plásticos.',
    descricaoCompleta: 'M07 ativa névoa (ar + fluido). Menos fluido que M08.',
    sintaxe: 'M07', parametros: [],
    exemplo: 'S2000 M03\nM07',
    explicacaoExemplo: 'Névoa para fresamento de alumínio.',
    dicaProfissional: 'Névoa (M07) é ideal para alumínio, plástico e materiais que não devem molhar (ex: grafite). Gera vapor — use EPI (máscara) e ventilação. Para aço e inox prefira sempre M08 (flood) — a névoa não resfria suficientemente em cortes pesados.',
    isG: false},

  {codigo: 'M08', nome: 'Liga Refrigeração Flood', categoria: 'Refrigeração', maquina: 'Ambos',
    descricao: 'Liga fluido de corte abundante. Obrigatório para aço e inox.',
    descricaoCompleta: 'M08 ativa flood coolant. Resfria ferramenta e peça, remove cavaco. Obrigatório para aço, inox e materiais difíceis.',
    sintaxe: 'M08', parametros: [],
    exemplo: 'S1500 M03\nM08',
    explicacaoExemplo: 'Liga fluido antes de cortar aço.',
    dicaProfissional: 'Ligue M08 ANTES de iniciar o corte, não durante. Temperatura súbita em ferramenta quente pode gerar micro-trincas. Verifique concentração do fluido semanalmente (ideal 6-8% em refratômetro) — fluido fraco não refrigera e prolifera bactérias.',
    diagramaTipo: 'refrigeracao',
    isG: false},

  {codigo: 'M09', nome: 'Desliga Refrigeração', categoria: 'Refrigeração', maquina: 'Ambos',
    descricao: 'Desliga todos os sistemas de refrigeração (M07 e M08).',
    descricaoCompleta: 'M09 para toda refrigeração.',
    sintaxe: 'M09', parametros: [],
    exemplo: 'G00 Z50.\nM09\nM05\nM30',
    explicacaoExemplo: 'Sequência de finalização profissional.', isG: false},

  {codigo: 'M10', nome: 'Fecha Chuck (Torno)', categoria: 'Torno', maquina: 'Torno CNC',
    descricao: 'Fecha e trava o mandril do torno hidraulicamente.',
    descricaoCompleta: 'M10 aciona o sistema hidráulico para fechar e travar o mandril. Para automação com alimentador de barras.',
    sintaxe: 'M10', parametros: [],
    exemplo: 'M10\nS1000 M03',
    explicacaoExemplo: 'Fecha mandril antes de tornear.', isG: false},

  {codigo: 'M11', nome: 'Abre Chuck (Torno)', categoria: 'Torno', maquina: 'Torno CNC',
    descricao: 'Abre o mandril do torno.',
    descricaoCompleta: 'M11 libera o mandril. Para ejetar peça ou alimentação automática.',
    sintaxe: 'M11', parametros: [],
    exemplo: 'M05\nM11',
    explicacaoExemplo: 'Abre mandril após finalizar peça.', isG: false},

  {codigo: 'M12', nome: 'Avança Contra-ponta', categoria: 'Torno', maquina: 'Torno CNC',
    descricao: 'Avança a contra-ponta para apoiar peças longas.',
    descricaoCompleta: 'M12 avança a contra-ponta hidráulica. Para suporte axial em eixos longos.',
    sintaxe: 'M12', parametros: [],
    exemplo: 'M12\nS500 M03',
    explicacaoExemplo: 'Suporte axial antes de tornear eixo longo.', isG: false},

  {codigo: 'M13', nome: 'Recua Contra-ponta', categoria: 'Torno', maquina: 'Torno CNC',
    descricao: 'Recua a contra-ponta para liberar a peça.',
    descricaoCompleta: 'M13 recua a contra-ponta após o torneamento.',
    sintaxe: 'M13', parametros: [],
    exemplo: 'M05\nM13\nM11',
    explicacaoExemplo: 'Libera peça: para spindle, recua contra-ponta, abre chuck.', isG: false},

  {codigo: 'M19', nome: 'Parada Orientada do Spindle', categoria: 'Spindle', maquina: 'Ambos',
    descricao: 'Para o spindle em posição angular específica. Essencial antes do G76.',
    descricaoCompleta: 'M19 para spindle em posição angular pré-definida. Necessário antes de G76 (mandrilamento fino).',
    sintaxe: 'M19', parametros: [],
    exemplo: 'M19\nG76 X30. Y20. Z-15. R2. Q100 F50',
    explicacaoExemplo: 'Orienta spindle antes do mandrilamento fino.', isG: false},

  {codigo: 'M21', nome: 'Espelhamento em X', categoria: 'Espelhamento', maquina: 'Centro de Usinagem',
    descricao: 'Ativa espelhamento no eixo X para peças simétricas.',
    descricaoCompleta: 'M21 inverte todos os movimentos X. Cancela com M23.',
    sintaxe: 'M21', parametros: [],
    exemplo: 'M21\nG01 X-30. F200\nM23',
    explicacaoExemplo: 'Usina lado simétrico em X sem reprogramar.', isG: false},

  {codigo: 'M22', nome: 'Espelhamento em Y', categoria: 'Espelhamento', maquina: 'Centro de Usinagem',
    descricao: 'Ativa espelhamento no eixo Y.',
    descricaoCompleta: 'M22 inverte todos os movimentos Y. Cancela com M24.',
    sintaxe: 'M22', parametros: [],
    exemplo: 'M22\nG01 Y-30. F200\nM24',
    explicacaoExemplo: 'Usina lado simétrico em Y.', isG: false},

  {codigo: 'M23', nome: 'Cancela Espelhamento X', categoria: 'Espelhamento', maquina: 'Centro de Usinagem',
    descricao: 'Desativa espelhamento em X (M21).',
    descricaoCompleta: 'M23 cancela M21.',
    sintaxe: 'M23', parametros: [],
    exemplo: 'M21\nG01 X-50. F200\nM23',
    explicacaoExemplo: 'Cancela espelhamento X.', isG: false},

  {codigo: 'M24', nome: 'Cancela Espelhamento Y', categoria: 'Espelhamento', maquina: 'Centro de Usinagem',
    descricao: 'Desativa espelhamento em Y (M22).',
    descricaoCompleta: 'M24 cancela M22.',
    sintaxe: 'M24', parametros: [],
    exemplo: 'M22\nG01 Y-50. F200\nM24',
    explicacaoExemplo: 'Cancela espelhamento Y.', isG: false},

  {codigo: 'M30', nome: 'Fim e Rebobina Programa', categoria: 'Controle', maquina: 'Ambos',
    descricao: 'Encerra e volta cursor ao início. O código de fim mais usado no mundo.',
    descricaoCompleta: 'M30 encerra, para spindle e refrigeração e reposiciona o cursor no início para a próxima peça.',
    sintaxe: 'M30', parametros: [],
    exemplo: 'G28 Z0\nG28 X0 Y0\nM09\nM05\nM30',
    explicacaoExemplo: 'Sequência profissional — padrão mundial.',
    dicaProfissional: 'A sequência correta antes do M30 é sempre: (1) G28 Z0 — sobe Z. (2) G28 X0 Y0 — retorna X,Y. (3) M09 — desliga fluido. (4) M05 — para spindle. (5) M30. Nunca pule essas etapas em programas de produção.',
    isG: false},

  {codigo: 'M41', nome: 'Gama de Velocidade Baixa', categoria: 'Spindle', maquina: 'Ambos',
    descricao: 'Seleciona gama baixa da caixa de velocidades — alto torque.',
    descricaoCompleta: 'M41 seleciona gama 1 (baixa). Para rosqueamento, furação grande e operações de alto torque.',
    sintaxe: 'M41', parametros: [],
    exemplo: 'M41\nS200 M03',
    explicacaoExemplo: 'Gama baixa para rosqueamento com macho grande.', isG: false},

  {codigo: 'M42', nome: 'Gama de Velocidade Alta', categoria: 'Spindle', maquina: 'Ambos',
    descricao: 'Seleciona gama alta — alta rotação, menor torque.',
    descricaoCompleta: 'M42 seleciona gama 2 (alta). Para acabamento e fresas pequenas em alta rotação.',
    sintaxe: 'M42', parametros: [],
    exemplo: 'M42\nS8000 M03',
    explicacaoExemplo: 'Gama alta para fresa pequena em alta rotação.', isG: false},

  {codigo: 'M48', nome: 'Habilita Override', categoria: 'Controle', maquina: 'Ambos',
    descricao: 'Reativa os botões de override de avanço e spindle do painel.',
    descricaoCompleta: 'M48 habilita os overrides do painel. Usar após M49.',
    sintaxe: 'M48', parametros: [],
    exemplo: 'M49\nG84 Z-20. F450\nG80\nM48',
    explicacaoExemplo: 'Reativa overrides após rosqueamento.', isG: false},

  {codigo: 'M49', nome: 'Desabilita Override', categoria: 'Controle', maquina: 'Ambos',
    descricao: 'Bloqueia overrides. Obrigatório em rosqueamento.',
    descricaoCompleta: 'M49 bloqueia todos os overrides. Para rosqueamento onde parâmetros não podem ser alterados.',
    sintaxe: 'M49', parametros: [],
    exemplo: 'M49\nG84 X20. Z-20. F450\nM48',
    explicacaoExemplo: 'Bloqueia durante rosqueamento — evita quebrar macho.', isG: false},

  {codigo: 'M50', nome: 'Liga Fluido pelo Furo da Ferramenta', categoria: 'Refrigeração', maquina: 'Centro de Usinagem',
    descricao: 'Liga fluido de alta pressão pelo interior da ferramenta.',
    descricaoCompleta: 'M50 ativa fluido pelo centro do spindle e ferramenta. Para furos profundos e materiais difíceis como inox e titânio.',
    sintaxe: 'M50', parametros: [],
    exemplo: 'M50\nG83 X20. Z-60. R2. Q8. F60\nG80\nM51',
    explicacaoExemplo: 'Fluido interno para furo profundo — evacua cavaco do fundo.', isG: false},

  {codigo: 'M51', nome: 'Desliga Fluido pelo Furo', categoria: 'Refrigeração', maquina: 'Centro de Usinagem',
    descricao: 'Desliga fluido de alta pressão pelo interior (M50).',
    descricaoCompleta: 'M51 desativa o fluido através do spindle ativado por M50.',
    sintaxe: 'M51', parametros: [],
    exemplo: 'M50\nG83 X20. Z-60. R2. Q8. F60\nM51',
    explicacaoExemplo: 'Desliga fluido pelo fuso após furação profunda.', isG: false},

  {codigo: 'M60', nome: 'Troca de Palete (APC)', categoria: 'Automação', maquina: 'Centro de Usinagem',
    descricao: 'Executa troca automática de palete para produção contínua.',
    descricaoCompleta: 'M60 aciona o APC. Palete usinado sai e próximo com peça bruta entra. Produção desassistida.',
    sintaxe: 'M60', parametros: [],
    exemplo: 'G28 Z0\nG28 X0 Y0\nM60\nG54',
    explicacaoExemplo: 'Troca palete para produção automática não-stop.', isG: false},

  {codigo: 'M98', nome: 'Chamada de Subprograma', categoria: 'Subprograma', maquina: 'Ambos',
    descricao: 'Chama um subprograma externo pelo número P. L define repetições.',
    descricaoCompleta: 'M98 chama O[número] e executa. L define quantas vezes. Retorna ao próximo bloco após M98.',
    sintaxe: 'M98 P[número] L[repetições]',
    parametros: [{ letra: 'P', descricao: 'Número do subprograma' }, { letra: 'L', descricao: 'Repetições (padrão: 1)' }],
    exemplo: 'M98 P1001\nM98 P1001 L5',
    explicacaoExemplo: 'Chama O1001 uma vez ou repete 5 vezes.', isG: false},

  {codigo: 'M99', nome: 'Fim de Subprograma / Retorno', categoria: 'Subprograma', maquina: 'Ambos',
    descricao: 'Retorna do subprograma ao programa principal.',
    descricaoCompleta: 'M99 marca fim do subprograma e retorna. No programa principal: reinicia do início (loop).',
    sintaxe: 'M99', parametros: [],
    exemplo: '; Sub O1001\nG81 X0 Y0 Z-15. R2. F100\nX20.\nG80\nM99',
    explicacaoExemplo: 'M99 retorna ao programa principal.', isG: false},
];
export const codigosGExtras: CodigoItem[] = [

  {codigo: 'G10', nome: 'Entrada de Dados Programável', categoria: 'Programação', maquina: 'Ambos',
    descricao: 'Define offsets de ferramenta e zero-peça diretamente no programa.',
    descricaoCompleta: 'G10 permite definir ou alterar offsets (H, D) e zero-peças (G54-G59) no programa. Poderoso para automação — elimina ajuste manual.',
    sintaxe: 'G10 L[tipo] P[nº] R[valor]\nG10 L2 P1 X Y Z  ; Zero-peça G54\nG10 L10 P1 R[val] ; Offset H\nG10 L11 P1 R[val] ; Offset D',
    parametros: [
      { letra: 'L', descricao: 'L2=zero-peça, L10=H geométrico, L11=D geométrico, L12=H desgaste, L13=D desgaste' },
      { letra: 'P', descricao: 'Número do offset (1=H1/D1...)' },
      { letra: 'R', descricao: 'Valor a definir' },
    ],
    exemplo: '; Define zero-peça G54:\nG10 L2 P1 X-350. Y-200. Z-100.\n;\n; Define H01 = 125.5mm:\nG10 L10 P1 R125.5\n;\n; Zera desgaste D01:\nG10 L13 P1 R0.0',
    explicacaoExemplo: 'Automação completa de offsets — sem ajuste manual do operador.', isG: true},

  {codigo: 'G12', nome: 'Fresamento Circular Horário', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Ciclo de bolsão circular horário — espiral crescente.',
    descricaoCompleta: 'G12 executa fresamento circular CW em espiral. I define o raio final do bolsão. Disponível em Fanuc e Haas.',
    sintaxe: 'G12 I[raio] F[av]',
    parametros: [{ letra: 'I', descricao: 'Raio final do bolsão' }, { letra: 'F', descricao: 'Avanço' }],
    exemplo: 'G00 X50. Y30. Z5.\nG01 Z-5. F80.\nG12 I10. F150.  ; Bolsão Ø20mm\nG00 Z50.',
    explicacaoExemplo: 'I=10mm → bolsão Ø20mm em espiral horária.', isG: true},

  {codigo: 'G13', nome: 'Fresamento Circular Anti-horário', categoria: 'Ciclos Fixos', maquina: 'Centro de Usinagem',
    descricao: 'Ciclo de bolsão circular anti-horário — espiral CCW.',
    descricaoCompleta: 'G13 é igual ao G12 mas no sentido anti-horário. Para fresamento concordante em bolsões.',
    sintaxe: 'G13 I[raio] F[av]',
    parametros: [{ letra: 'I', descricao: 'Raio do bolsão' }, { letra: 'F', descricao: 'Avanço' }],
    exemplo: 'G00 X0 Y0 Z5.\nG01 Z-8. F80.\nG13 I15. F150.  ; Bolsão Ø30mm\nG00 Z50.',
    explicacaoExemplo: 'I=15mm → bolsão Ø30mm anti-horário.', isG: true},

  {codigo: 'G16', nome: 'Coordenadas Polares', categoria: 'Programação', maquina: 'Centro de Usinagem',
    descricao: 'X = raio, Y = ângulo em graus. Ideal para furos em círculo.',
    descricaoCompleta: 'G16 ativa coordenadas polares. X = raio da posição, Y = ângulo em graus. Muito mais simples para furos em padrão circular do que calcular cos/sin.',
    sintaxe: 'G16  ; Ativa\nG[mov] X[raio] Y[ângulo] ...\nG15  ; Cancela',
    parametros: [{ letra: 'X', descricao: 'Raio' }, { letra: 'Y', descricao: 'Ângulo em graus (CCW)' }],
    exemplo: '; 6 furos em R=40mm:\nG16\nG81 X40. Y0 Z-15. R2. F100   ; 0°\nX40. Y60.   ; 60°\nX40. Y120.  ; 120°\nX40. Y180.  ; 180°\nX40. Y240.  ; 240°\nX40. Y300.  ; 300°\nG80\nG15',
    explicacaoExemplo: 'Muito mais simples que calcular sin/cos para cada furo!', isG: true},

  {codigo: 'G15', nome: 'Cancela Coordenadas Polares', categoria: 'Programação', maquina: 'Centro de Usinagem',
    descricao: 'Retorna ao sistema cartesiano normal após G16.',
    descricaoCompleta: 'G15 cancela o modo de coordenadas polares do G16.',
    sintaxe: 'G15', parametros: [],
    exemplo: 'G16\nG01 X50. Y45. F200.\nG15  ; Volta ao cartesiano',
    explicacaoExemplo: 'Cancela polares — retorna X=mm, Y=mm normais.', isG: true},

  {codigo: 'G31', nome: 'Ciclo de Apalpamento (Skip Function)', categoria: 'Medição', maquina: 'Ambos',
    descricao: 'Move até tocar apalpador e captura posição no contato.',
    descricaoCompleta: 'G31 move o eixo até o apalpador ser ativado. A posição no contato é salva em #5061 (X), #5062 (Y), #5063 (Z). Essencial para medição automática em processo.',
    sintaxe: 'G31 X[val] Y[val] Z[val] F[av]',
    parametros: [{ letra: 'F', descricao: 'Avanço lento para precisão (ex: F50)' }, { letra: '#5061-63', descricao: 'Variáveis com posição no contato X,Y,Z' }],
    exemplo: '; Mede posição Z da superfície:\nG31 Z-50. F50.     ; Move até tocar\n#103 = #5063       ; Captura Z no toque\nG00 Z[#103 + 5.]   ; Sobe 5mm',
    explicacaoExemplo: 'Fundamental para medição automática em processo.', isG: true},

  {codigo: 'G43.4', nome: 'TCP — Tool Center Point (5 eixos)', categoria: 'Fresamento Avançado', maquina: 'Centro de Usinagem',
    descricao: 'Mantém ponto de controle na ponta da ferramenta em 5 eixos.',
    descricaoCompleta: 'G43.4 ativa o TCP para 5 eixos. Compensa automaticamente o comprimento quando eixos A, B ou C giram. Sem TCP, ao girar um eixo rotativo a ponta da ferramenta sai do ponto programado.',
    sintaxe: 'G43.4 H[n]',
    parametros: [{ letra: 'H', descricao: 'Offset de comprimento H da ferramenta' }],
    exemplo: 'G43.4 H01\nG01 X50. Y30. Z-10. A30. B15. F200.\nG49   ; Cancela TCP',
    explicacaoExemplo: 'Essencial em 5 eixos — ponta sempre no ponto correto.', isG: true},
];
export const codigosGFabricantes: CodigoItem[] = [

  
  
  

  {
    codigo: 'CYCLE82', nome: 'Ciclo de Centramento / Furação Simples', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Siemens', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação simples ou centramento com temporização no fundo.',
    descricaoCompleta:
      'CYCLE82 é o ciclo básico de furação do Siemens SINUMERIK. Perfura até a profundidade final com avanço constante e permite uma pausa (dwell) no fundo para melhorar o acabamento. ' +
      'Equivale ao G81 do Fanuc mas com sintaxe de parâmetros por posição. ' +
      'Parâmetros: RTP = plano de retorno, RFP = plano de referência, SDIS = distância de segurança, DP = profundidade final, DPR = profundidade relativa, DTB = tempo de pausa no fundo (segundos).',
    sintaxe: 'CYCLE82(RTP, RFP, SDIS, DP, DPR, DTB)',
    parametros: [
      { letra: 'RTP', descricao: 'Plano de retorno (absoluto, ex: 50.0)' },
      { letra: 'RFP', descricao: 'Plano de referência — superfície da peça (ex: 0.0)' },
      { letra: 'SDIS', descricao: 'Distância de segurança acima do RFP (ex: 3.0)' },
      { letra: 'DP', descricao: 'Profundidade final absoluta (ex: -20.0)' },
      { letra: 'DPR', descricao: 'Profundidade relativa ao RFP (alternativa ao DP)' },
      { letra: 'DTB', descricao: 'Tempo de pausa no fundo em segundos (ex: 0.5)' },
    ],
    exemplo:
      'T1 D1\nS1200 M3\nG0 X30. Y20.\nCYCLE82(50., 0., 3., -18., , 0.3)\nM30',
    explicacaoExemplo:
      'Fura em X30 Y20: retorna ao plano 50, referência 0, segurança 3mm, profundidade -18mm, pausa 0.3s no fundo para acabamento limpo.',
    isG: false,
  },

  {
    codigo: 'CYCLE83', nome: 'Furação Profunda com Quebra de Cavaco', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Siemens', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação profunda com pecking — quebra ou retira cavacos em passos.',
    descricaoCompleta:
      'CYCLE83 é o ciclo de furação profunda do Siemens. Fura em incrementos (pecking) e pode apenas quebrar o cavaco (retrocede um pouco e continua) ou retrair completamente para expulsar o cavaco. ' +
      'Parâmetros principais: FDEP = primeira profundidade de peck, FDPR = redução de peck a cada passe, DAM = profundidade mínima de peck, DTB = pausa no fundo, DTS = pausa no retorno, FRF = fator de avanço no primeiro peck, VARI = modo (0=quebra, 1=retira cavaco).',
    sintaxe: 'CYCLE83(RTP, RFP, SDIS, DP, DPR, FDEP, FDPR, DAM, DTB, DTS, FRF, VARI)',
    parametros: [
      { letra: 'RTP', descricao: 'Plano de retorno' },
      { letra: 'RFP', descricao: 'Plano de referência (superfície)' },
      { letra: 'SDIS', descricao: 'Distância de segurança' },
      { letra: 'DP', descricao: 'Profundidade total final' },
      { letra: 'FDEP', descricao: 'Primeira profundidade de peck' },
      { letra: 'FDPR', descricao: 'Redução do incremento a cada peck' },
      { letra: 'DAM', descricao: 'Profundidade mínima do peck' },
      { letra: 'VARI', descricao: '0 = quebra de cavaco / 1 = retira cavaco completamente' },
    ],
    exemplo:
      'T3 D1 ; Broca Ø10\nS900 M3 M8\nG0 X50. Y50.\nCYCLE83(50.,0.,3.,-60.,,-15.,2.,5.,0.2,0.,1.,1)\nM9 M5\nM30',
    explicacaoExemplo:
      'Fura 60mm de profundidade em passos de 15mm, reduzindo 2mm/peck até mínimo de 5mm, retirando cavaco completamente a cada peck (VARI=1). Ideal para furos acima de 5x diâmetro.',
    isG: false,
  },

  {
    codigo: 'CYCLE84', nome: 'Rosqueamento Rígido e com Flutuante', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Siemens', diagramaTipo: 'rosca',
    descricao: 'Ciclo de rosqueamento com macho — rígido ou com mandril flutuante.',
    descricaoCompleta:
      'CYCLE84 executa rosqueamento com macho no Siemens SINUMERIK. Suporta tanto modo rígido (sincronização eletrônica spindle-Z) quanto mandril flutuante. ' +
      'O parâmetro SDAC define a direção do spindle (3=horário M3, 4=anti-horário M4). ' +
      'MPIT define o passo pela bitola da rosca (M3=0.5, M6=1.0, M10=1.5) — alternativa ao parâmetro PIT.',
    sintaxe: 'CYCLE84(RTP, RFP, SDIS, DP, DPR, DTB, SDAC, MPIT, PIT, POSS, SST, SST1)',
    parametros: [
      { letra: 'RTP', descricao: 'Plano de retorno' },
      { letra: 'RFP', descricao: 'Plano de referência' },
      { letra: 'DP', descricao: 'Profundidade final da rosca' },
      { letra: 'SDAC', descricao: 'Direção spindle: 3=M03 (direita), 4=M04 (esquerda)' },
      { letra: 'MPIT', descricao: 'Passo por bitola M (ex: 10.0 para M10 = passo 1.5mm automático)' },
      { letra: 'PIT', descricao: 'Passo manual em mm (alternativa ao MPIT)' },
      { letra: 'SST', descricao: 'Velocidade para rosquear (RPM)' },
      { letra: 'SST1', descricao: 'Velocidade para retrair (RPM — pode ser mais rápido)' },
    ],
    exemplo:
      'T5 D1 ; Macho M8\nG0 X25. Y25.\nCYCLE84(50.,0.,3.,-25.,,0.3,3,8.,,,300,600)\nM30',
    explicacaoExemplo:
      'Rosqueia M8 (MPIT=8 → passo 1.25mm automático), 25mm profundidade, 300 RPM para entrar, 600 RPM para retrair.',
    isG: false,
  },

  {
    codigo: 'CYCLE85', nome: 'Mandrilamento / Alargamento 1', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Siemens', diagramaTipo: 'furar',
    descricao: 'Ciclo de mandrilamento — entra e sai com avanço controlado.',
    descricaoCompleta:
      'CYCLE85 realiza mandrilamento ou alargamento com controle de avanço tanto na entrada quanto na saída. ' +
      'FFR é o avanço de entrada (furar), RFF é o avanço de retorno. Permite avanço de retorno diferente do de entrada — importante para não riscar o furo ao retrair.',
    sintaxe: 'CYCLE85(RTP, RFP, SDIS, DP, DPR, DTB, FFR, RFF)',
    parametros: [
      { letra: 'RTP', descricao: 'Plano de retorno' },
      { letra: 'RFP', descricao: 'Plano de referência' },
      { letra: 'DP', descricao: 'Profundidade final' },
      { letra: 'DTB', descricao: 'Pausa no fundo (s)' },
      { letra: 'FFR', descricao: 'Avanço de furação (mm/min)' },
      { letra: 'RFF', descricao: 'Avanço de retorno (mm/min — geralmente maior que FFR)' },
    ],
    exemplo:
      'T7 D1 ; Mandril ajustável Ø20\nS800 M3\nG0 X60. Y30.\nCYCLE85(50.,0.,3.,-40.,,0.5,80.,400.)\nM30',
    explicacaoExemplo:
      'Mandrilamento Ø20: entra a 80 mm/min, pausa 0.5s no fundo para acabamento, retorna a 400 mm/min (5x mais rápido, sem risco de marca).',
    isG: false,
  },

  {
    codigo: 'CYCLE93', nome: 'Ciclo de Canal (Grooving)', categoria: 'Torneamento',
    maquina: 'Torno CNC', fabricante: 'Siemens', diagramaTipo: 'linear',
    descricao: 'Ciclo de retificação de canal/ranhura em tornos Siemens SINUMERIK.',
    descricaoCompleta:
      'CYCLE93 executa usinagem de canais (grooves) em tornos com controle Siemens. ' +
      'Define a posição, largura, profundidade e ângulos do canal. Suporta canais externos e internos, axiais e radiais. ' +
      'SPD = posição de partida em X, SPL = posição de partida em Z, WIDG = largura do canal, DIAG = profundidade, STA1 = ângulo do flanco direito, ANG1 = ângulo do flanco esquerdo.',
    sintaxe: 'CYCLE93(SPD, SPL, WIDG, DIAG, STA1, ANG1, RCO1, RCO2, RCI1, RCI2, FAL1, FAL2, IDEP, DTB, VARI)',
    parametros: [
      { letra: 'SPD', descricao: 'Posição inicial em X (diâmetro)' },
      { letra: 'SPL', descricao: 'Posição inicial em Z' },
      { letra: 'WIDG', descricao: 'Largura total do canal (mm)' },
      { letra: 'DIAG', descricao: 'Profundidade do canal (mm)' },
      { letra: 'STA1', descricao: 'Ângulo do flanco direito (°) — 0 = reto' },
      { letra: 'ANG1', descricao: 'Ângulo do flanco esquerdo (°)' },
      { letra: 'DTB', descricao: 'Pausa no fundo (s)' },
      { letra: 'VARI', descricao: '1=externo, 2=interno, +axial/radial' },
    ],
    exemplo:
      'G0 X52. Z-30.\nCYCLE93(52.,_30.,5.,3.,0.,0.,0.4,0.4,0.2,0.2,0.1,0.1,1.,0.2,1)\nM30',
    explicacaoExemplo:
      'Canal externo em Z-30: 5mm largo, 3mm profundo, flancos retos, raios de canto 0.4mm externos e 0.2mm internos, sobremetal 0.1mm para acabamento.',
    isG: false,
  },

  {
    codigo: 'CYCLE95', nome: 'Ciclo de Desbaste / Acabamento por Perfil', categoria: 'Torneamento',
    maquina: 'Torno CNC', fabricante: 'Siemens', diagramaTipo: 'linear',
    descricao: 'Ciclo de torneamento de contorno — desbaste e acabamento por perfil programado.',
    descricaoCompleta:
      'CYCLE95 é o ciclo mais poderoso do Siemens para torneamento de contornos complexos. ' +
      'O perfil é definido em um subprograma separado (contorno) e o CYCLE95 faz desbaste em passes paralelos e depois acabamento seguindo o perfil exato. ' +
      'NPP = nome do subprograma de perfil, MID = profundidade de corte por passe, FALZ/FALX = sobremetal de acabamento em Z e X.',
    sintaxe: 'CYCLE95(NPP, MID, FALZ, FALX, FAL, FF1, FF2, FF3, VARI, DT, DAM, _VRT)',
    parametros: [
      { letra: 'NPP', descricao: 'Nome do subprograma de perfil (string, ex: "CONTORNO1")' },
      { letra: 'MID', descricao: 'Profundidade máxima de corte por passe (mm)' },
      { letra: 'FALZ', descricao: 'Sobremetal de acabamento em Z (mm)' },
      { letra: 'FALX', descricao: 'Sobremetal de acabamento em X (mm)' },
      { letra: 'FF1', descricao: 'Avanço de desbaste (mm/rot)' },
      { letra: 'FF2', descricao: 'Avanço de mergulho (mm/rot)' },
      { letra: 'FF3', descricao: 'Avanço de acabamento (mm/rot)' },
      { letra: 'VARI', descricao: '1=desbaste ext, 2=desbaste int, 3=acab ext, 4=acab int, +5=ext+int' },
    ],
    exemplo:
      'DEF STRING[32] NPP = "PERFIL1"\nCYCLE95(NPP, 2., 0.2, 0.1, , 0.25, 0.15, 0.1, 1)\n\n; Subprograma PERFIL1.SPF:\nG1 X20. Z0.\nX30. Z-15.\nX30. Z-40.\nX50. Z-55.\nM17',
    explicacaoExemplo:
      'Desbaste externo em passes de 2mm com sobremetal 0.2mm em Z e 0.1mm em X, depois acabamento seguindo o perfil definido em PERFIL1.SPF.',
    isG: false,
  },

  {
    codigo: 'CYCLE97', nome: 'Ciclo de Rosca em Torno', categoria: 'Rosqueamento',
    maquina: 'Torno CNC', fabricante: 'Siemens', diagramaTipo: 'rosca',
    descricao: 'Ciclo completo de rosqueamento em torno — externo, interno, cônico e múltiplas entradas.',
    descricaoCompleta:
      'CYCLE97 é o ciclo de rosqueamento em torno do Siemens. Suporta rosca externa e interna, cônica, passo métrico e polegada, múltiplas entradas (multi-start), variação de passo e perfil completo do flanco. ' +
      'PIT = passo em mm, MPIT = passo por bitola M, KDIAM = diâmetro de início, FDIAM = diâmetro final, APP = comprimento de aproximação, ROP = comprimento de saída, TDEP = profundidade de rosca.',
    sintaxe: 'CYCLE97(PIT, MPIT, SPL, FPL, DM1, DM2, APP, ROP, TDEP, FAL, IANG, NSP, NRC, NID, VARI, NUMT)',
    parametros: [
      { letra: 'PIT', descricao: 'Passo da rosca em mm (ex: 1.5 para M10)' },
      { letra: 'MPIT', descricao: 'Bitola M para passo automático (ex: 10.0 para M10)' },
      { letra: 'SPL', descricao: 'Posição Z de início' },
      { letra: 'FPL', descricao: 'Posição Z final' },
      { letra: 'DM1', descricao: 'Diâmetro de início em X' },
      { letra: 'DM2', descricao: 'Diâmetro final em X (igual ao DM1 para rosca cilíndrica)' },
      { letra: 'TDEP', descricao: 'Profundidade total da rosca (mm)' },
      { letra: 'NRC', descricao: 'Número de passes de desbaste' },
      { letra: 'VARI', descricao: '1=externa, 2=interna' },
      { letra: 'NUMT', descricao: 'Número de entradas (multi-start, ex: 2 para rosca dupla)' },
    ],
    exemplo:
      'S800 M4\nCYCLE97(,10.,0.,-30.,9.9,9.9,3.,2.,0.92,0.05,-30.,0.,5,2,1,1)\nM30',
    explicacaoExemplo:
      'Rosca M10 externa: Z0 até Z-30mm, diâmetro 9.9mm, profundidade 0.92mm (passo 1.5mm automático), 5 passes de desbaste, 2 passes de acabamento, saída 2mm.',
    isG: false,
  },

  {
    codigo: 'G33', nome: 'Rosqueamento de Passo Constante (Siemens)', categoria: 'Rosqueamento',
    maquina: 'Torno CNC', fabricante: 'Siemens', diagramaTipo: 'rosca',
    descricao: 'Rosqueamento linear de passo constante — interpolação spindle + eixo.',
    descricaoCompleta:
      'G33 no Siemens SINUMERIK executa rosqueamento por sincronização eletrônica do spindle com o eixo de avanço. ' +
      'Diferente do Fanuc onde G33 é rosca de passo variável — no Siemens G33 é a rosca de passo FIXO, equivalente ao G32 do Fanuc. ' +
      'K = passo axial em mm/rotação. SF = ângulo de início para múltiplas entradas.',
    sintaxe: 'G33 Z[fim] K[passo] SF=[ângulo_início]',
    parametros: [
      { letra: 'Z', descricao: 'Posição final do eixo Z' },
      { letra: 'K', descricao: 'Passo da rosca em mm/rotação' },
      { letra: 'SF', descricao: 'Ângulo de início do spindle para rosca multi-entrada (0–360°)' },
    ],
    exemplo:
      'G97 S600 M3\nG0 X29.8 Z3.\nG33 Z-28. K1.5\nG0 X35.\nZ3.\nX29.4\nG33 Z-28. K1.5\nG0 X35.\nM30',
    explicacaoExemplo:
      'Dois passes de rosca M30×1.5: primeiro X29.8mm depois X29.4mm. Cada passe sincroniza spindle com avanço de 1.5mm/rot.',
    isG: true,
  },

  {
    codigo: 'G64', nome: 'Modo Contínuo / Suavização de Trajetória', categoria: 'Movimento',
    maquina: 'Centro de Usinagem', fabricante: 'Siemens', diagramaTipo: 'linear',
    descricao: 'Ativa modo de trajetória contínua — suaviza cantos e mantém velocidade máxima.',
    descricaoCompleta:
      'G64 no Siemens ativa o modo de avanço contínuo (continuous path mode). O CNC não para nos pontos de transição entre blocos, mas suaviza a trajetória mantendo a velocidade programada. ' +
      'Oposto ao G60 (posicionamento exato) e G9 (parada exata por bloco). ' +
      'Fundamental em usinagem de superfícies 3D e moldes onde paradas criam marcas. ' +
      'No Siemens pode ser combinado com SOFT (suavização de jerk) e FFWOF/FFWON (feedforward).',
    sintaxe: 'G64',
    parametros: [],
    exemplo:
      'G64\nG1 X0. Y0. F3000\nX50. Y30.\nX80. Y10.\nX100. Y50.\nG60\nG1 X120. Y50. F500',
    explicacaoExemplo:
      'G64 ativa trajetória suave para fresamento de contorno a 3000mm/min (sem marcar cantos). G60 volta ao modo exato para a operação de precisão final.',
    isG: true,
  },

  {
    codigo: 'G74', nome: 'Retorno ao Ponto de Referência (Siemens)', categoria: 'Referência',
    maquina: 'Ambos', fabricante: 'Siemens', diagramaTipo: 'referencia',
    descricao: 'Move o eixo para o ponto de referência da máquina (zero máquina).',
    descricaoCompleta:
      'G74 no Siemens SINUMERIK equivale ao G28 do Fanuc — retorna ao zero máquina (ponto de referência). ' +
      'A sintaxe usa X1=0 Y1=0 Z1=0 para indicar quais eixos devem referenciar. ' +
      'Diferente do Fanuc, não passa por um ponto intermediário — vai direto ao zero máquina.',
    sintaxe: 'G74 X1=0 Y1=0 Z1=0',
    parametros: [
      { letra: 'X1=0', descricao: 'Inclui eixo X no retorno ao zero máquina' },
      { letra: 'Y1=0', descricao: 'Inclui eixo Y no retorno ao zero máquina' },
      { letra: 'Z1=0', descricao: 'Inclui eixo Z no retorno ao zero máquina (sempre primeiro!)' },
    ],
    exemplo:
      'G74 Z1=0\nG74 X1=0 Y1=0',
    explicacaoExemplo:
      'Primeiro retorna Z ao zero máquina (segurança), depois retorna X e Y. Sempre Z primeiro para evitar colisão com peça.',
    isG: true,
  },

  
  
  

  {
    codigo: 'G12', nome: 'Fresamento Circular de Bolso (Horário)', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'circular_cw',
    descricao: 'Fresar um bolsão circular CW a partir do centro — específico Haas.',
    descricaoCompleta:
      'G12 (Haas) fresa um bolsão circular completo no sentido horário partindo do centro. ' +
      'A ferramenta espirala do centro para fora até o diâmetro programado com I (raio). ' +
      'F = avanço, I = raio final do bolsão, Q = incremento radial por volta (se omitido, faz em uma única passada com raio I). ' +
      'Muito mais fácil que programar com G02/G03 + macros.',
    sintaxe: 'G12 I[raio] Q[incremento] F[avanço]',
    parametros: [
      { letra: 'I', descricao: 'Raio final do bolsão circular (mm)' },
      { letra: 'Q', descricao: 'Incremento radial por espiral — omitir para passada única' },
      { letra: 'F', descricao: 'Avanço em mm/min' },
    ],
    exemplo:
      'T1 M6 ; Fresa Ø10\nS3500 M3\nG0 X50. Y50. Z5.\nG1 Z-8. F500\nG12 I25. Q4. F1200\nG0 Z50.\nM30',
    explicacaoExemplo:
      'Fresar bolsão circular Ø50mm (raio 25mm), 8mm profundo. Entra no centro, espirala 4mm por volta até raio 25mm no sentido horário.',
    isG: true,
  },

  {
    codigo: 'G13', nome: 'Fresamento Circular de Bolso (Anti-Horário)', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'circular_ccw',
    descricao: 'Fresar um bolsão circular CCW a partir do centro — específico Haas.',
    descricaoCompleta:
      'G13 (Haas) é idêntico ao G12 mas no sentido anti-horário (CCW). ' +
      'Use G12 para fresamento convencional (conventional milling) e G13 para fresamento a favor (climb milling), dependendo da estratégia desejada.',
    sintaxe: 'G13 I[raio] Q[incremento] F[avanço]',
    parametros: [
      { letra: 'I', descricao: 'Raio final do bolsão circular (mm)' },
      { letra: 'Q', descricao: 'Incremento radial por espiral' },
      { letra: 'F', descricao: 'Avanço em mm/min' },
    ],
    exemplo:
      'G0 X0. Y0. Z5.\nG1 Z-5. F400\nG13 I20. Q5. F1000\nG0 Z50.\nM30',
    explicacaoExemplo:
      'Bolsão circular Ø40mm, sentido anti-horário (climb milling), 5mm profundo, espiral de 5mm por volta.',
    isG: true,
  },

  {
    codigo: 'G150', nome: 'Fresamento de Bolsão Geral (General Pocket)', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'linear',
    descricao: 'Ciclo de fresamento de bolsão de qualquer forma definida por subprograma.',
    descricaoCompleta:
      'G150 (Haas) é o ciclo de pocketing geral — fresa qualquer forma de bolsão cujo contorno é definido em um subprograma. ' +
      'P = número do subprograma que define o contorno, Q = incremento de profundidade por passe, R = distância de retorno, E = tolerância de contorno, ' +
      'F = avanço de fresamento, H = corretor de comprimento, D = corretor de diâmetro. ' +
      'O subprograma descreve o contorno do bolsão com G0/G1/G2/G3.',
    sintaxe: 'G150 P[subprog] Q[incremento_Z] R[retorno] E[tolerância] F[avanço] H[corretor_comp] D[corretor_diam]',
    parametros: [
      { letra: 'P', descricao: 'Número do subprograma de contorno' },
      { letra: 'Q', descricao: 'Profundidade de corte por passe (mm)' },
      { letra: 'R', descricao: 'Posição do plano de retorno (Z absoluto)' },
      { letra: 'E', descricao: 'Tolerância de contorno (mm, ex: 0.01)' },
      { letra: 'F', descricao: 'Avanço de fresamento (mm/min)' },
      { letra: 'H', descricao: 'Número do corretor de comprimento de ferramenta' },
      { letra: 'D', descricao: 'Número do corretor de diâmetro da fresa' },
    ],
    exemplo:
      'T5 M6 ; Fresa Ø16\nG0 G90 X0 Y0 S2500 M3\nG43 H5 Z50.\nG150 P100 Q5. R5. E.01 F1500 H5 D5\nG0 Z50.\nM30\n\nO100 (CONTORNO DO BOLSÃO)\nG0 X-30. Y-20.\nG1 X30.\nY20.\nX-30.\nY-20.\nM99',
    explicacaoExemplo:
      'Fresa bolsão retangular 60×40mm definido no subprograma O100, passes de 5mm profundidade, tolerância 0.01mm.',
    isG: true,
  },

  {
    codigo: 'G187', nome: 'Controle de Suavidade de Trajetória (Haas)', categoria: 'Controle',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'linear',
    descricao: 'Define o nível de suavização de cantos e precisão de trajetória no Haas.',
    descricaoCompleta:
      'G187 (Haas) controla o trade-off entre velocidade e precisão de cantos. ' +
      'P1 = alta precisão (para medição e cantos vivos), P2 = padrão, P3 = alta velocidade (para superfícies suaves em moldes). ' +
      'E = tolerância máxima de desvio de contorno em mm — valores menores = mais preciso mas mais lento. ' +
      'Equivalente ao G64 com parâmetros no Siemens.',
    sintaxe: 'G187 P[modo] E[tolerância]',
    parametros: [
      { letra: 'P1', descricao: 'Alta precisão — para furação e operações de posicionamento exato' },
      { letra: 'P2', descricao: 'Padrão — equilibrio velocidade/precisão (padrão liga no M30)' },
      { letra: 'P3', descricao: 'Alta velocidade — para superfícies 3D e moldagem' },
      { letra: 'E', descricao: 'Tolerância de contorno em mm (ex: E0.01 para alta precisão)' },
    ],
    exemplo:
      '; Fresamento de molde 3D — alta velocidade\nG187 P3 E0.025\nG1 X0. Y0. F5000\nX100. Y50.\nX200. Y0.\n; Voltar ao padrão\nG187 P2',
    explicacaoExemplo:
      'G187 P3 ativa modo de alta velocidade com 0.025mm de tolerância de contorno — ideal para superfícies 3D de moldes onde marcas de parada são inaceitáveis.',
    isG: true,
  },

  
  
  

  {
    codigo: 'G65', nome: 'Chamada de Macro (Fanuc)', categoria: 'Macro / Subprograma',
    maquina: 'Ambos', fabricante: 'Fanuc',
    descricao: 'Chama uma macro customizada (programa O9xxx) com passagem de parâmetros.',
    descricaoCompleta:
      'G65 chama um programa de macro Fanuc (O9000–O9999). Permite passar variáveis locais (#1–#33) como parâmetros nomeados (A, B, C, D, E, F, H, I, J, K, L, M, Q, R, S, T, U, V, W, X, Y, Z). ' +
      'As macros possibilitam programação com lógica (IF/THEN/GOTO), loops, cálculos matemáticos e parametrização de ciclos. ' +
      'P = número do programa de macro, os demais são parâmetros.',
    sintaxe: 'G65 P[macro_num] [parâmetros...]',
    parametros: [
      { letra: 'P', descricao: 'Número do programa de macro (O9000–O9999)' },
      { letra: 'A', descricao: 'Parâmetro A → variável local #1 na macro' },
      { letra: 'B', descricao: 'Parâmetro B → variável local #2 na macro' },
      { letra: 'X', descricao: 'Parâmetro X → variável local #24 na macro' },
      { letra: 'Z', descricao: 'Parâmetro Z → variável local #26 na macro' },
    ],
    exemplo:
      '; Chama macro de furo com chanfro\nG65 P9010 X50. Y30. Z-20. R3. A45. D5.\n\n; Macro O9010:\nO9010\nG81 X#24 Y#25 Z#26 R#18\n; ... lógica de chanfro ...\nM99',
    explicacaoExemplo:
      'Chama macro O9010 passando posição X50 Y30, profundidade Z-20, retorno R3, ângulo de chanfro A=45°, diâmetro D=5mm como variáveis locais.',
    isG: true,
  },

  {
    codigo: 'G68', nome: 'Rotação do Sistema de Coordenadas', categoria: 'Transformação',
    maquina: 'Centro de Usinagem', fabricante: 'Fanuc', diagramaTipo: 'espelhamento',
    descricao: 'Rotaciona o sistema de coordenadas para usinar padrões em ângulos diferentes.',
    descricaoCompleta:
      'G68 rotaciona o sistema de coordenadas de usinagem em torno de um ponto central. ' +
      'Extremamente útil para usinar o mesmo contorno em múltiplos ângulos sem reprogramar. ' +
      'X, Y = centro de rotação, R = ângulo de rotação em graus (sentido anti-horário positivo). ' +
      'Cancelar com G69. Pode ser aninhado em múltiplas rotações.',
    sintaxe: 'G68 X[centro_X] Y[centro_Y] R[ângulo]\n...\nG69',
    parametros: [
      { letra: 'X', descricao: 'Coordenada X do centro de rotação' },
      { letra: 'Y', descricao: 'Coordenada Y do centro de rotação' },
      { letra: 'R', descricao: 'Ângulo de rotação em graus (positivo = anti-horário)' },
    ],
    exemplo:
      '; Usinar furo em 0°, 90°, 180°, 270° em volta do centro\nG68 X0. Y0. R0.\nG81 X50. Y0. Z-10. R3. F100\nG69\nG68 X0. Y0. R90.\nG81 X50. Y0. Z-10. R3.\nG69\nG68 X0. Y0. R180.\nG81 X50. Y0. Z-10. R3.\nG69\nG68 X0. Y0. R270.\nG81 X50. Y0. Z-10. R3.\nG69',
    explicacaoExemplo:
      'Quatro furos equidistantes (raio 50mm) a 0°, 90°, 180° e 270° em torno da origem, usando a mesma linha G81 com rotação de coordenadas — muito mais simples que calcular as 4 posições.',
    isG: true,
  },

  {
    codigo: 'G51', nome: 'Escalonamento (Scaling)', categoria: 'Transformação',
    maquina: 'Centro de Usinagem', fabricante: 'Fanuc', diagramaTipo: 'espelhamento',
    descricao: 'Escala (amplia ou reduz) o programa de usinagem por um fator.',
    descricaoCompleta:
      'G51 aplica um fator de escala ao programa. Pode escalar uniformemente em todos os eixos ou diferente em cada eixo. ' +
      'X, Y, Z = centro do escalonamento, P = fator de escala (ex: P2000 = fator 2.0, P500 = fator 0.5). ' +
      'Cancelar com G50. Útil para adaptar programas a peças de tamanhos diferentes.',
    sintaxe: 'G51 X[centro] Y[centro] Z[centro] P[fator×1000]',
    parametros: [
      { letra: 'X/Y/Z', descricao: 'Centro do escalonamento (ponto fixo)' },
      { letra: 'P', descricao: 'Fator de escala ×1000 (ex: P2000 = 2×, P500 = 0.5×)' },
    ],
    exemplo:
      '; Programa de quadrado 50×50, escalar para 100×100\nG51 X0. Y0. P2000\nG0 X0. Y0.\nG1 X50. F500\nY50.\nX0.\nY0.\nG50 ; cancela escala',
    explicacaoExemplo:
      'G51 P2000 duplica todas as coordenadas — o quadrado de 50mm vira 100mm automaticamente sem alterar o programa original.',
    isG: true,
  },

  
  
  

  {
    codigo: 'CYCL 1', nome: 'Furação Profunda (Heidenhain)', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Heidenhain', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação com peck — define distância de incremento e retorno.',
    descricaoCompleta:
      'CYCL DEF 1 (Heidenhain) define o ciclo de furação profunda em formato conversacional Heidenhain. ' +
      'A sintaxe é completamente diferente do Fanuc/Siemens — usa CYCL DEF para definir e CYCL CALL para chamar. ' +
      'Parâmetros: profundidade total, profundidade de peck, distância de segurança, avanço. ' +
      'Q1 = profundidade total, Q2 = peck (incremento), Q3 = distância de segurança, Q4 = tempo no fundo, Q5 = avanço.',
    sintaxe:
      'CYCL DEF 1.0 PECKING\nCYCL DEF 1.1 DEPTH Q1=-[prof]\nCYCL DEF 1.2 PECKG Q2=[peck]\nCYCL DEF 1.3 DWELL Q3=[pausa]\nCYCL DEF 1.4 DR+ Q4=[segurança]\nCYCL DEF 1.5 F Q5=[avanço]\nL X+[X] Y+[Y] R0 FMAX M99',
    parametros: [
      { letra: 'Q1', descricao: 'Profundidade total (negativa, ex: -30)' },
      { letra: 'Q2', descricao: 'Incremento de peck (positivo, ex: 8)' },
      { letra: 'Q3', descricao: 'Tempo de pausa no fundo (s, ex: 0)' },
      { letra: 'Q4', descricao: 'Distância de segurança (ex: 2)' },
      { letra: 'Q5', descricao: 'Avanço de furação (mm/min)' },
    ],
    exemplo:
      'CYCL DEF 1.0 PECKING\nCYCL DEF 1.1 DEPTH Q1=-35\nCYCL DEF 1.2 PECKG Q2=8\nCYCL DEF 1.3 DWELL Q3=0\nCYCL DEF 1.4 DR+ Q4=2\nCYCL DEF 1.5 F Q5=180\nL X+50 Y+30 R0 FMAX M99\nL X+80 Y+30 R0 FMAX M99',
    explicacaoExemplo:
      'Define ciclo de furação 35mm profundo em pecks de 8mm, 180mm/min. Executa em X50Y30 e depois X80Y30 com FMAX para posicionamento rápido.',
    isG: false,
  },

  {
    codigo: 'CYCL 2', nome: 'Rosqueamento com Macho (Heidenhain)', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Heidenhain', diagramaTipo: 'rosca',
    descricao: 'Ciclo de rosqueamento Heidenhain — define profundidade e passo da rosca.',
    descricaoCompleta:
      'CYCL DEF 2 (Heidenhain) é o ciclo de rosqueamento com macho. ' +
      'No Heidenhain, o passo da rosca é inserido diretamente como avanço F calculado: F = RPM × passo. ' +
      'Ou seja, para M10×1.5 a 300 RPM: F = 300 × 1.5 = 450mm/min. ' +
      'O ciclo sincroniza automaticamente spindle e eixo Z.',
    sintaxe:
      'CYCL DEF 2.0 TAPPING\nCYCL DEF 2.1 DEPTH Q1=-[prof]\nCYCL DEF 2.2 DWELL Q2=[pausa]\nCYCL DEF 2.3 F Q3=[rpm×passo]\nL X+[X] Y+[Y] R0 FMAX M3 M99',
    parametros: [
      { letra: 'Q1', descricao: 'Profundidade da rosca (negativa)' },
      { letra: 'Q2', descricao: 'Tempo de pausa no fundo (geralmente 0)' },
      { letra: 'Q3', descricao: 'Avanço = RPM × passo (ex: 300 RPM × 1.5mm = 450)' },
    ],
    exemplo:
      'S300 M3\nCYCL DEF 2.0 TAPPING\nCYCL DEF 2.1 DEPTH Q1=-20\nCYCL DEF 2.2 DWELL Q2=0\nCYCL DEF 2.3 F Q3=450\nL X+30 Y+20 R0 FMAX M99',
    explicacaoExemplo:
      'Rosca M10×1.5: 300 RPM × 1.5 = 450 mm/min. Rosqueia 20mm de profundidade em X30Y20.',
    isG: false,
  },

  {
    codigo: 'CYCL 17', nome: 'Fresamento de Rosca Interna (Heidenhain)', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Heidenhain', diagramaTipo: 'rosca',
    descricao: 'Ciclo de fresamento de rosca com fresa de rosca — faz rosca sem macho.',
    descricaoCompleta:
      'CYCL DEF 17 (Heidenhain) fresa rosca interna com fresa de rosca helicoidal — dispensa o uso de macho. ' +
      'A fresa entra no centro, executa uma hélice e sai. Vantagem: uma só fresa faz várias bitolas, menos quebra de ferramenta em materiais difíceis. ' +
      'Q1 = profundidade da rosca, Q2 = passo em mm, Q3 = diâmetro nominal da rosca.',
    sintaxe:
      'CYCL DEF 17.0 THREAD MILLING\nCYCL DEF 17.1 DEPTH Q1=-[prof]\nCYCL DEF 17.2 PITCH Q2=[passo]\nCYCL DEF 17.3 NOMINAL DIA Q3=[diam_nom]\nL X+[X] Y+[Y] R0 FMAX M99',
    parametros: [
      { letra: 'Q1', descricao: 'Profundidade da rosca (mm)' },
      { letra: 'Q2', descricao: 'Passo da rosca (mm)' },
      { letra: 'Q3', descricao: 'Diâmetro nominal da rosca (mm)' },
    ],
    exemplo:
      'CYCL DEF 17.0 THREAD MILLING\nCYCL DEF 17.1 DEPTH Q1=-18\nCYCL DEF 17.2 PITCH Q2=1.5\nCYCL DEF 17.3 NOMINAL DIA Q3=10\nL X+40 Y+40 R0 FMAX M99',
    explicacaoExemplo:
      'Fresa rosca M10×1.5 com 18mm de profundidade usando fresa de rosca. A ferramenta executa movimento helicoidal sem necessidade de macho.',
    isG: false,
  },

  
  
  

  {
    codigo: 'G10', nome: 'Entrada de Dados por Programa (Mazak/Fanuc)', categoria: 'Corretor',
    maquina: 'Ambos', fabricante: 'Fanuc', diagramaTipo: 'referencia',
    descricao: 'Define valores de corretores de ferramenta e coordenadas de trabalho diretamente no programa.',
    descricaoCompleta:
      'G10 permite definir ou alterar corretores de ferramenta (comprimento, raio) e offsets de trabalho (G54–G59) diretamente via programa CNC, sem acessar o painel. ' +
      'L1 = corretor de geometria, L2 = corretor de desgaste, L10 = offset de trabalho. ' +
      'P = número do corretor, R = valor. Muito usado em automação para atualizar desgaste de ferramenta automaticamente.',
    sintaxe:
      'G10 L[tipo] P[num] R[valor]\n\nG10 L1 P[tool] R[comp_Z] ; corretor comprimento\nG10 L2 P[54-59] X[x] Y[y] Z[z] ; offset trabalho',
    parametros: [
      { letra: 'L1', descricao: 'Corretor de geometria de ferramenta' },
      { letra: 'L2', descricao: 'Corretor de desgaste de ferramenta' },
      { letra: 'L10', descricao: 'Offset de sistema de coordenadas (G54=P1, G55=P2...)' },
      { letra: 'P', descricao: 'Número do corretor ou offset' },
      { letra: 'R', descricao: 'Valor a definir (mm)' },
    ],
    exemplo:
      '; Definir offset G54 via programa\nG10 L2 P1 X-250.5 Y-180.3 Z-320.8\n\n; Atualizar desgaste ferramenta T1\nG10 L11 P1 R-0.05\n\nG54\nG0 X0. Y0.',
    explicacaoExemplo:
      'Define o offset G54 (P1) com os valores de X, Y, Z da origem da peça. Depois ajusta -0.05mm de desgaste no corretor da ferramenta 1 — tudo via programa sem operador.',
    isG: true,
  },

  
  
  

  {
    codigo: 'G100', nome: 'Macro Call — Mazatrol Macro', categoria: 'Macro',
    maquina: 'Ambos', fabricante: 'Mazak',
    descricao: 'Chamada de macro de usuário no Mazatrol. Equivale ao G65 Fanuc.',
    descricaoCompleta:
      'G100 chama um subprograma de macro Mazak. No SmoothX permite passar até 26 variáveis (A–Z). ' +
      'As variáveis são acessadas internamente como #1–#26. Muito usado em ciclos customizados de furação, ' +
      'rosqueamento e medição na linha.',
    sintaxe: 'G100 P[número] A[val] B[val] C[val]...',
    parametros: [
      { letra: 'P', descricao: 'Número do subprograma macro (ex: P1000)' },
      { letra: 'A–Z', descricao: 'Variáveis a passar para o macro (#1–#26)' },
    ],
    exemplo: '; Chama macro de furação customizado\nG100 P1000 A25.0 B10.0 C-30.0\n; A=diâmetro, B=passo, C=prof.',
    explicacaoExemplo: 'Executa macro 1000 passando diâmetro 25mm, passo 10mm e profundidade -30mm.',
    isG: true,
  },

  {
    codigo: 'G10.9', nome: 'Programação de Geometria de Ferramenta', categoria: 'Ferramenta',
    maquina: 'Centro de Usinagem', fabricante: 'Mazak',
    descricao: 'Define ou modifica dados de geometria da ferramenta diretamente via programa.',
    descricaoCompleta:
      'G10.9 permite definir comprimento, raio e desgaste de ferramentas diretamente no programa CNC ' +
      'no Mazak SmoothX/Matrix. Equivalente ao G10 do Fanuc mas com sintaxe estendida para o Mazatrol. ' +
      'Muito usado para automação de setup e troca de insertos sem intervenção do operador.',
    sintaxe: 'G10.9 T[num] H[comp] R[raio] WL[desgaste_comp] WR[desgaste_raio]',
    parametros: [
      { letra: 'T', descricao: 'Número da ferramenta' },
      { letra: 'H', descricao: 'Comprimento da ferramenta (mm)' },
      { letra: 'R', descricao: 'Raio da ferramenta (mm)' },
      { letra: 'WL', descricao: 'Desgaste de comprimento (positivo = subtrai material)' },
      { letra: 'WR', descricao: 'Desgaste de raio' },
    ],
    exemplo: '; Atualiza ferramenta T5 após medição\nG10.9 T5 H125.485 R5.000 WL0.000 WR0.000',
    explicacaoExemplo: 'Define T5 com comprimento medido 125.485mm e raio 5mm, zerando desgastes.',
    isG: true,
  },

  {
    codigo: 'G200', nome: 'Ciclo de Furação Profunda — Mazak', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Mazak', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação profunda com pecking nativo do Mazatrol SmoothX.',
    descricaoCompleta:
      'G200 é o ciclo de furação profunda do Mazatrol. Semelhante ao G83 Fanuc, mas com parâmetros ' +
      'de redução automática de peck e controle de fluido integrado. No SmoothX, aceita parâmetros ' +
      'adicionais para controle de alta velocidade e refrigeração.',
    sintaxe: 'G200 X[x] Y[y] Z[prof] R[ref] Q[peck] F[avanço]',
    parametros: [
      { letra: 'X, Y', descricao: 'Posição do furo' },
      { letra: 'Z', descricao: 'Profundidade final' },
      { letra: 'R', descricao: 'Plano de referência (distância de segurança)' },
      { letra: 'Q', descricao: 'Profundidade de cada peck (positivo)' },
      { letra: 'F', descricao: 'Avanço de furação (mm/min)' },
    ],
    exemplo: 'S1200 M3 M8\nG200 X50. Y30. Z-45. R3. Q8. F180',
    explicacaoExemplo: 'Fura em X50 Y30 até -45mm em passo de 8mm a 180mm/min, com refrigeração ativa.',
    isG: true,
  },

  {
    codigo: 'G201', nome: 'Ciclo de Rosqueamento — Mazak', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Mazak', diagramaTipo: 'rosca',
    descricao: 'Ciclo de rosqueamento rígido com sincronização spindle-eixo Z no Mazatrol.',
    descricaoCompleta:
      'G201 executa rosqueamento rígido sincronizando a rotação do spindle com o avanço em Z. ' +
      'No SmoothX, suporta aceleração/desaceleração otimizada para roscas de alta velocidade. ' +
      'O passo é calculado por: F = S × passo.',
    sintaxe: 'G201 X[x] Y[y] Z[prof] R[ref] F[avanço]',
    parametros: [
      { letra: 'Z', descricao: 'Profundidade da rosca (negativo)' },
      { letra: 'R', descricao: 'Plano de aproximação' },
      { letra: 'F', descricao: 'Avanço = RPM × passo (ex: M10 a 800rpm → F800)' },
    ],
    exemplo: '; M10 × 1.5mm — Rosca métrica\nS800 M3\nG201 X100. Y50. Z-25. R3. F1200\n; F = 800 × 1.5 = 1200',
    explicacaoExemplo: 'Rosqueia M10×1.5 a 800rpm até -25mm. F=1200 = 800rpm × 1.5mm de passo.',
    isG: true,
  },

  {
    codigo: 'G206', nome: 'Ciclo de Fresamento de Furo (Helical) — Mazak', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'Mazak', diagramaTipo: 'circular_cw',
    descricao: 'Ciclo de fresamento helicoidal de furos no Mazatrol SmoothX.',
    descricaoCompleta:
      'G206 executa um ciclo de fresamento helicoidal (helical interpolation) para abrir ou acabar furos ' +
      'com fresa de topo. Elimina a necessidade de broca em furos grandes. Permite controlar diâmetro ' +
      'final, profundidade e passo helicoidal.',
    sintaxe: 'G206 X[x] Y[y] Z[prof] R[ref] I[raio_fresa] Q[passo_z] F[avanço]',
    parametros: [
      { letra: 'I', descricao: 'Raio de interpolação helicoidal' },
      { letra: 'Q', descricao: 'Passo axial por volta (mm/revolução)' },
      { letra: 'Z', descricao: 'Profundidade total' },
      { letra: 'F', descricao: 'Avanço de corte mm/min' },
    ],
    exemplo: '; Furo Ø50mm com fresa Ø12mm\nG206 X0 Y0 Z-20. R2. I19. Q2. F300',
    explicacaoExemplo: 'Fresa furo Ø50mm (I=19 = (50-12)/2) em hélice de 2mm/volta até -20mm de profundidade.',
    isG: true,
  },

  
  
  

  {
    codigo: 'G1026', nome: 'Compensação Dinâmica de Ferramenta — Okuma', categoria: 'Compensação',
    maquina: 'Centro de Usinagem', fabricante: 'Okuma',
    descricao: 'Compensação dinâmica de raio de fresa com controle de avanço adaptativo.',
    descricaoCompleta:
      'G1026 é uma função exclusiva do OSP-P300 (Okuma) que aplica compensação de raio de fresa ' +
      'com ajuste automático de avanço nos cantos e arcos. Garante velocidade de corte constante ' +
      'ao redor do contorno, melhorando acabamento superficial. Substitui o par G41/G42 em programação avançada.',
    sintaxe: 'G1026 D[num_offset] F[avanço_nominal]',
    parametros: [
      { letra: 'D', descricao: 'Número do offset de raio da fresa' },
      { letra: 'F', descricao: 'Avanço nominal de referência' },
    ],
    exemplo: 'G1026 D1 F300\nG1 X100. Y0 F300\nG3 X0 Y100. R100.\nG1027 ; cancelar',
    explicacaoExemplo: 'Ativa compensação dinâmica Okuma com D1, percorre contorno e cancela com G1027.',
    isG: true,
  },

  {
    codigo: 'G28.1', nome: 'Retorno ao Ponto de Referência — Okuma OSP', categoria: 'Referência',
    maquina: 'Ambos', fabricante: 'Okuma', diagramaTipo: 'referencia',
    descricao: 'Retorno ao ponto de referência da máquina via ponto intermediário no OSP.',
    descricaoCompleta:
      'No Okuma OSP, G28.1 executa o zero return via um ponto intermediário de forma segura. ' +
      'Semelhante ao G28 Fanuc mas com controle de velocidade de aproximação independente. ' +
      'Aceita parâmetros de velocidade de busca de home e tolerância de posicionamento.',
    sintaxe: 'G28.1 X[x] Y[y] Z[z]',
    parametros: [
      { letra: 'X, Y, Z', descricao: 'Coordenadas do ponto intermediário antes de ir ao home' },
    ],
    exemplo: '; Retorno via ponto seguro\nG28.1 Z50.\nG28.1 X0. Y0.',
    explicacaoExemplo: 'Sobe Z para 50mm (seguro), depois faz home de X e Y pelo OSP.',
    isG: true,
  },

  {
    codigo: 'G2001', nome: 'Ciclo de Furação Profunda OSP', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Okuma', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação profunda com pecking no controle OSP-P300/P500.',
    descricaoCompleta:
      'G2001 é o ciclo de furação profunda do Okuma OSP. Funciona com pecking controlado, ' +
      'retração para limpeza de cavaco e redução automática de incremento. O OSP-P500 aceita ' +
      'parâmetros adicionais para refrigeração de alta pressão e controle adaptativo de carga.',
    sintaxe: 'G2001 X[x] Y[y] Z[prof] D[peck] R[ref] F[av]',
    parametros: [
      { letra: 'Z', descricao: 'Profundidade total' },
      { letra: 'D', descricao: 'Profundidade do peck' },
      { letra: 'R', descricao: 'Plano de referência' },
      { letra: 'F', descricao: 'Avanço de furação' },
    ],
    exemplo: 'S1500 M3 M8\nG2001 X80. Y40. Z-60. D12. R3. F200',
    explicacaoExemplo: 'Fura 60mm em passos de 12mm a 200mm/min com refrigeração no OSP Okuma.',
    isG: true,
  },

  {
    codigo: 'G205', nome: 'Ciclo de Mandrilamento OSP', categoria: 'Mandrilamento',
    maquina: 'Centro de Usinagem', fabricante: 'Okuma',
    descricao: 'Ciclo de mandrilamento com parada spindle e retração no OSP.',
    descricaoCompleta:
      'G205 executa mandrilamento fino no Okuma: avança até a profundidade, para o spindle ' +
      '(orientação precisa), recua levemente em XY (clearance) antes de retrair Z, ' +
      'evitando marcar a superfície interna. Exige função de parada de spindle orientado.',
    sintaxe: 'G205 X[x] Y[y] Z[prof] R[ref] Q[desvio_xy] F[av]',
    parametros: [
      { letra: 'Z', descricao: 'Profundidade de mandrilamento' },
      { letra: 'Q', descricao: 'Desvio de retração em XY para não marcar (ex: 0.1mm)' },
      { letra: 'F', descricao: 'Avanço de mandrilamento (lento para qualidade)' },
    ],
    exemplo: 'S800 M3 M8\nG205 X50. Y50. Z-30. R3. Q0.1 F40',
    explicacaoExemplo: 'Mandrilamento fino a 800rpm, 40mm/min, retrai 0.1mm antes de subir — acabamento H7.',
    isG: true,
  },

  {
    codigo: 'G253', nome: 'Ciclo de Torneamento Contorno — Okuma', categoria: 'Torneamento',
    maquina: 'Torno CNC', fabricante: 'Okuma',
    descricao: 'Ciclo de desbaste de contorno no torno Okuma OSP.',
    descricaoCompleta:
      'G253 executa desbaste de contorno em tornos Okuma. Similar ao G71 Fanuc mas com ' +
      'parâmetros no estilo OSP. Define o contorno final em um subprograma e o ciclo ' +
      'faz os passes de desbaste automaticamente com ap e offset lateral configuráveis.',
    sintaxe: 'G253 P[prog_contorno] D[ap] F[av] S[rpm]',
    parametros: [
      { letra: 'P', descricao: 'Número do subprograma com o contorno final' },
      { letra: 'D', descricao: 'Profundidade de corte por passe (ap)' },
      { letra: 'F', descricao: 'Avanço de desbaste' },
    ],
    exemplo: 'G253 P100 D1.5 F0.25 S1200',
    explicacaoExemplo: 'Desbaste de contorno com 1.5mm de ap e 0.25mm/rot de avanço, lendo perfil do subprog. 100.',
    isG: true,
  },

  
  
  

  {
    codigo: 'G120', nome: 'Ciclo de Fresamento de Ranhura — Mitsubishi', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'Mitsubishi',
    descricao: 'Ciclo de fresamento de ranhura (slot) no M700/M800.',
    descricaoCompleta:
      'G120 é o ciclo de fresamento de ranhura do Mitsubishi CNC. Define comprimento, largura, ' +
      'profundidade e estratégia de remoção de material automaticamente. Elimina a necessidade de ' +
      'programar passe a passe. Disponível a partir do M700V.',
    sintaxe: 'G120 X[x] Y[y] Z[prof] I[comp] J[larg] Q[passo] F[av]',
    parametros: [
      { letra: 'X, Y', descricao: 'Centro da ranhura' },
      { letra: 'Z', descricao: 'Profundidade final' },
      { letra: 'I', descricao: 'Comprimento da ranhura' },
      { letra: 'J', descricao: 'Largura da ranhura' },
      { letra: 'Q', descricao: 'Profundidade por passe (ap)' },
    ],
    exemplo: 'S2000 M3 M8\nG120 X50. Y30. Z-10. I60. J12. Q2. F200',
    explicacaoExemplo: 'Fresa ranhura 60×12mm com 2mm de passe até -10mm no centro X50 Y30.',
    isG: true,
  },

  {
    codigo: 'G180', nome: 'Ciclo de Rosqueamento — Mitsubishi M700', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Mitsubishi', diagramaTipo: 'rosca',
    descricao: 'Ciclo de rosqueamento rígido sincronizado no Mitsubishi M700/M800.',
    descricaoCompleta:
      'G180 executa rosqueamento rígido no Mitsubishi CNC com sincronização total entre spindle ' +
      'e eixo Z. O M800 suporta aceleração/desaceleração otimizada S-curve para minimizar ' +
      'estresse nas machos. Requer função de spindle encoder instalada.',
    sintaxe: 'G180 X[x] Y[y] Z[prof] R[ref] F[passo_×_RPM]',
    parametros: [
      { letra: 'Z', descricao: 'Profundidade da rosca' },
      { letra: 'R', descricao: 'Plano de aproximação' },
      { letra: 'F', descricao: 'F = RPM × passo da rosca' },
    ],
    exemplo: '; M8 × 1.25 a 600 RPM\nS600 M3\nG180 X50. Y50. Z-20. R3. F750\n; F = 600 × 1.25 = 750',
    explicacaoExemplo: 'Rosca M8×1.25 a 600rpm, F=750mm/min. Plano de retorno R3mm acima da peça.',
    isG: true,
  },

  {
    codigo: 'G76', nome: 'Ciclo de Rosca Fina (Torno) — Mitsubishi', categoria: 'Rosqueamento',
    maquina: 'Torno CNC', fabricante: 'Mitsubishi', diagramaTipo: 'rosca',
    descricao: 'Ciclo de rosqueamento de torneamento multi-passe no M700.',
    descricaoCompleta:
      'G76 no Mitsubishi M700/M800 executa rosqueamento externo/interno em múltiplos passes ' +
      'com redução automática de profundidade. Parâmetros de ângulo de entrada (0° ou 29°/30°) ' +
      'para rosca métrica ou NPT. Compatível com Fanuc G76 mas com parâmetros adicionais.',
    sintaxe: 'G76 P[passes_ângulo_mínimo] Q[prof_mín] R[folga_acabamento]\nG76 X[diâm_menor] Z[prof] P[altura_rosca] Q[1ºpasse] F[passo]',
    parametros: [
      { letra: 'P (1ª linha)', descricao: 'Número de passes acabamento + ângulo + profundidade mínima' },
      { letra: 'X', descricao: 'Diâmetro menor da rosca' },
      { letra: 'F', descricao: 'Passo da rosca em mm' },
    ],
    exemplo: '; Rosca M30 × 3.5\nG76 P021060 Q100 R100\nG76 X27.402 Z-45. P1299 Q400 F3.5',
    explicacaoExemplo: 'Rosca M30×3.5: 2 passes de acabamento, ângulo 60°, diâmetro menor 27.402mm, prof. total 1.299mm, 1° passe 0.4mm.',
    isG: true,
  },

  {
    codigo: 'G37', nome: 'Medição Automática de Ferramenta — Mitsubishi', categoria: 'Medição',
    maquina: 'Centro de Usinagem', fabricante: 'Mitsubishi',
    descricao: 'Ciclo de medição automática do comprimento de ferramenta no M700/M800.',
    descricaoCompleta:
      'G37 aciona o ciclo de medição automática de comprimento de ferramenta no Mitsubishi. ' +
      'Move a ferramenta até o sensor TLS (Tool Length Sensor) e registra automaticamente o ' +
      'offset H no registro de ferramentas. Elimina erros de setup manual.',
    sintaxe: 'G37 H[num_offset] Z[pos_sensor]',
    parametros: [
      { letra: 'H', descricao: 'Número do offset a ser atualizado' },
      { letra: 'Z', descricao: 'Posição Z aproximada do sensor de comprimento' },
    ],
    exemplo: 'T5 M6\nG37 H5 Z-350.\n; Offset H5 atualizado automaticamente',
    explicacaoExemplo: 'Após troca da ferramenta T5, G37 move até sensor em Z-350 e atualiza H5 automaticamente.',
    isG: true,
  },

  
  
  

  {
    codigo: 'G341', nome: 'Ciclo de Rosqueamento — Brother Speedio', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', diagramaTipo: 'rosca',
    descricao: 'Rosqueamento rígido de alta velocidade no Brother Speedio.',
    descricaoCompleta:
      'G341 é o ciclo de rosqueamento rígido do Brother Speedio. Otimizado para alta velocidade, ' +
      'com spindle que pode atingir 16.000 RPM. O sincronismo spindle-Z é tão preciso que machos ' +
      'rígidos sem compensação axial são usados em produção. Muito usado em linhas de usinagem de alumínio.',
    sintaxe: 'G341 X[x] Y[y] Z[prof] R[ref] F[avanço]',
    parametros: [
      { letra: 'Z', descricao: 'Profundidade da rosca' },
      { letra: 'R', descricao: 'Plano de aproximação' },
      { letra: 'F', descricao: 'Avanço = RPM × passo' },
    ],
    exemplo: '; Rosca M5 × 0.8 a 4000 RPM — Alumínio\nS4000 M3\nG341 X25. Y25. Z-15. R2. F3200\n; F = 4000 × 0.8 = 3200',
    explicacaoExemplo: 'Rosqueia M5×0.8 a 4000rpm em alumínio. F=3200mm/min. Máx. velocidade é diferencial do Speedio.',
    isG: true,
  },

  {
    codigo: 'G343', nome: 'Ciclo de Furação Profunda — Brother', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação profunda com peck no controle Brother CNC-C00.',
    descricaoCompleta:
      'G343 executa furação profunda com pecking no Brother Speedio. Projetado para máquinas de ' +
      'alta velocidade, o ciclo otimiza a aceleração/desaceleração do eixo Z para minimizar tempo ' +
      'de ciclo. Aceita Q para peck mínimo e retração parcial para quebra de cavaco.',
    sintaxe: 'G343 X[x] Y[y] Z[prof] R[ref] Q[peck] F[av]',
    parametros: [
      { letra: 'Z', descricao: 'Profundidade total' },
      { letra: 'Q', descricao: 'Profundidade do peck' },
      { letra: 'R', descricao: 'Plano de referência' },
      { letra: 'F', descricao: 'Avanço de furação' },
    ],
    exemplo: 'S5000 M3 M8\nG343 X50. Y50. Z-30. R2. Q5. F600',
    explicacaoExemplo: 'Fura 30mm em passos de 5mm a 5000rpm/600mm/min no Speedio — alumínio em alta velocidade.',
    isG: true,
  },

  {
    codigo: 'G241', nome: 'Ciclo de Furação Simples — Brother Speedio', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', diagramaTipo: 'furar',
    descricao: 'Ciclo de furação direta de alta velocidade no Brother Speedio.',
    descricaoCompleta:
      'G241 é o ciclo de furação direta (sem peck) do Brother Speedio. Otimizado para ciclos ' +
      'curtos em alumínio — a máquina pode executar mais de 600 furos/minuto em determinadas ' +
      'condições. A aceleração do eixo Z é gerenciada pelo controle CNC-C00 para máximo throughput.',
    sintaxe: 'G241 X[x] Y[y] Z[prof] R[ref] F[av]',
    parametros: [
      { letra: 'Z', descricao: 'Profundidade do furo' },
      { letra: 'R', descricao: 'Plano de referência' },
      { letra: 'F', descricao: 'Avanço de furação' },
    ],
    exemplo: 'S8000 M3 M8\nG241 Z-8. R2. F1200\nX10. Y10.\nX20. Y10.\nX30. Y10.',
    explicacaoExemplo: 'Fura posições múltiplas a 8000rpm/1200mm/min — ciclo puro sem peck para furos rasos em alumínio.',
    isG: true,
  },

  
  
  

  {
    codigo: 'CYCL DEF 20', nome: 'Dados do Contorno — DMG TNC 640', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'DMG',
    descricao: 'Define dados globais para ciclos de fresamento de contorno no TNC 640.',
    descricaoCompleta:
      'CYCL DEF 20 define parâmetros globais usados pelos ciclos de contorno (CYCL 21, 22, 23, 24) ' +
      'no Heidenhain TNC 640 (controle padrão dos centros DMG MORI de 5 eixos). ' +
      'Parâmetros: profundidade total, sobremedida de acabamento, passo (ap), velocidade de retração. ' +
      'Deve ser programado antes de CYCL DEF 21/22.',
    sintaxe: 'CYCL DEF 20.0 DADOS DO CONTORNO\nCYCL DEF 20.1 PROF=-[z] ~\n    PASSO=[ap] ~\n    SOBREMEDIDA=[delta]',
    parametros: [
      { letra: 'PROF', descricao: 'Profundidade total de fresamento (negativo)' },
      { letra: 'PASSO', descricao: 'Profundidade por passe (ap)' },
      { letra: 'SOBREMEDIDA', descricao: 'Sobremedida para acabamento posterior (geralmente 0.2-0.5mm)' },
    ],
    exemplo: 'CYCL DEF 20.0 DADOS DO CONTORNO\nCYCL DEF 20.1 PROF=-25 ~\n    PASSO=4 ~\n    SOBREMEDIDA=0.3\n\nCYCL DEF 22.0 DESBASTE\nCYCL DEF 22.1 PROF=-25 ~\n    PASSO=4',
    explicacaoExemplo: 'Define desbaste a -25mm em passos de 4mm com 0.3mm de sobremedida para acabamento final.',
    isG: false,
  },

  {
    codigo: 'CYCL DEF 22', nome: 'Desbaste de Cavidade — DMG TNC 640', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'DMG', diagramaTipo: 'linear',
    descricao: 'Ciclo de desbaste de cavidade (bolsão) no TNC 640 dos centros DMG MORI.',
    descricaoCompleta:
      'CYCL DEF 22 executa desbaste de bolsões e contornos no TNC 640. Usa a estratégia de ' +
      'trocoidal ou zig-zag automaticamente. Deve ser antecedido pelo CYCL DEF 20 (dados do contorno) ' +
      'e o contorno deve ser definido com LBL (label) no programa.',
    sintaxe: 'CYCL DEF 22.0 DESBASTE\nCYCL DEF 22.1 PROF=-[z] ~\n    PASSO=[ap] ~\n    FRESA-RAIO-ACABAM.=[delta]',
    parametros: [
      { letra: 'PROF', descricao: 'Profundidade total' },
      { letra: 'PASSO', descricao: 'Passo axial por nível' },
      { letra: 'FRESA-RAIO-ACABAM.', descricao: 'Raio da fresa de acabamento (para calcular sobremedida lateral)' },
    ],
    exemplo: 'CYCL DEF 22.0 DESBASTE\nCYCL DEF 22.1 PROF=-20 ~\n    PASSO=5 ~\n    FRESA-RAIO-ACABAM.=6\n\nLBL 1 ; Contorno do bolsão\nL X-30 Y-20 RL\nL X+30 Y-20\nL X+30 Y+20\nL X-30 Y+20\nL X-30 Y-20\nLBL 0\n\nCYCL CALL',
    explicacaoExemplo: 'Desbaste bolsão 60×40mm a -20mm em passos de 5mm, com fresa de acabamento Ø12mm para calcular sobremedida lateral.',
    isG: false,
  },

  {
    codigo: 'CYCL DEF 251', nome: 'Fresamento de Bolsão Retangular — DMG', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'DMG', diagramaTipo: 'linear',
    descricao: 'Ciclo de bolsão retangular completo (desbaste + acabamento) no TNC 640.',
    descricaoCompleta:
      'CYCL DEF 251 é um ciclo completo de bolsão retangular no Heidenhain TNC 640. ' +
      'Faz desbaste e acabamento (lateral e fundo) em um único ciclo. Aceita cantos com raio, ' +
      'ângulo de rotação do bolsão e sobrepasse. Excelente para plaquinhas de fixação e cavidades retangulares.',
    sintaxe: 'CYCL DEF 251.0 BOLSÃO RETANGULAR\nCYCL DEF 251.1 COMP.=[l] ~\n    LARGURA=[w] ~\n    PROF.=[z] ~\n    RAIO=[r] ~\n    ANG.=[ang]',
    parametros: [
      { letra: 'COMP.', descricao: 'Comprimento do bolsão (eixo X)' },
      { letra: 'LARGURA', descricao: 'Largura do bolsão (eixo Y)' },
      { letra: 'PROF.', descricao: 'Profundidade total (negativo)' },
      { letra: 'RAIO', descricao: 'Raio de canto do bolsão' },
      { letra: 'ANG.', descricao: 'Ângulo de rotação do bolsão (°)' },
    ],
    exemplo: 'CYCL DEF 251.0 BOLSÃO RETANGULAR\nCYCL DEF 251.1 COMP.=80 ~\n    LARGURA=50 ~\n    PROF.=-15 ~\n    RAIO=5 ~\n    ANG.=0\n\nL X+0 Y+0 FMAX\nCYCL CALL',
    explicacaoExemplo: 'Bolsão retangular 80×50mm, profundidade 15mm, cantos R5, ângulo 0° — ciclo completo desbaste+acabamento.',
    isG: false,
  },

  {
    codigo: 'CYCL DEF 253', nome: 'Fresamento de Ranhura — DMG TNC 640', categoria: 'Fresamento',
    maquina: 'Centro de Usinagem', fabricante: 'DMG',
    descricao: 'Ciclo de fresamento de ranhura (slot) no TNC 640 dos centros DMG MORI.',
    descricaoCompleta:
      'CYCL DEF 253 fresa ranhuras retas no TNC 640. Define comprimento, largura e profundidade ' +
      'automaticamente. A estratégia de corte pode ser pendular (passo a passo) ou helicoidal. ' +
      'Acabamento lateral e de fundo incluídos no mesmo ciclo.',
    sintaxe: 'CYCL DEF 253.0 FRESAMENTO RANHURA\nCYCL DEF 253.1 COMP.=[l] ~\n    PROF.=[z] ~\n    PASSO=[ap] ~\n    ANG.=[ang]',
    parametros: [
      { letra: 'COMP.', descricao: 'Comprimento da ranhura' },
      { letra: 'PROF.', descricao: 'Profundidade' },
      { letra: 'PASSO', descricao: 'Profundidade por passe' },
      { letra: 'ANG.', descricao: 'Ângulo de orientação da ranhura' },
    ],
    exemplo: 'CYCL DEF 253.0 FRESAMENTO RANHURA\nCYCL DEF 253.1 COMP.=60 ~\n    PROF.=-10 ~\n    PASSO=3 ~\n    ANG.=0\n\nL X+50 Y+30 FMAX\nCYCL CALL',
    explicacaoExemplo: 'Fresa ranhura 60mm de comprimento, -10mm de profundidade em passos de 3mm, ângulo 0°.',
    isG: false,
  },

  {
    codigo: 'PLANE SPATIAL', nome: 'Inclinação de Plano 5 Eixos — DMG TNC 640', categoria: 'Multi-eixo',
    maquina: 'Centro de Usinagem', fabricante: 'DMG',
    descricao: 'Define plano de usinagem inclinado por ângulos espaciais no TNC 640 (5 eixos).',
    descricaoCompleta:
      'PLANE SPATIAL é a função principal de inclinação de plano do Heidenhain TNC 640, ' +
      'padrão nos centros DMG MORI de 5 eixos. Define o plano de trabalho por ângulos de rotação ' +
      'espacial (SPA, SPB, SPC) permitindo usinar superfícies inclinadas sem recalcular coordenadas. ' +
      'O TNC 640 calcula automaticamente as posições A/B/C dos eixos rotativos.',
    sintaxe: 'PLANE SPATIAL SPA+[a] SPB+[b] SPC+[c] TURN FMAX',
    parametros: [
      { letra: 'SPA', descricao: 'Rotação espacial em torno do eixo X (°)' },
      { letra: 'SPB', descricao: 'Rotação espacial em torno do eixo Y (°)' },
      { letra: 'SPC', descricao: 'Rotação espacial em torno do eixo Z (°)' },
      { letra: 'TURN', descricao: 'Move os eixos rotativos para a posição calculada' },
    ],
    exemplo: '; Usinar face inclinada 45° em Y\nPLANE SPATIAL SPA+0 SPB+45 SPC+0 TURN FMAX\n; Coordenadas agora no plano inclinado\nL X+0 Y+0 Z+5 FMAX\nL Z-5 F300',
    explicacaoExemplo: 'Inclina o plano de trabalho 45° em torno de Y. As coordenadas programadas após passam a ser relativas ao plano inclinado.',
    isG: false,
  },

  
  
  

  {
    codigo: 'G10', nome: 'Entrada de Dados por Programa (Fanuc)', categoria: 'Offsets',
    maquina: 'Ambos', fabricante: 'Fanuc', diagramaTipo: 'referencia',
    descricao: 'Define ou corrige offsets de ferramenta e work offsets diretamente dentro do programa NC.',
    descricaoCompleta:
      'G10 permite que o programa CNC escreva valores diretamente nas tabelas de offsets (compensação de ferramenta, work offsets G54-G59, parâmetros). ' +
      'Essencial em sistemas com apalpadores — o macro mede a peça e usa G10 para corrigir o offset automaticamente sem intervenção humana. ' +
      'L: seleciona a tabela (1=geom.tool, 10=wear, 20=work offset). ' +
      'P: número do offset (P1=H1, P54=G54...). ' +
      'R: valor a definir. ' +
      'Q: eixo (1=X, 2=Y, 3=Z).',
    sintaxe: 'G10 L[n] P[offset] X[val] Y[val] Z[val] R[val]',
    parametros: [
      { letra: 'L1', descricao: 'Tabela de geometria de ferramenta (Length H)' },
      { letra: 'L10', descricao: 'Tabela de desgaste de ferramenta' },
      { letra: 'L2', descricao: 'Work offset — G54 a G59 (P1=G54, P2=G55 … P6=G59)' },
      { letra: 'P', descricao: 'Número do offset na tabela selecionada' },
      { letra: 'X/Y/Z/R', descricao: 'Valor absoluto a gravar no offset' },
    ],
    exemplo:
      '; Corrigir G54 Z-offset automaticamente\n' +
      'G10 L2 P1 Z-152.450  ; Grava Z=-152.45 no G54\n\n' +
      '; Corrigir desgaste da ferramenta T1\n' +
      'G10 L10 P1 R0.05      ; Adiciona 0.05mm ao wear H1',
    explicacaoExemplo:
      'Primeiro comando atualiza G54 Z sem ir para a página de offsets. Segundo ajusta desgaste de T1 em 0.05mm. Muito usado em sistemas com medição automática (skip G31).',
    isG: true,
  },

  {
    codigo: 'G31', nome: 'Função Skip (Apalpador / Probe)', categoria: 'Apalpador',
    maquina: 'Ambos', fabricante: 'Fanuc', diagramaTipo: 'referencia',
    descricao: 'Move o eixo até que o sinal de skip (apalpador) seja recebido, armazenando a posição em variáveis de macro.',
    descricaoCompleta:
      'G31 é o código de movimento com skip usado com apalpadores de toque. O eixo move na direção programada com o avanço especificado. ' +
      'Quando o apalpador encosta na peça e gera o sinal de skip, o movimento para e a posição é salva em variáveis de macro (#5061=X, #5062=Y, #5063=Z). ' +
      'Essa posição pode ser usada para calcular o offset ou compensação automaticamente. ' +
      'Essencial em sistemas de medição na máquina (Renishaw, Marposs, Blum).',
    sintaxe: 'G31 X[destino] Y[destino] Z[destino] F[avanço]',
    parametros: [
      { letra: 'X/Y/Z', descricao: 'Posição de destino (o movimento para antes se houver skip)' },
      { letra: 'F', descricao: 'Avanço de apalpação (tipicamente 50-200 mm/min)' },
      { letra: '#5061', descricao: 'Macro: posição X no momento do skip' },
      { letra: '#5062', descricao: 'Macro: posição Y no momento do skip' },
      { letra: '#5063', descricao: 'Macro: posição Z no momento do skip' },
    ],
    exemplo:
      'G91 G31 Z-50. F100    ; Move Z até skip (máx 50mm)\n' +
      '#100 = #5063          ; Salva posição Z do toque\n' +
      'G10 L2 P1 Z[#100]     ; Atualiza G54 Z com valor medido',
    explicacaoExemplo:
      'O apalpador toca a superfície da peça em Z. A posição é capturada em #5063 e imediatamente gravada em G54 Z com G10. Elimina erro humano no setup.',
    isG: true,
  },

  {
    codigo: 'G65', nome: 'Chamada de Macro (Fanuc Custom Macro B)', categoria: 'Macro',
    maquina: 'Ambos', fabricante: 'Fanuc', diagramaTipo: 'referencia',
    descricao: 'Chama uma subrotina de macro com passagem de argumentos — permite loops, cálculos e programação paramétrica.',
    descricaoCompleta:
      'G65 chama um programa O (subprograma de macro) passando argumentos pelas letras A-Z. ' +
      'As variáveis de macro (#1-#26) recebem os valores dos argumentos dentro da subrotina. ' +
      'Diferente de M98 (subprograma simples), o G65 permite passar parâmetros. ' +
      'Usado para ciclos customizados, furação em padrão, apalpação, cálculos trigonométricos, etc. ' +
      'Variáveis locais #1-#33, comuns #100-#149, globais #500-#599, do sistema #5001+.',
    sintaxe: 'G65 P[Oprog] A[val] B[val] C[val] ... Z[val]',
    parametros: [
      { letra: 'P', descricao: 'Número do programa de macro a chamar (ex: P9010)' },
      { letra: 'A→Z', descricao: 'Argumentos — A=#1, B=#2, C=#3, I=#4, J=#5, K=#6, D=#7, E=#8, F=#9...' },
      { letra: '#1-#26', descricao: 'Variáveis locais que recebem os argumentos' },
      { letra: '#100-#149', descricao: 'Variáveis comuns — persistem entre chamadas' },
    ],
    exemplo:
      '; Chamar macro O9010 para furar PCD\n' +
      'G65 P9010 A50. B6 C0.  ; Diâm=50, N furos=6, Ang inicial=0\n\n' +
      '; Dentro do O9010:\n' +
      '; #1=diâmetro PCD, #2=N furos, #3=ângulo inicial\n' +
      '; #10 = 360 / #2  ; passo angular\n' +
      '; WHILE [#4 LE #2] DO1 ...',
    explicacaoExemplo:
      'Chama macro O9010 passando diâmetro 50mm, 6 furos e ângulo 0°. A macro calcula posições e fura automaticamente.',
    isG: true,
  },

  {
    codigo: 'G68', nome: 'Rotação de Coordenadas (Fanuc)', categoria: 'Transformação',
    maquina: 'Centro de Usinagem', fabricante: 'Fanuc', diagramaTipo: 'espelhamento',
    descricao: 'Rotaciona o sistema de coordenadas pelo ângulo especificado — usina contornos rotacionados sem reprogramar.',
    descricaoCompleta:
      'G68 ativa a rotação do sistema de coordenadas. Todos os movimentos programados após G68 são executados com o sistema rotacionado. ' +
      'O centro de rotação é definido por X e Y. O ângulo R define a rotação (positivo = anti-horário). ' +
      'Cancelado por G69. Permite usar o mesmo contorno em diferentes ângulos sem duplicar código. ' +
      'Combinado com G51 (escala) cria peças simétricas com variações de tamanho.',
    sintaxe: 'G68 X[cx] Y[cy] R[ângulo]  ...código...  G69',
    parametros: [
      { letra: 'X', descricao: 'Coordenada X do centro de rotação' },
      { letra: 'Y', descricao: 'Coordenada Y do centro de rotação' },
      { letra: 'R', descricao: 'Ângulo de rotação em graus (+ = anti-horário, - = horário)' },
      { letra: 'G69', descricao: 'Cancela a rotação de coordenadas' },
    ],
    exemplo:
      'G68 X0 Y0 R45.   ; Rotaciona 45° em torno da origem\n' +
      'G0 X30. Y0\n' +
      'G1 Z-5. F200\n' +
      'G1 X50. Y20.\n' +
      'G69               ; Cancela rotação',
    explicacaoExemplo:
      'Rotaciona o sistema 45°. O perfil programado em X/Y é executado com esse giro. Ideal para peças com ranhuras anguladas ou simetria rotacional.',
    isG: true,
  },

  
  
  

  {
    codigo: 'CYCLE840', nome: 'Rosqueamento com Compensação — Siemens', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Siemens', diagramaTipo: 'rosca',
    descricao: 'Ciclo de rosqueamento com macho com mandril de compensação — sincronizado ou flutuante.',
    descricaoCompleta:
      'CYCLE840 é o ciclo de rosqueamento por macho do Siemens 828D/840D. Suporta dois modos: ' +
      'VARI=0 = mandril flutuante (compensador), onde o spindle e o avanço não precisam ser perfeitamente sincronizados. ' +
      'VARI=1 = rosqueamento rígido — spindle e eixo Z sincronizados (M29 no Fanuc). ' +
      'SDR define a direção: 0=horário (M03), 1=anti-horário (M04). ' +
      'SDAC mantém o spindle após o ciclo. ' +
      'MPIT define o passo pela denominação M (M6=passo 1mm, M8=1.25mm, etc.) OU PIT define passo direto.',
    sintaxe: 'CYCLE840(RTP, RFP, SDIS, DP, DPR, DTB, SDR, SDAC, ENC, MPIT, PIT)',
    parametros: [
      { letra: 'RTP', descricao: 'Plano de retorno' },
      { letra: 'RFP', descricao: 'Plano de referência (superfície)' },
      { letra: 'SDIS', descricao: 'Distância de segurança' },
      { letra: 'DP / DPR', descricao: 'Profundidade final / relativa' },
      { letra: 'SDR', descricao: 'Sentido: 0=M03 (direita), 1=M04 (esquerda)' },
      { letra: 'SDAC', descricao: 'Estado do spindle ao fim: 3=M03, 4=M04, 5=M05' },
      { letra: 'ENC', descricao: '0=mandril flutuante, 1=rosqueamento rígido' },
      { letra: 'MPIT/PIT', descricao: 'Tamanho M (MPIT) ou passo em mm (PIT)' },
    ],
    exemplo:
      'T2 D1\nS600 M3\nG0 X0. Y0.\nCYCLE840(50.,0.,3.,-20.,,0.5,0,3,1,,1.5)\nM30',
    explicacaoExemplo:
      'Rosqueia M??×1.5 em modo rígido (ENC=1), direção horária, profundidade 20mm, pausa 0.5s no fundo. Spindle continua M03 após o ciclo.',
    isG: false,
  },

  {
    codigo: 'TRANS / ATRANS', nome: 'Translação de Coordenadas — Siemens', categoria: 'Transformação',
    maquina: 'Ambos', fabricante: 'Siemens', diagramaTipo: 'referencia',
    descricao: 'Desloca a origem do sistema de coordenadas — TRANS absoluto, ATRANS adicional (acumula).',
    descricaoCompleta:
      'TRANS desloca absolutamente a origem de trabalho. ATRANS adiciona um deslocamento sobre o atual. ' +
      'Equivale ao G52 do Fanuc (local coordinate system). ' +
      'Permite programar um contorno na origem e depois deslocá-lo para múltiplas posições sem reprogramar. ' +
      'TRANS com todos zeros cancela o deslocamento ativo (como G52 X0 Y0 Z0 no Fanuc). ' +
      'Pode ser combinado com ROT (rotação) e SCALE (escala) na mesma linha.',
    sintaxe: 'TRANS X[dx] Y[dy] Z[dz]\nATRANS X[dx] Y[dy] Z[dz]',
    parametros: [
      { letra: 'TRANS X/Y/Z', descricao: 'Define deslocamento absoluto da origem' },
      { letra: 'ATRANS X/Y/Z', descricao: 'Adiciona deslocamento ao atual (acumulativo)' },
      { letra: 'TRANS', descricao: 'Sem parâmetros — cancela todos os frames ativos' },
    ],
    exemplo:
      'TRANS X50. Y30.       ; Origem em X50 Y30\n' +
      '; Programar furo na "nova origem"\n' +
      'G0 X0 Y0\nCYCLE82(10.,0.,3.,-15.,,0.)\n' +
      'ATRANS X30.           ; Desloca +30mm em X\n' +
      'CYCLE82(10.,0.,3.,-15.,,0.)\n' +
      'TRANS                 ; Cancela translação',
    explicacaoExemplo:
      'Furos idênticos em duas posições deslocadas 30mm em X. O código do ciclo é escrito uma única vez.',
    isG: false,
  },

  {
    codigo: 'CYCLE95', nome: 'Ciclo de Desbaste de Contorno — Siemens Torno', categoria: 'Torneamento',
    maquina: 'Torno CNC', fabricante: 'Siemens', diagramaTipo: 'linear',
    descricao: 'Ciclo de desbaste de contorno para torno CNC Siemens — equivale ao G71 do Fanuc.',
    descricaoCompleta:
      'CYCLE95 faz o desbaste de um perfil definido por um subprograma ou contorno embutido. ' +
      'Equivale ao G71/G72 do Fanuc. ' +
      'NPP = nome do subprograma que define o contorno final. ' +
      'MID = profundidade de corte por passada (ap). ' +
      'FALZ = sobremedida axial para acabamento. ' +
      'FALX = sobremedida radial para acabamento. ' +
      'FAL = sobremedida geral se FALZ/FALX não usados. ' +
      'FF1 = avanço de desbaste, FF2 = avanço de chanfro/raio, FF3 = avanço de acabamento. ' +
      'VARI = modo de usinagem (1=ext.long., 2=ext.front., 3=int.long., 4=int.front., +8=acabamento).',
    sintaxe: 'CYCLE95(NPP, MID, FALZ, FALX, FAL, FF1, FF2, FF3, VARI, DT, DAM, VRT)',
    parametros: [
      { letra: 'NPP', descricao: 'Nome do subprograma/label do contorno (string entre aspas)' },
      { letra: 'MID', descricao: 'Profundidade de corte por passe (ap)' },
      { letra: 'FALZ', descricao: 'Sobremedida axial para acabamento' },
      { letra: 'FALX', descricao: 'Sobremedida radial para acabamento' },
      { letra: 'FF1', descricao: 'Avanço de desbaste (mm/rot)' },
      { letra: 'VARI', descricao: '1=ext.longitudinal, 2=ext.frontal, +8=só acabamento' },
    ],
    exemplo:
      'T1 D1\nG96 S200 LIMS=2500 M4\nG0 X82. Z5.\n' +
      'CYCLE95("PERFIL",2.,0.2,0.15,,0.3,,0.1,1)\n\n' +
      'PERFIL:\nG1 X20. Z0\nG1 X20. Z-30.\nG1 X40. Z-45.\nG1 X40. Z-70.\nG1 X80. Z-80.\nRET',
    explicacaoExemplo:
      'Desbaste externo longitudinal com ap=2mm, sobremedida Z=0.2, X=0.15mm. O contorno "PERFIL" define o perfil final com chanfro e escalonamento.',
    isG: false,
  },

  
  
  

  {
    codigo: 'G47', nome: 'Gravação de Texto — Haas', categoria: 'Especial',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'linear',
    descricao: 'Grava texto alfanumérico diretamente na peça usando uma ferramenta de gravação.',
    descricaoCompleta:
      'G47 é exclusivo das máquinas Haas e permite gravar texto, números e caracteres especiais diretamente na peça. ' +
      'A ferramenta (tipicamente uma ponta de gravação cônica ou fresa de letra) percorre as letras automaticamente. ' +
      'A altura do texto é controlada pelo endereço H. ' +
      'O texto é colocado entre aspas após o endereço E. ' +
      'Útil para gravar número de série, código da peça ou data de fabricação diretamente no ciclo CNC.',
    sintaxe: 'G47 P[modo] E"[TEXTO]" X[x] Y[y] Z[z] F[av] H[altura]',
    parametros: [
      { letra: 'P1', descricao: 'Modo de gravação padrão' },
      { letra: 'E"TEXTO"', descricao: 'Texto a gravar (alfanumérico entre aspas)' },
      { letra: 'X/Y', descricao: 'Posição inicial do texto' },
      { letra: 'Z', descricao: 'Profundidade de gravação (negativo)' },
      { letra: 'F', descricao: 'Avanço de gravação' },
      { letra: 'H', descricao: 'Altura das letras em mm' },
    ],
    exemplo:
      'T5 M6 ; Fresa de gravação Ø3\nS3000 M3\nG0 G90 G54 X0 Y0\nG43 H5 Z20.\n' +
      'G47 P1 E"SN-2024-001" X10. Y15. Z-0.3 F500 H5.',
    explicacaoExemplo:
      'Grava o número de série "SN-2024-001" a partir de X10 Y15, profundidade 0.3mm, letras de 5mm de altura. Ótimo para rastreabilidade de peças.',
    isG: true,
  },

  {
    codigo: 'G188', nome: 'Tool Life Management — Haas', categoria: 'Gerenciamento',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'referencia',
    descricao: 'Habilita o gerenciamento de vida de ferramenta por número de peças ou minutos de corte no controle Haas.',
    descricaoCompleta:
      'G188 ativa o gerenciamento de vida de ferramenta do Haas. Trabalha com a tabela de ferramentas do controle ' +
      '(Tool Life Management). Cada ferramenta tem um contador de uso. Quando atinge o limite, ' +
      'o Haas troca automaticamente por uma ferramenta irmã (sister tool) ou emite alerta. ' +
      'O limite pode ser em número de usos (peças) ou tempo de corte. ' +
      'Requer configuração prévia na página de ferramentas do controle Haas.',
    sintaxe: 'T[n] M6\nG188          ; Ativa verificação de vida\n...\nG189          ; Cancela verificação',
    parametros: [
      { letra: 'G188', descricao: 'Ativa o controle de vida de ferramenta' },
      { letra: 'G189', descricao: 'Cancela o controle de vida de ferramenta' },
      { letra: 'Tool Life', descricao: 'Configurado na página de ferramentas do controle Haas' },
    ],
    exemplo:
      'T1 M6        ; Chama ferramenta T1\nG188         ; Verifica vida — troca para irmã se necessário\nG0 G90 G54 X0 Y0\nG43 H1 Z20.\n...\nG189         ; Fim da verificação de vida',
    explicacaoExemplo:
      'Após T1 M6, G188 verifica se T1 ainda está dentro da vida. Se já esgotada, o Haas usa a ferramenta irmã configurada automaticamente.',
    isG: true,
  },

  {
    codigo: 'G116', nome: 'Fresamento de Rosca Helicoidal — Haas', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Haas', diagramaTipo: 'rosca',
    descricao: 'Fresa uma rosca helicoidal em material sólido usando interpolação helicoidal — alternativa ao macho.',
    descricaoCompleta:
      'G116 realiza fresamento de rosca: a fresa de rosca (thread mill) interpola helicoidalmente dentro do furo ' +
      'para criar a rosca. Permite roscar materiais difíceis (inox, titânio) onde macho quebraria. ' +
      'Um único passe cria a rosca completa (fresa multilinha) ou múltiplos passes (fresa de 1 linha). ' +
      'O passo da rosca = pitch = deslocamento Z por volta. ' +
      'Vantagens: fura e rosqueia em sequência; se fresa quebrar, não trava; ' +
      'uma fresa cobre múltiplos tamanhos de rosca (diferente do macho).',
    sintaxe: 'G116 X[x] Y[y] Z[z] I[raio] P[passo] F[avanço]',
    parametros: [
      { letra: 'X/Y', descricao: 'Centro do furo a rosquear' },
      { letra: 'Z', descricao: 'Profundidade final da rosca' },
      { letra: 'I', descricao: 'Raio de aproximação helicoidal' },
      { letra: 'P', descricao: 'Passo da rosca (pitch) em mm ou polegadas' },
      { letra: 'F', descricao: 'Avanço de fresamento de rosca' },
    ],
    exemplo:
      '; Fresar rosca M16×2 em furo Ø14 pré-furado\n' +
      'T3 M6    ; Thread mill Ø12\n' +
      'S1200 M3\nG0 G54 X50. Y50.\nG43 H3 Z5.\n' +
      'G116 X50. Y50. Z-22. I2.0 P2.0 F400',
    explicacaoExemplo:
      'Fresa rosca M16×2 (passo 2mm) a 22mm de profundidade no centro X50 Y50. Raio de entrada helicoidal 2mm. Usado para roscas em inox e titânio.',
    isG: true,
  },

  
  
  

  {
    codigo: 'G161', nome: 'Usinagem de Alta Velocidade (HSM) — Mazak', categoria: 'Alta Velocidade',
    maquina: 'Centro de Usinagem', fabricante: 'Mazak',
    descricao: 'Ativa modo de alta velocidade com suavização de trajetória e look-ahead — Mazak SmoothG.',
    descricaoCompleta:
      'G161 ativa o modo de alta velocidade (HSM) do Mazak SmoothG. ' +
      'O controle usa look-ahead de até 200 blocos para antecipar mudanças de direção e calcular a trajetória mais suave. ' +
      'A desaceleração em cantos é automática. ' +
      'G162 ativa o modo de alta precisão (contrário — prioriza precisão, não velocidade). ' +
      'G160 cancela G161/G162 voltando ao modo padrão. ' +
      'Em moldes e peças de forma complexa, G161 pode reduzir o tempo de usinagem em 40-60%.',
    sintaxe: 'G161  ; Modo alta velocidade\nG162  ; Modo alta precisão\nG160  ; Cancela',
    parametros: [
      { letra: 'G161', descricao: 'Ativa suavização de trajetória para alta velocidade' },
      { letra: 'G162', descricao: 'Ativa controle de precisão (menor erro de contorno)' },
      { letra: 'G160', descricao: 'Cancela G161/G162 — modo padrão' },
    ],
    exemplo:
      'G161           ; Ativar HSM\n' +
      'S12000 M3\n' +
      'G0 G54 X0 Y0\n' +
      'G43 H1 Z5.\n' +
      '; ... Código de usinagem de superfície ...\n' +
      'G160           ; Desativar HSM',
    explicacaoExemplo:
      'Ativa HSM antes de usinagem de superfície de forma livre. O Mazak antecipa curvas e mantém o avanço programado mesmo em geometrias complexas.',
    isG: true,
  },

  
  
  

  {
    codigo: 'CYCL DEF 220', nome: 'Padrão Circular de Furos — Heidenhain', categoria: 'Padrão',
    maquina: 'Centro de Usinagem', fabricante: 'Heidenhain', diagramaTipo: 'furar',
    descricao: 'Define e executa um padrão circular de furos (PCD — Pitch Circle Diameter) no TNC.',
    descricaoCompleta:
      'CYCL DEF 220 define um PCD (Pitch Circle Diameter) — conjunto de furos igualmente espaçados em círculo. ' +
      'Após definir o ciclo de furação (CYCL DEF 200 ou CYCL DEF 83 por exemplo), ' +
      'o CYCL DEF 220 executa-o em todos os pontos do padrão circular. ' +
      'Parâmetros: centro do círculo, raio, ângulo inicial, número de furos. ' +
      'Extremamente eficiente para flange, tampas, bases com furos de fixação em círculo.',
    sintaxe:
      'CYCL DEF 220.0 PADRÃO CIRCULAR\n' +
      'CYCL DEF 220.1 CENTRO X=[cx] ~\n' +
      '    CENTRO Y=[cy] ~\n' +
      '    RAIO=[r] ~\n' +
      '    ANG.=[ang0] ~\n' +
      '    QUANTIDADE=[n]',
    parametros: [
      { letra: 'CENTRO X/Y', descricao: 'Centro do círculo do padrão' },
      { letra: 'RAIO', descricao: 'Raio do PCD (não diâmetro)' },
      { letra: 'ANG.', descricao: 'Ângulo do primeiro furo (°)' },
      { letra: 'QUANTIDADE', descricao: 'Número de furos igualmente espaçados' },
    ],
    exemplo:
      '; Primeiro definir ciclo de furação\n' +
      'CYCL DEF 200.0 FURAÇÃO\n' +
      'CYCL DEF 200.1 PROF.=-20 ~\n' +
      '    AVANÇO=250 ~\n' +
      '    SEG.=3\n\n' +
      '; Depois definir e executar o PCD\n' +
      'CYCL DEF 220.0 PADRÃO CIRCULAR\n' +
      'CYCL DEF 220.1 CENTRO X+50 ~\n' +
      '    CENTRO Y+50 ~\n' +
      '    RAIO=40 ~\n' +
      '    ANG.=0 ~\n' +
      '    QUANTIDADE=8\n' +
      'CYCL CALL',
    explicacaoExemplo:
      '8 furos de 20mm de profundidade em PCD Ø80mm (raio 40mm) centrado em X50 Y50, iniciando em 0°. Espaçamento automático de 45°.',
    isG: false,
  },

  {
    codigo: 'FN 0 / FN 1', nome: 'Atribuição e Cálculo de Variáveis — Heidenhain', categoria: 'Macro',
    maquina: 'Ambos', fabricante: 'Heidenhain', diagramaTipo: 'referencia',
    descricao: 'Programação paramétrica Heidenhain — atribuição de valores a variáveis Q e cálculos aritméticos.',
    descricaoCompleta:
      'No Heidenhain TNC, as variáveis Q (Q0–Q1999) são o equivalente das variáveis macro do Fanuc. ' +
      'FN 0 atribui um valor constante a uma variável. ' +
      'FN 1 soma dois valores. FN 2 subtrai. FN 3 multiplica. FN 4 divide. ' +
      'FN 5 = seno. FN 6 = co-seno. FN 7 = raiz. FN 18 = função IF. ' +
      'As variáveis Q são usadas como parâmetros em qualquer bloco: L X+Q1 Y+Q2. ' +
      'Q100-Q199 = variáveis de resultado. Q200+ = para programação livre.',
    sintaxe: 'FN 0: Q[n] = [valor]\nFN 1: Q[n] = Q[a] + Q[b]\nFN 5: Q[n] = SIN Q[ang]',
    parametros: [
      { letra: 'FN 0', descricao: 'Atribuição: Q1 = 50 → Q1 recebe valor 50' },
      { letra: 'FN 1 / FN 2', descricao: 'Soma / Subtração de variáveis' },
      { letra: 'FN 3 / FN 4', descricao: 'Multiplicação / Divisão' },
      { letra: 'FN 5 / FN 6', descricao: 'Seno / Co-seno (ângulo em graus)' },
      { letra: 'FN 18', descricao: 'Desvio condicional IF — FN 18: IF Q1 > 0 GOTO LBL 10' },
    ],
    exemplo:
      'FN 0: Q1 = 50.     ; Diâmetro PCD\n' +
      'FN 0: Q2 = 8.      ; Número de furos\n' +
      'FN 4: Q3 = 360 / Q2  ; Passo angular\n' +
      'FN 0: Q4 = 0.      ; Ângulo atual\n' +
      'LBL 1\n' +
      'FN 5: Q10 = SIN Q4  ; X = R×sen(ang)\n' +
      'FN 6: Q11 = COS Q4  ; Y = R×cos(ang)\n' +
      'L X+Q10 Y+Q11 FMAX\n' +
      'FN 18: IF Q4 < 360 GOTO LBL 1',
    explicacaoExemplo:
      'Calcula e percorre posições de 8 furos em PCD Ø50mm usando funções trigonométricas Heidenhain. Sem precisar calcular manualmente cada coordenada.',
    isG: false,
  },

  
  
  

  {
    codigo: 'G7.1', nome: 'Interpolação Cilíndrica — Okuma', categoria: 'Multi-eixo',
    maquina: 'Torno CNC', fabricante: 'Okuma', diagramaTipo: 'linear',
    descricao: 'Interpola movimento rotacional (C) com linear (Z) para usinar ranhuras/cames em torno CNC.',
    descricaoCompleta:
      'G7.1 ativa a interpolação cilíndrica no OSP da Okuma. Permite programar contornos na superfície ' +
      'cilíndrica da peça como se fosse um plano planificado. ' +
      'O eixo C (rotacional) é tratado como deslocamento linear equivalente ao arco no raio especificado. ' +
      'G7.1 C[raio]: ativa com raio de conversão. ' +
      'G7.1 C0: cancela. ' +
      'Usado para ranhuras helicoidais, came de tambor, roscas especiais em torno.',
    sintaxe: 'G7.1 C[raio]   ; Ativa\n...\nG7.1 C0        ; Cancela',
    parametros: [
      { letra: 'C[raio]', descricao: 'Raio da superfície cilíndrica (mm) — define conversão angular/linear' },
      { letra: 'G7.1 C0', descricao: 'Cancela o modo de interpolação cilíndrica' },
    ],
    exemplo:
      '; Ranhura helicoidal em cilindro Ø50 (raio 25)\n' +
      'G7.1 C25.    ; Ativa interp. cilíndrica raio 25mm\n' +
      'G1 C0. Z0. F100\n' +
      'G1 C90. Z-20.  ; 90° = ≈39.3mm arco, Z desce 20mm\n' +
      'G1 C180. Z-40.\n' +
      'G1 C360. Z-80.\n' +
      'G7.1 C0      ; Cancela',
    explicacaoExemplo:
      'Fresa ranhura helicoidal de 360° ao longo de 80mm de comprimento em cilindro Ø50mm. Perfeito para cames de tambor e porcas de rosca trapezoidal especial.',
    isG: true,
  },

  {
    codigo: 'G140', nome: 'Seleção de Cabeçote — Okuma Torno Bimandrino', categoria: 'Torno',
    maquina: 'Torno CNC', fabricante: 'Okuma',
    descricao: 'Seleciona qual spindle (principal ou sub-spindle) será ativo em tornos Okuma bimandrino (LB, Multus).',
    descricaoCompleta:
      'Em tornos Okuma de dois cabeçotes (LB-3000 EX II, Multus B), G140 e G141 selecionam qual cabeçote está ativo. ' +
      'G140 = cabeçote principal (S1). G141 = cabeçote secundário (S2). ' +
      'Cada cabeçote tem seus próprios offsets de ferramentas e work zeros. ' +
      'A transferência de peça entre cabeçotes usa G141 + G99 (avanço por rev) + M14 (fixar sub-spindle) + G74 (recuar ao zero). ' +
      'Fundamental para usinagem completa (OpA + OpB) sem reposicionamento manual.',
    sintaxe: 'G140  ; Seleciona spindle principal\nG141  ; Seleciona sub-spindle\nM14   ; Fixa sub-spindle para transferência',
    parametros: [
      { letra: 'G140', descricao: 'Ativa controle do cabeçote principal (S1/C1)' },
      { letra: 'G141', descricao: 'Ativa controle do sub-spindle (S2/C2)' },
      { letra: 'M14', descricao: 'Clampeia o sub-spindle — necessário para transferência de peça' },
      { letra: 'M15', descricao: 'Desclampeia o sub-spindle' },
    ],
    exemplo:
      '; Operação no cabeçote principal\n' +
      'G140\nT101 ; Ferra T1 cabeçote 1\nS1500 M3\n' +
      'G1 Z-50. F0.2\n\n' +
      '; Transferir peça para sub-spindle\n' +
      'G141  ; Selecionar sub-spindle\nM14   ; Fixar sub-spindle\n' +
      'G0 Z2.  ; Aproximar sub-spindle\n' +
      'M15   ; Liberar placa principal\n' +
      '; Usinar face B no sub-spindle\n' +
      'T201 S1200 M13',
    explicacaoExemplo:
      'Sequência de torneamento no cabeçote principal, transferência para sub-spindle e usinagem da face traseira — tudo em um ciclo automático.',
    isG: true,
  },

  
  
  

  {
    codigo: 'G05 P10000', nome: 'Modo de Alta Precisão — Mitsubishi M800', categoria: 'Alta Velocidade',
    maquina: 'Centro de Usinagem', fabricante: 'Mitsubishi',
    descricao: 'Ativa modo de alta velocidade e alta precisão (HSPB) no controle Mitsubishi M700/M800.',
    descricaoCompleta:
      'G05 P10000 ativa o modo HSPB (High Speed Processing B) do Mitsubishi M700/M800. ' +
      'O controle aumenta o número de blocos em look-ahead (pré-leitura) para suavizar trajetórias. ' +
      'A aceleração/desaceleração em cantos é automática. ' +
      'G05 P10001 = modo de alta precisão (tolerância de contorno mais apertada). ' +
      'G05 P0 = cancela. ' +
      'Comparável ao G05.1 Q1 do Fanuc. ' +
      'Em moldes e superfícies livres, aumenta velocidade de usinagem mantendo acabamento.',
    sintaxe: 'G05 P10000   ; Alta velocidade\nG05 P10001   ; Alta precisão\nG05 P0       ; Cancela',
    parametros: [
      { letra: 'P10000', descricao: 'Ativa modo de alta velocidade (HSPB)' },
      { letra: 'P10001', descricao: 'Ativa modo de alta precisão com tolerância mais fina' },
      { letra: 'P0', descricao: 'Cancela G05 — retorna ao modo de interpolação padrão' },
    ],
    exemplo:
      'G05 P10000      ; Ativar HSPB\n' +
      'S15000 M3\n' +
      'G0 G90 G54 X0 Y0\n' +
      'G43 H1 Z5. M8\n' +
      '; Usinagem de molde com muitos pontos\n' +
      '...\n' +
      'G05 P0          ; Desativar HSPB\n' +
      'M5 M9',
    explicacaoExemplo:
      'HSPB ativado antes de usinagem de forma livre. O controle Mitsubishi lê até 200 blocos à frente, suavizando curvas e mantendo o avanço programado constante.',
    isG: true,
  },

  
  
  

  {
    codigo: 'G00.1', nome: 'Posicionamento Rápido com Suavização — Brother', categoria: 'Movimento',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', diagramaTipo: 'linear',
    descricao: 'Move em rápido com trajetória suavizada (não angular) — reduz vibração e tempo em Brother Speedio.',
    descricaoCompleta:
      'G00.1 é exclusivo das máquinas Brother Speedio e realiza posicionamento rápido com trajetória curvilínea suavizada ' +
      'em vez da trajetória em L (angular) do G00 convencional. ' +
      'Em peças com muitos furos próximos, elimina as acelerações bruscas do G00 convencional. ' +
      'Reduz vibração estrutural e melhora a vida dos fusos. ' +
      'O tempo de ciclo pode ser menor que G00 padrão porque evita picos de aceleração. ' +
      'Recomendado em fresamento de alta velocidade com trocas de ferramenta frequentes.',
    sintaxe: 'G00.1 X[x] Y[y] Z[z]',
    parametros: [
      { letra: 'X/Y/Z', descricao: 'Posição de destino — trajetória suavizada automática' },
    ],
    exemplo:
      '; Furação rápida com múltiplos furos\n' +
      'G00.1 X10. Y10.   ; Rapid suavizado\n' +
      'G83 Z-20. R3. Q3. F400\n' +
      'G00.1 X30. Y10.\n' +
      'G83 Z-20. R3. Q3. F400\n' +
      'G00.1 X50. Y10.\n' +
      'G83 Z-20. R3. Q3. F400',
    explicacaoExemplo:
      'Três furos com G83 e deslocamentos por G00.1 suavizado. O Brother Speedio evita paradas bruscas entre furos mantendo dinamismo do ciclo.',
    isG: true,
  },

  

  {
    codigo: 'G04', nome: 'Temporização — Dwell', categoria: 'Movimento',
    maquina: 'Fresadora / Torno', fabricante: 'Universal',
    descricao: 'Pausa o movimento por tempo definido mantendo o spindle girando. Usado para garantir piso limpo em furos e melhorar acabamento no escareamento.',
    descricaoCompleta:
      'G04 para o avanço por um tempo especificado enquanto o spindle continua girando. ' +
      'Muito útil no fundo de furos cegos — garante que o piso seja completamente usinado. ' +
      'Em escareamento (G82), a pausa no fundo melhora o acabamento do ângulo de 90°. ' +
      'Fanuc: G04 X1.5 (segundos) ou G04 P1500 (milissegundos) — ambos pausam 1.5 seg. ' +
      'Em tornos com G75 (ranhura), G04 garante fundo de ranhura completamente cortado.',
    sintaxe: 'G04 X[seg]\nG04 P[ms]',
    parametros: [
      { letra: 'X', descricao: 'Tempo em segundos — ex: X1.5 pausa 1,5 segundos' },
      { letra: 'P', descricao: 'Tempo em milissegundos — ex: P1500 pausa 1500ms = 1,5 segundos' },
    ],
    exemplo:
      'G01 Z-20. F100.   ; Desce ao fundo\n' +
      'G04 X1.5          ; Pausa 1.5 seg no fundo\n' +
      'G00 Z5.           ; Retrai',
    explicacaoExemplo:
      'Pausa de 1.5 segundos no fundo do furo cego. O spindle continua a 100% da rotação — limpa o fundo e melhora o acabamento do rebaixo.',
    isG: true,
  },

  {
    codigo: 'G17 / G18 / G19', nome: 'Seleção de Plano de Trabalho', categoria: 'Configuração',
    maquina: 'Fresadora / Torno', fabricante: 'Universal',
    descricao: 'Define o plano para arcos G02/G03 e compensação G41/G42. G17=XY (fresadora), G18=XZ (torno), G19=YZ.',
    descricaoCompleta:
      'O plano de trabalho define em qual plano os arcos G02/G03 e G41/G42 são calculados. ' +
      'G17 (XY): padrão em fresadoras. Arcos no plano horizontal — vista de cima. ' +
      'G18 (XZ): padrão em tornos. Arcos no plano do perfil longitudinal. ' +
      'G19 (YZ): usinagem lateral em 5 eixos ou fixações especiais. ' +
      'Erro clássico: usar G02/G03 sem declarar o plano — o controle usa o plano modal anterior, podendo causar arco no plano errado.',
    sintaxe: 'G17  ; plano XY\nG18  ; plano XZ\nG19  ; plano YZ',
    parametros: [
      { letra: 'G17', descricao: 'Plano XY — padrão fresadoras, arcos em vista superior' },
      { letra: 'G18', descricao: 'Plano XZ — padrão tornos, arcos no perfil longitudinal' },
      { letra: 'G19', descricao: 'Plano YZ — 5 eixos ou fixações especiais' },
    ],
    exemplo:
      '; Fresadora\n' +
      'G17\n' +
      'G02 X50. Y30. R20. F200.   ; Arco no plano XY\n' +
      '\n' +
      '; Torno\n' +
      'G18\n' +
      'G03 X30. Z-15. R10. F0.2   ; Arco no plano XZ',
    explicacaoExemplo:
      'Na fresadora G17 precede G02. No torno G18 precede G03 para arredondamento de canto no perfil XZ.',
    isG: true,
  },

  {
    codigo: 'G20 / G21', nome: 'Unidade — Polegada / Métrico', categoria: 'Configuração',
    maquina: 'Fresadora / Torno', fabricante: 'Universal',
    descricao: 'G21=métrico (mm). G20=polegadas. Define unidade para coordenadas, avanços e offsets. Deve ser a primeira linha do programa.',
    descricaoCompleta:
      'G21 seleciona mm — coordenadas, avanços e offsets em milímetros. ' +
      'G20 seleciona polegadas — coordenadas e avanços em in/min ou in/rot. ' +
      'CRÍTICO: declarar no início de todo programa — nunca mudar no meio da usinagem. ' +
      'No Brasil: sempre G21. Programas importados dos EUA podem ter G20 — converter antes. ' +
      'Offsets G54-G59 também são afetados — requerem nova medição se a unidade for alterada.',
    sintaxe: 'G21  ; métrico (mm)\nG20  ; imperial (polegadas)',
    parametros: [
      { letra: 'G21', descricao: 'Sistema métrico (mm) — padrão no Brasil' },
      { letra: 'G20', descricao: 'Sistema imperial (polegadas) — padrão nos EUA' },
    ],
    exemplo:
      'O0001\n' +
      '%\n' +
      'G90 G17 G21        ; Absoluto, XY, métrico\n' +
      'G28 G91 Z0.\n' +
      'G90\n' +
      'T01 M06            ; Programa continua em mm',
    explicacaoExemplo:
      'G21 na linha de inicialização garante modo métrico independente de o operador ter mudado. Boa prática em todo programa.',
    isG: true,
  },

  {
    codigo: 'G40 / G41 / G42', nome: 'Compensação de Raio de Corte (CRC)', categoria: 'Compensação',
    maquina: 'Fresadora', fabricante: 'Universal',
    descricao: 'G41=compensação esquerda, G42=direita. Ajusta trajetória pelo raio da fresa. Para ajustar medida: mudar valor D sem alterar programa.',
    descricaoCompleta:
      'CRC (Cutter Radius Compensation) permite programar o perfil real da peça — o controle compensa o raio automaticamente. ' +
      'G41: ferramenta à esquerda do contorno (no sentido de avanço). ' +
      'G42: ferramenta à direita — mais comum no fresamento em concordância (climb). ' +
      'D01 = raio no offset. Para afinar cota: diminuir D. Para alargar: aumentar D. ' +
      'REGRA: ativar só com movimento de entrada tangencial antes do perfil — nunca dentro do material.',
    sintaxe: 'G41 D[n]  ; esquerda\nG42 D[n]  ; direita\nG40       ; cancela',
    parametros: [
      { letra: 'D', descricao: 'Número do offset (raio da fresa + correção de medida)' },
      { letra: 'G41', descricao: 'Ferramenta à esquerda do avanço' },
      { letra: 'G42', descricao: 'Ferramenta à direita do avanço' },
    ],
    exemplo:
      'G42 D01\n' +
      'G01 X0. Y-8. F280.  ; Entrada tangencial\n' +
      'G01 X80.            ; Lado 1\n' +
      'G01 Y50.            ; Lado 2\n' +
      'G01 X0.             ; Lado 3\n' +
      'G01 X-5. Y-5.       ; Saída antes do G40\n' +
      'G40',
    explicacaoExemplo:
      'Contorno retangular com G42. D01=5.0mm (raio da fresa). Se peça ficou 0.1mm grande, mudar D01 para 5.1mm corrige sem alterar programa.',
    isG: true,
  },

  {
    codigo: 'G43 / G44 / G49', nome: 'Compensação de Comprimento de Ferramenta (TLO)', categoria: 'Compensação',
    maquina: 'Centro de Usinagem', fabricante: 'Universal',
    descricao: 'G43=compensação positiva (padrão), G49=cancela. H-code indica registro do offset de comprimento. Obrigatório após troca de ferramenta.',
    descricaoCompleta:
      'TLO (Tool Length Offset) com G43 adiciona o valor de H ao eixo Z — ferramentas diferentes atingem Z=0 correto sem reprogramar. ' +
      'G43 H01: usa o valor armazenado em H01. ' +
      'Método de medição: apalpador de comprimento no spindle (mais preciso) ou método de papel. ' +
      'G43 deve aparecer na primeira movimentação Z após M06. ' +
      'G49 cancela — evitar usar G49 no meio do programa pois o Z vai à posição real da máquina.',
    sintaxe: 'G43 H[n] Z[cota]\nG49  ; cancela',
    parametros: [
      { letra: 'H', descricao: 'Registro do offset (H01=T01, H02=T02 etc)' },
      { letra: 'Z', descricao: 'Cota Z inicial com compensação já ativa' },
    ],
    exemplo:
      'T01 M06\n' +
      'G43 H01 Z50. M03 S3000  ; TLO ativo + sobe Z\n' +
      'G00 X0. Y0.\n' +
      'G01 Z-5. F100.',
    explicacaoExemplo:
      'G43 H01 ativa o offset da ferramenta T01 ao mesmo tempo que comanda Z50. O controle soma o valor H01 a qualquer coordenada Z programada a seguir.',
    isG: true,
  },

  {
    codigo: 'G52', nome: 'Coordenadas Locais — LCS (Local Coordinate System)', categoria: 'Coordenadas',
    maquina: 'Fresadora', fabricante: 'Fanuc / Haas',
    descricao: 'Deslocamento temporário da origem sem alterar G54. Ideal para subprogramas com características repetidas em posições diferentes.',
    descricaoCompleta:
      'G52 cria deslocamento temporário somado ao G54 ativo. ' +
      'Uso clássico: subprograma escrito em torno de X0Y0 local; G52 desloca para cada grupo de características. ' +
      'Cancelar: G52 X0. Y0. Z0. — retorna ao G54 sem offset. ' +
      'Diferença vs G91: G91 acumula deslocamentos; G52 define posição absoluta do offset local.',
    sintaxe: 'G52 X[dx] Y[dy]\nG52 X0. Y0.  ; cancela',
    parametros: [
      { letra: 'X/Y/Z', descricao: 'Deslocamento da nova origem local relativo ao G54 ativo' },
    ],
    exemplo:
      'G52 X10. Y10.   ; Grupo 1\n' +
      'M98 P9010       ; Usina padrão\n' +
      'G52 X50. Y10.   ; Grupo 2\n' +
      'M98 P9010       ; Mesmo padrão\n' +
      'G52 X0. Y0.     ; Cancela LCS',
    explicacaoExemplo:
      'Subprograma O9010 reutilizado 2 vezes em posições diferentes apenas mudando o G52. Elimina repetição de código.',
    isG: true,
  },

  {
    codigo: 'G90 / G91', nome: 'Modo Absoluto / Incremental', categoria: 'Coordenadas',
    maquina: 'Fresadora / Torno', fabricante: 'Universal',
    descricao: 'G90=absoluto (relativo ao zero da peça). G91=incremental (relativo à posição atual). Modal — permanece até ser alterado.',
    descricaoCompleta:
      'G90: coordenadas relativas à origem do sistema ativo (G54 etc). Padrão e mais seguro. ' +
      'G91: cada valor é um deslocamento a partir da posição atual. ' +
      'Uso clássico do G91: G28 G91 Z0 — retorno seguro ao home Z sem mover XY. ' +
      'ARMADILHA: misturar G90 e G91 inadvertidamente — verificar o modo após trechos em G91. ' +
      'No torno Fanuc: G90 tem significado DIFERENTE (ciclo de torneamento). Usar G00/G01 explicitamente.',
    sintaxe: 'G90  ; absoluto\nG91  ; incremental',
    parametros: [
      { letra: 'G90', descricao: 'Absoluto — X10. = ir para X=10 na peça' },
      { letra: 'G91', descricao: 'Incremental — X10. = mover +10mm da posição atual' },
    ],
    exemplo:
      'G90\n' +
      'G00 X50. Y30.      ; Vai para X50, Y30 absoluto\n' +
      '\n' +
      'G91\n' +
      'G00 X10. Y5.       ; Desloca +10mm em X, +5mm em Y\n' +
      '\n' +
      'G28 G91 Z0.        ; Retorno seguro ao home Z',
    explicacaoExemplo:
      'G28 G91 Z0 é o retorno padrão antes de M06. Em G91, Z0 significa "mover Z zero distância incremental" — o controle interpreta como retornar ao referencial.',
    isG: true,
  },

  {
    codigo: 'G96 / G97', nome: 'CSS — Velocidade de Corte Constante / RPM Fixo', categoria: 'Velocidade',
    maquina: 'Torno CNC', fabricante: 'Universal',
    descricao: 'G96=CSS (m/min constante, RPM varia). G97=RPM fixo. G50 define RPM máximo com G96. Essencial para acabamento de qualidade no torno.',
    descricaoCompleta:
      'G96 mantém V_c constante — RPM varia automaticamente com o diâmetro. ' +
      'Resultado: acabamento (Ra) uniforme em todo o perfil, vida de ferramenta otimizada. ' +
      'G50 S[max]: OBRIGATÓRIO com G96 — limita RPM máximo ao se aproximar do centro. ' +
      'G97: RPM fixo — obrigatório em roscas G32/G76 (sincronismo encoder-eixo) e mandrilamento. ' +
      'Fórmula manual: RPM = (V_c × 1000) / (π × Ø). Com G96 o CNC calcula automaticamente.',
    sintaxe: 'G96 S[m/min] M03\nG50 S[RPMmax]\nG97 S[RPM] M03',
    parametros: [
      { letra: 'S (G96)', descricao: 'Velocidade de corte em m/min (Vc)' },
      { letra: 'G50 S', descricao: 'RPM máximo — obrigatório com G96' },
      { letra: 'S (G97)', descricao: 'Rotação em RPM — constante' },
    ],
    exemplo:
      'G96 S200 M03    ; CSS: 200 m/min\n' +
      'G50 S3000       ; Máximo 3000 RPM\n' +
      'G01 X0. F0.15   ; Facear com RPM variando\n' +
      '\n' +
      'G97 S600 M03    ; RPM fixo para rosca\n' +
      'G76 P020060 Q100 R30  ; Ciclo de rosca',
    explicacaoExemplo:
      'Faceamento com G96: RPM sobe conforme Ø diminui, mantendo 200 m/min. G50 S3000 evita RPM excessivo. Na rosca G76, G97 garante sincronismo perfeito com o encoder.',
    isG: true,
  },

  
  
  

  {
    codigo: 'M68 / M69', nome: 'Castanha — Fechar / Abrir (DMG Torno)', categoria: 'Fixação',
    maquina: 'Torno CNC', fabricante: 'DMG', isG: false,
    descricao: 'M68 fecha a castanha (chuck clamp). M69 abre a castanha. Usados em automação com carregamento de peças.',
    descricaoCompleta:
      'Em tornos DMG Mori, M68 comanda o fechamento hidráulico/pneumático da castanha e M69 o abre. ' +
      'Fundamentais em células de automação onde um robô carrega/descarrega peças. ' +
      'Sequência padrão: M69 (abre) → robô coloca peça → M68 (fecha) → M03 (gira) → usina → M05 → M69 → robô retira. ' +
      'Alguns modelos usam M10/M11 para castanha principal e M68/M69 para contra-cabeçote ou castanha secundária.',
    sintaxe: 'M68  ; Fechar castanha\nM69  ; Abrir castanha',
    parametros: [
      { letra: 'M68', descricao: 'Fecha castanha — confirma pressão mínima antes de continuar' },
      { letra: 'M69', descricao: 'Abre castanha — aguarda confirmação de aberto' },
    ],
    exemplo:
      'M69          ; Abre castanha\nG4 P2.0      ; Aguarda 2s (robô carrega)\nM68          ; Fecha castanha\nM03 S800     ; Liga spindle\nG00 X100. Z5.\nG01 Z-50. F0.2\nM05\nM69          ; Abre — robô retira\nM30',
    explicacaoExemplo:
      'Ciclo completo de célula automática: abre → peça carregada → fecha → usina → abre → peça retirada. G4 P2.0 garante tempo para confirmação do robô.',
  },

  {
    codigo: 'M78 / M79', nome: 'Luneta — Avançar / Recuar (DMG)', categoria: 'Fixação',
    maquina: 'Torno CNC', fabricante: 'DMG', isG: false,
    descricao: 'M78 avança a luneta (steady rest). M79 recua. Essencial para peças longas e finas que vibrariam sem suporte.',
    descricaoCompleta:
      'A luneta (steady rest) é um suporte fixo que apoia peças longas no meio do comprimento, evitando deflexão e vibração. ' +
      'M78 avança a luneta até a posição programada e M79 a recua. ' +
      'Regra prática: usar luneta quando L/D (comprimento/diâmetro) > 6. Sem luneta em L/D > 8 é quase impossível manter tolerâncias. ' +
      'Importante: luneta deve ser ajustada ao diâmetro da peça antes de M78 — o operador posiciona manualmente.',
    sintaxe: 'M78  ; Avança luneta\nM79  ; Recua luneta',
    parametros: [
      { letra: 'M78', descricao: 'Avança luneta para posição de trabalho' },
      { letra: 'M79', descricao: 'Retrai luneta — libera peça' },
    ],
    exemplo:
      'M03 S400\nG00 Z-200.     ; Posiciona no meio da peça\nM78            ; Ativa luneta\nG01 X28. F0.15 ; Torneia com suporte\nM79            ; Recua luneta\nM05',
    explicacaoExemplo:
      'Para eixo de 400mm/Ø30mm (L/D=13): luneta ativada no centro. Sem ela, deflexão seria ~0.3mm → peça fora de tolerância.',
  },

  {
    codigo: 'M200 / M201', nome: 'Sub-spindle — Transferir Peça (DMG)', categoria: 'Sub-Spindle',
    maquina: 'Torno CNC', fabricante: 'DMG', isG: false,
    descricao: 'M200 transfere a peça do spindle principal para o sub-spindle. M201 sincroniza os dois spindles para transferência.',
    descricaoCompleta:
      'Tornos DMG com contra-cabeçote sincronizado (sub-spindle) permitem usinar ambas as faces sem reposicionamento manual. ' +
      'M201: sincroniza velocidades dos dois spindles. ' +
      'M200: executa a transferência — aproxima o sub-spindle, fecha sua castanha, abre a principal. ' +
      'Após transferência, o programa continua no lado B da peça, usando G-codes normais mas em orientação invertida. ' +
      'Reduz setup de horas para segundos em peças que precisam de dois lados.',
    sintaxe: 'M201  ; Sincroniza spindles\nM200  ; Transfere peça',
    parametros: [
      { letra: 'M201', descricao: 'Sincroniza RPM principal = sub-spindle (fase de transferência)' },
      { letra: 'M200', descricao: 'Comanda transferência completa: sub avança, fecha, principal abre' },
    ],
    exemplo:
      '; ===== LADO A =====\nM03 S800\nG01 X0. Z-45. F0.15  ; Usina lado A completo\nM05\n; ===== TRANSFERÊNCIA =====\nM201         ; Sincroniza spindles\nM200         ; Transfere peça ao sub\n; ===== LADO B =====\nM04 S800     ; Sub gira inverso (já é normal)\nG01 X0. Z-30. F0.15  ; Usina lado B\nM30',
    explicacaoExemplo:
      'Peça usinada dos dois lados sem toque manual. M04 no lado B porque o sub-spindle segura a peça invertida — o sentido de corte parece invertido no programa.',
  },

  {
    codigo: 'M38 / M39', nome: 'Contra-ponto — Avançar / Recuar (DMG)', categoria: 'Fixação',
    maquina: 'Torno CNC', fabricante: 'DMG', isG: false,
    descricao: 'M38 avança o contra-ponto pneumático/hidráulico. M39 recua. Para suporte de peças em ponta.',
    descricaoCompleta:
      'O contra-ponto (tailstock) suporta a extremidade livre de peças longas tornadas entre pontas. ' +
      'M38 avança até a peça com força programada. M39 recua. ' +
      'Força de avanço é ajustada por parâmetro de máquina (típico: 150–800 N). ' +
      'Diferente da luneta (posição fixa), o contra-ponto segue o eixo Z se necessário. ' +
      'Usar quando: L/D > 4 e a peça tem furo de centro.',
    sintaxe: 'M38  ; Avança contra-ponto\nM39  ; Recua contra-ponto',
    parametros: [
      { letra: 'M38', descricao: 'Avança contra-ponto com força controlada por parâmetro' },
      { letra: 'M39', descricao: 'Recua contra-ponto — libera extremidade da peça' },
    ],
    exemplo:
      'G00 Z5.      ; Aproxima de Z\nM38          ; Avança contra-ponto\nM03 S600\nG01 Z-380. F0.20 ; Desbaste em comprimento total\nM05\nM39          ; Recua contra-ponto\nG00 Z200. M30',
    explicacaoExemplo:
      'Para eixo longo Ø40mm × 380mm: contra-ponto suporta durante desbaste. M39 antes de retornar Z para evitar colisão.',
  },

  {
    codigo: 'G361 / G364', nome: 'TRANSMIT / TRACYL — Interpolação (DMG 5X)', categoria: 'Interpolação',
    maquina: 'Torno CNC', fabricante: 'DMG', isG: true,
    descricao: 'TRANSMIT: transforma eixo C+X em coordenadas cartesianas para fresamento de face. TRACYL: fresamento cilíndrico no torno.',
    descricaoCompleta:
      'TRANSMIT (G364) permite usinar formas planas na face do torno usando fresas — o controle converte X/Y cartesiano em X+C polar automaticamente. ' +
      'TRACYL (G365) desdobra a superfície cilíndrica da peça em um plano para gravar ou fresar ao longo do cilindro. ' +
      'Esses são recursos do Siemens SINUMERIK em tornos-centros DMG. ' +
      'Equivalente no Fanuc: G12.1 (face) e G07.1 (cilíndrico). ' +
      'Requer torno com eixo C motorizado (live tooling).',
    sintaxe: 'TRANSMIT  ; Ativa fresamento de face\nTRACYL(D)  ; D = diâmetro cilindro\nTRANS OFF  ; Desativa',
    parametros: [
      { letra: 'TRANSMIT', descricao: 'Ativa transformação polar → cartesiana na face da peça' },
      { letra: 'TRACYL(D)', descricao: 'D = diâmetro do cilindro a fresar em mm' },
      { letra: 'TRANS OFF', descricao: 'Desativa a transformação — retorna modo torno normal' },
    ],
    exemplo:
      'G97 S1500 M03\nTRANSMIT     ; Ativa face milling\nG17          ; Plano XY ativo\nG01 X10. Y10. F200  ; Move em cartesiano\nG03 X-10. Y10. CR=10. ; Arco\nTRANS OFF    ; Desativa\nG18          ; Retorna plano ZX',
    explicacaoExemplo:
      'Com TRANSMIT ativo, o programa usa X/Y como um centro de usinagem — o CNC converte automaticamente para C+X do torno. Ideal para sextavados, chavetas e furos radiais na face.',
  },

  
  
  

  {
    codigo: 'G100', nome: 'Skip Function — Pular Bloco (Brother)', categoria: 'Controle',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', isG: true,
    descricao: 'Pula para um bloco específico se sinal externo ativo. Usado com apalpadores e células automáticas.',
    descricaoCompleta:
      'G100 no controle Brother executa um salto condicional para o número de bloco especificado se o sinal de skip (entrada digital) estiver ativo. ' +
      'Útil para: apalpadores de presença de peça, detecção de quebra de ferramenta, células robóticas. ' +
      'Diferente do G31 (skip com gravação de posição) — G100 é um pulo puro para um label/número de bloco. ' +
      'Parâmetro P define o número do bloco destino.',
    sintaxe: 'G100 P[bloco]',
    parametros: [
      { letra: 'P', descricao: 'Número do bloco de destino do salto' },
    ],
    exemplo:
      'G100 P100    ; Se skip ativo: pula para bloco N100\nG01 Z-50. F300 ; Executa se peça presente\nN100\nM30          ; Fim — skip pula aqui se sem peça',
    explicacaoExemplo:
      'Verifica presença de peça: se apalpador não tocou (skip=1), pula direto para M30 sem usinar. Protege contra usinagem em vazio.',
  },

  {
    codigo: 'G113', nome: 'Interpolação Polar — Face (Brother)', categoria: 'Interpolação',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', isG: true,
    descricao: 'Interpola eixo C como eixo linear para fresamento polar na face da peça. Brother Speedio com eixo de indexação.',
    descricaoCompleta:
      'G113 ativa interpolação polar no Brother Speedio com mesa giratória (eixo A/B). ' +
      'Converte rotação do eixo giratório em deslocamento linear equivalente para usinagem de perfis curvos na face. ' +
      'Permite usar programação G01/G02/G03 normalmente em coordenadas retangulares sobre a face girada. ' +
      'G114 desativa. ' +
      'Brother Speedio série S1000X1 e R650X1 suportam esse recurso com mesa de 4º eixo integrada.',
    sintaxe: 'G113  ; Ativa interpolação polar\nG114  ; Desativa',
    parametros: [
      { letra: 'G113', descricao: 'Ativa modo de interpolação polar — converte A em linear' },
      { letra: 'G114', descricao: 'Desativa — retorna modo de posicionamento por ângulo' },
    ],
    exemplo:
      'G113         ; Ativa polar\nG17          ; Plano XY\nG01 X50. Y0. F500\nG02 X0. Y50. R50.\nG114         ; Desativa polar',
    explicacaoExemplo:
      'Fresa um arco de 90° na peça posicionada no 4º eixo usando G02 normal — G113 faz a conversão automática para o eixo giratório.',
  },

  {
    codigo: 'M60', nome: 'Troca de Pallet ATC — Brother', categoria: 'Automação',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', isG: false,
    descricao: 'Comanda a troca de pallet no Brother Speedio. Executa o ciclo completo de troca: abre mesa, troca, fecha, confirma.',
    descricaoCompleta:
      'M60 no Brother Speedio ativa o sistema de troca de pallet (Automatic Pallet Changer — APC). ' +
      'Quando executado: spindle para na posição de origem, mesa desloca para posição de troca, pallets são trocados, confirmação é enviada ao programa. ' +
      'Brother Speedio são conhecidos por trocas de pallet ultrarrápidas (< 4 segundos). ' +
      'Depois do M60, o programa reinicia do início do código de peça para o novo pallet. ' +
      'Pode-se usar M60 no final de cada ciclo de peça para automatizar produção em série.',
    sintaxe: 'M60  ; Troca de pallet',
    parametros: [
      { letra: 'M60', descricao: 'Executa ciclo completo de troca de pallet APC Brother' },
    ],
    exemplo:
      'O0001 (LADO A)\nT1 M06\nG54 G90\n; ... usinagem ...\nM60          ; Troca pallet — próxima peça\nM30\n\nO0002 (LADO B)\n; (M60 recarrega automaticamente O0001)',
    explicacaoExemplo:
      'No Brother, M60 é o coração da produção contínua. Uma peça bruta entra enquanto a acabada sai — aproveitamento de máquina > 80%.',
  },

  {
    codigo: 'M200 / M201', nome: 'Travamento do 4º Eixo — Brother Speedio', categoria: 'Eixos',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', isG: false,
    descricao: 'M200 trava o 4º eixo (mesa giratória) para usinagem. M201 libera o trava para indexação.',
    descricaoCompleta:
      'No Brother Speedio com 4º eixo integrado: antes de usinar, o eixo rotativo deve ser travado para absorver forças de corte. ' +
      'M200 aplica o freio mecânico/hidráulico do 4º eixo. M201 libera para nova indexação. ' +
      'Sequência correta: G00 A[ângulo] → M200 (trava) → usina → M201 (libera) → próximo ângulo. ' +
      'Sem M200, corte com alta força lateral pode mover o eixo → peça fora de tolerância angular.',
    sintaxe: 'G00 A[ângulo]\nM200  ; Trava 4º eixo\n; ... usina ...\nM201  ; Libera',
    parametros: [
      { letra: 'M200', descricao: 'Aplica freio no 4º eixo — confirma travamento antes de continuar' },
      { letra: 'M201', descricao: 'Libera freio — permite nova indexação angular' },
    ],
    exemplo:
      'G00 A0.         ; 0° — face 1\nM200            ; Trava\nG81 Z-12. R3. F200  ; Fura face 1\nM201            ; Libera\nG00 A60.        ; 60°\nM200            ; Trava\nG81 Z-12. R3. F200  ; Fura face 2\nM201 M30',
    explicacaoExemplo:
      'Furação em 6 faces de um hexagonal: indexa 60°, trava, fura, libera, repete. M200/M201 garantem que as forças da broca não girem a mesa.',
  },

  {
    codigo: 'M84', nome: 'B-Axis Lock / Spindle Clamp — Brother', categoria: 'Eixos',
    maquina: 'Centro de Usinagem', fabricante: 'Brother', isG: false,
    descricao: 'Trava o eixo B (inclinação do spindle) na posição atual. M85 libera. Necessário para usinagem 3+2.',
    descricaoCompleta:
      'No Brother Speedio série T (com eixo B), M84 trava o spindle na posição angular atual do eixo B. ' +
      'Fundamental para usinagem 3+2: posiciona B no ângulo desejado, trava com M84 e realiza cortes 3 eixos nessa orientação. ' +
      'Sem M84, vibrações do corte podem causar microdesvios angulares no eixo B. ' +
      'M85 libera o eixo B para nova posição. ' +
      'Para usinagem 5 eixos contínua: não usar M84 (deixar livre para interpolação simultânea).',
    sintaxe: 'G00 B[ângulo]\nM84  ; Trava eixo B\n; ... usinagem 3 eixos ...\nM85  ; Libera B',
    parametros: [
      { letra: 'M84', descricao: 'Trava eixo B na posição atual com freio mecânico' },
      { letra: 'M85', descricao: 'Libera eixo B para movimento' },
    ],
    exemplo:
      'G00 B45.        ; Inclina spindle 45°\nM84             ; Trava B\nG54\nG01 X50. Y0. Z-10. F300  ; Usina com spindle inclinado\nM85             ; Libera B\nG00 B0.         ; Retorna vertical',
    explicacaoExemplo:
      'Furação angulada a 45° em uma peça sem precisar de dispositivo especial. Posiciona B45°, trava, fura com G81 normal, libera B.',
  },

  
  
  

  {
    codigo: 'G70', nome: 'Ciclo de Acabamento — Torno (Mitsubishi)', categoria: 'Ciclos',
    maquina: 'Torno CNC', fabricante: 'Mitsubishi', isG: true,
    descricao: 'Ciclo de acabamento após desbaste G71/G72. Segue o perfil programado com uma passada final.',
    descricaoCompleta:
      'No Mitsubishi M800/M700, G70 funciona de forma idêntica ao Fanuc — executa o acabamento do perfil após o desbaste com G71 ou G72. ' +
      'O P define o primeiro bloco do perfil e Q o último. ' +
      'F e S programados dentro do perfil (entre P e Q) são usados pelo G70. ' +
      'Importante: o G70 Mitsubishi aceita os mesmos parâmetros que o G70 Fanuc, facilitando a migração de programas entre controles.',
    sintaxe: 'G70 P[início] Q[fim]',
    parametros: [
      { letra: 'P', descricao: 'Número do bloco inicial do perfil de acabamento' },
      { letra: 'Q', descricao: 'Número do bloco final do perfil' },
    ],
    exemplo:
      'G71 U2.0 R1.0\nG71 P100 Q200 U0.3 W0.1 F0.3\nG70 P100 Q200    ; Acabamento\n\nN100 G00 X20.\nG01 X30. Z-10. F0.12\nG01 Z-40.\nN200 G01 X50.',
    explicacaoExemplo:
      'G71 desbasta com 2mm de passe, sobremetal 0.3mm. G70 remove os 0.3mm em acabamento seguindo o mesmo perfil P100-Q200 com F0.12.',
  },

  {
    codigo: 'G74', nome: 'Ciclo de Furação / Canal Axial — Mitsubishi', categoria: 'Ciclos',
    maquina: 'Torno CNC', fabricante: 'Mitsubishi', isG: true,
    descricao: 'Ciclo de furação com peck em Z (eixo principal) ou canal na face. Equivalente ao G74 Fanuc.',
    descricaoCompleta:
      'G74 no Mitsubishi M800: ciclo de furação profunda na face do torno (direção Z) ou canais axiais. ' +
      'Parâmetro R = afastamento de retorno a cada peck. ' +
      'Q = profundidade de cada incremento (peck). ' +
      'Se X e P não são programados: somente furação em Z. Se programados: canais múltiplos na face. ' +
      'Sintaxe muito similar ao Fanuc G74 — programas podem ser portados com mínimas alterações.',
    sintaxe: 'G74 R[recuo]\nG74 Z[prof] Q[peck] F[av]',
    parametros: [
      { letra: 'R', descricao: 'Distância de retrocesso a cada peck (mm)' },
      { letra: 'Z', descricao: 'Profundidade total do furo' },
      { letra: 'Q', descricao: 'Incremento por peck (µm — ex: Q5000 = 5mm)' },
      { letra: 'F', descricao: 'Avanço de furação (mm/rot)' },
    ],
    exemplo:
      'G97 S800 M03 M08\nG00 X0. Z5.      ; Centro da peça\nG74 R1.0\nG74 Z-60. Q8000 F0.12\nG00 Z100. M09 M30',
    explicacaoExemplo:
      'Furo central de 60mm em passos de 8mm (Q8000 = 8.0mm). R1.0 = recua 1mm a cada peck para evacuar cavaco. F0.12 mm/rot.',
  },

  {
    codigo: 'M10 / M11', nome: 'Castanha — Fechar / Abrir (Mitsubishi)', categoria: 'Fixação',
    maquina: 'Torno CNC', fabricante: 'Mitsubishi', isG: false,
    descricao: 'M10 fecha a castanha (chuck clamp). M11 abre. Padrão nos tornos Mitsubishi M800.',
    descricaoCompleta:
      'Nos tornos Mitsubishi M800/M700, M10 fecha a castanha e M11 a abre. ' +
      'Diferente dos DMG (M68/M69), o Mitsubishi usa numeração mais baixa. ' +
      'Muitos controles Mitsubishi têm a pressão de aperto programável por parâmetro. ' +
      'Confirmar no manual da máquina: alguns modelos usam M68/M69 para compatibilidade Fanuc. ' +
      'A sequência de automação é a mesma: M11 → carga → M10 → usina → M11 → descarga.',
    sintaxe: 'M10  ; Fecha castanha\nM11  ; Abre castanha',
    parametros: [
      { letra: 'M10', descricao: 'Fecha castanha — aguarda sinal de confirmação de pressão' },
      { letra: 'M11', descricao: 'Abre castanha — aguarda confirmação de aberto' },
    ],
    exemplo:
      'M11         ; Abre para troca de peça\nM00         ; Parada programada (operador carrega)\nM10         ; Fecha\nM03 S600\nG00 X52. Z2.\nG71 U1.5 R0.5\nG71 P10 Q80 U0.3 F0.25\nG70 P10 Q80\nM05\nM11\nM30',
    explicacaoExemplo:
      'M00 para o programa para o operador colocar a peça. M10 fecha após confirmação. Ciclo completo de torno manual assistido por CNC.',
  },

  {
    codigo: 'G68.2', nome: 'Inclinação do Plano de Trabalho — Mitsubishi', categoria: 'Coordenadas',
    maquina: 'Centro de Usinagem', fabricante: 'Mitsubishi', isG: true,
    descricao: 'Define plano de trabalho inclinado por ângulos Euler ou vetores. Permite usinagem 3+2 e 5 eixos contínuos no M800.',
    descricaoCompleta:
      'G68.2 no Mitsubishi M800 (idêntico ao Fanuc 31i) define um sistema de coordenadas inclinado. ' +
      'Permite programar em coordenadas do plano inclinado como se fosse um plano horizontal normal. ' +
      'Tipos de especificação: ' +
      'G68.2 X Y Z I J K (vetor normal ao plano) ou ' +
      'G68.2 X Y Z Q1 Q2 Q3 (ângulos Euler). ' +
      'G69 cancela o plano inclinado. ' +
      'Essencial para 5 eixos: programa em 3 eixos, máquina interpola 5.',
    sintaxe: 'G68.2 X[cx] Y[cy] Z[cz] I[a1] J[a2] K[a3]\nG69  ; Cancela',
    parametros: [
      { letra: 'X Y Z', descricao: 'Ponto de origem do sistema inclinado' },
      { letra: 'I J K', descricao: 'Ângulos de rotação em X, Y, Z respectivamente (graus)' },
      { letra: 'G69', descricao: 'Cancela G68.2 — retorna ao plano original' },
    ],
    exemplo:
      'G68.2 X0. Y0. Z0. I0. J30. K0.  ; Inclina 30° em Y\nG54\nG00 X50. Y0. Z10.  ; Coord. do plano inclinado\nG81 Z-15. R3. F200\nG69  ; Cancela inclinação\nG00 Z100.',
    explicacaoExemplo:
      'Fura furo inclinado 30° sem necessidade de dispositivo especial. G68.2 faz a matemática — programa como se fosse furo vertical.',
  },

  {
    codigo: 'M96 / M97', nome: 'Espelho — Ativar / Cancelar (Mitsubishi)', categoria: 'Transformações',
    maquina: 'Centro de Usinagem', fabricante: 'Mitsubishi', isG: false,
    descricao: 'M96 ativa espelho nos eixos programados. M97 cancela. Duplica peça espelhada sem reprogramação.',
    descricaoCompleta:
      'Nos centros de usinagem Mitsubishi M800, M96 ativa imagem espelho em eixos especificados. ' +
      'Exemplo: M96 X0. espelha em relação ao eixo X=0 (inverte direção de Y). ' +
      'Combina com G54 para espelhar peças em gabaritos com layout espelhado. ' +
      'M97 cancela o espelho e retorna ao modo normal. ' +
      'Útil para: peças simétricas (esquerda/direita), gabaritos duplos, redução de programação.',
    sintaxe: 'M96 X[val] Y[val]  ; Ativa espelho\nM97               ; Cancela espelho',
    parametros: [
      { letra: 'X', descricao: 'Posição do eixo de espelho em X (omitir se não espelhar X)' },
      { letra: 'Y', descricao: 'Posição do eixo de espelho em Y (omitir se não espelhar Y)' },
    ],
    exemplo:
      'G54\nM98 P1000    ; Usina lado esquerdo\nM96 X0.      ; Ativa espelho em X\nG55          ; Offset da peça direita\nM98 P1000    ; Mesmo programa — espelhado\nM97          ; Cancela espelho\nM30',
    explicacaoExemplo:
      'O subprograma P1000 é usado para ambas as peças. M96 X0 espelha automaticamente todos os movimentos X — peça direita sai espelhada da esquerda.',
  },

  
  
  

  {
    codigo: 'CALL / CALLSUB', nome: 'Chamada de Subprograma — Okuma OSP', categoria: 'Subprogramas',
    maquina: 'Ambos', fabricante: 'Okuma', isG: false,
    descricao: 'No Okuma OSP, subprogramas são chamados com CALL e encerrados com RTS. Diferente do M98/M99 Fanuc.',
    descricaoCompleta:
      'O controle Okuma OSP-P300/P200 usa sintaxe própria para subprogramas. ' +
      'CALL O[nome] L[repetições]: chama subprograma pelo nome. ' +
      'O subprograma termina com RTS (Return from Subroutine) — equivalente ao M99 Fanuc. ' +
      'Programas no Okuma podem ter nomes alfanuméricos (não só números) — ex: CALL O"FURO_M6". ' +
      'Variáveis locais e globais: V1-V99 locais ao subprograma, V100+ globais. ' +
      'Muito mais flexível que o M98/M99 do Fanuc.',
    sintaxe: 'CALL O[número/nome] L[repetições]\n; No subprograma:\nRTS  ; Fim do subprograma',
    parametros: [
      { letra: 'O', descricao: 'Número ou nome do subprograma (ex: O100 ou O"PERFIL")' },
      { letra: 'L', descricao: 'Número de repetições (padrão: 1)' },
      { letra: 'RTS', descricao: 'Return from Subroutine — substitui M99 do Fanuc' },
    ],
    exemplo:
      '; PROGRAMA PRINCIPAL\nCALL O200 L3  ; Chama O200 — 3 vezes\nM02           ; Fim\n\n; SUBPROGRAMA O200\nG01 X50. F300\nG01 Z-30.\nG01 X60.\nRTS           ; Retorna ao principal',
    explicacaoExemplo:
      'CALL O200 L3 executa o subprograma 3 vezes consecutivamente. RTS retorna após cada execução. L3 = economiza 3 cópias do mesmo código.',
  },

  {
    codigo: 'G330', nome: 'Ciclo de Furação Profunda — Okuma OSP', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Okuma', isG: true,
    descricao: 'Ciclo de peck drilling do Okuma OSP. Equivalente ao G83 Fanuc mas com sintaxe própria e mais parâmetros.',
    descricaoCompleta:
      'G330 é o ciclo de furação profunda no Okuma OSP-P300. ' +
      'Parâmetros: Z = profundidade total, D = incremento de peck, B = afastamento de retorno, F = avanço. ' +
      'O Okuma OSP tem ciclos numerados diferentemente do Fanuc: ' +
      'G330=furação peck, G331=rosqueamento, G332=mandrilamento, G333=alargamento. ' +
      'Importante: o cancelamento é G300 (equivalente ao G80 Fanuc).',
    sintaxe: 'G330 X[x] Y[y] Z[z] D[peck] B[retorno] F[av]',
    parametros: [
      { letra: 'Z', descricao: 'Profundidade total do furo' },
      { letra: 'D', descricao: 'Profundidade do incremento (peck) em mm' },
      { letra: 'B', descricao: 'Distância de retrocesso a cada peck' },
      { letra: 'F', descricao: 'Avanço de furação (mm/min)' },
    ],
    exemplo:
      'T3\nS900 M3\nG0 X50. Y30.\nG330 Z-80. D15. B1. F120\nG300      ; Cancela ciclo (= G80 Fanuc)\nM30',
    explicacaoExemplo:
      'Furo de 80mm em passos de 15mm, recuando 1mm a cada peck. G300 cancela o ciclo — equivalente ao G80. Adaptar F de mm/rot (Fanuc) para mm/min (Okuma).',
  },

  {
    codigo: 'G110 / G111', nome: 'Offset de Ferramenta — Okuma OSP', categoria: 'Ferramenta',
    maquina: 'Centro de Usinagem', fabricante: 'Okuma', isG: true,
    descricao: 'G110 ativa offset de comprimento de ferramenta. G111 cancela. Equivalente ao G43/G49 no Fanuc.',
    descricaoCompleta:
      'No Okuma OSP, o offset de comprimento de ferramenta é chamado com G110 H[número]. ' +
      'G111 cancela (equivalente ao G49). ' +
      'O Okuma usa uma lógica diferente: o número H corresponde ao registro de ferramenta completo (comprimento + raio + desgaste). ' +
      'Muitos Okuma modernos (OSP-P300) já ativam automaticamente o offset quando T[n] é chamado — G110 é confirmação adicional. ' +
      'Verificar no manual: em alguns modelos G110 é substituído por G43 para compatibilidade.',
    sintaxe: 'G110 H[número]  ; Ativa TLO\nG111           ; Cancela TLO',
    parametros: [
      { letra: 'H', descricao: 'Número do registro de offset de ferramenta' },
      { letra: 'G111', descricao: 'Cancela offset de comprimento — equivalente G49 Fanuc' },
    ],
    exemplo:
      'T5           ; Chama fresa T5\nG110 H5      ; Ativa offset comprimento T5\nG0 Z100.\nG0 X0. Y0.\nG0 Z10.\nG1 Z-20. F200\nG111         ; Cancela TLO\nG0 Z100.\nM30',
    explicacaoExemplo:
      'Sequência padrão Okuma: T5 seleciona, G110 H5 aplica o offset de comprimento registrado para a ferramenta 5. G111 cancela ao final.',
  },

  {
    codigo: 'M31 / M32', nome: 'Castanha Principal — Fechar / Abrir (Okuma)', categoria: 'Fixação',
    maquina: 'Torno CNC', fabricante: 'Okuma', isG: false,
    descricao: 'M31 fecha a castanha do torno Okuma. M32 abre. Padrão no OSP-P300/P200 para tornos série LB/LT.',
    descricaoCompleta:
      'Nos tornos Okuma série LB-EX, LT, e MULTUS, M31 fecha a castanha principal e M32 a abre. ' +
      'Nos modelos com sub-spindle: M33/M34 controlam a castanha do contra-spindle. ' +
      'A pressão de aperto pode ser programada por parâmetro ou por código específico antes de M31. ' +
      'Importante: no Okuma, M31 verifica pressão mínima antes de continuar o programa — segurança automática. ' +
      'Em peças frágeis, ajustar pressão por parâmetro P9103 (dependendo do modelo).',
    sintaxe: 'M31  ; Fecha castanha\nM32  ; Abre castanha\nM33  ; Fecha sub-spindle\nM34  ; Abre sub-spindle',
    parametros: [
      { letra: 'M31', descricao: 'Fecha castanha principal — aguarda pressão OK' },
      { letra: 'M32', descricao: 'Abre castanha principal' },
      { letra: 'M33', descricao: 'Fecha castanha do sub-spindle (se equipado)' },
      { letra: 'M34', descricao: 'Abre castanha do sub-spindle' },
    ],
    exemplo:
      'M32         ; Abre para carga\nM00         ; Parada — operador carrega peça\nM31         ; Fecha\nM03 S1000\nG00 X55. Z2.\nG71 U2. R0.5\nG71 P10 Q90 U0.4 W0.1 F0.3\nG70 P10 Q90\nM05 M32 M30',
    explicacaoExemplo:
      'Ciclo com carga manual: M32 abre, M00 para para o operador, M31 fecha com verificação de pressão. M05 M32 M30 finaliza seguro.',
  },

  {
    codigo: 'G2001', nome: 'Interpolação de Alta Velocidade — Okuma', categoria: 'Velocidade',
    maquina: 'Centro de Usinagem', fabricante: 'Okuma', isG: true,
    descricao: 'Ativa modo de usinagem de alta velocidade (HSM) no Okuma OSP. Equivalente ao G05.1 Q1 do Fanuc.',
    descricaoCompleta:
      'G2001 é o código de usinagem de alta velocidade do controle Okuma OSP-P300. ' +
      'Ativa o processamento antecipado de blocos (look-ahead), suavização de trajetória e controle de aceleração adaptativo. ' +
      'Parâmetros específicos do Okuma permitem controlar: ' +
      'Nível de suavização (1-10), tolerância de corda, aceleração máxima. ' +
      'G2000 desativa o modo HSM. ' +
      'Equivalentes em outros controles: Fanuc G05.1 Q1, Siemens CYCLE832, Heidenhain FUNCTION TCPM.',
    sintaxe: 'G2001  ; Ativa HSM\n; ... blocos de usinagem ...\nG2000  ; Desativa HSM',
    parametros: [
      { letra: 'G2001', descricao: 'Ativa modo High Speed Machining — Okuma OSP' },
      { letra: 'G2000', descricao: 'Desativa HSM — retorna modo padrão' },
    ],
    exemplo:
      'G2001        ; Ativa HSM\nG01 X100. F8000\nG03 X80. Y20. R30.\nG01 X60. Y50.\nG02 X40. Y70. R15.\nG2000        ; Desativa\nG00 Z100.',
    explicacaoExemplo:
      'Alta velocidade ativada: o OSP suaviza automaticamente as transições entre G01/G02/G03 sem parar. F8000 (8m/min) possível com G2001 — sem ele, a máquina frenaria em cada mudança de direção.',
  },

  
  
  

  {
    codigo: 'CYCL DEF 6', nome: 'Ciclo 6 — Rosqueamento com Macho (Heidenhain)', categoria: 'Rosqueamento',
    maquina: 'Centro de Usinagem', fabricante: 'Heidenhain', isG: false,
    descricao: 'Define o ciclo de rosqueamento rígido com macho no iTNC/TNC 640. Parâmetros: profundidade, passo, fator de velocidade.',
    descricaoCompleta:
      'CYCL DEF 6 no Heidenhain define um ciclo de rosqueamento com macho (tapping). ' +
      'Q239 = passo da rosca em mm (positivo = direita, negativo = esquerda). ' +
      'Q203/Q204 = coordenada da superfície e 2º plano de segurança. ' +
      'Q206 = avanço de retração (geralmente maior que de entrada). ' +
      'Para executar: CYCL CALL (posição única) ou L X Y FMAX CYCL CALL (com posicionamento). ' +
      'Heidenhain suporta rosqueamento rígido desde iTNC 530 — sem mandril flutuante necessário.',
    sintaxe:
      'CYCL DEF 6.0 ROSQUEAMENTO\nCYCL DEF 6.1 DIST+5\nCYCL DEF 6.2 TIEFE-20\nCYCL DEF 6.3 PASSO+1.25\nCYCL DEF 6.4 F_ENTR600\n\nL X50 Y30 FMAX\nCYCL CALL',
    parametros: [
      { letra: 'DIST', descricao: 'Distância de segurança acima da peça (positivo)' },
      { letra: 'TIEFE', descricao: 'Profundidade de rosca (negativo)' },
      { letra: 'PASSO', descricao: 'Passo da rosca (+ direita, - esquerda)' },
      { letra: 'F_ENTR', descricao: 'Avanço de entrada (mm/min)' },
    ],
    exemplo:
      'CYCL DEF 6.0 ROSQUEAMENTO\nCYCL DEF 6.1 DIST+3\nCYCL DEF 6.2 TIEFE-25\nCYCL DEF 6.3 PASSO+1.0\nCYCL DEF 6.4 F600\n\nTOOL CALL 8 Z S600\nL X30 Y30 FMAX M3\nCYCL CALL\nL X60 Y30 FMAX\nCYCL CALL\nM30',
    explicacaoExemplo:
      'Rosqueia M6×1.0 a 25mm de profundidade em 2 posições. Passo 1.0mm com S600 RPM → F = 600 × 1.0 = 600 mm/min automaticamente calculado pelo controle.',
  },

  {
    codigo: 'CYCL DEF 220', nome: 'Ciclo 220 — Padrão Circular (Heidenhain)', categoria: 'Furação',
    maquina: 'Centro de Usinagem', fabricante: 'Heidenhain', isG: false,
    descricao: 'Distribui o ciclo de furação ativo em N furos igualmente espaçados num círculo. Dispensa programar cada posição.',
    descricaoCompleta:
      'CYCL DEF 220 distribui qualquer ciclo previamente definido (CYCL DEF 1-27) em posições distribuídas num círculo. ' +
      'Q216/Q217 = centro do círculo X e Y. Q244 = diâmetro do padrão. ' +
      'Q245 = ângulo do primeiro furo. Q246 = ângulo do último furo. Q247 = passo angular entre furos. Q241 = número de repetições. ' +
      'Extremamente eficiente: defina o ciclo uma vez (ex: CYCL DEF 1 furação) e chame o 220 para distribuí-lo.',
    sintaxe:
      'CYCL DEF 1.0 FURACAO  ; ciclo base\nCYCL DEF 220.0 PADRAO CIRCULAR\nCYCL DEF 220.1 Q216=50  ; centro X\nCYCL DEF 220.2 Q217=50  ; centro Y\nCYCL DEF 220.3 Q244=60  ; Ø padrão\nCYCL DEF 220.4 Q245=0   ; ângulo 1°\nCYCL DEF 220.5 Q246=360 ; ângulo final\nCYCL DEF 220.6 Q241=6   ; 6 furos\nCYCL CALL',
    parametros: [
      { letra: 'Q216/Q217', descricao: 'Coordenadas XY do centro do padrão circular' },
      { letra: 'Q244', descricao: 'Diâmetro do padrão (círculo dos furos)' },
      { letra: 'Q245/Q246', descricao: 'Ângulo do primeiro e último furo' },
      { letra: 'Q241', descricao: 'Número de furos/posições' },
    ],
    exemplo:
      '; 6 furos em círculo Ø60mm, centro X50 Y50\nCYCL DEF 1.0 FURACAO\nCYCL DEF 1.1 DIST+3\nCYCL DEF 1.2 TIEFE-15\nCYCL DEF 1.3 F200\nCYCL DEF 220.0 PADRAO CIRC\nCYCL DEF 220.1 Q216=50\nCYCL DEF 220.2 Q217=50\nCYCL DEF 220.3 Q244=60\nCYCL DEF 220.5 Q246=360\nCYCL DEF 220.6 Q241=6\nCYCL CALL',
    explicacaoExemplo:
      '6 furos a cada 60° num círculo de Ø60mm, centro em X50 Y50. Sem o 220, seriam 6 blocos L X Y + CYCL CALL. Com o 220: um bloco faz tudo.',
  },

  {
    codigo: 'G54.1 / G54 P', nome: 'Offsets de Trabalho Estendidos', categoria: 'Coordenadas',
    maquina: 'Centro de Usinagem', fabricante: 'Fanuc / Haas',
    descricao: 'Expande os 6 offsets básicos para até 300 (Fanuc G54.1 P1-P300) ou 99 (Haas G54 P1-P99). Essencial para sistemas pallet.',
    descricaoCompleta:
      'Fanuc G54.1 P1 a P300: expande além dos G54-G59 básicos (com opção de memória). ' +
      'Haas G54 P1 a P99: extensão proprietária. ' +
      'Aplicação: sistemas pallet com múltiplas fixações, gabaritos com muitas peças, células robotizadas. ' +
      'Offsets persistentes — mantêm valores após desligar a máquina. ' +
      'Funcionam exatamente como G54-G59 em termos de uso no programa.',
    sintaxe: 'G54.1 P[1-300]  ; Fanuc\nG54 P[1-99]     ; Haas',
    parametros: [
      { letra: 'P', descricao: 'Número do offset estendido' },
    ],
    exemplo:
      'G54.1 P1    ; Pallet 1\n' +
      'M98 P1000   ; Usina\n' +
      'G54.1 P2    ; Pallet 2\n' +
      'M98 P1000   ; Mesmo programa\n' +
      'G54.1 P3    ; Pallet 3\n' +
      'M98 P1000',
    explicacaoExemplo:
      'O subprograma M98 P1000 usina 3 pallets diferentes apenas trocando G54.1 P— sem alterar o programa de usinagem.',
    isG: true,
  },
];
export const codigosMExtras: CodigoItem[] = [

  
  {codigo: 'M14', nome: 'Trava Eixo C', categoria: 'Controle', maquina: 'Torno CNC',
    fabricante: 'Universal', diagramaTipo: 'trava_eixo',
    descricao: 'Trava o eixo C para operações de fresamento no torno.',
    descricaoCompleta: 'M14 ativa o freio/trava do eixo C. Usado em tornos com eixo C para fresamento excêntrico, chavetas e furos fora do centro.',
    sintaxe: 'M14', parametros: [],
    exemplo: 'S500 M03\nM14\nG01 X10. F80',
    explicacaoExemplo: 'Liga spindle, trava eixo C e fresa.', isG: false},

  {codigo: 'M15', nome: 'Destrava Eixo C', categoria: 'Controle', maquina: 'Torno CNC',
    fabricante: 'Universal', diagramaTipo: 'trava_eixo',
    descricao: 'Libera o freio do eixo C para retornar ao torneamento.',
    descricaoCompleta: 'M15 cancela a trava do eixo C. Necessário antes de retornar ao torneamento convencional.',
    sintaxe: 'M15', parametros: [],
    exemplo: 'M15\nG97 S1200 M03',
    explicacaoExemplo: 'Destrava C e retorna ao torneamento.', isG: false},

  {codigo: 'M16', nome: 'Posição de Troca de Ferramenta', categoria: 'Ferramenta', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'Move a máquina para a posição definida de troca de ferramenta.',
    descricaoCompleta: 'M16 envia a máquina para a posição programada de troca (diferente do G28). Usado em centros com troca em posição específica.',
    sintaxe: 'M16', parametros: [],
    exemplo: 'M16\nT03 M06',
    explicacaoExemplo: 'Vai à posição de troca e executa M06.', isG: false},

  {codigo: 'M17', nome: 'Retorno de Subprograma (Siemens)', categoria: 'Subprograma', maquina: 'Ambos',
    fabricante: 'Siemens',
    descricao: 'Equivalente ao M99 do Fanuc — retorna de subprograma no Siemens.',
    descricaoCompleta: 'No controle Siemens SINUMERIK, M17 finaliza um subprograma e retorna ao programa chamador. Equivale ao M99 no Fanuc.',
    sintaxe: 'M17', parametros: [],
    exemplo: '; SUBPROGRAMA SUB1.SPF\nG01 X50. F200\nM17',
    explicacaoExemplo: 'Fim do sub no Siemens — retorna ao principal.', isG: false},

  {codigo: 'M18', nome: 'Cancela Parada Orientada do Spindle', categoria: 'Spindle', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'Cancela o M19 (spindle orientation), liberando rotação livre.',
    descricaoCompleta: 'M18 cancela a orientação fixa do spindle definida pelo M19. O spindle volta ao modo de rotação normal.',
    sintaxe: 'M18', parametros: [],
    exemplo: 'M19\nM06 T02\nM18\nS2500 M03',
    explicacaoExemplo: 'Orienta, troca ferramenta, cancela orientação e liga.', isG: false},

  
  {codigo: 'M25', nome: 'Abre Chuck / Pinça', categoria: 'Fixação', maquina: 'Torno CNC',
    fabricante: 'Universal', diagramaTipo: 'chuck',
    descricao: 'Abre o chuck ou pinça para troca de peça.',
    descricaoCompleta: 'M25 abre o chuck (castanha) ou pinça. Dependendo do fabricante pode ser abre ou fecha — confirme sempre no manual da máquina. Fanuc: M25 geralmente abre. Mazak: pode variar.',
    sintaxe: 'M25', parametros: [],
    exemplo: 'G00 Z100.\nM25\n; (TROCAR PEÇA)\nM26',
    explicacaoExemplo: 'Recua Z, abre chuck para troca, fecha com M26.', isG: false},

  {codigo: 'M26', nome: 'Fecha Chuck / Pinça', categoria: 'Fixação', maquina: 'Torno CNC',
    fabricante: 'Universal', diagramaTipo: 'chuck',
    descricao: 'Fecha o chuck ou pinça prendendo a peça.',
    descricaoCompleta: 'M26 fecha o chuck. Par do M25. A pressão de fechamento é controlada por parâmetro de máquina. Checar direção de operação no manual.',
    sintaxe: 'M26', parametros: [],
    exemplo: 'M25\n; (POSICIONAR PEÇA)\nM26\nS1500 M03',
    explicacaoExemplo: 'Abre, posiciona peça, fecha e liga spindle.', isG: false},

  {codigo: 'M27', nome: 'Verificação de Chuck', categoria: 'Fixação', maquina: 'Torno CNC',
    fabricante: 'Universal', diagramaTipo: 'chuck',
    descricao: 'Verifica se o chuck está devidamente fechado antes de continuar.',
    descricaoCompleta: 'M27 realiza verificação de segurança do chuck. Se não estiver travado corretamente, o programa para com alarme. Essencial em linhas automáticas.',
    sintaxe: 'M27', parametros: [],
    exemplo: 'M26\nM27\nS2000 M03',
    explicacaoExemplo: 'Fecha chuck, verifica fixação e só então liga spindle.', isG: false},

  {codigo: 'M28', nome: 'Retorno ao Ponto de Referência de Ferramenta', categoria: 'Ferramenta', maquina: 'Ambos',
    fabricante: 'Fanuc', diagramaTipo: 'referencia',
    descricao: 'Retorna ao ponto de referência de troca — similar ao G28 mas para ferramenta.',
    descricaoCompleta: 'M28 (Fanuc) envia a ferramenta de volta ao ponto de referência de troca definido por parâmetro. Em outras marcas pode acionar braco da ferramenta ou retrair porta-ferramenta.',
    sintaxe: 'M28', parametros: [],
    exemplo: 'G01 Z-5. F100\nM28\nT04 M06',
    explicacaoExemplo: 'Finaliza corte, retorna ao ref. e troca.', isG: false},

  {codigo: 'M29', nome: 'Modo de Rosqueamento Rígido', categoria: 'Rosqueamento', maquina: 'Centro de Usinagem',
    fabricante: 'Fanuc', diagramaTipo: 'rosca',
    descricao: 'Ativa sincronismo spindle-eixo Z para rosqueamento rígido (sem flutuante).',
    descricaoCompleta: 'M29 ativa o modo rígido (rigid tapping). O spindle e o eixo Z ficam sincronizados eletricamente. Elimina a necessidade de mandril flutuante. Mais preciso e rápido. Usar antes de G84.',
    sintaxe: 'S[RPM] M29\nG84 Z[prof] R[retorno] F[passo]',
    parametros: [{ letra: 'S', descricao: 'RPM sincronizado com o passo' }],
    exemplo: 'S800 M29\nG84 Z-25. R3. F1.25',
    explicacaoExemplo: 'M10×1.25: 800 RPM rígido, rosqueia 25mm profundidade.', isG: false},

  
  {codigo: 'M31', nome: 'Bypass de Intertravamento', categoria: 'Controle', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'Ignora temporariamente o interlock de segurança (usar com cuidado!).',
    descricaoCompleta: 'M31 bypassa intertravamentos elétricos temporariamente. Uso restrito — apenas por técnicos habilitados. Em muitas máquinas modernas este código é desabilitado por segurança.',
    sintaxe: 'M31', parametros: [],
    exemplo: '; ATENÇÃO: Usar somente em manutenção\nM31',
    explicacaoExemplo: 'Bypass de interlock — apenas manutenção especializada.', isG: false},

  {codigo: 'M32', nome: 'Liga Sopro de Ar', categoria: 'Refrigeração', maquina: 'Ambos',
    fabricante: 'Universal', diagramaTipo: 'air_blow',
    descricao: 'Ativa o sopro de ar comprimido para limpeza de cavacos.',
    descricaoCompleta: 'M32 liga o bico de ar comprimido. Muito usado para limpar a peça, o prendedor e a ferramenta entre operações. Boa prática antes de medições.',
    sintaxe: 'M32', parametros: [],
    exemplo: 'G00 Z50.\nM32\nG04 P2000\nM33',
    explicacaoExemplo: 'Retrai, sopra ar por 2s e desliga.', isG: false},

  {codigo: 'M33', nome: 'Desliga Sopro de Ar', categoria: 'Refrigeração', maquina: 'Ambos',
    fabricante: 'Universal', diagramaTipo: 'air_blow',
    descricao: 'Desativa o sopro de ar comprimido.',
    descricaoCompleta: 'M33 desliga o sopro de ar. Par do M32. Sempre desligar antes de iniciar usinagem para não interferir no refrigerante.',
    sintaxe: 'M33', parametros: [],
    exemplo: 'M32\nG04 P1500\nM33\nG01 Z-5. F150',
    explicacaoExemplo: 'Sopra, aguarda 1.5s, desliga e inicia corte.', isG: false},

  {codigo: 'M36', nome: 'Range de Avanço 1 (Baixo)', categoria: 'Avanço', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'Seleciona a gama de avanço baixa (1° faixa).',
    descricaoCompleta: 'M36 seleciona a primeira faixa de avanço da caixa de câmbio mecânica. Para materiais duros e passes pesados com baixa velocidade.',
    sintaxe: 'M36', parametros: [],
    exemplo: 'M36\nG01 Z-5. F50',
    explicacaoExemplo: 'Gama baixa para corte pesado.', isG: false},

  {codigo: 'M37', nome: 'Range de Avanço 2 (Alto)', categoria: 'Avanço', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'Seleciona a gama de avanço alta (2° faixa).',
    descricaoCompleta: 'M37 seleciona a segunda faixa de avanço. Para operações de acabamento e materiais macios.',
    sintaxe: 'M37', parametros: [],
    exemplo: 'M37\nG01 X50. F800',
    explicacaoExemplo: 'Gama alta para acabamento rápido.', isG: false},

  {codigo: 'M40', nome: 'Seleção Automática de Engrenagem', categoria: 'Spindle', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'O CNC seleciona automaticamente a melhor gama de velocidade do spindle.',
    descricaoCompleta: 'M40 deixa o controle CNC selecionar automaticamente a gama correta (M41/M42) baseado na velocidade S programada. Mais conveniente e evita erros.',
    sintaxe: 'M40', parametros: [],
    exemplo: 'M40\nS3000 M03',
    explicacaoExemplo: 'CNC escolhe gama ideal para 3000 RPM.', isG: false},

  
  {codigo: 'M43', nome: 'Aumenta Override de Avanço +1%', categoria: 'Override', maquina: 'Ambos',
    fabricante: 'Haas',
    descricao: 'Incrementa o override de avanço em 1% (específico Haas).',
    descricaoCompleta: 'M43 (Haas) aumenta o feed override em 1% por vez via programa. Permite ajustes finos de velocidade dentro do programa automático.',
    sintaxe: 'M43', parametros: [],
    exemplo: 'M43\nM43\nM43',
    explicacaoExemplo: 'Aumenta override 3% progressivamente.', isG: false},

  {codigo: 'M44', nome: 'Diminui Override de Avanço -1%', categoria: 'Override', maquina: 'Ambos',
    fabricante: 'Haas',
    descricao: 'Decrementa o override de avanço em 1% (específico Haas).',
    descricaoCompleta: 'M44 (Haas) reduz o feed override em 1% por execução.',
    sintaxe: 'M44', parametros: [],
    exemplo: 'G01 X50. F500\nM44\nM44',
    explicacaoExemplo: 'Corta e reduz avanço 2%.', isG: false},

  {codigo: 'M47', nome: 'Execução Contínua do Programa', categoria: 'Controle', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'Reinicia o programa do início ao atingir o fim — loop contínuo.',
    descricaoCompleta: 'M47 cria um loop infinito do programa. A máquina executa continuamente sem parar. Usado em células de produção série automatizadas.',
    sintaxe: 'M47', parametros: [],
    exemplo: 'O0001\n; ... programa ...\nM47',
    explicacaoExemplo: 'Programa roda continuamente até operador interromper.', isG: false},

  
  {codigo: 'M52', nome: 'Ar pelo Furo da Ferramenta', categoria: 'Refrigeração', maquina: 'Centro de Usinagem',
    fabricante: 'Universal', diagramaTipo: 'air_blow',
    descricao: 'Ativa sopro de ar interno pela ferramenta (through-tool air).',
    descricaoCompleta: 'M52 liga o ar comprimido pelo canal interno da ferramenta. Para fresas e brocas com furo central. Excelente para alumínio e materiais que não podem molhar.',
    sintaxe: 'M52', parametros: [],
    exemplo: 'T01 M06\nS8000 M03\nM52\nG01 Z-20. F1200',
    explicacaoExemplo: 'Fresa com ar interno — ideal para alumínio.', isG: false},

  {codigo: 'M53', nome: 'Desliga Ar pelo Furo', categoria: 'Refrigeração', maquina: 'Centro de Usinagem',
    fabricante: 'Universal',
    descricao: 'Desativa o ar interno pela ferramenta.',
    descricaoCompleta: 'M53 desliga o ar through-tool. Par do M52.',
    sintaxe: 'M53', parametros: [],
    exemplo: 'G01 Z5.\nM53\nM09',
    explicacaoExemplo: 'Retrai ferramenta e desliga ar interno.', isG: false},

  {codigo: 'M54', nome: 'Liga Esteira de Cavacos (Avançar)', categoria: 'Automação', maquina: 'Centro de Usinagem',
    fabricante: 'Universal', diagramaTipo: 'chip_conveyor',
    descricao: 'Liga a esteira transportadora de cavacos no sentido de descarte.',
    descricaoCompleta: 'M54 aciona o chip conveyor (esteira de cavacos) para frente. Usado em centros de usinagem de produção contínua para remoção automática de cavacos.',
    sintaxe: 'M54', parametros: [],
    exemplo: 'M54\n; (usinagem contínua)\nM55',
    explicacaoExemplo: 'Liga esteira, usina, depois para.', isG: false},

  {codigo: 'M55', nome: 'Para Esteira de Cavacos', categoria: 'Automação', maquina: 'Centro de Usinagem',
    fabricante: 'Universal',
    descricao: 'Para a esteira transportadora de cavacos.',
    descricaoCompleta: 'M55 para o chip conveyor.',
    sintaxe: 'M55', parametros: [],
    exemplo: 'G00 Z100.\nM55\nM30',
    explicacaoExemplo: 'Para esteira ao fim do programa.', isG: false},

  {codigo: 'M56', nome: 'Liga Esteira de Cavacos (Reverso)', categoria: 'Automação', maquina: 'Centro de Usinagem',
    fabricante: 'Universal',
    descricao: 'Liga a esteira em reverso para desentupir acúmulo de cavacos.',
    descricaoCompleta: 'M56 aciona o chip conveyor em reverso. Usado quando cavacos enroscam ou acumulam. Geralmente usado por alguns segundos apenas.',
    sintaxe: 'M56', parametros: [],
    exemplo: 'M56\nG04 P3000\nM54',
    explicacaoExemplo: 'Reverso 3s para desentupir, depois avança.', isG: false},

  {codigo: 'M57', nome: 'Liga Refrigeração de Alta Pressão', categoria: 'Refrigeração', maquina: 'Centro de Usinagem',
    fabricante: 'Universal', diagramaTipo: 'alta_pressao',
    descricao: 'Ativa refrigeração de alta pressão (70-100 bar) pelo furo da ferramenta.',
    descricaoCompleta: 'M57 liga HPC (High Pressure Coolant). Quebra cavacos, melhora vida de ferramenta e permite maiores avanços. Ideal para aço inox, titânio e furação profunda. Pressão típica: 70-100 bar.',
    sintaxe: 'M57', parametros: [],
    exemplo: 'T01 M06\nS3000 M03\nM08\nM57\nG83 Z-80. R3. Q8. F120',
    explicacaoExemplo: 'Furação profunda com HPC — quebra cavaco a cada 8mm.', isG: false},

  {codigo: 'M58', nome: 'Desliga Refrigeração Alta Pressão', categoria: 'Refrigeração', maquina: 'Centro de Usinagem',
    fabricante: 'Universal',
    descricao: 'Desativa o sistema de alta pressão.',
    descricaoCompleta: 'M58 desliga o HPC. Sempre desligar antes de trocar ferramenta para não contaminar o ATC.',
    sintaxe: 'M58', parametros: [],
    exemplo: 'M58\nM09\nG28 Z0\nT02 M06',
    explicacaoExemplo: 'Desliga HPC, depois fluido, retorna e troca.', isG: false},

  
  {codigo: 'M62', nome: 'Saída Auxiliar 1 — Liga', categoria: 'Automação', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'Ativa a saída digital auxiliar 1 (relé externo, sinalizador, robô).',
    descricaoCompleta: 'M62 liga a saída digital 1. Usada para acionar dispositivos externos: sinalizadores, relés, robôs colaborativos, fixadores hidráulicos, etc. A função exata depende do integrador.',
    sintaxe: 'M62', parametros: [],
    exemplo: 'M62\nG04 P500\nG01 Z-10. F100',
    explicacaoExemplo: 'Liga auxiliar 1 (ex: fixador hidráulico) e inicia corte.', isG: false},

  {codigo: 'M63', nome: 'Saída Auxiliar 1 — Desliga', categoria: 'Automação', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'Desativa a saída digital auxiliar 1.',
    descricaoCompleta: 'M63 desliga a saída digital 1. Par do M62.',
    sintaxe: 'M63', parametros: [],
    exemplo: 'G00 Z50.\nM63',
    explicacaoExemplo: 'Retrai e desliga auxiliar 1.', isG: false},

  {codigo: 'M64', nome: 'Saída Auxiliar 2 — Liga', categoria: 'Automação', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'Ativa a saída digital auxiliar 2.',
    descricaoCompleta: 'M64 liga a saída digital 2. Função definida pelo integrador da máquina.',
    sintaxe: 'M64', parametros: [],
    exemplo: 'M64\nG04 P1000',
    explicacaoExemplo: 'Liga auxiliar 2 por 1 segundo.', isG: false},

  {codigo: 'M65', nome: 'Saída Auxiliar 2 — Desliga', categoria: 'Automação', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'Desativa a saída digital auxiliar 2.',
    descricaoCompleta: 'M65 desliga a saída digital 2. Par do M64.',
    sintaxe: 'M65', parametros: [],
    exemplo: 'G04 P1000\nM65',
    explicacaoExemplo: 'Aguarda 1s e desliga auxiliar 2.', isG: false},

  {codigo: 'M68', nome: 'Liga Fixador Hidráulico / Pneumático', categoria: 'Fixação', maquina: 'Ambos',
    fabricante: 'Universal', diagramaTipo: 'fixador',
    descricao: 'Aciona o sistema de fixação hidráulica ou pneumática da peça.',
    descricaoCompleta: 'M68 fecha/ativa o fixador hidráulico ou pneumático. Usado em células de automação e dispositivos automáticos. A peça é presa sem intervenção do operador.',
    sintaxe: 'M68', parametros: [],
    exemplo: 'M68\nG04 P500\nM27\nS2000 M03',
    explicacaoExemplo: 'Fecha fixador, aguarda 0.5s, verifica e liga spindle.', isG: false},

  {codigo: 'M69', nome: 'Desliga Fixador Hidráulico / Pneumático', categoria: 'Fixação', maquina: 'Ambos',
    fabricante: 'Universal', diagramaTipo: 'fixador',
    descricao: 'Libera o sistema de fixação para troca de peça.',
    descricaoCompleta: 'M69 abre/desativa o fixador. Par do M68. Sempre executar após retornar à posição segura.',
    sintaxe: 'M69', parametros: [],
    exemplo: 'G28 Z0\nM05\nM69',
    explicacaoExemplo: 'Retorna ao zero, para spindle e libera peça.', isG: false},

  
  {codigo: 'M70', nome: 'Espelhamento em X (Fanuc)', categoria: 'Transformação', maquina: 'Centro de Usinagem',
    fabricante: 'Fanuc', diagramaTipo: 'espelhamento',
    descricao: 'Ativa espelhamento em X — peças simétricas sem reprogramar.',
    descricaoCompleta: 'M70 (Fanuc) ativa o espelhamento no eixo X. O programa original é espelhado automaticamente. Ideal para peças simétricas — esquerdo/direito.',
    sintaxe: 'M70', parametros: [],
    exemplo: 'O0010 (LADO DIREITO)\n; ... programa ...\nM99\n\nO0001\nM98 P0010  (direito)\nM70\nM98 P0010  (espelha = esquerdo)\nM71',
    explicacaoExemplo: 'Chama sub-rotina para lado D e E sem duplicar código.', isG: false},

  {codigo: 'M71', nome: 'Cancela Espelhamento X (Fanuc)', categoria: 'Transformação', maquina: 'Centro de Usinagem',
    fabricante: 'Fanuc',
    descricao: 'Cancela o espelhamento ativo em X.',
    descricaoCompleta: 'M71 desativa o M70. Sempre cancelar ao final para não afetar próximas operações.',
    sintaxe: 'M71', parametros: [],
    exemplo: 'M70\nM98 P100\nM71',
    explicacaoExemplo: 'Espelha, executa sub e cancela.', isG: false},

  {codigo: 'M74', nome: 'Desativa Detecção de Erro', categoria: 'Controle', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'Suspende temporariamente a detecção de erro de programa.',
    descricaoCompleta: 'M74 desabilita temporariamente alarmes não críticos durante operação específica. Usar com cautela — pode mascarar problemas reais.',
    sintaxe: 'M74', parametros: [],
    exemplo: 'M74\nG04 P500\nM75',
    explicacaoExemplo: 'Desativa erro por 0.5s durante transição crítica.', isG: false},

  {codigo: 'M75', nome: 'Ativa Detecção de Erro', categoria: 'Controle', maquina: 'Ambos',
    fabricante: 'Universal',
    descricao: 'Reativa o monitoramento de erros após M74.',
    descricaoCompleta: 'M75 reativa a detecção de erros. Par do M74. Sempre reativar após uso.',
    sintaxe: 'M75', parametros: [],
    exemplo: 'M74\n; (operação)\nM75',
    explicacaoExemplo: 'Reativa monitoramento.', isG: false},

  {codigo: 'M77', nome: 'Mede Comprimento da Ferramenta', categoria: 'Medição', maquina: 'Centro de Usinagem',
    fabricante: 'Universal', diagramaTipo: 'medicao',
    descricao: 'Aciona o ciclo automático de medição de comprimento de ferramenta.',
    descricaoCompleta: 'M77 aciona o apalpador de ferramentas (tool setter). O CNC mede automaticamente o comprimento e atualiza o offset H correspondente. Elimina erros de setup.',
    sintaxe: 'T[n] M06\nM77', parametros: [],
    exemplo: 'T03 M06\nM77\nG43 H03 Z100.',
    explicacaoExemplo: 'Troca T3, mede comprimento, aplica offset H03.', isG: false},

  {codigo: 'M78', nome: 'Mede Diâmetro da Ferramenta', categoria: 'Medição', maquina: 'Centro de Usinagem',
    fabricante: 'Universal', diagramaTipo: 'medicao',
    descricao: 'Mede automaticamente o diâmetro da fresa e atualiza offset D.',
    descricaoCompleta: 'M78 aciona medição lateral do apalpador de ferramentas para medir diâmetro. Atualiza o offset D para compensação de raio G41/G42.',
    sintaxe: 'M78', parametros: [],
    exemplo: 'T01 M06\nM77\nM78\nG43 H01 Z50.',
    explicacaoExemplo: 'Mede C e D da ferramenta automaticamente.', isG: false},

  
  {codigo: 'M80', nome: 'Liga Porta Automática', categoria: 'Automação', maquina: 'Centro de Usinagem',
    fabricante: 'Haas', diagramaTipo: 'porta',
    descricao: 'Abre/fecha a porta automática da máquina (Haas).',
    descricaoCompleta: 'M80 (Haas) aciona a porta automática opcional. Usado em células robotizadas para entrada/saída automática de peças sem intervenção do operador.',
    sintaxe: 'M80', parametros: [],
    exemplo: 'M30\nM80\n; (robô troca peça)\nM81\nM03',
    explicacaoExemplo: 'Abre porta para robô, fecha e reinicia.', isG: false},

  {codigo: 'M81', nome: 'Fecha Porta Automática', categoria: 'Automação', maquina: 'Centro de Usinagem',
    fabricante: 'Haas',
    descricao: 'Fecha a porta automática da máquina (Haas).',
    descricaoCompleta: 'M81 fecha a porta automática. Par do M80.',
    sintaxe: 'M81', parametros: [],
    exemplo: 'M80\nG04 P3000\nM81',
    explicacaoExemplo: 'Abre por 3s e fecha.', isG: false},

  {codigo: 'M88', nome: 'Liga Refrigeração de Alta Pressão (Haas)', categoria: 'Refrigeração', maquina: 'Centro de Usinagem',
    fabricante: 'Haas', diagramaTipo: 'alta_pressao',
    descricao: 'Liga o sistema HPC (High Pressure Coolant) no controle Haas.',
    descricaoCompleta: 'M88 (Haas) ativa o sistema de refrigeração de alta pressão. Equivalente ao M57 em outras marcas. Requer a opção instalada na máquina.',
    sintaxe: 'M88', parametros: [],
    exemplo: 'S2500 M03\nM08\nM88\nG01 Z-50. F200',
    explicacaoExemplo: 'Liga spindle, flood e HPC para furação profunda.', isG: false},

  {codigo: 'M89', nome: 'Desliga Refrigeração de Alta Pressão (Haas)', categoria: 'Refrigeração', maquina: 'Centro de Usinagem',
    fabricante: 'Haas',
    descricao: 'Desliga o HPC no controle Haas.',
    descricaoCompleta: 'M89 (Haas) desativa o sistema HPC. Par do M88.',
    sintaxe: 'M89', parametros: [],
    exemplo: 'M89\nM09\nG28 Z0',
    explicacaoExemplo: 'Desliga HPC e flood, retorna ao zero.', isG: false},

  
  {codigo: 'M91', nome: 'Vai ao Zero Máquina em X e Y (Haas)', categoria: 'Referência', maquina: 'Ambos',
    fabricante: 'Haas', diagramaTipo: 'referencia',
    descricao: 'Move X e Y para o zero máquina — ignora workpiece offsets.',
    descricaoCompleta: 'M91 (Haas) move a máquina para o zero absoluto da máquina em X e Y, ignorando todos os offsets de peça (G54-G59). Útil para manutenção e posicionamento de referência.',
    sintaxe: 'M91', parametros: [],
    exemplo: 'G00 Z50.\nM91',
    explicacaoExemplo: 'Retrai Z e move X,Y ao zero máquina.', isG: false},

  {codigo: 'M92', nome: 'Vai ao Zero Secundário (Haas)', categoria: 'Referência', maquina: 'Ambos',
    fabricante: 'Haas',
    descricao: 'Move aos eixos para o zero secundário programado (Haas).',
    descricaoCompleta: 'M92 (Haas) envia os eixos para uma segunda posição de referência definida por parâmetro. Útil para troca de peça em posição específica.',
    sintaxe: 'M92', parametros: [],
    exemplo: 'M92\n; (troca peça na posição secundária)',
    explicacaoExemplo: 'Posição alternativa de troca.', isG: false},

  {codigo: 'M95', nome: 'Modo Sleep / Espera (Haas)', categoria: 'Controle', maquina: 'Ambos',
    fabricante: 'Haas',
    descricao: 'Pausa o programa por um tempo determinado — modo hibernação.',
    descricaoCompleta: 'M95 (Haas) coloca a máquina em modo de espera por tempo determinado. Pode ser usado para aguardar tempo de cura de cola, resfriamento de peça ou sincronizar com outro processo.',
    sintaxe: 'M95 (HH:MM)',
    parametros: [{ letra: 'HH:MM', descricao: 'Horas e minutos de espera' }],
    exemplo: 'M95 (00:30)',
    explicacaoExemplo: 'Máquina aguarda 30 minutos (ex: cura de resina).', isG: false},

  {codigo: 'M96', nome: 'Pular se Entrada Inativa (Haas)', categoria: 'Controle', maquina: 'Ambos',
    fabricante: 'Haas',
    descricao: 'Pula para bloco N se entrada digital estiver desligada (Haas).',
    descricaoCompleta: 'M96 (Haas) é um desvio condicional. Se a entrada digital especificada estiver LOW (0), pula para o bloco N indicado. Permite lógica condicional no programa.',
    sintaxe: 'M96 P[bloco] Q[entrada]',
    parametros: [{ letra: 'P', descricao: 'Número do bloco destino' }, { letra: 'Q', descricao: 'Número da entrada digital' }],
    exemplo: 'M96 P100 Q1\nG01 Z-10. F100\nN100 M30',
    explicacaoExemplo: 'Se entrada 1 = OFF, pula para N100 (fim).', isG: false},

  {codigo: 'M97', nome: 'Chamada de Subprograma Local (Haas)', categoria: 'Subprograma', maquina: 'Ambos',
    fabricante: 'Haas',
    descricao: 'Chama uma sub-rotina local pelo número de bloco N (Haas).',
    descricaoCompleta: 'M97 (Haas) chama uma sub-rotina definida no mesmo programa pelo label N. Mais eficiente que M98 para sub-rotinas pequenas dentro do mesmo arquivo.',
    sintaxe: 'M97 P[N-label]',
    parametros: [{ letra: 'P', descricao: 'Número N do label da sub-rotina' }],
    exemplo: 'M97 P1000\nG00 Z50.\nM30\n\nN1000\nG01 Z-5. F100\nM99',
    explicacaoExemplo: 'Chama N1000 (sub local) sem arquivo separado.', isG: false},

  
  {codigo: 'SPOS', nome: 'Posicionamento do Spindle (Siemens)', categoria: 'Spindle', maquina: 'Ambos',
    fabricante: 'Siemens', diagramaTipo: 'spindle_pos',
    descricao: 'Posiciona o spindle em ângulo exato — específico Siemens SINUMERIK.',
    descricaoCompleta: 'SPOS (Siemens) posiciona o spindle em um ângulo angular específico. Diferente do M19, permite definir qualquer ângulo de 0° a 360°.',
    sintaxe: 'SPOS=<ângulo>',
    parametros: [{ letra: 'ângulo', descricao: 'Posição em graus (0.001° resolução)' }],
    exemplo: 'SPOS=0\nSPOS=90\nSPOS=180',
    explicacaoExemplo: 'Posiciona spindle a 0°, 90° e 180°.', isG: false},

  {codigo: 'M70 (SIE)', nome: 'Modo Eixo (Siemens)', categoria: 'Spindle', maquina: 'Ambos',
    fabricante: 'Siemens',
    descricao: 'Coloca o spindle em modo eixo controlado posicionalmente (Siemens).',
    descricaoCompleta: 'M70 (Siemens SINUMERIK) transforma o spindle em um eixo posicional controlado (eixo C). Diferente do M70 Fanuc (espelhamento). Atenção: mesmo código, funções diferentes.',
    sintaxe: 'M70', parametros: [],
    exemplo: 'M70\nG01 C90. F5.',
    explicacaoExemplo: 'Modo eixo C: gira 90° de forma precisa.', isG: false},

  
  {codigo: 'M89', nome: 'Ciclo Modal Ativo (Heidenhain)', categoria: 'Ciclo', maquina: 'Centro de Usinagem',
    fabricante: 'Heidenhain',
    descricao: 'Executa o último ciclo de furação programado em cada posição (Heidenhain).',
    descricaoCompleta: 'M89 (Heidenhain iTNC) torna o último CYCL DEF ativo de forma modal — executa o ciclo automaticamente em cada posição programada seguinte. Para cancelar: CYCL CALL ou M99.',
    sintaxe: 'CYCL DEF ...\nM89',
    parametros: [],
    exemplo: 'CYCL DEF 200 DRILLING\nL X10 Y10 M89\nL X30 Y10\nL X50 Y10',
    explicacaoExemplo: 'Fura nas posições X10, X30 e X50 automaticamente.', isG: false},

  {codigo: 'M90', nome: 'Velocidade Constante em Cantos (Heidenhain)', categoria: 'Movimento', maquina: 'Centro de Usinagem',
    fabricante: 'Heidenhain',
    descricao: 'Mantém velocidade constante em cantos — sem desaceleração (Heidenhain).',
    descricaoCompleta: 'M90 (Heidenhain) desativa a desaceleração automática nos cantos do contorno. A máquina mantém velocidade constante. Deixa pequenos arredondamentos nos cantos — usado para acabamentos de alta velocidade (HSM).',
    sintaxe: 'L X... Y... F... M90',
    parametros: [],
    exemplo: 'L X50 Y0 F3000 M90\nL X50 Y50 F3000 M90',
    explicacaoExemplo: 'Fresamento HSM sem desaceleração em cantos.', isG: false},

  {codigo: 'M91', nome: 'Posição Relativa ao Zero Máquina (Heidenhain)', categoria: 'Referência', maquina: 'Ambos',
    fabricante: 'Heidenhain', diagramaTipo: 'referencia',
    descricao: 'Movimento em coordenadas relativas ao zero máquina (Heidenhain).',
    descricaoCompleta: 'M91 (Heidenhain iTNC) faz o bloco seguinte usar coordenadas relativas ao ponto zero da máquina (REF), ignorando o datum da peça (preset). Ativo apenas para o bloco em que aparece.',
    sintaxe: 'L Z+100 M91',
    parametros: [],
    exemplo: 'L Z+200 M91 FMAX',
    explicacaoExemplo: 'Move Z para 200mm acima do zero máquina.', isG: false},

  {codigo: 'M92', nome: 'Posição Absoluta na Máquina (Heidenhain)', categoria: 'Referência', maquina: 'Ambos',
    fabricante: 'Heidenhain',
    descricao: 'Posição absoluta em coordenadas de máquina — ignora datum da peça.',
    descricaoCompleta: 'M92 (Heidenhain) move para posição definida em coordenadas absolutas da máquina. Útil para ir ao ponto de troca de ferramenta específico.',
    sintaxe: 'L X+0 Y+0 M92 FMAX',
    parametros: [],
    exemplo: 'L Z+200 M92 FMAX',
    explicacaoExemplo: 'Sobe Z ao ponto de troca em coordenada máquina.', isG: false},

  
  {codigo: 'M200', nome: 'Confirmar Código T (Mazak)', categoria: 'Ferramenta', maquina: 'Ambos',
    fabricante: 'Mazak',
    descricao: 'Pré-seleciona a próxima ferramenta no carrossel (Mazak).',
    descricaoCompleta: 'M200 (Mazak Smooth) pré-seleciona e prepara a próxima ferramenta no magazine enquanto a máquina ainda está usinando com a atual. Reduz o tempo de troca.',
    sintaxe: 'T[n] M200',
    parametros: [{ letra: 'T', descricao: 'Número da ferramenta a preparar' }],
    exemplo: 'G01 X50. F300 (ainda na T01)\nT03 M200  (prepara T03 no magazine)\nG28 Z0\nT03 M06',
    explicacaoExemplo: 'Prepara T03 enquanto usina com T01 — troca mais rápida.', isG: false},

  
  {codigo: 'M38', nome: 'Abre Proteção (Okuma)', categoria: 'Automação', maquina: 'Ambos',
    fabricante: 'Okuma',
    descricao: 'Abre a proteção/guarda automática da máquina (Okuma OSP).',
    descricaoCompleta: 'M38 (Okuma OSP) abre a proteção/porta automática. Usado em integração com robôs e automação. Confirmar no manual pois numeração pode variar por modelo.',
    sintaxe: 'M38', parametros: [],
    exemplo: 'M05\nM09\nG28 Z0\nM38',
    explicacaoExemplo: 'Para spindle, fluido, retorna Z e abre proteção.', isG: false},

  {codigo: 'M39', nome: 'Fecha Proteção (Okuma)', categoria: 'Automação', maquina: 'Ambos',
    fabricante: 'Okuma',
    descricao: 'Fecha a proteção automática (Okuma OSP).',
    descricaoCompleta: 'M39 (Okuma OSP) fecha a proteção/guarda. Par do M38.',
    sintaxe: 'M39', parametros: [],
    exemplo: 'M38\n; (carregamento peça)\nM39\nS2000 M03',
    explicacaoExemplo: 'Abre, carrega peça, fecha e liga spindle.', isG: false},

  
  {codigo: 'M130', nome: 'Liga Limpeza de Mesa (DMG)', categoria: 'Automação', maquina: 'Centro de Usinagem',
    fabricante: 'DMG',
    descricao: 'Ativa o sistema de limpeza automática de mesa/cavacos (DMG Mori).',
    descricaoCompleta: 'M130 (DMG Mori) aciona o ciclo de limpeza automática da área de trabalho. Sopro de ar e/ou refrigerante para remover cavacos antes da próxima operação.',
    sintaxe: 'M130', parametros: [],
    exemplo: 'G00 Z100.\nM05\nM130\nG04 P5000',
    explicacaoExemplo: 'Retrai, para spindle e limpa mesa por 5s.', isG: false},

  
  {codigo: 'M251', nome: 'Seleciona Eixo B (Mitsubishi)', categoria: 'Eixo', maquina: 'Centro de Usinagem',
    fabricante: 'Mitsubishi',
    descricao: 'Ativa o eixo B (inclinação) para usinagem em 5 eixos (Mitsubishi M800).',
    descricaoCompleta: 'M251 (Mitsubishi M800/M80) ativa o eixo B para posicionamento angular em máquinas de 5 eixos. Permite usinagem em superfícies inclinadas sem reposicionar peça.',
    sintaxe: 'M251\nG01 B[ângulo] F[av]',
    parametros: [{ letra: 'B', descricao: 'Ângulo de inclinação em graus' }],
    exemplo: 'M251\nG01 B30. F500',
    explicacaoExemplo: 'Ativa eixo B e inclina 30° para 5 eixos.', isG: false},

  
  {codigo: 'M85', nome: 'Troca Rápida ATC (Brother)', categoria: 'Ferramenta', maquina: 'Centro de Usinagem',
    fabricante: 'Brother',
    descricao: 'Troca de ferramenta ultra-rápida com retorno de ponto — exclusivo Brother.',
    descricaoCompleta: 'M85 (Brother Speedio) realiza a troca de ferramenta de forma ultra-rápida (0.9s). Diferente do M06 padrão, o M85 não necessita retornar ao G28 primeiro — o ATC do Brother compensa automaticamente. Velocidade de troca incomparável.',
    sintaxe: 'T[n] M85',
    parametros: [{ letra: 'T', descricao: 'Número da ferramenta' }],
    exemplo: 'T02 M85  (troca em 0.9 segundos)\nS5000 M03',
    explicacaoExemplo: 'Troca ultra-rápida exclusiva Brother — 3× mais rápido que ATC convencional.', isG: false},

];

export const todosCodigos: CodigoItem[] = [
  ...codigosG, ...codigosGExtras, ...codigosGFabricantes,
  ...codigosM, ...codigosMExtras,
];
