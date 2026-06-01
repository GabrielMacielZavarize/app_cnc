import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class GuiaScreen extends StatefulWidget {
  const GuiaScreen({super.key});
  @override
  State<GuiaScreen> createState() => _GuiaScreenState();
}

class _GuiaScreenState extends State<GuiaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _busca = '';
  final _ctrl = TextEditingController();

  @override
  void initState() { super.initState(); _tab = TabController(length: 4, vsync: this); }
  @override
  void dispose() { _tab.dispose(); _ctrl.dispose(); super.dispose(); }

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
                decoration: BoxDecoration(color: kAmber, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.lightbulb_rounded, color: kDark, size: 20)),
              const SizedBox(width: 12),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Guia Rápido', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                Text('RESOLVA PROBLEMAS REAIS DO CHÃO DE FÁBRICA', style: TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.5)),
              ]),
            ]),
            const SizedBox(height: 14),
            TabBar(
              controller: _tab,
              labelColor: kAmber, unselectedLabelColor: Colors.grey,
              indicatorColor: kAmber, indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true, tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: '🔍 Por Problema'),
                Tab(text: '🔄 Equivalências'),
                Tab(text: '📝 Endereços'),
                Tab(text: '⚡ Referência Rápida'),
              ],
            ),
          ]),
        ),
        Expanded(child: TabBarView(controller: _tab, children: [
          _PorProblema(),
          _Equivalencias(),
          _Enderecos(),
          _ReferenciaRapida(),
        ])),
      ]),
    );
  }
}

// ─────────────────────────────────────────
// ABA 1 — BUSCA POR PROBLEMA REAL
// ─────────────────────────────────────────
class _PorProblema extends StatefulWidget {
  @override
  State<_PorProblema> createState() => _PorProblemaState();
}

class _PorProblemaState extends State<_PorProblema> {
  String _busca = '';
  final _ctrl = TextEditingController();

  List<_Problema> get _filtrados {
    if (_busca.isEmpty) return _problemas;
    final b = _busca.toLowerCase();
    return _problemas.where((p) =>
      p.problema.toLowerCase().contains(b) ||
      p.tags.any((t) => t.toLowerCase().contains(b)) ||
      p.solucao.toLowerCase().contains(b)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200)),
          child: Row(children: [
            Icon(Icons.search, color: _busca.isEmpty ? Colors.grey.shade400 : kAmber, size: 18),
            const SizedBox(width: 10),
            Expanded(child: TextField(
              controller: _ctrl,
              onChanged: (v) => setState(() => _busca = v),
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Ex: "como fazer rosca", "furo profundo", "acabamento"...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
            )),
            if (_busca.isNotEmpty) GestureDetector(
              onTap: () { _ctrl.clear(); setState(() => _busca = ''); },
              child: Icon(Icons.close_rounded, color: Colors.grey.shade400, size: 18)),
          ]),
        ),
      ),
      if (_busca.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
          child: Text('${_filtrados.length} resultado(s)',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500))),
      Expanded(child: _filtrados.isEmpty
        ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Nenhum resultado para "$_busca"',
              style: TextStyle(color: Colors.grey.shade400)),
          ]))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _filtrados.length,
            itemBuilder: (ctx, i) => Center(child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: _ProblemaCard(p: _filtrados[i]))))),
    ]);
  }
}

class _ProblemaCard extends StatefulWidget {
  final _Problema p;
  const _ProblemaCard({required this.p});
  @override
  State<_ProblemaCard> createState() => _ProblemaCardState();
}

class _ProblemaCardState extends State<_ProblemaCard> {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expandido = !_expandido),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _expandido ? kAmber.withValues(alpha: 0.5) : Colors.grey.shade100,
            width: _expandido ? 1.5 : 0.5)),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(width: 40, height: 40,
                decoration: BoxDecoration(
                  color: widget.p.cor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8)),
                child: Icon(widget.p.icone, color: widget.p.cor, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(widget.p.problema,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Wrap(spacing: 4, children: widget.p.tags.take(3).map((t) =>
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                    child: Text(t, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)))).toList()),
              ])),
              Icon(_expandido ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                color: Colors.grey.shade400, size: 20),
            ]),
          ),
          if (_expandido) Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Divider(height: 1),
              const SizedBox(height: 12),

              // CÓDIGO RECOMENDADO
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(8)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Código recomendado', style: TextStyle(color: Colors.grey.shade400, fontSize: 10)),
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.p.codigo));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Código copiado!'), duration: Duration(seconds: 1)));
                      },
                      child: const Row(children: [
                        Icon(Icons.copy_rounded, color: kAmber, size: 12),
                        SizedBox(width: 4),
                        Text('Copiar', style: TextStyle(color: kAmber, fontSize: 10)),
                      ])),
                  ]),
                  const SizedBox(height: 6),
                  Text(widget.p.codigo,
                    style: const TextStyle(color: Color(0xFF7EC8A4), fontSize: 12, fontFamily: 'monospace', height: 1.6)),
                ]),
              ),
              const SizedBox(height: 10),

              // SOLUÇÃO
              Text('Como resolver:', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kDark)),
              const SizedBox(height: 6),
              Text(widget.p.solucao, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5)),

              // DICA
              if (widget.p.dica.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFFFF3DC), borderRadius: BorderRadius.circular(8)),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFBA7517), size: 15),
                    const SizedBox(width: 6),
                    Expanded(child: Text(widget.p.dica,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF7A4F00), height: 1.4))),
                  ])),
              ],

              // FABRICANTES
              if (widget.p.fabricantes.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text('Como é em cada fabricante:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
                const SizedBox(height: 6),
                ...widget.p.fabricantes.entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(children: [
                    Container(
                      width: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(4)),
                      child: Text(e.key, style: const TextStyle(color: kAmber, fontSize: 10, fontWeight: FontWeight.w600))),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e.value,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontFamily: 'monospace'))),
                  ]))),
              ],
            ]),
          ),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────
// ABA 2 — EQUIVALÊNCIAS FANUC × SIEMENS × HAAS
// ─────────────────────────────────────────
class _Equivalencias extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 800), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(10)),
              child: const Row(children: [
                Icon(Icons.info_outline_rounded, color: kBlue, size: 16),
                SizedBox(width: 8),
                Expanded(child: Text('Mesma operação, comandos diferentes! Use esta tabela para converter programas entre fabricantes.',
                  style: TextStyle(fontSize: 12, color: kBlue, height: 1.4))),
              ])),
            const SizedBox(height: 16),

            // CABEÇALHO
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                Expanded(flex: 2, child: Text('Operação', style: const TextStyle(color: kAmber, fontSize: 11, fontWeight: FontWeight.w700))),
                Expanded(flex: 2, child: Text('FANUC', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('SIEMENS', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('HAAS', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700), textAlign: TextAlign.center)),
              ]),
            ),
            const SizedBox(height: 4),

            ..._equivalencias.asMap().entries.map((e) {
              final eq = e.value;
              final isSection = eq.operacao.startsWith('──');
              if (isSection) return Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(eq.operacao.replaceAll('──', '').trim(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kDark)));
              return GestureDetector(
                onTap: () => _mostrarDetalhes(context, eq),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: e.key.isOdd ? Colors.grey.shade50 : Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade100, width: 0.5)),
                  child: Row(children: [
                    Expanded(flex: 2, child: Text(eq.operacao,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500))),
                    Expanded(flex: 2, child: Text(eq.fanuc,
                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Color(0xFF003087)),
                      textAlign: TextAlign.center)),
                    Expanded(flex: 2, child: Text(eq.siemens,
                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Color(0xFF009999)),
                      textAlign: TextAlign.center)),
                    Expanded(flex: 2, child: Text(eq.haas,
                      style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Color(0xFF8B0000)),
                      textAlign: TextAlign.center)),
                  ]),
                ));
            }),
          ],
        ))),
      ],
    );
  }

  void _mostrarDetalhes(BuildContext context, _Equivalencia eq) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(eq.operacao, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(eq.descricao, style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4)),
          const SizedBox(height: 16),
          _fabRow('FANUC', eq.fanuc, const Color(0xFF003087)),
          const SizedBox(height: 8),
          _fabRow('SIEMENS', eq.siemens, const Color(0xFF009999)),
          const SizedBox(height: 8),
          _fabRow('HAAS', eq.haas, const Color(0xFF8B0000)),
          if (eq.nota.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFFFF3DC), borderRadius: BorderRadius.circular(8)),
              child: Text('⚠️ ${eq.nota}', style: const TextStyle(fontSize: 12, color: Color(0xFF7A4F00)))),
          ],
        ]),
      ),
    );
  }

  Widget _fabRow(String fab, String cmd, Color cor) => Row(children: [
    Container(width: 80, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: cor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(fab, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: cor), textAlign: TextAlign.center)),
    const SizedBox(width: 10),
    Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(6)),
      child: Text(cmd, style: const TextStyle(color: kAmber, fontSize: 12, fontFamily: 'monospace')))),
  ]);
}

// ─────────────────────────────────────────
// ABA 3 — ENDEREÇOS DE PROGRAMAÇÃO
// ─────────────────────────────────────────
class _Enderecos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(10)),
              child: const Text(
                'Cada letra no bloco CNC tem uma função específica. Entender os endereços é fundamental para ler e programar em qualquer máquina CNC do mundo.',
                style: TextStyle(fontSize: 12, color: kBlue, height: 1.5))),
            const SizedBox(height: 16),

            ..._grupos.map((grupo) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _secTitulo(grupo.nome, grupo.cor),
                const SizedBox(height: 8),
                ...grupo.enderecos.map((e) => Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade100)),
                  child: Row(children: [
                    Container(width: 40, height: 40,
                      decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(8)),
                      child: Center(child: Text(e.letra,
                        style: const TextStyle(color: kAmber, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'monospace')))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(e.nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(e.descricao, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
                    ])),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: e.maquina == 'Ambos' ? const Color(0xFFE1F5EE) :
                               e.maquina == 'Torno' ? const Color(0xFFFAECE7) : const Color(0xFFE6F1FB),
                        borderRadius: BorderRadius.circular(6)),
                      child: Text(e.maquina,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
                          color: e.maquina == 'Ambos' ? kGreen :
                                 e.maquina == 'Torno' ? const Color(0xFF993C1D) : kBlue))),
                  ]),
                )),
                const SizedBox(height: 12),
              ])),

            // ESTRUTURA DE UM BLOCO
            _secTitulo('Estrutura de um Bloco CNC', kDark),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Exemplo de bloco completo:', style: TextStyle(color: Colors.grey, fontSize: 11)),
                const SizedBox(height: 8),
                const Text('N0010 G01 X50.0 Y30.0 Z-5.0 F200 S1500 T02 M08',
                  style: TextStyle(color: kAmber, fontSize: 12, fontFamily: 'monospace', height: 1.6)),
                const SizedBox(height: 12),
                _blocoItem('N0010', 'Número do bloco (linha 10)'),
                _blocoItem('G01',   'Interpolação linear (modo de corte)'),
                _blocoItem('X50.0', 'Posição final no eixo X = 50mm'),
                _blocoItem('Y30.0', 'Posição final no eixo Y = 30mm'),
                _blocoItem('Z-5.0', 'Profundidade Z = -5mm'),
                _blocoItem('F200',  'Avanço = 200 mm/min'),
                _blocoItem('S1500', 'Rotação = 1500 RPM'),
                _blocoItem('T02',   'Ferramenta número 2'),
                _blocoItem('M08',   'Liga refrigeração'),
              ]),
            ),
          ],
        ))),
      ],
    );
  }

  Widget _blocoItem(String letra, String desc) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(children: [
      SizedBox(width: 120, child: Text(letra,
        style: const TextStyle(color: Color(0xFF79C0FF), fontSize: 11, fontFamily: 'monospace'))),
      Expanded(child: Text('→ $desc',
        style: const TextStyle(color: Colors.grey, fontSize: 11))),
    ]));

  Widget _secTitulo(String t, Color cor) => Row(children: [
    Container(width: 4, height: 16, decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 8),
    Text(t, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: cor)),
  ]);
}

// ─────────────────────────────────────────
// ABA 4 — REFERÊNCIA RÁPIDA
// ─────────────────────────────────────────
class _ReferenciaRapida extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _card('🚀 Início de Programa — Sequência Obrigatória', kBlue, '''O[NÚMERO] (NOME DO PROGRAMA)
;
G21          ; Milímetros
G40 G49 G80  ; Cancela compensações
G91 G28 Z0   ; Retorno Z ao zero
G91 G28 X0 Y0; Retorno XY ao zero
G90          ; Modo absoluto
;
T01 M06      ; Troca ferramenta
G43 H01 Z100.; Compensação comprimento
G54          ; Zero-peça 1
S1500 M03    ; Liga spindle
M08          ; Liga refrigeração'''),

            _card('🏁 Fim de Programa — Sequência Obrigatória', kGreen, '''G00 Z50.     ; Sobe Z para posição segura
M09          ; Desliga refrigeração
G91 G28 Z0   ; Retorno Z ao zero
G91 G28 X0 Y0; Retorno XY ao zero
M05          ; Para spindle
M30          ; Fim e rebobina'''),

            _card('🔩 Rosqueamento — Fórmula Crítica', kRed, '''; FÓRMULA: F = PASSO × RPM
; Exemplo: M10 × 1.5mm a 300 RPM
; F = 1.5 × 300 = 450 mm/min
;
M49          ; Trava override (OBRIGATÓRIO!)
G97 S300 M03 ; RPM FIXO (nunca G96 em rosca!)
G84 X20. Y15. Z-20. R5. F450
G80
M48          ; Libera override'''),

            _card('📐 Fórmulas Essenciais', kAmber, '''; RPM = (Vc × 1000) ÷ (π × D)
; Vc=200 m/min, D=10mm → RPM=6366
;
; AVANÇO DA MESA (Vf)
; Vf = fz × Z × RPM
; fz=0.05, Z=4, RPM=6366 → Vf=1273 mm/min
;
; FURO PARA MACHO
; Ø = D_nominal - (1.0825 × passo)
; M10×1.5 → Ø = 10 - (1.0825×1.5) = 8.376mm
;
; CSS TORNO (G96)
; RPM = (Vc × 1000) ÷ (π × D_atual)'''),

            _card('⚠️ Regras de Segurança CNC', const Color(0xFFA32D2D), '''; SEMPRE faça em ordem:
; 1. G28 Z0 antes de G28 X0 Y0
;    (sobe Z primeiro — evita colisão)
;
; 2. G43 H[n] após TODA troca de ferramenta
;    (sem compensação → colisão garantida)
;
; 3. G49 ao final do programa
;    (cancela compensação de comprimento)
;
; 4. G40 antes de sair do perfil
;    (nunca cancele G41/G42 no meio do perfil)
;
; 5. M49 durante rosqueamento
;    (override alterado = macho quebrado)'''),

            _card('🔄 Torno — Sequência G71+G70', const Color(0xFF993C1D), '''; DESBASTE EXTERNO + ACABAMENTO
;
T0101                  ; Pastilha desbaste
G50 S3000              ; Limite RPM
G96 S200 M03           ; Vc=200 m/min
G95                    ; Avanço mm/rot
G00 X[D_max+2] Z2.
;
G71 U2.0 R0.5          ; ap=2mm, recuo=0.5
G71 P10 Q20 U0.4 W0.1 F0.25
;
N10 G00 X[D_min-2]     ; Início do perfil
G01 Z0 F0.15
G01 X[D1] Z[C1]        ; Chanfro ou raio
G01 Z[Z1]              ; Diâmetro 1
G01 X[D2]              ; Transição
N20 G01 Z[Z2]          ; Fim do perfil
;
G00 X100. Z50.
T0202                  ; Pastilha acabamento
G96 S280 M03
G00 X[D_max+2] Z2.
G70 P10 Q20            ; Acabamento!'''),

            _card('💡 Compensação de Raio — G41/G42', kBlue, '''; G41 = FRESA À ESQUERDA DO PERFIL
; G42 = FRESA À DIREITA DO PERFIL
; D[n] = raio da fresa na tabela de offsets
;
; ENTRADA (sempre tangencial):
G41 D01 G01 X[entX] F200.
G03 X[iniX] Y[iniY] R[raio]  ; Arco entrada
;
; PERFIL:
G01 Y[Y1]
G01 X[X2]
G01 Y[Y2]
;
; SAÍDA (sempre tangencial):
G03 X[saiX] Y[saiY] R[raio]
G40 G00 X[longe]     ; Cancela SEMPRE com movimento
;
; DICA: Mude só D[n] para trocar fresa
; sem reprogramar o perfil!'''),
          ],
        ))),
      ],
    );
  }

  Widget _card(String titulo, Color cor, String codigo) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade100)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: cor.withValues(alpha: 0.08),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(11))),
        child: Text(titulo, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: cor))),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: kDark,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(11))),
        child: SelectableText(codigo,
          style: const TextStyle(color: Color(0xFFE6EDF3), fontSize: 11, fontFamily: 'monospace', height: 1.7))),
    ]));
}

// ─────────────────────────────────────────
// MODELOS
// ─────────────────────────────────────────
class _Problema {
  final String problema, solucao, codigo, dica;
  final List<String> tags;
  final Map<String, String> fabricantes;
  final Color cor;
  final IconData icone;
  const _Problema(this.problema, this.solucao, this.codigo, this.dica,
    this.tags, this.fabricantes, this.cor, this.icone);
}

class _Equivalencia {
  final String operacao, fanuc, siemens, haas, descricao, nota;
  const _Equivalencia(this.operacao, this.fanuc, this.siemens, this.haas,
    this.descricao, this.nota);
}

class _Endereco {
  final String letra, nome, descricao, maquina;
  const _Endereco(this.letra, this.nome, this.descricao, this.maquina);
}

class _GrupoEnderecos {
  final String nome;
  final Color cor;
  final List<_Endereco> enderecos;
  const _GrupoEnderecos(this.nome, this.cor, this.enderecos);
}

// ─────────────────────────────────────────
// DADOS — PROBLEMAS REAIS
// ─────────────────────────────────────────
const _problemas = [
  _Problema(
    'Como fazer rosca com macho no centro de usinagem?',
    'Use o ciclo G84 (rosca direita) ou G74 (rosca esquerda). A chave é calcular o avanço correto: F = passo × RPM. Trave o override com M49 antes para não quebrar o macho.',
    'M49              ; Trava override\nG97 S300 M03     ; RPM FIXO\nG84 X20. Y15. Z-20. R5. F450\n; M10×1.5: F=300×1.5=450\nG80\nM48              ; Libera override',
    'NUNCA use G96 (CSS) para rosqueamento — use sempre G97 (RPM fixo). O avanço deve ser calculado com exatidão: se F estiver errado, o macho quebra.',
    ['rosca', 'macho', 'tapping', 'G84', 'rosqueamento', 'M10', 'M12', 'M6'],
    {'FANUC': 'G84 X.. Z.. F[passo×RPM]', 'SIEMENS': 'CYCLE84()', 'HAAS': 'G84 (igual Fanuc)'},
    Color(0xFF993C1D), Icons.settings_rounded),

  _Problema(
    'Como fazer furo profundo sem quebrar a broca?',
    'Use o ciclo G83 (peck drilling) que retrai totalmente a cada passo Q para remover o cavaco. Para furos L/D > 5, use passos de 1-1.5× o diâmetro da broca.',
    'G99 G83 X20. Y15. Z-50. R2. Q8. F60\n; Z=-50mm profundidade\n; Q=8mm por passo (peck)\n; Retrai completamente a cada 8mm\nG80',
    'Para inox e titânio, reduza Q para 0.5× o diâmetro e use fluido interno (M50) se disponível. A retração total remove o cavaco que é o maior causador de quebra.',
    ['furo profundo', 'broca', 'peck', 'G83', 'furação', 'cavaco', 'quebra'],
    {'FANUC': 'G83 Z.. Q.. F..', 'SIEMENS': 'CYCLE83()', 'HAAS': 'G83 (igual Fanuc)'},
    Color(0xFF185FA5), Icons.radio_button_unchecked),

  _Problema(
    'Como usinar um contorno/perfil externo com precisão?',
    'Use a compensação de raio G41 (fresa à esquerda) ou G42 (direita). Assim você programa o perfil exato e a máquina compensa o raio da fresa automaticamente. Pode trocar a fresa sem reprogramar.',
    'G41 D01 G01 X10. F200.  ; D01=raio da fresa\nG03 X-30. Y-20. R20.    ; Entrada tangencial\nG01 Y20.                 ; Lateral\nG01 X30.                 ; Topo\nG01 Y-20.                ; Lateral\nG01 X-30.                ; Base\nG03 X-30. Y-40. R20.    ; Saída\nG40 G00 X0               ; Cancela',
    'Sempre entre e saia do perfil com um arco tangencial (G02/G03) para evitar marcas de entrada. O valor D01 é o raio da fresa — mude só ele quando trocar de ferramenta.',
    ['contorno', 'perfil', 'G41', 'G42', 'compensação de raio', 'externo', 'fresamento'],
    {'FANUC': 'G41 D[n] / G42 D[n]', 'SIEMENS': 'G41 D[n] / G42 D[n]', 'HAAS': 'G41 D[n] / G42 D[n]'},
    Color(0xFF0F6E56), Icons.crop_free_rounded),

  _Problema(
    'Como fazer desbaste automático no torno (sem programar cada passe)?',
    'Use o ciclo G71 (Fanuc) que executa todos os passes de desbaste automaticamente. Você programa só o perfil final (entre N10 e N20) e o CNC calcula quantos passes são necessários.',
    'G71 U2.0 R0.5            ; ap=2mm, recuo=0.5mm\nG71 P10 Q20 U0.4 W0.1 F0.25\nN10 G00 X18.              ; Início do perfil\nG01 Z0\nG01 X20. Z-1.             ; Chanfro\nG01 Z-30.                 ; Ø20 por 30mm\nG01 X40. Z-31.            ; Chanfro\nN20 G01 Z-60.             ; Fim do perfil\nG70 P10 Q20              ; Acabamento!',
    'Após G71, sempre use G70 com outra pastilha para o acabamento. O G71 deixa 0.4mm (U=0.4) radial e 0.1mm (W=0.1) axial para o G70 tirar.',
    ['desbaste', 'torno', 'G71', 'automático', 'perfil', 'ciclo', 'torneamento'],
    {'FANUC': 'G71 U[ap] R[rec] / G71 P Q U W F', 'SIEMENS': 'CYCLE95()', 'HAAS': 'G71 (igual Fanuc)'},
    Color(0xFF534AB7), Icons.rotate_right_rounded),

  _Problema(
    'Como fazer rosca externa no torno?',
    'Use G92 (um passe por bloco) ou G76 (ciclo automático completo). O G92 dá mais controle sobre cada passe. F = passo da rosca em mm. RPM deve ser FIXO (G97).',
    '; ROSCA M20×2.5 — MÉTODO G92\nG97 S400 M03       ; RPM FIXO!\nG92 X19.4 Z-42. F2.5  ; Passe 1\nG92 X18.9 Z-42. F2.5  ; Passe 2\nG92 X18.5 Z-42. F2.5  ; Passe 3\nG92 X18.0 Z-42. F2.5  ; Passe 4\nG92 X17.4 Z-42. F2.5  ; Passe 5\nG92 X16.93 Z-42. F2.5 ; Acabamento\nG92 X16.93 Z-42. F2.5 ; Limpeza',
    'Profundidade total M20×2.5 = 1.534mm radial → Ø final = 16.933mm. Passes progressivos: mais fundo no início, mais raso no final. NUNCA pare o spindle durante o rosqueamento.',
    ['rosca', 'torno', 'G92', 'G76', 'M20', 'externa', 'filete', 'torneamento'],
    {'FANUC': 'G92 X[d] Z[l] F[passo] ou G76 P.. Q.. R..\nG76 X[d] Z[l] P[h] Q[1°p] F[passo]', 'SIEMENS': 'CYCLE97()', 'HAAS': 'G92 (igual Fanuc)'},
    Color(0xFF993C1D), Icons.settings_outlined),

  _Problema(
    'Como fazer bolsão (pocket) circular?',
    'Estratégia de espiral crescente do centro para fora. Comece mergulhando no centro do bolsão e vá aumentando o raio com arcos G03 até chegar à parede. Finalize com um passe de acabamento G41.',
    'G00 X0 Y0          ; Centro do bolsão\nG01 Z-5. F80.      ; Mergulha (fresa de fundo!)\nG03 X10. Y0 I5. J0 F200.  ; R=5mm\nG03 X10. Y0 I-10. J0      ; Círculo R=10\nG03 X20. Y0 I-10. J0      ; Círculo R=20 (parede)\nG41 D01\nG03 X20. Y0 I-20. J0 F150.; Acabamento parede\nG40',
    'A fresa DEVE ter capacidade de mergulho (fundo cortante). Para bolsões grandes, faça a espiral em passos de 40-50% do diâmetro da fresa para distribuir o calor uniformemente.',
    ['bolsão', 'pocket', 'circular', 'espiral', 'fresamento', 'cavidade'],
    {'FANUC': 'G02/G03 espiral + G41/G42', 'SIEMENS': 'CYCLE73() ou POCKET3()', 'HAAS': 'G02/G03 (igual Fanuc)'},
    Color(0xFFBA7517), Icons.circle_outlined),

  _Problema(
    'Como fazer furos em padrão circular (flange)?',
    'Calcule as coordenadas XY de cada furo usando trigonometria: X = R×cos(ângulo) e Y = R×sen(ângulo). Para 8 furos em círculo de R=40mm, o ângulo entre furos = 360÷8 = 45°.',
    '; 8 FUROS EM CÍRCULO R=40mm\nG99 G83 R2. Z-17. Q5. F60.\nX40.  Y0.     ; 0°\nX28.3 Y28.3   ; 45°\nX0.   Y40.    ; 90°\nX-28.3 Y28.3  ; 135°\nX-40. Y0.     ; 180°\nX-28.3 Y-28.3 ; 225°\nX0.   Y-40.   ; 270°\nX28.3 Y-28.3  ; 315°\nG80',
    'Fórmula: X=R×cos(n×360÷N), Y=R×sin(n×360÷N) onde N=total de furos, n=número do furo. Use a calculadora do app (módulo Calculadora) para calcular.',
    ['flange', 'furos circular', 'padrão', 'bolt circle', 'trigonometria', 'PCD'],
    {'FANUC': 'G81/G83 com coordenadas calculadas', 'SIEMENS': 'HOLES1() ou HOLES2()', 'HAAS': 'G81/G83 (igual Fanuc)'},
    Color(0xFF2E7D32), Icons.rotate_right_rounded),

  _Problema(
    'A peça ficou fora de medida — o que fazer?',
    'Verifique na ordem: 1) Offset de ferramenta (comprimento e raio) 2) Zero-peça G54 3) Desgaste da ferramenta 4) Dilatação térmica. Na maioria dos casos é o offset de raio (D) ou o zero-peça.',
    '; VERIFICAR E CORRIGIR OFFSET\n; No painel: OFFSET > GEOMETRY\n; H[n] = comprimento da ferramenta\n; D[n] = raio da fresa\n;\n; Se peça grande: AUMENTAR D[n]\n; Se peça pequena: DIMINUIR D[n]\n;\n; 1μm = 0.001mm no offset = 0.002mm na peça\n; (corta dos dois lados)',
    'Com G41 ativo: aumentar D[n] em 0.01mm aumenta a peça em 0.02mm (dois lados). Para corrações de menos de 0.1mm, ajuste o offset sem parar o programa — use o ajuste incremental.',
    ['fora de medida', 'offset', 'correção', 'tolerância', 'ajuste', 'qualidade'],
    {'FANUC': 'OFFSET > WEAR > D[n] ou H[n]', 'SIEMENS': 'Tool Offset > D[n]', 'HAAS': 'OFFSET > D[n]'},
    Color(0xFFA32D2D), Icons.straighten_rounded),

  _Problema(
    'Como evitar vibração e chatter na usinagem?',
    'Vibração (chatter) é causada por ressonância entre a ferramenta e a peça. Soluções: mudar RPM ±10%, reduzir comprimento de ferramenta, aumentar número de dentes, verificar fixação.',
    '; AJUSTES PARA ELIMINAR VIBRAÇÃO\n;\n; 1. Mudar RPM ±10% (quebra ressonância)\n;    S1500 → S1650 ou S1350\n;\n; 2. Reduzir avanço (F) em 20%\n;\n; 3. Reduzir profundidade ap em 30%\n;\n; 4. Usar fresa com número ímpar de\n;    dentes (3 ou 5 flutes)\n;\n; 5. Encurtar saliência da ferramenta\n;    máximo: 3× diâmetro',
    'A regra do 3D: saliência máxima = 3× diâmetro. Para Ø10mm → máximo 30mm de saliência. Cada mm extra de saliência aumenta a deflexão exponencialmente.',
    ['vibração', 'chatter', 'vibrar', 'barulho', 'ressonância', 'acabamento ruim'],
    {'Solução universal': 'Mudar RPM ±10% e verificar fixação'},
    Color(0xFF534AB7), Icons.graphic_eq_rounded),

  _Problema(
    'Como programar chanfro 45° no torno?',
    'No torno, um chanfro 1×45° significa avançar 1mm em X e 1mm em Z simultaneamente com G01. A relação X:Z é sempre 1:1 para 45°.',
    '; CHANFRO 1×45° AO PASSAR DE Ø20 PARA Ø30\n;\nG01 Z-20.          ; Torna Ø20 até Z-20\nG01 X22. Z-21.     ; Chanfro: +1mm X e -1mm Z\nG01 X30.           ; Transição para Ø30\n;\n; CHANFRO 2×45°:\n; G01 X22. Z-22.    ; +2mm X e -2mm Z',
    'Para chanfro de entrada (no início da peça): G01 X[D-2] Z0 → G01 X[D] Z-1 (chanfro 1mm). Sempre inclua chanfros nas transições de diâmetro para facilitar a montagem e evitar rebarbas.',
    ['chanfro', 'torno', '45 graus', 'chanfrar', 'transição', 'bevel'],
    {'FANUC': 'G01 X[+ap] Z[-ap] (ângulo automático)', 'SIEMENS': ',CHF=[tamanho] no bloco', 'HAAS': 'G01 X Z (igual Fanuc)'},
    Color(0xFF185FA5), Icons.change_history_rounded),

  _Problema(
    'Como fazer raio de canto no torno?',
    'Use G02 (raio convexo externo) ou G03 (raio côncavo interno) no plano XZ. O raio une dois diâmetros com uma curva suave. Muito usado em eixos e buchas.',
    '; RAIO R3 ENTRE Ø20 E Ø30 NO TORNO\n;\nG18            ; Plano XZ (torno)\nG01 Z-20.      ; Torna Ø20 até Z-20\nG02 X26. Z-23. R3. F0.1  ; Raio côncavo R3\nG01 X30.       ; Continua em Ø30\n;\n; PARA RAIO CONVEXO (arredondado):\n; G03 X26. Z-17. R3.',
    'G18 é o plano XZ — obrigatório para arcos no torno! Sem G18, o CNC usa o plano errado. Verifique se está ativo antes de G02/G03.',
    ['raio', 'torno', 'arredondamento', 'G02', 'G03', 'corner radius', 'R'],
    {'FANUC': 'G18 + G02/G03 X Z R', 'SIEMENS': ',RND=[raio] no bloco', 'HAAS': 'G18 + G02/G03'},
    Color(0xFF0F6E56), Icons.rounded_corner_rounded),
];

// ─────────────────────────────────────────
// DADOS — EQUIVALÊNCIAS
// ─────────────────────────────────────────
const _equivalencias = [
  _Equivalencia('── MOVIMENTAÇÃO ──', '', '', '', '', ''),
  _Equivalencia('Posicionamento rápido', 'G00', 'G00', 'G00', 'Move na velocidade máxima sem corte', ''),
  _Equivalencia('Interpolação linear', 'G01', 'G01', 'G01', 'Movimento linear com corte', ''),
  _Equivalencia('Arco horário', 'G02', 'G02', 'G02', 'Interpolação circular CW', ''),
  _Equivalencia('Arco anti-horário', 'G03', 'G03', 'G03', 'Interpolação circular CCW', ''),
  _Equivalencia('Pausa (Dwell)', 'G04 P[ms]', 'G04 F[s]', 'G04 P[ms]', 'Para movimentos por tempo definido', 'Siemens usa F em segundos, Fanuc/Haas usam P em ms'),

  _Equivalencia('── PLANOS E UNIDADES ──', '', '', '', '', ''),
  _Equivalencia('Plano XY (fresamento)', 'G17', 'G17', 'G17', 'Plano de trabalho para arcos', ''),
  _Equivalencia('Plano XZ (torneamento)', 'G18', 'G18', 'G18', 'Plano padrão para tornos', ''),
  _Equivalencia('Milímetros', 'G21', 'G71*', 'G21', 'Define unidade em mm', '*Siemens: parâmetro de máquina'),
  _Equivalencia('Polegadas', 'G20', 'G70*', 'G20', 'Define unidade em polegadas', '*Siemens: G70 tem função diferente'),

  _Equivalencia('── COMPENSAÇÃO ──', '', '', '', '', ''),
  _Equivalencia('Comp. raio esquerda', 'G41 D[n]', 'G41 D[n]', 'G41 D[n]', 'Fresa à esquerda do perfil', ''),
  _Equivalencia('Comp. raio direita', 'G42 D[n]', 'G42 D[n]', 'G42 D[n]', 'Fresa à direita do perfil', ''),
  _Equivalencia('Cancela comp. raio', 'G40', 'G40', 'G40', 'Desativa G41/G42', ''),
  _Equivalencia('Comp. comprimento+', 'G43 H[n]', 'N/A*', 'G43 H[n]', 'Ativa offset de comprimento', '*Siemens usa sistema de ferramentas diferente'),
  _Equivalencia('Cancela comp. comp.', 'G49', 'N/A', 'G49', 'Desativa G43/G44', ''),

  _Equivalencia('── COORDENADAS ──', '', '', '', '', ''),
  _Equivalencia('Absoluto', 'G90', 'G90', 'G90', 'Coordenadas do zero-peça', ''),
  _Equivalencia('Incremental', 'G91', 'G91', 'G91', 'Coordenadas relativas', ''),
  _Equivalencia('Zero-peça 1', 'G54', 'G54', 'G54', 'Primeiro sistema de trabalho', ''),
  _Equivalencia('Zero-peças 1-6', 'G54-G59', 'G54-G59', 'G54-G59', 'Sistemas de coordenadas', ''),
  _Equivalencia('Zero-peças extras', 'G54.1 P1-48', 'G505-G599', 'G110-G129', 'Offsets adicionais', ''),
  _Equivalencia('Retorno ao zero', 'G28 Z0', 'G74 Z0', 'G28 Z0', 'Vai ao home da máquina', 'Siemens usa G74 para retorno ao zero'),

  _Equivalencia('── AVANÇO E VELOCIDADE ──', '', '', '', '', ''),
  _Equivalencia('Avanço mm/min', 'G94', 'G94', 'G94', 'Padrão para fresamento', ''),
  _Equivalencia('Avanço mm/rot', 'G95', 'G95', 'G95', 'Padrão para torneamento', ''),
  _Equivalencia('Veloc. corte const. (CSS)', 'G96 S[m/min]', 'G96 S[m/min]', 'G96 S[m/min]', 'Mantém Vc constante no torno', ''),
  _Equivalencia('RPM constante', 'G97 S[RPM]', 'G97 S[RPM]', 'G97 S[RPM]', 'Rotação fixa em RPM', ''),
  _Equivalencia('Limite de RPM', 'G92 S[RPM]', 'G25 S[RPM]', 'G50 S[RPM]', 'Limita RPM máximo com G96', ''),

  _Equivalencia('── CICLOS FIXOS — FURAÇÃO ──', '', '', '', '', ''),
  _Equivalencia('Cancela ciclo fixo', 'G80', 'G80', 'G80', 'Desativa qualquer ciclo', ''),
  _Equivalencia('Furação simples', 'G81', 'CYCLE81()', 'G81', 'Fura e retrai rapidamente', ''),
  _Equivalencia('Furação com pausa', 'G82', 'CYCLE82()', 'G82', 'Pausa no fundo do furo', ''),
  _Equivalencia('Furação profunda', 'G83', 'CYCLE83()', 'G83', 'Retração total para cavaco', ''),
  _Equivalencia('Rosqueamento dir.', 'G84', 'CYCLE84()', 'G84', 'Ciclo de rosca direita', ''),
  _Equivalencia('Rosqueamento esq.', 'G74', 'CYCLE840()', 'G74', 'Ciclo de rosca esquerda', ''),
  _Equivalencia('Mandrilamento fino', 'G76', 'CYCLE76()', 'G76*', 'Mandrila sem riscar', '*Haas: G76 pode ter sintaxe diferente'),
  _Equivalencia('Mandrilamento simples', 'G85', 'CYCLE85()', 'G85', 'Entra e sai com avanço', ''),
  _Equivalencia('Retorno ao plano R', 'G99', 'N/A', 'G99', 'Mais rápido entre furos', ''),
  _Equivalencia('Retorno ao plano ini.', 'G98', 'N/A', 'G98', 'Mais seguro entre furos', ''),

  _Equivalencia('── CICLOS TORNO ──', '', '', '', '', ''),
  _Equivalencia('Acabamento torno', 'G70 P Q', 'CYCLE95()', 'G70 P Q', 'Passe fino após G71/G72', ''),
  _Equivalencia('Desbaste longitudinal', 'G71 U R / P Q', 'CYCLE95()', 'G71', 'Desbaste paralelo ao Z', ''),
  _Equivalencia('Desbaste transversal', 'G72 W R / P Q', 'CYCLE95()', 'G72', 'Desbaste paralelo ao X', ''),
  _Equivalencia('Desbaste por cópia', 'G73 U W R / P Q', 'CYCLE95()', 'G73', 'Paralelo ao perfil', ''),
  _Equivalencia('Rosca automática', 'G76 P Q R\nG76 X Z P Q F', 'CYCLE97()', 'G76', 'Ciclo completo de rosca', ''),
  _Equivalencia('Rosca passe a passe', 'G92 X Z F', 'G33 Z F K', 'G92 X Z F', 'Um bloco = um passe', 'Siemens G33 tem sintaxe diferente'),
  _Equivalencia('Canal/Ranhura', 'G75 X Z P Q', 'CYCLE93()', 'G75', 'Ciclo de sangramento/canal', ''),

  _Equivalencia('── FUNÇÕES AUXILIARES ──', '', '', '', '', ''),
  _Equivalencia('Spindle horário', 'M03', 'M03', 'M03', 'Liga CW', ''),
  _Equivalencia('Spindle anti-horário', 'M04', 'M04', 'M04', 'Liga CCW', ''),
  _Equivalencia('Para spindle', 'M05', 'M05', 'M05', 'Stop', ''),
  _Equivalencia('Troca ferramenta', 'T[n] M06', 'T[n] M06', 'T[n] M06', 'ATC', ''),
  _Equivalencia('Liga fluido', 'M08', 'M08', 'M08', 'Flood coolant on', ''),
  _Equivalencia('Desliga fluido', 'M09', 'M09', 'M09', 'Coolant off', ''),
  _Equivalencia('Fim do programa', 'M30', 'M30', 'M30', 'End + rewind', ''),
  _Equivalencia('Subprograma chamada', 'M98 P[n]', 'L[n]', 'M98 P[n]', 'Chama subprograma', 'Siemens chama com L[número]'),
  _Equivalencia('Fim subprograma', 'M99', 'RET', 'M99', 'Retorna ao principal', 'Siemens usa RET'),
  _Equivalencia('Parada obrigatória', 'M00', 'M00', 'M00', 'Para e aguarda CycleStart', ''),
  _Equivalencia('Parada opcional', 'M01', 'M01', 'M01', 'Para se chave ligada', ''),
];

// ─────────────────────────────────────────
// DADOS — ENDEREÇOS
// ─────────────────────────────────────────
const _grupos = [
  _GrupoEnderecos('Identificação do Programa e Bloco', kDark, [
    _Endereco('O', 'Número do Programa', 'Identifica o programa. Ex: O0001 = programa 1. Sempre no início, antes de qualquer código.', 'Ambos'),
    _Endereco('N', 'Número do Bloco (Sequência)', 'Número da linha. Não obrigatório mas facilita referências. Ex: N0010, N0020... Incrementos de 10 permitem inserir linhas.', 'Ambos'),
  ]),
  _GrupoEnderecos('Eixos de Movimento', kBlue, [
    _Endereco('X', 'Eixo X (horizontal)', 'Fresamento: eixo horizontal mesa. Torneamento: diâmetro da peça (programado como diâmetro, não raio).', 'Ambos'),
    _Endereco('Y', 'Eixo Y (perpendicular)', 'Eixo perpendicular ao X na horizontal. Usado principalmente em fresamento.', 'Centro'),
    _Endereco('Z', 'Eixo Z (vertical/axial)', 'Fresamento: eixo do spindle (vertical). Torneamento: comprimento axial.', 'Ambos'),
    _Endereco('U', 'Incremental X (torno)', 'Deslocamento incremental no eixo X do torno. U2. = avança 2mm no diâmetro (1mm no raio).', 'Torno'),
    _Endereco('W', 'Incremental Z (torno)', 'Deslocamento incremental no eixo Z do torno. W-5. = avança 5mm axialmente.', 'Torno'),
    _Endereco('A', 'Eixo rotativo A', 'Rotação em torno do eixo X. Usado em máquinas de 4º e 5º eixo.', 'Centro'),
    _Endereco('B', 'Eixo rotativo B', 'Rotação em torno do eixo Y. Cabeçote inclinável em 5 eixos.', 'Centro'),
    _Endereco('C', 'Eixo rotativo C', 'Rotação em torno do eixo Z. Torno com eixo C para fresamento.', 'Ambos'),
  ]),
  _GrupoEnderecos('Parâmetros de Arco', kGreen, [
    _Endereco('I', 'Centro do arco em X', 'Distância do ponto inicial ao centro do arco no eixo X. Usado como alternativa ao R.', 'Ambos'),
    _Endereco('J', 'Centro do arco em Y', 'Distância do ponto inicial ao centro do arco no eixo Y.', 'Ambos'),
    _Endereco('K', 'Centro do arco em Z', 'Distância ao centro no eixo Z. Usado em arcos no plano XZ ou YZ.', 'Ambos'),
    _Endereco('R', 'Raio do arco', 'Raio da interpolação circular. R+ = arco < 180°. R- = arco > 180°. Mais simples que I,J,K.', 'Ambos'),
  ]),
  _GrupoEnderecos('Velocidades e Avanços', Color(0xFF993C1D), [
    _Endereco('S', 'Velocidade do Spindle', 'Com G97: S = RPM. Com G96: S = velocidade de corte em m/min. Ex: S1500 = 1500 RPM ou 150 m/min.', 'Ambos'),
    _Endereco('F', 'Taxa de Avanço (Feed)', 'Com G94: F = mm/min. Com G95: F = mm/rotação. Em rosqueamento: F = passo da rosca. CRÍTICO!', 'Ambos'),
  ]),
  _GrupoEnderecos('Ferramentas e Offsets', kAmber, [
    _Endereco('T', 'Seleção de Ferramenta', 'Fresamento: T01 a T60 (número da ferramenta). Torno: T0101 (dois dígitos = ferramenta + dois dígitos = offset).', 'Ambos'),
    _Endereco('H', 'Offset de Comprimento', 'Número da tabela de offset de comprimento. G43 H01 = ativa offset H01. Cada ferramenta tem seu H.', 'Centro'),
    _Endereco('D', 'Offset de Raio', 'Número do offset de raio da fresa. G41 D01 = compensa pelo raio armazenado em D01. Troque D para trocar fresa.', 'Centro'),
  ]),
  _GrupoEnderecos('Parâmetros de Ciclos Fixos', kBlue, [
    _Endereco('Q', 'Incremento por passo', 'Em G83: passo de furação (ex: Q8. = 8mm por peck). Em G76: primeiro passe de profundidade. Em G71: não usado.', 'Ambos'),
    _Endereco('P', 'Pausa / Subprograma', 'Em G82/G89: pausa em ms (P500 = 0.5s). Em M98: número do subprograma (P1001 = O1001).', 'Ambos'),
    _Endereco('L', 'Número de repetições', 'Em M98: quantas vezes chamar o subprograma. Em Siemens: número do subprograma.', 'Ambos'),
  ]),
];