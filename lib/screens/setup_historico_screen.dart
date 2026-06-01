import 'package:flutter/material.dart';
import '../constants.dart';

// ─────────────────────────────────────────
// HISTÓRICO DE SETUP — Screen
// ─────────────────────────────────────────

class SetupItem {
  String id;
  String maquina;
  String numeroProg;
  String nomePeca;
  String operacao;
  String material;
  // Offsets de trabalho
  double g54x, g54y, g54z;
  double g55x, g55y, g55z;
  // Ferramentas usadas
  List<FerramentaSetup> ferramentas;
  // Observações
  String observacoes;
  DateTime data;
  String operador;

  SetupItem({
    required this.id,
    required this.maquina,
    required this.numeroProg,
    required this.nomePeca,
    required this.operacao,
    required this.material,
    required this.g54x, required this.g54y, required this.g54z,
    required this.g55x, required this.g55y, required this.g55z,
    required this.ferramentas,
    required this.observacoes,
    required this.data,
    required this.operador,
  });
}

class FerramentaSetup {
  int numero; // T01, T02...
  String descricao;
  double compensacaoH; // comprimento H
  double compensacaoD; // raio D
  double desgasteH;
  double desgasteD;

  FerramentaSetup({
    required this.numero,
    required this.descricao,
    required this.compensacaoH,
    required this.compensacaoD,
    required this.desgasteH,
    required this.desgasteD,
  });
}

// ─── Dados de exemplo ─────────────────────────────────────
List<SetupItem> _setups = [
  SetupItem(
    id: '001',
    maquina: 'Centro CNC #1 — Fanuc 0i',
    numeroProg: 'O1234',
    nomePeca: 'Tampa Lateral',
    operacao: 'Fresamento de perfil + furação',
    material: 'Aço 1020',
    g54x: -320.450, g54y: -185.230, g54z: -250.000,
    g55x: 0, g55y: 0, g55z: 0,
    ferramentas: [
      FerramentaSetup(numero: 1, descricao: 'Fresa Topo Ø16mm 4F', compensacaoH: 145.320, compensacaoD: 8.003, desgasteH: 0.0, desgasteD: 0.0),
      FerramentaSetup(numero: 2, descricao: 'Broca Ø8mm HSS', compensacaoH: 122.450, compensacaoD: 0, desgasteH: 0.0, desgasteD: 0.0),
      FerramentaSetup(numero: 3, descricao: 'Macho M10x1.5', compensacaoH: 118.000, compensacaoD: 0, desgasteH: 0.0, desgasteD: 0.0),
    ],
    observacoes: 'Fixação em morsa — referenciar em X e Y no canto inferior esquerdo da peça. Checar paralelismo antes de iniciar.',
    data: DateTime.now().subtract(const Duration(days: 2)),
    operador: 'João',
  ),
  SetupItem(
    id: '002',
    maquina: 'Torno CNC #3 — Siemens 828D',
    numeroProg: 'MPF234',
    nomePeca: 'Eixo Escalonado',
    operacao: 'Torneamento externo + rosca M20',
    material: 'Aço 4140',
    g54x: 0, g54y: 0, g54z: -185.440,
    g55x: 0, g55y: 0, g55z: 0,
    ferramentas: [
      FerramentaSetup(numero: 1, descricao: 'Inserto CNMG 120408 desbaste', compensacaoH: 0, compensacaoD: 0.4, desgasteH: 0, desgasteD: 0),
      FerramentaSetup(numero: 2, descricao: 'Inserto DCMT 11T3 acabamento', compensacaoH: 0, compensacaoD: 0.2, desgasteH: 0, desgasteD: 0),
      FerramentaSetup(numero: 3, descricao: 'Inserto Rosca 60° passo 1.5', compensacaoH: 0, compensacaoD: 0, desgasteH: 0, desgasteD: 0),
    ],
    observacoes: 'Zero Z na face da peça. Tolerância do eixo: Ø30 h6. Verificar Rz < 3.2 após acabamento.',
    data: DateTime.now().subtract(const Duration(days: 5)),
    operador: 'Carlos',
  ),
];

// ─────────────────────────────────────────
class SetupHistoricoScreen extends StatefulWidget {
  const SetupHistoricoScreen({super.key});
  @override
  State<SetupHistoricoScreen> createState() => _SetupHistoricoScreenState();
}

class _SetupHistoricoScreenState extends State<SetupHistoricoScreen> {
  String _pesquisa = '';
  final _pesqCtrl = TextEditingController();

  List<SetupItem> get _filtrados {
    if (_pesquisa.isEmpty) return _setups;
    final q = _pesquisa.toLowerCase();
    return _setups.where((s) =>
      s.nomePeca.toLowerCase().contains(q) ||
      s.maquina.toLowerCase().contains(q) ||
      s.numeroProg.toLowerCase().contains(q) ||
      s.operador.toLowerCase().contains(q)
    ).toList();
  }

  @override
  void dispose() { _pesqCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: const Text('Histórico de Setup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        backgroundColor: kDark,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _showNovoSetup, tooltip: 'Novo setup'),
        ],
      ),
      body: Column(children: [
        // Barra de pesquisa
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _pesqCtrl,
            decoration: InputDecoration(
              hintText: 'Pesquisar por peça, máquina, programa...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _pesquisa.isNotEmpty
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _pesqCtrl.clear(); setState(() => _pesquisa = ''); })
                  : null,
              filled: true, fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            onChanged: (v) => setState(() => _pesquisa = v),
          ),
        ),

        // Lista de setups
        Expanded(
          child: _filtrados.isEmpty
            ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.history, color: Colors.grey[400], size: 60),
                const SizedBox(height: 12),
                Text('Nenhum setup encontrado', style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Novo Setup'),
                  style: ElevatedButton.styleFrom(backgroundColor: kDark, foregroundColor: Colors.white),
                  onPressed: _showNovoSetup,
                ),
              ]))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: _filtrados.length,
                itemBuilder: (ctx, i) => _buildSetupCard(_filtrados[i]),
              ),
        ),
      ]),
    );
  }

  Widget _buildSetupCard(SetupItem s) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _showDetalhe(s),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 46, height: 46,
                decoration: BoxDecoration(color: kDark.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.precision_manufacturing, color: kDark, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.nomePeca, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('${s.maquina}  •  ${s.numeroProg}', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ])),
              Text(_dataFormatada(s.data), style: TextStyle(color: Colors.grey[500], fontSize: 11)),
            ]),
            const SizedBox(height: 10),
            Text(s.operacao, style: const TextStyle(fontSize: 13, color: Colors.black87)),
            const SizedBox(height: 8),
            Row(children: [
              _tag(s.material, kBlue),
              const SizedBox(width: 6),
              _tag('T${s.ferramentas.length}', kGreen),
              const SizedBox(width: 6),
              _tag('Op: ${s.operador}', kAmber),
            ]),
            const SizedBox(height: 10),
            // Offsets resumo
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: kDark.withOpacity(0.04), borderRadius: BorderRadius.circular(8)),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _offsetChip('G54 X', s.g54x),
                _offsetChip('G54 Y', s.g54y),
                _offsetChip('G54 Z', s.g54z),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _offsetChip(String label, double val) {
    return Column(children: [
      Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      Text(val.toStringAsFixed(3), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace')),
    ]);
  }

  Widget _tag(String t, Color cor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: cor.withOpacity(0.1), borderRadius: BorderRadius.circular(6), border: Border.all(color: cor.withOpacity(0.4))),
      child: Text(t, style: TextStyle(color: cor, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }

  String _dataFormatada(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inDays == 0) return 'hoje';
    if (diff.inDays == 1) return 'ontem';
    return '${d.day.toString().padLeft(2,'0')}/${d.month.toString().padLeft(2,'0')}';
  }

  // ─── Detalhe do Setup ─────────────────────────────────────
  void _showDetalhe(SetupItem s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        builder: (_, ctrl) => SingleChildScrollView(
          controller: ctrl,
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),

            // Cabeçalho
            Text(s.nomePeca, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            Text('${s.maquina}  •  Prog: ${s.numeroProg}', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 4),
            Text('${_dataFormatada(s.data)} — Operador: ${s.operador}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            const Divider(height: 20),

            // Operação e material
            _secRow('Operação', s.operacao),
            _secRow('Material', s.material),
            const SizedBox(height: 16),

            // Offsets G54/G55
            _secTitle('Offsets de Trabalho'),
            const SizedBox(height: 8),
            _offsetTable('G54', s.g54x, s.g54y, s.g54z),
            if (s.g55x != 0 || s.g55y != 0 || s.g55z != 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: _offsetTable('G55', s.g55x, s.g55y, s.g55z),
              ),
            const SizedBox(height: 16),

            // Ferramentas
            _secTitle('Ferramentas (${s.ferramentas.length})'),
            const SizedBox(height: 8),
            ...s.ferramentas.map((f) => _ferramentaRow(f)),
            const SizedBox(height: 16),

            // Observações
            if (s.observacoes.isNotEmpty) ...[
              _secTitle('Observações do Setup'),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8E1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kAmber.withOpacity(0.5)),
                ),
                child: Text(s.observacoes, style: const TextStyle(fontSize: 13, height: 1.5)),
              ),
            ],
            const SizedBox(height: 20),

            // Ações
            Row(children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.copy),
                  label: const Text('Duplicar Setup'),
                  onPressed: () {
                    Navigator.pop(context);
                    _duplicarSetup(s);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Excluir'),
                  style: ElevatedButton.styleFrom(backgroundColor: kRed, foregroundColor: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                    _excluirSetup(s);
                  },
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _offsetTable(String wcs, double x, double y, double z) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: kDark.withOpacity(0.04), borderRadius: BorderRadius.circular(10), border: Border.all(color: kDark.withOpacity(0.1))),
      child: Row(children: [
        Container(
          width: 40,
          child: Text(wcs, style: TextStyle(fontWeight: FontWeight.bold, color: kDark, fontSize: 13)),
        ),
        Expanded(child: _coordBox('X', x)),
        const SizedBox(width: 8),
        Expanded(child: _coordBox('Y', y)),
        const SizedBox(width: 8),
        Expanded(child: _coordBox('Z', z)),
      ]),
    );
  }

  Widget _coordBox(String eixo, double val) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Column(children: [
        Text(eixo, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(val.toStringAsFixed(3), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'monospace')),
      ]),
    );
  }

  Widget _ferramentaRow(FerramentaSetup f) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
      child: Row(children: [
        Container(
          width: 34, height: 34,
          decoration: BoxDecoration(color: kDark, shape: BoxShape.circle),
          child: Center(child: Text('T${f.numero.toString().padLeft(2,'0')}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10))),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(f.descricao, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          if (f.compensacaoH != 0)
            Text('H: ${f.compensacaoH.toStringAsFixed(3)}  D: ${f.compensacaoD.toStringAsFixed(3)}',
              style: TextStyle(fontSize: 11, color: Colors.grey[600], fontFamily: 'monospace')),
        ])),
        if (f.desgasteH != 0 || f.desgasteD != 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: kAmber.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
            child: Text('Desg.', style: const TextStyle(color: kAmber, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
      ]),
    );
  }

  Widget _secTitle(String t) => Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kDark));
  Widget _secRow(String label, String val) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(children: [
      SizedBox(width: 80, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
      Expanded(child: Text(val, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
    ]),
  );

  // ─── Duplicar Setup ──────────────────────────────────────
  void _duplicarSetup(SetupItem original) {
    setState(() {
      _setups.insert(0, SetupItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        maquina: original.maquina,
        numeroProg: original.numeroProg,
        nomePeca: '${original.nomePeca} (cópia)',
        operacao: original.operacao,
        material: original.material,
        g54x: original.g54x, g54y: original.g54y, g54z: original.g54z,
        g55x: original.g55x, g55y: original.g55y, g55z: original.g55z,
        ferramentas: original.ferramentas,
        observacoes: original.observacoes,
        data: DateTime.now(),
        operador: original.operador,
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Setup duplicado com sucesso!'), backgroundColor: kGreen),
    );
  }

  // ─── Excluir Setup ───────────────────────────────────────
  void _excluirSetup(SetupItem s) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Excluir setup?'),
        content: Text('Deseja remover o setup de "${s.nomePeca}"?'),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.pop(context)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kRed),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
            onPressed: () {
              setState(() => _setups.removeWhere((item) => item.id == s.id));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // ─── Novo Setup ──────────────────────────────────────────
  void _showNovoSetup() {
    final maqCtrl = TextEditingController();
    final progCtrl = TextEditingController();
    final pecaCtrl = TextEditingController();
    final opCtrl = TextEditingController();
    final matCtrl = TextEditingController();
    final operacaoCtrl = TextEditingController();
    final g54xCtrl = TextEditingController(text: '0.000');
    final g54yCtrl = TextEditingController(text: '0.000');
    final g54zCtrl = TextEditingController(text: '0.000');
    final obsCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Novo Setup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 14),
            _inputF(maqCtrl, 'Máquina', 'Ex: Centro CNC #1 — Fanuc 0i'),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _inputF(progCtrl, 'Nº Programa', 'O1234')),
              const SizedBox(width: 8),
              Expanded(child: _inputF(opCtrl, 'Operador', 'Nome')),
            ]),
            const SizedBox(height: 8),
            _inputF(pecaCtrl, 'Nome da Peça', 'Ex: Tampa lateral'),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _inputF(matCtrl, 'Material', 'Ex: Aço 1020')),
            ]),
            const SizedBox(height: 8),
            _inputF(operacaoCtrl, 'Operação', 'Ex: Fresamento de perfil'),
            const SizedBox(height: 10),
            const Text('G54 — Zero Peça', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            Row(children: [
              Expanded(child: _inputF(g54xCtrl, 'X', '0.000')),
              const SizedBox(width: 6),
              Expanded(child: _inputF(g54yCtrl, 'Y', '0.000')),
              const SizedBox(width: 6),
              Expanded(child: _inputF(g54zCtrl, 'Z', '0.000')),
            ]),
            const SizedBox(height: 8),
            _inputF(obsCtrl, 'Observações', 'Fixação, referências, cuidados...', maxLines: 3),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Salvar Setup'),
                style: ElevatedButton.styleFrom(backgroundColor: kDark, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  if (pecaCtrl.text.trim().isEmpty) return;
                  setState(() {
                    _setups.insert(0, SetupItem(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      maquina: maqCtrl.text.trim(),
                      numeroProg: progCtrl.text.trim(),
                      nomePeca: pecaCtrl.text.trim(),
                      operacao: operacaoCtrl.text.trim(),
                      material: matCtrl.text.trim(),
                      g54x: double.tryParse(g54xCtrl.text) ?? 0,
                      g54y: double.tryParse(g54yCtrl.text) ?? 0,
                      g54z: double.tryParse(g54zCtrl.text) ?? 0,
                      g55x: 0, g55y: 0, g55z: 0,
                      ferramentas: [],
                      observacoes: obsCtrl.text.trim(),
                      data: DateTime.now(),
                      operador: opCtrl.text.trim(),
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

  Widget _inputF(TextEditingController ctrl, String label, String hint, {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
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
}
