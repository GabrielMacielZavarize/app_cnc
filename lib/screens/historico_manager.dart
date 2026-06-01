import '../constants.dart';
import 'package:flutter/material.dart';

// ─────────────────────────────────────────
// MODELOS
// ─────────────────────────────────────────
class ItemHistorico {
  final String titulo, subtitulo, tipo, id;
  final DateTime data;
  const ItemHistorico({
    required this.titulo,
    required this.subtitulo,
    required this.tipo,
    required this.id,
    required this.data,
  });
}

class NotaPessoal {
  final String id, titulo, conteudo;
  final DateTime data;
  final Color cor;

  NotaPessoal({
    required this.id,
    required this.titulo,
    required this.conteudo,
    required this.data,
    required this.cor,
  });

  NotaPessoal copyWith({String? titulo, String? conteudo}) {
    return NotaPessoal(
      id: id,
      cor: cor,
      data: DateTime.now(),
      titulo: titulo ?? this.titulo,
      conteudo: conteudo ?? this.conteudo,
    );
  }
}

// ─────────────────────────────────────────
// GERENCIADOR SINGLETON
// ─────────────────────────────────────────
class HistoricoManager extends ChangeNotifier {
  static final HistoricoManager _i = HistoricoManager._();
  factory HistoricoManager() => _i;
  HistoricoManager._();

  final List<ItemHistorico> _historico = [];
  final List<NotaPessoal> _notas = [];

  List<ItemHistorico> get historico => List.unmodifiable(_historico);
  List<NotaPessoal> get notas => List.unmodifiable(_notas);

  void addHistorico(ItemHistorico item) {
    _historico.removeWhere((h) => h.id == item.id);
    _historico.insert(0, item);
    if (_historico.length > 50) _historico.removeLast();
    notifyListeners();
  }

  void addNota(NotaPessoal nota) {
    _notas.insert(0, nota);
    notifyListeners();
  }

  void editarNota(String id, String titulo, String conteudo) {
    final idx = _notas.indexWhere((n) => n.id == id);
    if (idx >= 0) {
      _notas[idx] = _notas[idx].copyWith(titulo: titulo, conteudo: conteudo);
      notifyListeners();
    }
  }

  void deletarNota(String id) {
    _notas.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void limparHistorico() {
    _historico.clear();
    notifyListeners();
  }
}

final historicoManager = HistoricoManager();

// ─────────────────────────────────────────
// TELA PRINCIPAL
// ─────────────────────────────────────────
class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  static const Color _kDark  = Color(0xFF1A1A2E);
  static const Color _kAmber = Color(0xFFE8A020);
  static const Color _kBg    = Color(0xFFF5F5F5);
  static const Color _kBlue  = Color(0xFF185FA5);

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    historicoManager.addListener(_refresh);
  }

  @override
  void dispose() {
    _tab.dispose();
    historicoManager.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                _HistoricoList(),
                _NotasList(onNovaNota: () => _showNotaDialog(context)),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tab,
        builder: (context, child) {
          if (_tab.index == 1) {
            return FloatingActionButton(
              backgroundColor: _kAmber,
              onPressed: () => _showNotaDialog(context),
              child: const Icon(Icons.add_rounded, color: _kDark),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: _kDark,
      padding: const EdgeInsets.fromLTRB(20, 55, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _kBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.history_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Histórico & Notas',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'SEU USO DO APP',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 9,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          TabBar(
            controller: _tab,
            labelColor: _kAmber,
            unselectedLabelColor: Colors.grey,
            indicatorColor: _kAmber,
            indicatorSize: TabBarIndicatorSize.label,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            tabs: [
              Tab(text: 'Histórico (${historicoManager.historico.length})'),
              Tab(text: 'Notas (${historicoManager.notas.length})'),
            ],
          ),
        ],
      ),
    );
  }

  void _showNotaDialog(BuildContext ctx, {NotaPessoal? nota}) {
    final tituloCtrl = TextEditingController(text: nota?.titulo ?? '');
    final conteudoCtrl = TextEditingController(text: nota?.conteudo ?? '');
    const List<Color> cores = [
      Color(0xFFE8A020),
      Color(0xFF185FA5),
      Color(0xFF0F6E56),
      Color(0xFFA32D2D),
      Color(0xFF534AB7),
    ];
    int corIdx = 0;

    showModalBottomSheet<void>(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (builderCtx, setLocal) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(builderCtx).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Nova Nota',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        ...cores.asMap().entries.map((e) {
                          return GestureDetector(
                            onTap: () => setLocal(() => corIdx = e.key),
                            child: Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(left: 6),
                              decoration: BoxDecoration(
                                color: e.value,
                                shape: BoxShape.circle,
                                border: corIdx == e.key
                                    ? Border.all(color: Colors.black, width: 2.5)
                                    : null,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: tituloCtrl,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        hintText: 'Título da nota...',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: conteudoCtrl,
                      maxLines: 4,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Ex: G54 X=-250.5, broca Ø8mm F=0.05...',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    GestureDetector(
                      onTap: () {
                        if (tituloCtrl.text.isEmpty) return;
                        if (nota != null) {
                          historicoManager.editarNota(
                            nota.id, tituloCtrl.text, conteudoCtrl.text);
                        } else {
                          historicoManager.addNota(NotaPessoal(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            titulo: tituloCtrl.text,
                            conteudo: conteudoCtrl.text,
                            data: DateTime.now(),
                            cor: cores[corIdx],
                          ));
                        }
                        Navigator.pop(builderCtx);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A2E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Salvar Nota',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────
// LISTA DE HISTÓRICO
// ─────────────────────────────────────────
class _HistoricoList extends StatelessWidget {
  const _HistoricoList({super.key});

  @override
  Widget build(BuildContext context) {
    final historico = historicoManager.historico;

    if (historico.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history_rounded, size: 56, color: Colors.grey.shade200),
              const SizedBox(height: 14),
              const Text(
                'Nenhuma consulta ainda',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Seus códigos, alarmes e materiais\nconsultados aparecerão aqui',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${historico.length} consultas',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              GestureDetector(
                onTap: () => historicoManager.limparHistorico(),
                child: Text(
                  'Limpar tudo',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: historico.length,
            itemBuilder: (ctx, i) {
              final item = historico[i];
              final cor = _corTipo(item.tipo);
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: cor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(_iconeTipo(item.tipo), color: cor, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.titulo,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: cor.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.tipo,
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: cor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _formatarData(item.data),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Color _corTipo(String tipo) {
    switch (tipo) {
      case 'Código G': return const Color(0xFFBA7517);
      case 'Código M': return const Color(0xFF0F6E56);
      case 'Alarme':   return const Color(0xFFA32D2D);
      case 'Material': return const Color(0xFF185FA5);
      case 'Programa': return const Color(0xFF2E7D32);
      case 'Cálculo':  return const Color(0xFF534AB7);
      default:         return Colors.grey;
    }
  }

  IconData _iconeTipo(String tipo) {
    switch (tipo) {
      case 'Código G': return Icons.menu_book_rounded;
      case 'Código M': return Icons.menu_book_outlined;
      case 'Alarme':   return Icons.warning_amber_rounded;
      case 'Material': return Icons.layers_rounded;
      case 'Programa': return Icons.code_rounded;
      case 'Cálculo':  return Icons.calculate_rounded;
      default:         return Icons.history_rounded;
    }
  }

  String _formatarData(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'há ${diff.inHours}h';
    if (diff.inDays < 7) return 'há ${diff.inDays}d';
    return '${d.day}/${d.month}';
  }
}

// ─────────────────────────────────────────
// LISTA DE NOTAS
// ─────────────────────────────────────────
class _NotasList extends StatelessWidget {
  final VoidCallback onNovaNota;
  const _NotasList({super.key, required this.onNovaNota});

  @override
  Widget build(BuildContext context) {
    final notas = historicoManager.notas;

    if (notas.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.sticky_note_2_outlined, size: 56, color: Colors.grey.shade200),
              const SizedBox(height: 14),
              const Text(
                'Nenhuma nota ainda',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Toque no + para criar sua primeira nota',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3DC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '💡 Use notas para guardar offsets,\nzero-peças e dicas pessoais',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFBA7517),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notas.length,
      itemBuilder: (ctx, i) {
        final nota = notas[i];
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Dismissible(
              key: Key(nota.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => historicoManager.deletarNota(nota.id),
              background: Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFA32D2D),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: const Icon(Icons.delete_rounded, color: Colors.white),
              ),
              child: GestureDetector(
                onTap: () => _editarNota(ctx, nota),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border(
                      left: BorderSide(color: nota.cor, width: 4),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              nota.titulo,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            _formatarData(nota.data),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                      if (nota.conteudo.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          nota.conteudo,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _editarNota(BuildContext context, NotaPessoal nota) {
    final tituloCtrl = TextEditingController(text: nota.titulo);
    final conteudoCtrl = TextEditingController(text: nota.conteudo);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Editar Nota',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: tituloCtrl,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'Título...',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: conteudoCtrl,
                  maxLines: 4,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Conteúdo...',
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () {
                    historicoManager.editarNota(
                      nota.id, tituloCtrl.text, conteudoCtrl.text);
                    Navigator.pop(sheetCtx);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatarData(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return 'agora';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes}min';
    if (diff.inHours < 24) return 'há ${diff.inHours}h';
    return '${d.day}/${d.month}/${d.year}';
  }
}
