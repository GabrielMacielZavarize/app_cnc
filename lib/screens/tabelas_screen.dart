import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class TabelasScreen extends StatefulWidget {
  const TabelasScreen({super.key});
  @override
  State<TabelasScreen> createState() => _TabelasScreenState();
}

class _TabelasScreenState extends State<TabelasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() { super.initState(); _tab = TabController(length: 6, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

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
                child: const Icon(Icons.table_chart_rounded, color: Colors.white, size: 20)),
              const SizedBox(width: 12),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Tabelas Técnicas', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                Text('REFERÊNCIA MUNDIAL DE USINAGEM', style: TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.5)),
              ]),
            ]),
            const SizedBox(height: 16),
            TabBar(
              controller: _tab,
              labelColor: kAmber, unselectedLabelColor: Colors.grey,
              indicatorColor: kAmber, indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true, tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Roscas Métricas'),
                Tab(text: 'Roscas BSP/NPT'),
                Tab(text: 'Tolerâncias ISO'),
                Tab(text: 'Conversões'),
                Tab(text: 'Chaves/Parafusos'),
                Tab(text: 'Parâm. de Corte'),
              ],
            ),
          ]),
        ),
        Expanded(child: TabBarView(controller: _tab, children: [
          _RoscasMetricas(),
          _RoscasBSP(),
          _ToleranciasISO(),
          _Conversoes(),
          _ChavesParafusos(),
          const _ParametrosCorte(),
        ])),
      ]),
    );
  }
}

// ─────────────────────────────────────────
// ROSCAS MÉTRICAS
// ─────────────────────────────────────────
class _RoscasMetricas extends StatefulWidget {
  @override
  State<_RoscasMetricas> createState() => _RoscasMetricasState();
}

class _RoscasMetricasState extends State<_RoscasMetricas> {
  String _busca = '';

  @override
  Widget build(BuildContext context) {
    final dados = _roscasMetricas.where((r) =>
      _busca.isEmpty || r.nome.toLowerCase().contains(_busca.toLowerCase())).toList();

    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade200)),
          child: Row(children: [
            Icon(Icons.search, color: Colors.grey.shade400, size: 18),
            const SizedBox(width: 10),
            Expanded(child: TextField(
              onChanged: (v) => setState(() => _busca = v),
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Buscar rosca (ex: M10, M16...)',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
            )),
          ]),
        ),
      ),
      const SizedBox(height: 8),
      // CABEÇALHO
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          _th('Rosca', 2), _th('Passo\n(mm)', 1), _th('Furo\nMacho', 1),
          _th('Diâm.\nMédio', 1), _th('Chave\n(mm)', 1),
        ]),
      ),
      const SizedBox(height: 4),
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: dados.length,
        itemBuilder: (ctx, i) {
          final r = dados[i];
          return Center(child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: GestureDetector(
              onTap: () => _mostrarDetalhes(context, r),
              child: Container(
                margin: const EdgeInsets.only(bottom: 3),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: i.isOdd ? Colors.grey.shade50 : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade100, width: 0.5)),
                child: Row(children: [
                  Expanded(flex: 2, child: Text(r.nome,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kBlue))),
                  Expanded(flex: 1, child: Text(r.passo,
                    style: const TextStyle(fontSize: 12), textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text(r.furoBroca,
                    style: const TextStyle(fontSize: 12, color: kGreen, fontWeight: FontWeight.w500), textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text(r.diametroMedio,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600), textAlign: TextAlign.center)),
                  Expanded(flex: 1, child: Text(r.chave,
                    style: const TextStyle(fontSize: 12), textAlign: TextAlign.center)),
                ]),
              ),
            ),
          ));
        },
      )),
    ]);
  }

  void _mostrarDetalhes(BuildContext context, _RoscaMetrica r) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Text(r.nome, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: kBlue)),
          const SizedBox(height: 4),
          Text('Rosca Métrica ISO — Passo ${r.passo}mm',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          const SizedBox(height: 20),
          _detalheRow('Passo nominal', '${r.passo} mm'),
          _detalheRow('Furo para macho', '${r.furoBroca} mm', cor: kGreen),
          _detalheRow('Diâmetro médio', '${r.diametroMedio} mm'),
          _detalheRow('Diâmetro externo', '${r.diametroExterno} mm'),
          _detalheRow('Altura do filete', '${r.alturaFilete} mm'),
          _detalheRow('Chave de boca', '${r.chave} mm'),
          if (r.passoFino.isNotEmpty) ...[
            const Divider(height: 20),
            Text('Passo Fino disponível: ${r.passoFino}mm',
              style: const TextStyle(fontSize: 12, color: kBlue)),
          ],
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: 'Rosca ${r.nome}: furo ${r.furoBroca}mm'));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Copiado!'), duration: Duration(seconds: 1)));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(color: kBlue, borderRadius: BorderRadius.circular(10)),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.copy_rounded, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text('Copiar dados', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
              ])),
          ),
        ]),
      ),
    );
  }

  Widget _detalheRow(String label, String valor, {Color? cor}) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(children: [
      Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
      Text(valor, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cor ?? kDark)),
    ]));

  Widget _th(String t, int flex) => Expanded(flex: flex,
    child: Text(t, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
      textAlign: flex == 2 ? TextAlign.left : TextAlign.center));
}

// ─────────────────────────────────────────
// ROSCAS BSP / NPT
// ─────────────────────────────────────────
class _RoscasBSP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _secaoTitulo('BSP — British Standard Pipe (Whitworth)', kBlue),
            const SizedBox(height: 8),
            _info('Rosca de tubulação britânica, cônica (BSPT) e paralela (BSPP). Muito usada no Brasil em sistemas hidráulicos e pneumáticos.'),
            const SizedBox(height: 10),
            _tabelaHeader(['Designação', 'Diâm. Ext.', 'Fios/pol', 'Passo(mm)', 'Chave']),
            ..._dadosBSP.map((r) => _tabelaLinha(r, _dadosBSP.indexOf(r))),
            const SizedBox(height: 20),

            _secaoTitulo('NPT — National Pipe Thread (Americana)', kRed),
            const SizedBox(height: 8),
            _info('Rosca cônica americana. Usada em equipamentos importados e em conexões pneumáticas de origem americana.'),
            const SizedBox(height: 10),
            _tabelaHeader(['Designação', 'Diâm. Ext.', 'Fios/pol', 'Passo(mm)', 'Chave']),
            ..._dadosNPT.map((r) => _tabelaLinha(r, _dadosNPT.indexOf(r))),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFFFF3DC), borderRadius: BorderRadius.circular(10)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [
                  Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFBA7517), size: 16),
                  SizedBox(width: 6),
                  Text('DICA IMPORTANTE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFBA7517))),
                ]),
                const SizedBox(height: 8),
                Text('BSP e NPT NÃO são compatíveis entre si, apesar de serem visualmente similares. BSP usa 55° de ângulo de filete, NPT usa 60°. Misturar pode causar vazamentos e danos!',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.5)),
              ]),
            ),
          ],
        ))),
      ],
    );
  }
}

// ─────────────────────────────────────────
// TOLERÂNCIAS ISO
// ─────────────────────────────────────────
class _ToleranciasISO extends StatefulWidget {
  @override
  State<_ToleranciasISO> createState() => _ToleranciasISOState();
}

class _ToleranciasISOState extends State<_ToleranciasISO> {
  int _faixaIdx = 0;
  final _faixas = ['Ø 1-3mm', 'Ø 3-6mm', 'Ø 6-10mm', 'Ø 10-18mm', 'Ø 18-30mm', 'Ø 30-50mm', 'Ø 50-80mm', 'Ø 80-120mm'];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // INFO
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(10)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [
                  Icon(Icons.info_outline_rounded, color: kBlue, size: 16),
                  SizedBox(width: 6),
                  Text('SISTEMA DE TOLERÂNCIAS ISO 286', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kBlue)),
                ]),
                const SizedBox(height: 8),
                Text('As tolerâncias definem os limites máximo e mínimo de uma dimensão. A letra indica a posição (afastamento) e o número indica a qualidade (IT = grau de tolerância).',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.5)),
              ]),
            ),
            const SizedBox(height: 16),

            // AJUSTES COMUNS
            _secaoTitulo('Ajustes Mais Usados em Usinagem', kBlue),
            const SizedBox(height: 10),
            ..._ajustesComuns.map((a) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade100)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(6)),
                    child: Text(a.codigo, style: const TextStyle(color: kAmber, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'monospace'))),
                  const SizedBox(width: 10),
                  Expanded(child: Text(a.nome, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
                ]),
                const SizedBox(height: 6),
                Text(a.descricao, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
                const SizedBox(height: 6),
                Text('Exemplo de aplicação: ${a.aplicacao}',
                  style: const TextStyle(fontSize: 11, color: kBlue, fontStyle: FontStyle.italic)),
              ]),
            )),
            const SizedBox(height: 16),

            // SELETOR DE FAIXA
            _secaoTitulo('Tolerâncias Fundamentais (IT) por Faixa', kGreen),
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _faixas.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () => setState(() => _faixaIdx = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _faixaIdx == i ? kDark : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _faixaIdx == i ? kAmber : Colors.grey.shade200)),
                    child: Text(_faixas[i], style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w500,
                      color: _faixaIdx == i ? kAmber : Colors.grey.shade600)))),
              ),
            ),
            const SizedBox(height: 10),
            _tabelaIT(_faixaIdx),
            const SizedBox(height: 20),

            // TABELA DE QUALIDADES
            _secaoTitulo('Guia de Qualidades IT por Aplicação', const Color(0xFF993C1D)),
            const SizedBox(height: 10),
            ..._qualidades.map((q) => Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade100)),
              child: Row(children: [
                Container(width: 40, height: 40,
                  decoration: BoxDecoration(color: const Color(0xFFFAECE7), borderRadius: BorderRadius.circular(8)),
                  child: Center(child: Text('IT${q.it}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF993C1D))))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(q.aplicacao, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  Text(q.descricao, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ])),
              ]),
            )),
          ],
        ))),
      ],
    );
  }

  Widget _tabelaIT(int faixaIdx) {
    final dados = _toleranciasIT[faixaIdx];
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: kDark, borderRadius: const BorderRadius.vertical(top: Radius.circular(7))),
          child: Row(children: [
            Expanded(flex: 2, child: Text('Qualidade', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white))),
            Expanded(flex: 3, child: Text(_faixas[faixaIdx], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: kAmber), textAlign: TextAlign.center)),
          ]),
        ),
        ...dados.asMap().entries.map((e) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: e.key.isOdd ? Colors.grey.shade50 : Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5))),
          child: Row(children: [
            Expanded(flex: 2, child: Text(e.value[0],
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kBlue))),
            Expanded(flex: 3, child: Text(e.value[1],
              style: const TextStyle(fontSize: 12), textAlign: TextAlign.center)),
          ]),
        )),
      ]),
    );
  }
}

// ─────────────────────────────────────────
// CONVERSÕES
// ─────────────────────────────────────────
class _Conversoes extends StatefulWidget {
  @override
  State<_Conversoes> createState() => _ConversoesState();
}

class _ConversoesState extends State<_Conversoes> {
  final _ctrl = TextEditingController();
  double _valor = 0;
  int _catIdx = 0;

  final _cats = ['Comprimento', 'Pressão', 'Força', 'Temperatura', 'Velocidade', 'Torque'];

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600), child: Column(
          children: [
            // SELETOR
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _cats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 6),
                itemBuilder: (ctx, i) => GestureDetector(
                  onTap: () => setState(() { _catIdx = i; _ctrl.clear(); _valor = 0; }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _catIdx == i ? kDark : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _catIdx == i ? kAmber : Colors.grey.shade200)),
                    child: Text(_cats[i], style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w500,
                      color: _catIdx == i ? kAmber : Colors.grey.shade600)))),
              ),
            ),
            const SizedBox(height: 14),

            // INPUT
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200)),
              child: Row(children: [
                Expanded(child: TextField(
                  controller: _ctrl,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Digite o valor para converter',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                  onChanged: (v) => setState(() => _valor = double.tryParse(v.replaceAll(',', '.')) ?? 0),
                )),
                Text(_unidadeBase(_catIdx), style: const TextStyle(color: kBlue, fontWeight: FontWeight.w600)),
              ]),
            ),
            const SizedBox(height: 14),

            // RESULTADOS
            if (_valor != 0) ..._getConversoes(_catIdx, _valor).map((c) =>
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: c[1]));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${c[0]}: ${c[1]} copiado!'), duration: const Duration(seconds: 1)));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade100)),
                  child: Row(children: [
                    Expanded(child: Text(c[0], style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
                    Text(c[1], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kDark)),
                    const SizedBox(width: 8),
                    Icon(Icons.copy_rounded, color: Colors.grey.shade300, size: 16),
                  ]),
                ),
              )),

            if (_valor == 0) ...[
              const SizedBox(height: 20),
              // TABELAS FIXAS DE REFERÊNCIA
              ..._tabelasConversao[_catIdx].map((grupo) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _secaoTitulo(grupo[0] as String, kBlue),
                  const SizedBox(height: 8),
                  ...(grupo[1] as List<List<String>>).map((linha) =>
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade100)),
                      child: Row(children: [
                        Expanded(child: Text(linha[0], style: TextStyle(fontSize: 12, color: Colors.grey.shade600))),
                        Text(linha[1], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kDark)),
                      ]),
                    )),
                  const SizedBox(height: 12),
                ],
              )),
            ],
          ],
        ))),
      ],
    );
  }

  String _unidadeBase(int idx) {
    switch (idx) {
      case 0: return 'mm'; case 1: return 'bar'; case 2: return 'N';
      case 3: return '°C'; case 4: return 'm/min'; case 5: return 'N·m';
      default: return '';
    }
  }

  List<List<String>> _getConversoes(int idx, double v) {
    switch (idx) {
      case 0: return [
        ['Polegadas (in)', '${(v / 25.4).toStringAsFixed(4)} in'],
        ['Pés (ft)', '${(v / 304.8).toStringAsFixed(4)} ft'],
        ['Metros (m)', '${(v / 1000).toStringAsFixed(4)} m'],
        ['Centímetros (cm)', '${(v / 10).toStringAsFixed(3)} cm'],
        ['Micrômetros (μm)', '${(v * 1000).toStringAsFixed(0)} μm'],
      ];
      case 1: return [
        ['PSI (lb/pol²)', '${(v * 14.504).toStringAsFixed(2)} PSI'],
        ['kPa (kilopascal)', '${(v * 100).toStringAsFixed(1)} kPa'],
        ['MPa (megapascal)', '${(v / 10).toStringAsFixed(3)} MPa'],
        ['kgf/cm²', '${(v * 1.0197).toStringAsFixed(3)} kgf/cm²'],
        ['atm (atmosfera)', '${(v / 1.01325).toStringAsFixed(3)} atm'],
        ['N/mm²', '${(v / 10).toStringAsFixed(3)} N/mm²'],
      ];
      case 2: return [
        ['kgf (quilograma-força)', '${(v / 9.807).toStringAsFixed(3)} kgf'],
        ['lbf (libra-força)', '${(v * 0.2248).toStringAsFixed(3)} lbf'],
        ['kN (quilonewton)', '${(v / 1000).toStringAsFixed(4)} kN'],
        ['daN (decanewton)', '${(v / 10).toStringAsFixed(3)} daN'],
      ];
      case 3: return [
        ['Fahrenheit (°F)', '${(v * 9 / 5 + 32).toStringAsFixed(1)} °F'],
        ['Kelvin (K)', '${(v + 273.15).toStringAsFixed(2)} K'],
      ];
      case 4: return [
        ['m/s (metros por segundo)', '${(v / 60).toStringAsFixed(3)} m/s'],
        ['ft/min (pés por minuto)', '${(v * 3.281).toStringAsFixed(1)} ft/min'],
        ['km/h', '${(v * 0.06).toStringAsFixed(3)} km/h'],
      ];
      case 5: return [
        ['kgf·m', '${(v / 9.807).toStringAsFixed(3)} kgf·m'],
        ['kgf·cm', '${(v * 10.197).toStringAsFixed(2)} kgf·cm'],
        ['lbf·ft', '${(v * 0.7376).toStringAsFixed(3)} lbf·ft'],
        ['lbf·in', '${(v * 8.851).toStringAsFixed(2)} lbf·in'],
        ['kN·m', '${(v / 1000).toStringAsFixed(4)} kN·m'],
      ];
      default: return [];
    }
  }
}

// ─────────────────────────────────────────
// CHAVES E PARAFUSOS
// ─────────────────────────────────────────
class _ChavesParafusos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 700), child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _secaoTitulo('Chaves para Parafusos Métricos (DIN 933/912)', kBlue),
            const SizedBox(height: 8),
            _tabelaHeader(['Parafuso', 'Chave Fixa', 'Allen (int)', 'Torx', 'Torque Rec.']),
            ..._chavesMetricas.asMap().entries.map((e) => _tabelaLinha(e.value, e.key)),
            const SizedBox(height: 20),

            _secaoTitulo('Chaves para Parafusos em Polegadas (SAE/UNC)', kRed),
            const SizedBox(height: 8),
            _tabelaHeader(['Parafuso', 'Chave (pol)', 'Chave (mm)', 'Allen', 'Torque Rec.']),
            ..._chavesSAE.asMap().entries.map((e) => _tabelaLinha(e.value, e.key)),
            const SizedBox(height: 20),

            _secaoTitulo('Brocas para Furos de Passagem', kGreen),
            const SizedBox(height: 8),
            _info('Diâmetros de furo recomendados para passagem livre de parafusos. Folga normal = diâmetro nominal + 0.5mm.'),
            const SizedBox(height: 8),
            _tabelaHeader(['Parafuso', 'Furo Fino', 'Furo Médio', 'Furo Largo', 'Cabeça Enc.']),
            ..._furosPassagem.asMap().entries.map((e) => _tabelaLinha(e.value, e.key)),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFFE1F5EE), borderRadius: BorderRadius.circular(10)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [
                  Icon(Icons.warning_amber_rounded, color: kGreen, size: 16),
                  SizedBox(width: 6),
                  Text('TORQUES DE APERTO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kGreen)),
                ]),
                const SizedBox(height: 8),
                Text('Os torques recomendados são para parafusos grau 8.8 (classe 8.8) em aço. Reduzir 20% para alumínio e 40% para plástico. Sempre usar torquímetro calibrado em aplicações críticas.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.5)),
              ]),
            ),
          ],
        ))),
      ],
    );
  }
}

// ─────────────────────────────────────────
// HELPERS VISUAIS
// ─────────────────────────────────────────
Widget _secaoTitulo(String t, Color cor) => Row(children: [
  Container(width: 4, height: 16, decoration: BoxDecoration(color: cor, borderRadius: BorderRadius.circular(2))),
  const SizedBox(width: 8),
  Text(t, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: cor)),
]);

Widget _info(String t) => Container(
  padding: const EdgeInsets.all(10),
  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.grey.shade200)),
  child: Text(t, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4)));

Widget _tabelaHeader(List<String> cols) => Container(
  margin: const EdgeInsets.only(bottom: 2),
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(6)),
  child: Row(children: cols.asMap().entries.map((e) =>
    Expanded(child: Text(e.value,
      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
      textAlign: e.key == 0 ? TextAlign.left : TextAlign.center))).toList()));

Widget _tabelaLinha(List<String> cols, int idx) => Container(
  margin: const EdgeInsets.only(bottom: 2),
  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
  decoration: BoxDecoration(
    color: idx.isOdd ? Colors.grey.shade50 : Colors.white,
    borderRadius: BorderRadius.circular(4),
    border: Border.all(color: Colors.grey.shade100, width: 0.5)),
  child: Row(children: cols.asMap().entries.map((e) =>
    Expanded(child: Text(e.value,
      style: TextStyle(fontSize: 11,
        fontWeight: e.key == 0 ? FontWeight.w600 : FontWeight.normal,
        color: e.key == 0 ? kBlue : Colors.grey.shade700),
      textAlign: e.key == 0 ? TextAlign.left : TextAlign.center))).toList()));

// ─────────────────────────────────────────
// DADOS — ROSCAS MÉTRICAS
// ─────────────────────────────────────────
class _RoscaMetrica {
  final String nome, passo, furoBroca, diametroMedio, diametroExterno, alturaFilete, chave, passoFino;
  const _RoscaMetrica(this.nome, this.passo, this.furoBroca, this.diametroMedio,
    this.diametroExterno, this.alturaFilete, this.chave, this.passoFino);
}

const _roscasMetricas = [
  _RoscaMetrica('M2',    '0.40', '1.60', '1.74',  '2.00',  '0.245', '4',  ''),
  _RoscaMetrica('M2.5',  '0.45', '2.05', '2.19',  '2.50',  '0.276', '5',  ''),
  _RoscaMetrica('M3',    '0.50', '2.50', '2.68',  '3.00',  '0.307', '5.5',''),
  _RoscaMetrica('M4',    '0.70', '3.30', '3.55',  '4.00',  '0.429', '7',  ''),
  _RoscaMetrica('M5',    '0.80', '4.20', '4.48',  '5.00',  '0.491', '8',  ''),
  _RoscaMetrica('M6',    '1.00', '5.00', '5.35',  '6.00',  '0.613', '10', '0.75'),
  _RoscaMetrica('M8',    '1.25', '6.75', '7.19',  '8.00',  '0.767', '13', '1.00'),
  _RoscaMetrica('M10',   '1.50', '8.50', '9.03',  '10.00', '0.920', '17', '1.25'),
  _RoscaMetrica('M12',   '1.75', '10.20','10.86', '12.00', '1.074', '19', '1.50'),
  _RoscaMetrica('M14',   '2.00', '12.00','12.70', '14.00', '1.227', '22', '1.50'),
  _RoscaMetrica('M16',   '2.00', '14.00','14.70', '16.00', '1.227', '24', '1.50'),
  _RoscaMetrica('M18',   '2.50', '15.50','16.38', '18.00', '1.534', '27', '2.00'),
  _RoscaMetrica('M20',   '2.50', '17.50','18.38', '20.00', '1.534', '30', '2.00'),
  _RoscaMetrica('M22',   '2.50', '19.50','20.38', '22.00', '1.534', '32', '2.00'),
  _RoscaMetrica('M24',   '3.00', '21.00','22.05', '24.00', '1.840', '36', '2.00'),
  _RoscaMetrica('M27',   '3.00', '24.00','25.05', '27.00', '1.840', '41', '2.00'),
  _RoscaMetrica('M30',   '3.50', '26.50','27.73', '30.00', '2.147', '46', '2.00'),
  _RoscaMetrica('M33',   '3.50', '29.50','30.73', '33.00', '2.147', '50', '2.00'),
  _RoscaMetrica('M36',   '4.00', '32.00','33.40', '36.00', '2.454', '55', '3.00'),
  _RoscaMetrica('M39',   '4.00', '35.00','36.40', '39.00', '2.454', '60', '3.00'),
  _RoscaMetrica('M42',   '4.50', '37.50','39.08', '42.00', '2.760', '65', '3.00'),
  _RoscaMetrica('M48',   '5.00', '43.00','44.75', '48.00', '3.067', '75', '3.00'),
  _RoscaMetrica('M52',   '5.00', '47.00','48.75', '52.00', '3.067', '80', '4.00'),
  _RoscaMetrica('M56',   '5.50', '50.50','52.43', '56.00', '3.374', '85', '4.00'),
  _RoscaMetrica('M60',   '5.50', '54.50','56.43', '60.00', '3.374', '90', '4.00'),
  _RoscaMetrica('M64',   '6.00', '58.00','60.10', '64.00', '3.681', '95', '4.00'),
  _RoscaMetrica('M72',   '6.00', '66.00','68.10', '72.00', '3.681', '105','6.00'),
  _RoscaMetrica('M80',   '6.00', '74.00','76.10', '80.00', '3.681', '115','6.00'),
  _RoscaMetrica('M90',   '6.00', '84.00','86.10', '90.00', '3.681', '130','6.00'),
  _RoscaMetrica('M100',  '6.00', '94.00','96.10', '100.00','3.681', '145','6.00'),
];

// ─────────────────────────────────────────
// DADOS — BSP / NPT
// ─────────────────────────────────────────
const _dadosBSP = [
  ['1/8"',  '9.72',  '28', '0.907', '14'],
  ['1/4"',  '13.16', '19', '1.337', '19'],
  ['3/8"',  '16.66', '19', '1.337', '22'],
  ['1/2"',  '20.96', '14', '1.814', '27'],
  ['3/4"',  '26.44', '14', '1.814', '32'],
  ['1"',    '33.25', '11', '2.309', '41'],
  ['1.1/4"','41.91', '11', '2.309', '50'],
  ['1.1/2"','47.80', '11', '2.309', '55'],
  ['2"',    '59.61', '11', '2.309', '65'],
  ['2.1/2"','75.18', '11', '2.309', '75'],
  ['3"',    '87.88', '11', '2.309', '90'],
];

const _dadosNPT = [
  ['1/8"',  '10.29', '27', '0.941', '14'],
  ['1/4"',  '13.72', '18', '1.411', '19'],
  ['3/8"',  '17.15', '18', '1.411', '22'],
  ['1/2"',  '21.34', '14', '1.814', '27'],
  ['3/4"',  '26.67', '14', '1.814', '32'],
  ['1"',    '33.40', '11.5','2.209','41'],
  ['1.1/4"','42.16', '11.5','2.209','50'],
  ['1.1/2"','48.26', '11.5','2.209','55'],
  ['2"',    '60.33', '11.5','2.209','65'],
];

// ─────────────────────────────────────────
// DADOS — TOLERÂNCIAS ISO
// ─────────────────────────────────────────
class _Ajuste { final String codigo, nome, descricao, aplicacao;
  const _Ajuste(this.codigo, this.nome, this.descricao, this.aplicacao); }

class _Qualidade { final String it, aplicacao, descricao;
  const _Qualidade(this.it, this.aplicacao, this.descricao); }

const _ajustesComuns = [
  _Ajuste('H7/h6', 'Ajuste Deslizante', 'Peças que devem deslizar uma sobre a outra sem folga perceptível. Montagem à mão sem aperto.', 'Eixos em mancais, guias de máquinas, pinos de posicionamento'),
  _Ajuste('H7/p6', 'Ajuste com Interferência Leve', 'Interferência pequena — requer prensa leve ou aquecimento para montagem. Transmite pequenos esforços.', 'Buchas em alojamentos, polias em eixos'),
  _Ajuste('H7/s6', 'Ajuste com Interferência Forte', 'Interferência média — requer prensa hidráulica. Transmite torques e forças axiais consideráveis.', 'Rolamentos em alojamentos, engrenagens em eixos'),
  _Ajuste('H7/u6', 'Ajuste Forçado', 'Grande interferência — aquecimento e prensa. Desmontagem apenas por destruição da peça.', 'Acoplamentos permanentes, eixos com coroa'),
  _Ajuste('H7/f7', 'Ajuste com Folga Larga', 'Folga pequena mas perceptível. Permite rotação e translação fácil. Necessita lubrificação.', 'Eixos em mancais de deslizamento, pistões em cilindros'),
  _Ajuste('H8/f7', 'Ajuste com Folga Normal', 'Folga para rotação livre com lubrificação. Padrão para a maioria dos mancais de deslizamento.', 'Mancais de deslizamento com lubrificação forçada'),
  _Ajuste('H11/c11', 'Ajuste com Folga Grande', 'Folga ampla para montagem fácil. Tolera desalinhamentos e dilatação térmica.', 'Parafusos em furos de passagem, acoplamentos flexíveis'),
  _Ajuste('JS6/h5', 'Ajuste de Transição', 'Pode ter folga ou interferência pequena. Montagem a mão ou com maço leve.', 'Peças que precisam de precisão mas desmontagem frequente'),
];

const _qualidades = [
  _Qualidade('01-1', 'Padrões de calibração', 'Instrumentos de precisão máxima — laboratório metrológico'),
  _Qualidade('2-4',  'Calibradores e medidores', 'Instrumentos de medição de alta precisão'),
  _Qualidade('5-6',  'Ajustes precisos', 'Rolamentos, eixos de precisão, calibradores de trabalho'),
  _Qualidade('7-8',  'Ajustes normais', 'Eixos e furos em máquinas normais — mais usados'),
  _Qualidade('9-10', 'Tolerâncias médias', 'Peças com requisitos menores de precisão'),
  _Qualidade('11-12','Trabalho grosseiro', 'Peças fundidas, forjadas — antes de usinagem de precisão'),
  _Qualidade('13-16','Tolerâncias largas', 'Materiais brutos, tolerâncias de entregas de matéria-prima'),
];

// Tolerâncias IT em μm por faixa dimensional
const _toleranciasIT = [
  // Ø 1-3mm
  [['IT5','4 μm'], ['IT6','6 μm'], ['IT7','10 μm'], ['IT8','14 μm'], ['IT9','25 μm'], ['IT10','40 μm'], ['IT11','60 μm']],
  // Ø 3-6mm
  [['IT5','5 μm'], ['IT6','8 μm'], ['IT7','12 μm'], ['IT8','18 μm'], ['IT9','30 μm'], ['IT10','48 μm'], ['IT11','75 μm']],
  // Ø 6-10mm
  [['IT5','6 μm'], ['IT6','9 μm'], ['IT7','15 μm'], ['IT8','22 μm'], ['IT9','36 μm'], ['IT10','58 μm'], ['IT11','90 μm']],
  // Ø 10-18mm
  [['IT5','8 μm'], ['IT6','11 μm'], ['IT7','18 μm'], ['IT8','27 μm'], ['IT9','43 μm'], ['IT10','70 μm'], ['IT11','110 μm']],
  // Ø 18-30mm
  [['IT5','9 μm'], ['IT6','13 μm'], ['IT7','21 μm'], ['IT8','33 μm'], ['IT9','52 μm'], ['IT10','84 μm'], ['IT11','130 μm']],
  // Ø 30-50mm
  [['IT5','11 μm'],['IT6','16 μm'], ['IT7','25 μm'], ['IT8','39 μm'], ['IT9','62 μm'], ['IT10','100 μm'],['IT11','160 μm']],
  // Ø 50-80mm
  [['IT5','13 μm'],['IT6','19 μm'], ['IT7','30 μm'], ['IT8','46 μm'], ['IT9','74 μm'], ['IT10','120 μm'],['IT11','190 μm']],
  // Ø 80-120mm
  [['IT5','15 μm'],['IT6','22 μm'], ['IT7','35 μm'], ['IT8','54 μm'], ['IT9','87 μm'], ['IT10','140 μm'],['IT11','220 μm']],
];

// ─────────────────────────────────────────
// DADOS — CONVERSÕES (tabelas de referência)
// ─────────────────────────────────────────
const _tabelasConversao = [
  // Comprimento
  [[
    'Referências rápidas',
    [['1 polegada (1")', '25.4 mm'], ['1/2"', '12.7 mm'], ['1/4"', '6.35 mm'], ['1/8"', '3.175 mm'],
     ['1 pé (12")', '304.8 mm'], ['1 jarda (36")', '914.4 mm'], ['1 milha', '1609.34 m'],
     ['1 μm (mícron)', '0.001 mm'], ['1 mil (thou)', '0.0254 mm']]
  ]],
  // Pressão
  [[
    'Referências rápidas',
    [['1 bar', '14.504 PSI'], ['1 bar', '100 kPa'], ['1 MPa', '145.04 PSI'],
     ['1 kgf/cm²', '98.07 kPa'], ['1 atm', '101.325 kPa'], ['1 atm', '1.01325 bar'],
     ['6 bar', '87 PSI (pneumática)'], ['200 bar', '2900 PSI (hidráulica)'],
     ['1 N/mm²', '10 bar'], ['1 MPa', '1 N/mm²']]
  ]],
  // Força
  [[
    'Referências rápidas',
    [['1 kgf', '9.807 N'], ['1 tonelada-força', '9806.65 N'],
     ['1 kN', '101.97 kgf'], ['1 lbf', '4.448 N'],
     ['100 N', '10.197 kgf'], ['1000 N', '1 kN']]
  ]],
  // Temperatura
  [[
    'Referências rápidas de temperatura',
    [['0°C (água gela)', '32°F'], ['100°C (água ferve)', '212°F'],
     ['20°C (ambiente)', '68°F'], ['37°C (corpo)', '98.6°F'],
     ['300°C (têmpera)', '572°F'], ['800°C (austenitização)', '1472°F'],
     ['-196°C (N2 líquido)', '-320.8°F'], ['150°C (expansão rolamento)', '302°F']]
  ]],
  // Velocidade
  [[
    'Referências rápidas',
    [['1 m/min', '0.0167 m/s'], ['60 m/min', '1 m/s'],
     ['100 m/min', '1.667 m/s'], ['200 m/min', '3.333 m/s'],
     ['1 ft/min', '0.3048 m/min'], ['1 m/s', '196.85 ft/min']]
  ]],
  // Torque
  [[
    'Referências rápidas',
    [['1 N·m', '0.102 kgf·m'], ['1 N·m', '8.851 lbf·in'],
     ['1 kgf·m', '9.807 N·m'], ['1 lbf·ft', '1.356 N·m'],
     ['1 kgf·cm', '0.0981 N·m'], ['100 N·m', '10.2 kgf·m']]
  ]],
];

// ─────────────────────────────────────────
// DADOS — CHAVES E PARAFUSOS
// ─────────────────────────────────────────
const _chavesMetricas = [
  ['M3',  '5.5',  '2.5', 'T10', '1.3 N·m'],
  ['M4',  '7',    '3',   'T20', '3.0 N·m'],
  ['M5',  '8',    '4',   'T25', '6.0 N·m'],
  ['M6',  '10',   '5',   'T30', '10 N·m'],
  ['M8',  '13',   '6',   'T40', '25 N·m'],
  ['M10', '17',   '8',   'T50', '49 N·m'],
  ['M12', '19',   '10',  'T55', '86 N·m'],
  ['M14', '22',   '12',  'T60', '137 N·m'],
  ['M16', '24',   '14',  'T70', '210 N·m'],
  ['M18', '27',   '14',  '—',   '290 N·m'],
  ['M20', '30',   '17',  '—',   '400 N·m'],
  ['M24', '36',   '19',  '—',   '690 N·m'],
  ['M27', '41',   '19',  '—',   '1000 N·m'],
  ['M30', '46',   '22',  '—',   '1350 N·m'],
];

const _chavesSAE = [
  ['#10 (3/16")', '3/8"',   '9.5mm',  '5/32"', '7 N·m'],
  ['1/4"',        '7/16"',  '11.1mm', '3/16"', '12 N·m'],
  ['5/16"',       '1/2"',   '12.7mm', '1/4"',  '24 N·m'],
  ['3/8"',        '9/16"',  '14.3mm', '5/16"', '41 N·m'],
  ['7/16"',       '5/8"',   '15.9mm', '3/8"',  '65 N·m'],
  ['1/2"',        '3/4"',   '19.1mm', '3/8"',  '102 N·m'],
  ['9/16"',       '7/8"',   '22.2mm', '1/2"',  '149 N·m'],
  ['5/8"',        '15/16"', '23.8mm', '1/2"',  '203 N·m'],
  ['3/4"',        '1-1/8"', '28.6mm', '5/8"',  '339 N·m'],
];

const _furosPassagem = [
  ['M3',  '3.2mm',  '3.4mm',  '3.6mm',  '6mm'],
  ['M4',  '4.3mm',  '4.5mm',  '4.8mm',  '8mm'],
  ['M5',  '5.3mm',  '5.5mm',  '5.8mm',  '10mm'],
  ['M6',  '6.4mm',  '6.6mm',  '7.0mm',  '11mm'],
  ['M8',  '8.4mm',  '9.0mm',  '10.0mm', '14mm'],
  ['M10', '10.5mm', '11.0mm', '12.0mm', '18mm'],
  ['M12', '13.0mm', '13.5mm', '14.5mm', '20mm'],
  ['M14', '15.0mm', '15.5mm', '16.5mm', '24mm'],
  ['M16', '17.0mm', '17.5mm', '18.5mm', '26mm'],
  ['M20', '21.0mm', '22.0mm', '24.0mm', '33mm'],
  ['M24', '25.0mm', '26.0mm', '28.0mm', '39mm'],
];
// ─────────────────────────────────────────
// PARÂMETROS DE CORTE POR MATERIAL
// ─────────────────────────────────────────

class _ParametroMaterial {
  final String material;
  final String emoji;
  final Color cor;
  final String dureza;
  final String descricao;
  final List<_LinhaParam> fresamento;
  final List<_LinhaParam> torneamento;
  final List<_LinhaParam> furacao;
  final String dica;
  const _ParametroMaterial({
    required this.material, required this.emoji, required this.cor,
    required this.dureza, required this.descricao,
    required this.fresamento, required this.torneamento, required this.furacao,
    required this.dica,
  });
}

class _LinhaParam {
  final String ferramenta;
  final String vc;      // m/min
  final String fz;      // mm/dente ou mm/rot
  final String ap;      // profundidade axial
  final String ae;      // profundidade radial / largura
  final String obs;
  const _LinhaParam(this.ferramenta, this.vc, this.fz, this.ap, this.ae, this.obs);
}

const _materiaisCorte = [
  _ParametroMaterial(
    material: 'Aço Baixo Carbono', emoji: '🔩', cor: Color(0xFF1565C0),
    dureza: '120-180 HB', descricao: 'SAE 1020, 1045, A36 — usinabilidade boa',
    fresamento: [
      _LinhaParam('Fresa AÇO HSS-Co', '25-35', '0.03-0.05', '2-4mm', '5-8mm', 'Refrigeração obrigatória'),
      _LinhaParam('Fresa Metal Duro P20', '80-120', '0.06-0.12', '3-6mm', '6-12mm', 'Sem revestimento ou TiAlN'),
      _LinhaParam('Fresa Metal Duro P30', '100-150', '0.08-0.15', '4-8mm', '8-15mm', 'TiAlN — desbaste pesado'),
      _LinhaParam('Fresa MD com TiSiN', '120-180', '0.10-0.18', '4-8mm', '8-16mm', 'Alta produtividade'),
    ],
    torneamento: [
      _LinhaParam('Pastilha P10/P20 CVD', '200-280', '0.15-0.30', '1-3mm', '—', 'Acabamento/semi-acabamento'),
      _LinhaParam('Pastilha P30 CVD', '150-220', '0.25-0.45', '2-5mm', '—', 'Desbaste geral'),
      _LinhaParam('Pastilha cerâmica', '350-500', '0.10-0.20', '0.5-2mm', '—', 'Somente acabamento seco'),
    ],
    furacao: [
      _LinhaParam('Broca HSS-Co', '20-28', '0.10-0.20', '—', '—', 'Refrigeração abundante'),
      _LinhaParam('Broca metal duro', '60-90', '0.15-0.25', '—', '—', 'Refrigeração interna'),
      _LinhaParam('Broca inserto', '90-130', '0.20-0.35', '—', '—', 'Alta produção'),
    ],
    dica: 'Para aço 1045 trefilado: use Vc 20% menor por ser mais duro. Em fresamento: rampa de entrada (ramp-in) a 3° evita carga axial excessiva.',
  ),

  _ParametroMaterial(
    material: 'Aço Inoxidável', emoji: '⚡', cor: Color(0xFF558B2F),
    dureza: '170-220 HB', descricao: 'AISI 304, 316, 430 — tendência ao encruamento',
    fresamento: [
      _LinhaParam('Fresa AÇO HSS-Co 8%', '15-25', '0.02-0.04', '1-3mm', '3-6mm', 'Refrigeração copiosa'),
      _LinhaParam('Fresa MD M20/M30', '50-80', '0.04-0.08', '2-4mm', '4-8mm', 'AlTiN ou AlCrN'),
      _LinhaParam('Fresa MD AlTiN 5x', '60-100', '0.06-0.10', '2-5mm', '5-10mm', 'Menor ap evita encruamento'),
    ],
    torneamento: [
      _LinhaParam('Pastilha M15 PVD TiAlN', '120-180', '0.10-0.25', '0.5-2mm', '—', 'Acabamento — manter corte contínuo'),
      _LinhaParam('Pastilha M25 TiAlN', '100-150', '0.20-0.40', '1.5-4mm', '—', 'Desbaste — fluido abundante'),
    ],
    furacao: [
      _LinhaParam('Broca HSS-Co ponta 135°', '12-18', '0.06-0.12', '—', '—', 'Ângulo 135° evita escorregamento'),
      _LinhaParam('Broca MD Inox', '40-60', '0.10-0.18', '—', '—', 'Refrigeração interna obrigatória'),
    ],
    dica: 'INOX encruamento é real: nunca parar a ferramenta no corte. Manter Vc baixa (reduz calor). Usar pastilha nova — pastilha desgastada causa encruamento imediato. Fluido de corte: óleo integral melhor que emulsão para inox.',
  ),

  _ParametroMaterial(
    material: 'Alumínio', emoji: '✈️', cor: Color(0xFF9E9E9E),
    dureza: '60-120 HB', descricao: 'AA 6061, 7075, 2024 — usinabilidade excelente',
    fresamento: [
      _LinhaParam('Fresa HSS 3 cortes', '60-100', '0.05-0.10', '5-15mm', '10-20mm', 'Boa opção — custo baixo'),
      _LinhaParam('Fresa MD 2-3 cortes N', '200-400', '0.08-0.20', '10-25mm', '15-30mm', 'Hélice 45°+ limpeza cavaco'),
      _LinhaParam('Fresa MD polida N', '300-600', '0.10-0.25', '15-30mm', '20-40mm', 'Para acabamento espelhado'),
    ],
    torneamento: [
      _LinhaParam('Pastilha K10 PCD', '500-1000', '0.10-0.30', '0.5-3mm', '—', 'PCD = acabamento espelho'),
      _LinhaParam('Pastilha K20 não revestida', '300-600', '0.15-0.40', '1-5mm', '—', 'Ângulo de saída positivo'),
    ],
    furacao: [
      _LinhaParam('Broca HSS ponta 118°', '40-60', '0.15-0.30', '—', '—', 'Lubrificante leve'),
      _LinhaParam('Broca MD polida N', '100-200', '0.20-0.40', '—', '—', 'Hélice alta — evacua cavaco'),
    ],
    dica: 'Alumínio puro (1000-series) é pegajoso — use pastilha PCD ou MD não revestida com ângulo de saída alto (+15° a +20°). Para ligas 7075: pode-se usinar a seco. Fresa de 2 cortes evapora cavaco melhor que 4 cortes.',
  ),

  _ParametroMaterial(
    material: 'Ferro Fundido', emoji: '🏭', cor: Color(0xFF4E342E),
    dureza: '180-250 HB', descricao: 'Cinzento (GG), Nodular (GGG) — frágil, cavaco curto',
    fresamento: [
      _LinhaParam('Fresa MD K10/K20', '80-120', '0.08-0.15', '3-6mm', '6-12mm', 'Usinar a seco — sem fluido'),
      _LinhaParam('Fresa MD K30 CBN', '120-200', '0.10-0.20', '2-5mm', '5-10mm', 'Alta Vc a seco — CBN ideal'),
      _LinhaParam('Fresa cerâmica', '300-500', '0.08-0.15', '1-3mm', '3-6mm', 'Somente desbaste sem fluido'),
    ],
    torneamento: [
      _LinhaParam('Pastilha K10 CVD', '150-250', '0.15-0.35', '1-4mm', '—', 'A seco — fluido causa trinca'),
      _LinhaParam('Pastilha cerâmica', '400-700', '0.10-0.25', '0.5-2mm', '—', 'Acabamento de alta velocidade'),
      _LinhaParam('Pastilha CBN', '600-900', '0.10-0.20', '0.5-1.5mm', '—', 'Ferro endurecido ou têmpera'),
    ],
    furacao: [
      _LinhaParam('Broca MD K20 ponta 90°', '40-70', '0.15-0.30', '—', '—', 'A seco ou ar comprimido'),
      _LinhaParam('Broca inserto K', '60-100', '0.20-0.40', '—', '—', 'Produção alta'),
    ],
    dica: 'NUNCA use fluido de corte em ferro fundido cinzento — choque térmico causa trinca nas pastilhas cerâmicas. Ar comprimido para evacuar pó. Cavaco em pó: use óculos de proteção e evite inalar.',
  ),

  _ParametroMaterial(
    material: 'Titânio', emoji: '🚀', cor: Color(0xFF6A1B9A),
    dureza: '300-380 HB', descricao: 'Ti-6Al-4V (grau 5) — difícil usinagem, alta resistência',
    fresamento: [
      _LinhaParam('Fresa MD TiAlN 4 cortes', '30-50', '0.03-0.06', '1-3mm', '2-5mm', 'Refrigeração interna obrigatória'),
      _LinhaParam('Fresa MD AlCrN 5x', '40-60', '0.04-0.08', '1.5-4mm', '3-6mm', 'ap pequeno — af grande'),
      _LinhaParam('Fresa especial Titânio', '50-80', '0.05-0.10', '2-5mm', '4-8mm', 'Hélice alta + nr. arestas par'),
    ],
    torneamento: [
      _LinhaParam('Pastilha K10/M10 PVD', '60-100', '0.10-0.20', '1-3mm', '—', 'Fluido copiosa pressão alta'),
      _LinhaParam('Pastilha K20 não revestida', '40-70', '0.12-0.25', '1-4mm', '—', 'Ângulo de saída alto +10°'),
    ],
    furacao: [
      _LinhaParam('Broca MD TiAlN refrigeração', '20-35', '0.05-0.10', '—', '—', 'Refrigeração interna 70bar'),
      _LinhaParam('Broca MD AlTiN ponta 135°', '25-40', '0.08-0.12', '—', '—', 'Peck drilling: Q=1.5x D'),
    ],
    dica: 'Titânio é DIFÍCIL: baixa condutividade = calor fica na ferramenta. Usar Vc BAIXA com avanço adequado. Nunca fazer micro-pausas — titânio encruado é muito mais duro. Fluido de corte em alta pressão (70+ bar) é diferencial para ferramentas.',
  ),

  _ParametroMaterial(
    material: 'Aço Inox Duplex', emoji: '🔬', cor: Color(0xFF00695C),
    dureza: '250-310 HB', descricao: 'SAF 2205, 2507 — alta resistência ao encruamento',
    fresamento: [
      _LinhaParam('Fresa MD M20 AlCrN', '40-60', '0.03-0.06', '1-2mm', '2-4mm', 'Fluido copiosa — menor ap'),
      _LinhaParam('Fresa MD 5 cortes M30', '50-70', '0.04-0.08', '1.5-3mm', '3-5mm', 'Alta rigidez fixação'),
    ],
    torneamento: [
      _LinhaParam('Pastilha M10 PVD TiAlN', '80-120', '0.08-0.18', '0.5-2mm', '—', 'Não interromper corte'),
      _LinhaParam('Pastilha M25 TiAlN', '60-100', '0.15-0.30', '1-3.5mm', '—', 'Desbaste com fluido'),
    ],
    furacao: [
      _LinhaParam('Broca MD Inox/Duplex', '25-40', '0.06-0.12', '—', '—', 'Ângulo 135° — peck drilling'),
    ],
    dica: 'Duplex é mais difícil que 316L: encruamento acontece mais rápido. Ferramentas com ângulo de saída positivo alto. Troca de inserto mais frequente. Considerar trocador de fluido refrigerado de alta pressão.',
  ),

  _ParametroMaterial(
    material: 'Bronze / Latão', emoji: '🥉', cor: Color(0xFFE65100),
    dureza: '80-160 HB', descricao: 'CuZn37, CuSn8 — excelente usinabilidade',
    fresamento: [
      _LinhaParam('Fresa HSS 4 cortes', '50-80', '0.06-0.12', '4-8mm', '8-15mm', 'Fluido leve ou a seco'),
      _LinhaParam('Fresa MD K20 não revestida', '150-250', '0.10-0.20', '5-12mm', '10-20mm', 'Alta velocidade — ótimo acabamento'),
    ],
    torneamento: [
      _LinhaParam('Pastilha K10 sem revestimento', '200-400', '0.15-0.35', '1-4mm', '—', 'A seco — acabamento espelho'),
      _LinhaParam('Pastilha PCD', '400-600', '0.10-0.25', '0.5-2mm', '—', 'Acabamento premium'),
    ],
    furacao: [
      _LinhaParam('Broca HSS ponta 118°', '40-60', '0.15-0.30', '—', '—', 'Boa evacuação de cavaco'),
      _LinhaParam('Broca MD não revestida', '80-120', '0.20-0.35', '—', '—', 'Lubricante leve ou a seco'),
    ],
    dica: 'Bronze é material "fácil" — cuide da qualidade superficial. Pastilha desgastada causa acabamento ruim. Para latão livre (CuZn35Pb2): Vc pode ser 2x maior que bronze. Evitar revestimento TiN no latão — causa adesão.',
  ),

  _ParametroMaterial(
    material: 'Plástico / Nylon', emoji: '🧪', cor: Color(0xFF0288D1),
    dureza: '— Shore D', descricao: 'POM, PA6, PEEK, ABS — baixa condutividade térmica',
    fresamento: [
      _LinhaParam('Fresa HSS 2 cortes geom. O', '80-150', '0.05-0.12', '3-10mm', '5-15mm', 'Hélice alta — sem fluido'),
      _LinhaParam('Fresa MD polida 1-2 cortes', '100-250', '0.08-0.15', '5-15mm', '10-25mm', 'Ângulo saída alto +20°'),
    ],
    torneamento: [
      _LinhaParam('Pastilha K10 sem revestimento', '150-350', '0.10-0.30', '0.5-3mm', '—', 'Ângulo de saída positivo alto'),
      _LinhaParam('Pastilha PCD', '300-600', '0.08-0.20', '0.2-1.5mm', '—', 'Acabamento perfeito'),
    ],
    furacao: [
      _LinhaParam('Broca HSS ponta 90-118°', '30-60', '0.10-0.25', '—', '—', 'Controlar calor — sem fluido'),
      _LinhaParam('Broca especial plástico', '50-100', '0.15-0.30', '—', '—', 'Sem retornos no furo'),
    ],
    dica: 'Plástico conduz mal o calor — evitar Vc alta. PEEK e reforçados com fibra de vidro: desgastam ferramentas rápido (usar MD). POM "slippery": fixação boa é fundamental. Fluido: ar comprimido ou a seco (água deforma POM).',
  ),

  _ParametroMaterial(
    material: 'Superliga (Inconel)', emoji: '🛸', cor: Color(0xFF37474F),
    dureza: '300-450 HB', descricao: 'Inconel 718, 625, Hastelloy — difícil usinagem, alta temperatura',
    fresamento: [
      _LinhaParam('Fresa MD AlTiN 4 cortes', '20-35', '0.02-0.04', '0.5-1.5mm', '1-3mm', 'Fluido alta pressão obrigatório'),
      _LinhaParam('Fresa MD AlCrN 5 cortes', '25-45', '0.03-0.05', '0.8-2mm', '1.5-4mm', 'HSM com ae=5-10% de D'),
      _LinhaParam('Fresa cerâmica (SIALON)', '200-400', '0.05-0.10', '0.3-0.8mm', '0.5-1.5mm', 'Seco — sem fluido com cerâmica'),
    ],
    torneamento: [
      _LinhaParam('Pastilha cerâmica SiAlON', '150-300', '0.08-0.15', '0.3-1mm', '—', 'Alta Vc com pastilha cerâmica seca'),
      _LinhaParam('Pastilha CBN alto cBN', '80-150', '0.05-0.12', '0.2-0.8mm', '—', 'Acabamento fino — refrigeração'),
      _LinhaParam('Pastilha K10 PVD sem revestimento', '20-40', '0.10-0.20', '0.5-2mm', '—', 'Opção econômica — Vc baixa'),
    ],
    furacao: [
      _LinhaParam('Broca MD AlTiN refrigeração int.', '15-25', '0.04-0.08', '—', '—', 'Pressão mínima 70 bar'),
      _LinhaParam('Broca cerâmica (furos curtos)', '50-80', '0.03-0.06', '—', '—', 'Somente furos < 3×D'),
    ],
    dica: 'Superligas são o maior desafio da usinagem: condutividade térmica 10× menor que aço. TODO o calor vai para a ferramenta. Regra: Vc MUITO baixa + avanço adequado + refrigeração máxima. Cerâmica pode ir em Vc alta MAS somente a seco e em corte interrompido curto.',
  ),

  _ParametroMaterial(
    material: 'Aço Temperado', emoji: '🔥', cor: Color(0xFF880E4F),
    dureza: '45-65 HRC', descricao: 'Aço D2, H13, M2 temperado — usinagem de acabamento duro',
    fresamento: [
      _LinhaParam('Fresa MD CBN 4-6 cortes', '80-120', '0.02-0.04', '0.1-0.3mm', '0.3-0.8mm', 'Hard milling — ap e ae muito pequenos'),
      _LinhaParam('Fresa MD AlTiN 4 cortes', '30-60', '0.01-0.03', '0.1-0.2mm', '0.2-0.5mm', 'Revestimento AlTiN resiste calor'),
      _LinhaParam('Fresa esférica MD CBN', '60-100', '0.01-0.03', '0.05-0.15mm', '—', 'Acabamento de moldes 60+HRC'),
    ],
    torneamento: [
      _LinhaParam('Pastilha CBN (PCBN) grão fino', '80-200', '0.05-0.15', '0.1-0.5mm', '—', 'Hard turning — substitui retífica'),
      _LinhaParam('Pastilha CBN alto cBN', '120-250', '0.08-0.20', '0.2-0.8mm', '—', 'Desbaste em aço > 55HRC'),
      _LinhaParam('Pastilha cerâmica whisker', '100-200', '0.05-0.12', '0.1-0.4mm', '—', 'Acabamento fino — estável'),
    ],
    furacao: [
      _LinhaParam('Broca MD microgrão (< 45 HRC)', '10-20', '0.03-0.07', '—', '—', 'Acima de 45HRC: EDM recomendado'),
      _LinhaParam('Fresa de topo como broca (helical)', '30-50', '0.02-0.04', '—', '—', 'Entrada helicoidal para furos duros'),
    ],
    dica: 'Hard turning (CBN) substitui retífica em aços > 55 HRC: Ra 0.4-0.8µm possível. Vantagem: 1 setup no torno vs. 2 ops (tornear + retificar). Requisito: rigidez MÁXIMA da máquina (defl. < 0.005mm). Qualquer vibração = superfície estriada.',
  ),

  _ParametroMaterial(
    material: 'CFRP / Compósito', emoji: '✈', cor: Color(0xFF1A237E),
    dureza: '— (abrasivo)', descricao: 'Fibra de carbono, GFRP, laminados — altamente abrasivo',
    fresamento: [
      _LinhaParam('Fresa MD diamante CVD', '100-300', '0.05-0.12', '1-5mm', '2-8mm', 'CFRP seco — NO fluido de corte'),
      _LinhaParam('Fresa MD ZrN/DLC polida', '80-200', '0.06-0.15', '1-4mm', '2-6mm', 'Ângulo helicoidal 0° evita delam.'),
      _LinhaParam('Router diamante 2 cortes', '150-400', '0.08-0.20', '2-8mm', '3-10mm', 'Router bits — ideal para CFRP'),
    ],
    torneamento: [
      _LinhaParam('Pastilha PCD microgrão', '100-300', '0.05-0.15', '0.5-3mm', '—', 'Somente PCD — MD desgasta rápido'),
      _LinhaParam('Pastilha diamante CVD', '150-400', '0.04-0.10', '0.3-1.5mm', '—', 'Acabamento espelho em CFRP'),
    ],
    furacao: [
      _LinhaParam('Broca diamante CVD ponta 135°', '50-120', '0.03-0.08', '—', '—', 'Peck mínimo — delaminação risco'),
      _LinhaParam('Broca escalonada PCD', '80-150', '0.05-0.10', '—', '—', 'Furos de qualidade aeronáutica'),
    ],
    dica: 'CFRP é ABRASIVO extremo — desgasta ferramentas HSS em segundos. Usar SOMENTE PCD ou diamante CVD. NUNCA usar fluido de corte aquoso (delamina a fibra e corrói epóxi). Aspiração de pó: fibras de carbono são condutoras — risco curto-circuito e cancerígenas. EPI obrigatório.',
  ),

  _ParametroMaterial(
    material: 'Cobre / Cu-ETP', emoji: '🔶', cor: Color(0xFFBF360C),
    dureza: '40-80 HB', descricao: 'Cobre eletrolítico, Cu-OF, CuBe — muito macio e pegajoso',
    fresamento: [
      _LinhaParam('Fresa MD K10 polida 2 cortes', '150-300', '0.08-0.18', '5-15mm', '10-25mm', 'Polida — evita adesão de Cu'),
      _LinhaParam('Fresa HSS polida 2 cortes', '50-80', '0.06-0.12', '3-8mm', '5-12mm', 'Ângulo saída +20° obrigatório'),
      _LinhaParam('Fresa PCD polida', '300-600', '0.10-0.25', '8-20mm', '15-30mm', 'Máxima qualidade — eletrodos EDM'),
    ],
    torneamento: [
      _LinhaParam('Pastilha PCD', '400-700', '0.10-0.30', '0.5-3mm', '—', 'Acabamento espelho em cobre'),
      _LinhaParam('Pastilha K10 sem revestimento', '200-400', '0.12-0.35', '1-4mm', '—', 'Ângulo de saída alto +15°'),
    ],
    furacao: [
      _LinhaParam('Broca MD polida ponta 118°', '80-150', '0.12-0.25', '—', '—', 'Polida — Cu adere em brocas normais'),
      _LinhaParam('Broca HSS-Co polida', '30-50', '0.08-0.18', '—', '—', 'Lubrificante leve — óleo graxo'),
    ],
    dica: 'Cobre é o pior para usinagem entre os materiais macios: MUITO pegajoso (BUE — Built-Up Edge instantâneo). Usar SEMPRE pastilha/fresa polida e afiada. Nunca parar a ferramenta no material. Fluido: óleo integral graxo melhor que emulsão. Cobre eletrolítico puro é ainda mais pegajoso que ligas.',
  ),
];

// ─────────────────────────────────────────
// WIDGET DA ABA PARÂMETROS DE CORTE
// ─────────────────────────────────────────
class _ParametrosCorte extends StatefulWidget {
  const _ParametrosCorte();
  @override
  State<_ParametrosCorte> createState() => _ParametrosCorteState();
}

class _ParametrosCorteState extends State<_ParametrosCorte> {
  int _materialIdx = 0;
  int _operacaoIdx = 0;

  static const _operacoes = ['Fresamento', 'Torneamento', 'Furação'];

  @override
  Widget build(BuildContext context) {
    final mat = _materiaisCorte[_materialIdx];
    final linhas = _operacaoIdx == 0 ? mat.fresamento
        : _operacaoIdx == 1 ? mat.torneamento
        : mat.furacao;

    return Column(children: [
      // SELETOR DE MATERIAL
      Container(
        height: 44,
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _materiaisCorte.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (ctx, i) {
            final m = _materiaisCorte[i];
            final ativo = _materialIdx == i;
            return GestureDetector(
              onTap: () => setState(() => _materialIdx = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: ativo ? m.cor : m.cor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ativo ? m.cor : m.cor.withValues(alpha: 0.25))),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(m.emoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 5),
                  Text(m.material.split(' ').first,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: ativo ? Colors.white : m.cor)),
                ])));
          },
        ),
      ),

      // INFO DO MATERIAL
      Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: mat.cor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: mat.cor.withValues(alpha: 0.2))),
        child: Row(children: [
          Text(mat.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(mat.material, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: mat.cor)),
            Text('${mat.descricao} · ${mat.dureza}',
              style: TextStyle(fontSize: 11, color: mat.cor.withValues(alpha: 0.7))),
          ])),
        ]),
      ),

      // SELETOR DE OPERAÇÃO
      Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Row(children: List.generate(_operacoes.length, (i) {
          final ativo = _operacaoIdx == i;
          return Expanded(child: GestureDetector(
            onTap: () => setState(() => _operacaoIdx = i),
            child: Container(
              margin: EdgeInsets.only(left: i > 0 ? 6 : 0),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: ativo ? kDark : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: ativo ? kDark : Colors.grey.shade200)),
              child: Text(_operacoes[i],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: ativo ? Colors.white : Colors.grey.shade600)))));
        })),
      ),

      // CABEÇALHO DA TABELA
      Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(8)),
        child: Row(children: [
          Expanded(flex: 3, child: Text('Ferramenta', style: _thStyle)),
          Expanded(flex: 1, child: Text('Vc\nm/min', style: _thStyle, textAlign: TextAlign.center)),
          if (_operacaoIdx != 2)
            Expanded(flex: 1, child: Text('fz\nmm/d', style: _thStyle, textAlign: TextAlign.center))
          else
            Expanded(flex: 1, child: Text('fn\nmm/r', style: _thStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('ap\nmm', style: _thStyle, textAlign: TextAlign.center)),
        ]),
      ),

      // LINHAS DA TABELA
      Expanded(child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        itemCount: linhas.length + 1,
        itemBuilder: (ctx, i) {
          if (i == linhas.length) {
            // DICA PROFISSIONAL
            return Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFCC02).withValues(alpha: 0.5))),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('💡', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Dica do especialista',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF795548))),
                  const SizedBox(height: 4),
                  Text(mat.dica,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF4E342E), height: 1.5)),
                ])),
              ]),
            );
          }
          final l = linhas[i];
          return GestureDetector(
            onTap: () => _mostrarDetalhesParam(context, l, mat),
            child: Container(
              margin: const EdgeInsets.only(bottom: 3),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: i.isOdd ? Colors.grey.shade50 : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade100, width: 0.5)),
              child: Row(children: [
                Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(l.ferramenta, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  if (l.obs.isNotEmpty)
                    Text(l.obs, style: TextStyle(fontSize: 9, color: Colors.grey.shade500)),
                ])),
                Expanded(flex: 1, child: Text(l.vc,
                  style: TextStyle(fontSize: 11, color: mat.cor, fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center)),
                Expanded(flex: 1, child: Text(l.fz,
                  style: const TextStyle(fontSize: 11), textAlign: TextAlign.center)),
                Expanded(flex: 1, child: Text(l.ap,
                  style: const TextStyle(fontSize: 11), textAlign: TextAlign.center)),
              ]),
            ));
        },
      )),
    ]);
  }

  static const _thStyle = TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600);

  void _mostrarDetalhesParam(BuildContext context, _LinhaParam l, _ParametroMaterial mat) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(mat.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 10),
            Expanded(child: Text(l.ferramenta,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
          ]),
          const Divider(height: 20),
          _detalheRow('Velocidade de Corte (Vc)', '${l.vc} m/min', mat.cor),
          _detalheRow('Avanço por dente (fz)', '${l.fz} mm/dente', mat.cor),
          _detalheRow('Profundidade axial (ap)', '${l.ap} mm', mat.cor),
          if (l.ae.isNotEmpty && l.ae != '—')
            _detalheRow('Prof. radial / largura (ae)', '${l.ae} mm', mat.cor),
          _detalheRow('Material', '${mat.material} (${mat.dureza})', Colors.grey.shade600),
          const SizedBox(height: 8),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
            child: Text('ℹ️ ${l.obs.isEmpty ? "Sem observações adicionais." : l.obs}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF444444)))),
          const SizedBox(height: 4),
          Text('Toque para copiar — esses valores são pontos de partida. Ajuste ±20% conforme condição real.',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
        ]),
      ),
    );
  }

  Widget _detalheRow(String label, String valor, Color cor) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Expanded(child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF666666)))),
      Text(valor, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cor)),
    ]));
}
