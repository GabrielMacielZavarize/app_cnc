import 'package:flutter/material.dart';
import '../constants.dart';

// ─────────────────────────────────────────
// MODELO DO ITEM DE CHECKLIST
// ─────────────────────────────────────────
class CheckItem {
  final String titulo;
  final String detalhe;
  final String categoria;
  final String icone;
  bool concluido;

  CheckItem({
    required this.titulo,
    required this.detalhe,
    required this.categoria,
    required this.icone,
    this.concluido = false,
  });
}

// ─────────────────────────────────────────
// DADOS DO CHECKLIST (28 PASSOS)
// ─────────────────────────────────────────
List<CheckItem> _criarChecklist() => [
  // PRÉ-PARTIDA
  CheckItem(
    titulo: 'Verificar EPI completo',
    detalhe: 'Óculos de proteção, sapato com bico de aço, protetores auriculares disponíveis.',
    categoria: 'Pré-Partida', icone: '🥽'),
  CheckItem(
    titulo: 'Inspeção visual da área',
    detalhe: 'Verificar se há ferramentas, trapos ou objetos sobre a mesa, guias e parafuso de fuso.',
    categoria: 'Pré-Partida', icone: '👁️'),
  CheckItem(
    titulo: 'Verificar nível de óleo lubrificante',
    detalhe: 'Nível do reservatório de lubrificação das guias deve estar entre MIN e MAX.',
    categoria: 'Pré-Partida', icone: '🛢️'),
  CheckItem(
    titulo: 'Verificar nível do fluido de corte',
    detalhe: 'Tanque deve estar acima do nível mínimo. Mistura correta: 5-8% concentrado em água.',
    categoria: 'Pré-Partida', icone: '💧'),
  CheckItem(
    titulo: 'Verificar pressão do ar comprimido',
    detalhe: 'Pressão deve ser ≥ 6 bar (87 PSI) para máquinas Fanuc/Siemens, ≥ 85 PSI para HAAS.',
    categoria: 'Pré-Partida', icone: '💨'),
  CheckItem(
    titulo: 'Verificar porta de proteção',
    detalhe: 'Fechar porta e confirmar funcionamento do sensor (indicador no painel deve aparecer).',
    categoria: 'Pré-Partida', icone: '🚪'),
  CheckItem(
    titulo: 'Ligar o CNC e aguardar inicialização',
    detalhe: 'Aguardar o sistema operacional carregar completamente antes de qualquer operação.',
    categoria: 'Pré-Partida', icone: '⚡'),

  // REFERÊNCIA E SETUP
  CheckItem(
    titulo: 'Executar Zero Return (Referência)',
    detalhe: 'Sequência obrigatória: Z primeiro, depois X, Y e demais eixos. Nunca pular esta etapa.',
    categoria: 'Referência e Setup', icone: '🏠'),
  CheckItem(
    titulo: 'Verificar ferramentas no magazine/revólver',
    detalhe: 'Confirmar posições T1-Tn. Verificar aperto dos porta-ferramentas e condição dos insertos.',
    categoria: 'Referência e Setup', icone: '🔧'),
  CheckItem(
    titulo: 'Conferir offsets de comprimento (H)',
    detalhe: 'Verificar valores H no registro de ferramentas. Valores suspeitos ou zerados = risco de colisão.',
    categoria: 'Referência e Setup', icone: '📏'),
  CheckItem(
    titulo: 'Confirmar zero-peça (G54-G59)',
    detalhe: 'Verificar coordenadas do zero-peça no registro de sistemas de coordenadas. Conferir com projeto.',
    categoria: 'Referência e Setup', icone: '📍'),
  CheckItem(
    titulo: 'Verificar fixação da peça',
    detalhe: 'Conferir aperto de grampos, parafusos de fixação ou placa de 3 garras. Peça solta = colisão.',
    categoria: 'Referência e Setup', icone: '🔩'),

  // PRIMEIRO CICLO / DRY RUN
  CheckItem(
    titulo: 'Checar programa CNC selecionado',
    detalhe: 'Confirmar que o programa correto está selecionado (nome/número) para a peça a usinare.',
    categoria: 'Primeiro Ciclo', icone: '📋'),
  CheckItem(
    titulo: 'Rodar em DRY RUN / Bloqueio de máquina',
    detalhe: 'Para peça nova ou programa novo: rodar com Machine Lock ativo para verificar trajetória sem corte.',
    categoria: 'Primeiro Ciclo', icone: '🔄'),
  CheckItem(
    titulo: 'Avançar bloco a bloco (Single Block)',
    detalhe: 'Para primeiro ciclo em peça nova: ativar Single Block e avançar manualmente o primeiro bloco G00/G01.',
    categoria: 'Primeiro Ciclo', icone: '▶️'),
  CheckItem(
    titulo: 'Override de avanço a 0% — subir gradualmente',
    detalhe: 'Iniciar o ciclo com override de avanço em 0%. Subir gradualmente observando a trajetória.',
    categoria: 'Primeiro Ciclo', icone: '🎚️'),
  CheckItem(
    titulo: 'Confirmar ponto de segurança em Z',
    detalhe: 'Verificar que G00 de aproximação vai para Z seguro (Z5 ou mais) antes de X/Y.',
    categoria: 'Primeiro Ciclo', icone: '⬆️'),

  // DURANTE A OPERAÇÃO
  CheckItem(
    titulo: 'Monitorar carga do spindle',
    detalhe: 'Acompanhar barra de carga. Acima de 80%: reduzir avanço. Picos = ferramenta gasta ou parâmetros errados.',
    categoria: 'Durante a Operação', icone: '📊'),
  CheckItem(
    titulo: 'Verificar refrigeração ativa',
    detalhe: 'Confirmar que fluido de corte está saindo pelo bocal correto e atingindo a zona de corte.',
    categoria: 'Durante a Operação', icone: '🌊'),
  CheckItem(
    titulo: 'Observar formação de cavaco',
    detalhe: 'Cavaco azul = temperatura alta (reduzir Vc). Cavaco em fita longa = risco de embaraçar (ajustar F/Q).',
    categoria: 'Durante a Operação', icone: '🌀'),
  CheckItem(
    titulo: 'Monitorar vibração e ruídos anormais',
    detalhe: 'Chiado alto = falta de rigidez ou ferramenta gasta. Vibração = balanço ou fixação frouxa.',
    categoria: 'Durante a Operação', icone: '👂'),
  CheckItem(
    titulo: 'Verificar troca de ferramenta (ATC)',
    detalhe: 'Observar a 1ª troca automática. Confirmar que ferramenta correta foi selecionada e posicionada.',
    categoria: 'Durante a Operação', icone: '🔀'),

  // INSPEÇÃO DIMENSIONAL
  CheckItem(
    titulo: 'Medir 1ª peça completa',
    detalhe: 'Medir todas as cotas críticas no projeto. Verificar com instrumentos calibrados (paquímetro, micrômetro).',
    categoria: 'Inspeção', icone: '📐'),
  CheckItem(
    titulo: 'Conferir acabamento superficial',
    detalhe: 'Verificar rugosidade visualmente e/ou com rugosímetro. Striações ou marcas = problema de parâmetros.',
    categoria: 'Inspeção', icone: '🔍'),
  CheckItem(
    titulo: 'Verificar compensação de ferramenta se necessário',
    detalhe: 'Se cota fora da tolerância: ajustar wear offset (desgaste). Regra: + offset = remove mais material.',
    categoria: 'Inspeção', icone: '⚙️'),

  // FIM DE TURNO
  CheckItem(
    titulo: 'Mover eixos para posição de segurança',
    detalhe: 'Ao terminar: posicionar Z no máximo positivo, X e Y em posição central ou home.',
    categoria: 'Fim de Turno', icone: '📦'),
  CheckItem(
    titulo: 'Limpar máquina — remover cavacos',
    detalhe: 'Limpar cavacos da mesa, fixação e proteções. Cavacos em guias causam desgaste prematuro.',
    categoria: 'Fim de Turno', icone: '🧹'),
  CheckItem(
    titulo: 'Registrar ocorrências no diário da máquina',
    detalhe: 'Anotar alarmes, quebras de ferramenta, desvios dimensionais ou qualquer anomalia observada.',
    categoria: 'Fim de Turno', icone: '📝'),
];

// ─────────────────────────────────────────
// TELA PRINCIPAL DO CHECKLIST
// ─────────────────────────────────────────
class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});
  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  late List<CheckItem> _items;
  String _filtroCategoria = 'Todos';

  static const _categorias = [
    'Todos',
    'Pré-Partida',
    'Referência e Setup',
    'Primeiro Ciclo',
    'Durante a Operação',
    'Inspeção',
    'Fim de Turno',
  ];

  static const _coresCategorias = {
    'Pré-Partida': Color(0xFF1565C0),
    'Referência e Setup': Color(0xFF2E7D32),
    'Primeiro Ciclo': Color(0xFF6A1B9A),
    'Durante a Operação': Color(0xFFE65100),
    'Inspeção': Color(0xFF00695C),
    'Fim de Turno': Color(0xFF4E342E),
  };

  @override
  void initState() {
    super.initState();
    _items = _criarChecklist();
  }

  List<CheckItem> get _itemsFiltrados => _filtroCategoria == 'Todos'
      ? _items
      : _items.where((i) => i.categoria == _filtroCategoria).toList();

  int get _totalConcluidos => _items.where((i) => i.concluido).length;
  double get _progresso => _items.isEmpty ? 0 : _totalConcluidos / _items.length;

  Color _corCategoria(String cat) => _coresCategorias[cat] ?? kBlue;

  void _resetarTodos() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Resetar Checklist'),
        content: const Text('Desmarcar todos os itens e começar novo turno?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kRed),
            onPressed: () {
              setState(() {
                for (final item in _items) item.concluido = false;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Resetar', style: TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itens = _itemsFiltrados;

    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        // HEADER
        Container(
          color: kDark,
          padding: const EdgeInsets.fromLTRB(20, 55, 20, 16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.checklist_rounded, color: Colors.white, size: 20)),
              const SizedBox(width: 12),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Checklist do Operador',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                Text('28 PASSOS — ROTINA DIÁRIA CNC', style: TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.5)),
              ])),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: Colors.grey),
                tooltip: 'Resetar turno',
                onPressed: _resetarTodos),
            ]),

            const SizedBox(height: 14),

            // BARRA DE PROGRESSO
            Row(children: [
              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _progresso,
                  backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation(
                    _progresso == 1.0 ? kGreen : kAmber),
                  minHeight: 8))),
              const SizedBox(width: 12),
              Text('$_totalConcluidos/${_items.length}',
                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ]),

            if (_progresso == 1.0)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: kGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kGreen.withValues(alpha: 0.4))),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.check_circle_rounded, color: kGreen, size: 16),
                  SizedBox(width: 6),
                  Text('Checklist completo! Bom turno! ✅',
                    style: TextStyle(color: kGreen, fontSize: 12, fontWeight: FontWeight.w600)),
                ])),

            const SizedBox(height: 12),

            // FILTRO DE CATEGORIAS
            SizedBox(
              height: 30,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categorias.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (ctx, i) {
                  final cat = _categorias[i];
                  final ativo = _filtroCategoria == cat;
                  final cor = cat == 'Todos' ? kAmber : _corCategoria(cat);
                  return GestureDetector(
                    onTap: () => setState(() => _filtroCategoria = cat),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: ativo ? cor : cor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: ativo ? cor : cor.withValues(alpha: 0.3))),
                      child: Text(cat,
                        style: TextStyle(
                          fontSize: 11,
                          color: ativo ? Colors.white : cor,
                          fontWeight: FontWeight.w600))));
                }),
            ),
          ]),
        ),

        // LISTA DE ITENS
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: itens.length,
          itemBuilder: (ctx, i) {
            // Mostrar cabeçalho de categoria se mudou
            final item = itens[i];
            final showHeader = i == 0 || itens[i - 1].categoria != item.categoria;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showHeader) ...[
                  if (i > 0) const SizedBox(height: 8),
                  _CategoriaHeader(
                    titulo: item.categoria,
                    cor: _corCategoria(item.categoria),
                    total: itens.where((x) => x.categoria == item.categoria).length,
                    concluidos: itens.where((x) => x.categoria == item.categoria && x.concluido).length,
                  ),
                  const SizedBox(height: 6),
                ],
                Center(child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: _CheckCard(
                    item: item,
                    cor: _corCategoria(item.categoria),
                    onToggle: () => setState(() => item.concluido = !item.concluido),
                  ))),
              ],
            );
          },
        )),
      ]),
    );
  }
}

// ─────────────────────────────────────────
// HEADER DE CATEGORIA
// ─────────────────────────────────────────
class _CategoriaHeader extends StatelessWidget {
  final String titulo;
  final Color cor;
  final int total, concluidos;
  const _CategoriaHeader({required this.titulo, required this.cor, required this.total, required this.concluidos});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(children: [
        Container(width: 3, height: 18, decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 8),
        Text(titulo,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cor, letterSpacing: 0.5)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: concluidos == total ? cor.withValues(alpha: 0.15) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10)),
          child: Text('$concluidos/$total',
            style: TextStyle(fontSize: 10, color: concluidos == total ? cor : Colors.grey.shade500, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}

// ─────────────────────────────────────────
// CARD DO ITEM DO CHECKLIST
// ─────────────────────────────────────────
class _CheckCard extends StatelessWidget {
  final CheckItem item;
  final Color cor;
  final VoidCallback onToggle;
  const _CheckCard({required this.item, required this.cor, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: item.concluido ? cor.withValues(alpha: 0.06) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: item.concluido ? cor.withValues(alpha: 0.35) : Colors.grey.shade100,
            width: item.concluido ? 1.5 : 0.5)),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // ÍCONE DO ITEM
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: item.concluido ? cor.withValues(alpha: 0.12) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8)),
            child: Center(child: Text(item.icone, style: const TextStyle(fontSize: 18)))),
          const SizedBox(width: 12),

          // CONTEÚDO
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(item.titulo,
              style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600,
                color: item.concluido ? cor : kDark,
                decoration: item.concluido ? TextDecoration.lineThrough : TextDecoration.none,
                decorationColor: cor)),
            const SizedBox(height: 3),
            Text(item.detalhe,
              style: TextStyle(
                fontSize: 11,
                color: item.concluido ? cor.withValues(alpha: 0.6) : Colors.grey.shade500,
                height: 1.4)),
          ])),
          const SizedBox(width: 8),

          // CHECKBOX
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              item.concluido ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              key: ValueKey(item.concluido),
              color: item.concluido ? cor : Colors.grey.shade300,
              size: 24)),
        ]),
      ),
    );
  }
}
