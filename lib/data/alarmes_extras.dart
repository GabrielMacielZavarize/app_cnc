// alarmes_extras.dart — Alarmes CNC expandidos
// Fanuc PS / OT / SV / OH + Haas + Siemens extras
import '../models.dart';

// ─────────────────────────────────────────
// FANUC — ALARMES PS (Erro de Programa)
// ─────────────────────────────────────────
const alarmesFanucPS = [
  AlarmeItem(
    codigo: 'PS0000', titulo: 'Por favor, ligue o power novamente',
    descricao: 'Parâmetro alterado exige religar o CNC.',
    descricaoCompleta: 'Um parâmetro que requer reinicialização foi modificado. O CNC deve ser desligado e religado para o parâmetro ter efeito.',
    gravidade: 'MÉDIO', categoria: 'Parâmetro',
    causas: ['Parâmetro com flag NPA alterado', 'Dados de compensação modificados'],
    solucoes: ['Salvar backup dos parâmetros', 'Desligar e religar o CNC', 'Confirmar que o alarme não retorna'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0001', titulo: 'TH Alarm — Excesso de Caracteres',
    descricao: 'Número de caracteres na linha excedeu o limite.',
    descricaoCompleta: 'A linha do programa excedeu o número máximo de caracteres permitido pelo controle.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['Linha muito longa no programa', 'Múltiplos endereços na mesma linha', 'Comentários excessivos'],
    solucoes: ['Dividir a linha em múltiplas linhas', 'Reduzir comentários', 'Verificar se há espaços extras'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0002', titulo: 'TV Alarm — Erro de Bloco',
    descricao: 'Número de caracteres no bloco não é par.',
    descricaoCompleta: 'Controle em modo TV (verificação de paridade de bloco) detectou número ímpar de caracteres.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['Número ímpar de caracteres no bloco', 'Verificação TV habilitada (P0000#0=1)'],
    solucoes: ['Desabilitar verificação TV: P0000#0=0', 'Corrigir o bloco problemático'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0003', titulo: 'Too Many Digits',
    descricao: 'Número de dígitos excedeu o limite do endereço.',
    descricaoCompleta: 'Um valor numérico foi programado com mais dígitos do que o endereço permite.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['Valor além do range do endereço', 'Zeros adicionais acidentais', 'Unidade incorreta (mm vs pol.)'],
    solucoes: ['Verificar valor máximo do endereço', 'Corrigir o valor no programa', 'Verificar configuração mm/pol. (P0000#2)'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0010', titulo: 'Improper G-code',
    descricao: 'Código G não existe ou opção não instalada.',
    descricaoCompleta: 'O código G programado não é reconhecido pelo CNC nesta configuração.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['Código G não existe nesta série Fanuc', 'Opção de software não instalada', 'Erro de digitação no código G'],
    solucoes: ['Verificar código G no manual da versão', 'Verificar parâmetros de opção (P8001-P8133)', 'Corrigir digitação'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0011', titulo: 'Feed Rate Not Found',
    descricao: 'Nenhum avanço F programado para o movimento.',
    descricaoCompleta: 'Um bloco de corte (G01, G02, G03) foi encontrado sem avanço F válido.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['F não programado antes do G01', 'F=0 programado', 'Modo G93/G94/G95 incorreto'],
    solucoes: ['Adicionar F[valor] ao bloco', 'Verificar se F foi programado anteriormente no programa', 'Verificar modo de avanço G94/G95'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0015', titulo: 'Too Many Axes Commanded',
    descricao: 'Número de eixos no bloco excedeu o máximo.',
    descricaoCompleta: 'Foram programados mais eixos simultaneamente do que o CNC suporta.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['Programação de eixos além da configuração', 'Macro com eixos extras', 'Erro no pós-processador'],
    solucoes: ['Verificar configuração de eixos do CNC', 'Corrigir pós-processador', 'Dividir em blocos separados'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0020', titulo: 'Illegal Plane Selected',
    descricao: 'Eixo redundante ou conflito de planos G17/G18/G19.',
    descricaoCompleta: 'Plano selecionado inválido ou eixo que não pertence ao plano foi comandado.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['G02/G03 com eixo do plano errado', 'G17 ativo com movimento G18', 'Eixo não configurado usado no plano'],
    solucoes: ['Verificar plano ativo (G17=XY, G18=XZ, G19=YZ)', 'Selecionar plano correto', 'Conferir eixos programados no arco'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0022', titulo: 'No Circle Radius',
    descricao: 'Raio R ou parâmetros I,J,K zerados em G02/G03.',
    descricaoCompleta: 'Em interpolação circular, R=0 ou I=J=K=0 foram programados.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['R não programado', 'I,J,K todos zero', 'Ponto inicial = ponto final com R'],
    solucoes: ['Programar R com valor diferente de zero', 'Para círculo completo usar I ou J', 'Verificar coordenadas de início e fim do arco'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0029', titulo: 'Illegal Offset Value',
    descricao: 'Valor de offset fora do range permitido.',
    descricaoCompleta: 'Um valor de offset de ferramenta ou peça está fora dos limites permitidos pelo sistema.',
    gravidade: 'MÉDIO', categoria: 'Offset',
    causas: ['Offset de ferramenta com valor excessivo', 'Compensação de raio muito grande', 'Erro ao inserir offset'],
    solucoes: ['Verificar e corrigir valores de offset', 'Confirmar unidade mm/pol.', 'Verificar se offset correto foi selecionado'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0030', titulo: 'Illegal Offset Number',
    descricao: 'Número de offset H ou D não existe.',
    descricaoCompleta: 'O número de offset programado com H ou D não corresponde a nenhum registrado.',
    gravidade: 'MÉDIO', categoria: 'Offset',
    causas: ['H/D com número maior que o máximo', 'Programa de outra máquina com mais ferramentas', 'Offset não cadastrado'],
    solucoes: ['Verificar H/D no programa', 'Cadastrar offset correspondente', 'Verificar P6800 (máx. offsets)'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0041', titulo: 'Cutter Comp — Cannot Determine Start Block',
    descricao: 'Compensação de raio não consegue determinar bloco inicial.',
    descricaoCompleta: 'Na ativação de G41/G42, o CNC não consegue calcular a posição inicial do contorno.',
    gravidade: 'MÉDIO', categoria: 'Compensação',
    causas: ['G41/G42 sem movimento no bloco', 'Raio de compensação maior que o raio do canto', 'Contorno com segmentos muito curtos'],
    solucoes: ['Garantir movimento XY no bloco de ativação', 'Reduzir raio de compensação', 'Usar G41/G42 com G00 antes do contorno'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0050', titulo: 'Overdraft In Fixed Cycle',
    descricao: 'Erro de over-draft no ciclo fixo de furação.',
    descricaoCompleta: 'No ciclo fixo, o eixo Z foi além do ponto final programado.',
    gravidade: 'MÉDIO', categoria: 'Ciclo Fixo',
    causas: ['Profundidade Q maior que Z total', 'Parâmetro de ciclo incorreto', 'G83 com Q=0'],
    solucoes: ['Verificar relação Q vs Z total', 'Q deve ser menor que a profundidade total', 'Corrigir parâmetros do ciclo'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0059', titulo: 'Address Not Found',
    descricao: 'Variável de macro não inicializada ou endereço faltando.',
    descricaoCompleta: 'Uma variável macro (#) foi usada antes de ser atribuída ou endereço obrigatório não encontrado.',
    gravidade: 'MÉDIO', categoria: 'Macro',
    causas: ['Variável #[n] com valor nulo (#0)', 'G65/G66 sem parâmetros obrigatórios', 'Endereço A, B, C não programado em macro'],
    solucoes: ['Verificar valor da variável antes do uso', 'Usar IF [#n NE #0] para testar', 'Passar todos parâmetros obrigatórios'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0060', titulo: 'Sequence Number Not Found',
    descricao: 'N[número] de bloco referenciado não existe no programa.',
    descricaoCompleta: 'Um GOTO N[x] ou M99 P[x] referenciam um número de sequência que não existe.',
    gravidade: 'MÉDIO', categoria: 'Macro',
    causas: ['N referenciado deletado', 'GOTO com número errado', 'M99 P com número de subprograma inexistente'],
    solucoes: ['Verificar destino do GOTO', 'Confirmar existência do N', 'Verificar número do subprograma'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0070', titulo: 'No Program Space in Memory',
    descricao: 'Memória de programas insuficiente.',
    descricaoCompleta: 'Não há espaço suficiente na memória para armazenar o programa.',
    gravidade: 'MÉDIO', categoria: 'Memória',
    causas: ['Memória cheia com programas antigos', 'Programa muito grande', 'Memória de opção não instalada'],
    solucoes: ['Deletar programas desnecessários', 'Comprimir programa (remover comentários)', 'Verificar capacidade de memória (P6033)'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0071', titulo: 'Data Not Found',
    descricao: 'Programa chamado por M98 não existe na memória.',
    descricaoCompleta: 'Subprograma chamado com M98 P[número] não foi encontrado na memória do CNC.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['Subprograma não carregado', 'Número errado no M98 P', 'Programa apagado acidentalmente'],
    solucoes: ['Carregar subprograma na memória', 'Verificar número do subprograma', 'Verificar diretório de programas'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0076', titulo: 'Sub Program Nesting Too Deep',
    descricao: 'Subprogramas aninhados além do limite (4 níveis).',
    descricaoCompleta: 'A chamada de subprogramas M98 foi aninhada além de 4 níveis.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['Mais de 4 M98 aninhados', 'Subprograma chamando a si mesmo', 'Estrutura de macro muito profunda'],
    solucoes: ['Reduzir níveis de aninhamento', 'Consolidar subprogramas', 'Verificar recursão acidental'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0085', titulo: 'Communication Error',
    descricao: 'Erro de comunicação RS-232 ou DNC.',
    descricaoCompleta: 'Falha na comunicação serial entre CNC e dispositivo externo.',
    gravidade: 'MÉDIO', categoria: 'Comunicação',
    causas: ['Baud rate incompatível', 'Cabo RS-232 com defeito', 'Paridade ou stop bits errados', 'Software DNC mal configurado'],
    solucoes: ['Conferir P101=9600, P102=7bits, P103=paridade par', 'Verificar cabo e conectores', 'Reconfigurar software DNC', 'Testar com terminal serial'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0090', titulo: 'Zero Return Incomplete',
    descricao: 'Zero return não foi executado após power-on.',
    descricaoCompleta: 'O CNC exige zero return após ligar mas ele não foi executado.',
    gravidade: 'MÉDIO', categoria: 'Referência',
    causas: ['CNC religado sem zero return', 'Encoder absoluto sem bateria', 'Parâmetro P1005#0 habilitado'],
    solucoes: ['Executar zero return na sequência Z → X → Y', 'Verificar bateria do encoder (≥3V)', 'Sequência: HANDLE/JOG → +Z → +X → +Y'],
    atencao: 'Execute sempre Z primeiro para evitar colisão com mesa.'),

  AlarmeItem(
    codigo: 'PS0100', titulo: 'Parameter Write Enable',
    descricao: 'Parâmetros foram alterados com P8900#0=1 (PWE ativo).',
    descricaoCompleta: 'O modo de escrita de parâmetros foi habilitado. Qualquer alteração de parâmetro gera este alarme.',
    gravidade: 'MÉDIO', categoria: 'Parâmetro',
    causas: ['P8900#0=1 (PWE) ativado para editar parâmetros', 'Manutenção em andamento'],
    solucoes: ['Desabilitar PWE: P8900#0=0', 'Confirmar parâmetros alterados', 'Religar o CNC se necessário'],
    atencao: 'Desabilite PWE imediatamente após editar parâmetros.'),

  AlarmeItem(
    codigo: 'PS0111', titulo: 'Macro Variable — Divide by Zero',
    descricao: 'Divisão por zero em expressão de macro.',
    descricaoCompleta: 'Uma expressão aritmética em macro tentou dividir por zero.',
    gravidade: 'MÉDIO', categoria: 'Macro',
    causas: ['#[resultado] = #A / #B onde #B=0', 'Variável não inicializada usada como divisor', 'Lógica de macro incorreta'],
    solucoes: ['Adicionar proteção: IF [#B EQ 0] GOTO [erro]', 'Verificar lógica da macro', 'Inicializar variáveis antes do uso'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0119', titulo: 'Macro Variable — Overflow',
    descricao: 'Overflow em cálculo de variável macro.',
    descricaoCompleta: 'Resultado de uma operação aritmética excedeu o limite da variável macro (±99999999.99999).',
    gravidade: 'MÉDIO', categoria: 'Macro',
    causas: ['Cálculo com resultado muito grande', 'Loop infinito acumulando valor', 'Uso de SQRT de número negativo'],
    solucoes: ['Revisar lógica do cálculo', 'Verificar SQRT e LOG com valores positivos', 'Adicionar limites nas variáveis'],
    atencao: null),

  AlarmeItem(
    codigo: 'PS0128', titulo: 'Macro — Illegal Argument',
    descricao: 'Argumento inválido em função de macro.',
    descricaoCompleta: 'Uma função matemática de macro recebeu argumento fora do domínio válido.',
    gravidade: 'MÉDIO', categoria: 'Macro',
    causas: ['ASIN/ACOS com argumento fora de [-1,1]', 'SQRT de número negativo', 'LOG de número ≤0'],
    solucoes: ['Verificar domínio das funções matemáticas', 'Adicionar verificação IF antes da função', 'Depurar variáveis com SETVN'],
    atencao: null),
];

// ─────────────────────────────────────────
// FANUC — ALARMES OT (Over Travel)
// ─────────────────────────────────────────
const alarmesFanucOT = [
  AlarmeItem(
    codigo: 'OT0500', titulo: 'Over Travel — Limite Positivo (+)',
    descricao: 'Eixo atingiu limite de curso positivo por software.',
    descricaoCompleta: 'O eixo ultrapassou o limite de curso positivo definido em P1320. Movimento bloqueado.',
    gravidade: 'ALTO', categoria: 'Limite de Curso',
    causas: ['Zero-peça G54 mal definido', 'Coordenada programada além do curso', 'P1320 incorreto'],
    solucoes: ['Mover o eixo no sentido negativo com JOG/MPG', 'Corrigir zero-peça G54-G59', 'Verificar/ajustar P1320'],
    atencao: 'NUNCA forçar mecanicamente. Mover sempre na direção contrária ao limite.'),

  AlarmeItem(
    codigo: 'OT0501', titulo: 'Over Travel — Limite Negativo (-)',
    descricao: 'Eixo atingiu limite de curso negativo por software.',
    descricaoCompleta: 'O eixo ultrapassou o limite de curso negativo definido em P1321.',
    gravidade: 'ALTO', categoria: 'Limite de Curso',
    causas: ['Zero-peça G54 com offset excessivo negativo', 'G43 com valor positivo muito grande', 'Programação de Z muito profunda'],
    solucoes: ['Mover o eixo no sentido positivo com JOG/MPG', 'Corrigir offset da ferramenta H', 'Revisar coordenada Z'],
    atencao: 'Verificar H (offset de comprimento) antes de religar.'),

  AlarmeItem(
    codigo: 'OT0502', titulo: 'Stroke Limit 2 — Positivo',
    descricao: 'Segundo limite de curso positivo atingido.',
    descricaoCompleta: 'Eixo ultrapassou o segundo limite de curso positivo (P1322).',
    gravidade: 'ALTO', categoria: 'Limite de Curso',
    causas: ['Área de proteção configurada com P1322', 'Peça de grande porte', 'Fixture em área restrita'],
    solucoes: ['Mover o eixo na direção contrária', 'Revisar P1322/P1323', 'Verificar configuração de áreas proibidas (G22)'],
    atencao: null),

  AlarmeItem(
    codigo: 'OT0503', titulo: 'Stroke Limit 2 — Negativo',
    descricao: 'Segundo limite de curso negativo atingido.',
    descricaoCompleta: 'Eixo ultrapassou o segundo limite de curso negativo (P1323).',
    gravidade: 'ALTO', categoria: 'Limite de Curso',
    causas: ['Área de proteção configurada', 'Movimento de G28 atravessando área proibida', 'Parâmetro P1323 incorreto'],
    solucoes: ['Mover na direção contrária', 'Revisar rota de G28', 'Ajustar P1322/P1323'],
    atencao: null),

  AlarmeItem(
    codigo: 'OT0506', titulo: 'Hardware Over Travel — Limite Hardware Positivo',
    descricao: 'Eixo atingiu chave de fim de curso FÍSICA positiva.',
    descricaoCompleta: 'O eixo tocou a chave de hardware de limite positivo. Sinal de hardware OT+ ativado.',
    gravidade: 'CRÍTICO', categoria: 'Limite de Curso',
    causas: ['Falha de software OT não detectada', 'P1320 incorreto ou desabilitado', 'Colisão ou escorregamento'],
    solucoes: ['Mover com cautela no JOG na direção segura', 'Verificar chave de limite (I/O)', 'Revisar P1320', 'Inspeção mecânica do eixo'],
    atencao: 'Este alarme indica problema grave. Inspecionar guias e parafuso antes de religar.'),

  AlarmeItem(
    codigo: 'OT0507', titulo: 'Hardware Over Travel — Limite Hardware Negativo',
    descricao: 'Eixo atingiu chave de fim de curso FÍSICA negativa.',
    descricaoCompleta: 'O eixo tocou a chave de hardware de limite negativo.',
    gravidade: 'CRÍTICO', categoria: 'Limite de Curso',
    causas: ['Falha no software OT', 'P1321 incorreto', 'Zero return não executado após manutenção'],
    solucoes: ['Mover eixo no sentido positivo em JOG lento', 'Verificar chave de HW OT', 'Inspecionar parafuso de fuso e guias'],
    atencao: 'Inspecionar mecanicamente antes de continuar.'),
];

// ─────────────────────────────────────────
// FANUC — ALARMES SV (Servo)
// ─────────────────────────────────────────
const alarmesFanucSV = [
  AlarmeItem(
    codigo: 'SV0300', titulo: 'Servo Alarm — Need Zero Return (APC)',
    descricao: 'Encoder absoluto perdeu referência — zero return obrigatório.',
    descricaoCompleta: 'O encoder absoluto (APC) perdeu a referência de posição. É necessário executar zero return.',
    gravidade: 'MÉDIO', categoria: 'Referência',
    causas: ['Bateria da memória absoluta descarregada', 'Power off por mais de 72 horas sem bateria', 'Encoder substituído'],
    solucoes: ['Executar ZERO RETURN: Z→X→Y→B/C', 'Verificar tensão da bateria CR17335 (deve ser ≥3V)', 'Substituir bateria se necessário'],
    atencao: 'Substituir bateria com máquina LIGADA. Desligar com bateria fraca apaga referência absoluta.'),

  AlarmeItem(
    codigo: 'SV0301', titulo: 'Servo Alarm — APC — Need Zero Return (Battery)',
    descricao: 'Bateria do encoder absoluto com tensão muito baixa.',
    descricaoCompleta: 'Tensão da bateria abaixo do nível crítico. Trocar bateria imediatamente.',
    gravidade: 'ALTO', categoria: 'Manutenção',
    causas: ['Bateria CR17335 descarregada (vida útil: 2-3 anos)'],
    solucoes: ['Substituir bateria CR17335 3V com máquina LIGADA', 'Verificar data da última troca', 'Implementar preventivo anual'],
    atencao: 'TROCAR COM MÁQUINA LIGADA. Trocar desligada apaga posição absoluta e requer zero return.'),

  AlarmeItem(
    codigo: 'SV0360', titulo: 'Servo Alarm — FSSB Error',
    descricao: 'Erro na comunicação FSSB (Fanuc Serial Servo Bus).',
    descricaoCompleta: 'Falha na comunicação fibra óptica entre o NCU e os amplificadores servo.',
    gravidade: 'CRÍTICO', categoria: 'Comunicação',
    causas: ['Cabo de fibra óptica com dobra ou avaria', 'Conector de fibra sujo ou mal encaixado', 'Amplificador servo com falha', 'Ordem de conexão FSSB incorreta'],
    solucoes: ['Inspecionar cabos de fibra óptica (não dobrar < 30mm de raio)', 'Limpar conectores ópticos com algodão seco', 'Verificar ordem de conexão FSSB no P1023', 'Substituir amplificador se falha confirmada'],
    atencao: 'Nunca tocar na face dos conectores ópticos. Contamina o sinal.'),

  AlarmeItem(
    codigo: 'SV0380', titulo: 'Servo Alarm — Axis Card Alarm',
    descricao: 'Alarme na placa do eixo servo.',
    descricaoCompleta: 'A placa de controle do eixo servo reportou alarme interno.',
    gravidade: 'CRÍTICO', categoria: 'Hardware',
    causas: ['Placa de eixo com defeito eletrônico', 'Superaquecimento da placa', 'Interferência eletromagnética', 'Conexão interna frouxa'],
    solucoes: ['Verificar temperatura do gabinete', 'Inspecionar conexões internas', 'Verificar leds da placa do eixo', 'Substituir placa se confirmado'],
    atencao: 'Requer técnico especializado Fanuc.'),

  AlarmeItem(
    codigo: 'SV0401', titulo: 'Servo Alarm — VRDY Off',
    descricao: 'Sinal VRDY do amplificador servo não presente.',
    descricaoCompleta: 'O amplificador servo não enviou o sinal de pronto (VRDY) ao CNC.',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['Alarme ativo no amplificador (verificar LED)', 'Emergência bloqueando enable', 'Alimentação 200-240V ausente', 'Cabo FSSB com defeito'],
    solucoes: ['Verificar LEDs do amplificador (A-F = falha específica)', 'Liberar e resetar emergência', 'Medir tensão de alimentação 200V (±10%)', 'Inspecionar cabo fibra óptica FSSB'],
    atencao: 'Não resetar repetidamente sem diagnosticar causa raiz.'),

  AlarmeItem(
    codigo: 'SV0410', titulo: 'Servo Alarm — Eixo Parado (SVNE Off)',
    descricao: 'Eixo servo parado — sinal SVNE não presente.',
    descricaoCompleta: 'O sinal de habilitação do servo (SVNE) foi desativado inesperadamente.',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['Emergência ativada durante operação', 'Reset externo acionado', 'Falha no relé de segurança'],
    solucoes: ['Verificar circuito de emergência', 'Liberar emergência e resetar', 'Testar relés de segurança'],
    atencao: null),

  AlarmeItem(
    codigo: 'SV0413', titulo: 'Servo Alarm — Speed Error Overflow',
    descricao: 'Diferença entre velocidade real e comandada muito alta.',
    descricaoCompleta: 'A diferença entre a velocidade real e a velocidade comandada excedeu o limite (P1825/P1826).',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['Colisão ou obstáculo mecânico', 'Ganho P1825/P1826 incorreto', 'Motor servo com defeito', 'Sobrecarga excessiva'],
    solucoes: ['Verificar obstrução mecânica', 'Conferir e ajustar P1825/P1826', 'Verificar tensão DC do barramento (270-340V)', 'Inspecionar motor e encoder'],
    atencao: 'NÃO mover o eixo com alarme ativo. Inspecionar mecanicamente primeiro.'),

  AlarmeItem(
    codigo: 'SV0414', titulo: 'Servo Alarm — Position Error Overflow',
    descricao: 'Erro de posição excedeu o limite P1828.',
    descricaoCompleta: 'A diferença entre posição comandada e posição real ultrapassou P1828.',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['P1828 com valor muito restritivo', 'Avanço muito alto para a máquina', 'Encoder com falha intermitente', 'Correia dentada com folga ou quebrada'],
    solucoes: ['Verificar P1828 (valor típico: 20000-50000 pulsos)', 'Reduzir avanço F e retry', 'Executar diagnóstico DGN 300 (erro real)', 'Executar ZERO RETURN após solucionar'],
    atencao: 'Execute ZERO RETURN após resolver.'),

  AlarmeItem(
    codigo: 'SV0416', titulo: 'Servo Alarm — Disconnected Pulse Encoder',
    descricao: 'Encoder do motor desconectado.',
    descricaoCompleta: 'Sinal do encoder do motor servo não está chegando ao amplificador.',
    gravidade: 'CRÍTICO', categoria: 'Encoder',
    causas: ['Cabo do encoder com mau contato ou partido', 'Conector do encoder mal encaixado', 'Encoder do motor com defeito', 'Tensão de alimentação do encoder ausente'],
    solucoes: ['Verificar cabo encoder do motor (inspecionar visualmente)', 'Reconectar todos os conectores do encoder', 'Medir tensão de alimentação (+5V)', 'Substituir encoder se confirmado'],
    atencao: null),

  AlarmeItem(
    codigo: 'SV0430', titulo: 'Servo Alarm — Servo Motor Overheat',
    descricao: 'Motor servo com temperatura acima do limite.',
    descricaoCompleta: 'O termistor do motor servo detectou temperatura acima do limite (normalmente 120°C).',
    gravidade: 'CRÍTICO', categoria: 'Temperatura',
    causas: ['Ciclo de trabalho excessivo', 'Ventilação do motor obstruída', 'Carga mecânica excessiva', 'Temperatura ambiente elevada (>35°C)'],
    solucoes: ['Aguardar resfriamento (mín. 20 min)', 'Verificar ventilação e limpeza do motor', 'Reduzir ciclo de trabalho', 'Verificar lubrificação das guias'],
    atencao: 'NÃO forçar religar. Risco de dano permanente ao motor.'),

  AlarmeItem(
    codigo: 'SV0431', titulo: 'Servo Alarm — Amplifier Overheat',
    descricao: 'Amplificador servo com temperatura acima do limite.',
    descricaoCompleta: 'O amplificador servo atingiu temperatura máxima.',
    gravidade: 'CRÍTICO', categoria: 'Temperatura',
    causas: ['Filtro do gabinete entupido', 'Ventilador do amplificador parado', 'Temperatura ambiente alta', 'Ciclo de trabalho excessivo'],
    solucoes: ['Verificar e limpar filtros do gabinete', 'Verificar funcionamento do ventilador do amplificador', 'Verificar temperatura do ambiente (máx. 40°C)', 'Aguardar resfriamento antes de religar'],
    atencao: 'Limpar filtros mensalmente. Amplificadores danificados por calor não têm conserto.'),

  AlarmeItem(
    codigo: 'SV0436', titulo: 'Servo Alarm — Softthermala (Rated Current)',
    descricao: 'Corrente nominal do servo ultrapassada — proteção térmica por software.',
    descricaoCompleta: 'O modelo térmico do software detectou que o motor está operando acima da corrente nominal.',
    gravidade: 'ALTO', categoria: 'Servo',
    causas: ['Carga mecânica acima do nominal', 'Lubrificação insuficiente das guias', 'Correia ou acoplamento com problema', 'Perfil de aceleração agressivo'],
    solucoes: ['Verificar lubrificação das guias lineares', 'Reduzir aceleração/desaceleração', 'Verificar carga nos eixos', 'Inspecionar parafuso de fuso'],
    atencao: null),

  AlarmeItem(
    codigo: 'SV0460', titulo: 'Servo Alarm — FSSB — Initialization Failure',
    descricao: 'Falha na inicialização do barramento FSSB.',
    descricaoCompleta: 'O barramento de comunicação servo FSSB não inicializou corretamente.',
    gravidade: 'CRÍTICO', categoria: 'Comunicação',
    causas: ['Amplificador não responde ao FSSB', 'Ordem incorreta no P1023', 'Amplificador com firmware incompatível', 'Cabo óptico com falha'],
    solucoes: ['Verificar P1023 (sequência dos eixos)', 'Inspecionar fibra óptica FSSB', 'Verificar versão de firmware dos amplificadores', 'Ligar com NCU e amplificadores ao mesmo tempo'],
    atencao: 'Requer técnico Fanuc para diagnóstico completo.'),
];

// ─────────────────────────────────────────
// FANUC — ALARMES OH (Overheat)
// ─────────────────────────────────────────
const alarmesFanucOH = [
  AlarmeItem(
    codigo: 'OH0700', titulo: 'Overheat — Control Unit',
    descricao: 'Superaquecimento na unidade de controle (NCU) — temperatura >55°C.',
    descricaoCompleta: 'A temperatura interna do gabinete de controle ultrapassou 55°C. CNC desligado automaticamente para proteção.',
    gravidade: 'CRÍTICO', categoria: 'Temperatura',
    causas: ['Filtro de ar do gabinete entupido', 'Ventilador interno parado ou degradado', 'Temperatura ambiente >35°C', 'Ar condicionado do painel com defeito', 'Porta do gabinete aberta por longo tempo'],
    solucoes: ['Desligar imediatamente e aguardar resfriamento (30 min)', 'Limpar filtros de ar mensalmente', 'Verificar todos os ventiladores do gabinete', 'Confirmar temperatura interna <40°C', 'Instalar ou reparar ar condicionado do painel'],
    atencao: 'NÃO religar enquanto temperatura interna não baixar. Custo do NCU pode ultrapassar R\$ 30.000.'),

  AlarmeItem(
    codigo: 'OH0701', titulo: 'Overheat — Servo Amplifier',
    descricao: 'Superaquecimento em amplificador servo.',
    descricaoCompleta: 'O amplificador servo atingiu temperatura crítica.',
    gravidade: 'CRÍTICO', categoria: 'Temperatura',
    causas: ['Filtros do gabinete entupidos', 'Ventilador do amplificador parado', 'Ciclo de trabalho excessivo', 'Temperatura ambiente acima do nominal'],
    solucoes: ['Limpar filtros do gabinete', 'Verificar ventilador do amplificador', 'Reduzir duty cycle', 'Verificar temperatura do ambiente (máx 40°C)'],
    atencao: 'Amplificadores danificados por calor geralmente precisam de troca.'),

  AlarmeItem(
    codigo: 'OH0702', titulo: 'Overheat — Spindle Motor',
    descricao: 'Motor do spindle com temperatura acima do limite.',
    descricaoCompleta: 'O termistor do motor do spindle detectou temperatura acima do máximo.',
    gravidade: 'CRÍTICO', categoria: 'Temperatura',
    causas: ['Cortes muito pesados por longo período', 'Refrigeração interna do motor falha', 'Temperatura ambiente elevada', 'Motor com rolamento em degradação'],
    solucoes: ['Aguardar resfriamento (mín. 30 min)', 'Reduzir profundidade de corte e avanço', 'Verificar sistema de refrigeração do motor', 'Inspecionar rolamentos do spindle'],
    atencao: 'Não religar sem resolver a causa. Risco de dano permanente ao enrolamento.'),

  AlarmeItem(
    codigo: 'OH0703', titulo: 'Overheat — Spindle Amplifier',
    descricao: 'Amplificador do spindle com temperatura acima do limite.',
    descricaoCompleta: 'O amplificador do spindle (SPM) atingiu temperatura máxima.',
    gravidade: 'CRÍTICO', categoria: 'Temperatura',
    causas: ['Filtro do gabinete entupido', 'Ventilador do SPM parado', 'Corrente excessiva por sobrecarga'],
    solucoes: ['Limpar filtros e verificar ventiladores', 'Aguardar resfriamento total', 'Verificar corrente do spindle no diagnóstico', 'Reduzir carga de corte'],
    atencao: null),

  AlarmeItem(
    codigo: 'OH0704', titulo: 'Fan Failure — Control Unit',
    descricao: 'Ventilador da unidade de controle com falha.',
    descricaoCompleta: 'O ventilador interno do NCU parou ou está com velocidade reduzida.',
    gravidade: 'ALTO', categoria: 'Temperatura',
    causas: ['Ventilador com rolamento desgastado', 'Obstrução no ventilador', 'Conector do ventilador solto', 'Ventilador queimado'],
    solucoes: ['Verificar e limpar ventilador', 'Reconectar cabo do ventilador', 'Substituir ventilador (peça de baixo custo)', 'Monitorar temperatura interna'],
    atencao: 'Substituir ventilador preventivamente a cada 3-5 anos. Peça barata, consequência cara.'),
];

// ─────────────────────────────────────────
// FANUC — ALARMES PS EXTRAS (Programa/Setup)
// ─────────────────────────────────────────
const alarmesFanucPSExtra = [
  AlarmeItem(
    codigo: 'PS0010', titulo: 'Código G Indevido — G Improper',
    descricao: 'Código G não permitido na situação atual do CNC.',
    descricaoCompleta: 'Um código G foi programado em contexto não permitido (ex: G91 em modo incremental já ativo, G96 em centro de usinagem, G40 quando compensação não está ativa).',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['Código G usado fora de contexto', 'G96/G97 em máquina que não suporta', 'G40 sem G41/G42 prévio'],
    solucoes: ['Verificar linha de alarme no programa', 'Confirmar modo modal atual (G90/G91, G40/G41/G42)', 'Remover ou substituir o código G problemático'],
    atencao: null),
  AlarmeItem(
    codigo: 'PS0015', titulo: 'Endereço Não Permitido',
    descricao: 'Letra de endereço não permitida no bloco atual.',
    descricaoCompleta: 'Um endereço (letra) foi programado em contexto não permitido — por exemplo, endereço S em G94 sem spindle, ou endereço Q negativo em G83.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['Endereço incompatível com o código G do bloco', 'Valor fora do range (ex: Q negativo)', 'Letra duplicada no mesmo bloco'],
    solucoes: ['Verificar o bloco indicado pelo alarme', 'Consultar tabela de endereços permitidos', 'Remover endereço incompatível'],
    atencao: null),
  AlarmeItem(
    codigo: 'PS0035', titulo: 'Raio de Arco Inconsistente',
    descricao: 'G02/G03: o raio R não fecha o arco corretamente.',
    descricaoCompleta: 'Em G02 ou G03 com endereço R, a distância entre ponto inicial e final é maior que o diâmetro (2×R). Impossível formar o arco.',
    gravidade: 'MÉDIO', categoria: 'Geometria',
    causas: ['Erro de cálculo no raio R programado', 'Pontos inicial e final muito afastados para o R dado', 'Confusão entre R positivo (arco < 180°) e R negativo (> 180°)'],
    solucoes: ['Recalcular o raio R correto (deve ser ≥ metade da corda)', 'Usar I/J/K para definir o centro do arco diretamente', 'Verificar se o arco é > 180° — usar R negativo'],
    atencao: null),
  AlarmeItem(
    codigo: 'PS0070', titulo: 'Buffer Overflow — Programa Muito Grande',
    descricao: 'Programa excede a memória disponível no CNC.',
    descricaoCompleta: 'O programa NC a ser armazenado excede a capacidade de memória do CNC Fanuc. Típico em programas de usinagem de moldes com milhões de blocos.',
    gravidade: 'MÉDIO', categoria: 'Memória',
    causas: ['Programa muito longo para a memória instalada', 'Memória cheia com outros programas', 'Programa gerado com tolerância muito fina (muitos pontos)'],
    solucoes: ['Usar DNC (Direct Numeric Control) para executar sem armazenar', 'Dividir programa em subprogramas menores', 'Deletar programas desnecessários da memória', 'Aumentar memória se opção disponível'],
    atencao: null),
  AlarmeItem(
    codigo: 'PS0101', titulo: 'Erro de Retorno de Subprograma',
    descricao: 'M99 sem M98 correspondente — erro de retorno de subprograma.',
    descricaoCompleta: 'O CNC encontrou M99 (retorno de subprograma) sem ter sido chamado por M98. Ou a chamada e o retorno estão desbalanceados.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['M99 no programa principal sem M98 prévio', 'Número de M98 e M99 desbalanceado', 'Subprograma com M99 chamado como programa principal'],
    solucoes: ['Verificar estrutura de chamadas M98/M99', 'Confirmar que programa principal termina com M30, não M99', 'Adicionar M30 no final do programa principal'],
    atencao: null),
];

// ─────────────────────────────────────────
// HAAS — ALARMES EXTRAS
// ─────────────────────────────────────────
const alarmesHaasExtras = [
  AlarmeItem(
    codigo: '103', titulo: 'SERVO ERROR — Y Axis Fault',
    descricao: 'Falha no servo do eixo Y.',
    descricaoCompleta: 'O servo do eixo Y reportou falha. Proteção térmica ou erro de seguimento.',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['Sobrecarga no eixo Y', 'Guia Y sem lubrificação', 'Encoder Y com falha', 'Cabo servo Y com defeito'],
    solucoes: ['Aguardar resfriamento (10 min)', 'Verificar lubrificação das guias', 'Executar ZERO RETURN após resolver', 'Verificar cabo e conector do encoder Y'],
    atencao: 'Não forçar movimento com alarme ativo.'),

  AlarmeItem(
    codigo: '104', titulo: 'SERVO ERROR — Z Axis Fault',
    descricao: 'Falha no servo do eixo Z.',
    descricaoCompleta: 'Servo do eixo Z com falha. Especialmente perigoso: eixo Z com ferramenta pesada pode cair.',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['Sobrecarga em Z (fresamento profundo)', 'Guia Z sem lubrificação', 'Encoder Z com problema', 'Contrapeso do eixo Z com defeito'],
    solucoes: ['Aguardar resfriamento', 'NÃO mover Z sem confirmar que não vai cair', 'Verificar contrapeso/freio de Z', 'Executar ZERO RETURN'],
    atencao: 'CUIDADO com queda do eixo Z. Verificar freio de Z antes de movimentar.'),

  AlarmeItem(
    codigo: '105', titulo: 'SERVO ERROR — A/B Axis Fault',
    descricao: 'Falha no servo do 4º/5º eixo.',
    descricaoCompleta: 'Servo do eixo rotativo A ou B com falha.',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['Carga excessiva na mesa rotativa', 'Encoder do eixo rotativo com problema', 'Choque ou sobrecarga durante posicionamento'],
    solucoes: ['Verificar carga na mesa rotativa', 'Executar ZERO RETURN do eixo rotativo', 'Verificar encoder do eixo rotativo', 'Reduzir override de posicionamento'],
    atencao: null),

  AlarmeItem(
    codigo: '161', titulo: 'SERVO DRIVE FAULT — X Drive',
    descricao: 'Drive do servo X reportou falha interna.',
    descricaoCompleta: 'O drive servo do eixo X detectou falha interna (sobrecorrente, sobretensão ou falha de IGBTs).',
    gravidade: 'CRÍTICO', categoria: 'Drive',
    causas: ['Sobrecorrente no drive X', 'Curto no motor ou cabo', 'IGBT do drive com defeito', 'Ventilador do drive parado'],
    solucoes: ['Verificar isolamento do cabo do motor X', 'Medir resistência do motor (fases equilibradas)', 'Verificar temperatura do drive', 'Substituir drive se confirmado'],
    atencao: 'Requer técnico HAAS autorizado para troca de drive.'),

  AlarmeItem(
    codigo: '162', titulo: 'SERVO DRIVE FAULT — Y Drive',
    descricao: 'Drive do servo Y reportou falha interna.',
    descricaoCompleta: 'O drive servo do eixo Y detectou falha (sobrecorrente, sobretensão ou falha de IGBTs).',
    gravidade: 'CRÍTICO', categoria: 'Drive',
    causas: ['Sobrecorrente no drive Y', 'Motor Y com falha de isolamento', 'IGBT com defeito'],
    solucoes: ['Verificar motor Y (medir isolamento)', 'Verificar ventilação do drive', 'Substituir drive se confirmado'],
    atencao: null),

  AlarmeItem(
    codigo: '163', titulo: 'SERVO DRIVE FAULT — Z Drive',
    descricao: 'Drive do servo Z reportou falha interna.',
    descricaoCompleta: 'O drive servo do eixo Z detectou falha.',
    gravidade: 'CRÍTICO', categoria: 'Drive',
    causas: ['Motor Z com falha', 'Sobretensão no drive Z', 'IGBT com defeito'],
    solucoes: ['Verificar motor Z e seus cabos', 'Verificar tensão de alimentação', 'Chamar técnico HAAS'],
    atencao: 'Verificar freio de Z antes de movimentar o eixo.'),

  AlarmeItem(
    codigo: '164', titulo: 'SERVO DRIVE FAULT — Spindle Drive',
    descricao: 'Drive do spindle reportou falha.',
    descricaoCompleta: 'O inversor/drive do spindle detectou falha interna.',
    gravidade: 'CRÍTICO', categoria: 'Drive',
    causas: ['Sobrecorrente no spindle', 'IGBTs do inversor com defeito', 'Motor spindle com falha de isolamento', 'Rolamento do spindle travado'],
    solucoes: ['Verificar motor spindle (medir isolamento)', 'Verificar rolamentos do spindle', 'Verificar código de falha no display do drive', 'Chamar técnico HAAS'],
    atencao: 'Drive do spindle é componente caro. Diagnosticar causa antes da troca.'),

  AlarmeItem(
    codigo: '292', titulo: 'SPINDLE ORIENTATION FAULT',
    descricao: 'Spindle não conseguiu orientar (troca de ferramenta).',
    descricaoCompleta: 'O spindle não completou a orientação necessária para troca de ferramenta.',
    gravidade: 'CRÍTICO', categoria: 'Spindle',
    causas: ['Encoder de orientação com problema', 'Freio do spindle com defeito', 'Parâmetro de orientação incorreto', 'Interferência mecânica'],
    solucoes: ['Verificar encoder do spindle', 'Verificar freio de orientação', 'Revisar parâmetro de orientação DWELL (P261)', 'Inspecionar correias do spindle'],
    atencao: 'NUNCA abrir a porta do ATC manualmente com spindle em movimento.'),

  AlarmeItem(
    codigo: '993', titulo: 'MEMORY FAULT — Machine Data Lost',
    descricao: 'Dados da máquina perdidos — memória com falha.',
    descricaoCompleta: 'Memória CMOS/SRAM perdeu dados. Pode ser necessário recarregar parâmetros.',
    gravidade: 'CRÍTICO', categoria: 'Sistema',
    causas: ['Bateria CMOS descarregada', 'Queda de energia durante escrita', 'SRAM com falha'],
    solucoes: ['Fazer BACKUP antes de qualquer ação', 'Substituir bateria CMOS', 'Recarregar parâmetros do backup', 'Contatar HAAS para restauração de dados'],
    atencao: 'BACKUP OBRIGATÓRIO. Perda de parâmetros pode inutilizar a máquina.'),

  AlarmeItem(
    codigo: '115', titulo: 'SPINDLE LOAD — Tool Break Detection',
    descricao: 'Detecção de quebra de ferramenta por carga do spindle.',
    descricaoCompleta: 'A carga do spindle caiu abruptamente indicando possível quebra de ferramenta.',
    gravidade: 'ALTO', categoria: 'Ferramenta',
    causas: ['Ferramenta quebrada', 'Parâmetro de threshold muito sensível', 'Variação normal de material'],
    solucoes: ['Verificar ferramenta visualmente', 'Ajustar threshold de detecção', 'Verificar parâmetro P165'],
    atencao: 'Verificar ferramenta antes de continuar.'),

  AlarmeItem(
    codigo: '133', titulo: 'LOW COOLANT — Nível de Fluido Baixo',
    descricao: 'Nível de fluido de corte abaixo do mínimo.',
    descricaoCompleta: 'O sensor de nível do tanque de refrigerante detectou nível abaixo do mínimo.',
    gravidade: 'MÉDIO', categoria: 'Refrigeração',
    causas: ['Consumo normal sem reposição', 'Vazamento no sistema', 'Sensor de nível com defeito'],
    solucoes: ['Completar fluido de corte até o nível máximo', 'Verificar vazamentos', 'Mistura correta: 5-8% concentrado', 'Verificar sensor de nível se fluido estiver OK'],
    atencao: null),

  AlarmeItem(
    codigo: '199', titulo: 'ATC FAULT — Carousel Position Error',
    descricao: 'Erro de posicionamento do carrossel de ferramentas.',
    descricaoCompleta: 'O carrossel do ATC não está na posição correta ou sensor não confirma posição.',
    gravidade: 'CRÍTICO', categoria: 'Trocador',
    causas: ['Ferramenta presa', 'Sensor de posição do carrossel com defeito', 'Pressão de ar insuficiente', 'Motor do carrossel com problema'],
    solucoes: ['DESLIGAR antes de qualquer intervenção manual', 'Verificar pressão de ar (mín. 85 PSI)', 'Inspecionar ferramenta presa no carrossel', 'ATC INIT no menu diagnóstico'],
    atencao: 'NUNCA girar carrossel manualmente com máquina ligada.'),
];

// ─────────────────────────────────────────
// SIEMENS — ALARMES EXTRAS
// ─────────────────────────────────────────
const alarmesSiemensExtras = [
  AlarmeItem(
    codigo: '1000', titulo: 'Canal 1 — Emergência Ativa',
    descricao: 'Parada de emergência ativada no canal 1.',
    descricaoCompleta: 'O canal 1 do SINUMERIK está em estado de emergência. Todos os acionamentos estão inibidos.',
    gravidade: 'ALTO', categoria: 'Segurança',
    causas: ['Botão de emergência pressionado', 'Categoria 0/1 de parada ativada', 'Falha no módulo de segurança Safety Integrated'],
    solucoes: ['Liberar botão de emergência', 'Verificar histórico de alarmes (ALM)', 'Confirmar estado dos módulos Safety', 'Pressionar RESET no painel'],
    atencao: null),

  AlarmeItem(
    codigo: '2000', titulo: 'Eixo — Erro de Seguimento Excessivo',
    descricao: 'Erro de contorno (schleppfehler) ultrapassou o limite.',
    descricaoCompleta: 'A diferença entre posição comandada e real superou MD36400 (contour monitoring).',
    gravidade: 'ALTO', categoria: 'Servo',
    causas: ['Override muito alto', 'MD36400 restritivo', 'Guias sem lubrificação', 'Ganho KV desajustado'],
    solucoes: ['Reduzir override para 50%', 'Ajustar MD36400 (tipicamente 0.5-2mm)', 'Lubrificar guias lineares', 'Verificar KV com NC/PLC diagnóstico'],
    atencao: null),

  AlarmeItem(
    codigo: '10621', titulo: 'Canal — Ferramenta T0 Não Permitida',
    descricao: 'T0 programado — ferramenta zero não permitida.',
    descricaoCompleta: 'T0 foi programado mas não é permitido nesta configuração de gerenciamento de ferramentas.',
    gravidade: 'MÉDIO', categoria: 'Ferramenta',
    causas: ['T0 programado sem corretor D', 'Gerenciamento de ferramentas ativo rejeitando T0', 'Erro de programação'],
    solucoes: ['Verificar se T0 é intencional', 'Programar T[n] D[n] correto', 'Verificar configuração do tool management'],
    atencao: null),

  AlarmeItem(
    codigo: '14009', titulo: 'Ferramenta — Vida Útil Esgotada',
    descricao: 'Vida da ferramenta atingiu 100% — alerta de troca.',
    descricaoCompleta: 'O gerenciamento de ferramentas SINUMERIK detectou que a vida útil programada foi atingida.',
    gravidade: 'MÉDIO', categoria: 'Ferramenta',
    causas: ['Tempo de corte ou número de peças atingiu o limite', 'Parâmetro de vida útil configurado'],
    solucoes: ['Trocar o inserto/ferramenta', 'Resetar contador de vida útil no tool management', 'Verificar estado real da ferramenta antes de resetar'],
    atencao: null),

  AlarmeItem(
    codigo: '17010', titulo: 'Canal — Limite de Curso de Software',
    descricao: 'Eixo vai ultrapassar limite de software.',
    descricaoCompleta: 'O bloco programado levaria o eixo além do limite de curso de software.',
    gravidade: 'ALTO', categoria: 'Limite de Curso',
    causas: ['Zero-peça mal configurado', 'Programa de outra máquina com dimensões diferentes', 'MD36100/36110 (limites de software) incorretos'],
    solucoes: ['Verificar zero-peça (G54-G59)', 'Verificar MD36100 (SW limit +) e MD36110 (SW limit -)', 'Mover eixo na direção segura e corrigir programa'],
    atencao: null),

  AlarmeItem(
    codigo: '20004', titulo: 'Eixo — Falha de Referência',
    descricao: 'Referência não executada após power-on.',
    descricaoCompleta: 'O eixo requer referência mas ela não foi executada.',
    gravidade: 'MÉDIO', categoria: 'Referência',
    causas: ['CNC religado sem executar referência', 'Encoder incremental sem referência', 'Falha durante referência anterior'],
    solucoes: ['Executar REFERÊNCIA pelo painel (Ref Point ou Home)', 'Para encoder incremental: mover no sentido de REFP', 'Verificar cam de referência se falhou'],
    atencao: null),

  AlarmeItem(
    codigo: '21611', titulo: 'Drive — Subtensão no Barramento DC',
    descricao: 'Tensão DC abaixo do mínimo no S120/SIMODRIVE.',
    descricaoCompleta: 'Tensão do barramento DC ficou abaixo do nível mínimo para operação segura.',
    gravidade: 'CRÍTICO', categoria: 'Drive',
    causas: ['Tensão de rede abaixo de 380V', 'Fusíveis de rede queimados', 'Módulo retificador com defeito', 'Falha no contator de rede'],
    solucoes: ['Medir tensão trifásica de entrada (380-400V ±10%)', 'Verificar fusíveis do painel principal', 'Verificar contator de rede e relé de pré-carga', 'Medir DC no barramento (deve ser ~540V para 380V AC)'],
    atencao: 'Aguardar 5 min antes de tocar. DC 600V é fatal.'),

  AlarmeItem(
    codigo: '21700', titulo: 'Motor — Temperatura Elevada',
    descricao: 'Temperatura do motor servo acima do limite por KTY/PTC.',
    descricaoCompleta: 'O sensor de temperatura (KTY84 ou PTC) do motor servo reportou temperatura acima do limite.',
    gravidade: 'ALTO', categoria: 'Temperatura',
    causas: ['Ciclo de trabalho excessivo', 'Refrigeração do motor insuficiente', 'Carga mecânica elevada', 'MD1607 (limite de temp.) muito baixo'],
    solucoes: ['Aguardar resfriamento', 'Verificar refrigeração do motor', 'Reduzir duty cycle', 'Verificar MD1607 (limite normal: 120-145°C)'],
    atencao: null),

  AlarmeItem(
    codigo: '22010', titulo: 'Drive — Falha de Comunicação DRIVE-CLiQ',
    descricao: 'Erro na comunicação DRIVE-CLiQ entre componentes S120.',
    descricaoCompleta: 'Falha na comunicação DRIVE-CLiQ (comunicação serial entre Control Unit e componentes S120).',
    gravidade: 'CRÍTICO', categoria: 'Comunicação',
    causas: ['Cabo DRIVE-CLiQ com defeito', 'Conector solto ou oxidado', 'Motor Module ou encoder com falha', 'Topologia DRIVE-CLiQ incorreta'],
    solucoes: ['Inspecionar cabos e conectores DRIVE-CLiQ', 'Verificar topologia no STARTER/Startdrive', 'Reconectar todos os conectores', 'Substituir cabo ou componente se confirmado'],
    atencao: null),

  AlarmeItem(
    codigo: '25001', titulo: 'Encoder — Sinal Sujo ou Interrompido',
    descricao: 'Sinal do encoder com qualidade insuficiente.',
    descricaoCompleta: 'O sinal sin/cos do encoder está com amplitude baixa ou forma de onda distorcida.',
    gravidade: 'ALTO', categoria: 'Encoder',
    causas: ['Régua linear ou encoder rotativo sujo', 'Cabeça leitora danificada', 'Cabo de sinal com interferência', 'Folga excessiva na régua linear'],
    solucoes: ['Limpar régua com álcool isopropílico', 'Verificar folga da cabeça leitora (mín. 0.5mm)', 'Verificar blindagem do cabo do encoder', 'Substituir se sinal não melhorar'],
    atencao: null),

  AlarmeItem(
    codigo: '26001', titulo: 'Monitoramento de Velocidade — Excedido',
    descricao: 'Velocidade do eixo ultrapassou o limite Safety.',
    descricaoCompleta: 'A função Safety Integrated detectou que a velocidade ultrapassou o SLS (Safely Limited Speed).',
    gravidade: 'CRÍTICO', categoria: 'Segurança',
    causas: ['Porta aberta com override alto', 'Parâmetro SLS mal configurado', 'Falha no Safety Integrated'],
    solucoes: ['Fechar portas e reiniciar Safety', 'Verificar parâmetros SLS no STARTER', 'Diagnóstico Safety no NCK'],
    atencao: 'Safety Integrated é função de segurança. Requer técnico certificado para ajuste.'),

  AlarmeItem(
    codigo: '380800', titulo: 'CLP — Timeout de Ciclo',
    descricao: 'CLP SINUMERIK ultrapassou tempo de ciclo máximo.',
    descricaoCompleta: 'O ciclo do PLC excedeu o tempo máximo configurado. Pode indicar loop infinito ou sobrecarga.',
    gravidade: 'CRÍTICO', categoria: 'CLP',
    causas: ['Bloco de programa CLP com loop', 'Muitas funções de comunicação no ciclo', 'Sobrecarga do processador'],
    solucoes: ['Verificar programa CLP por loops', 'Reduzir comunicação OPI/DDE no ciclo', 'Aumentar tempo de watchdog (MD10080)'],
    atencao: 'Requer técnico de CLP SINUMERIK.'),
];

// ─────────────────────────────────────────
// ALARMES HAAS — BANCO 2
// ─────────────────────────────────────────
const alarmesHaasBank2 = [
  AlarmeItem(codigo: '102', titulo: 'SERVO ERROR — Y Axis Overload',
    descricao: 'Sobrecarga no servo do eixo Y.',
    descricaoCompleta: 'Corrente do servo Y excedeu o limite de proteção.',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['Avanço excessivo em Y', 'Colisão lateral', 'Guia Y sem lubrificação', 'Falha no drive Y'],
    solucoes: ['Aguardar resfriamento 10min', 'Verificar guias e lubrificação', 'Checar drive no painel elétrico'],
    atencao: 'Inspecionar guias de Y visualmente antes de religar.'),
  AlarmeItem(codigo: '103', titulo: 'SERVO ERROR — Z Axis Overload',
    descricao: 'Sobrecarga no servo do eixo Z.',
    descricaoCompleta: 'Sobrecarga no eixo vertical Z. Frequente após colisão por G43 com H errado.',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['G43 com H errado', 'Ferramenta mais curta que o programado', 'Colisão Z', 'Ballscrew travado'],
    solucoes: ['Verificar todos os offsets H', 'Inspecionar fuso de esferas Z', 'Reduzir avanços'],
    atencao: 'Verificar folga no fuso Z após colisão.'),
  AlarmeItem(codigo: '115', titulo: 'SPINDLE ENCODER FAULT',
    descricao: 'Falha no encoder do spindle.',
    descricaoCompleta: 'Sinal do encoder do spindle perdido ou com erro. Controle não confirma velocidade/posição.',
    gravidade: 'CRÍTICO', categoria: 'Spindle',
    causas: ['Cabo do encoder danificado', 'Encoder sujo', 'Interferência EMI'],
    solucoes: ['Inspecionar cabo do encoder', 'Limpar encoder com ar comprimido', 'Verificar aterramento'],
    atencao: 'Nao rosquear com encoder com falha.'),
  AlarmeItem(codigo: '120', titulo: 'SPINDLE DRIVE FAULT',
    descricao: 'Falha no drive do spindle.',
    descricaoCompleta: 'Inversor do spindle reportou falha interna — temperatura, sobretensao ou IGBT.',
    gravidade: 'CRÍTICO', categoria: 'Spindle',
    causas: ['Superaquecimento do drive', 'Sobretensao na rede', 'IGBT com defeito'],
    solucoes: ['Verificar ventilacao do painel', 'Medir tensao de entrada', 'Chamar tecnico'],
    atencao: 'Documentar hora e condicoes para o tecnico.'),
  AlarmeItem(codigo: '131', titulo: 'HIGH COOLANT PRESSURE',
    descricao: 'Pressao de refrigeracao acima do limite.',
    descricaoCompleta: 'Sistema de refrigeracao com pressao elevada. Possivel obstrucao.',
    gravidade: 'MÉDIO', categoria: 'Refrigeracao',
    causas: ['Filtro entupido', 'Bico obstruido', 'Cavaco bloqueando saida'],
    solucoes: ['Limpar filtro', 'Verificar bicos', 'Verificar nivel e qualidade do fluido'],
    atencao: null),
  AlarmeItem(codigo: '306', titulo: 'PROBE FAULT — Probe Signal Error',
    descricao: 'Falha no apalpador.',
    descricaoCompleta: 'Apalpador nao respondeu ao sinal de skip ou disparou em posicao inesperada.',
    gravidade: 'ALTO', categoria: 'Apalpador',
    causas: ['Bateria fraca', 'Receptor mal posicionado', 'Cavaco no apalpador', 'Interferencia de luz'],
    solucoes: ['Trocar bateria', 'Limpar apalpador e receptor', 'Reposicionar receptor IR'],
    atencao: 'Verificar G54 apos resolucao — offset pode ter sido zerado errado.'),
  AlarmeItem(codigo: '994', titulo: 'MACHINE NEEDS SERVICE',
    descricao: 'Manutencao preventiva programada.',
    descricaoCompleta: 'Contador de horas atingiu o intervalo de manutencao configurado.',
    gravidade: 'BAIXO', categoria: 'Manutencao',
    causas: ['Intervalo de manutencao atingido'],
    solucoes: ['Executar PM conforme manual', 'Resetar contador apos manutencao'],
    atencao: null),
  AlarmeItem(codigo: '124', titulo: 'SERVO — AMPLIFIER OVERHEAT',
    descricao: 'Amplificador servo com superaquecimento.',
    descricaoCompleta: 'O amplificador servo reportou temperatura interna acima do limite. Proteção térmica ativada.',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['Temperatura do armário elétrico elevada', 'Filtro de ar do armário entupido', 'Ciclo de trabalho excessivo'],
    solucoes: ['Abrir porta do armário (cuidado com tensão!)', 'Verificar temperatura do ambiente', 'Limpar filtro de ar do armário', 'Reduzir ciclo de trabalho'],
    atencao: 'Aguardar 30min antes de religar. Verificar ventilação do armário.'),
  AlarmeItem(codigo: '200', titulo: 'TOOL NUMBER EXCEEDS MAXIMUM',
    descricao: 'Número de ferramenta fora do range do magazine.',
    descricaoCompleta: 'O programa chamou número de ferramenta maior que a capacidade do carrossel instalado.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['Número T maior que posições do carrossel', 'Erro de digitação no programa', 'Ferramenta programada sem ser carregada'],
    solucoes: ['Verificar quantidade de posições do carrossel', 'Corrigir número T no programa', 'Verificar tabela de ferramentas'],
    atencao: null),
  AlarmeItem(codigo: '267', titulo: 'LUBE FAULT — Way Lube Low',
    descricao: 'Nível de lubrificante das guias baixo.',
    descricaoCompleta: 'Nível de óleo do sistema de lubrificação das guias abaixo do mínimo.',
    gravidade: 'ALTO', categoria: 'Lubrificação',
    causas: ['Reservatório de lubrificante vazio', 'Bomba de lubrificação com defeito', 'Vazamento na linha de lubrificação'],
    solucoes: ['Verificar nível no reservatório de lube', 'Completar com óleo ISO VG 68 (ou conforme manual)', 'Verificar bomba e linhas de lubrificação'],
    atencao: 'Operar sem lubrificação danifica as guias permanentemente.'),
  AlarmeItem(codigo: '351', titulo: 'RIGID TAP: SPINDLE NOT AT SPEED',
    descricao: 'Rosqueamento rígido: spindle não atingiu velocidade.',
    descricaoCompleta: 'Durante G84 rígido (G84 com M29 ou padrão Haas), o spindle não atingiu a velocidade programada.',
    gravidade: 'ALTO', categoria: 'Rosqueamento',
    causas: ['Spindle sobrecarregado', 'Override de spindle abaixo de 100%', 'Velocidade programada acima do máximo'],
    solucoes: ['Garantir override do spindle em 100%', 'Reduzir velocidade de rosqueamento', 'Verificar se macho está livre'],
    atencao: 'Rosqueamento com spindle fora de velocidade destrói o macho e a rosca.'),
  AlarmeItem(codigo: '414', titulo: 'X-AXIS DRIVE FAULT',
    descricao: 'Falha no drive do eixo X.',
    descricaoCompleta: 'O drive servo do eixo X reportou falha interna (IGBT, temperatura, sobrecorrente).',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['Falha interna no amplificador', 'Temperatura do drive excessiva', 'Sobrecorrente — possível colisão'],
    solucoes: ['Verificar LEDs de diagnóstico no drive X', 'Verificar temperatura do armário', 'Documentar condições e chamar técnico HAAS'],
    atencao: 'Não religar repetidamente sem diagnóstico — pode agravar o dano.'),
];

// ─────────────────────────────────────────
// ALARMES SIEMENS — BANCO 2
// ─────────────────────────────────────────
const alarmesSiemensBank2 = [
  AlarmeItem(codigo: '25201', titulo: 'Drive: DC Bus Undervoltage',
    descricao: 'Subvoltagem no barramento DC do drive.',
    descricaoCompleta: 'Tensao do barramento DC do drive SINAMICS caiu abaixo do minimo.',
    gravidade: 'CRÍTICO', categoria: 'Eletrica',
    causas: ['Queda de tensao da rede', 'Fusivel queimado', 'Retificador com defeito'],
    solucoes: ['Verificar tensao de alimentacao 380V', 'Verificar fusíveis no armario', 'Chamar tecnico SIEMENS'],
    atencao: 'Nao religar sem inspecao previa.'),
  AlarmeItem(codigo: '26010', titulo: 'Drive: Motor Temperature Exceeded',
    descricao: 'Temperatura do motor servo excedida.',
    descricaoCompleta: 'Sensor KTY/PTC do motor reportou temperatura acima do limite no parametro p0626.',
    gravidade: 'ALTO', categoria: 'Servo',
    causas: ['Ciclo de trabalho excessivo', 'Motor subdimensionado', 'Ventilacao bloqueada'],
    solucoes: ['Aguardar resfriamento', 'Verificar fluxo de ar no motor', 'Reduzir ciclo de trabalho'],
    atencao: null),
  AlarmeItem(codigo: '8080', titulo: 'NC: Block Not Decodable',
    descricao: 'Bloco do programa NC invalido.',
    descricaoCompleta: 'O parser NCK encontrou bloco com sintaxe invalida.',
    gravidade: 'MÉDIO', categoria: 'Programacao',
    causas: ['Erro de sintaxe no programa', 'Codigo G nao suportado', 'Parametro fora de faixa'],
    solucoes: ['Verificar o bloco indicado no alarme', 'Consultar manual 828D/840D', 'Testar em Single Block'],
    atencao: null),
  AlarmeItem(codigo: '10652', titulo: 'Contour Monitoring — Tolerance Exceeded',
    descricao: 'Monitoramento de contorno: tolerancia excedida.',
    descricaoCompleta: 'Eixo desviou do contorno programado alem da tolerancia de monitoramento.',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['Forca de corte excessiva', 'Ferramenta gasta', 'Fuso com folga', 'Ganho de servo insuficiente'],
    solucoes: ['Trocar ferramenta', 'Verificar fixacao da peca', 'Verificar backlash no fuso'],
    atencao: 'Pecas produzidas durante este alarme podem estar fora de tolerancia.'),
  AlarmeItem(codigo: '21611', titulo: 'Spindle: Speed Difference Too Large',
    descricao: 'Diferenca de velocidade do spindle muito grande.',
    descricaoCompleta: 'Velocidade real do spindle divergiu > 5% da programada por mais de 3 segundos.',
    gravidade: 'ALTO', categoria: 'Spindle',
    causas: ['Sobrecarga no corte', 'Correia escorregando', 'Encoder do spindle com falha'],
    solucoes: ['Reduzir profundidade de corte', 'Verificar tensao da correia', 'Verificar encoder'],
    atencao: 'Em rosqueamento este alarme causa rosca incorreta.'),
  AlarmeItem(codigo: '10750', titulo: 'Axis: Software Limit Exceeded',
    descricao: 'Limite de software de eixo excedido.',
    descricaoCompleta: 'Eixo atingiu o limite de software. O NCK bloqueou o movimento antes do limite de hardware.',
    gravidade: 'ALTO', categoria: 'Limite de Curso',
    causas: ['Zero-peca (workoffset) configurado incorretamente', 'Programa com coordenada fora do curso', 'Peca muito grande para a area de trabalho'],
    solucoes: ['Mover eixo na direcao oposta no modo JOG', 'Verificar e corrigir workoffset (G54-G59)', 'Revisar programa — verificar coord. max.'],
    atencao: 'Mover na direcao negativa para liberar o eixo.'),
  AlarmeItem(codigo: '380500', titulo: 'PLC: Coolant Level Low',
    descricao: 'Nivel de fluido de corte abaixo do minimo.',
    descricaoCompleta: 'Sensor do tanque de refrigerante detectou nivel abaixo do limite minimo configurado no PLC.',
    gravidade: 'MÉDIO', categoria: 'Refrigeracao',
    causas: ['Evaporacao do fluido', 'Vazamento no sistema', 'Filtro obstruido desviando fluxo'],
    solucoes: ['Completar tanque com fluido adequado', 'Verificar concentracao (Brix: 6-10%)', 'Verificar vazamentos nas mangueiras'],
    atencao: 'Trabalhar sem fluido suficiente supera a temperatura da ferramenta e da peca.'),
  AlarmeItem(codigo: '25000', titulo: 'NCK: Zero Return Not Completed',
    descricao: 'Retorno ao zero (homing) nao completado ao ligar.',
    descricaoCompleta: 'O NCK exige que todos os eixos sejam referenciados (homing) antes de iniciar qualquer ciclo automatico.',
    gravidade: 'ALTO', categoria: 'Referencia',
    causas: ['Maquina ligada sem executar referencia', 'Eixo nao atingiu o sensor de referencia', 'Encoder absoluto sem bateria'],
    solucoes: ['Executar REF POINT (Reference Point Approach) no menu JOG', 'Verificar sensor de referencia de cada eixo', 'Verificar bateria do encoder absoluto'],
    atencao: 'Nunca ignorar referencia — offsetsde posicao podem estar incorretos.'),
  AlarmeItem(codigo: '14010', titulo: 'NCK: Program Not Found',
    descricao: 'Programa NC nao encontrado no controle.',
    descricaoCompleta: 'O numero de programa chamado por M98 ou subrotina nao existe na memoria do NCK.',
    gravidade: 'MÉDIO', categoria: 'Programacao',
    causas: ['Subprograma nao carregado no controle', 'Nome/numero do programa incorreto no chamado', 'Programa apagado da memoria'],
    solucoes: ['Verificar se subprograma foi carregado (Program Manager)', 'Conferir nome exato do subprograma', 'Recarregar via DNC ou USB'],
    atencao: null),
];

// ─────────────────────────────────────────
// ALARMES OKUMA — BANCO 2 (OSP EX/MC codes)
// ─────────────────────────────────────────
const alarmesOkumaBank2 = [
  AlarmeItem(codigo: 'EX0027', titulo: 'OVERLOAD — Feed Axis Motor',
    descricao: 'Sobrecarga no motor de avanco.',
    descricaoCompleta: 'Motor de avanco atingiu a corrente limite. OSP desligou o eixo por protecao.',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['Colisao', 'Avanco excessivo', 'Lubrificacao insuficiente', 'Problema no acionamento'],
    solucoes: ['Verificar possivel colisao', 'Lubrificar guias (TURCITE)', 'Reduzir avanco', 'Reinicializar OSP'],
    atencao: 'OKUMA OSP — aguardar 5 minutos antes de religar apos sobrecarga.'),
  AlarmeItem(codigo: 'EX0033', titulo: 'SPINDLE SPEED NOT REACHED',
    descricao: 'Rotacao do spindle nao atingida.',
    descricaoCompleta: 'Spindle nao atingiu velocidade programada dentro do tempo de estabilizacao.',
    gravidade: 'MÉDIO', categoria: 'Spindle',
    causas: ['Spindle sobrecarregado', 'Correia desgastada', 'Parametro de tempo curto'],
    solucoes: ['Reduzir carga', 'Verificar correia', 'Ajustar parametro de tempo'],
    atencao: null),
  AlarmeItem(codigo: 'EX1210', titulo: 'SERVO ALARM — Encoder Error',
    descricao: 'Erro no encoder do eixo.',
    descricaoCompleta: 'Encoder linear ou rotativo reportou erro de sinal. OSP perde referencia de posicao.',
    gravidade: 'CRÍTICO', categoria: 'Servo',
    causas: ['Encoder danificado por cavaco/oleo', 'Cabo com falha', 'Temperatura excessiva'],
    solucoes: ['Verificar e limpar encoder', 'Checar cabo em todo o percurso', 'Solicitar tecnico OKUMA'],
    atencao: 'Fazer nova referencia (HOME) apos resolver — posicao perdida.'),
  AlarmeItem(codigo: 'EX0060', titulo: 'CHUCK NOT CLAMPED',
    descricao: 'Placa/mandril nao fechada.',
    descricaoCompleta: 'Sensor de confirmacao de fechamento da placa nao detectou fixacao.',
    gravidade: 'ALTO', categoria: 'Fixacao',
    causas: ['Pressao hidraulica baixa', 'Peca nao colocada', 'Sensor com falha', 'Valvula hidraulica com defeito'],
    solucoes: ['Verificar pressao hidraulica', 'Confirmar peca fixada manualmente', 'Testar sensor'],
    atencao: 'Nunca bypassar sensor de confirmacao de placa — risco grave de acidente.'),
  AlarmeItem(codigo: 'MC0001', titulo: 'EMERGENCY STOP',
    descricao: 'Parada de emergencia ativada.',
    descricaoCompleta: 'Um ou mais botoes E-STOP foram pressionados ou circuito de seguranca aberto.',
    gravidade: 'CRÍTICO', categoria: 'Seguranca',
    causas: ['E-STOP pressionado', 'Porta de seguranca aberta', 'Falha no circuito de seguranca'],
    solucoes: ['Verificar todos os E-STOPs', 'Fechar portas', 'Girar e destrancar E-STOP', 'Pressionar RESET'],
    atencao: null),
  AlarmeItem(codigo: 'EX0040', titulo: 'ATC ALARM — Tool Change Incomplete',
    descricao: 'Troca automatica de ferramenta nao completada.',
    descricaoCompleta: 'O ciclo de troca automatica de ferramenta do Okuma foi interrompido antes de completar.',
    gravidade: 'CRÍTICO', categoria: 'Trocador',
    causas: ['Ferramenta presa no cone do spindle', 'Pressao de ar abaixo de 0.5 MPa', 'Sensor de posicao do ATC com defeito', 'Falha na valvula pneumatica do ATC'],
    solucoes: ['DESLIGAR a maquina antes de qualquer intervencao', 'Verificar pressao de ar (min. 0.5 MPa)', 'Executar ATC RESET no menu de manutencao', 'Verificar cone do spindle — limpar com pano e ar'],
    atencao: 'Nunca colocar maos na area do ATC com maquina energizada.'),
  AlarmeItem(codigo: 'EX0100', titulo: 'SOFT LIMIT OVER — Positive',
    descricao: 'Limite de software positivo excedido.',
    descricaoCompleta: 'Eixo tentou ultrapassar o limite positivo de software configurado no OSP.',
    gravidade: 'ALTO', categoria: 'Limite de Curso',
    causas: ['Work Zero configurado incorretamente', 'Programa com coordenada alem do curso', 'Override manual em JOG alem do limite'],
    solucoes: ['Mover eixo na direcao negativa com MPG', 'Corrigir Work Zero no OSP', 'Revisar programa — verificar coord. maximas'],
    atencao: 'Mover sempre na direcao oposta (negativa) para liberar.'),
  AlarmeItem(codigo: 'EX0101', titulo: 'SOFT LIMIT OVER — Negative',
    descricao: 'Limite de software negativo excedido.',
    descricaoCompleta: 'Eixo tentou ultrapassar o limite negativo de software no OSP.',
    gravidade: 'ALTO', categoria: 'Limite de Curso',
    causas: ['Work Zero negativo demais', 'Programa com Z muito negativo', 'Comprimento de ferramenta nao compensado'],
    solucoes: ['Mover eixo na direcao positiva com MPG', 'Verificar compensacao de ferramenta (G43)', 'Revisar Work Zero'],
    atencao: null),
  AlarmeItem(codigo: 'EX0210', titulo: 'HYDRAULIC PRESSURE LOW',
    descricao: 'Pressao hidraulica abaixo do minimo Okuma.',
    descricaoCompleta: 'A pressao do sistema hidraulico caiu abaixo do valor minimo. Placa e fixacoes podem soltar.',
    gravidade: 'CRÍTICO', categoria: 'Hidraulica',
    causas: ['Motor da bomba hidraulica desligado', 'Nivel de oleo hidraulico baixo', 'Filtro hidraulico entupido', 'Valvula de alivio com vazamento'],
    solucoes: ['Verificar se bomba hidraulica esta ligada', 'Checar nivel de oleo no visor (regua)', 'Trocar filtro hidraulico (500h)', 'Ajustar pressao: 4.5-5.5 MPa (manometro)'],
    atencao: 'Nunca operar com pressao insuficiente — placa pode soltar a peca durante o corte.'),
  AlarmeItem(codigo: 'PP0050', titulo: 'PROGRAM SYNTAX ERROR',
    descricao: 'Erro de sintaxe no programa OSP.',
    descricaoCompleta: 'O controle OSP encontrou bloco com sintaxe invalida. Verificar linha indicada no alarme.',
    gravidade: 'MÉDIO', categoria: 'Programacao',
    causas: ['Codigo G ou M invalido para o OSP', 'Parametro fora da faixa', 'Falta de ponto decimal em coordenada', 'Conflito entre codigos modais'],
    solucoes: ['Verificar o bloco indicado pelo numero de linha', 'Consultar manual OSP-P300/P200', 'Verificar se o codigo e compativel com a versao do OSP'],
    atencao: null),
];

// ─────────────────────────────────────────
// GETTERS COMBINADOS
// ─────────────────────────────────────────

/// FANUC: base + todos os bancos extras (PS, OT, SV, OH + PS Extra)
List<AlarmeItem> get alarmesFanucCompleto => [
  ...alarmesFanuc,
  ...alarmesFanucPS,
  ...alarmesFanucPSExtra,
  ...alarmesFanucOT,
  ...alarmesFanucSV,
  ...alarmesFanucOH,
];

/// HAAS: base + extras + banco 2
List<AlarmeItem> get alarmesHaasCompleto => [
  ...alarmesHaas,
  ...alarmesHaasExtras,
  ...alarmesHaasBank2,
];

/// SIEMENS: base + extras + banco 2
List<AlarmeItem> get alarmesSiemensCompleto => [
  ...alarmesSiemens,
  ...alarmesSiemensExtras,
  ...alarmesSiemensBank2,
];

/// OKUMA: base (models.dart) + banco 2 (OSP EX/MC codes)
List<AlarmeItem> get alarmesOkumaCompleto => [
  ...alarmesOkuma,
  ...alarmesOkumaBank2,
];

// ─────────────────────────────────────────
// BANCO 3 — FANUC: Alarmes de Sistema (SW)
// ─────────────────────────────────────────
const alarmesFanucSW = [
  AlarmeItem(codigo: 'SW0001', titulo: 'EMERGENCY STOP SIGNAL ON',
    descricao: 'Sinal de parada de emergencia ativo.',
    descricaoCompleta: 'O botão de emergência ou sinal de E-Stop externo está ativo. Máquina bloqueada completamente.',
    gravidade: 'CRÍTICO', categoria: 'Segurança',
    causas: ['Botão de E-Stop pressionado', 'Porta do gabinete aberta', 'Sinal de E-Stop externo (CLP/PLC)', 'Cabo do E-Stop interrompido'],
    solucoes: ['Girar botão de E-Stop para destravar', 'Verificar portas e proteções da máquina', 'Checar sinal do CLP no ladder diagram', 'Verificar continuidade dos cabos de segurança'],
    atencao: 'Identificar a causa antes de destravar — E-Stop pode ter sido acionado por motivo de segurança real.'),
  AlarmeItem(codigo: 'SW0003', titulo: 'BATTERY ALARM (CNC)',
    descricao: 'Bateria do CNC com tensão baixa.',
    descricaoCompleta: 'A bateria de manutenção de memória do CNC está com carga baixa. Parâmetros e programas podem ser perdidos ao desligar.',
    gravidade: 'MÉDIO', categoria: 'Manutenção',
    causas: ['Bateria de lítio vencida (vida útil ~3 anos)', 'Bateria não recarregando', 'CNC ficou longos períodos desligado'],
    solucoes: ['Substituir bateria 3V lítio (A02B-0309-K102 Fanuc)', 'Fazer backup de parâmetros antes da troca', 'Trocar com CNC ligado para não perder memória SRAM'],
    atencao: 'Fazer backup completo de parâmetros (SRAM) antes de trocar a bateria. Após troca, restaurar o backup completo.'),
  AlarmeItem(codigo: 'SW0102', titulo: 'PARAMETER WRITE ENABLED',
    descricao: 'Escrita de parametros habilitada acidentalmente.',
    descricaoCompleta: 'O modo de escrita de parâmetros está ativo (Parameter 8000#0=1). Pode causar escrita acidental de parâmetros críticos.',
    gravidade: 'BAIXO', categoria: 'Configuração',
    causas: ['Operador habilitou escrita e esqueceu de desabilitar', 'Macro ativa escrita via G10', 'Após edição de parâmetros'],
    solucoes: ['Desabilitar: Setting > parâmetro 8000#0 = 0', 'Verificar se macro ou programa alterou parâmetros críticos'],
    atencao: null),
  AlarmeItem(codigo: 'SW0507', titulo: 'OVER TRAVEL: SOFT LIMIT +X',
    descricao: 'Eixo X excedeu limite de software positivo.',
    descricaoCompleta: 'O eixo X tentou mover além do limite de curso configurado no parâmetro 1320/1321. Movimento bloqueado.',
    gravidade: 'ALTO', categoria: 'Limite de Curso',
    causas: ['Programa com G0/G1 para coordenada além do curso', 'Offset G54-G59 incorreto', 'Limite de software mal configurado'],
    solucoes: ['Mover eixo na direção negativa (−X) em JOG/MPG para sair do limite', 'Verificar offset de trabalho ativo (G54 etc)', 'Revisar parâmetro 1320 (limite +) e 1321 (limite −)'],
    atencao: 'Só mover na direção oposta ao limite atingido. Verificar offset antes de reiniciar programa.'),
  AlarmeItem(codigo: 'SW5016', titulo: 'ILLEGAL USE OF G-CODE',
    descricao: 'Codigo G incompativel ou ilegal na situação atual.',
    descricaoCompleta: 'Um código G foi programado em condição em que não é permitido — por exemplo, G41 dentro de G91 sem distância, ou código G do grupo errado no bloco.',
    gravidade: 'MÉDIO', categoria: 'Programação',
    causas: ['G41/G42 sem D ou com D=0', 'Códigos G incompatíveis no mesmo bloco', 'G91 + ciclo enlatado sem coordenadas válidas'],
    solucoes: ['Verificar a linha indicada no alarme', 'Garantir que G41/G42 têm D válido e movimento linear', 'Separar códigos G incompatíveis em blocos diferentes'],
    atencao: null),
];

// ─────────────────────────────────────────
// BANCO 3 — HAAS: Alarmes de Eixo e Sistema
// ─────────────────────────────────────────
const alarmesHaasBank3 = [
  AlarmeItem(codigo: '125', titulo: 'SERVO OVERLOAD — AXIS X',
    descricao: 'Sobrecarga no servo do eixo X.',
    descricaoCompleta: 'O motor servo do eixo X está sobrecarregado. Possível obstrução mecânica ou excesso de carga no corte.',
    gravidade: 'ALTO', categoria: 'Servo',
    causas: ['Avanço muito alto para o material usinado', 'Obstrução mecânica no eixo', 'Servo drive com problema térmico', 'Correia ou acoplamento danificado'],
    solucoes: ['Reduzir avanço e profundidade de corte', 'Mover eixo manualmente (máquina desligada) para verificar folga', 'Verificar temperatura do servo drive no armário', 'Inspecionar correia e acoplamento do eixo X'],
    atencao: 'Se eixo duro ao mover manualmente = problema mecânico. Se move livre = problema elétrico/servo.'),
  AlarmeItem(codigo: '190', titulo: 'COOLANT LEVEL LOW',
    descricao: 'Nivel de refrigerante abaixo do minimo.',
    descricaoCompleta: 'O sensor de nível do tanque de refrigerante detectou nível abaixo do mínimo operacional.',
    gravidade: 'BAIXO', categoria: 'Refrigeração',
    causas: ['Consumo normal sem reabastecimento', 'Vazamento no sistema de refrigeração', 'Sensor de nível com defeito'],
    solucoes: ['Completar tanque com refrigerante da concentração correta (8-10% emulsão)', 'Verificar vazamentos nas mangueiras e conexões', 'Limpar ou substituir sensor de nível'],
    atencao: 'Manter concentração: usar refratômetro. Abaixo de 5% = risco de corrosão; acima de 15% = espuma e risco à saúde.'),
  AlarmeItem(codigo: '263', titulo: 'M-FIN TIMEOUT',
    descricao: 'M-code auxiliar nao finalizou no tempo esperado.',
    descricaoCompleta: 'Um M-code auxiliar (M03, M08, M60 etc.) não retornou sinal de finalização dentro do tempo limite configurado.',
    gravidade: 'MÉDIO', categoria: 'PLC/Auxiliares',
    causas: ['Motor de spindle não arrancou (problema elétrico)', 'Sensor de feedback do M-code com falha', 'Contator do spindle com problema', 'Parâmetro de timeout muito curto'],
    solucoes: ['Verificar se spindle gira (MDI: M03 S100)', 'Verificar tensão no contator do spindle', 'Checar parâmetro de timeout do M-code no PLC', 'Verificar sensor de confirmação do auxiliar'],
    atencao: null),
  AlarmeItem(codigo: '270', titulo: 'LUBE FAULT',
    descricao: 'Falha no sistema de lubrificacao periódica.',
    descricaoCompleta: 'O sistema de lubrificação periódica das guias e fuso de esferas reportou falha de pressão ou ciclo.',
    gravidade: 'ALTO', categoria: 'Lubrificação',
    causas: ['Reservatório de óleo de lubrificação vazio', 'Bomba de lubrificação com defeito', 'Pressostato de lubrificação sem sinal', 'Linha de lubrificação entupida'],
    solucoes: ['Verificar nível do reservatório de lubrificação das guias', 'Checar se bomba cicla (LED no controlador da bomba)', 'Verificar pressostato e sua fiação', 'Purgar linhas de lubrificação com seringa'],
    atencao: 'CRÍTICO para durabilidade: guias e fuso sem lubrificação adequada desgastam rapidamente. Verificar a cada 8h de operação.'),
  AlarmeItem(codigo: '306', titulo: 'AIR PRESSURE LOW',
    descricao: 'Pressao de ar comprimido abaixo do minimo HAAS.',
    descricaoCompleta: 'O pressostato detectou pressão de ar abaixo de 85 PSI (5.9 bar) mínimo requerido para operação segura.',
    gravidade: 'ALTO', categoria: 'Pneumática',
    causas: ['Compressor com capacidade insuficiente', 'Consumo simultâneo alto na linha de ar', 'Vazamento na linha de ar da máquina', 'Filtro de ar entupido'],
    solucoes: ['Verificar pressão no manômetro da entrada da máquina', 'Regular pressão na válvula para 90-100 PSI', 'Verificar vazamentos (spray com água+sabão)', 'Trocar elemento do filtro de ar (manutenção anual)'],
    atencao: 'Abaixo de 85 PSI: troca automática de ferramentas pode falhar e causar colisão com dano severo ao spindle.'),
];

// ─────────────────────────────────────────
// BANCO 3 — SIEMENS 840D sl específicos
// ─────────────────────────────────────────
const alarmesSiemensBank3 = [
  AlarmeItem(codigo: '10620', titulo: 'AXIS POSITION TOLERANCE EXCEEDED',
    descricao: 'Eixo excedeu a tolerancia de posicionamento.',
    descricaoCompleta: 'A diferença entre posição comandada e posição real do encoder excedeu o limite de tolerância (MD36010 STOP_LIMIT_FINE).',
    gravidade: 'ALTO', categoria: 'Servo/Encoder',
    causas: ['Folga mecânica excessiva no fuso ou guias', 'Sinal do encoder ruidoso', 'Parâmetro MD36010 muito rigoroso', 'Vibração ou colisão recente'],
    solucoes: ['Verificar folga do fuso com indicador de discagem', 'Checar sinal do encoder no SINAMICS (Diagnosis)', 'Ajustar MD36010 se tolerância foi reduzida', 'Verificar fixação mecânica do encoder no motor'],
    atencao: 'Se ocorre repetidamente: agendar inspeção mecânica — fuso pode estar desgastado.'),
  AlarmeItem(codigo: '25201', titulo: 'CONTOUR MONITORING AXIS X',
    descricao: 'Monitoramento de contorno disparado no eixo X.',
    descricaoCompleta: 'O eixo X seguiu o contorno com erro acima do permitido. Motor sobrecarregado ou limitação mecânica.',
    gravidade: 'ALTO', categoria: 'Servo',
    causas: ['Aceleração muito agressiva (MD1135)', 'Problema no servo drive SINAMICS', 'Atrito excessivo nas guias lineares', 'Carga no eixo acima da capacidade nominal'],
    solucoes: ['Reduzir aceleração no MD1135 (ACCEL_REDUCTION)', 'Verificar alarmes no SINAMICS (p0945, p0947)', 'Lubrificar guias lineares conforme manual', 'Verificar dimensionamento de carga no projeto do eixo'],
    atencao: null),
  AlarmeItem(codigo: '380501', titulo: 'NCK PROGRAM MEMORY FULL',
    descricao: 'Memoria de programas do NCK esta cheia.',
    descricaoCompleta: 'Não há mais espaço no NCK para armazenar programas novos. Todos os uploads serão rejeitados.',
    gravidade: 'MÉDIO', categoria: 'Memória',
    causas: ['Muitos programas acumulados sem exclusão', 'Programas grandes de CAM armazenados no NCK', 'Memória NCK original pequena (opção)'],
    solucoes: ['Deletar programas não utilizados via Program Manager', 'Mover programas grandes para External Memory (USB/CF card)', 'Verificar configuração MD18351 (tamanho partição de programas)'],
    atencao: 'Preferir trabalhar com DNC (External Execution) para programas grandes — não ocupa memória interna do NCK.'),
  AlarmeItem(codigo: '17500', titulo: 'TOOL MANAGEMENT: TOOL NOT FOUND',
    descricao: 'Ferramenta nao encontrada no gerenciamento.',
    descricaoCompleta: 'O sistema de gerenciamento de ferramentas (TM) não encontrou a ferramenta chamada com o T-code programado.',
    gravidade: 'MÉDIO', categoria: 'Gerenciamento de Ferramentas',
    causas: ['Ferramenta não cadastrada no TM', 'Número T incorreto no programa', 'Ferramenta marcada como removida no TM', 'Configuração do magazine incorreta'],
    solucoes: ['Verificar cadastro em Offset > Tools no TM', 'Confirmar número T no programa vs. número no TM', 'Verificar se ferramenta está como "Present" no TM', 'Verificar localização física no magazine'],
    atencao: null),
  AlarmeItem(codigo: '21612', titulo: 'DRIVE FAULT: DC LINK VOLTAGE LOW',
    descricao: 'Tensao do barramento DC do SINAMICS esta baixa.',
    descricaoCompleta: 'A tensão do barramento CC do drive SINAMICS está abaixo do mínimo. Pode indicar falha na alimentação CA ou no módulo de potência.',
    gravidade: 'CRÍTICO', categoria: 'Drive/Elétrica',
    causas: ['Queda de tensão na rede (fase faltando)', 'Módulo Line Module com defeito', 'Capacitores do barramento DC degradados', 'Conexões de potência frouxas no quadro'],
    solucoes: ['Verificar tensão nas 3 fases (380V ±10%) na entrada do quadro', 'Verificar LED de status do Line Module (verde = OK)', 'Checar temperatura do armário elétrico e ventilação', 'Verificar alarmes SINAMICS p0945 e p0947'],
    atencao: 'NUNCA abrir o quadro elétrico de drives com máquina energizada — capacitores mantêm carga perigosa por vários minutos após desligar.'),
];

// Getters expandidos com banco 3
List<AlarmeItem> get alarmesFanucCompletoV2 => [
  ...alarmesFanuc, ...alarmesFanucPS, ...alarmesFanucPSExtra,
  ...alarmesFanucOT, ...alarmesFanucSV, ...alarmesFanucOH, ...alarmesFanucSW,
];
List<AlarmeItem> get alarmesHaasCompletoV2 => [
  ...alarmesHaas, ...alarmesHaasExtras, ...alarmesHaasBank2, ...alarmesHaasBank3,
];
List<AlarmeItem> get alarmesSiemensCompletoV2 => [
  ...alarmesSiemens, ...alarmesSiemensExtras, ...alarmesSiemensBank2, ...alarmesSiemensBank3,
];
