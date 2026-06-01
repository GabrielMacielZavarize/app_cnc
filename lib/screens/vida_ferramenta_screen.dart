import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants.dart';

// ─────────────────────────────────────────
// VIDA DA FERRAMENTA — Screen
// ─────────────────────────────────────────

enum StatusFerramenta { ok, atencao, trocar }

class FeramentaItem {
  String id;
  String nome;
  String tipo;
  double diametro;
  int numDentes;
  String material; // HSS, Carbide, CBN, Cerâmica
  String fabricante;
  int vidaMaxPecas;
  int vidaMaxMinutos;
  int pecasFeitas;
  int minutosUsados;
  String observacoes;
  DateTime ultimaUso;
  bool ativa;
  int alertaPct; // alerta em % da vida (default 80%)

  FeramentaItem({
    required this.id,
    required this.nome,
    required this.tipo,
    required this.diametro,
    required this.numDentes,
    required this.material,
    required this.fabricante,
    required this.vidaMaxPecas,
    required this.vidaMaxMinutos,
    required this.pecasFeitas,
    required this.minutosUsados,
    required this.observacoes,
    required this.ultimaUso,
    required this.ativa,
    required this.alertaPct,
  });

  double get pctPecas => vidaMaxPecas > 0 ? (pecasFeitas / vidaMaxPecas).clamp(0.0, 1.0) : 0;
  double get pctMinutos => vidaMaxMinutos > 0 ? (minutosUsados / vidaMaxMinutos).clamp(0.0, 1.0) : 0;
  double get pctGeral => math.max(pctPecas, pctMinutos);

  StatusFerramenta get status {
    if (pctGeral >= 1.0) return StatusFerramenta.trocar;
    if (pctGeral >= alertaPct / 100.0) return StatusFerramenta.atencao;
    return StatusFerramenta.ok;
  }

  Color get cor {
    switch (status) {
      case StatusFerramenta.ok: return kGreen;
      case StatusFerramenta.atencao: return kAmber;
      case StatusFerramenta.trocar: return kRed;
    }
  }

  String get statusLabel {
    switch (status) {
      case StatusFerramenta.ok: return 'OK';
      case StatusFerramenta.atencao: return 'ATENÇÃO';
      case StatusFerramenta.trocar: return 'TROCAR';
    }
  }

  String get tipoIcon {
    if (tipo.contains('Fresa')) return '🔵';
    if (tipo.contains('Broca')) return '🔩';
    if (tipo.contains('Inserto')) return '🔶';
    if (tipo.contains('Macho')) return '🔧';
    if (tipo.contains('Alarg')) return '⭕';
    return '⚙️';
  }
}

// ─── Dados de exemplo ─────────────────────────────────────
List<FeramentaItem> _ferramentas = [
  FeramentaItem(
    id: '001', nome: 'Fresa Topo Ø10mm 4F', tipo: 'Fresa de Topo',
    diametro: 10, numDentes: 4, material: 'Carbide', fabricante: 'Sandvik',
    vidaMaxPecas: 500, vidaMaxMinutos: 300, pecasFeitas: 420, minutosUsados: 250,
    observacoes: 'Usar para aço 1020 — Vc=150 fz=0.04', ultimaUso: DateTime.now().subtract(const Duration(hours: 2)),
    ativa: true, alertaPct: 80,
  ),
  FeramentaItem(
    id: '002', nome: 'Broca Ø8mm HSS', tipo: 'Broca',
    diametro: 8, numDentes: 2, material: 'HSS', fabricante: 'Dormer',
    vidaMaxPecas: 200, vidaMaxMinutos: 120, pecasFeitas: 45, minutosUsados: 30,
    observacoes: 'Furação em alumínio — N=2200rpm', ultimaUso: DateTime.now().subtract(const Duration(days: 1)),
    ativa: true, alertaPct: 80,
  ),
  FeramentaItem(
    id: '003', nome: 'Inserto CNMG 120408', tipo: 'Inserto Torno',
    diametro: 0, numDentes: 1, material: 'Carbide', fabricante: 'Iscar',
    vidaMaxPecas: 300, vidaMaxMinutos: 180, pecasFeitas: 300, minutosUsados: 185,
    observacoes: 'CNMG para acabamento inox — vida esgotada!', ultimaUso: DateTime.now().subtract(const Duration(hours: 8)),
    ativa: true, alertaPct: 80,
  ),
  FeramentaItem(
    id: '004', nome: 'Macho M8 x 1.25 Rígido', tipo: 'Macho',
    diametro: 8, numDentes: 4, material: 'HSS-Co', fabricante: 'Gühring',
    vidaMaxPecas: 400, vidaMaxMinutos: 200, pecasFeitas: 120, minutosUsados: 60,
    observacoes: 'Rosqueamento rígido G84 — aço', ultimaUso: DateTime.now().subtract(const Duration(days: 3)),
    ativa: true, alertaPct: 75,
  ),
];

// ─────────────────────────────────────────
class VidaFerramentaScreen extends StatefulWidget {
  const VidaFerramentaScreen({super.key});
  @override
  State<VidaFerramentaScreen> createState() => _VidaFerramentaScreenState();
}

class _VidaFerramentaScreenState extends State<VidaFerramentaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _filtro = 'Todas';

  final _filtros = ['Todas', 'OK', 'ATENÇÃO', 'TROCAR'];

  @override
  void initState() { super.initState(); _tab = TabController(length: 2, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  List<FeramentaItem> get _filtradas {
    if (_filtro == 'Todas') return _ferramentas;
    return _ferramentas.where((f) => f.statusLabel == _filtro).toList();
  }

  int get _totalTrocar => _ferramentas.where((f) => f.status == StatusFerramenta.trocar).length;
  int get _totalAtencao => _ferramentas.where((f) => f.status == StatusFerramenta.atencao).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Vida da Ferramenta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: kDark,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddFerramenta,
            tooltip: 'Nova ferramenta',
          ),
        ],
        bottom: TabBar(
          controller: _tab,
          indicatorColor: kAmber,
          labelColor: kAmber,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: '🔧 Ferramentas'),
            Tab(text: '📊 Visão Geral'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildListagem(),
          _buildVisaoGeral(),
        ],
      ),
    );
  }

  // ─── ABA 1: Listagem ───────────────────────────────────────
  Widget _buildListagem() {
    return Column(children: [
      // Alertas no topo
      if (_totalTrocar > 0 || _totalAtencao > 0)
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _totalTrocar > 0 ? kRed.withOpacity(0.1) : kAmber.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _totalTrocar > 0 ? kRed : kAmber),
          ),
          child: Row(children: [
            Icon(_totalTrocar > 0 ? Icons.warning_rounded : Icons.info_rounded,
              color: _totalTrocar > 0 ? kRed : kAmber),
            const SizedBox(width: 10),
            Expanded(child: Text(
              _totalTrocar > 0
                ? '$_totalTrocar ferramenta(s) precisa(m) ser TROCADA(S)!'
                : '$_totalAtencao ferramenta(s) com vida próxima do limite.',
              style: TextStyle(
                color: _totalTrocar > 0 ? kRed : kAmber,
                fontWeight: FontWeight.bold,
              ),
            )),
          ]),
        ),

      // Filtros
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: _filtros.map((f) {
            final sel = f == _filtro;
            Color corFiltro;
            switch (f) {
              case 'TROCAR': corFiltro = kRed; break;
              case 'ATENÇÃO': corFiltro = kAmber; break;
              case 'OK': corFiltro = kGreen; break;
              default: corFiltro = kDark;
            }
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(f),
                selected: sel,
                onSelected: (_) => setState(() => _filtro = f),
                selectedColor: corFiltro,
                labelStyle: TextStyle(color: sel ? Colors.white : kDark, fontWeight: FontWeight.w600, fontSize: 12),
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),

      // Lista
      Expanded(
        child: _filtradas.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.check_circle, color: kGreen, size: 64),
              const SizedBox(height: 12),
              Text('Nenhuma ferramenta nessa categoria', style: TextStyle(color: Colors.grey[600])),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _filtradas.length,
              itemBuilder: (ctx, i) => _buildFerCard(_filtradas[i]),
            ),
      ),
    ]);
  }

  Widget _buildFerCard(FeramentaItem f) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showFerDetalhe(f),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(f.tipoIcon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(f.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('${f.material} — ${f.fabricante}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: f.cor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(f.statusLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ]),
            const SizedBox(height: 12),

            // Barra de vida — Peças
            if (f.vidaMaxPecas > 0) ...[
              Row(children: [
                const SizedBox(width: 4),
                Text('Peças: ${f.pecasFeitas} / ${f.vidaMaxPecas}', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                const Spacer(),
                Text('${(f.pctPecas * 100).round()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: f.cor)),
              ]),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: f.pctPecas,
                  backgroundColor: f.cor.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation(f.cor),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Barra de vida — Minutos
            if (f.vidaMaxMinutos > 0) ...[
              Row(children: [
                const SizedBox(width: 4),
                Text('Tempo: ${f.minutosUsados} / ${f.vidaMaxMinutos} min', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                const Spacer(),
                Text('${(f.pctMinutos * 100).round()}%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: f.cor)),
              ]),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: f.pctMinutos,
                  backgroundColor: f.cor.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation(f.cor),
                  minHeight: 8,
                ),
              ),
            ],

            const SizedBox(height: 10),
            Row(children: [
              _quickBtn(Icons.add_circle_outline, 'Registrar uso', f.cor, () => _registrarUso(f)),
              const SizedBox(width: 8),
              _quickBtn(Icons.refresh, 'Resetar', Colors.grey, () => _resetarFerramenta(f)),
              const Spacer(),
              Text('Último: ${_horasAtras(f.ultimaUso)}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _quickBtn(IconData icon, String label, Color cor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cor.withOpacity(0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: cor, size: 14),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: cor, fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  String _horasAtras(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}min atrás';
    if (diff.inHours < 24) return '${diff.inHours}h atrás';
    return '${diff.inDays}d atrás';
  }

  // ─── Registrar uso ───────────────────────────────────────
  void _registrarUso(FeramentaItem f) {
    int pecas = 1;
    int minutos = 5;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: Text('Registrar uso — ${f.nome}'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Quantas peças foram produzidas?'),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () { if (pecas > 0) setS(() => pecas--); }),
              Text('$pecas', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setS(() => pecas++)),
            ]),
            const SizedBox(height: 8),
            const Text('Tempo de corte (min):'),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () { if (minutos > 0) setS(() => minutos -= 5); }),
              Text('$minutos', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => setS(() => minutos += 5)),
            ]),
          ]),
          actions: [
            TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(ctx)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kDark),
              child: const Text('Confirmar', style: TextStyle(color: Colors.white)),
              onPressed: () {
                setState(() {
                  f.pecasFeitas += pecas;
                  f.minutosUsados += minutos;
                  f.ultimaUso = DateTime.now();
                });
                Navigator.pop(ctx);
                if (f.status == StatusFerramenta.trocar) {
                  _showAlertaTroca(f);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertaTroca(FeramentaItem f) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Row(children: [
          Icon(Icons.warning_rounded, color: kRed, size: 28),
          SizedBox(width: 8),
          Text('Trocar Ferramenta!', style: TextStyle(color: kRed)),
        ]),
        content: Text('A ferramenta "${f.nome}" atingiu o limite de vida!\n\nSubstitua antes de continuar para evitar quebra, rejeito de peças e danos à máquina.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Entendido — vou trocar'),
            style: ElevatedButton.styleFrom(backgroundColor: kRed, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // ─── Resetar ferramenta ───────────────────────────────────
  void _resetarFerramenta(FeramentaItem f) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Resetar vida?'),
        content: Text('Isso zerará o contador de "${f.nome}".\nFaça isso apenas ao colocar uma ferramenta nova.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kGreen),
            child: const Text('Resetar', style: TextStyle(color: Colors.white)),
            onPressed: () {
              setState(() {
                f.pecasFeitas = 0;
                f.minutosUsados = 0;
                f.ultimaUso = DateTime.now();
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ─── Detalhe da ferramenta ───────────────────────────────
  void _showFerDetalhe(FeramentaItem f) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(children: [
              Text(f.tipoIcon, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(f.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('${f.tipo} — ${f.material}', style: TextStyle(color: Colors.grey[600])),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: f.cor, borderRadius: BorderRadius.circular(10)),
                child: Text(f.statusLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ]),
            const Divider(height: 24),
            _linhaDetalhe('Fabricante', f.fabricante),
            _linhaDetalhe('Diâmetro', f.diametro > 0 ? '${f.diametro} mm' : '—'),
            _linhaDetalhe('Nº de dentes', '${f.numDentes}'),
            _linhaDetalhe('Peças feitas', '${f.pecasFeitas} / ${f.vidaMaxPecas}'),
            _linhaDetalhe('Tempo usado', '${f.minutosUsados} / ${f.vidaMaxMinutos} min'),
            _linhaDetalhe('Último uso', _horasAtras(f.ultimaUso)),
            if (f.observacoes.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('Observações:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kAmber.withOpacity(0.4)),
                ),
                child: Text(f.observacoes, style: const TextStyle(fontSize: 13)),
              ),
            ],
            const SizedBox(height: 16),
            // Indicador de vida circular
            Center(child: _buildVidaCircular(f)),
          ]),
        ),
      ),
    );
  }

  Widget _buildVidaCircular(FeramentaItem f) {
    final pct = f.pctGeral;
    return SizedBox(
      width: 160, height: 160,
      child: Stack(
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: pct,
              strokeWidth: 14,
              backgroundColor: f.cor.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(f.cor),
              strokeCap: StrokeCap.round,
            ),
          ),
          Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('${(pct * 100).round()}%', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: f.cor)),
            Text('vida usada', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ])),
        ],
      ),
    );
  }

  Widget _linhaDetalhe(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        SizedBox(width: 110, child: Text(label, style: const TextStyle(color: Colors.grey))),
        Text(val, style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }

  // ─── ABA 2: Visão Geral ────────────────────────────────────
  Widget _buildVisaoGeral() {
    final ok = _ferramentas.where((f) => f.status == StatusFerramenta.ok).length;
    final atencao = _ferramentas.where((f) => f.status == StatusFerramenta.atencao).length;
    final trocar = _ferramentas.where((f) => f.status == StatusFerramenta.trocar).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Cards de resumo
        Row(children: [
          _summaryCard('OK', ok, kGreen, Icons.check_circle),
          const SizedBox(width: 10),
          _summaryCard('ATENÇÃO', atencao, kAmber, Icons.warning_rounded),
          const SizedBox(width: 10),
          _summaryCard('TROCAR', trocar, kRed, Icons.cancel),
        ]),
        const SizedBox(height: 20),

        // Lista resumida de status
        const Text('Status por Ferramenta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        ..._ferramentas.map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(children: [
            Text(f.tipoIcon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(f.nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: f.pctGeral,
                  backgroundColor: f.cor.withOpacity(0.15),
                  valueColor: AlwaysStoppedAnimation(f.cor),
                  minHeight: 8,
                ),
              ),
            ])),
            const SizedBox(width: 10),
            SizedBox(
              width: 56,
              child: Text('${(f.pctGeral * 100).round()}%',
                style: TextStyle(fontWeight: FontWeight.bold, color: f.cor, fontSize: 13),
                textAlign: TextAlign.right),
            ),
          ]),
        )),
        const SizedBox(height: 20),

        // Dica
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: kBlue.withOpacity(0.3)),
          ),
          child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('💡', style: TextStyle(fontSize: 20)),
            SizedBox(width: 10),
            Expanded(child: Text(
              'Configure o limite de alerta em 75–80% para ter tempo de preparar a ferramenta reserva antes da troca urgente. Monitore sempre o Rz da peça — é o primeiro sinal de desgaste.',
              style: TextStyle(fontSize: 13, height: 1.4),
            )),
          ]),
        ),
      ]),
    );
  }

  Widget _summaryCard(String label, int count, Color cor, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cor.withOpacity(0.4)),
        ),
        child: Column(children: [
          Icon(icon, color: cor, size: 28),
          const SizedBox(height: 6),
          Text('$count', style: TextStyle(fontWeight: FontWeight.bold, color: cor, fontSize: 24)),
          Text(label, style: TextStyle(color: cor, fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  // ─── Adicionar nova ferramenta ───────────────────────────
  void _showAddFerramenta() {
    final nomeCtrl = TextEditingController();
    final fabCtrl = TextEditingController();
    final diamCtrl = TextEditingController();
    final vidaPecasCtrl = TextEditingController(text: '300');
    final vidaMinCtrl = TextEditingController(text: '180');
    String tipoSel = 'Fresa de Topo';
    String matSel = 'Carbide';

    final tipos = ['Fresa de Topo', 'Fresa de Face', 'Broca', 'Inserto Torno', 'Macho', 'Alargador', 'Rebolo'];
    final materiais = ['Carbide', 'HSS', 'HSS-Co', 'CBN', 'Cerâmica', 'Diamante'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, left: 20, right: 20, top: 20),
        child: StatefulBuilder(
          builder: (ctx2, setS) => Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Nova Ferramenta', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 14),
            _inputField(nomeCtrl, 'Nome / Descrição', 'Ex: Fresa Topo Ø10mm 4F'),
            const SizedBox(height: 10),
            _inputField(fabCtrl, 'Fabricante', 'Ex: Sandvik'),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _inputField(diamCtrl, 'Diâmetro (mm)', '0')),
              const SizedBox(width: 10),
              Expanded(child: _dropField('Tipo', tipoSel, tipos, (v) => setS(() => tipoSel = v!))),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _inputField(vidaPecasCtrl, 'Vida (peças)', '300')),
              const SizedBox(width: 10),
              Expanded(child: _inputField(vidaMinCtrl, 'Vida (min)', '180')),
            ]),
            const SizedBox(height: 10),
            _dropField('Material', matSel, materiais, (v) => setS(() => matSel = v!)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Ferramenta'),
                style: ElevatedButton.styleFrom(backgroundColor: kDark, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  if (nomeCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _ferramentas.add(FeramentaItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      nome: nomeCtrl.text.trim(),
                      tipo: tipoSel,
                      diametro: double.tryParse(diamCtrl.text) ?? 0,
                      numDentes: 4,
                      material: matSel,
                      fabricante: fabCtrl.text.trim(),
                      vidaMaxPecas: int.tryParse(vidaPecasCtrl.text) ?? 300,
                      vidaMaxMinutos: int.tryParse(vidaMinCtrl.text) ?? 180,
                      pecasFeitas: 0, minutosUsados: 0,
                      observacoes: '',
                      ultimaUso: DateTime.now(),
                      ativa: true, alertaPct: 80,
                    ));
                  });
                  Navigator.pop(ctx);
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _inputField(TextEditingController ctrl, String label, String hint) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label, hintText: hint,
        filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        labelStyle: const TextStyle(fontSize: 12),
      ),
      style: const TextStyle(fontSize: 13),
    );
  }

  Widget _dropField(String label, String val, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: val,
      decoration: InputDecoration(
        labelText: label,
        filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        labelStyle: const TextStyle(fontSize: 12),
      ),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 12)))).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }
}
