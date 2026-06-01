import 'dart:math';
import 'package:flutter/material.dart';
import '../constants.dart';

class CalculadoraScreen extends StatefulWidget {
  final double? initialVc;
  final double? initialFz;
  final double? initialAp;
  final double? initialAe;

  const CalculadoraScreen({
    super.key,
    this.initialVc,
    this.initialFz,
    this.initialAp,
    this.initialAe,
  });

  @override
  State<CalculadoraScreen> createState() => _CalculadoraScreenState();
}

class _CalculadoraScreenState extends State<CalculadoraScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  double _vc = 200, _diam = 12;
  int _matIdx = 0;
  double _fz = 0.05, _rpmAv = 5305;
  int _z = 4;
  double _kc = 2500, _ae = 6, _ap = 3, _vfP = 1061;
  double _comprimento = 100, _sobremetal = 12, _vfT = 1061;
  int _passes = 1;
  double _dRosca = 10, _passo = 1.5;
  int _tipoRoscaIdx = 0;

  final _mats = [
    _Mat('Aço 1020', 200), _Mat('Aço Inox', 120),
    _Mat('Alumínio', 400), _Mat('Aço Ferr.', 80),
    _Mat('Bronze', 600), _Mat('Latão', 300),
    _Mat('Titânio', 50), _Mat('Plástico', 900),
  ];
  final _roscas = ['Métrica (M)', 'NPT Cônica', 'BSP Whitworth', 'UNF Unificada'];

  @override
  // Bolt Circle
  double _bcDiam = 100, _bcIni = 0;
  int _bcNfuros = 6;
  final _bcDiamCtrl = TextEditingController(text: '100');
  final _bcNCtrl = TextEditingController(text: '6');
  final _bcIniCtrl = TextEditingController(text: '0');

  void initState() {
    super.initState();
    _tab = TabController(length: 8, vsync: this);
    if (widget.initialVc != null) _vc = widget.initialVc!;
    if (widget.initialFz != null) _fz = widget.initialFz!;
    if (widget.initialAp != null) _ap = widget.initialAp!;
    if (widget.initialAe != null) _ae = widget.initialAe!;
  }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  double get _rpm => (_vc * 1000) / (pi * _diam);
  double get _vf => _fz * _z * _rpmAv;
  double get _pot => (_kc * _ae * _ap * _vfP) / (60 * 1e6);
  double get _tmMin => (_comprimento + _sobremetal) * _passes / (_vfT > 0 ? _vfT : 1);
  double get _furo => _dRosca - (1.0825 * _passo);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        Container(
          color: kDark,
          padding: const EdgeInsets.fromLTRB(20, 55, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 36, height: 36,
                decoration: BoxDecoration(color: kBlue, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.calculate_rounded, color: Colors.white, size: 20)),
              const SizedBox(width: 12),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Calculadora', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                Text('PARÂMETROS DE CORTE', style: TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.5)),
              ]),
            ]),
            const SizedBox(height: 16),
            TabBar(
              controller: _tab,
              labelColor: kAmber, unselectedLabelColor: Colors.grey,
              indicatorColor: kAmber, indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true, tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              tabs: const [Tab(text: 'RPM'), Tab(text: 'Avanço'), Tab(text: 'Potência'), Tab(text: 'Tempo'), Tab(text: 'Rosca'), Tab(text: 'Força Corte'), Tab(text: 'Vida Ferram.'), Tab(text: '⭕ Bolt Circle')],
            ),
          ]),
        ),
        Expanded(child: TabBarView(controller: _tab, children: [
          _rpmTab(), _avancoTab(), _potenciaTab(), _tempoTab(), _roscaTab(), _forcaCorteTab(), _vidaFerramTab(), _boltCircleTab(),
        ])),
      ]),
    );
  }

  Widget _rpmTab() {
    final r = _rpm;
    String? av; Color? ac;
    if (r > 15000) { av = 'RPM elevado — verifique limites do spindle!'; ac = Colors.red.shade100; }
    else if (r > 8000) { av = 'RPM alto — confirme balanceamento da ferramenta.'; ac = const Color(0xFFFFF3DC); }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 500), child: Column(children: [
        _card('Material de corte', Icons.layers_rounded, kBlue,
          Wrap(spacing: 6, runSpacing: 6,
            children: List.generate(_mats.length, (i) => GestureDetector(
              onTap: () => setState(() { _matIdx = i; _vc = _mats[i].vc.toDouble(); }),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _matIdx == i ? kAmber : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20)),
                child: Text(_mats[i].n,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                    color: _matIdx == i ? kDark : Colors.grey.shade600))))))),
        const SizedBox(height: 12),
        _card('Parâmetros', Icons.tune_rounded, kBlue, Column(children: [
          _field('Velocidade de corte (Vc)', _vc, 'm/min', (v) => setState(() => _vc = v)),
          const SizedBox(height: 10),
          _field('Diâmetro da ferramenta (D)', _diam, 'mm', (v) => setState(() => _diam = v)),
          const SizedBox(height: 12),
          _formula('RPM = (Vc × 1000) ÷ (π × D)', 'Fórmula ISO 3685 — padrão mundial'),
        ])),
        const SizedBox(height: 12),
        _card('Resultado', Icons.check_circle_outline_rounded, kGreen, Column(children: [
          _primary('Rotação recomendada', r.round().toString(), 'RPM'),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _box('Vel. superficial', _vc.toStringAsFixed(0), 'm/min')),
            const SizedBox(width: 8),
            Expanded(child: _box('Freq. de corte', (r/60).toStringAsFixed(1), 'Hz')),
          ]),
          if (av != null) ...[
            const SizedBox(height: 10),
            Container(width: double.infinity, padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: ac, borderRadius: BorderRadius.circular(8)),
              child: Text(av, style: const TextStyle(fontSize: 12, color: Color(0xFF7A4F00)))),
          ],
        ])),
      ]))),
    );
  }

  Widget _avancoTab() {
    final v = _vf;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 500), child: Column(children: [
        _card('Parâmetros de avanço', Icons.speed_rounded, kBlue, Column(children: [
          _field('Número de dentes (Z)', _z.toDouble(), 'dentes', (v) => setState(() => _z = v.round())),
          const SizedBox(height: 10),
          _field('Avanço por dente (fz)', _fz, 'mm/d', (v) => setState(() => _fz = v)),
          const SizedBox(height: 10),
          _field('RPM da operação', _rpmAv, 'RPM', (v) => setState(() => _rpmAv = v)),
          const SizedBox(height: 12),
          _formula('Vf = fz × Z × RPM', 'Avanço da mesa em mm/min'),
        ])),
        const SizedBox(height: 12),
        _card('Resultado', Icons.check_circle_outline_rounded, kGreen, Column(children: [
          _primary('Avanço da mesa', v.round().toString(), 'mm/min'),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _box('Por revolução', (_fz*_z).toStringAsFixed(3), 'mm/rot')),
            const SizedBox(width: 8),
            Expanded(child: _box('Por segundo', (v/60).toStringAsFixed(1), 'mm/s')),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _box('Por minuto', v.toStringAsFixed(1), 'mm/min')),
            const SizedBox(width: 8),
            Expanded(child: _box('Por hora', (v*60).round().toString(), 'mm/h')),
          ]),
        ])),
      ]))),
    );
  }

  Widget _potenciaTab() {
    final p = _pot;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 500), child: Column(children: [
        _card('Parâmetros de corte', Icons.bolt_rounded, kBlue, Column(children: [
          _field('Força específica Kc', _kc, 'N/mm²', (v) => setState(() => _kc = v)),
          const SizedBox(height: 10),
          _field('Largura de corte (ae)', _ae, 'mm', (v) => setState(() => _ae = v)),
          const SizedBox(height: 10),
          _field('Profundidade de corte (ap)', _ap, 'mm', (v) => setState(() => _ap = v)),
          const SizedBox(height: 10),
          _field('Avanço da mesa (Vf)', _vfP, 'mm/min', (v) => setState(() => _vfP = v)),
          const SizedBox(height: 12),
          _formula('Pc = (Kc × ae × ap × Vf) ÷ (60 × 10⁶)', 'Potência em kW'),
        ])),
        const SizedBox(height: 12),
        _card('Resultado', Icons.check_circle_outline_rounded, kGreen, Column(children: [
          _primary('Potência necessária', p.toStringAsFixed(2), 'kW'),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _box('Com efic. 80%', (p/0.8).toStringAsFixed(2), 'kW')),
            const SizedBox(width: 8),
            Expanded(child: _box('Em CV', ((p/0.8)*1.36).toStringAsFixed(2), 'CV')),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _box('Torque', (_rpmAv>0?(p*9550/_rpmAv).toStringAsFixed(1):'—'), 'N·m')),
            const SizedBox(width: 8),
            Expanded(child: _box('Em Watts', (p*1000).round().toString(), 'W')),
          ]),
        ])),
      ]))),
    );
  }

  Widget _tempoTab() {
    final tm = _tmMin;
    final ts = tm * 60;
    final mn = tm.floor();
    final sg = ((tm - mn) * 60).round();
    final ph = tm > 0 ? (60 / tm).floor() : 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 500), child: Column(children: [
        _card('Parâmetros de usinagem', Icons.timer_rounded, kBlue, Column(children: [
          _field('Comprimento de corte (L)', _comprimento, 'mm', (v) => setState(() => _comprimento = v)),
          const SizedBox(height: 10),
          _field('Sobremetal entrada + saída', _sobremetal, 'mm', (v) => setState(() => _sobremetal = v)),
          const SizedBox(height: 10),
          _field('Avanço da mesa (Vf)', _vfT, 'mm/min', (v) => setState(() => _vfT = v)),
          const SizedBox(height: 10),
          _field('Número de passes', _passes.toDouble(), 'passes', (v) => setState(() => _passes = v.round())),
          const SizedBox(height: 12),
          _formula('Tm = (L + sobremetal) × passes ÷ Vf', 'Tempo de corte em minutos'),
        ])),
        const SizedBox(height: 12),
        _card('Resultado', Icons.check_circle_outline_rounded, kGreen, Column(children: [
          _primary('Tempo de corte', '$mn:${sg.toString().padLeft(2, '0')}', 'min : seg'),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _box('Em segundos', ts.toStringAsFixed(1), 'seg')),
            const SizedBox(width: 8),
            Expanded(child: _box('Peças / hora', ph.toString(), 'peças')),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _box('Distância total', ((_comprimento+_sobremetal)*_passes).toStringAsFixed(1), 'mm')),
            const SizedBox(width: 8),
            Expanded(child: _box('Peças / turno 8h', (ph*8).toString(), 'peças')),
          ]),
        ])),
      ]))),
    );
  }

  Widget _roscaTab() {
    final f = _furo;
    final b = ((f * 10).ceil()) / 10;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 500), child: Column(children: [
        _card('Tipo de rosca', Icons.settings_rounded, kBlue,
          Wrap(spacing: 6, runSpacing: 6,
            children: List.generate(_roscas.length, (i) => GestureDetector(
              onTap: () => setState(() => _tipoRoscaIdx = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: _tipoRoscaIdx == i ? kAmber : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20)),
                child: Text(_roscas[i],
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500,
                    color: _tipoRoscaIdx == i ? kDark : Colors.grey.shade600))))))),
        const SizedBox(height: 12),
        _card('Parâmetros da rosca', Icons.tune_rounded, kBlue, Column(children: [
          _field('Diâmetro nominal (D)', _dRosca, 'mm', (v) => setState(() => _dRosca = v)),
          const SizedBox(height: 10),
          _field('Passo (P)', _passo, 'mm', (v) => setState(() => _passo = v)),
          const SizedBox(height: 12),
          _formula('Ø furo = D - (1.0825 × P)', 'Diâmetro de furo — norma ISO 965'),
        ])),
        const SizedBox(height: 12),
        _card('Resultado', Icons.check_circle_outline_rounded, kGreen, Column(children: [
          _primary('Furo para macho', f.toStringAsFixed(2), 'mm'),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _box('Broca recomendada', b.toStringAsFixed(1), 'mm')),
            const SizedBox(width: 8),
            Expanded(child: _box('Diâm. externo', _dRosca.toStringAsFixed(2), 'mm')),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(child: _box('Altura do filete', (0.6495*_passo).toStringAsFixed(3), 'mm')),
            const SizedBox(width: 8),
            Expanded(child: _box('Diâm. médio', (_dRosca-0.6495*_passo).toStringAsFixed(3), 'mm')),
          ]),
        ])),
      ]))),
    );
  }

  Widget _card(String titulo, IconData icon, Color cor, Widget child) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 14, color: cor), const SizedBox(width: 6),
          Text(titulo.toUpperCase(),
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: cor, letterSpacing: 0.5)),
        ]),
        const SizedBox(height: 14),
        child,
      ]),
    );
  }

  Widget _field(String label, double value, String unit, void Function(double) onChange) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      const SizedBox(height: 4),
      Row(children: [
        Expanded(child: TextFormField(
          initialValue: value % 1 == 0 ? value.toInt().toString() : value.toString(),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 0.5)),
            isDense: true),
          onChanged: (v) {
            final p = double.tryParse(v.replaceAll(',', '.'));
            if (p != null) onChange(p);
          })),
        const SizedBox(width: 8),
        Text(unit, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w500)),
      ]),
    ]);
  }

  Widget _formula(String f, String d) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(8)),
    child: Column(children: [
      Text(f, style: const TextStyle(color: kAmber, fontSize: 12, fontFamily: 'monospace'), textAlign: TextAlign.center),
      const SizedBox(height: 4),
      Text(d, style: const TextStyle(color: Colors.grey, fontSize: 10), textAlign: TextAlign.center),
    ]));

  Widget _primary(String l, String v, String u) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(10)),
    child: Column(children: [
      Text(l, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      const SizedBox(height: 4),
      Text(v, style: const TextStyle(color: kAmber, fontSize: 32, fontWeight: FontWeight.w500)),
      Text(u, style: const TextStyle(color: Colors.grey, fontSize: 11)),
    ]));

  Widget _box(String l, String v, String u) => Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
    child: Column(children: [
      Text(l, style: TextStyle(fontSize: 10, color: Colors.grey.shade500), textAlign: TextAlign.center),
      const SizedBox(height: 4),
      Text(v, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: kDark)),
      Text(u, style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
    ]));

  // ─── Bolt Circle / PCD ────────────────────────────────────
  Widget _boltCircleTab() {
    final r = _bcDiam / 2;
    final List<Map<String, double>> furos = [];
    for (int i = 0; i < _bcNfuros; i++) {
      final angRad = (_bcIni + (360.0 / _bcNfuros) * i) * (pi / 180);
      furos.add({'x': r * cos(angRad), 'y': r * sin(angRad), 'ang': _bcIni + (360.0 / _bcNfuros) * i});
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: _bcInput(_bcDiamCtrl, '⌀ PCD (mm)', (v) {
            final d = double.tryParse(v); if (d != null && d > 0) setState(() => _bcDiam = d);
          })),
          const SizedBox(width: 10),
          Expanded(child: _bcInput(_bcNCtrl, 'Nº de furos', (v) {
            final n = int.tryParse(v); if (n != null && n >= 2) setState(() => _bcNfuros = n);
          })),
          const SizedBox(width: 10),
          Expanded(child: _bcInput(_bcIniCtrl, 'Ângulo inicial (°)', (v) {
            final a = double.tryParse(v); if (a != null) setState(() => _bcIni = a);
          })),
        ]),
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            width: 240, height: 240,
            child: CustomPaint(painter: _BoltCirclePainter(furos, _bcDiam)),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(12)),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(color: kDark, borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
              child: Row(children: [
                const SizedBox(width: 30, child: Text('#', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 12))),
                const Expanded(child: Text('X (mm)', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 12))),
                const Expanded(child: Text('Y (mm)', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 12))),
                const SizedBox(width: 60, child: Text('Ângulo', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold, fontSize: 12))),
              ]),
            ),
            ...List.generate(furos.length, (i) {
              final f = furos[i];
              return Container(
                color: i % 2 == 0 ? kDark : kDark.withOpacity(0.8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(children: [
                  SizedBox(width: 30, child: Text('${i+1}', style: const TextStyle(color: kAmber, fontWeight: FontWeight.bold, fontSize: 13))),
                  Expanded(child: Text(f['x']!.toStringAsFixed(4), style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'))),
                  Expanded(child: Text(f['y']!.toStringAsFixed(4), style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'))),
                  SizedBox(width: 60, child: Text('${f['ang']!.toStringAsFixed(2)}°', style: TextStyle(color: Colors.grey[400], fontSize: 12))),
                ]),
              );
            }),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
              child: Text(
                '\u2300 PCD = $_bcDiam mm  \u2022  $_bcNfuros furos  \u2022  Espa\u00e7amento = ${(360.0 / _bcNfuros).toStringAsFixed(4)}\u00b0',
                style: TextStyle(color: Colors.grey[400], fontSize: 11), textAlign: TextAlign.center),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E5F5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.purple.withOpacity(0.3)),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('\ud83d\udca1 Dica G-Code (Fanuc)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.purple)),
            SizedBox(height: 6),
            Text(
              'Use os valores X,Y gerados diretamente no programa CNC:\n\nG81 R2. Z-15. F80. (ciclo de fura\u00e7\u00e3o)\nX[valor1] Y[valor2] (furo 1)\n...\nG80 (cancela ciclo)',
              style: TextStyle(fontSize: 12, fontFamily: 'monospace', height: 1.5),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _bcInput(TextEditingController ctrl, String label, ValueChanged<String> onChanged) {
    return TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(fontSize: 11),
        filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      ),
      style: const TextStyle(fontSize: 13),
    );
  }
}

class _Mat {
  final String n; final int vc;
  const _Mat(this.n, this.vc);
}

// ─────────────────────────────────────────
// FORÇA DE CORTE
// ─────────────────────────────────────────
Widget _forcaCorteTab() {
  return const _ForcaCorteTab();
}

Widget _vidaFerramTab() {
  return const _VidaFerramTab();
}


// ─────────────────────────────────────────
// TELA FORÇA DE CORTE
// ─────────────────────────────────────────
class _ForcaCorteTab extends StatefulWidget {
  const _ForcaCorteTab({super.key});
  @override
  State<_ForcaCorteTab> createState() => _ForcaCorteTabState();
}

class _ForcaCorteTabState extends State<_ForcaCorteTab> {
  final _apCtrl = TextEditingController();
  final _aeCtrl = TextEditingController();
  final _fzCtrl = TextEditingController();
  final _zcCtrl = TextEditingController();
  final _kcCtrl = TextEditingController();

  double? _forca, _potencia, _torque, _pressao;
  int _materialIdx = 0;

  // Kc1 — força específica de corte N/mm² por material
  final _materiais = [
    _MatKc('Aço carbono 1020',      1500),
    _MatKc('Aço 4140 (temperado)',  2000),
    _MatKc('Aço inox 304',          2200),
    _MatKc('Inox Duplex 2205',      2400),
    _MatKc('Ferro fundido cinzento', 1100),
    _MatKc('Alumínio 6061',          700),
    _MatKc('Alumínio 7075',          800),
    _MatKc('Titânio Ti-6Al-4V',     1900),
    _MatKc('Inconel 718',            2800),
    _MatKc('Hastelloy C-276',        2700),
    _MatKc('Cobre',                  900),
    _MatKc('Bronze',                1000),
    _MatKc('PEEK',                   500),
  ];

  void _calcular() {
    final ap = double.tryParse(_apCtrl.text.replaceAll(',', '.')) ?? 0;
    final ae = double.tryParse(_aeCtrl.text.replaceAll(',', '.')) ?? 0;
    final fz = double.tryParse(_fzCtrl.text.replaceAll(',', '.')) ?? 0;
    final z  = double.tryParse(_zcCtrl.text.replaceAll(',', '.')) ?? 1;
    final kc = double.tryParse(_kcCtrl.text.replaceAll(',', '.')) ?? _materiais[_materialIdx].kc.toDouble();

    if (ap <= 0 || ae <= 0 || fz <= 0) return;

    // Força de corte principal: Fc = kc × ap × fz (por dente)
    // Força total: Ft = kc × ap × ae × fz × z / 1000 (em N)
    final fc = kc * ap * fz; // força por dente (N)
    final ft = kc * ap * ae * fz * z / 1000; // força total estimada (N)

    setState(() {
      _forca = ft;
      // Pressão média de corte
      _pressao = kc * fz; // N/mm²
    });
  }

  @override
  void dispose() {
    _apCtrl.dispose(); _aeCtrl.dispose(); _fzCtrl.dispose();
    _zcCtrl.dispose(); _kcCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // INFO
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(10)),
              child: const Text(
                'Calcula a força de corte principal (Fc) em fresamento.\n'
                'Fc = Kc × ap × fz × z\n'
                'Kc = força específica de corte (N/mm²)',
                style: TextStyle(fontSize: 12, color: kBlue, height: 1.5))),
            const SizedBox(height: 16),

            // MATERIAL
            _label('Material (Kc₁ padrão)'),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200)),
              child: DropdownButtonHideUnderline(child: DropdownButton<int>(
                value: _materialIdx,
                isExpanded: true,
                onChanged: (v) => setState(() {
                  _materialIdx = v!;
                  _kcCtrl.text = _materiais[v].kc.toString();
                }),
                items: _materiais.asMap().entries.map((e) =>
                  DropdownMenuItem(value: e.key, child: Text(e.value.nome,
                    style: const TextStyle(fontSize: 13)))).toList()))),
            const SizedBox(height: 12),

            // CAMPOS
            Row(children: [
              Expanded(child: _campo('ap — Prof. axial (mm)', _apCtrl)),
              const SizedBox(width: 10),
              Expanded(child: _campo('ae — Prof. radial (mm)', _aeCtrl)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _campo('fz — Avanço por dente (mm)', _fzCtrl)),
              const SizedBox(width: 10),
              Expanded(child: _campo('z — Nº de dentes', _zcCtrl)),
            ]),
            const SizedBox(height: 10),
            _campo('Kc — Força específica (N/mm²)', _kcCtrl,
              hint: _materiais[_materialIdx].kc.toString()),
            const SizedBox(height: 14),

            // BOTÃO
            GestureDetector(
              onTap: _calcular,
              child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: kBlue, borderRadius: BorderRadius.circular(10)),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.calculate_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Calcular Força de Corte', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                ]))),

            // RESULTADO
            if (_forca != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(12)),
                child: Column(children: [
                  _resultRow('Força de corte total (Ft)', '${_forca!.toStringAsFixed(1)} N',
                    '${(_forca! / 9.807).toStringAsFixed(1)} kgf'),
                  const Divider(color: Color(0xFF252540), height: 20),
                  _resultRow('Pressão média de corte', '${_pressao!.toStringAsFixed(0)} N/mm²', ''),
                  const Divider(color: Color(0xFF252540), height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFF252540), borderRadius: BorderRadius.circular(8)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('⚙️ Como usar:', style: TextStyle(color: kAmber, fontSize: 11, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Text('• Força > 2000N → verificar rigidez da fixação\n'
                           '• Força > 5000N → risco de vibração — reduzir ae ou ap\n'
                           '• Use para dimensionar o sistema de fixação da peça',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 11, height: 1.5)),
                    ])),
                ])),
            ],

            const SizedBox(height: 20),
            // TABELA Kc REFERÊNCIA
            _label('Tabela Kc de Referência (N/mm²)'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8)),
              child: Column(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: kDark,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(7))),
                  child: Row(children: [
                    const Expanded(flex: 3, child: Text('Material',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
                    const Expanded(flex: 2, child: Text('Kc₁ (N/mm²)',
                      style: TextStyle(color: kAmber, fontSize: 11, fontWeight: FontWeight.w700),
                      textAlign: TextAlign.right)),
                  ])),
                ..._materiais.asMap().entries.map((e) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: e.key.isOdd ? Colors.grey.shade50 : Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5))),
                  child: Row(children: [
                    Expanded(flex: 3, child: Text(e.value.nome,
                      style: const TextStyle(fontSize: 12))),
                    Expanded(flex: 2, child: Text('${e.value.kc}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kBlue),
                      textAlign: TextAlign.right)),
                  ]))),
              ])),
          ]),
        )),
      ],
    );
  }

  Widget _label(String t) => Text(t,
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kDark));

  Widget _campo(String label, TextEditingController ctrl, {String? hint}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200)),
        child: TextField(controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint ?? '0.0',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero))),
    ]);

  Widget _resultRow(String label, String valor, String sub) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(valor, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        if (sub.isNotEmpty) Text(sub, style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
      ]),
    ]);
}

class _MatKc {
  final String nome; final int kc;
  const _MatKc(this.nome, this.kc);
}

// ─────────────────────────────────────────
// TELA VIDA DE FERRAMENTA — TAYLOR
// ─────────────────────────────────────────
class _VidaFerramTab extends StatefulWidget {
  const _VidaFerramTab({super.key});
  @override
  State<_VidaFerramTab> createState() => _VidaFerramTabState();
}

class _VidaFerramTabState extends State<_VidaFerramTab> {
  final _vcAtualCtrl = TextEditingController();
  final _tAtualCtrl  = TextEditingController();
  final _vcNovoCtrl  = TextEditingController();
  final _nCtrl       = TextEditingController(text: '0.25');

  double? _vidaNova, _relacao;
  int _materialIdx = 0;

  final _materiais = [
    _MatTaylor('Aço carbono — fresa carbeto',         0.25, 45,  180),
    _MatTaylor('Aço carbono — fresa HSS',              0.12, 20,  120),
    _MatTaylor('Aço inox — fresa carbeto',             0.25, 30,  150),
    _MatTaylor('Alumínio — fresa carbeto',             0.30, 80,  600),
    _MatTaylor('Ferro fundido — fresa carbeto',        0.25, 50,  200),
    _MatTaylor('Titânio Ti-6Al-4V — carbeto',          0.25, 20,   60),
    _MatTaylor('Inconel 718 — carbeto',                0.22, 10,   35),
    _MatTaylor('Aço endurecido 50HRC — CBN',           0.20, 40,  120),
  ];

  void _calcular() {
    final vcA = double.tryParse(_vcAtualCtrl.text.replaceAll(',', '.')) ?? 0;
    final tA  = double.tryParse(_tAtualCtrl.text.replaceAll(',', '.'))  ?? 0;
    final vcN = double.tryParse(_vcNovoCtrl.text.replaceAll(',', '.'))  ?? 0;
    final n   = double.tryParse(_nCtrl.text.replaceAll(',', '.'))       ?? 0.25;

    if (vcA <= 0 || tA <= 0 || vcN <= 0 || n <= 0) return;

    // Equação de Taylor: Vc × T^n = C
    // T_novo = T_atual × (Vc_atual / Vc_novo) ^ (1/n)
    final tNovo = tA * pow(vcA / vcN, 1 / n);
    final relacao = tNovo / tA;

    setState(() {
      _vidaNova = tNovo;
      _relacao = relacao;
    });
  }

  @override
  void dispose() {
    _vcAtualCtrl.dispose(); _tAtualCtrl.dispose();
    _vcNovoCtrl.dispose(); _nCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFE1F5EE), borderRadius: BorderRadius.circular(10)),
              child: const Text(
                'Equação de Taylor: Vc × T^n = C\n\n'
                'Se você conhece a vida atual da ferramenta a uma velocidade, '
                'calcula quanto tempo vai durar em outra velocidade.',
                style: TextStyle(fontSize: 12, color: kGreen, height: 1.5))),
            const SizedBox(height: 16),

            // MATERIAL
            _label('Material / Ferramenta (n de Taylor)'),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade200)),
              child: DropdownButtonHideUnderline(child: DropdownButton<int>(
                value: _materialIdx, isExpanded: true,
                onChanged: (v) => setState(() {
                  _materialIdx = v!;
                  _nCtrl.text = _materiais[v].n.toString();
                  _vcAtualCtrl.text = _materiais[v].vcRef.toString();
                  _tAtualCtrl.text = _materiais[v].tRef.toString();
                }),
                items: _materiais.asMap().entries.map((e) =>
                  DropdownMenuItem(value: e.key,
                    child: Text(e.value.nome, style: const TextStyle(fontSize: 12)))).toList()))),
            const SizedBox(height: 12),

            Row(children: [
              Expanded(child: _campo('Vc atual (m/min)', _vcAtualCtrl)),
              const SizedBox(width: 10),
              Expanded(child: _campo('Vida atual (min)', _tAtualCtrl)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _campo('Vc nova (m/min)', _vcNovoCtrl)),
              const SizedBox(width: 10),
              Expanded(child: _campo('n de Taylor', _nCtrl, hint: '0.25')),
            ]),
            const SizedBox(height: 14),

            GestureDetector(
              onTap: _calcular,
              child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(10)),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.timer_outlined, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Calcular Vida da Ferramenta', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                ]))),

            if (_vidaNova != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(12)),
                child: Column(children: [
                  _resultRow('Vida na nova velocidade', '${_vidaNova!.toStringAsFixed(1)} min', ''),
                  const Divider(color: Color(0xFF252540), height: 20),
                  _resultRow('Variação', _relacao! >= 1
                    ? '+${((_relacao! - 1) * 100).toStringAsFixed(0)}% mais vida'
                    : '${((_relacao! - 1) * 100).toStringAsFixed(0)}% menos vida', ''),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _relacao! >= 1
                        ? const Color(0xFF0F6E56).withValues(alpha: 0.2)
                        : kRed.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      _relacao! >= 1
                        ? '✅ Velocidade menor = mais vida. Mas verifique produtividade!'
                        : '⚠️ Velocidade maior = vida menor. Aumentar troca preventiva.',
                      style: TextStyle(
                        color: _relacao! >= 1 ? kGreen : kRed,
                        fontSize: 12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center)),
                ])),
            ],

            const SizedBox(height: 20),
            _label('Tabela de Referência Taylor'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8)),
              child: Column(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: kDark,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(7))),
                  child: Row(children: [
                    const Expanded(flex: 3, child: Text('Material/Ferramenta',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700))),
                    const Expanded(flex: 1, child: Text('n', textAlign: TextAlign.center,
                      style: TextStyle(color: kAmber, fontSize: 10, fontWeight: FontWeight.w700))),
                    const Expanded(flex: 1, child: Text('Vc ref.', textAlign: TextAlign.center,
                      style: TextStyle(color: kAmber, fontSize: 10, fontWeight: FontWeight.w700))),
                    const Expanded(flex: 1, child: Text('T ref.', textAlign: TextAlign.center,
                      style: TextStyle(color: kAmber, fontSize: 10, fontWeight: FontWeight.w700))),
                  ])),
                ..._materiais.asMap().entries.map((e) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: e.key.isOdd ? Colors.grey.shade50 : Colors.white,
                    border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5))),
                  child: Row(children: [
                    Expanded(flex: 3, child: Text(e.value.nome,
                      style: const TextStyle(fontSize: 10))),
                    Expanded(flex: 1, child: Text(e.value.n.toString(),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: kBlue),
                      textAlign: TextAlign.center)),
                    Expanded(flex: 1, child: Text('${e.value.vcRef}',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      textAlign: TextAlign.center)),
                    Expanded(flex: 1, child: Text('${e.value.tRef}min',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                      textAlign: TextAlign.center)),
                  ]))),
              ])),
            const SizedBox(height: 20),
          ]),
        )),
      ],
    );
  }

  Widget _label(String t) => Text(t,
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kDark));

  Widget _campo(String label, TextEditingController ctrl, {String? hint}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200)),
        child: TextField(controller: ctrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: hint ?? '0.0',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero))),
    ]);

  Widget _resultRow(String label, String valor, String sub) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12))),
      Text(valor, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
    ]);
}

class _MatTaylor {
  final String nome; final double n; final int tRef, vcRef;
  const _MatTaylor(this.nome, this.n, this.tRef, this.vcRef);
}

// ─── Bolt Circle Painter ──────────────────────────────────
class _BoltCirclePainter extends CustomPainter {
  final List<Map<String, double>> furos;
  final double diametro;
  _BoltCirclePainter(this.furos, this.diametro);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.38;

    // Círculo PCD
    final pPcd = Paint()..color = const Color(0xFF1A1A2E).withOpacity(0.2)..style = PaintingStyle.stroke..strokeWidth = 1..strokeCap = StrokeCap.round;
    canvas.drawCircle(Offset(cx, cy), r, pPcd);

    // Eixo X e Y
    final pAxis = Paint()..color = Colors.grey.withOpacity(0.25)..strokeWidth = 0.8;
    canvas.drawLine(Offset(cx - r - 10, cy), Offset(cx + r + 10, cy), pAxis);
    canvas.drawLine(Offset(cx, cy - r - 10), Offset(cx, cy + r + 10), pAxis);

    // Furos
    for (int i = 0; i < furos.length; i++) {
      final f = furos[i];
      final px = cx + (f['x']! / (diametro / 2)) * r;
      final py = cy - (f['y']! / (diametro / 2)) * r;

      // Linha do centro ao furo
      final pLine = Paint()..color = const Color(0xFFE8A020).withOpacity(0.3)..strokeWidth = 0.8;
      canvas.drawLine(Offset(cx, cy), Offset(px, py), pLine);

      // Furo
      final pFuro = Paint()..color = const Color(0xFF185FA5)..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(px, py), 8, pFuro);
      final pFuroBord = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = 1.5;
      canvas.drawCircle(Offset(px, py), 8, pFuroBord);

      // Número
      final tp = TextPainter(
        text: TextSpan(text: '${i+1}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(px - tp.width / 2, py - tp.height / 2));
    }

    // Centro
    final pCentro = Paint()..color = const Color(0xFFE8A020);
    canvas.drawCircle(Offset(cx, cy), 4, pCentro);

    // Label diâmetro
    final tpD = TextPainter(
      text: TextSpan(text: 'PCD ⌀$diametro mm', style: TextStyle(color: Colors.grey[600], fontSize: 9)),
      textDirection: TextDirection.ltr,
    )..layout();
    tpD.paint(canvas, Offset(cx - tpD.width / 2, cy + r + 4));
  }

  @override
  bool shouldRepaint(_BoltCirclePainter old) => true;
}