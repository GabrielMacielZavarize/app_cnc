import type { CheckItem } from '@/types';
// Gerado por scripts/convert_dart_data.py — não editar à mão.

export const checklistItens: CheckItem[] = [
  
  {
    titulo: 'Verificar EPI completo',
    detalhe: 'Óculos de proteção, sapato com bico de aço, protetores auriculares disponíveis.',
    categoria: 'Pré-Partida', icone: '🥽'},
  {
    titulo: 'Inspeção visual da área',
    detalhe: 'Verificar se há ferramentas, trapos ou objetos sobre a mesa, guias e parafuso de fuso.',
    categoria: 'Pré-Partida', icone: '👁️'},
  {
    titulo: 'Verificar nível de óleo lubrificante',
    detalhe: 'Nível do reservatório de lubrificação das guias deve estar entre MIN e MAX.',
    categoria: 'Pré-Partida', icone: '🛢️'},
  {
    titulo: 'Verificar nível do fluido de corte',
    detalhe: 'Tanque deve estar acima do nível mínimo. Mistura correta: 5-8% concentrado em água.',
    categoria: 'Pré-Partida', icone: '💧'},
  {
    titulo: 'Verificar pressão do ar comprimido',
    detalhe: 'Pressão deve ser ≥ 6 bar (87 PSI) para máquinas Fanuc/Siemens, ≥ 85 PSI para HAAS.',
    categoria: 'Pré-Partida', icone: '💨'},
  {
    titulo: 'Verificar porta de proteção',
    detalhe: 'Fechar porta e confirmar funcionamento do sensor (indicador no painel deve aparecer).',
    categoria: 'Pré-Partida', icone: '🚪'},
  {
    titulo: 'Ligar o CNC e aguardar inicialização',
    detalhe: 'Aguardar o sistema operacional carregar completamente antes de qualquer operação.',
    categoria: 'Pré-Partida', icone: '⚡'},

  
  {
    titulo: 'Executar Zero Return (Referência)',
    detalhe: 'Sequência obrigatória: Z primeiro, depois X, Y e demais eixos. Nunca pular esta etapa.',
    categoria: 'Referência e Setup', icone: '🏠'},
  {
    titulo: 'Verificar ferramentas no magazine/revólver',
    detalhe: 'Confirmar posições T1-Tn. Verificar aperto dos porta-ferramentas e condição dos insertos.',
    categoria: 'Referência e Setup', icone: '🔧'},
  {
    titulo: 'Conferir offsets de comprimento (H)',
    detalhe: 'Verificar valores H no registro de ferramentas. Valores suspeitos ou zerados = risco de colisão.',
    categoria: 'Referência e Setup', icone: '📏'},
  {
    titulo: 'Confirmar zero-peça (G54-G59)',
    detalhe: 'Verificar coordenadas do zero-peça no registro de sistemas de coordenadas. Conferir com projeto.',
    categoria: 'Referência e Setup', icone: '📍'},
  {
    titulo: 'Verificar fixação da peça',
    detalhe: 'Conferir aperto de grampos, parafusos de fixação ou placa de 3 garras. Peça solta = colisão.',
    categoria: 'Referência e Setup', icone: '🔩'},

  
  {
    titulo: 'Checar programa CNC selecionado',
    detalhe: 'Confirmar que o programa correto está selecionado (nome/número) para a peça a usinare.',
    categoria: 'Primeiro Ciclo', icone: '📋'},
  {
    titulo: 'Rodar em DRY RUN / Bloqueio de máquina',
    detalhe: 'Para peça nova ou programa novo: rodar com Machine Lock ativo para verificar trajetória sem corte.',
    categoria: 'Primeiro Ciclo', icone: '🔄'},
  {
    titulo: 'Avançar bloco a bloco (Single Block)',
    detalhe: 'Para primeiro ciclo em peça nova: ativar Single Block e avançar manualmente o primeiro bloco G00/G01.',
    categoria: 'Primeiro Ciclo', icone: '▶️'},
  {
    titulo: 'Override de avanço a 0% — subir gradualmente',
    detalhe: 'Iniciar o ciclo com override de avanço em 0%. Subir gradualmente observando a trajetória.',
    categoria: 'Primeiro Ciclo', icone: '🎚️'},
  {
    titulo: 'Confirmar ponto de segurança em Z',
    detalhe: 'Verificar que G00 de aproximação vai para Z seguro (Z5 ou mais) antes de X/Y.',
    categoria: 'Primeiro Ciclo', icone: '⬆️'},

  
  {
    titulo: 'Monitorar carga do spindle',
    detalhe: 'Acompanhar barra de carga. Acima de 80%: reduzir avanço. Picos = ferramenta gasta ou parâmetros errados.',
    categoria: 'Durante a Operação', icone: '📊'},
  {
    titulo: 'Verificar refrigeração ativa',
    detalhe: 'Confirmar que fluido de corte está saindo pelo bocal correto e atingindo a zona de corte.',
    categoria: 'Durante a Operação', icone: '🌊'},
  {
    titulo: 'Observar formação de cavaco',
    detalhe: 'Cavaco azul = temperatura alta (reduzir Vc). Cavaco em fita longa = risco de embaraçar (ajustar F/Q).',
    categoria: 'Durante a Operação', icone: '🌀'},
  {
    titulo: 'Monitorar vibração e ruídos anormais',
    detalhe: 'Chiado alto = falta de rigidez ou ferramenta gasta. Vibração = balanço ou fixação frouxa.',
    categoria: 'Durante a Operação', icone: '👂'},
  {
    titulo: 'Verificar troca de ferramenta (ATC)',
    detalhe: 'Observar a 1ª troca automática. Confirmar que ferramenta correta foi selecionada e posicionada.',
    categoria: 'Durante a Operação', icone: '🔀'},

  
  {
    titulo: 'Medir 1ª peça completa',
    detalhe: 'Medir todas as cotas críticas no projeto. Verificar com instrumentos calibrados (paquímetro, micrômetro).',
    categoria: 'Inspeção', icone: '📐'},
  {
    titulo: 'Conferir acabamento superficial',
    detalhe: 'Verificar rugosidade visualmente e/ou com rugosímetro. Striações ou marcas = problema de parâmetros.',
    categoria: 'Inspeção', icone: '🔍'},
  {
    titulo: 'Verificar compensação de ferramenta se necessário',
    detalhe: 'Se cota fora da tolerância: ajustar wear offset (desgaste). Regra: + offset = remove mais material.',
    categoria: 'Inspeção', icone: '⚙️'},

  
  {
    titulo: 'Mover eixos para posição de segurança',
    detalhe: 'Ao terminar: posicionar Z no máximo positivo, X e Y em posição central ou home.',
    categoria: 'Fim de Turno', icone: '📦'},
  {
    titulo: 'Limpar máquina — remover cavacos',
    detalhe: 'Limpar cavacos da mesa, fixação e proteções. Cavacos em guias causam desgaste prematuro.',
    categoria: 'Fim de Turno', icone: '🧹'},
  {
    titulo: 'Registrar ocorrências no diário da máquina',
    detalhe: 'Anotar alarmes, quebras de ferramenta, desvios dimensionais ou qualquer anomalia observada.',
    categoria: 'Fim de Turno', icone: '📝'},
];
