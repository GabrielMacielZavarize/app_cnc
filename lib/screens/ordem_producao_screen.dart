import 'package:flutter/material.dart';
import '../constants.dart';

// ─────────────────────────────────────────────────────────────
// MODELO
// ─────────────────────────────────────────────────────────────
enum StatusOrdem { pendente, emAndamento, concluida, pausada, reprovada }

class OrdemProducao {
  final String id;
  String nomePeca;
  String numeroProg;
  String material;
  String maquina;
  int qtdTotal;
  int qtdProduzida;
  int qtdRejeitada;
  StatusOrdem status;
  String operador;
  String observacao;
  final DateTime criada;
  DateTime? iniciada;
  DateTime? finalizada;

  OrdemProducao({
    required this.id,
    required this.nomePeca,
    required this.numeroProg,
    required this.material,
    required this.maquina,
    required this.qtdTotal,
    this.qtdProduzida = 0,
    this.qtdRejeitada = 0,
    this.status = StatusOrdem.pendente,
    this.operador = '',
    this.observacao = '',
    required this.criada,
  });
}

// ─────────────────────────────────────────────────────────────
// TELA PRINCIPAL
// ─────────────────────────────────────────────────────────────
class OrdemProducaoScreen extends StatefulWidget {
  const OrdemProducaoScreen({super.key});
  @override
  State<OrdemProducaoScreen> createState() => _OrdemProducaoScreenState();
}

class _OrdemProducaoScreenState extends State<OrdemProducaoScreen> {
  final List<OrdemProducao> _ordens = [
    OrdemProducao(
      id: 'OP-001', nomePeca: 'Flange DN50', numeroProg: 'O1001',
      material: 'Aço 1045', maquina: 'TORNO CNC #1',
      qtdTotal: 20, qtdProduzida: 12, qtdRejeitada: 1,
      status: StatusOrdem.emAndamento, operador: 'Carlos',
      criada: DateTime.now().subtract(const Duration(hours: 3))),
    OrdemProducao(
      id: 'OP-002', nomePeca: 'Eixo 25mm', numeroProg: 'O2050',
      material: 'Inox 304', maquina: 'TORNO CNC #2',
      qtdTotal: 10, qtdProduzida: 0,
      status: StatusOrdem.pendente, operador: '',
      criada: DateTime.now().subtract(const Duration(hours: 1))),
    OrdemProducao(
      id: 'OP-003', nomePeca: 'Tampa Caixa', numeroProg: 'O3010',
      material: 'Alumínio 6061', maquina: 'CENTRO USINAGEM #1',
      qtdTotal: 50, qtdProduzida: 50, qtdRejeitada: 2,
      status: StatusOrdem.concluida, operador: 'Ana',
      criada: DateTime.now().subtract(const Duration(days: 1))),
  ];

  StatusOrdem? _filtroStatus;
  int _idCounter = 4;

  List<OrdemProducao> get _ordensFiltradas => _filtroStatus == null
      ? _ordens
      : _ordens.where((o) => o.status == _filtroStatus).toList();

  // ── Cores e labels por status ─────────────────────────────
  static const _statusCores = {
    StatusOrdem.pendente:    Color(0xFF1565C0),
    StatusOrdem.emAndamento: Color(0xFFE65100),
    StatusOrdem.concluida:   Color(0xFF2E7D32),
    StatusOrdem.pausada:     Color(0xFF6A1B9A),
    StatusOrdem.reprovada:   Color(0xFFC62828),
  };
  static const _statusLabels = {
    StatusOrdem.pendente:    '⏳ Pendente',
    StatusOrdem.emAndamento: '⚙️ Em Andamento',
    StatusOrdem.concluida:   '✅ Concluída',
    StatusOrdem.pausada:     '⏸️ Pausada',
    StatusOrdem.reprovada:   '❌ Reprovada',
  };

  Color _cor(StatusOrdem s) => _statusCores[s]!;
  String _label(StatusOrdem s) => _statusLabels[s]!;

  // ── Estatísticas rápidas ──────────────────────────────────
  int get _totalPecas => _ordens.fold(0, (a, o) => a + o.qtdTotal);
  int get _produzidas => _ordens.fold(0, (a, o) => a + o.qtdProduzida);
  int get _rejeitadas => _ordens.fold(0, (a, o) => a + o.qtdRejeitada);
  double get _eficiencia => _produzidas == 0 ? 0
      : ((_produzidas - _rejeitadas) / _produzidas * 100);

  @override
  Widget build(BuildContext context) {
    final ordens = _ordensFiltradas;
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        _buildHeader(),
        _buildEstatisticas(),
        _buildFiltros(),
        Expanded(child: ordens.isEmpty
          ? _buildVazio()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
              itemCount: ordens.length,
              itemBuilder: (ctx, i) => _OrdemCard(
                ordem: ordens[i],
                cor: _cor(ordens[i].status),
                label: _label(ordens[i].status),
                onTap: () => _abrirDetalhes(ordens[i]),
              ))),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kAmber,
        foregroundColor: kDark,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nova OP', style: TextStyle(fontWeight: FontWeight.w700)),
        onPressed: _novaOrdem),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: kDark,
      padding: const EdgeInsets.fromLTRB(20, 55, 20, 16),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(color: const Color(0xFF1565C0), borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.assignment_rounded, color: Colors.white, size: 20)),
        const SizedBox(width: 12),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Ordens de Produção',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
          Text('CONTROLE DE PEÇAS E CICLOS', style: TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.5)),
        ])),
      ]));
  }

  Widget _buildEstatisticas() {
    return Container(
      color: kDark,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      child: Row(children: [
        _StatChip(valor: '${_ordens.length}', label: 'OPs', cor: kAmber),
        const SizedBox(width: 8),
        _StatChip(valor: '$_produzidas/$_totalPecas', label: 'Peças', cor: kBlue),
        const SizedBox(width: 8),
        _StatChip(valor: '$_rejeitadas', label: 'Rejeit.', cor: kRed),
        const SizedBox(width: 8),
        _StatChip(valor: '${_eficiencia.toStringAsFixed(0)}%', label: 'Efic.', cor: kGreen),
      ]));
  }

  Widget _buildFiltros() {
    final opcoes = [null, ...StatusOrdem.values];
    return Container(
      height: 42,
      color: kDark,
      padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: opcoes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (ctx, i) {
          final s = opcoes[i];
          final ativo = _filtroStatus == s;
          final cor = s == null ? kAmber : _cor(s);
          final texto = s == null ? '📋 Todos' : _label(s);
          return GestureDetector(
            onTap: () => setState(() => _filtroStatus = s),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: ativo ? cor : cor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: ativo ? cor : cor.withValues(alpha: 0.4))),
              child: Text(texto,
                style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  color: ativo ? Colors.white : cor))));
        }),
    );
  }

  Widget _buildVazio() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.assignment_outlined, size: 64, color: Colors.grey.shade200),
      const SizedBox(height: 12),
      Text('Nenhuma ordem neste filtro',
        style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
      const SizedBox(height: 6),
      Text('Toque em "Nova OP" para criar',
        style: TextStyle(color: Colors.grey.shade300, fontSize: 12)),
    ]));
  }

  // ── Nova Ordem ──────────────────────────────────────────────
  void _novaOrdem() {
    final nomeCtrl    = TextEditingController();
    final progCtrl    = TextEditingController();
    final matCtrl     = TextEditingController();
    final maqCtrl     = TextEditingController();
    final qtdCtrl     = TextEditingController(text: '1');
    final operCtrl    = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.add_circle_outline_rounded, color: kBlue),
              const SizedBox(width: 8),
              const Text('Nova Ordem de Produção',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
            ]),
            const SizedBox(height: 12),
            _Campo(ctrl: nomeCtrl, label: 'Nome da Peça *', hint: 'Ex: Flange DN50'),
            _Campo(ctrl: progCtrl, label: 'Número do Programa', hint: 'Ex: O1001'),
            Row(children: [
              Expanded(child: _Campo(ctrl: matCtrl, label: 'Material', hint: 'Ex: Aço 1045')),
              const SizedBox(width: 10),
              Expanded(child: _Campo(ctrl: maqCtrl, label: 'Máquina', hint: 'Ex: CNC #1')),
            ]),
            Row(children: [
              SizedBox(width: 100, child: _Campo(ctrl: qtdCtrl, label: 'Qtd Total *', hint: '1', tipo: TextInputType.number)),
              const SizedBox(width: 10),
              Expanded(child: _Campo(ctrl: operCtrl, label: 'Operador', hint: 'Nome do operador')),
            ]),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAmber, foregroundColor: kDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                icon: const Icon(Icons.check_rounded),
                label: const Text('Criar Ordem', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                onPressed: () {
                  if (nomeCtrl.text.trim().isEmpty) return;
                  final op = OrdemProducao(
                    id: 'OP-${_idCounter.toString().padLeft(3, '0')}',
                    nomePeca: nomeCtrl.text.trim(),
                    numeroProg: progCtrl.text.trim(),
                    material: matCtrl.text.trim(),
                    maquina: maqCtrl.text.trim(),
                    qtdTotal: int.tryParse(qtdCtrl.text) ?? 1,
                    operador: operCtrl.text.trim(),
                    criada: DateTime.now(),
                  );
                  setState(() {
                    _ordens.insert(0, op);
                    _idCounter++;
                  });
                  Navigator.pop(ctx);
                })),
          ]))));
  }

  // ── Detalhes / Edição ────────────────────────────────────────
  void _abrirDetalhes(OrdemProducao op) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            padding: const EdgeInsets.all(20),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              // TÍTULO
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _cor(op.status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8)),
                  child: Text(op.id,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _cor(op.status)))),
                const SizedBox(width: 10),
                Expanded(child: Text(op.nomePeca,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(ctx)),
              ]),
              const Divider(height: 20),

              // INFO
              Row(children: [
                _InfoPill(label: op.material.isEmpty ? 'Material —' : op.material, icone: Icons.layers_rounded, cor: kBlue),
                const SizedBox(width: 8),
                _InfoPill(label: op.maquina.isEmpty ? 'Máquina —' : op.maquina, icone: Icons.settings_rounded, cor: kGreen),
              ]),
              if (op.numeroProg.isNotEmpty) ...[
                const SizedBox(height: 8),
                _InfoPill(label: 'Prog: ${op.numeroProg}', icone: Icons.code_rounded, cor: const Color(0xFF6A1B9A)),
              ],
              const SizedBox(height: 14),

              // PROGRESSO
              Row(children: [
                const Text('Produzidas:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                const Spacer(),
                Text('${op.qtdProduzida} / ${op.qtdTotal}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: op.qtdTotal > 0 ? op.qtdProduzida / op.qtdTotal : 0,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: AlwaysStoppedAnimation(_cor(op.status)),
                  minHeight: 10)),
              if (op.qtdRejeitada > 0) ...[
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.cancel_outlined, size: 13, color: kRed),
                  const SizedBox(width: 4),
                  Text('${op.qtdRejeitada} peça(s) rejeitada(s)',
                    style: const TextStyle(fontSize: 11, color: kRed)),
                ]),
              ],
              const SizedBox(height: 16),

              // AÇÕES RÁPIDAS
              Row(children: [
                if (op.status == StatusOrdem.pendente || op.status == StatusOrdem.pausada)
                  Expanded(child: _BtnAcao(
                    label: 'Iniciar', icone: Icons.play_arrow_rounded, cor: kGreen,
                    onTap: () { setModal(() { op.status = StatusOrdem.emAndamento; op.iniciada ??= DateTime.now(); }); setState(() {}); })),
                if (op.status == StatusOrdem.emAndamento) ...[
                  Expanded(child: _BtnAcao(
                    label: '+ Peça', icone: Icons.add_circle_outline_rounded, cor: kBlue,
                    onTap: () {
                      if (op.qtdProduzida < op.qtdTotal) setModal(() { op.qtdProduzida++; setState(() {}); });
                    })),
                  const SizedBox(width: 8),
                  Expanded(child: _BtnAcao(
                    label: 'Pausar', icone: Icons.pause_rounded, cor: const Color(0xFF6A1B9A),
                    onTap: () { setModal(() { op.status = StatusOrdem.pausada; }); setState(() {}); })),
                  const SizedBox(width: 8),
                  Expanded(child: _BtnAcao(
                    label: 'Concluir', icone: Icons.check_rounded, cor: kGreen,
                    onTap: () { setModal(() { op.status = StatusOrdem.concluida; op.finalizada = DateTime.now(); }); setState(() {}); })),
                ],
                if (op.status == StatusOrdem.concluida)
                  Expanded(child: _BtnAcao(
                    label: 'Reabrir', icone: Icons.refresh_rounded, cor: kAmber,
                    onTap: () { setModal(() { op.status = StatusOrdem.emAndamento; op.finalizada = null; }); setState(() {}); })),
              ]),

              // REJEITAR
              if (op.status == StatusOrdem.emAndamento) ...[
                const SizedBox(height: 8),
                SizedBox(width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kRed),
                      foregroundColor: kRed),
                    icon: const Icon(Icons.remove_circle_outline_rounded, size: 16),
                    label: const Text('Registrar Rejeição', style: TextStyle(fontSize: 12)),
                    onPressed: () {
                      setModal(() { if (op.qtdRejeitada < op.qtdTotal) op.qtdRejeitada++; });
                      setState(() {});
                    })),
              ],
              const SizedBox(height: 8),
            ])))));
  }
}

// ─────────────────────────────────────────────────────────────
// CARD DA ORDEM
// ─────────────────────────────────────────────────────────────
class _OrdemCard extends StatelessWidget {
  final OrdemProducao ordem;
  final Color cor;
  final String label;
  final VoidCallback onTap;
  const _OrdemCard({required this.ordem, required this.cor, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final progresso = ordem.qtdTotal > 0 ? ordem.qtdProduzida / ordem.qtdTotal : 0.0;
    return GestureDetector(
      onTap: onTap,
      child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cor.withValues(alpha: 0.2)),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: cor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6)),
                child: Text(ordem.id,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: cor))),
              const SizedBox(width: 8),
              Expanded(child: Text(ordem.nomePeca,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: cor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(label, style: TextStyle(fontSize: 10, color: cor, fontWeight: FontWeight.w600))),
            ]),
            const SizedBox(height: 8),
            Row(children: [
              if (ordem.material.isNotEmpty) ...[
                Icon(Icons.layers_rounded, size: 12, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(ordem.material, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                const SizedBox(width: 10),
              ],
              if (ordem.maquina.isNotEmpty) ...[
                Icon(Icons.settings_rounded, size: 12, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(ordem.maquina, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
              const Spacer(),
              Text('${ordem.qtdProduzida}/${ordem.qtdTotal}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cor)),
            ]),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progresso,
                backgroundColor: Colors.grey.shade100,
                valueColor: AlwaysStoppedAnimation(
                  progresso >= 1.0 ? kGreen : cor),
                minHeight: 6)),
            if (ordem.qtdRejeitada > 0) ...[
              const SizedBox(height: 4),
              Row(children: [
                const Icon(Icons.cancel_outlined, size: 11, color: kRed),
                const SizedBox(width: 3),
                Text('${ordem.qtdRejeitada} rejeitada(s)',
                  style: const TextStyle(fontSize: 10, color: kRed)),
              ]),
            ],
          ])))));
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGETS AUXILIARES
// ─────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String valor, label;
  final Color cor;
  const _StatChip({required this.valor, required this.label, required this.cor});
  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cor.withValues(alpha: 0.3))),
      child: Column(children: [
        Text(valor, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: cor)),
        Text(label, style: TextStyle(fontSize: 9, color: cor.withValues(alpha: 0.8), letterSpacing: 0.5)),
      ])));
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final IconData icone;
  final Color cor;
  const _InfoPill({required this.label, required this.icone, required this.cor});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: cor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(8)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icone, size: 13, color: cor),
      const SizedBox(width: 5),
      Text(label, style: TextStyle(fontSize: 11, color: cor, fontWeight: FontWeight.w600)),
    ]));
}

class _BtnAcao extends StatelessWidget {
  final String label;
  final IconData icone;
  final Color cor;
  final VoidCallback onTap;
  const _BtnAcao({required this.label, required this.icone, required this.cor, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(color: cor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cor.withValues(alpha: 0.4))),
      child: Column(children: [
        Icon(icone, color: cor, size: 20),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: cor)),
      ])));
}

class _Campo extends StatelessWidget {
  final TextEditingController ctrl;
  final String label, hint;
  final TextInputType tipo;
  const _Campo({required this.ctrl, required this.label, required this.hint,
    this.tipo = TextInputType.text});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey)),
      const SizedBox(height: 4),
      TextField(
        controller: ctrl, keyboardType: tipo,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade300, fontSize: 12),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade200)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: kBlue)))),
    ]));
}
