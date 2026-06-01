import 'dart:math';
import 'package:flutter/material.dart';
import '../constants.dart';

// ─────────────────────────────────────────
// TOLERÂNCIAS ISO — SCREEN
// ─────────────────────────────────────────

class ToleranciaISO {
  final String campo;
  final String descricao;
  final String tipo; // 'furo' ou 'eixo'
  final Color cor;
  const ToleranciaISO(this.campo, this.descricao, this.tipo, this.cor);
}

// Tabela base de desvios fundamentais (µm) por letra de campo
// Valores simplificados baseados na norma ISO 286-1:2010
// Retorna: (desvio superior ES/es, desvio inferior EI/ei) em µm

class _IsoData {
  // Graus de tolerância IT (µm) para diâmetros nominais
  // IT01..IT18 — usamos IT5..IT12 que são os mais comuns
  static double it(int grade, double d) {
    // Diâmetro médio geométrico
    double dm = d; // simplificado — usa d diretamente
    // Tolerâncias IT em µm segundo ISO 286
    const List<double> coefA = [0.3, 0.5, 0.8, 1.2, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144];
    // grade 1..14 → índice 0..13
    if (grade < 1 || grade > 14) return 0;
    final a = coefA[grade - 1];
    return (a * pow(dm, 1/3) * 1000).roundToDouble() / 1000; // µm aproximado
  }

  // Retorna IT em µm para grau e diâmetro nominal (range médio)
  static double itGrade(int grade, double dMin, double dMax) {
    // Diâmetro médio geométrico do intervalo
    double dm = sqrt(dMin * dMax);
    if (dm == 0) dm = dMax;
    // Fórmula ISO: IT = i × k, onde i = 0.45∛D + 0.001D
    double i = 0.45 * pow(dm, 1/3) + 0.001 * dm; // µm
    const Map<int, double> kMap = {
      5: 7, 6: 10, 7: 16, 8: 25, 9: 40, 10: 64, 11: 100, 12: 160,
      13: 250, 14: 400, 4: 4, 3: 2.5, 2: 1.6, 1: 1,
    };
    double k = kMap[grade] ?? 10;
    return (i * k).roundToDouble();
  }
}

// ─── Intervalos de diâmetro nominais (mm) ───────────────
const List<List<double>> _intervals = [
  [0, 3], [3, 6], [6, 10], [10, 18],
  [18, 30], [30, 50], [50, 80], [80, 120],
  [120, 180], [180, 250], [250, 315], [315, 400], [400, 500],
];

// ─── Desvios fundamentais de furo (EI) em µm ─────────────
// Para furos, EI é o desvio inferior (valor mais negativo ou zero)
// Campos: H=0, G, F, E, D, JS, K, M, N, P, R, S
Map<String, List<int>> _fiEI = {
  'H': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  'G': [2, 4, 5, 6, 7, 9, 10, 12, 14, 15, 17, 18, 20],
  'F': [6, 10, 13, 16, 20, 25, 30, 36, 43, 50, 56, 62, 68],
  'E': [14, 20, 25, 32, 40, 50, 60, 72, 85, 100, 110, 125, 135],
  'D': [20, 30, 40, 50, 65, 80, 100, 120, 145, 170, 190, 210, 230],
  'JS': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // ±IT/2
};

// ─── Desvios fundamentais de eixo (es) em µm ─────────────
// Para eixos, es é o desvio superior (negativo = abaixo da linha zero)
// Campos: h=0, g, f, e, d, js, k, m, n, p, r, s
Map<String, List<int>> _esMap = {
  'h': [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  'g': [-2, -4, -5, -6, -7, -9, -10, -12, -14, -15, -17, -18, -20],
  'f': [-6, -10, -13, -16, -20, -25, -30, -36, -43, -50, -56, -62, -68],
  'e': [-14, -20, -25, -32, -40, -50, -60, -72, -85, -100, -110, -125, -135],
  'd': [-20, -30, -40, -50, -65, -80, -100, -120, -145, -170, -190, -210, -230],
  'k': [0, 1, 1, 1, 2, 2, 2, 3, 3, 4, 4, 4, 5],
  'm': [2, 4, 6, 7, 8, 9, 11, 13, 15, 17, 20, 21, 23],
  'n': [4, 8, 10, 12, 15, 17, 20, 23, 27, 31, 34, 37, 40],
  'p': [6, 12, 15, 18, 22, 26, 32, 37, 43, 50, 56, 62, 68],
  'r': [10, 15, 19, 23, 28, 34, 41, 48, 58, 68, 78, 86, 98],
  's': [14, 19, 23, 28, 35, 43, 53, 64, 79, 94, 108, 121, 133],
};

// ─── Ajustes mais comuns e suas aplicações ─────────────────
class _Ajuste {
  final String codigo;
  final String tipo;
  final String aplicacao;
  final Color cor;
  const _Ajuste(this.codigo, this.tipo, this.aplicacao, this.cor);
}

const _ajustesComuns = [
  _Ajuste('H7/h6', 'Deslizante preciso', 'Eixos-guia, punções, spindles — zero folga, montagem manual possível', Color(0xFF1565C0)),
  _Ajuste('H7/g6', 'Deslizante', 'Buchas deslizantes, mancais, guias lineares — folga mínima', Color(0xFF0277BD)),
  _Ajuste('H7/f7', 'Girante', 'Mancais de rolamento, eixos em rotação contínua com lubrificação', Color(0xFF00838F)),
  _Ajuste('H8/f7', 'Girante livre', 'Eixos em mancais de bronze, hastes de cilindros pneumáticos', Color(0xFF00695C)),
  _Ajuste('H7/k6', 'Transição', 'Engrenagens, polias fixas — sem folga garantida, pequena interferência', Color(0xFF558B2F)),
  _Ajuste('H7/n6', 'Forçado leve', 'Rolamentos fixos, bucha de bronzina — montagem com prensa ou aquecimento', Color(0xFFE65100)),
  _Ajuste('H7/p6', 'Interferência', 'Buchas permanentes, pinos, montagem com prensa a quente', Color(0xFFBF360C)),
  _Ajuste('H7/s6', 'Forçado pesado', 'Anéis de rolamento em carcaças, acoplamentos permanentes', Color(0xFF880E4F)),
  _Ajuste('H11/c11', 'Folga grande', 'Acoplamentos frouxos, tampas de caixas, flanges de vedação', Color(0xFF4527A0)),
  _Ajuste('H9/d9', 'Folga média', 'Eixos em bronze, partes de equipamentos agrícolas e pesados', Color(0xFF283593)),
];

// ─────────────────────────────────────────
class TolerenciasScreen extends StatefulWidget {
  const TolerenciasScreen({super.key});
  @override
  State<TolerenciasScreen> createState() => _TolerenciasScreenState();
}

class _TolerenciasScreenState extends State<TolerenciasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  // ── Calculadora ──
  double _dNominal = 25.0;
  String _campoFuro = 'H';
  int _grauFuro = 7;
  String _campoEixo = 'h';
  int _grauEixo = 6;

  final _txtDiam = TextEditingController(text: '25');

  final _camposFuro = ['H', 'G', 'F', 'E', 'D', 'JS'];
  final _camposEixo = ['h', 'g', 'f', 'e', 'd', 'k', 'm', 'n', 'p', 'r', 's'];
  final _graus = [4, 5, 6, 7, 8, 9, 10, 11, 12];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tab.dispose(); _txtDiam.dispose(); super.dispose(); }

  // ── Encontra o índice do intervalo para o diâmetro ──
  int _idxInterval(double d) {
    for (int i = 0; i < _intervals.length; i++) {
      if (d > _intervals[i][0] && d <= _intervals[i][1]) return i;
    }
    return 0;
  }

  // ── Calcula IT ──
  double _calcIT(int grade, int idx) {
    return _IsoData.itGrade(grade, _intervals[idx][0], _intervals[idx][1]);
  }

  // ── Desvio fundamental do furo (EI) ──
  int _eiDeFuro(String campo, int idx) {
    if (campo == 'JS') return 0; // ±IT/2
    return _fiEI[campo]?[idx] ?? 0;
  }

  // ── Desvio fundamental do eixo (es) ──
  int _esDeixo(String campo, int idx) {
    return _esMap[campo]?[idx] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Tolerâncias ISO', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: kDark,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tab,
          indicatorColor: kAmber,
          labelColor: kAmber,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: '🔢 Calculadora'),
            Tab(text: '📋 Ajustes Comuns'),
            Tab(text: '📐 Tabela IT'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildCalculadora(),
          _buildAjustesComuns(),
          _buildTabelaIT(),
        ],
      ),
    );
  }

  // ─── ABA 1: Calculadora ───────────────────────────────────
  Widget _buildCalculadora() {
    final idx = _idxInterval(_dNominal);
    final itFuro = _calcIT(_grauFuro, idx);
    final itEixo = _calcIT(_grauEixo, idx);

    // Furo
    final int eiF = _eiDeFuro(_campoFuro, idx);
    double esF;
    if (_campoFuro == 'JS') {
      esF = itFuro / 2;
      // EI = -IT/2 (representado como double)
    } else {
      esF = eiF + itFuro;
    }
    final double eiFd = _campoFuro == 'JS' ? -itFuro / 2 : eiF.toDouble();

    // Eixo
    final int esE = _esDeixo(_campoEixo, idx);
    final double eiE = esE - itEixo;

    // Ajuste
    final double folga = eiFd - esE; // folga mínima (positivo = folga, negativo = interferência)
    final double folgaMax = esF - eiE;
    final bool eFolga = folga >= 0;
    final bool eInterf = folgaMax < 0;
    final bool eTransi = !eFolga && !eInterf || (folga < 0 && folgaMax > 0);

    String tipoAjuste;
    Color corAjuste;
    if (eFolga) {
      tipoAjuste = 'Ajuste com FOLGA';
      corAjuste = kBlue;
    } else if (eInterf) {
      tipoAjuste = 'Ajuste por INTERFERÊNCIA';
      corAjuste = kRed;
    } else {
      tipoAjuste = 'Ajuste de TRANSIÇÃO';
      corAjuste = kAmber;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // ── Entrada diâmetro ──
        _sectionTitle('Diâmetro Nominal (mm)'),
        const SizedBox(height: 8),
        TextField(
          controller: _txtDiam,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: _inputDec('Ex: 25.00 mm'),
          onChanged: (v) {
            final d = double.tryParse(v);
            if (d != null && d > 0 && d <= 500) setState(() => _dNominal = d);
          },
        ),
        const SizedBox(height: 4),
        Text('Intervalo: ${_intervals[idx][0]} < D ≤ ${_intervals[idx][1]} mm',
          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 20),

        // ── Configuração Furo + Eixo ──
        Row(children: [
          Expanded(child: _buildCampoCard(
            titulo: '⬜ FURO',
            campo: _campoFuro,
            grau: _grauFuro,
            campos: _camposFuro,
            onCampo: (v) => setState(() => _campoFuro = v),
            onGrau: (v) => setState(() => _grauFuro = v),
            corHeader: kBlue,
          )),
          const SizedBox(width: 12),
          Expanded(child: _buildCampoCard(
            titulo: '⬛ EIXO',
            campo: _campoEixo,
            grau: _grauEixo,
            campos: _camposEixo,
            onCampo: (v) => setState(() => _campoEixo = v),
            onGrau: (v) => setState(() => _grauEixo = v),
            corHeader: kDark,
          )),
        ]),
        const SizedBox(height: 20),

        // ── Resultado Furo ──
        _buildResultCard(
          titulo: 'FURO  ${_campoFuro}${_grauFuro}',
          it: itFuro,
          devSup: esF,
          devInf: eiFd,
          dNominal: _dNominal,
          cor: kBlue,
        ),
        const SizedBox(height: 12),

        // ── Resultado Eixo ──
        _buildResultCard(
          titulo: 'EIXO  ${_campoEixo}${_grauEixo}',
          it: itEixo,
          devSup: esE.toDouble(),
          devInf: eiE,
          dNominal: _dNominal,
          cor: Colors.grey[800]!,
        ),
        const SizedBox(height: 20),

        // ── Tipo de Ajuste ──
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: corAjuste.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: corAjuste, width: 2),
          ),
          child: Column(children: [
            Text(tipoAjuste, style: TextStyle(color: corAjuste, fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _infoChip('Folga mín', '${folga.round()} µm', eFolga ? kBlue : kRed),
              _infoChip('Folga máx', '${folgaMax.round()} µm', folgaMax > 0 ? kBlue : kRed),
            ]),
            const SizedBox(height: 12),
            _diagramaAjuste(eiFd, esF, eiE, esE.toDouble(), corAjuste),
          ]),
        ),
        const SizedBox(height: 20),
        _buildDica(tipoAjuste, eFolga, eTransi),
      ]),
    );
  }

  Widget _buildCampoCard({
    required String titulo,
    required String campo,
    required int grau,
    required List<String> campos,
    required ValueChanged<String> onCampo,
    required ValueChanged<int> onGrau,
    required Color corHeader,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(color: corHeader, borderRadius: BorderRadius.circular(8)),
          child: Text(titulo, textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 10),
        const Text('Campo', style: TextStyle(fontSize: 11, color: Colors.grey)),
        DropdownButton<String>(
          value: campo,
          isExpanded: true,
          items: campos.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))).toList(),
          onChanged: (v) { if (v != null) onCampo(v); },
        ),
        const Text('Grau IT', style: TextStyle(fontSize: 11, color: Colors.grey)),
        DropdownButton<int>(
          value: grau,
          isExpanded: true,
          items: _graus.map((g) => DropdownMenuItem(value: g, child: Text('IT$g'))).toList(),
          onChanged: (v) { if (v != null) onGrau(v); },
        ),
        const SizedBox(height: 4),
        Center(
          child: Text('$campo$grau',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: corHeader)),
        ),
      ]),
    );
  }

  Widget _buildResultCard({
    required String titulo,
    required double it,
    required double devSup,
    required double devInf,
    required double dNominal,
    required Color cor,
  }) {
    final dimMax = dNominal + devSup / 1000;
    final dimMin = dNominal + devInf / 1000;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        border: Border(left: BorderSide(color: cor, width: 4)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(titulo, style: TextStyle(fontWeight: FontWeight.bold, color: cor, fontSize: 16)),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _numBox('IT (tolerância)', '${it.round()} µm', cor)),
          const SizedBox(width: 8),
          Expanded(child: _numBox('Dev. Superior', '${devSup > 0 ? "+" : ""}${devSup.round()} µm', devSup > 0 ? kGreen : kRed)),
          const SizedBox(width: 8),
          Expanded(child: _numBox('Dev. Inferior', '${devInf > 0 ? "+" : ""}${devInf.round()} µm', devInf > 0 ? kGreen : kRed)),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _numBox('Dim. Máx', '${dimMax.toStringAsFixed(3)} mm', kGreen)),
          const SizedBox(width: 8),
          Expanded(child: _numBox('Dim. Mín', '${dimMin.toStringAsFixed(3)} mm', kRed)),
        ]),
      ]),
    );
  }

  Widget _numBox(String label, String val, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cor.withOpacity(0.3)),
      ),
      child: Column(children: [
        Text(label, style: TextStyle(fontSize: 10, color: cor)),
        const SizedBox(height: 4),
        Text(val, style: TextStyle(fontWeight: FontWeight.bold, color: cor, fontSize: 13)),
      ]),
    );
  }

  Widget _infoChip(String label, String val, Color cor) {
    return Column(children: [
      Text(label, style: TextStyle(fontSize: 11, color: cor)),
      Text(val, style: TextStyle(fontWeight: FontWeight.bold, color: cor, fontSize: 16)),
    ]);
  }

  // Diagrama visual simplificado do ajuste
  Widget _diagramaAjuste(double eiFuro, double esFuro, double eiEixo, double esEixo, Color cor) {
    return Column(children: [
      const Text('Diagrama de Desvios (µm)', style: TextStyle(fontSize: 12, color: Colors.grey)),
      const SizedBox(height: 8),
      SizedBox(
        height: 80,
        child: CustomPaint(
          size: const Size(double.infinity, 80),
          painter: _DiagramaTolPainter(eiFuro, esFuro, eiEixo, esEixo, cor),
        ),
      ),
    ]);
  }

  Widget _buildDica(String tipo, bool folga, bool transicao) {
    String texto;
    if (folga) {
      texto = '✅ Ajuste com folga: as peças são montadas e desmontadas facilmente, com possibilidade de movimento relativo. Use lubrificação quando necessário.';
    } else if (transicao) {
      texto = '⚠️ Ajuste de transição: pode ter pequena folga ou pequena interferência. Montagem com prensa leve ou malete. Adequado para peças que precisam ser alinhadas com precisão mas ainda desmontadas.';
    } else {
      texto = '🔴 Ajuste por interferência: as peças são montadas com prensa, aquecimento ou criocontração. A ligação transmite esforços sem elementos adicionais (sem pinos, chavetas).';
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kAmber.withOpacity(0.5)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('💡 ', style: TextStyle(fontSize: 20)),
        Expanded(child: Text(texto, style: const TextStyle(fontSize: 13, height: 1.4))),
      ]),
    );
  }

  // ─── ABA 2: Ajustes Comuns ─────────────────────────────────
  Widget _buildAjustesComuns() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _ajustesComuns.length,
      itemBuilder: (ctx, i) {
        final a = _ajustesComuns[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => _showAjusteDetalhe(a),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                Container(
                  width: 72, height: 72,
                  decoration: BoxDecoration(
                    color: a.cor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: a.cor, width: 2),
                  ),
                  child: Center(child: Text(a.codigo,
                    style: TextStyle(fontWeight: FontWeight.bold, color: a.cor, fontSize: 13),
                    textAlign: TextAlign.center)),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a.tipo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(a.aplicacao, style: TextStyle(color: Colors.grey[700], fontSize: 12, height: 1.4)),
                ])),
                Icon(Icons.chevron_right, color: a.cor),
              ]),
            ),
          ),
        );
      },
    );
  }

  void _showAjusteDetalhe(_Ajuste a) {
    // Parse código (ex: H7/h6)
    final parts = a.codigo.split('/');
    final furo = parts[0];
    final eixo = parts[1];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: a.cor, borderRadius: BorderRadius.circular(10)),
                child: Text(a.codigo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(a.tipo, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
            ]),
            const SizedBox(height: 16),
            _detalheRow('Furo', furo, kBlue),
            _detalheRow('Eixo', eixo, kDark),
            const Divider(height: 24),
            const Text('Aplicação Industrial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Text(a.aplicacao, style: const TextStyle(fontSize: 14, height: 1.5)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.calculate_outlined),
              label: Text('Calcular para um diâmetro'),
              style: ElevatedButton.styleFrom(backgroundColor: a.cor, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                // Navega para a aba da calculadora com esse ajuste pré-selecionado
                _tab.animateTo(0);
                setState(() {
                  final campoF = furo.replaceAll(RegExp(r'[0-9]'), '');
                  final grauF = int.tryParse(furo.replaceAll(RegExp(r'[A-Za-z]'), '')) ?? 7;
                  final campoE = eixo.replaceAll(RegExp(r'[0-9]'), '');
                  final grauE = int.tryParse(eixo.replaceAll(RegExp(r'[A-Za-z]'), '')) ?? 6;
                  if (_camposFuro.contains(campoF)) _campoFuro = campoF;
                  if (_graus.contains(grauF)) _grauFuro = grauF;
                  if (_camposEixo.contains(campoE)) _campoEixo = campoE;
                  if (_graus.contains(grauE)) _grauEixo = grauE;
                });
              },
            ),
          ]),
        ),
      ),
    );
  }

  Widget _detalheRow(String label, String val, Color cor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 50, child: Text('$label:', style: const TextStyle(color: Colors.grey))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: cor.withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
          child: Text(val, style: TextStyle(fontWeight: FontWeight.bold, color: cor)),
        ),
      ]),
    );
  }

  // ─── ABA 3: Tabela IT ─────────────────────────────────────
  Widget _buildTabelaIT() {
    final grausMostrar = [6, 7, 8, 9, 10, 11];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Valores de Tolerância IT (µm)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text('Segundo ISO 286-1:2010 — valores para campos mais comuns',
          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStatePropertyAll(kDark),
            headingTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            dataRowColor: WidgetStatePropertyAll(Colors.white),
            columnSpacing: 16,
            columns: [
              const DataColumn(label: Text('Intervalo\n(mm)')),
              ...grausMostrar.map((g) => DataColumn(label: Text('IT$g'), numeric: true)),
            ],
            rows: List.generate(_intervals.length, (i) {
              final dMin = _intervals[i][0];
              final dMax = _intervals[i][1];
              return DataRow(
                color: WidgetStatePropertyAll(i % 2 == 0 ? Colors.white : const Color(0xFFF5F5F5)),
                cells: [
                  DataCell(Text('$dMin – $dMax', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                  ...grausMostrar.map((g) {
                    final val = _IsoData.itGrade(g, dMin, dMax).round();
                    return DataCell(Text('$val', style: const TextStyle(fontSize: 12)));
                  }),
                ],
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        _legenda(),
      ]),
    );
  }

  Widget _legenda() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Guia Rápido de Graus IT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 10),
        _itRow('IT5–IT6', 'Peças de alta precisão: rolamentos, spindles, instrumentos de medição', kBlue),
        _itRow('IT7–IT8', 'Uso geral em indústria: engrenagens, mancais, eixos de máquinas', kGreen),
        _itRow('IT9–IT10', 'Trabalhos normais: fixações, peças intercambiáveis, tolerâncias médias', kAmber),
        _itRow('IT11–IT12', 'Trabalhos grosseiros: fundição, forjamento, partes não acopladas', kRed),
      ]),
    );
  }

  Widget _itRow(String grade, String desc, Color cor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 70, padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
          decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(6)),
          child: Text(grade, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(desc, style: const TextStyle(fontSize: 12, height: 1.3))),
      ]),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────
  Widget _sectionTitle(String t) =>
      Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDark));

  InputDecoration _inputDec(String hint) => InputDecoration(
    hintText: hint,
    filled: true, fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}

// ─── Painter do diagrama de tolerâncias ──────────────────────
class _DiagramaTolPainter extends CustomPainter {
  final double eiFuro, esFuro, eiEixo, esEixo;
  final Color cor;
  _DiagramaTolPainter(this.eiFuro, this.esFuro, this.eiEixo, this.esEixo, this.cor);

  @override
  void paint(Canvas canvas, Size size) {
    final all = [eiFuro, esFuro, eiEixo, esEixo];
    final minV = all.reduce(min);
    final maxV = all.reduce(max);
    final range = (maxV - minV).abs().clamp(1.0, double.infinity);
    final scale = (size.height * 0.6) / range;
    final midY = size.height * 0.5;
    final zeroY = midY - (-minV * scale); // linha de zero

    // Linha de zero
    final pZero = Paint()..color = Colors.grey..strokeWidth = 1.5..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, zeroY), Offset(size.width, zeroY), pZero);
    final tp = TextPainter(text: const TextSpan(text: 'Ø', style: TextStyle(color: Colors.grey, fontSize: 10)), textDirection: TextDirection.ltr)..layout();
    tp.paint(canvas, Offset(0, zeroY - 12));

    final w = size.width;
    final furoLeft = w * 0.05;
    final furoRight = w * 0.45;
    final eixoLeft = w * 0.55;
    final eixoRight = w * 0.95;

    // Furo
    _drawField(canvas, furoLeft, furoRight, zeroY, eiFuro, esFuro, kBlue, scale, 'FURO');
    // Eixo
    _drawField(canvas, eixoLeft, eixoRight, zeroY, eiEixo, esEixo, Colors.grey[700]!, scale, 'EIXO');
  }

  void _drawField(Canvas c, double left, double right, double zeroY,
      double ei, double es, Color cor, double scale, String label) {
    final top = zeroY - es * scale;
    final bot = zeroY - ei * scale;
    final rect = Rect.fromLTRB(left, top, right, bot);
    c.drawRect(rect, Paint()..color = cor.withOpacity(0.3));
    c.drawRect(rect, Paint()..color = cor..style = PaintingStyle.stroke..strokeWidth = 2);

    final tp = TextPainter(
      text: TextSpan(text: label, style: TextStyle(color: cor, fontSize: 9, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, Offset(left + (right - left - tp.width) / 2, top - 14));
  }

  @override
  bool shouldRepaint(_DiagramaTolPainter old) => true;
}
