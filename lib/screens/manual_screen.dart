import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants.dart';

// ─────────────────────────────────────────
// MANUAL ILUSTRADO CNC
// ─────────────────────────────────────────
class ManualScreen extends StatefulWidget {
  const ManualScreen({super.key});
  @override
  State<ManualScreen> createState() => _ManualScreenState();
}

class _ManualScreenState extends State<ManualScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 11, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

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
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: const Color(0xFF7B2FBE), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 20)),
              const SizedBox(width: 12),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Manual Ilustrado', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                Text('GUIA VISUAL COM DIAGRAMAS CNC', style: TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.5)),
              ]),
            ]),
            const SizedBox(height: 14),
            TabBar(
              controller: _tab,
              labelColor: kAmber,
              unselectedLabelColor: Colors.grey,
              indicatorColor: kAmber,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: '⭕ Interpolação'),
                Tab(text: '🔩 Furação'),
                Tab(text: '↔️ G41/G42'),
                Tab(text: '📐 Sistemas Coord.'),
                Tab(text: '📊 Parâmetros'),
                Tab(text: '🔄 Ciclos Torno'),
                Tab(text: '⚙️ M-Codes'),
                Tab(text: '🎯 Setup & Borda'),
                Tab(text: '⚡ Velocidades'),
                Tab(text: '🔧 Ferramentas'),
                Tab(text: '📏 Tolerâncias'),
              ],
            ),
          ]),
        ),
        Expanded(child: TabBarView(controller: _tab, children: const [
          _TabInterpolacao(),
          _TabFuracao(),
          _TabCompensacao(),
          _TabCoordenadas(),
          _TabParametros(),
          _TabCiclosTorno(),
          _TabMCodes(),
          _TabSetupBorda(),
          _TabVelocidades(),
          _TabFerramentas(),
          _TabTolerancias(),
        ])),
      ]),
    );
  }
}

// ═══════════════════════════════════════════
// ABA 1 — INTERPOLAÇÃO CIRCULAR
// ═══════════════════════════════════════════
class _TabInterpolacao extends StatelessWidget {
  const _TabInterpolacao();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: Column(children: [
          _SectionTitle(num: '01', titulo: 'Interpolação Circular', sub: 'G02 move no sentido horário (CW). G03 move no sentido anti-horário (CCW).'),
          const SizedBox(height: 12),

          // G02 e G03 lado a lado
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _ManualCard(
              titulo: 'G02 — Horário (CW)',
              badge: 'CW', badgeColor: kBlue,
              child: Column(children: [
                SizedBox(height: 190, child: CustomPaint(painter: _G02Painter(), size: const Size(double.infinity, 190))),
                const _CodeBox(lines: [
                  _CodeLine('; Com raio R:', true),
                  _CodeLine('G02 X160 Y100 R50 F150', false),
                  _CodeLine('; Com I,J:', true),
                  _CodeLine('G02 X160 Y100 I50 J0 F150', false),
                ]),
                const _Callout(
                  icon: Icons.warning_amber_rounded, color: Color(0xFFFFCC02),
                  bg: Color(0x1FFFCC02),
                  text: 'Para círculo 360° use sempre I,J — nunca R. Com R o CNC não sabe qual caminho tomar.',
                ),
              ]),
            )),
            const SizedBox(width: 10),
            Expanded(child: _ManualCard(
              titulo: 'G03 — Anti-horário (CCW)',
              badge: 'CCW', badgeColor: kGreen,
              child: Column(children: [
                SizedBox(height: 190, child: CustomPaint(painter: _G03Painter(), size: const Size(double.infinity, 190))),
                const _CodeBox(lines: [
                  _CodeLine('; Com raio R:', true),
                  _CodeLine('G03 X160 Y100 R50 F150', false),
                  _CodeLine('; Círculo completo 360°:', true),
                  _CodeLine('G03 I50 J0 F150', false),
                ]),
                const _Callout(
                  icon: Icons.lightbulb_rounded, color: kGreen,
                  bg: Color(0x1100C853),
                  text: 'G03 é usado para raios internos, bolsões circulares e usinagem climb em face interna.',
                ),
              ]),
            )),
          ]),

          const SizedBox(height: 12),

          // R+ vs R-
          _ManualCard(
            titulo: 'R+ vs R— — Qual caminho o CNC escolhe?',
            badge: 'IMPORTANTE', badgeColor: kRed,
            child: Column(children: [
              SizedBox(height: 160, child: CustomPaint(painter: _RPosiNegaPainter(), size: const Size(double.infinity, 160))),
              const _Callout(
                icon: Icons.info_rounded, color: kBlue, bg: Color(0x112979FF),
                text: 'R+ → arco menor que 180° (caminho curto). R− → arco maior que 180° (caminho longo). Para círculo completo use obrigatoriamente I,J.',
              ),
            ]),
          ),

          const SizedBox(height: 12),

          // IJ explicação
          _ManualCard(
            titulo: 'I, J, K — Distância do Início ao Centro',
            badge: 'PARÂMETROS', badgeColor: kAmber,
            child: Column(children: [
              SizedBox(height: 180, child: CustomPaint(painter: _IJPainter(), size: const Size(double.infinity, 180))),
              const SizedBox(height: 10),
              _ParamTable(rows: const [
                ['I', 'Distância em X: do ponto inicial ao centro do arco'],
                ['J', 'Distância em Y: do ponto inicial ao centro do arco'],
                ['K', 'Distância em Z: para arcos nos planos G18 e G19'],
                ['R', 'Raio direto (simples, mas não funciona em 360°)'],
              ]),
            ]),
          ),
        ]))),
      ],
    );
  }
}

// ═══════════════════════════════════════════
// ABA 2 — CICLOS DE FURAÇÃO
// ═══════════════════════════════════════════
class _TabFuracao extends StatelessWidget {
  const _TabFuracao();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: Column(children: [
          _SectionTitle(num: '02', titulo: 'Ciclos de Furação', sub: 'G80, G81, G83, G84 — Ciclos fixos automatizam movimentos repetitivos de furação.'),
          const SizedBox(height: 12),

          const _CncImage(
            asset: 'assets/images/cnc/g83_furacao_peck.png',
            legenda: 'G83 Peck Drilling — broca avança Q mm, recua, volta e avança mais Q (profundidade > 3×D)',
            height: 190,
          ),
          const SizedBox(height: 12),

          // G81
          _ManualCard(
            titulo: 'G81 — Furação Simples',
            badge: 'RASA ≤ 3×D', badgeColor: kBlue,
            child: Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 160, height: 220, child: CustomPaint(painter: _G81Painter(), size: const Size(160, 220))),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const _CodeBox(lines: [
                    _CodeLine('; Ciclo G81 — furação simples', true),
                    _CodeLine('G81 X50. Y30. Z-20. R3. F150', false),
                    _CodeLine('; Mais furos mesma prof.:', true),
                    _CodeLine('X80. Y30.', false),
                    _CodeLine('X110. Y30.', false),
                    _CodeLine('G80   ; cancela ciclo', true),
                  ]),
                  const SizedBox(height: 10),
                  _ParamTable(rows: const [
                    ['X,Y', 'Posição do furo'],
                    ['Z', 'Profundidade final (neg.)'],
                    ['R', 'Plano de aproximação'],
                    ['F', 'Avanço mm/min'],
                  ]),
                ])),
              ]),
              const _Callout(
                icon: Icons.warning_amber_rounded, color: Color(0xFFFFCC02), bg: Color(0x1FFFCC02),
                text: 'G80 cancela o ciclo! Sem G80 qualquer movimento XY vai reativar a furação.',
              ),
            ]),
          ),

          const SizedBox(height: 12),

          // G83
          _ManualCard(
            titulo: 'G83 — Furação Profunda (Peck)',
            badge: '> 3×D', badgeColor: kAmber,
            child: Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 160, height: 260, child: CustomPaint(painter: _G83Painter(), size: const Size(160, 260))),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const _CodeBox(lines: [
                    _CodeLine('; G83 — furação profunda peck', true),
                    _CodeLine('G83 X50. Y30. Z-60.', false),
                    _CodeLine('     R3. Q10. F120', false),
                    _CodeLine('; Q = prof. de cada peck', true),
                    _CodeLine('; A cada Q: retrai ao R', true),
                    _CodeLine('X100. Y30. ; próximo furo', true),
                    _CodeLine('G80', false),
                  ]),
                  const SizedBox(height: 10),
                  _ParamTable(rows: const [
                    ['Z', 'Profundidade total'],
                    ['R', 'Plano de referência'],
                    ['Q', 'Peck (SEMPRE positivo!)'],
                    ['F', 'Avanço de furação'],
                  ]),
                ])),
              ]),
              const _Callout(
                icon: Icons.lightbulb_rounded, color: kGreen, bg: Color(0x1100C853),
                text: 'Para furos acima de 5× o diâmetro, reduza Q progressivamente. Q deve ser POSITIVO sempre.',
              ),
            ]),
          ),

          const SizedBox(height: 12),

          // G84
          _ManualCard(
            titulo: 'G84 — Rosqueamento Rígido',
            badge: 'F = RPM × PASSO', badgeColor: kRed,
            child: Column(children: [
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(width: 160, height: 230, child: CustomPaint(painter: _G84Painter(), size: const Size(160, 230))),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const _CodeBox(lines: [
                    _CodeLine('; M10×1.5 a 500 RPM', true),
                    _CodeLine('; F = 500 × 1.5 = 750', true),
                    _CodeLine('S500 M3', false),
                    _CodeLine('G84 X50. Y30. Z-25.', false),
                    _CodeLine('     R5. F750', false),
                    _CodeLine('G80', false),
                  ]),
                  const SizedBox(height: 10),
                  // Tabela F por rosca
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade100)),
                    child: Table(
                      columnWidths: const {0: FlexColumnWidth(1.2), 1: FlexColumnWidth(1), 2: FlexColumnWidth(1), 3: FlexColumnWidth(1)},
                      children: [
                        TableRow(decoration: BoxDecoration(color: kDark, borderRadius: const BorderRadius.vertical(top: Radius.circular(8))), children: [
                          _th('Rosca'), _th('Passo'), _th('500rpm'), _th('800rpm'),
                        ]),
                        _trow(['M6', '1.0', 'F500', 'F800'], false),
                        _trow(['M8', '1.25', 'F625', 'F1000'], true),
                        _trow(['M10', '1.5', 'F750', 'F1200'], false),
                        _trow(['M12', '1.75', 'F875', 'F1400'], true),
                      ],
                    ),
                  ),
                ])),
              ]),
              const _Callout(
                icon: Icons.info_rounded, color: kBlue, bg: Color(0x112979FF),
                text: 'Spindle sincroniza com Z: M3 na ida, M4 na volta automático. Não programe M4 manual.',
              ),
            ]),
          ),
        ]))),
      ],
    );
  }

  Widget _th(String t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
    child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)));

  TableRow _trow(List<String> cells, bool alt) => TableRow(
    decoration: BoxDecoration(color: alt ? Colors.grey.shade50 : Colors.white),
    children: cells.asMap().entries.map((e) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
      child: Text(e.value, style: TextStyle(
        fontSize: 11, fontWeight: e.key == 0 ? FontWeight.w600 : FontWeight.normal,
        color: e.key == 2 || e.key == 3 ? kBlue : Colors.black87)))).toList());
}

// ═══════════════════════════════════════════
// ABA 3 — COMPENSAÇÃO G41/G42
// ═══════════════════════════════════════════
class _TabCompensacao extends StatelessWidget {
  const _TabCompensacao();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: Column(children: [
          _SectionTitle(num: '03', titulo: 'Compensação de Raio G41/G42', sub: 'Programa o contorno da peça — o CNC calcula automaticamente o caminho real da fresa.'),
          const SizedBox(height: 12),

          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: _ManualCard(
              titulo: 'G41 — Fresa à Esquerda',
              badge: 'EXTERNO', badgeColor: kBlue,
              child: Column(children: [
                SizedBox(height: 200, child: CustomPaint(painter: _G41Painter(), size: const Size(double.infinity, 200))),
                const _CodeBox(lines: [
                  _CodeLine('G41 D1  ; ativa com D1', true),
                  _CodeLine('G01 X50. Y0 F200', false),
                  _CodeLine('X150.', false),
                  _CodeLine('Y80.', false),
                  _CodeLine('X50.', false),
                  _CodeLine('G40     ; cancela', true),
                ]),
              ]),
            )),
            const SizedBox(width: 10),
            Expanded(child: _ManualCard(
              titulo: 'G42 — Fresa à Direita',
              badge: 'INTERNO', badgeColor: const Color(0xFF9C27B0),
              child: Column(children: [
                SizedBox(height: 200, child: CustomPaint(painter: _G42Painter(), size: const Size(double.infinity, 200))),
                const _CodeBox(lines: [
                  _CodeLine('G42 D1  ; ativa com D1', true),
                  _CodeLine('G01 X50. Y0 F200', false),
                  _CodeLine('X150.', false),
                  _CodeLine('Y80.', false),
                  _CodeLine('X50.', false),
                  _CodeLine('G40     ; cancela', true),
                ]),
              ]),
            )),
          ]),

          const SizedBox(height: 12),

          _ManualCard(
            titulo: '🖐️ Como lembrar: Regra do Polegar',
            badge: 'DICA', badgeColor: kAmber,
            child: Column(children: [
              SizedBox(height: 150, child: CustomPaint(painter: _G41G42RegPainter(), size: const Size(double.infinity, 150))),
              const SizedBox(height: 8),
              const _Callout(
                icon: Icons.back_hand_rounded, color: kAmber, bg: Color(0x1FFFCC02),
                text: 'Aponte o polegar na direção de avanço. G41 = fresa no lado da palma (esquerda). G42 = fresa no lado do dorso (direita).',
              ),
            ]),
          ),

          const SizedBox(height: 12),

          _ManualCard(
            titulo: '🚨 Regras Importantes — G41/G42',
            badge: 'ATENÇÃO', badgeColor: kRed,
            child: Column(children: [
              const _Callout(
                icon: Icons.warning_amber_rounded, color: kRed, bg: Color(0x11FF3D00),
                text: 'Sempre ATIVAR G41/G42 com movimento de aproximação fora do contorno. Nunca ativar dentro do material.',
              ),
              const SizedBox(height: 8),
              const _Callout(
                icon: Icons.warning_amber_rounded, color: kRed, bg: Color(0x11FF3D00),
                text: 'Sempre CANCELAR G40 fora do material. Cancelar dentro gera colisão.',
              ),
              const SizedBox(height: 8),
              const _Callout(
                icon: Icons.info_rounded, color: kBlue, bg: Color(0x112979FF),
                text: 'D = número do offset de raio. D0 cancela sem G40. D1 usa o offset registrado na posição 1.',
              ),
            ]),
          ),
        ]))),
      ],
    );
  }
}

// ═══════════════════════════════════════════
// ABA 4 — SISTEMAS DE COORDENADAS
// ═══════════════════════════════════════════
class _TabCoordenadas extends StatelessWidget {
  const _TabCoordenadas();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: Column(children: [
          _SectionTitle(num: '04', titulo: 'Sistemas de Coordenadas', sub: 'G54-G59 são os zeros de peça. G28 é o home da máquina. G43 aplica o comprimento da ferramenta.'),
          const SizedBox(height: 12),

          _ManualCard(
            titulo: 'G54 a G59 — Zeros de Peça (Work Offsets)',
            badge: 'FUNDAMENTAL', badgeColor: kAmber,
            child: Column(children: [
              SizedBox(height: 220, child: CustomPaint(painter: _G54Painter(), size: const Size(double.infinity, 220))),
              const SizedBox(height: 10),
              _ParamTable(rows: const [
                ['G54', 'Zero-peça 1 — o mais usado no dia a dia'],
                ['G55', 'Zero-peça 2 — segunda fixação ou segunda peça'],
                ['G56', 'Zero-peça 3 — terceira fixação'],
                ['G57', 'Zero-peça 4 — uso livre'],
                ['G58', 'Zero-peça 5 — uso livre'],
                ['G59', 'Zero-peça 6 — uso livre'],
              ]),
              const SizedBox(height: 8),
              const _Callout(
                icon: Icons.lightbulb_rounded, color: kGreen, bg: Color(0x1100C853),
                text: 'G54 é o mais usado. Em palete ou fixação múltipla, use G55/G56 para cada peça — evita retrabalho de zerar.',
              ),
            ]),
          ),

          const SizedBox(height: 12),

          _ManualCard(
            titulo: 'G28 — Retorno ao Home da Máquina',
            badge: 'SEGURANÇA', badgeColor: kRed,
            child: Column(children: [
              SizedBox(height: 180, child: CustomPaint(painter: _G28Painter(), size: const Size(double.infinity, 180))),
              const _CodeBox(lines: [
                _CodeLine('; SEMPRE sobe Z primeiro!', true),
                _CodeLine('G28 Z0.    ; vai ao home em Z', false),
                _CodeLine('G28 X0 Y0. ; depois X e Y', false),
                _CodeLine('; G91 G28 Z0 = retorno incremental', true),
                _CodeLine('G91 G28 Z0.', false),
                _CodeLine('G90        ; volta ao modo absoluto', false),
              ]),
              const SizedBox(height: 8),
              const _Callout(
                icon: Icons.warning_amber_rounded, color: kRed, bg: Color(0x11FF3D00),
                text: 'Sempre retorne Z primeiro! Mover X/Y com Z baixo = colisão com fixadores e peça.',
              ),
            ]),
          ),

          const SizedBox(height: 12),

          _ManualCard(
            titulo: 'G43/G44 — Compensação de Comprimento de Ferramenta',
            badge: 'TOOL LENGTH', badgeColor: kBlue,
            child: Column(children: [
              SizedBox(height: 180, child: CustomPaint(painter: _G43Painter(), size: const Size(double.infinity, 180))),
              const _CodeBox(lines: [
                _CodeLine('; T1 = fresa Ø10 com H1=125.5mm', true),
                _CodeLine('T1 M6      ; troca ferramenta', false),
                _CodeLine('G43 H1 Z5. ; aplica offset H1', false),
                _CodeLine('G0 X0 Y0   ; posiciona', false),
                _CodeLine('G49        ; cancela compensação', false),
              ]),
              const SizedBox(height: 8),
              _ParamTable(rows: const [
                ['G43 H+', 'Soma o offset ao Z — ferramenta mais longa'],
                ['G44 H-', 'Subtrai o offset do Z — ferramenta mais curta'],
                ['H', 'Número do registro de offset (H1 = offset 1)'],
                ['G49', 'Cancela compensação de comprimento'],
              ]),
            ]),
          ),
        ]))),
      ],
    );
  }
}

// ═══════════════════════════════════════════
// ABA 5 — PARÂMETROS DE CORTE
// ═══════════════════════════════════════════
class _TabParametros extends StatelessWidget {
  const _TabParametros();

  static const _dados = [
    ['🔩 Aço 1045', '120-180 HB', '80-150', '0.06-0.12', '3-6', 'Refrigeração recomendada'],
    ['⚡ Inox 304', '170-220 HB', '50-80', '0.04-0.08', '2-4', 'Nunca parar no corte'],
    ['✈️ Alumínio 6061', '60-120 HB', '200-400', '0.08-0.20', '8-20', 'Fresa 2 cortes hélice alta'],
    ['🏭 Ferro Fundido', '180-250 HB', '80-120', '0.08-0.15', '3-6', 'A SECO — sem fluido!'],
    ['🚀 Titânio Ti64', '300-380 HB', '30-60', '0.03-0.06', '1-3', 'Refrigeração alta pressão'],
    ['🥉 Bronze/Latão', '80-160 HB', '150-250', '0.10-0.20', '5-12', 'Seco ou lubrif. leve'],
    ['🧪 Plástico/Nylon', '— Shore', '100-200', '0.08-0.15', '5-15', 'Sem fluido — deforma'],
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: Column(children: [
          _SectionTitle(num: '05', titulo: 'Parâmetros de Corte', sub: 'Vc (velocidade de corte), fz (avanço/dente) e ap (profundidade) — o triângulo da usinagem.'),
          const SizedBox(height: 12),

          // Triângulo visual
          _ManualCard(
            titulo: 'O Triângulo da Usinagem',
            badge: 'FUNDAMENTAL', badgeColor: kAmber,
            child: Column(children: [
              SizedBox(height: 160, child: CustomPaint(painter: _TrianguloPainter(), size: const Size(double.infinity, 160))),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _InfoTile(icon: Icons.bolt_rounded, cor: kBlue, titulo: 'Vc — Velocidade', sub: 'Controla o CALOR. Alta = mais desgaste.')),
                const SizedBox(width: 6),
                Expanded(child: _InfoTile(icon: Icons.arrow_forward_rounded, cor: kGreen, titulo: 'fz — Avanço/dente', sub: 'Controla o CAVACO. Muito baixo = rubbing.')),
                const SizedBox(width: 6),
                Expanded(child: _InfoTile(icon: Icons.layers_rounded, cor: kRed, titulo: 'ap — Profundidade', sub: 'Controla o VOLUME removido.')),
              ]),
            ]),
          ),

          const SizedBox(height: 12),

          // Fórmulas
          _ManualCard(
            titulo: '📐 Fórmulas Essenciais',
            badge: 'CÁLCULO', badgeColor: kBlue,
            child: Column(children: [
              _FormulaBox(
                titulo: 'RPM (velocidade do spindle)',
                formula: 'n = (Vc × 1000) ÷ (π × D)',
                exemplo: 'Vc=100 m/min, D=10mm → n = 3183 RPM',
                cor: kBlue,
              ),
              const SizedBox(height: 10),
              _FormulaBox(
                titulo: 'Avanço da mesa (mm/min)',
                formula: 'Vf = fz × z × n',
                exemplo: 'fz=0.05, z=4 dentes, n=3183 → F = 637 mm/min',
                cor: kGreen,
              ),
              const SizedBox(height: 10),
              _FormulaBox(
                titulo: 'Velocidade de corte a partir do RPM',
                formula: 'Vc = (π × D × n) ÷ 1000',
                exemplo: 'D=20mm, n=1592 RPM → Vc = 100 m/min',
                cor: kAmber,
              ),
            ]),
          ),

          const SizedBox(height: 12),

          // Tabela por material
          _ManualCard(
            titulo: '📊 Tabela por Material — Fresamento Metal Duro',
            badge: 'REFERÊNCIA', badgeColor: kGreen,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Legenda
              Row(children: [
                _LegendaChip('Vc m/min', kBlue),
                const SizedBox(width: 6),
                _LegendaChip('fz mm/d', kGreen),
                const SizedBox(width: 6),
                _LegendaChip('ap mm', kRed),
              ]),
              const SizedBox(height: 10),
              // Tabela
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade100)),
                clipBehavior: Clip.hardEdge,
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2.2),
                    1: FlexColumnWidth(1.3),
                    2: FlexColumnWidth(1.2),
                    3: FlexColumnWidth(1.2),
                    4: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFF0D0D1A)),
                      children: [
                        _thCell('Material'), _thCell('Dureza'),
                        _thCell('Vc'), _thCell('fz'), _thCell('ap'),
                      ]),
                    ..._dados.asMap().entries.map((entry) {
                      final i = entry.key;
                      final d = entry.value;
                      return TableRow(
                        decoration: BoxDecoration(color: i.isOdd ? Colors.grey.shade50 : Colors.white),
                        children: [
                          _tdCell(d[0], Colors.black87, bold: true),
                          _tdCell(d[1], Colors.grey.shade500),
                          _tdCell(d[2], kBlue, bold: true),
                          _tdCell(d[3], const Color(0xFF2E7D32), bold: true),
                          _tdCell(d[4], kRed, bold: true),
                        ],
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const _Callout(
                icon: Icons.lightbulb_rounded, color: kAmber, bg: Color(0x1FFFCC02),
                text: 'Valores são pontos de partida. Ajuste ±20% conforme condição real da máquina, fixação e ferramenta.',
              ),
            ]),
          ),

          const SizedBox(height: 12),

          // Diagnóstico do cavaco
          _ManualCard(
            titulo: '🌀 Diagnóstico Visual pelo Cavaco',
            badge: 'PRÁTICO', badgeColor: kGreen,
            child: Column(children: [
              _CavacoDiag(emoji: '🌀', titulo: 'Cavaco espiral curto', desc: 'Parâmetros corretos ✅', cor: kGreen),
              _CavacoDiag(emoji: '🎀', titulo: 'Cavaco em fita longa', desc: 'fz baixo ou ap alto — ajustar avanço', cor: kAmber),
              _CavacoDiag(emoji: '🔵', titulo: 'Cavaco azul/queimado', desc: 'Vc muito alta — reduzir RPM urgente', cor: kRed),
              _CavacoDiag(emoji: '💔', titulo: 'Cavaco em pó (ferro fundido)', desc: 'Normal — mas use óculos e não inale', cor: Colors.grey.shade500),
              _CavacoDiag(emoji: '🪡', titulo: 'Cavaco em agulha fina', desc: 'fz muito baixo — rubbing desgasta fresa', cor: const Color(0xFFBA7517)),
            ]),
          ),
        ]))),
      ],
    );
  }

  static Widget _thCell(String t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    child: Text(t, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)));

  static Widget _tdCell(String t, Color c, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    child: Text(t, style: TextStyle(fontSize: 10, color: c, fontWeight: bold ? FontWeight.w700 : FontWeight.normal)));
}

// ─────────────────────────────────────────
// WIDGETS AUXILIARES
// ─────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String num, titulo, sub;
  const _SectionTitle({required this.num, required this.titulo, required this.sub});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('$num — ${titulo.toUpperCase()}',
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: kAmber, letterSpacing: 1.5)),
    const SizedBox(height: 4),
    Text(titulo, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: kDark)),
    const SizedBox(height: 4),
    Text(sub, style: const TextStyle(fontSize: 12, color: Colors.grey, height: 1.5)),
  ]);
}

class _ManualCard extends StatelessWidget {
  final String titulo;
  final String badge;
  final Color badgeColor;
  final Widget child;
  const _ManualCard({required this.titulo, required this.badge, required this.badgeColor, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade100),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Expanded(child: Text(titulo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kDark))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: badgeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
          child: Text(badge, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: badgeColor))),
      ]),
      const SizedBox(height: 12),
      child,
    ]),
  );
}

class _CodeLine {
  final String text;
  final bool isComment;
  const _CodeLine(this.text, this.isComment);
}

class _CodeBox extends StatelessWidget {
  final List<_CodeLine> lines;
  const _CodeBox({required this.lines});
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: const Color(0xFF0A0A16), borderRadius: BorderRadius.circular(8)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: lines.map((l) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Text(l.text,
        style: TextStyle(
          fontSize: 11, fontFamily: 'Courier',
          color: l.isComment ? const Color(0xFF556677) : const Color(0xFFA8D8A8),
          height: 1.6)),
    )).toList()),
  );
}

class _Callout extends StatelessWidget {
  final IconData icon;
  final Color color, bg;
  final String text;
  const _Callout({required this.icon, required this.color, required this.bg, required this.text});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8), border: Border.all(color: color.withValues(alpha: 0.25))),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: color, size: 16),
      const SizedBox(width: 8),
      Expanded(child: Text(text, style: TextStyle(fontSize: 12, color: color, height: 1.5))),
    ]),
  );
}

class _ParamTable extends StatelessWidget {
  final List<List<String>> rows;
  const _ParamTable({required this.rows});
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white, borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade100)),
    child: Column(children: rows.asMap().entries.map((e) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: e.key.isOdd ? Colors.grey.shade50 : Colors.white,
        borderRadius: e.key == 0
          ? const BorderRadius.vertical(top: Radius.circular(8))
          : e.key == rows.length - 1
            ? const BorderRadius.vertical(bottom: Radius.circular(8))
            : BorderRadius.zero),
      child: Row(children: [
        SizedBox(width: 36, child: Text(e.value[0], style: const TextStyle(fontWeight: FontWeight.w700, color: kAmber, fontSize: 12, fontFamily: 'Courier'))),
        const SizedBox(width: 8),
        Expanded(child: Text(e.value[1], style: const TextStyle(fontSize: 11, color: Color(0xFF444444)))),
      ]),
    )).toList()),
  );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color cor;
  final String titulo, sub;
  const _InfoTile({required this.icon, required this.cor, required this.titulo, required this.sub});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: cor.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: cor.withValues(alpha: 0.2))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: cor, size: 18),
      const SizedBox(height: 4),
      Text(titulo, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: cor)),
      const SizedBox(height: 2),
      Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey, height: 1.4)),
    ]),
  );
}

class _FormulaBox extends StatelessWidget {
  final String titulo, formula, exemplo;
  final Color cor;
  const _FormulaBox({required this.titulo, required this.formula, required this.exemplo, required this.cor});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFF0A0A16),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: cor.withValues(alpha: 0.3))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(titulo, style: TextStyle(fontSize: 10, color: cor.withValues(alpha: 0.7), letterSpacing: .5)),
      const SizedBox(height: 6),
      Text(formula, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: cor, fontFamily: 'Courier')),
      const SizedBox(height: 6),
      Text(exemplo, style: const TextStyle(fontSize: 11, color: Color(0xFF8888A8), height: 1.4)),
    ]),
  );
}

// ─────────────────────────────────────────
// WIDGET — IMAGEM CNC COM LEGENDA
// ─────────────────────────────────────────
class _CncImage extends StatelessWidget {
  final String asset;
  final String legenda;
  final double height;
  const _CncImage({required this.asset, required this.legenda, this.height = 200});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          asset,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B2A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF2A3A5A)),
            ),
            child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Icon(Icons.image_not_supported_outlined, color: Color(0xFF445566), size: 36),
              const SizedBox(height: 8),
              Text(legenda, style: const TextStyle(color: Color(0xFF445566), fontSize: 11), textAlign: TextAlign.center),
            ])),
          ),
        ),
      ),
      if (legenda.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 4, 0),
          child: Text(legenda, style: const TextStyle(color: Color(0xFF6677AA), fontSize: 10, fontStyle: FontStyle.italic)),
        ),
    ],
  );
}

Widget _LegendaChip(String t, Color c) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  decoration: BoxDecoration(color: c.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: c.withValues(alpha: 0.3))),
  child: Text(t, style: TextStyle(fontSize: 10, color: c, fontWeight: FontWeight.w600)));

class _CavacoDiag extends StatelessWidget {
  final String emoji, titulo, desc;
  final Color cor;
  const _CavacoDiag({required this.emoji, required this.titulo, required this.desc, required this.cor});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Text(emoji, style: const TextStyle(fontSize: 22)),
      const SizedBox(width: 10),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(titulo, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cor)),
        Text(desc, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ]),
    ]),
  );
}

// ─────────────────────────────────────────
// CUSTOM PAINTERS — DIAGRAMAS
// ─────────────────────────────────────────

class _G02Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) * 0.7;

    // Eixos
    final axisPaint = Paint()..color = const Color(0xFFCCCCDD)..strokeWidth = 0.8;
    canvas.drawLine(Offset(10, cy), Offset(size.width - 10, cy), axisPaint);
    canvas.drawLine(Offset(cx, 10), Offset(cx, size.height - 10), axisPaint);
    // Labels eixos
    _text(canvas, 'X', size.width - 14, cy - 8, const Color(0xFF888888), 9);
    _text(canvas, 'Y', cx + 4, 10, const Color(0xFF888888), 9);

    // Centro
    final centerX = cx;
    final centerY = cy;
    // Ponto inicial A (esquerda)
    final ax = cx - r;
    final ay = cy;
    // Ponto final B (direita)
    final bx = cx + r;
    final by = cy;

    // Arco G02 (horário) — parte superior
    final arcPaint = Paint()..color = kBlue..strokeWidth = 2.5..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: r),
      math.pi, math.pi, false, arcPaint);

    // Centro
    final centerPaint = Paint()..color = kAmber;
    canvas.drawCircle(Offset(centerX, centerY), 4, centerPaint);
    _text(canvas, 'Centro', centerX + 6, centerY - 10, kAmber, 9);

    // Raio tracejado
    final radiusPaint = Paint()..color = kAmber.withValues(alpha: 0.5)..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    _dashedLine(canvas, Offset(centerX, centerY), Offset(ax, ay), radiusPaint);
    _text(canvas, 'R', cx - r / 2 - 4, cy - 10, kAmber, 9);

    // Ponto A
    canvas.drawCircle(Offset(ax, ay), 5, Paint()..color = kRed);
    _text(canvas, 'A (início)', ax - 14, ay + 14, kRed, 9);

    // Ponto B
    canvas.drawCircle(Offset(bx, by), 5, Paint()..color = kGreen);
    _text(canvas, 'B (fim)', bx - 8, by + 14, kGreen, 9);

    // Seta rotação CW
    _text(canvas, '↻', centerX - 10, centerY - 20, kBlue, 22);
    _text(canvas, 'CW', centerX - 8, centerY + 2, kBlue, 10);

    // I tracejado
    final iPaint = Paint()..color = const Color(0xFFFF8A65)..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    _dashedLine(canvas, Offset(ax, ay), Offset(centerX, centerY), iPaint);
    _text(canvas, 'I=+${r.toInt()}', ax + 8, ay - 12, const Color(0xFFFF8A65), 9);
  }

  @override bool shouldRepaint(_) => false;
}

class _G03Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = math.min(cx, cy) * 0.7;

    final axisPaint = Paint()..color = const Color(0xFFCCCCDD)..strokeWidth = 0.8;
    canvas.drawLine(Offset(10, cy), Offset(size.width - 10, cy), axisPaint);
    canvas.drawLine(Offset(cx, 10), Offset(cx, size.height - 10), axisPaint);
    _text(canvas, 'X', size.width - 14, cy - 8, const Color(0xFF888888), 9);
    _text(canvas, 'Y', cx + 4, 10, const Color(0xFF888888), 9);

    final ax = cx - r; final bx = cx + r;

    // Arco G03 (anti-horário) — parte inferior
    final arcPaint = Paint()..color = kGreen..strokeWidth = 2.5..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      0, math.pi, false, arcPaint);

    canvas.drawCircle(Offset(cx, cy), 4, Paint()..color = kAmber);
    _text(canvas, 'Centro', cx + 6, cy - 10, kAmber, 9);
    _dashedLine(canvas, Offset(cx, cy), Offset(bx, cy),
      Paint()..color = kAmber.withValues(alpha: 0.5)..strokeWidth = 1.2..style = PaintingStyle.stroke);
    _text(canvas, 'R', cx + r / 2 - 4, cy - 10, kAmber, 9);

    canvas.drawCircle(Offset(ax, cy), 5, Paint()..color = kRed);
    _text(canvas, 'A (início)', ax - 14, cy + 14, kRed, 9);
    canvas.drawCircle(Offset(bx, cy), 5, Paint()..color = kGreen);
    _text(canvas, 'B (fim)', bx - 8, cy + 14, kGreen, 9);

    _text(canvas, '↺', cx - 10, cy - 24, kGreen, 22);
    _text(canvas, 'CCW', cx - 10, cy - 2, kGreen, 10);

    _dashedLine(canvas, Offset(ax, cy), Offset(cx, cy),
      Paint()..color = const Color(0xFFFF8A65)..strokeWidth = 1.5..style = PaintingStyle.stroke);
    _text(canvas, 'I=+${r.toInt()}', ax + 8, cy - 12, const Color(0xFFFF8A65), 9);
  }
  @override bool shouldRepaint(_) => false;
}

class _RPosiNegaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;

    // Linha divisória
    final divPaint = Paint()..color = const Color(0xFF333355)..strokeWidth = 1..style = PaintingStyle.stroke;
    _dashedLine(canvas, Offset(w / 2, 10), Offset(w / 2, h - 10), divPaint);

    // === LADO ESQUERDO: R+ (arco curto < 180) ===
    final ax = w * 0.12; final bx = w * 0.38;
    final cy = h * 0.55;
    final r1 = (bx - ax) * 0.75;

    _text(canvas, 'R+50  →  arco curto (<180°)', ax, 14, kBlue, 10);
    canvas.drawCircle(Offset(ax, cy), 5, Paint()..color = kRed);
    canvas.drawCircle(Offset(bx, cy), 5, Paint()..color = kGreen);
    _text(canvas, 'A', ax - 4, cy + 12, kRed, 9);
    _text(canvas, 'B', bx - 4, cy + 12, kGreen, 9);

    final arcPaintBlue = Paint()..color = kBlue..strokeWidth = 2.5..style = PaintingStyle.stroke;
    final cx1 = (ax + bx) / 2;
    final r1c = (bx - ax) / 2;
    canvas.drawArc(Rect.fromCircle(center: Offset(cx1, cy), radius: r1c * 1.4),
      -math.pi * 0.85, math.pi * 0.85, false, arcPaintBlue);
    _text(canvas, 'caminho curto', cx1 - 28, cy + 30, kBlue, 9);

    // === LADO DIREITO: R- (arco longo > 180) ===
    final ax2 = w * 0.58; final bx2 = w * 0.88;
    final cx2 = (ax2 + bx2) / 2;
    final r2 = (bx2 - ax2) / 2;

    _text(canvas, 'R−50  →  arco longo (>180°)', ax2 - 4, 14, const Color(0xFFFF8A65), 10);
    canvas.drawCircle(Offset(ax2, cy), 5, Paint()..color = kRed);
    canvas.drawCircle(Offset(bx2, cy), 5, Paint()..color = kGreen);
    _text(canvas, 'A', ax2 - 4, cy + 12, kRed, 9);
    _text(canvas, 'B', bx2 - 4, cy + 12, kGreen, 9);

    final arcPaintOrange = Paint()..color = const Color(0xFFFF8A65)..strokeWidth = 2.5..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCircle(center: Offset(cx2, cy - r2 * 0.3), radius: r2 * 1.5),
      math.pi * 0.1, -math.pi * 1.5, false, arcPaintOrange);
    _text(canvas, 'caminho longo', cx2 - 28, 45, const Color(0xFFFF8A65), 9);
  }
  @override bool shouldRepaint(_) => false;
}

class _IJPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2 - 20;
    final cy = size.height / 2 + 10;
    final r = 55.0;

    final axisPaint = Paint()..color = const Color(0xFFCCCCDD)..strokeWidth = 0.7;
    canvas.drawLine(Offset(20, cy), Offset(size.width - 10, cy), axisPaint);
    canvas.drawLine(Offset(cx + 20, 10), Offset(cx + 20, size.height - 10), axisPaint);

    final ax = cx - r; final ay = cy;
    final endX = cx; final endY = cy - r;

    // Arco do início (ax,ay) ao fim (endX, endY)
    final arcPaint = Paint()..color = kBlue..strokeWidth = 2.5..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r),
      math.pi, -math.pi / 2, false, arcPaint);

    // Centro
    canvas.drawCircle(Offset(cx, cy), 4, Paint()..color = kAmber);
    _text(canvas, 'Centro', cx + 6, cy - 8, kAmber, 9);

    // Ponto inicial
    canvas.drawCircle(Offset(ax, ay), 5, Paint()..color = kRed);
    _text(canvas, 'início', ax - 4, ay + 12, kRed, 9);

    // Ponto final
    canvas.drawCircle(Offset(endX, endY), 5, Paint()..color = kGreen);
    _text(canvas, 'fim', endX + 6, endY - 4, kGreen, 9);

    // Vetor I (horizontal)
    final iPaint = Paint()..color = const Color(0xFFFF8A65)..strokeWidth = 2;
    canvas.drawLine(Offset(ax, ay), Offset(cx, ay), iPaint);
    canvas.drawCircle(Offset(cx, ay), 2, iPaint);
    _text(canvas, 'I = +(${r.toInt()})', ax + 6, ay - 12, const Color(0xFFFF8A65), 10);

    // Vetor J (vertical)
    final jPaint = Paint()..color = const Color(0xFFA5D6A7)..strokeWidth = 2;
    canvas.drawLine(Offset(ax, ay), Offset(ax, cy), jPaint);
    _text(canvas, 'J = 0', ax - 28, ay - r / 2, const Color(0xFFA5D6A7), 10);

    // Raio tracejado
    _dashedLine(canvas, Offset(cx, cy), Offset(endX, endY),
      Paint()..color = kAmber.withValues(alpha: 0.5)..strokeWidth = 1.2..style = PaintingStyle.stroke);
    _text(canvas, 'R=${r.toInt()}', cx + 6, (cy + endY) / 2, kAmber, 9);

    // Labels
    _text(canvas, 'X', size.width - 14, cy - 8, const Color(0xFF888888), 9);
    _text(canvas, 'Y', cx + 26, 12, const Color(0xFF888888), 9);
  }
  @override bool shouldRepaint(_) => false;
}

class _G81Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    final cx = w / 2;

    // Peça
    final pecaPaint = Paint()..color = const Color(0xFFE8EAF6)..style = PaintingStyle.fill;
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(10, h * 0.4, w - 20, h * 0.52), const Radius.circular(4)), pecaPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(10, h * 0.4, w - 20, h * 0.52), const Radius.circular(4)),
      Paint()..color = Colors.grey.shade300..style = PaintingStyle.stroke..strokeWidth = 1);
    _text(canvas, 'PEÇA', cx - 14, h * 0.6, Colors.grey.shade400, 10);

    // Furo
    final furoPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(cx - 12, h * 0.4, 24, h * 0.45), furoPaint);

    // Plano R (pontilhado amarelo)
    _dashedLine(canvas, Offset(8, h * 0.32), Offset(w - 8, h * 0.32),
      Paint()..color = kAmber..strokeWidth = 1.2..style = PaintingStyle.stroke);
    _text(canvas, 'Plano R', w - 42, h * 0.30, kAmber, 8);

    // Plano inicial
    _dashedLine(canvas, Offset(8, h * 0.12), Offset(w - 8, h * 0.12),
      Paint()..color = Colors.grey..strokeWidth = 0.8..style = PaintingStyle.stroke);
    _text(canvas, 'Plano Inicial', w - 54, h * 0.10, Colors.grey, 8);

    // Ferramenta
    final toolPaint = Paint()..color = kBlue..style = PaintingStyle.fill;
    final toolRect = RRect.fromRectAndRadius(Rect.fromLTWH(cx - 7, h * 0.05, 14, h * 0.25), const Radius.circular(2));
    canvas.drawRRect(toolRect, toolPaint);
    final path = Path()..moveTo(cx - 7, h * 0.30)..lineTo(cx, h * 0.36)..lineTo(cx + 7, h * 0.30);
    canvas.drawPath(path, toolPaint);

    // Seta descida (verde)
    _arrow(canvas, Offset(cx, h * 0.36), Offset(cx, h * 0.84), kGreen, 2.0);
    _text(canvas, 'F', cx + 4, h * 0.62, kGreen, 10);

    // Seta subida (vermelho tracejado)
    final upPaint = Paint()..color = kRed..strokeWidth = 1.5..style = PaintingStyle.stroke;
    _dashedLine(canvas, Offset(cx + 4, h * 0.84), Offset(cx + 4, h * 0.30), upPaint);
    _text(canvas, 'G00', cx + 7, h * 0.5, kRed, 8);

    // Z final
    _dashedLine(canvas, Offset(8, h * 0.85), Offset(cx - 12, h * 0.85),
      Paint()..color = const Color(0xFFFF8A65)..strokeWidth = 0.8..style = PaintingStyle.stroke);
    _text(canvas, 'Z', 10, h * 0.83, const Color(0xFFFF8A65), 8);
  }
  @override bool shouldRepaint(_) => false;
}

class _G83Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    final cx = w / 2;

    // Peça
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(8, h * 0.30, w - 16, h * 0.64), const Radius.circular(4)),
      Paint()..color = const Color(0xFFE8EAF6));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(8, h * 0.30, w - 16, h * 0.64), const Radius.circular(4)),
      Paint()..color = Colors.grey.shade300..style = PaintingStyle.stroke..strokeWidth = 1);

    // Furo
    canvas.drawRect(Rect.fromLTWH(cx - 11, h * 0.30, 22, h * 0.62), Paint()..color = Colors.white);

    // Plano R
    _dashedLine(canvas, Offset(6, h * 0.22), Offset(w - 6, h * 0.22),
      Paint()..color = kAmber..strokeWidth = 1..style = PaintingStyle.stroke);
    _text(canvas, 'R', w - 14, h * 0.20, kAmber, 8);

    // Ferramenta no topo
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 6, h * 0.02, 12, h * 0.18), const Radius.circular(2)),
      Paint()..color = kBlue);
    final tp = Path()..moveTo(cx - 6, h * 0.20)..lineTo(cx, h * 0.26)..lineTo(cx + 6, h * 0.20);
    canvas.drawPath(tp, Paint()..color = kBlue);

    // Linhas horizontais de peck
    final peckPositions = [h * 0.45, h * 0.58, h * 0.72, h * 0.86];
    final peckLabels = ['1º peck', '2º peck', '3º peck', 'Z final'];
    final peckColors = [kBlue, kBlue, kBlue, const Color(0xFFFF8A65)];

    for (int i = 0; i < peckPositions.length; i++) {
      _dashedLine(canvas, Offset(6, peckPositions[i]), Offset(cx - 11, peckPositions[i]),
        Paint()..color = peckColors[i]..strokeWidth = 0.8..style = PaintingStyle.stroke);
      _text(canvas, peckLabels[i], 8, peckPositions[i] - 9, peckColors[i], 8);
    }

    // Setas de descida e subida para cada peck
    double posY = h * 0.26;
    for (int i = 0; i < 3; i++) {
      // descida
      _arrow(canvas, Offset(cx, posY), Offset(cx, peckPositions[i]), kBlue, 2.0);
      // subida tracejada
      final upPaint = Paint()..color = kRed..strokeWidth = 1.2..style = PaintingStyle.stroke;
      _dashedLine(canvas, Offset(cx + 4, peckPositions[i]), Offset(cx + 4, h * 0.22), upPaint);
      posY = h * 0.22;
    }
    // Último peck — descida final
    _arrow(canvas, Offset(cx, posY), Offset(cx, peckPositions[3]), kGreen, 2.0);
    // Última subida
    _dashedLine(canvas, Offset(cx + 4, peckPositions[3]), Offset(cx + 4, h * 0.22),
      Paint()..color = kRed..strokeWidth = 1.2..style = PaintingStyle.stroke);
  }
  @override bool shouldRepaint(_) => false;
}

class _G84Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    final cx = w / 2;

    // Peça
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(8, h * 0.38, w - 16, h * 0.54), const Radius.circular(4)),
      Paint()..color = const Color(0xFFE8EAF6));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(8, h * 0.38, w - 16, h * 0.54), const Radius.circular(4)),
      Paint()..color = Colors.grey.shade300..style = PaintingStyle.stroke..strokeWidth = 1);

    // Furo com rosca visual
    canvas.drawRect(Rect.fromLTWH(cx - 11, h * 0.38, 22, h * 0.50), Paint()..color = Colors.white);
    for (int i = 0; i < 7; i++) {
      final y = h * 0.42 + i * (h * 0.05);
      canvas.drawLine(Offset(cx - 11, y), Offset(cx + 11, y),
        Paint()..color = Colors.grey.shade300..strokeWidth = 0.8);
    }

    // Macho
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 7, h * 0.05, 14, h * 0.30), const Radius.circular(2)),
      Paint()..color = kBlue.withValues(alpha: 0.8));
    final mp = Path()..moveTo(cx - 7, h * 0.35)..lineTo(cx, h * 0.40)..lineTo(cx + 7, h * 0.35);
    canvas.drawPath(mp, Paint()..color = kBlue);

    // Plano R
    _dashedLine(canvas, Offset(6, h * 0.30), Offset(w - 6, h * 0.30),
      Paint()..color = kAmber..strokeWidth = 1..style = PaintingStyle.stroke);
    _text(canvas, 'Plano R', w - 38, h * 0.28, kAmber, 8);

    // Seta M3 descida
    _arrow(canvas, Offset(cx + 16, h * 0.40), Offset(cx + 16, h * 0.82), kBlue, 2.0);
    _text(canvas, 'M3↓', cx + 20, h * 0.62, kBlue, 9);

    // Seta M4 subida
    _dashedLine(canvas, Offset(cx - 16, h * 0.82), Offset(cx - 16, h * 0.30),
      Paint()..color = kRed..strokeWidth = 2..style = PaintingStyle.stroke);
    _arrow(canvas, Offset(cx - 16, h * 0.40), Offset(cx - 16, h * 0.30), kRed, 2.0);
    _text(canvas, 'M4↑', cx - 36, h * 0.55, kRed, 9);

    // Fórmula F
    _text(canvas, 'F = RPM × Passo', 12, h * 0.96, const Color(0xFF69F0AE), 10);
  }
  @override bool shouldRepaint(_) => false;
}

class _G41Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    final margin = 28.0;
    final offset = 16.0;

    // Contorno programado (amarelo tracejado)
    final contornoPaint = Paint()..color = kAmber.withValues(alpha: 0.6)..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    _dashedLine(canvas, Offset(margin + offset, margin + offset), Offset(w - margin - offset, margin + offset), contornoPaint);
    _dashedLine(canvas, Offset(w - margin - offset, margin + offset), Offset(w - margin - offset, h - margin - offset), contornoPaint);
    _dashedLine(canvas, Offset(w - margin - offset, h - margin - offset), Offset(margin + offset, h - margin - offset), contornoPaint);
    _dashedLine(canvas, Offset(margin + offset, h - margin - offset), Offset(margin + offset, margin + offset), contornoPaint);
    _text(canvas, 'Contorno programado', margin + 24, h * 0.5, kAmber.withValues(alpha: 0.7), 9);

    // Caminho real da fresa (azul sólido, mais externo)
    final frPaint = Paint()..color = kBlue..strokeWidth = 2.2..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(margin, margin, w - margin * 2, h - margin * 2), frPaint);

    // Fresa no canto superior esquerdo
    canvas.drawCircle(Offset(margin, margin), 15, Paint()..color = kBlue.withValues(alpha: 0.15)..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(margin, margin), 15, Paint()..color = kBlue..strokeWidth = 1.5..style = PaintingStyle.stroke);
    canvas.drawCircle(Offset(margin, margin), 2.5, Paint()..color = kBlue);

    // Seta de direção
    _arrow(canvas, Offset(w - margin, margin + 10), Offset(w - margin, h / 2), kGreen, 2.0);

    // Labels
    _text(canvas, 'G41 (esquerda)', margin, h - 14, kBlue, 9);
    _text(canvas, 'R = D/2', margin + 18, margin - 4, const Color(0xFFFF8A65), 8);
    _line(canvas, Offset(margin, margin), Offset(margin + 15, margin),
      Paint()..color = const Color(0xFFFF8A65)..strokeWidth = 1.5);
  }
  void _line(Canvas c, Offset a, Offset b, Paint p) => c.drawLine(a, b, p);
  @override bool shouldRepaint(_) => false;
}

class _G42Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    final margin = 28.0;
    final offset = 16.0;
    final purple = const Color(0xFF9C27B0);

    _dashedLine(canvas, Offset(margin, margin), Offset(w - margin, margin),
      Paint()..color = kAmber.withValues(alpha: 0.6)..strokeWidth = 1.5..style = PaintingStyle.stroke);
    _dashedLine(canvas, Offset(w - margin, margin), Offset(w - margin, h - margin),
      Paint()..color = kAmber.withValues(alpha: 0.6)..strokeWidth = 1.5..style = PaintingStyle.stroke);
    _dashedLine(canvas, Offset(w - margin, h - margin), Offset(margin, h - margin),
      Paint()..color = kAmber.withValues(alpha: 0.6)..strokeWidth = 1.5..style = PaintingStyle.stroke);
    _dashedLine(canvas, Offset(margin, h - margin), Offset(margin, margin),
      Paint()..color = kAmber.withValues(alpha: 0.6)..strokeWidth = 1.5..style = PaintingStyle.stroke);
    _text(canvas, 'Contorno programado', margin + 8, h * 0.5, kAmber.withValues(alpha: 0.7), 9);

    final frPaint = Paint()..color = purple..strokeWidth = 2.2..style = PaintingStyle.stroke;
    canvas.drawRect(Rect.fromLTWH(margin + offset, margin + offset, w - (margin + offset) * 2, h - (margin + offset) * 2), frPaint);

    canvas.drawCircle(Offset(margin + offset, margin + offset), 15,
      Paint()..color = purple.withValues(alpha: 0.15)..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(margin + offset, margin + offset), 15,
      Paint()..color = purple..strokeWidth = 1.5..style = PaintingStyle.stroke);
    canvas.drawCircle(Offset(margin + offset, margin + offset), 2.5, Paint()..color = purple);

    _arrow(canvas, Offset(w - margin - offset, margin + offset + 10),
      Offset(w - margin - offset, h / 2), kGreen, 2.0);

    _text(canvas, 'G42 (direita)', margin + offset + 4, h - 14, purple, 9);
    _text(canvas, 'R = D/2', margin + offset + 18, margin + offset - 4, const Color(0xFFFF8A65), 8);
  }
  @override bool shouldRepaint(_) => false;
}

class _G41G42RegPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    final midX = w / 2; final midY = h / 2;

    // Linha divisória
    canvas.drawLine(Offset(midX, 10), Offset(midX, h - 10),
      Paint()..color = const Color(0xFF333355)..strokeWidth = 1..style = PaintingStyle.stroke);

    // === G41 LADO ESQUERDO ===
    _text(canvas, 'G41', midX * 0.45, 14, kAmber, 13);
    // Seta de avanço
    _arrow(canvas, Offset(30, midY), Offset(midX - 15, midY), kGreen, 2.5);
    _text(canvas, '→ avanço', 50, midY + 12, kGreen, 9);
    // Fresa acima (à esquerda da direção de avanço)
    canvas.drawCircle(Offset(midX * 0.5, midY - 32), 22,
      Paint()..color = kBlue.withValues(alpha: 0.15));
    canvas.drawCircle(Offset(midX * 0.5, midY - 32), 22,
      Paint()..color = kBlue..strokeWidth = 1.8..style = PaintingStyle.stroke);
    _text(canvas, 'FRESA', midX * 0.5 - 16, midY - 35, kBlue, 9);
    _text(canvas, 'ESQUERDA', midX * 0.5 - 20, midY - 22, kBlue, 8);
    // Linha de conexão
    canvas.drawLine(Offset(midX * 0.5, midY - 10), Offset(midX * 0.5, midY),
      Paint()..color = kBlue..strokeWidth = 1.2..style = PaintingStyle.stroke);

    // === G42 LADO DIREITO ===
    _text(canvas, 'G42', midX * 1.42, 14, kAmber, 13);
    _arrow(canvas, Offset(midX + 15, midY), Offset(w - 30, midY), kGreen, 2.5);
    _text(canvas, '→ avanço', midX + 30, midY + 12, kGreen, 9);
    // Fresa abaixo (à direita)
    final purple = const Color(0xFF9C27B0);
    canvas.drawCircle(Offset(midX * 1.5, midY + 32), 22, Paint()..color = purple.withValues(alpha: 0.15));
    canvas.drawCircle(Offset(midX * 1.5, midY + 32), 22,
      Paint()..color = purple..strokeWidth = 1.8..style = PaintingStyle.stroke);
    _text(canvas, 'FRESA', midX * 1.5 - 14, midY + 29, purple, 9);
    _text(canvas, 'DIREITA', midX * 1.5 - 14, midY + 42, purple, 8);
    canvas.drawLine(Offset(midX * 1.5, midY), Offset(midX * 1.5, midY + 10),
      Paint()..color = purple..strokeWidth = 1.2..style = PaintingStyle.stroke);
  }
  @override bool shouldRepaint(_) => false;
}

class _G54Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;

    // Mesa da máquina
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(10, h * 0.6, w - 20, h * 0.3), const Radius.circular(4)),
      Paint()..color = const Color(0xFFE0E0E0));

    // Peça 1 (G54)
    canvas.drawRect(Rect.fromLTWH(20, h * 0.38, w * 0.28, h * 0.24),
      Paint()..color = kBlue.withValues(alpha: 0.15));
    canvas.drawRect(Rect.fromLTWH(20, h * 0.38, w * 0.28, h * 0.24),
      Paint()..color = kBlue..strokeWidth = 1.5..style = PaintingStyle.stroke);
    canvas.drawCircle(Offset(20, h * 0.38), 5, Paint()..color = kBlue);
    _text(canvas, 'G54', 24, h * 0.34, kBlue, 10);
    _text(canvas, 'Zero-peça 1', 14, h * 0.28, kBlue, 8);

    // Peça 2 (G55)
    canvas.drawRect(Rect.fromLTWH(w * 0.36, h * 0.38, w * 0.28, h * 0.24),
      Paint()..color = kGreen.withValues(alpha: 0.15));
    canvas.drawRect(Rect.fromLTWH(w * 0.36, h * 0.38, w * 0.28, h * 0.24),
      Paint()..color = kGreen..strokeWidth = 1.5..style = PaintingStyle.stroke);
    canvas.drawCircle(Offset(w * 0.36, h * 0.38), 5, Paint()..color = kGreen);
    _text(canvas, 'G55', w * 0.36 + 4, h * 0.34, kGreen, 10);
    _text(canvas, 'Zero-peça 2', w * 0.34, h * 0.28, kGreen, 8);

    // Peça 3 (G56)
    canvas.drawRect(Rect.fromLTWH(w * 0.68, h * 0.38, w * 0.22, h * 0.24),
      Paint()..color = kAmber.withValues(alpha: 0.15));
    canvas.drawRect(Rect.fromLTWH(w * 0.68, h * 0.38, w * 0.22, h * 0.24),
      Paint()..color = kAmber..strokeWidth = 1.5..style = PaintingStyle.stroke);
    canvas.drawCircle(Offset(w * 0.68, h * 0.38), 5, Paint()..color = kAmber);
    _text(canvas, 'G56', w * 0.68 + 4, h * 0.34, kAmber, 10);

    // Home da máquina
    canvas.drawCircle(Offset(w - 14, 14), 8, Paint()..color = kRed.withValues(alpha: 0.2));
    canvas.drawCircle(Offset(w - 14, 14), 8, Paint()..color = kRed..strokeWidth = 1.5..style = PaintingStyle.stroke);
    _text(canvas, 'HOME', w - 36, 26, kRed, 8);

    // Linha do home ao G54
    _dashedLine(canvas, Offset(w - 14, 22), Offset(20, h * 0.38),
      Paint()..color = Colors.grey.shade400..strokeWidth = 0.8..style = PaintingStyle.stroke);

    _text(canvas, 'Eixo X', w - 20, h * 0.92, Colors.grey.shade500, 9);
    _text(canvas, 'Máquina pode ter até 6 zeros de peça simultâneos', 10, h * 0.98, Colors.grey.shade400, 8);
  }
  @override bool shouldRepaint(_) => false;
}

class _G28Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    final cx = w / 2;

    // Peça
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(20, h * 0.6, w - 40, h * 0.3), const Radius.circular(4)),
      Paint()..color = const Color(0xFFE8EAF6));

    // Home position
    canvas.drawCircle(Offset(cx, 20), 12, Paint()..color = kRed.withValues(alpha: 0.15));
    canvas.drawCircle(Offset(cx, 20), 12, Paint()..color = kRed..strokeWidth = 2..style = PaintingStyle.stroke);
    _text(canvas, 'HOME', cx - 12, 26, kRed, 9);

    // Ferramenta atual (baixo)
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 7, h * 0.45, 14, h * 0.14), const Radius.circular(2)),
      Paint()..color = kBlue.withValues(alpha: 0.8));

    // Ponto intermediário
    canvas.drawCircle(Offset(cx, h * 0.30), 5, Paint()..color = kAmber);
    _text(canvas, 'Ponto intermediário', cx - 52, h * 0.26, kAmber, 9);

    // Seta: ferramenta → intermediário
    _arrow(canvas, Offset(cx, h * 0.44), Offset(cx, h * 0.33), kGreen, 2.0);
    _text(canvas, '1°: Z sobe', cx + 8, h * 0.38, kGreen, 9);

    // Seta: intermediário → home
    _arrow(canvas, Offset(cx - 4, h * 0.30), Offset(cx - 4, 34), kBlue, 2.0);
    _text(canvas, '2°: vai ao HOME', cx - 52, h * 0.15, kBlue, 9);

    _text(canvas, 'G28 Z0. → G28 X0 Y0', 14, h * 0.95, Colors.grey.shade500, 9);
  }
  @override bool shouldRepaint(_) => false;
}

class _G43Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    final cx = w / 2;

    // Peça
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(10, h * 0.7, w - 20, h * 0.22), const Radius.circular(4)),
      Paint()..color = const Color(0xFFE8EAF6));
    _text(canvas, 'PEÇA (Z=0)', cx - 24, h * 0.78, Colors.grey.shade500, 9);

    // Z=0 da máquina (topo)
    _dashedLine(canvas, Offset(10, h * 0.08), Offset(w - 10, h * 0.08),
      Paint()..color = Colors.grey..strokeWidth = 0.8..style = PaintingStyle.stroke);
    _text(canvas, 'Z máquina = 0', w - 70, h * 0.06, Colors.grey, 8);

    // Ferramenta curta (T1)
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 30, h * 0.08, 14, h * 0.45), const Radius.circular(2)),
      Paint()..color = kBlue.withValues(alpha: 0.7));
    final p1 = Path()..moveTo(cx - 30, h * 0.53)..lineTo(cx - 23, h * 0.62)..lineTo(cx - 16, h * 0.53);
    canvas.drawPath(p1, Paint()..color = kBlue.withValues(alpha: 0.7));
    _text(canvas, 'T1 H1=80mm', cx - 50, h * 0.65, kBlue, 8);

    // Ferramenta longa (T2)
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx + 16, h * 0.08, 14, h * 0.58), const Radius.circular(2)),
      Paint()..color = kGreen.withValues(alpha: 0.7));
    final p2 = Path()..moveTo(cx + 16, h * 0.66)..lineTo(cx + 23, h * 0.72)..lineTo(cx + 30, h * 0.66);
    canvas.drawPath(p2, Paint()..color = kGreen.withValues(alpha: 0.7));
    _text(canvas, 'T2 H2=120mm', cx + 12, h * 0.79, kGreen, 8);

    // Setas de comprimento
    _arrow(canvas, Offset(cx - 23, h * 0.08), Offset(cx - 23, h * 0.62), kBlue, 1.5);
    _text(canvas, 'H1', cx - 14, h * 0.34, kBlue, 9);
    _arrow(canvas, Offset(cx + 38, h * 0.08), Offset(cx + 38, h * 0.70), kGreen, 1.5);
    _text(canvas, 'H2', cx + 40, h * 0.38, kGreen, 9);

    _text(canvas, 'G43 ajusta Z para compensar comprimento diferente', 10, h * 0.96, Colors.grey.shade400, 8);
  }
  @override bool shouldRepaint(_) => false;
}

class _TrianguloPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    final r = math.min(w, h) * 0.25;

    // 3 círculos do triângulo
    final centers = [
      Offset(w * 0.20, h * 0.55),
      Offset(w * 0.50, h * 0.55),
      Offset(w * 0.80, h * 0.55),
    ];
    final colors = [kBlue, kGreen, kRed];
    final labels = ['Vc', 'fz', 'ap'];
    final sublabels = ['Velocidade\nm/min', 'Avanço/dente\nmm/d', 'Profundidade\nmm'];

    for (int i = 0; i < 3; i++) {
      canvas.drawCircle(centers[i], r, Paint()..color = colors[i].withValues(alpha: 0.12));
      canvas.drawCircle(centers[i], r, Paint()..color = colors[i]..strokeWidth = 2..style = PaintingStyle.stroke);
      _textCentered(canvas, labels[i], centers[i].dx, centers[i].dy - 8, colors[i], 20, bold: true);
    }

    // Linhas de conexão
    for (int i = 0; i < 3; i++) {
      for (int j = i + 1; j < 3; j++) {
        canvas.drawLine(
          _pointOnCircle(centers[i], r, _angleTo(centers[i], centers[j])),
          _pointOnCircle(centers[j], r, _angleTo(centers[j], centers[i])),
          Paint()..color = Colors.grey.shade300..strokeWidth = 1.2..style = PaintingStyle.stroke);
      }
    }

    // Labels secundários
    for (int i = 0; i < 3; i++) {
      _textCentered(canvas, sublabels[i].split('\n')[0], centers[i].dx, centers[i].dy + 8, colors[i].withValues(alpha: 0.7), 9);
      _textCentered(canvas, sublabels[i].split('\n')[1], centers[i].dx, centers[i].dy + 19, Colors.grey.shade400, 8);
    }
  }

  double _angleTo(Offset from, Offset to) => math.atan2(to.dy - from.dy, to.dx - from.dx);
  Offset _pointOnCircle(Offset center, double r, double angle) =>
    Offset(center.dx + r * math.cos(angle), center.dy + r * math.sin(angle));

  void _textCentered(Canvas canvas, String t, double x, double y, Color c, double size, {bool bold = false}) {
    final tp = TextPainter(
      text: TextSpan(text: t, style: TextStyle(color: c, fontSize: size, fontWeight: bold ? FontWeight.w800 : FontWeight.normal)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x - tp.width / 2, y - tp.height / 2));
  }

  @override bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────
// UTILITÁRIOS DE DESENHO
// ─────────────────────────────────────────

void _text(Canvas canvas, String text, double x, double y, Color color, double size) {
  final tp = TextPainter(
    text: TextSpan(text: text, style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.w600)),
    textDirection: TextDirection.ltr)..layout();
  tp.paint(canvas, Offset(x, y));
}

void _arrow(Canvas canvas, Offset from, Offset to, Color color, double width) {
  final paint = Paint()..color = color..strokeWidth = width..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
  canvas.drawLine(from, to, paint);
  // Ponta da seta
  final dx = to.dx - from.dx; final dy = to.dy - from.dy;
  final len = math.sqrt(dx * dx + dy * dy);
  if (len == 0) return;
  final ux = dx / len; final uy = dy / len;
  const arrowLen = 8.0; const arrowAngle = 0.4;
  final p1 = Offset(to.dx - arrowLen * (ux * math.cos(arrowAngle) - uy * math.sin(arrowAngle)),
                    to.dy - arrowLen * (uy * math.cos(arrowAngle) + ux * math.sin(arrowAngle)));
  final p2 = Offset(to.dx - arrowLen * (ux * math.cos(arrowAngle) + uy * math.sin(arrowAngle)),
                    to.dy - arrowLen * (uy * math.cos(arrowAngle) - ux * math.sin(arrowAngle)));
  canvas.drawLine(to, p1, Paint()..color = color..strokeWidth = width..strokeCap = StrokeCap.round);
  canvas.drawLine(to, p2, Paint()..color = color..strokeWidth = width..strokeCap = StrokeCap.round);
}

void _dashedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
  const dashLen = 5.0; const gapLen = 3.0;
  final dx = to.dx - from.dx; final dy = to.dy - from.dy;
  final len = math.sqrt(dx * dx + dy * dy);
  if (len == 0) return;
  final ux = dx / len; final uy = dy / len;
  double dist = 0;
  bool drawing = true;
  while (dist < len) {
    final segLen = drawing ? math.min(dashLen, len - dist) : math.min(gapLen, len - dist);
    if (drawing) {
      canvas.drawLine(
        Offset(from.dx + ux * dist, from.dy + uy * dist),
        Offset(from.dx + ux * (dist + segLen), from.dy + uy * (dist + segLen)),
        paint);
    }
    dist += segLen;
    drawing = !drawing;
  }
}

// ─────────────────────────────────────────
// PAINTER — G71 CICLO DE DESBASTE (TORNO)
// ─────────────────────────────────────────
class _G71Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    final piecePaint  = Paint()..color = const Color(0xFF1A3A5C)..style = PaintingStyle.fill;
    final stockPaint  = Paint()..color = const Color(0xFF2E5478).withValues(alpha: 0.4)..style = PaintingStyle.fill;
    final profilePaint = Paint()..color = const Color(0xFF29B6F6)..strokeWidth = 2..style = PaintingStyle.stroke;
    final toolPaint   = Paint()..color = const Color(0xFFFFB300)..strokeWidth = 1.5..style = PaintingStyle.fill;
    final passPaint   = Paint()..color = const Color(0xFF66BB6A).withValues(alpha: 0.5)..strokeWidth = 1..style = PaintingStyle.stroke;
    final axisPaint   = Paint()..color = const Color(0xFF555566)..strokeWidth = 0.8;

    // Eixo de rotação (Z)
    canvas.drawLine(Offset(20, h * 0.82), Offset(w - 10, h * 0.82), axisPaint);
    _text(canvas, 'Z', w - 18, h * 0.72, const Color(0xFF888888), 9);
    _text(canvas, 'X', 10, h * 0.20, const Color(0xFF888888), 9);
    canvas.drawLine(Offset(w * 0.12, 10), Offset(w * 0.12, h * 0.85), axisPaint);

    // Matéria-prima (bruto)
    final stockPath = Path()
      ..moveTo(w * 0.18, h * 0.82)
      ..lineTo(w * 0.18, h * 0.12)
      ..lineTo(w * 0.88, h * 0.12)
      ..lineTo(w * 0.88, h * 0.82)
      ..close();
    canvas.drawPath(stockPath, stockPaint);

    // Perfil final desejado (azul)
    final profile = Path()
      ..moveTo(w * 0.18, h * 0.82)
      ..lineTo(w * 0.18, h * 0.55)
      ..lineTo(w * 0.35, h * 0.42)
      ..lineTo(w * 0.50, h * 0.42)
      ..lineTo(w * 0.50, h * 0.30)
      ..lineTo(w * 0.72, h * 0.30)
      ..lineTo(w * 0.72, h * 0.20)
      ..lineTo(w * 0.88, h * 0.20)
      ..lineTo(w * 0.88, h * 0.82);
    canvas.drawPath(profile, profilePaint);
    // Preenche peça final
    final pieceFill = Path.from(profile)..close();
    canvas.drawPath(pieceFill, piecePaint);

    // Passes de desbaste G71 (linhas horizontais)
    final passY = [h * 0.18, h * 0.26, h * 0.34, h * 0.46, h * 0.58];
    for (final y in passY) {
      if (y > h * 0.82) continue;
      canvas.drawLine(Offset(w * 0.18, y), Offset(w * 0.88, y), passPaint);
    }

    // Ferramenta (triângulo amarelo)
    final tx = w * 0.88; final ty = h * 0.18;
    final toolPath = Path()
      ..moveTo(tx - 8, ty - 10)
      ..lineTo(tx + 4, ty)
      ..lineTo(tx - 8, ty + 6)
      ..close();
    canvas.drawPath(toolPath, toolPaint);

    // Labels
    _text(canvas, 'Bruto', w * 0.60, h * 0.06, const Color(0xFF2E5478), 9);
    _text(canvas, 'Perfil final', w * 0.22, h * 0.35, const Color(0xFF29B6F6), 8);
    _text(canvas, 'Passes G71', w * 0.55, h * 0.43, const Color(0xFF66BB6A), 8);
    _text(canvas, '◀ Ferramenta', tx - 72, ty - 6, const Color(0xFFFFB300), 8);
  }
  @override bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────
// PAINTER — VELOCIDADE DE CORTE (Vc / RPM / Ø)
// ─────────────────────────────────────────
class _VcFormulaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;

    // Fundo escuro do "display"
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(8, 8, w - 16, h - 16), const Radius.circular(10)),
      Paint()..color = const Color(0xFF0D1B2A));

    // Círculo girando (representando a fresa)
    final cx = w * 0.22; final cy = h * 0.48; final r = h * 0.30;
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = const Color(0xFF1E3A5F));
    canvas.drawCircle(Offset(cx, cy), r,
      Paint()..color = const Color(0xFF29B6F6)..strokeWidth = 2..style = PaintingStyle.stroke);
    // Dentes da fresa
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final tx = cx + (r - 6) * math.cos(angle);
      final ty = cy + (r - 6) * math.sin(angle);
      canvas.drawRect(
        Rect.fromCenter(center: Offset(tx, ty), width: 6, height: 6),
        Paint()..color = const Color(0xFFFFB300));
    }
    // Diâmetro
    canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy),
      Paint()..color = const Color(0xFF29B6F6).withValues(alpha: 0.4)..strokeWidth = 1);
    _text(canvas, 'Ø', cx - 4, cy - 8, const Color(0xFF29B6F6), 10);

    // Seta de velocidade ao redor
    final sweepPaint = Paint()
      ..color = const Color(0xFFFF7043)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r + 10),
      -math.pi * 0.8, math.pi * 1.4, false, sweepPaint);

    // Fórmulas à direita
    final rx = w * 0.48;
    _text(canvas, 'RPM  =', rx, h * 0.18, const Color(0xFFCCCCDD), 11);
    _text(canvas, 'Vc × 1000', rx + 52, h * 0.14, const Color(0xFFFF7043), 10);
    canvas.drawLine(Offset(rx + 52, h * 0.26), Offset(rx + 52 + 68, h * 0.26),
      Paint()..color = const Color(0xFF555566)..strokeWidth = 1);
    _text(canvas, 'π × Ø', rx + 62, h * 0.28, const Color(0xFF29B6F6), 10);

    _text(canvas, 'F  =', rx, h * 0.48, const Color(0xFFCCCCDD), 11);
    _text(canvas, 'RPM × fz × Z', rx + 36, h * 0.48, const Color(0xFF66BB6A), 10);

    _text(canvas, 'Vc = m/min', rx, h * 0.65, const Color(0xFFFF7043).withValues(alpha: 0.8), 9);
    _text(canvas, 'fz = mm/dente', rx, h * 0.76, const Color(0xFF66BB6A).withValues(alpha: 0.8), 9);
    _text(canvas, 'Z  = nº dentes', rx, h * 0.87, const Color(0xFFFFB300).withValues(alpha: 0.8), 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────
// PAINTER — CÓDIGO ISO DO INSERTO
// ─────────────────────────────────────────
class _InsertISOPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;

    // Fundo
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(4, 4, w - 8, h - 8), const Radius.circular(8)),
      Paint()..color = const Color(0xFF0D1B2A));

    // Texto do código ISO em blocos coloridos
    const code = ['C', 'N', 'M', 'G', ' ', '1', '2', '0', '4', ' ', '0', '8'];
    const colors = [
      Color(0xFFFF7043), Color(0xFF29B6F6), Color(0xFF66BB6A), Color(0xFFFFB300),
      Colors.transparent,
      Color(0xFFAB47BC), Color(0xFFAB47BC), Color(0xFFEF5350), Color(0xFFEF5350),
      Colors.transparent,
      Color(0xFF26C6DA), Color(0xFF26C6DA),
    ];
    const descriptions = [
      'Forma\n80°', 'Folga\n0°', 'Toler.\n±0.08', 'Tipo\nc/furo',
      '',
      'Comp.\n12mm', '', 'Esp.\n04mm', '',
      '',
      'Raio\n0.8mm', '',
    ];

    double x = 18;
    final blockW = (w - 36) / 10.0;

    for (int i = 0; i < code.length; i++) {
      if (code[i] == ' ') { x += blockW * 0.4; continue; }
      final bx = x; final by = h * 0.08;
      final bh = h * 0.40;

      // Bloco colorido
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(bx, by, blockW - 3, bh), const Radius.circular(4)),
        Paint()..color = colors[i].withValues(alpha: 0.15));
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(bx, by, blockW - 3, bh), const Radius.circular(4)),
        Paint()..color = colors[i]..strokeWidth = 1..style = PaintingStyle.stroke);

      // Letra/número no centro do bloco
      _text(canvas, code[i], bx + (blockW - 3) / 2 - 4, by + bh / 2 - 8, colors[i], 13);

      // Descrição abaixo
      if (descriptions[i].isNotEmpty) {
        final lines = descriptions[i].split('\n');
        _text(canvas, lines[0], bx - 2, by + bh + 6, colors[i].withValues(alpha: 0.8), 7);
        if (lines.length > 1) _text(canvas, lines[1], bx - 2, by + bh + 15, Colors.grey, 6);
      }
      x += blockW;
    }

    // Título
    _text(canvas, 'CNMG 120408  —  Código ISO (ISO 1832)', 18, h * 0.76, const Color(0xFF8888A8), 9);

    // Forma do inserto (canto inferior direito) — losango 80°
    final ic = Offset(w * 0.88, h * 0.32);
    final ir = h * 0.20;
    final angle80 = 80 * math.pi / 180;
    final insertPath = Path()
      ..moveTo(ic.dx, ic.dy - ir)
      ..lineTo(ic.dx + ir * math.sin(angle80 / 2), ic.dy)
      ..lineTo(ic.dx, ic.dy + ir)
      ..lineTo(ic.dx - ir * math.sin(angle80 / 2), ic.dy)
      ..close();
    canvas.drawPath(insertPath, Paint()..color = const Color(0xFFFF7043).withValues(alpha: 0.15));
    canvas.drawPath(insertPath, Paint()..color = const Color(0xFFFF7043)..strokeWidth = 1.5..style = PaintingStyle.stroke);
    _text(canvas, '80°', ic.dx - 10, ic.dy + ir + 4, const Color(0xFFFF7043), 8);
  }
  @override bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────
// PAINTER — ZONA DE TOLERÂNCIA H7/h6
// ─────────────────────────────────────────
class _ToleranciaH7Painter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;

    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(4, 4, w - 8, h - 8), const Radius.circular(8)),
      Paint()..color = const Color(0xFF0D1B2A));

    // Linha zero (nominal Ø30)
    final zy = h * 0.50;
    final lx1 = w * 0.18; final lx2 = w * 0.82;
    canvas.drawLine(Offset(lx1, zy), Offset(lx2, zy),
      Paint()..color = const Color(0xFF555566)..strokeWidth = 1.5);
    _text(canvas, 'Ø30 nominal', lx1 - 2, zy - 14, const Color(0xFF666677), 8);

    // ─── FURO H7 (à esquerda) ───
    final fuH = h * 0.20; // altura da zona H7 = 21µm em escala
    // zona começa em zy (zero) e vai para CIMA (+21µm)
    final hx1 = w * 0.20; final hx2 = w * 0.42;
    final hRect = Rect.fromLTWH(hx1, zy - fuH, hx2 - hx1, fuH);
    canvas.drawRect(hRect, Paint()..color = const Color(0xFF29B6F6).withValues(alpha: 0.20));
    canvas.drawRect(hRect, Paint()..color = const Color(0xFF29B6F6)..strokeWidth = 1.5..style = PaintingStyle.stroke);

    // Cotas H7
    _arrow(canvas, Offset(hx1 - 12, zy), Offset(hx1 - 12, zy - fuH), const Color(0xFF29B6F6), 1.2);
    _text(canvas, '+21µm', hx1 - 40, zy - fuH / 2 - 4, const Color(0xFF29B6F6), 8);
    _text(canvas, '0', hx1 - 14, zy + 2, const Color(0xFF29B6F6), 8);
    _text(canvas, 'H7', (hx1 + hx2) / 2 - 8, zy - fuH / 2 - 5, const Color(0xFF29B6F6), 10);
    _text(canvas, '(FURO)', (hx1 + hx2) / 2 - 14, zy - fuH / 2 + 6, const Color(0xFF29B6F6).withValues(alpha: 0.7), 7);

    // ─── EIXO h6 (à direita) ───
    final eiH = h * 0.14; // 13µm em escala
    // zona vai de zy para BAIXO (0 a -13µm)
    final ex1 = w * 0.58; final ex2 = w * 0.80;
    final eRect = Rect.fromLTWH(ex1, zy, ex2 - ex1, eiH);
    canvas.drawRect(eRect, Paint()..color = const Color(0xFFFF7043).withValues(alpha: 0.20));
    canvas.drawRect(eRect, Paint()..color = const Color(0xFFFF7043)..strokeWidth = 1.5..style = PaintingStyle.stroke);

    // Cotas h6
    _arrow(canvas, Offset(ex2 + 12, zy), Offset(ex2 + 12, zy + eiH), const Color(0xFFFF7043), 1.2);
    _text(canvas, '-13µm', ex2 + 4, zy + eiH / 2 - 4, const Color(0xFFFF7043), 8);
    _text(canvas, '0', ex2 + 4, zy + 2, const Color(0xFFFF7043), 8);
    _text(canvas, 'h6', (ex1 + ex2) / 2 - 6, zy + eiH / 2 - 5, const Color(0xFFFF7043), 10);
    _text(canvas, '(EIXO)', (ex1 + ex2) / 2 - 12, zy + eiH / 2 + 6, const Color(0xFFFF7043).withValues(alpha: 0.7), 7);

    // Folga
    _text(canvas, '← Folga: 0 a 34µm →', w * 0.28, h * 0.84, const Color(0xFF66BB6A), 9);
    _text(canvas, 'Ajuste deslizante fino H7/h6', w * 0.18, h * 0.92, const Color(0xFF888888), 8);
  }
  @override bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────
// PAINTER — CORTE TRANSVERSAL DA FERRAMENTA
// (Geometria ângulos de saída/folga)
// ─────────────────────────────────────────
class _GeomFerramentaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width; final h = size.height;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(4, 4, w - 8, h - 8), const Radius.circular(8)),
      Paint()..color = const Color(0xFF0D1B2A));

    // Peça (retângulo cinza)
    final piecePath = Path()
      ..addRect(Rect.fromLTWH(w * 0.05, h * 0.60, w * 0.90, h * 0.32));
    canvas.drawPath(piecePath, Paint()..color = const Color(0xFF1E3A5F));
    canvas.drawPath(piecePath, Paint()..color = const Color(0xFF29B6F6)..strokeWidth = 1.5..style = PaintingStyle.stroke);

    // Ferramenta (triângulo)
    final tx = w * 0.42; final ty = h * 0.60;
    final toolPath = Path()
      ..moveTo(tx, ty)
      ..lineTo(tx - w * 0.18, ty - h * 0.42)
      ..lineTo(tx + w * 0.06, ty - h * 0.10)
      ..close();
    canvas.drawPath(toolPath, Paint()..color = const Color(0xFFFFB300).withValues(alpha: 0.25));
    canvas.drawPath(toolPath, Paint()..color = const Color(0xFFFFB300)..strokeWidth = 2..style = PaintingStyle.stroke);

    // Linha de referência vertical
    canvas.drawLine(Offset(tx, ty - h * 0.50), Offset(tx, ty),
      Paint()..color = Colors.grey..strokeWidth = 0.8..style = PaintingStyle.stroke);

    // Ângulo de saída (rake angle)
    final rakeEnd = Offset(tx - w * 0.18, ty - h * 0.42);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(tx, ty), width: 50, height: 50),
      -math.pi / 2, -0.45, false,
      Paint()..color = const Color(0xFF66BB6A)..strokeWidth = 1.5..style = PaintingStyle.stroke);
    _text(canvas, 'γ saída', tx - w * 0.20, ty - h * 0.28, const Color(0xFF66BB6A), 8);

    // Ângulo de folga (clearance)
    canvas.drawArc(
      Rect.fromCenter(center: Offset(tx, ty), width: 36, height: 36),
      0, 0.55, false,
      Paint()..color = const Color(0xFFFF7043)..strokeWidth = 1.5..style = PaintingStyle.stroke);
    _text(canvas, 'α folga', tx + 14, ty - 12, const Color(0xFFFF7043), 8);

    // Aresta de corte
    canvas.drawCircle(Offset(tx, ty), 4, Paint()..color = const Color(0xFFFFFFFF));
    _text(canvas, 'Aresta', tx + 6, ty + 4, const Color(0xFFCCCCDD), 7);

    // Seta de avanço
    _arrow(canvas, Offset(w * 0.75, h * 0.55), Offset(tx + 20, h * 0.55), const Color(0xFF29B6F6), 1.5);
    _text(canvas, 'fz →', w * 0.65, h * 0.47, const Color(0xFF29B6F6), 9);

    // Legenda
    _text(canvas, 'γ = ângulo de saída  |  α = ângulo de folga', w * 0.06, h * 0.06, const Color(0xFF666677), 8);
  }
  @override bool shouldRepaint(_) => false;
}

// ═══════════════════════════════════════════
// ABA 6 — CICLOS DE TORNO
// ═══════════════════════════════════════════
class _TabCiclosTorno extends StatelessWidget {
  const _TabCiclosTorno();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      _SectionTitle(num: '06', titulo: 'Ciclos de Desbaste no Torno', sub: 'G71 / G72 / G73 = desbaste automático. G70 = ciclo de acabamento final.'),
      const SizedBox(height: 12),

      const _CncImage(
        asset: 'assets/images/cnc/g71_desbaste_torno.png',
        legenda: 'Ciclo G71 — passes automáticos paralelos ao eixo Z desbastando até o perfil final',
        height: 200,
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'G71 — Desbaste Longitudinal',
        badge: 'Fanuc / Mitsubishi', badgeColor: Color(0xFF185FA5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // DIAGRAMA G71
          Container(
            height: 160,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(painter: _G71Painter(), size: const Size.fromHeight(160)),
          ),
          const _InfoTile(icon: Icons.info_outline, cor: Color(0xFF185FA5),
            titulo: 'Como funciona',
            sub: 'Gera passes paralelos ao eixo Z. Define o perfil entre N(P) e N(Q). U = passe por lado (raio). W = sobremedida axial.'),
          const SizedBox(height: 10),
          const _CodeBox(lines: [
            _CodeLine('G71 U[ap] R[recuo]', false),
            _CodeLine('G71 P[início] Q[fim] U[sobrem-X] W[sobrem-Z] F[feed]', false),
            _CodeLine('; ── Exemplo M30×2 em eixo Ø55 ──', true),
            _CodeLine('G71 U2.0 R0.5', false),
            _CodeLine('G71 P100 Q200 U0.3 W0.1 F0.25', false),
            _CodeLine('N100 G00 X20.          ; início do perfil', false),
            _CodeLine('G01 Z0.', false),
            _CodeLine('G01 X40. Z-25.         ; cone', false),
            _CodeLine('G01 Z-50.              ; cilindro', false),
            _CodeLine('N200 G01 X55.          ; fim do perfil', false),
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF185FA5), bg: Color(0xFFE3F2FD),
            text: 'U=passe por lado (raio). R=recuo de saída entre passes. U0.3 W0.1 = sobremetal para acabamento com G70 depois.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'G72 — Desbaste Frontal (Face)',
        badge: 'Fanuc', badgeColor: Color(0xFF0F6E56),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _InfoTile(icon: Icons.info_outline, cor: Color(0xFF0F6E56),
            titulo: 'Passes paralelos à face (eixo X)',
            sub: 'Ideal para peças de grande diâmetro e pequeno comprimento — flanges, discos, tampas.'),
          const SizedBox(height: 8),
          const _CodeBox(lines: [
            _CodeLine('G72 W[ap] R[recuo]', false),
            _CodeLine('G72 P[início] Q[fim] U[sobrem-X] W[sobrem-Z] F[feed]', false),
            _CodeLine('; W = profundidade axial por passe', true),
            _CodeLine('; O perfil N(P)-N(Q) é percorrido em X', true),
          ]),
          const _Callout(icon: Icons.warning_amber_rounded, color: Color(0xFFE8A020), bg: Color(0xFFFFF8E1),
            text: 'G72 exige perfil programado de X maior para X menor (X decrescente). Inverso do G71.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'G73 — Ciclo de Traçado Repetido',
        badge: 'Para peças pré-formadas', badgeColor: Color(0xFF4527A0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _InfoTile(icon: Icons.info_outline, cor: Color(0xFF4527A0),
            titulo: 'Para fundidos e forjados',
            sub: 'Repete o perfil N(P)-N(Q) deslocando progressivamente. Muito mais rápido que G71 quando o bruto já tem o perfil aproximado.'),
          const SizedBox(height: 8),
          const _CodeBox(lines: [
            _CodeLine('G73 U[sobremetal-X-total] W[sobremetal-Z-total] R[nº-passes]', false),
            _CodeLine('G73 P[início] Q[fim] U[sobrem-acab-X] W[sobrem-acab-Z] F[feed]', false),
            _CodeLine('; Ex: 4 passes, 4mm em X, 2mm em Z:', true),
            _CodeLine('G73 U4.0 W2.0 R4', false),
            _CodeLine('G73 P100 Q200 U0.4 W0.1 F0.2', false),
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF4527A0), bg: Color(0xFFEDE7F6),
            text: 'Use G73 quando o blank (bruto) já tem a forma grosseira. Evita passes em vazio que o G71 faria.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'G70 — Ciclo de Acabamento',
        badge: 'Sempre após G71/G72/G73', badgeColor: Color(0xFF993C1D),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _CodeBox(lines: [
            _CodeLine('; Após G71/G72/G73, troque a ferramenta:', true),
            _CodeLine('T0202 M03', false),
            _CodeLine('G96 S250 M03       ; CSS para acabamento', false),
            _CodeLine('G00 X55. Z5.', false),
            _CodeLine('G70 P100 Q200 F0.1 ; percorre N100-N200 exato', false),
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF185FA5), bg: Color(0xFFE3F2FD),
            text: 'G70 não aceita U/W — usa o perfil exato definido em N(P)-N(Q). Sempre troque para ferramenta de acabamento antes.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'G74 — Peck no Eixo Z / G75 — Sangramento Radial',
        badge: 'Furação e grooving', badgeColor: Color(0xFF37474F),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _CodeBox(lines: [
            _CodeLine('; G74 — Furação axial com peck:', true),
            _CodeLine('G74 R1.0             ; recuo entre pecks', false),
            _CodeLine('G74 X0. Z-40. P0 Q5000 F0.15', false),
            _CodeLine('; X0=centro, Z-40=prof, Q5000=peck 5mm', true),
            _CodeLine('', false),
            _CodeLine('; G75 — Sangramento radial com pecking:', true),
            _CodeLine('G75 R0.5             ; recuo entre pecks', false),
            _CodeLine('G75 X34. Z-25. P1500 Q2000 F0.06', false),
            _CodeLine('; P1500=passo radial 1.5mm, Q2000=passo Z', true),
          ]),
          const _Callout(icon: Icons.warning_amber_rounded, color: Color(0xFFE8A020), bg: Color(0xFFFFF8E1),
            text: 'Reduza a velocidade no sangramento (G75). Vibração quebra insertos de sangrar facilmente.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'G76 — Ciclo de Rosca no Torno',
        badge: 'Threading — Fanuc', badgeColor: Color(0xFF993C1D),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _InfoTile(icon: Icons.bolt, cor: Color(0xFF993C1D),
            titulo: 'Infeed em ângulo automático',
            sub: 'G76 faz passes de rosca com infeed em 29°/30° protegendo a aresta. Define passes, ângulo, altura e 1º passe tudo em P.'),
          const SizedBox(height: 8),
          const _CodeBox(lines: [
            _CodeLine('; Rosca M30×2 externa:', true),
            _CodeLine('G76 P021060 Q100 R0.1', false),
            _CodeLine('G76 X27.4 Z-38. P1300 Q400 F2.0', false),
            _CodeLine('; P021060: 02=passes acab, 10=saída 1°, 60=ang 60°', true),
            _CodeLine('; Q100=passe min 0.1mm, R0.1=sobremetal acab', true),
            _CodeLine('; X27.4=diâm fundo, P1300=altura 1.3mm, F2.0=passo', true),
          ]),
          const _Callout(icon: Icons.functions, color: Color(0xFF4527A0), bg: Color(0xFFEDE7F6),
            text: 'Diâmetro fundo (macho): D = D_nom − 1.2269 × passo\nEx: M30×2 → 30 − 1.2269×2 = 27.55mm'),
        ]),
      ),
      const SizedBox(height: 20),

      _SectionTitle(num: '07', titulo: 'Comparativo G71 × G72 × G73', sub: 'Quando usar cada ciclo de desbaste'),
      const SizedBox(height: 8),
      _ParamTable(rows: const [
        ['G71', 'Passes paralelos a Z (longitudinal) — eixos e cilindros'],
        ['G72', 'Passes paralelos a X (frontal) — flanges e discos'],
        ['G73', 'Paralelos ao perfil — fundidos e pré-formados'],
        ['G70', 'Segue o perfil exato — acabamento final'],
      ]),
      const SizedBox(height: 20),
    ]);
  }
}

// ═══════════════════════════════════════════
// ABA 7 — M-CODES
// ═══════════════════════════════════════════
class _TabMCodes extends StatelessWidget {
  const _TabMCodes();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      _SectionTitle(num: '07', titulo: 'Códigos M — Funções Auxiliares', sub: 'Spindle, refrigeração, troca de ferramenta, pausa, subprogramas e funções especiais.'),
      const SizedBox(height: 12),

      const _CncImage(
        asset: 'assets/images/cnc/mcodes_painel.png',
        legenda: 'Principais M-codes CNC — funções auxiliares da máquina',
        height: 190,
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Controle do Spindle',
        badge: 'M03 / M04 / M05 / M19', badgeColor: Color(0xFF185FA5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _ParamTable(rows: const [
            ['M03', 'Spindle horário (CW) — fresamento padrão, torneamento externo'],
            ['M04', 'Spindle anti-horário (CCW) — rosca esquerda, torneamento especial'],
            ['M05', 'Para o spindle (não desliga) — use antes de M06'],
            ['M19', 'Orientação do spindle — posição fixa. Exigido pelo ATC/G76'],
          ]),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'Refrigeração (Coolant)',
        badge: 'M07 / M08 / M09 / M50', badgeColor: Color(0xFF0F6E56),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _ParamTable(rows: const [
            ['M07', 'Névoa (mist coolant) — alumínio, mini CNC, peças leves'],
            ['M08', 'Inundação (flood) — aço, inox. Padrão em usinagem'],
            ['M09', 'Desliga refrigeração — sempre antes de M06'],
            ['M50', 'Pelo fuso (through-spindle) — brocamento profundo e trocóide'],
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF185FA5), bg: Color(0xFFE3F2FD),
            text: 'Ligue M08 antes de M03. Corte seco em inox causa dano severo à aresta por choque térmico.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'Troca de Ferramenta',
        badge: 'M06 — ATC', badgeColor: Color(0xFF993C1D),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _ParamTable(rows: const [
            ['M06', 'Troca automática de ferramenta (ATC) — SEMPRE com G28 Z antes'],
            ['M61', 'Seleciona ferramenta no magazine (alguns controles)'],
            ['M62', 'Avança ferramenta p/ posição de troca (Siemens e similares)'],
          ]),
          const SizedBox(height: 8),
          const _CodeBox(lines: [
            _CodeLine('; Sequência CORRETA de troca:', true),
            _CodeLine('G28 G91 Z0.    ; retorna Z ao home', false),
            _CodeLine('G90', false),
            _CodeLine('T02 M06        ; chama T02 e executa troca', false),
            _CodeLine('G43 H02 Z50.   ; compensa comprimento H02', false),
            _CodeLine('M03 S2000      ; liga spindle', false),
          ]),
          const _Callout(icon: Icons.warning_amber_rounded, color: Color(0xFFE8A020), bg: Color(0xFFFFF8E1),
            text: 'NUNCA chame M06 sem G28 Z antes. A ferramenta retrai para trocar — se Z estiver baixo, COLISÃO garantida!'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'Pausa e Controle de Execução',
        badge: 'M00 / M01 / M02 / M30', badgeColor: Color(0xFF37474F),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _ParamTable(rows: const [
            ['M00', 'Pausa incondicional — inspecionar peça no meio do ciclo'],
            ['M01', 'Pausa condicional (Optional Stop) — só para se botão ativo'],
            ['M02', 'Fim de programa sem rebobinar — cursor fica no M02'],
            ['M30', 'Fim + rebobina — padrão, cursor volta ao início'],
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF185FA5), bg: Color(0xFFE3F2FD),
            text: 'Em série use M01 para inspeção opcional. Desative o botão OPT STOP em produção para pular as paradas.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'Subprogramas',
        badge: 'M98 / M99', badgeColor: Color(0xFF4527A0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _CodeBox(lines: [
            _CodeLine('; Chama O0200 por 3 vezes:', true),
            _CodeLine('M98 P30200      ; P[vezes][número]', false),
            _CodeLine('                ; P30200 = 3x o programa O0200', false),
            _CodeLine('', false),
            _CodeLine('; Dentro do subprograma O0200:', true),
            _CodeLine('O0200', false),
            _CodeLine('  G01 X10. F200.', false),
            _CodeLine('  ...', false),
            _CodeLine('M99             ; retorna ao programa chamador', false),
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF4527A0), bg: Color(0xFFEDE7F6),
            text: 'M99 no programa principal (não em sub) = loop infinito. Útil para programas que devem rodar continuamente.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'Funções Especiais',
        badge: 'M29 / M48 / M49', badgeColor: Color(0xFF993C1D),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _ParamTable(rows: const [
            ['M29', 'Modo rígido — OBRIGATÓRIO antes do G84 no Fanuc'],
            ['M48', 'Habilita override de avanço/spindle — estado padrão'],
            ['M49', 'Desabilita override — CRÍTICO no rosqueamento'],
            ['M96', 'Skip condicional ON (G31) — ativa skip do apalpador'],
            ['M97', 'Skip condicional OFF — desativa skip function'],
          ]),
          const _Callout(icon: Icons.warning_amber_rounded, color: Color(0xFFE8A020), bg: Color(0xFFFFF8E1),
            text: 'Use M49 antes do G84. Se o operador tocar o override durante rosqueamento, a rosca fica errada e o macho quebra!'),
        ]),
      ),
      const SizedBox(height: 20),
    ]);
  }
}

// ═══════════════════════════════════════════
// ABA 8 — SETUP & BORDA
// ═══════════════════════════════════════════
class _TabSetupBorda extends StatelessWidget {
  const _TabSetupBorda();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(16), children: [
      _SectionTitle(num: '08', titulo: 'Setup & Edge Finding', sub: 'Encontrar bordas, zerar ferramentas e verificar alinhamento da máquina.'),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Método 1 — Localizador Eletrônico de Borda',
        badge: 'Mais preciso', badgeColor: Color(0xFF185FA5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _InfoTile(icon: Icons.bolt, cor: Color(0xFF185FA5),
            titulo: 'Edge finder elétrico (Ø10mm)',
            sub: 'O localizador pisca/apita quando toca a peça. Diâmetro padrão 10mm = raio 5mm.'),
          const SizedBox(height: 10),
          const _CodeBox(lines: [
            _CodeLine('; Procedimento:', true),
            _CodeLine('; 1. Monte no spindle (baixa RPM ~500)', true),
            _CodeLine('; 2. Toque a borda — ele desvia ao contato', true),
            _CodeLine('; 3. DRO: zere X e some 5.0mm (raio)', true),
            _CodeLine('; 4. X real peça = posição DRO - 5.0mm', true),
            _CodeLine('; 5. Atualize G54 X com esse valor', true),
            _CodeLine('; 6. Repita para Y', true),
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF185FA5), bg: Color(0xFFE3F2FD),
            text: 'Borda direita: G54 X = (DRO) - raio. Borda esquerda: G54 X = (DRO) + raio.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'Método 2 — Relógio Comparador (DTI)',
        badge: 'Alinhamento e borda', badgeColor: Color(0xFF0F6E56),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _InfoTile(icon: Icons.radio_button_unchecked, cor: Color(0xFF0F6E56),
            titulo: 'DTI no spindle (parado)',
            sub: 'Movimente X até o relógio indicar zero — essa é a borda exata. Mais versátil que o localizador.'),
          const SizedBox(height: 8),
          const _CodeBox(lines: [
            _CodeLine('; Para encontrar centro de furo:', true),
            _CodeLine('; 1. DTI tocando a parede do furo', true),
            _CodeLine('; 2. Gire spindle manualmente 360°', true),
            _CodeLine('; 3. Ajuste XY até agulha não desviar', true),
            _CodeLine('; 4. G54 X=0 Y=0 nessa posição', true),
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF0F6E56), bg: Color(0xFFE8F5E9),
            text: 'DTI funciona em furos, raios, planos inclinados e superfícies irregulares — mais versátil que o localizador.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'Método 3 — Papel / Folha de Cigarro',
        badge: 'Zeragem Z clássica', badgeColor: Color(0xFFE8A020),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _InfoTile(icon: Icons.description, cor: Color(0xFFE8A020),
            titulo: 'Espessuras: papel 0.1mm, cigarro/seda 0.05mm',
            sub: 'Deslize entre a ferramenta e a peça — quando travar levemente, esse é o Z de contato.'),
          const SizedBox(height: 8),
          const _CodeBox(lines: [
            _CodeLine('; 1. Coloque folha sobre a peça', true),
            _CodeLine('; 2. Desça Z até sentir resistência ao puxar', true),
            _CodeLine('; 3. Zere Z no DRO', true),
            _CodeLine('; 4. Suba Z + espessura do papel (0.1mm)', true),
            _CodeLine('; 5. G54 Z = posição DRO atual', true),
            _CodeLine('; A face da peça está em Z=0.000', true),
          ]),
          const _Callout(icon: Icons.warning_amber_rounded, color: Color(0xFFE8A020), bg: Color(0xFFFFF8E1),
            text: 'Método rápido mas depende do toque do operador. Para tolerâncias < 0.05mm, use apalpador ou medidor de altura.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'Método 4 — Giz / Toque de Ferramenta',
        badge: 'Centro de cilindro', badgeColor: Color(0xFF37474F),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _CodeBox(lines: [
            _CodeLine('; Técnica do giz:', true),
            _CodeLine('; 1. Pinte a lateral com giz ou caneta', true),
            _CodeLine('; 2. Gire spindle e desça fresa até tirar o giz', true),
            _CodeLine('; 3. Anote posição X (borda direita)', true),
            _CodeLine('; 4. Repita no lado oposto (borda esquerda)', true),
            _CodeLine('; 5. Centro = (X_dir + X_esq) / 2', true),
          ]),
          const _Callout(icon: Icons.functions, color: Color(0xFF4527A0), bg: Color(0xFFEDE7F6),
            text: 'Fórmula: Centro = X_toque + (Ø_fresa/2) + (Ø_peça/2)\nBorda direta: G54 X = X_DRO + Ø_fresa/2'),
        ]),
      ),
      const SizedBox(height: 20),

      _SectionTitle(num: '09', titulo: 'Zeragem de Z — Comprimento de Ferramenta', sub: 'G43 aplica o offset H ao eixo Z. Sem G43 o CNC não sabe onde está a ponta.'),
      const SizedBox(height: 8),

      _ManualCard(
        titulo: 'G43 — Compensação de Comprimento de Ferramenta',
        badge: 'H offset', badgeColor: Color(0xFF4527A0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _InfoTile(icon: Icons.straighten, cor: Color(0xFF4527A0),
            titulo: 'Como funciona',
            sub: 'G43 H01 = "a ferramenta T01 é H01mm mais longa que o ponto de referência". Sem G43 o CNC ignora o comprimento.'),
          const SizedBox(height: 8),
          const _CodeBox(lines: [
            _CodeLine('; Sequência de setup Z:', true),
            _CodeLine('; 1. Ferramenta no spindle', true),
            _CodeLine('; 2. Toque face da peça com papel', true),
            _CodeLine('; 3. Pressione TOOL LENGTH MEASURE ou insira H', true),
            _CodeLine('G43 H01 Z50.  ; ponta está em Z=50 acima da peça', false),
          ]),
          const _Callout(icon: Icons.warning_amber_rounded, color: Color(0xFFE8A020), bg: Color(0xFFFFF8E1),
            text: 'SEMPRE programe G43 após trocar ferramenta. Esquecer G43 com H0 ou H errado = colisão ou corte no ar.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'Comparativo de Métodos de Medição',
        badge: 'Precisão', badgeColor: Color(0xFF185FA5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _ParamTable(rows: const [
            ['Apalpador na máquina', '±0.002mm — automático, sem tirar ferramenta'],
            ['Presetter externo', '±0.005mm — fora da máquina, sem parar produção'],
            ['Medidor de bancada', '±0.01mm — barato e manual'],
            ['Toque com papel', '±0.1mm — sem equipamento, método de campo'],
          ]),
        ]),
      ),
      const SizedBox(height: 20),

      _SectionTitle(num: '10', titulo: 'Alinhamento e Paralelismo', sub: 'Verificar morsa, runout do spindle e paralelismo de fixação.'),
      const SizedBox(height: 8),

      _ManualCard(
        titulo: 'Paralelismo da Morsa — Procedimento DTI',
        badge: 'Tolerância < 0.02mm/200mm', badgeColor: Color(0xFF0F6E56),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _CodeBox(lines: [
            _CodeLine('; 1. Monte DTI no spindle', true),
            _CodeLine('; 2. Toque o trilho guia fixo da morsa', true),
            _CodeLine('; 3. Mova X ao longo da morsa devagar', true),
            _CodeLine('; 4. Desvio aceitável: < 0.02mm em 200mm', true),
            _CodeLine('; 5. Corrija: malete de nylon + reaperto gradual', true),
            _CodeLine('; 6. Repita até atingir tolerância', true),
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF0F6E56), bg: Color(0xFFE8F5E9),
            text: 'Paralelize sempre após remontagem ou queda. 0.1mm/200mm = 0.5mm/1000mm — erro multiplicado em peças longas.'),
        ]),
      ),
      const SizedBox(height: 10),

      _ManualCard(
        titulo: 'Batimento do Spindle — TIR (Total Indicator Reading)',
        badge: 'Máx 0.005mm', badgeColor: Color(0xFF993C1D),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _CodeBox(lines: [
            _CodeLine('; 1. Monte pino de precisão (test bar) no spindle', true),
            _CodeLine('; 2. DTI tocando o cilindro do pino', true),
            _CodeLine('; 3. Gire spindle lentamente 360° à mão', true),
            _CodeLine('; 4. TIR = diferença máx - mín', true),
            _CodeLine(';    Aceitável: < 0.005mm para usinagem fina', true),
            _CodeLine(';    Trocar rolamentos se TIR > 0.020mm', true),
          ]),
          const _Callout(icon: Icons.warning_amber_rounded, color: Color(0xFFE8A020), bg: Color(0xFFFFF8E1),
            text: 'Alto TIR destrói qualidade de furos e acabamentos. Verifique mensalmente em máquinas de produção.'),
        ]),
      ),
      const SizedBox(height: 20),
    ]);
  }
}

// ═══════════════════════════════════════════
// ABA 9 — VELOCIDADES DE CORTE
// ═══════════════════════════════════════════
class _TabVelocidades extends StatelessWidget {
  const _TabVelocidades();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(16, 20, 16, 32), children: [
      const _SectionTitle(num: '09', titulo: 'Velocidades de Corte', sub: 'Tabela de Vc, f e ap por material'),

      const _CncImage(
        asset: 'assets/images/cnc/velocidade_corte_tabela.png',
        legenda: 'Tabela de velocidades de corte por material — referência rápida para Vc, fz e ap',
        height: 185,
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Fórmula Base — RPM e Avanço',
        badge: 'Essencial', badgeColor: Color(0xFF185FA5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // DIAGRAMA VISUAL Vc/RPM
          Container(
            height: 130,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(painter: _VcFormulaPainter(), size: const Size.fromHeight(130)),
          ),
          const _CodeBox(lines: [
            _CodeLine('RPM = (Vc × 1000) / (π × Ø)', false),
            _CodeLine('; Vc = velocidade de corte em m/min', true),
            _CodeLine('; Ø  = diâmetro da ferramenta em mm', true),
            _CodeLine('', false),
            _CodeLine('Avanço (mm/min) = RPM × fz × Z', false),
            _CodeLine('; fz = avanço por dente (mm/dente)', true),
            _CodeLine('; Z  = número de dentes da fresa', true),
            _CodeLine('', false),
            _CodeLine('; Exemplo: Fresa Ø10mm, 4 dentes, Vc=120m/min, fz=0.03', true),
            _CodeLine('; RPM = (120×1000)/(π×10) = 3820 RPM', true),
            _CodeLine('; F   = 3820 × 0.03 × 4  = 458 mm/min ≈ F460', true),
          ]),
          const _Callout(icon: Icons.functions_rounded, color: Color(0xFF4527A0), bg: Color(0xFFEDE7F6),
            text: 'Regra dos 80%: na prática, use 80% do Vc teórico no primeiro teste. Ajuste conforme cavaco, vibração e acabamento.'),
        ]),
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Tabela de Velocidades — Fresa de Topo Carbide',
        badge: 'Referência', badgeColor: Color(0xFF2E7D32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _ParamTable(rows: [
            ['Material', 'Vc (m/min) | fz (mm/dente Ø10)'],
            ['Alumínio 6061', '200–400 m/min | fz 0.05–0.10'],
            ['Aço baixo carbono', '80–120 m/min | fz 0.03–0.06'],
            ['Aço inox 304', '40–80 m/min | fz 0.02–0.04'],
            ['Ferro fundido', '100–150 m/min | fz 0.04–0.07'],
            ['Titânio Gr5', '30–60 m/min | fz 0.02–0.04'],
            ['Latão/Bronze', '150–250 m/min | fz 0.04–0.08'],
            ['Plástico (ABS/Nylon)', '200–500 m/min | fz 0.08–0.15'],
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF185FA5), bg: Color(0xFFE3F2FD),
            text: 'Valores para carbide não revestido. Com TiAlN: +30% em Vc. Com AlTiN: +50% em Vc para aços temperados.'),
        ]),
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Tabela de Velocidades — Torneamento (Insertos)',
        badge: 'Referência', badgeColor: Color(0xFF4527A0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _ParamTable(rows: [
            ['Material', 'Vc (m/min) | fn (mm/rot) | ap (mm)'],
            ['Alumínio', '500–1000 | fn 0.15–0.40 | ap 1–5'],
            ['Aço C45', '180–280 | fn 0.20–0.35 | ap 1–4'],
            ['Aço inox 304', '120–200 | fn 0.10–0.25 | ap 0.5–3'],
            ['Aço endurecido', '80–150 | fn 0.05–0.15 | ap 0.2–1'],
            ['Ferro fundido cinz.', '150–250 | fn 0.20–0.40 | ap 1–4'],
          ]),
          const _Callout(icon: Icons.warning_amber_rounded, color: Color(0xFFE8A020), bg: Color(0xFFFFF8E1),
            text: 'Inox: usar refrigeração abundante e sair sempre do corte — nunca parar no material. Calor acumula e endurece a peça.'),
        ]),
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Parâmetros de Furação — Brocas HSS e Carbide',
        badge: 'Brocação', badgeColor: Color(0xFF0F6E56),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _ParamTable(rows: [
            ['Material', 'Vc HSS (m/min) | Vc Carbide | fn (mm/rot)'],
            ['Alumínio', '60–100 | 150–250 | 0.10–0.25'],
            ['Aço macio', '25–40 | 80–120 | 0.10–0.20'],
            ['Aço inox', '8–15 | 30–60 | 0.05–0.12'],
            ['Ferro fundido', '25–40 | 80–130 | 0.12–0.25'],
            ['Latão', '40–80 | 120–200 | 0.12–0.25'],
          ]),
          const _CodeBox(lines: [
            _CodeLine('; Peck drilling (G83): profundidade > 3× Ø', true),
            _CodeLine('; Q = 1/3 do diâmetro da broca (peck step)', true),
            _CodeLine('; Reduzir Vc 20% em furos cegos', true),
          ]),
        ]),
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Interpretando o Cavaco (Diagnóstico Visual)',
        badge: 'Diagnóstico', badgeColor: Color(0xFF993C1D),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _ParamTable(rows: [
            ['Cavaco', 'Diagnóstico → Ação'],
            ['Azul/Roxo intenso', 'Temperatura alta → ↑Refrigeração ou ↓Vc'],
            ['Longo e enrolado', 'Quebra-cavaco fraco → ↑fn ou mudar geometria'],
            ['Em pó/poeira', 'Vc muito alta ou material quebradiço — normal em CI'],
            ['Com aresta postiça', 'BUE: ↑Vc ou troca para PVD (TiAlN coating)'],
            ['Cavaco perfeito (C)', 'Parâmetros corretos para aços — manter!'],
          ]),
        ]),
      ),
      const SizedBox(height: 20),
    ]);
  }
}

// ═══════════════════════════════════════════
// ABA 10 — FERRAMENTAS E INSERTOS
// ═══════════════════════════════════════════
class _TabFerramentas extends StatelessWidget {
  const _TabFerramentas();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(16, 20, 16, 32), children: [
      const _SectionTitle(num: '10', titulo: 'Ferramentas & Insertos', sub: 'Identificação, geometria e aplicação'),

      _ManualCard(
        titulo: 'Código ISO de Insertos — Identificação Completa',
        badge: 'ISO 1832', badgeColor: Color(0xFF185FA5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // DIAGRAMA ISO DO INSERTO
          Container(
            height: 120,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(painter: _InsertISOPainter(), size: const Size.fromHeight(120)),
          ),
          const _CodeBox(lines: [
            _CodeLine('C N M G  1 2 0 4  0 8', false),
            _CodeLine('; ① C = Forma: C=80°, D=55°, S=90°, T=60°, V=35°', true),
            _CodeLine('; ② N = Folga: N=0°, A=3°, B=5°, C=7°', true),
            _CodeLine('; ③ M = Tolerância: M=±0.08mm, G=±0.025mm', true),
            _CodeLine('; ④ G = Tipo: G=com furo+chanfro, N=sem furo', true),
            _CodeLine('; ⑤⑥ 12 = Comprimento do lado (mm)', true),
            _CodeLine('; ⑦⑧ 04 = Espessura (mm)', true),
            _CodeLine('; ⑨⑩ 08 = Raio de ponta × 10 (0.8mm)', true),
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF185FA5), bg: Color(0xFFE3F2FD),
            text: 'CNMG = Torneamento externo desbaste. DCMT = Acabamento fino. VCGT = Alumínio. DNMG = Torneamento interno.'),
        ]),
      ),
      const SizedBox(height: 8),
      const _CncImage(
        asset: 'assets/images/cnc/cnmg_inserto.png',
        legenda: 'Inserto CNMG 120408 — forma rômbica 80°, para torneamento externo de desbaste e semiacabamento',
        height: 180,
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Geometria de Fresas de Topo — Aplicação',
        badge: 'Seleção', badgeColor: Color(0xFF2E7D32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _ParamTable(rows: [
            ['Tipo', 'Aplicação Principal | Observação'],
            ['2F – 2 dentes', 'Alumínio, ranhura profunda | Mais espaço para cavaco'],
            ['4F – 4 dentes', 'Aço, contorno, bolsão | Uso geral mais comum'],
            ['6F – 6 dentes', 'Acabamento, passes leves | Alta velocidade, baixo ap'],
            ['Esférica R', 'Superfície 3D, moldes | Ra fino, requerer 5 eixos'],
            ['Toroidal (Bull)', 'HSM, desbaste molde | Melhor resistência que esférica'],
            ['Chanfradeira 45°', 'Chanfro externo de peças | Não usar G41 com elas'],
          ]),
        ]),
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Geometria do Inserto — Ângulos de Corte',
        badge: 'Teoria', badgeColor: Color(0xFF0F6E56),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 150,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(painter: _GeomFerramentaPainter(), size: const Size.fromHeight(150)),
          ),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF0F6E56), bg: Color(0xFFE8F5E9),
            text: 'γ (gamma) = ângulo de saída: positivo → corte mais suave. α (alfa) = ângulo de folga: evita atrito do flanco com a peça.'),
        ]),
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Porta-Ferramentas — Runout e Balanceamento',
        badge: 'Qualidade', badgeColor: Color(0xFF4527A0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _CodeBox(lines: [
            _CodeLine('; HIERARQUIA DE PORTA-FERRAMENTAS (precisão)', true),
            _CodeLine('; 1. Shrink-fit (termo-retraído) → runout < 0.003mm', false),
            _CodeLine('; 2. Hidráulico → runout < 0.003mm, bom amortec.', false),
            _CodeLine('; 3. Weldon ER (collet chuck) → runout < 0.010mm', false),
            _CodeLine('; 4. Weldon convencional → runout 0.015-0.030mm', false),
            _CodeLine('', false),
            _CodeLine('; REGRA: balancear > G2.5 a 12000 RPM (ISO 1940)', true),
            _CodeLine('; Acima de 15000 RPM: balancear sempre', true),
          ]),
          const _Callout(icon: Icons.warning_amber_rounded, color: Color(0xFFE8A020), bg: Color(0xFFFFF8E1),
            text: 'Runout > 0.01mm em fresas de acabamento: um dente corta mais que o outro → estrias no fundo do bolsão e desgaste diferencial.'),
        ]),
      ),
      const SizedBox(height: 8),
      const _CncImage(
        asset: 'assets/images/cnc/porta_ferramentas.png',
        legenda: 'Tipos de porta-ferramentas: Shrink-fit, Hidráulico, Collet ER e Weldon — comparativo de precisão',
        height: 180,
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Machos — Pré-furos e Seleção',
        badge: 'Roscas', badgeColor: Color(0xFF0F6E56),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _ParamTable(rows: [
            ['Rosca', 'Pré-furo → Macho passante | Cego'],
            ['M3 × 0.5', 'Ø2.5mm → mesma medida'],
            ['M4 × 0.7', 'Ø3.3mm → Ø3.3mm'],
            ['M5 × 0.8', 'Ø4.2mm → Ø4.2mm'],
            ['M6 × 1.0', 'Ø5.0mm → Ø5.0mm'],
            ['M8 × 1.25', 'Ø6.75mm → Ø6.75mm'],
            ['M10 × 1.5', 'Ø8.5mm → Ø8.5mm'],
            ['M12 × 1.75', 'Ø10.2mm → Ø10.2mm'],
          ]),
          const _CodeBox(lines: [
            _CodeLine('; Fórmula: Ø pré-furo = Ø nominal - passo', true),
            _CodeLine('; M6×1.0 → 6.0 - 1.0 = 5.0mm de pré-furo', true),
            _CodeLine('; Para cego: profundidade útil = profundidade pedida', true),
            _CodeLine('; Pré-furo deve ser 3mm mais fundo que a rosca', true),
          ]),
        ]),
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Vida de Ferramenta — Critérios de Troca',
        badge: 'Manutenção', badgeColor: Color(0xFF993C1D),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _ParamTable(rows: [
            ['Sinal de Desgaste', 'Significado → Ação'],
            ['Arranhado na peça (riscado)', 'Aresta lascada → Troca imediata'],
            ['Barulho de chatter', 'Vibração: parâm. ou desgaste → Checar runout'],
            ['Ra subiu (+50%)', 'Desgaste de flanco VB > 0.3mm → Trocar'],
            ['Fumaça sem refrigerante', 'Temperatura alta → ↑ refrigeração ou ↓ Vc'],
            ['Potência do spindle +20%', 'Aresta cega → Trocar antes de quebrar'],
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF185FA5), bg: Color(0xFFE3F2FD),
            text: 'Trocar no momento certo economiza: 1 inserto quebrado dentro da peça = peça sucata + tempo parado + possível dano ao mandril.'),
        ]),
      ),
      const SizedBox(height: 20),
    ]);
  }
}

// ═══════════════════════════════════════════
// ABA 11 — TOLERÂNCIAS E AJUSTES
// ═══════════════════════════════════════════
class _TabTolerancias extends StatelessWidget {
  const _TabTolerancias();

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.fromLTRB(16, 20, 16, 32), children: [
      const _SectionTitle(num: '11', titulo: 'Tolerâncias & Ajustes', sub: 'ISO 286 — Ajustes de eixo e furo'),

      _ManualCard(
        titulo: 'Sistema ISO 286 — Conceitos Básicos',
        badge: 'ISO 286', badgeColor: Color(0xFF185FA5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _CodeBox(lines: [
            _CodeLine('Designação: Ø30 H7 / h6', false),
            _CodeLine('; H7 = Tolerância do FURO (maiúscula = furo)', true),
            _CodeLine('; h6 = Tolerância do EIXO (minúscula = eixo)', true),
            _CodeLine('; 30 = Diâmetro nominal em mm', true),
            _CodeLine('', false),
            _CodeLine('; LETRAS: posição do campo de tolerância', true),
            _CodeLine('; H/h = próximo ao zero (H = acima, h = abaixo)', true),
            _CodeLine('; G/g = folga pequena', true),
            _CodeLine('; F/f = folga média', true),
            _CodeLine('; P/p, S/s = interferência (forçado)', true),
          ]),
          const _Callout(icon: Icons.functions_rounded, color: Color(0xFF4527A0), bg: Color(0xFFEDE7F6),
            text: 'NÚMEROS: indicam grau de qualidade IT (Tolerance). IT6 = preciso (maquinado fino). IT7 = normal. IT9-11 = estrutural.'),
        ]),
      ),
      const SizedBox(height: 8),
      const _CncImage(
        asset: 'assets/images/cnc/tolerancia_h7h6.png',
        legenda: 'Diagrama ISO 286 — H7 (furo) acima da linha zero e h6 (eixo) abaixo. Ajuste deslizante com folga mínima de 0µm.',
        height: 180,
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Diagrama de Zona — H7/h6 (Ø30mm)',
        badge: 'Visual', badgeColor: Color(0xFF29B6F6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            height: 145,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAlias,
            child: CustomPaint(painter: _ToleranciaH7Painter(), size: const Size.fromHeight(145)),
          ),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF29B6F6), bg: Color(0xFFE3F2FD),
            text: 'Furo H7 começa no zero e vai para CIMA (+21µm). Eixo h6 começa no zero e vai para BAIXO (−13µm). Folga total: 0 a 34µm.'),
        ]),
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Ajustes Mais Comuns — Tabela de Referência',
        badge: 'Referência', badgeColor: Color(0xFF2E7D32),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _ParamTable(rows: [
            ['Ajuste', 'Tipo → Aplicação'],
            ['H7/h6', 'Deslizante fino → Eixos deslizantes precisos'],
            ['H7/g6', 'Deslizante com folga → Mancais, guias lineares'],
            ['H7/f7', 'Girante → Rolamentos comuns, eixos giratórios'],
            ['H7/k6', 'Interferência leve → Bucha prensada com martelo'],
            ['H7/p6', 'Interferência forçada → Engrenagem no eixo'],
            ['H7/s6', 'Interferência alta → Anel externo de rolamento'],
          ]),
        ]),
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Valores de Tolerância IT para Ø30mm',
        badge: 'Ø 30mm', badgeColor: Color(0xFF4527A0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _ParamTable(rows: [
            ['Qualidade', 'IT Value | Exemplo (Ø30)'],
            ['IT5', '± 9µm | Ø30 ±0.009mm'],
            ['IT6', '±13µm | Ø30 H6 = +0/+0.013mm'],
            ['IT7', '±21µm | Ø30 H7 = +0/+0.021mm'],
            ['IT8', '±33µm | Torneamento cuidadoso'],
            ['IT9', '±52µm | Torneamento normal'],
            ['IT11', '±130µm | Corte em bruto'],
          ]),
          const _CodeBox(lines: [
            _CodeLine('; Ø30 H7: furo aceita de 30.000 a 30.021mm', true),
            _CodeLine('; Ø30 h6: eixo aceita de 29.987 a 30.000mm', true),
            _CodeLine('; Folga H7/h6: 0.000 a 0.034mm (deslizante fino)', true),
          ]),
        ]),
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Rugosidade Superficial Ra — Escala de Processos',
        badge: 'Acabamento', badgeColor: Color(0xFF0F6E56),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _ParamTable(rows: [
            ['Processo', 'Ra Típico | Aplicação'],
            ['Torneamento bruto', 'Ra 6.3–12.5µm | Desbaste'],
            ['Fresamento normal', 'Ra 1.6–3.2µm | Faces funcionais'],
            ['Torneamento fino', 'Ra 0.8–1.6µm | Sedes de vedação'],
            ['Esmerilhamento', 'Ra 0.2–0.8µm | Ajustes de precisão'],
            ['Lapidação/Polimento', 'Ra < 0.1µm | Espelhos ópticos'],
          ]),
          const _CodeBox(lines: [
            _CodeLine('; Símbolo √ com número = Ra máximo (µm)', true),
            _CodeLine('; √ 1.6 = Ra ≤ 1.6µm (torneamento fino)', true),
            _CodeLine('; √ sem número = qualquer acabamento (bruto OK)', true),
          ]),
          const _Callout(icon: Icons.lightbulb_outline, color: Color(0xFF185FA5), bg: Color(0xFFE3F2FD),
            text: 'Para Ra < 0.8µm em torno: Vc alta (G96 S300+), fn pequeno (0.05-0.10 mm/rot), inserto com raio RE ≥ 0.8mm.'),
        ]),
      ),
      const SizedBox(height: 12),

      _ManualCard(
        titulo: 'Medição no Chão de Fábrica — Instrumentos',
        badge: 'Metrologia', badgeColor: Color(0xFF993C1D),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _ParamTable(rows: [
            ['Instrumento', 'Resolução | Aplicação'],
            ['Paquímetro', '0.02mm | Medição geral rápida'],
            ['Micrômetro externo', '0.001mm | Diâmetros externos precisos'],
            ['Micrômetro interno (3 pontos)', '0.001mm | Furos H6/H7 precisos'],
            ['Relógio comparador (DTI)', '0.001mm | Alinhamento, batimento'],
            ['Pino Go/NoGo', 'por campo IT | Verificação rápida em série'],
            ['Rugosímetro portátil', '0.01µm | Ra, Rz, Rmax em campo'],
          ]),
          const _Callout(icon: Icons.warning_amber_rounded, color: Color(0xFFE8A020), bg: Color(0xFFFFF8E1),
            text: 'Medir sempre com peça na temperatura de 20°C (ISO 1). Aço se dilata 11µm/°C/m — em usinagem intensa, esperar 15 min antes de medir H7.'),
        ]),
      ),
      const SizedBox(height: 20),
    ]);
  }
}
