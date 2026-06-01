import 'package:flutter/material.dart';
import '../../constants.dart';
import 'materiais_data.dart';

class MateriaisScreen extends StatefulWidget {
  const MateriaisScreen({super.key});
  @override
  State<MateriaisScreen> createState() => _MateriaisScreenState();
}

class _MateriaisScreenState extends State<MateriaisScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _busca = '';

  @override
  void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
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
                decoration: BoxDecoration(color: const Color(0xFF993C1D), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.layers_rounded, color: Colors.white, size: 20)),
              const SizedBox(width: 12),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Materiais', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                Text('PARÂMETROS DE CORTE MUNDIAIS', style: TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.5)),
              ]),
            ]),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: const Color(0xFF252540), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Icon(Icons.search, color: Colors.grey.shade500, size: 18),
                const SizedBox(width: 10),
                Expanded(child: TextField(
                  onChanged: (v) => setState(() => _busca = v.toLowerCase()),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Buscar material...',
                    hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                )),
              ]),
            ),
            const SizedBox(height: 12),
            TabBar(
              controller: _tab,
              labelColor: kAmber, unselectedLabelColor: Colors.grey,
              indicatorColor: kAmber, indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true, tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Fresamento (12)'),
                Tab(text: 'Torneamento (10)'),
                Tab(text: 'Furação (8)'),
              ],
            ),
          ]),
        ),
        Expanded(child: TabBarView(controller: _tab, children: [
          _MateriaisList(materiais: materiaisFresamento, busca: _busca),
          _MateriaisList(materiais: materiaisTorneamento, busca: _busca),
          _MateriaisList(materiais: materiaisFuracao, busca: _busca),
        ])),
      ]),
    );
  }
}

class _MateriaisList extends StatelessWidget {
  final List<MaterialCNC> materiais;
  final String busca;
  const _MateriaisList({required this.materiais, required this.busca});

  @override
  Widget build(BuildContext context) {
    final f = busca.isEmpty
      ? materiais
      : materiais.where((m) =>
          m.nome.toLowerCase().contains(busca) ||
          m.norma.toLowerCase().contains(busca) ||
          m.descricao.toLowerCase().contains(busca)).toList();

    if (f.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
      const SizedBox(height: 12),
      Text('Nenhum material encontrado', style: TextStyle(color: Colors.grey.shade400)),
    ]));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: f.length,
      itemBuilder: (ctx, i) => Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: _MaterialCard(material: f[i]))),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final MaterialCNC material;
  const _MaterialCard({required this.material});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => MaterialDetalheScreen(material: material))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100)),
        child: Row(children: [
          Container(width: 52, height: 52,
            decoration: BoxDecoration(
              color: material.cor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10)),
            child: Icon(material.icone, color: material.cor, size: 26)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(material.nome,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                child: Text(material.norma,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade600))),
            ]),
            const SizedBox(height: 4),
            Text(material.descricao,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Row(children: [
              _chip('Vc: ${material.vcMin}-${material.vcMax} m/min', kBlue),
              const SizedBox(width: 6),
              _chip('HB: ${material.dureza}', const Color(0xFF993C1D)),
            ]),
          ])),
          Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 20),
        ]),
      ),
    );
  }

  Widget _chip(String text, Color cor) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: cor.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(6)),
    child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: cor)));
}

class MaterialDetalheScreen extends StatelessWidget {
  final MaterialCNC material;
  const MaterialDetalheScreen({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    final temFresamento = material.fresamento.isNotEmpty;
    final temTorneamento = material.torneamento.isNotEmpty;
    final temFuracao = material.furacao.isNotEmpty;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kDark,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text(material.nome,
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // HEADER
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(14)),
              child: Row(children: [
                Container(width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: material.cor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12)),
                  child: Icon(material.icone, color: material.cor, size: 30)),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(material.nome, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(material.norma, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text(material.descricao, style: const TextStyle(color: Colors.grey, fontSize: 11, height: 1.4)),
                ])),
              ]),
            ),
            const SizedBox(height: 14),

            // PROPRIEDADES
            _secao('Propriedades do Material', Icons.science_rounded, kBlue,
              Column(children: [
                _prop('Dureza', material.dureza),
                _prop('Resistência à Tração', material.resistencia),
                _prop('Densidade', material.densidade),
                _prop('Maquinabilidade', material.maquinabilidade),
                if (material.aplicacoes.isNotEmpty) _prop('Aplicações', material.aplicacoes),
              ])),
            const SizedBox(height: 12),

            // PARÂMETROS
            _secao('Parâmetros de Corte', Icons.tune_rounded, const Color(0xFF993C1D),
              Column(children: [
                if (temFresamento) ...[
                  _subTitle('Fresamento', Icons.view_in_ar_rounded),
                  const SizedBox(height: 8),
                  _tabela(material.fresamento),
                  if (temTorneamento || temFuracao) const SizedBox(height: 14),
                ],
                if (temTorneamento) ...[
                  _subTitle('Torneamento', Icons.rotate_right_rounded),
                  const SizedBox(height: 8),
                  _tabela(material.torneamento),
                  if (temFuracao) const SizedBox(height: 14),
                ],
                if (temFuracao) ...[
                  _subTitle('Furação', Icons.radio_button_unchecked_rounded),
                  const SizedBox(height: 8),
                  _tabela(material.furacao),
                ],
              ])),
            const SizedBox(height: 12),

            // FLUIDO
            _secao('Fluido de Corte', Icons.water_drop_rounded, kGreen,
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _prop('Tipo recomendado', material.fluido),
                _prop('Concentração', material.concentracaoFluido),
                if (material.dicaFluido.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFE1F5EE), borderRadius: BorderRadius.circular(8)),
                    child: Text(material.dicaFluido,
                      style: const TextStyle(fontSize: 12, color: kGreen, height: 1.4))),
                ],
              ])),
            const SizedBox(height: 12),

            // DICAS
            if (material.dicas.isNotEmpty)
              _secao('Dicas Práticas de Chão de Fábrica', Icons.lightbulb_outline_rounded, kAmber,
                Column(children: material.dicas.asMap().entries.map((e) =>
                  Padding(padding: const EdgeInsets.only(bottom: 8),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(width: 22, height: 22, margin: const EdgeInsets.only(top: 1),
                        decoration: BoxDecoration(color: const Color(0xFFFFF3DC), borderRadius: BorderRadius.circular(11)),
                        child: Center(child: Text('${e.key+1}',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFBA7517))))),
                      const SizedBox(width: 8),
                      Expanded(child: Text(e.value,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4))),
                    ]))).toList())),
            const SizedBox(height: 20),
          ]),
        )),
      ),
    );
  }

  Widget _secao(String titulo, IconData icon, Color cor, Widget child) => Container(
    width: double.infinity, padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade100)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, size: 16, color: cor), const SizedBox(width: 6),
        Text(titulo, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cor, letterSpacing: 0.5))]),
      const SizedBox(height: 12), child,
    ]));

  Widget _subTitle(String t, IconData icon) => Row(children: [
    Icon(icon, size: 14, color: Colors.grey.shade500), const SizedBox(width: 6),
    Text(t, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
  ]);

  Widget _prop(String label, String valor) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 140, child: Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade500))),
      Expanded(child: Text(valor, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: kDark))),
    ]));

  Widget _tabela(List<ParamCorte> params) => Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(8)),
    child: Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.grey.shade50,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(7))),
        child: Row(children: [
          Expanded(flex: 3, child: Text('Operação', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey.shade600))),
          Expanded(flex: 2, child: Text('Vc (m/min)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey.shade600), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('fz (mm/d)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey.shade600), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text('ap (mm)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey.shade600), textAlign: TextAlign.center)),
        ]),
      ),
      ...params.asMap().entries.map((e) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: e.key.isOdd ? Colors.grey.shade50 : Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.5))),
        child: Row(children: [
          Expanded(flex: 3, child: Text(e.value.operacao, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))),
          Expanded(flex: 2, child: Text(e.value.vc, style: const TextStyle(fontSize: 11, color: kBlue), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(e.value.fz, style: const TextStyle(fontSize: 11, color: kGreen), textAlign: TextAlign.center)),
          Expanded(flex: 2, child: Text(e.value.ap, style: const TextStyle(fontSize: 11, color: Color(0xFF993C1D)), textAlign: TextAlign.center)),
        ]),
      )),
    ]),
  );
}