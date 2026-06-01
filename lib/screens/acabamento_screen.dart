import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants.dart';

// ─────────────────────────────────────────
// ACABAMENTO SUPERFICIAL — Ra / Rz / N
// ─────────────────────────────────────────

class _GrauAcabamento {
  final String n;       // N1..N12
  final double raMin;
  final double raMax;
  final double rzTip;   // Rz típico
  final String descricao;
  final List<String> processos;
  final Color cor;
  const _GrauAcabamento(this.n, this.raMin, this.raMax, this.rzTip, this.descricao, this.processos, this.cor);
}

const _graus = [
  _GrauAcabamento('N1', 0.012, 0.025, 0.1, 'Super-espelho', ['Lapidação especial', 'Superacabamento'], Color(0xFF1A237E)),
  _GrauAcabamento('N2', 0.025, 0.05, 0.2, 'Espelho fino', ['Lapidação fina', 'Brunimento fino', 'Retífica especial'], Color(0xFF283593)),
  _GrauAcabamento('N3', 0.05, 0.1, 0.4, 'Espelho', ['Retífica cilíndrica fina', 'Lapidação', 'Superacabamento'], Color(0xFF1565C0)),
  _GrauAcabamento('N4', 0.1, 0.2, 0.8, 'Muito fino', ['Retífica plana fina', 'Torno fino', 'Brunimento'], Color(0xFF0277BD)),
  _GrauAcabamento('N5', 0.2, 0.4, 1.6, 'Fino', ['Retífica plana', 'Torno preciso', 'Fresamento fino'], Color(0xFF006064)),
  _GrauAcabamento('N6', 0.4, 0.8, 3.2, 'Semi-fino', ['Torno normal', 'Fresamento normal', 'Retífica grosseira'], Color(0xFF00695C)),
  _GrauAcabamento('N7', 0.8, 1.6, 6.3, 'Médio', ['Torno desbaste leve', 'Fresamento', 'Plaina'], Color(0xFF2E7D32)),
  _GrauAcabamento('N8', 1.6, 3.2, 12.5, 'Normal', ['Usinagem convencional', 'Furação', 'Fresamento desbaste'], Color(0xFF558B2F)),
  _GrauAcabamento('N9', 3.2, 6.3, 25.0, 'Grosseiro', ['Desbaste geral', 'Torno desbaste', 'Serramento'], Color(0xFFF9A825)),
  _GrauAcabamento('N10', 6.3, 12.5, 50.0, 'Muito grosseiro', ['Serramento a frio', 'Limalha manual'], Color(0xFFE65100)),
  _GrauAcabamento('N11', 12.5, 25.0, 100.0, 'Extremamente grosseiro', ['Fundição bruta', 'Forjamento'], Color(0xFFBF360C)),
  _GrauAcabamento('N12', 25.0, 50.0, 200.0, 'Bruto / sem usinagem', ['Fundição em areia', 'Laminação a quente'], Color(0xFF880E4F)),
];

// ─── Dados de rugosidade por processo de fabricação ───────────
class _Processo {
  final String nome;
  final String categoria;
  final double raMin;
  final double raMax;
  final String nMin;
  final String nMax;
  final String observacao;
  final IconData icone;
  const _Processo(this.nome, this.categoria, this.raMin, this.raMax, this.nMin, this.nMax, this.observacao, this.icone);
}

const _processos = [
  // Retificação
  _Processo('Retífica Plana', 'Retificação', 0.1, 1.6, 'N4', 'N6', 'Acabamento fino a grosseiro conforme rebolo e passe', Icons.rotate_right),
  _Processo('Retífica Cilíndrica', 'Retificação', 0.05, 0.8, 'N3', 'N6', 'Excelente para eixos e peças de revolução', Icons.rotate_right),
  _Processo('Retífica Sem Centro', 'Retificação', 0.1, 1.6, 'N4', 'N6', 'Peças cilíndricas longas e de pequeno diâmetro', Icons.rotate_right),
  // Torneamento
  _Processo('Torneamento Fino', 'Torneamento', 0.4, 1.6, 'N6', 'N7', 'Inserto CBN, velocidades altas', Icons.settings),
  _Processo('Torneamento Normal', 'Torneamento', 1.6, 6.3, 'N7', 'N9', 'Operação padrão de torno CNC', Icons.settings),
  _Processo('Torneamento Desbaste', 'Torneamento', 3.2, 12.5, 'N9', 'N10', 'Remoção rápida de material', Icons.settings),
  // Fresamento
  _Processo('Fresamento Fino (topo plano)', 'Fresamento', 0.4, 3.2, 'N6', 'N8', 'Passe de acabamento com fresa de topo', Icons.view_module),
  _Processo('Fresamento Face', 'Fresamento', 0.8, 3.2, 'N6', 'N8', 'Bom Ra em face quando feed baixo', Icons.view_module),
  _Processo('Fresamento Desbaste', 'Fresamento', 3.2, 12.5, 'N9', 'N10', 'Remoção de material em desbaste', Icons.view_module),
  // Furação
  _Processo('Furação Convencional', 'Furação', 3.2, 12.5, 'N9', 'N10', 'Broca helicoidal padrão', Icons.hardware),
  _Processo('Furação com Alargador', 'Furação', 0.4, 1.6, 'N6', 'N7', 'Excelente para furos de precisão', Icons.hardware),
  _Processo('Furação com Mandrilamento', 'Furação', 0.1, 0.8, 'N4', 'N6', 'Mandrilador de linha fina/bore', Icons.hardware),
  // Processos Especiais
  _Processo('Lapidação (Lapping)', 'Especial', 0.012, 0.1, 'N1', 'N4', 'Superfícies de vedação, instrumentos', Icons.auto_awesome),
  _Processo('Brunimento (Honing)', 'Especial', 0.05, 0.4, 'N3', 'N6', 'Paredes de cilindros, furos de precisão', Icons.auto_awesome),
  _Processo('Superacabamento', 'Especial', 0.012, 0.2, 'N1', 'N4', 'Rolamentos, selos, pinos de pistão', Icons.auto_awesome),
  _Processo('Polimento manual', 'Especial', 0.1, 1.6, 'N4', 'N6', 'Moldes e matrizes', Icons.auto_awesome),
  // Outros
  _Processo('Fundição em Areia', 'Fundição', 12.5, 50.0, 'N11', 'N12', 'Peças fundidas brutas', Icons.factory),
  _Processo('Fundição em Coquilha', 'Fundição', 1.6, 6.3, 'N7', 'N9', 'Melhor acabamento que areia', Icons.factory),
  _Processo('Injeção Plástica', 'Plástico', 0.2, 3.2, 'N5', 'N8', 'Depende do acabamento do molde', Icons.view_quilt),
  _Processo('Eletroestimulação EDM', 'Especial', 0.4, 6.3, 'N6', 'N9', 'Depende da energia de descarga', Icons.bolt),
];

// ─── Comparador visual Ra ──────────────────────────────────
class _CompRa {
  final String nome;
  final double ra;
  final String nGrau;
  const _CompRa(this.nome, this.ra, this.nGrau);
}

const _exemplos = [
  _CompRa('Espelho óptico', 0.012, 'N1'),
  _CompRa('Rolamento de esfera', 0.05, 'N3'),
  _CompRa('Eixo retificado', 0.2, 'N5'),
  _CompRa('Torno fino / rasqueado', 0.4, 'N6'),
  _CompRa('Usinagem normal CNC', 1.6, 'N7'),
  _CompRa('Furação c/ broca HSS', 3.2, 'N8'),
  _CompRa('Serramento / escariamento', 6.3, 'N9'),
  _CompRa('Fundição em coquilha', 12.5, 'N10'),
  _CompRa('Fundição em areia', 25.0, 'N11'),
  _CompRa('Laminado a quente', 50.0, 'N12'),
];

// ─────────────────────────────────────────
class AcabamentoScreen extends StatefulWidget {
  const AcabamentoScreen({super.key});
  @override
  State<AcabamentoScreen> createState() => _AcabamentoScreenState();
}

class _AcabamentoScreenState extends State<AcabamentoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _filtroCategoria = 'Todos';
  double _raConsulta = 1.6;
  final _raCtrl = TextEditingController(text: '1.6');

  final _categorias = ['Todos', 'Retificação', 'Torneamento', 'Fresamento', 'Furação', 'Especial', 'Fundição', 'Plástico'];

  @override
  void initState() { super.initState(); _tab = TabController(length: 4, vsync: this); }
  @override
  void dispose() { _tab.dispose(); _raCtrl.dispose(); super.dispose(); }

  _GrauAcabamento _grauDeRa(double ra) {
    for (final g in _graus) {
      if (ra <= g.raMax) return g;
    }
    return _graus.last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Acabamento Superficial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: kDark,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tab,
          indicatorColor: kAmber,
          labelColor: kAmber,
          unselectedLabelColor: Colors.white70,
          isScrollable: true,
          tabs: const [
            Tab(text: '🔎 Consultar Ra'),
            Tab(text: '📊 Tabela N1-N12'),
            Tab(text: '⚙️ Por Processo'),
            Tab(text: '📐 Comparativo'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildConsultar(),
          _buildTabelaN(),
          _buildPorProcesso(),
          _buildComparativo(),
        ],
      ),
    );
  }

  // ─── ABA 1: Consultar Ra ──────────────────────────────────
  Widget _buildConsultar() {
    final grau = _grauDeRa(_raConsulta);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Digite o valor de Ra (µm):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        TextField(
          controller: _raCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Ex: 1.6',
            suffixText: 'µm Ra',
            filled: true, fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
          onChanged: (v) {
            final d = double.tryParse(v);
            if (d != null && d > 0) setState(() => _raConsulta = d);
          },
        ),
        const SizedBox(height: 8),
        // Slider
        Slider(
          value: _raConsulta.clamp(0.012, 50.0),
          min: 0.012, max: 50.0,
          activeColor: grau.cor,
          onChanged: (v) {
            setState(() {
              _raConsulta = double.parse(v.toStringAsFixed(3));
              _raCtrl.text = _raConsulta.toString();
            });
          },
        ),
        const SizedBox(height: 16),
        // Card resultado
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: grau.cor,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [BoxShadow(color: grau.cor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Column(children: [
            Text(grau.n, style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
            Text(grau.descricao, style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _raChip('Ra mín', '${grau.raMin} µm'),
              _raChip('Ra máx', '${grau.raMax} µm'),
              _raChip('Rz típico', '${grau.rzTip} µm'),
            ]),
          ]),
        ),
        const SizedBox(height: 20),
        // Processos que atingem esse grau
        const Text('Processos que atingem esse grau:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        ...grau.processos.map((p) => Card(
          margin: const EdgeInsets.only(bottom: 6),
          child: ListTile(
            leading: Icon(Icons.check_circle, color: grau.cor),
            title: Text(p, style: const TextStyle(fontSize: 14)),
            dense: true,
          ),
        )),
        const SizedBox(height: 16),
        // Escala visual
        _buildEscalaVisual(_raConsulta),
        const SizedBox(height: 16),
        // Símbolos de desenho técnico
        _buildSimbolos(grau),
      ]),
    );
  }

  Widget _raChip(String label, String val) {
    return Column(children: [
      Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
    ]);
  }

  Widget _buildEscalaVisual(double raAtual) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Posição na Escala de Rugosidade:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      const SizedBox(height: 8),
      Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(colors: [Color(0xFF1A237E), Color(0xFF2E7D32), Color(0xFFF9A825), Color(0xFF880E4F)]),
        ),
        child: Stack(children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['N1', 'N3', 'N6', 'N9', 'N12'].map((n) =>
                Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(n, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)))).toList(),
            ),
          ),
          // Marcador da posição atual
          Positioned(
            left: (log(raAtual.clamp(0.012, 50.0)) - log(0.012)) / (log(50.0) - log(0.012)) *
                (MediaQuery.of(context).size.width - 64),
            top: 5,
            child: Container(
              width: 3, height: 30,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 4)]),
            ),
          ),
        ]),
      ),
    ]);
  }

  Widget _buildSimbolos(_GrauAcabamento grau) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Símbolo em Desenho Técnico (ISO 1302)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 12),
        Row(children: [
          Container(
            width: 70, height: 70,
            child: CustomPaint(painter: _SimboloAcabPainter(grau.raMax, grau.cor)),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Ra máx: ${grau.raMax} µm', style: TextStyle(fontWeight: FontWeight.bold, color: grau.cor)),
            Text('Grau: ${grau.n}', style: TextStyle(color: grau.cor)),
            const SizedBox(height: 4),
            Text('O símbolo ✓ indica superfície usinada com Ra máximo especificado.',
              style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ])),
        ]),
      ]),
    );
  }

  // ─── ABA 2: Tabela N1–N12 ────────────────────────────────
  Widget _buildTabelaN() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _graus.length,
      itemBuilder: (ctx, i) {
        final g = _graus[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showGrauDetalhe(g),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(color: g.cor, shape: BoxShape.circle),
                  child: Center(child: Text(g.n, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(g.descricao, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('Ra: ${g.raMin}–${g.raMax} µm  |  Rz ≈ ${g.rzTip} µm',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ])),
                // Barra visual Ra
                Container(
                  width: 60,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('${g.raMax} µm', style: TextStyle(fontSize: 10, color: g.cor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: (log(g.raMax + 0.001) - log(0.012)) / (log(50.1) - log(0.012)),
                      backgroundColor: g.cor.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation(g.cor),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ]),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ]),
            ),
          ),
        );
      },
    );
  }

  void _showGrauDetalhe(_GrauAcabamento g) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),
            Row(children: [
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: g.cor, shape: BoxShape.circle),
                child: Center(child: Text(g.n, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
              ),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(g.descricao, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text('Ra: ${g.raMin}–${g.raMax} µm', style: TextStyle(color: g.cor)),
              ]),
            ]),
            const Divider(height: 24),
            _infoRow('Ra mínimo', '${g.raMin} µm', g.cor),
            _infoRow('Ra máximo', '${g.raMax} µm', g.cor),
            _infoRow('Rz típico', '${g.rzTip} µm', g.cor),
            const SizedBox(height: 14),
            const Text('Processos que atingem:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...g.processos.map((p) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(children: [
                Icon(Icons.fiber_manual_record, size: 8, color: g.cor),
                const SizedBox(width: 8),
                Text(p, style: const TextStyle(fontSize: 13)),
              ]),
            )),
          ]),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String val, Color cor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 100, child: Text(label, style: const TextStyle(color: Colors.grey))),
        Text(val, style: TextStyle(fontWeight: FontWeight.bold, color: cor, fontSize: 15)),
      ]),
    );
  }

  // ─── ABA 3: Por Processo ─────────────────────────────────
  Widget _buildPorProcesso() {
    final filtrados = _filtroCategoria == 'Todos'
        ? _processos
        : _processos.where((p) => p.categoria == _filtroCategoria).toList();

    return Column(children: [
      // Filtro
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: _categorias.map((c) {
            final sel = c == _filtroCategoria;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(c),
                selected: sel,
                onSelected: (_) => setState(() => _filtroCategoria = c),
                selectedColor: kDark,
                labelStyle: TextStyle(color: sel ? Colors.white : kDark, fontWeight: FontWeight.w600),
                backgroundColor: Colors.white,
                checkmarkColor: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: filtrados.length,
          itemBuilder: (ctx, i) {
            final p = filtrados[i];
            final corN = _grauDeRa(p.raMin).cor;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: corN.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                    child: Icon(p.icone, color: corN, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.nome, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 3),
                    Row(children: [
                      _tagN(p.nMin, corN),
                      const Text(' — ', style: TextStyle(color: Colors.grey)),
                      _tagN(p.nMax, _grauDeRa(p.raMax).cor),
                      const SizedBox(width: 8),
                      Text('Ra ${p.raMin}–${p.raMax} µm', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                    ]),
                    const SizedBox(height: 4),
                    Text(p.observacao, style: TextStyle(color: Colors.grey[600], fontSize: 11, fontStyle: FontStyle.italic)),
                  ])),
                ]),
              ),
            );
          },
        ),
      ),
    ]);
  }

  Widget _tagN(String n, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(4)),
      child: Text(n, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  // ─── ABA 4: Comparativo Visual ───────────────────────────
  Widget _buildComparativo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Referências do Mundo Real', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text('Compare o Ra com exemplos práticos', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 12),
        ..._exemplos.map((e) {
          final grau = _grauDeRa(e.ra);
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(color: grau.cor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  child: Center(child: Text(e.nGrau, style: TextStyle(color: grau.cor, fontWeight: FontWeight.bold, fontSize: 12))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(e.nome, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text('Ra ${e.ra} µm', style: TextStyle(fontWeight: FontWeight.bold, color: grau.cor, fontSize: 13)),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 80,
                    child: LinearProgressIndicator(
                      value: (log(e.ra + 0.001) - log(0.012)) / (log(50.1) - log(0.012)),
                      backgroundColor: grau.cor.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation(grau.cor),
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ]),
              ]),
            ),
          );
        }),
        const SizedBox(height: 16),
        _buildRelacaoRaRz(),
      ]),
    );
  }

  Widget _buildRelacaoRaRz() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Relação Ra × Rz × Rmax', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        const Text('Para a maioria dos processos de usinagem:\n• Rz ≈ 4 × Ra\n• Rmax ≈ 6 × Ra\n\nEssas relações variam com o tipo de processo (retificação ≈ 5×, torneamento ≈ 4×, lapidação ≈ 3×).',
          style: TextStyle(fontSize: 13, height: 1.5)),
        const SizedBox(height: 12),
        const Text('Parâmetros Ra vs Rz:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        const Text('• Ra (média aritmética): mais usado globalmente, presente em todos os desenhos técnicos\n• Rz (altura média dos 5 maiores picos-vales): mais sensível a defeitos pontuais\n• Rmax (pico a vale máximo): usado em vedações e contatos críticos',
          style: TextStyle(fontSize: 12, height: 1.5, color: Colors.black87)),
      ]),
    );
  }
}

// ─── Painter do símbolo de acabamento ─────────────────────
class _SimboloAcabPainter extends CustomPainter {
  final double ra;
  final Color cor;
  _SimboloAcabPainter(this.ra, this.cor);

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = cor..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round;
    final cx = size.width * 0.5;
    final by = size.height * 0.85;
    // Linha horizontal da superfície
    canvas.drawLine(Offset(cx * 0.2, by), Offset(size.width * 0.95, by), p..strokeWidth = 1.5);
    // Símbolo V (usinado)
    final path = Path();
    path.moveTo(cx * 0.4, by * 0.3);
    path.lineTo(cx * 0.7, by);
    path.lineTo(cx * 1.0, by * 0.5);
    canvas.drawPath(path, p..strokeWidth = 2);
    // Texto Ra
    final tp = TextPainter(
      text: TextSpan(text: '$ra', style: TextStyle(color: cor, fontSize: 10, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx * 0.95, by * 0.1));
  }

  @override
  bool shouldRepaint(_SimboloAcabPainter old) => ra != old.ra;
}

double log(double x) => x > 0 ? math.log(x) : -10;
