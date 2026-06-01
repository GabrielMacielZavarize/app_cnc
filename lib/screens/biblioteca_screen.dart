import 'package:flutter/material.dart';
import '../constants.dart';
import '../models.dart';
import '../data/codigos_extras.dart';
import '../data/codigos_g_fabricantes.dart';
import '../widgets/diagrama_cnc.dart';
import '../widgets/diagrama_codigo.dart';
import 'favoritos_screen.dart';

// ─────────────────────────────────────────
// MAPA DE SINÔNIMOS / INTENÇÃO CNC
// ─────────────────────────────────────────
const Map<String, List<String>> _sinonimos = {
  // Furação
  'furação': ['fura', 'furo', 'drill', 'g81', 'g83', 'g74', 'g73'],
  'fura': ['furação', 'furo', 'broca', 'g81', 'g83'],
  'furo': ['furação', 'fura', 'broca', 'g81', 'g83'],
  'pica pau': [
    'g83',
    'g74',
    'picapau',
    'pica-pau',
    'furação profunda',
    'quebra cavaco'
  ],
  'picapau': ['g83', 'g74', 'pica pau', 'furação profunda'],
  'pica-pau': ['g83', 'g74', 'pica pau', 'furação profunda'],
  'furação profunda': ['g83', 'g74', 'pica pau'],
  'quebra cavaco': ['g83', 'g74', 'pica pau'],
  'furação simples': ['g81', 'ciclo de furação'],
  // Rosqueamento
  'rosca': ['g76', 'g84', 'g92', 'rosqueamento', 'macho', 'thread'],
  'rosqueamento': ['g76', 'g84', 'g92', 'rosca', 'macho'],
  'macho': ['g84', 'g76', 'rosqueamento', 'rosca'],
  'thread': ['g76', 'g84', 'g92', 'rosca'],
  // Desbaste / acabamento
  'desbaste': ['g71', 'g72', 'g73', 'roughing'],
  'desbaste longitudinal': ['g71'],
  'desbaste frontal': ['g72'],
  'acabamento': ['g70', 'g72', 'finishing'],
  'finishing': ['g70', 'acabamento'],
  'roughing': ['g71', 'g72', 'desbaste'],
  // Sangria / canal
  'sangria': ['g75', 'g74', 'canal', 'grooving'],
  'canal': ['g75', 'g74', 'sangria'],
  'grooving': ['g75', 'canal', 'sangria'],
  // Torneamento
  'torneamento': ['g90', 'g71', 'g72', 'torno', 'turning'],
  'turning': ['g90', 'g71', 'torneamento'],
  'cilindrar': ['g90', 'g71', 'torneamento externo'],
  'tornear': ['g90', 'g71', 'torneamento'],
  // Movimentos
  'posicionamento': ['g00', 'rápido', 'rapid'],
  'rápido': ['g00', 'posicionamento rápido'],
  'rapid': ['g00', 'posicionamento rápido'],
  'linear': ['g01', 'interpolação linear'],
  'circular': ['g02', 'g03', 'arco', 'raio'],
  'arco': ['g02', 'g03', 'circular'],
  // Compensação
  'compensação': ['g41', 'g42', 'g43', 'offset', 'raio'],
  'compensação raio': ['g41', 'g42'],
  'offset': ['g43', 'g41', 'g42', 'compensação'],
  'raio ferramenta': ['g41', 'g42'],
  // Coordenadas
  'origem': ['g54', 'g55', 'g56', 'zeragem', 'zero peça'],
  'zeragem': ['g54', 'g55', 'zero peça', 'origem'],
  'zero peça': ['g54', 'g55', 'zeragem', 'origem'],
  'coordenadas': ['g54', 'g55', 'g90', 'g91'],
  'absoluto': ['g90', 'absoluta'],
  'incremental': ['g91', 'relativo'],
  // Spindle / avanço
  'spindle': ['m03', 'm04', 'm05', 'rotação'],
  'rotação': ['m03', 'm04', 'g97', 'rpm'],
  'rpm': ['g97', 'm03', 'rotação', 's'],
  'velocidade corte': ['g96', 'css', 'vc'],
  'css': ['g96', 'velocidade corte'],
  'avanço': ['g94', 'g95', 'f', 'feed'],
  'feed': ['g94', 'g95', 'avanço'],
  // Refrigeração
  'refrigeração': ['m08', 'm09', 'fluido', 'coolant'],
  'fluido': ['m08', 'm09', 'refrigeração'],
  'coolant': ['m08', 'm09', 'refrigeração'],
  // Troca ferramenta
  'troca ferramenta': ['m06', 'atc', 'tool change'],
  'atc': ['m06', 'troca ferramenta'],
  // Mandrilamento
  'mandrilamento': ['g85', 'g86', 'boring'],
  'boring': ['g85', 'g86', 'mandrilamento'],
  // Sub-rotina / macro
  'sub-rotina': ['m98', 'm99', 'subprograma'],
  'subprograma': ['m98', 'm99', 'sub-rotina'],
  'macro': ['m98', 'g65', 'sub-rotina'],
  // Parada
  'parada': ['m00', 'm01', 'm02', 'stop'],
  'stop': ['m00', 'm01', 'parada'],
};

// Palavras que devem ser ignoradas na busca (stop words CNC)
const _stopWords = {
  'qual',
  'como',
  'para',
  'usar',
  'fazer',
  'código',
  'codigo',
  'função',
  'funcao',
  'que',
  'o',
  'a',
  'de',
  'do',
  'da',
  'no',
  'na',
  'em',
  'com',
  'torno',
  'cnc',
  'comando',
  'fanuc',
  'siemens',
  'haas',
  'um',
  'uma',
  'e',
  'ou',
  'se',
  'por',
  'mais',
  'menos',
  'muito',
  'pouco',
  'bem',
  'mal',
  'preciso',
  'quero',
  'desejo',
  'gostaria',
  'necessito',
  'indica',
  'indicar',
  'programador',
  'operador',
  'máquina',
  'maquina',
};

/// Extrai termos relevantes da busca, expande sinônimos e retorna set de palavras
Set<String> _expandirBusca(String busca) {
  final termos = busca.toLowerCase().trim();
  final resultado = <String>{};

  // Adiciona a busca original inteira (para frases compostas)
  resultado.add(termos);

  // Verifica frases compostas no mapa de sinônimos
  for (final chave in _sinonimos.keys) {
    if (termos.contains(chave)) {
      resultado.add(chave);
      resultado.addAll(_sinonimos[chave]!);
    }
  }

  // Divide em palavras individuais, filtra stop words
  final palavras = termos
      .split(RegExp(r'[\s\-_]+'))
      .where((p) => p.length >= 2 && !_stopWords.contains(p))
      .toList();

  for (final p in palavras) {
    resultado.add(p);
    // Expande sinônimos de cada palavra
    if (_sinonimos.containsKey(p)) {
      resultado.addAll(_sinonimos[p]!);
    }
    // Busca parcial no mapa (ex: "pica" encontra "pica pau")
    for (final chave in _sinonimos.keys) {
      if (chave.contains(p) && p.length >= 3) {
        resultado.add(chave);
        resultado.addAll(_sinonimos[chave]!);
      }
    }
  }

  return resultado;
}

/// Calcula score de relevância de um item para a busca
int _scoreItem(CodigoItem c, Set<String> termos) {
  int score = 0;
  final codigo = c.codigo.toLowerCase();
  final nome = c.nome.toLowerCase();
  final descricao = c.descricao.toLowerCase();
  final descComp = c.descricaoCompleta.toLowerCase();
  final categoria = c.categoria.toLowerCase();

  for (final t in termos) {
    if (t.isEmpty) continue;
    if (codigo == t) score += 100; // match exato do código
    if (codigo.contains(t)) score += 50;
    if (nome.contains(t)) score += 30;
    if (descricao.contains(t)) score += 20;
    if (descComp.contains(t)) score += 10;
    if (categoria.contains(t)) score += 15;
    if (c.fabricante.toLowerCase().contains(t)) score += 5;
  }
  return score;
}

// ─────────────────────────────────────────
// BIBLIOTECA SCREEN
// ─────────────────────────────────────────
class BibliotecaScreen extends StatefulWidget {
  final String? initialSearch;
  const BibliotecaScreen({super.key, this.initialSearch});
  @override
  State<BibliotecaScreen> createState() => _BibliotecaScreenState();
}

class _BibliotecaScreenState extends State<BibliotecaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _busca = '';
  String _fabricante = 'Todos';
  final _searchController = TextEditingController();

  static const _fabricantes = [
    'Todos',
    'Universal',
    'Fanuc',
    'Siemens',
    'Haas',
    'Heidenhain',
    'Mazak',
    'Okuma',
    'Mitsubishi',
    'Brother',
    'DMG',
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 6, vsync: this);
    favManager.addListener(_refresh);
    if (widget.initialSearch != null && widget.initialSearch!.isNotEmpty) {
      _busca = widget.initialSearch!;
      _searchController.text = _busca;
    }
  }

  @override
  void dispose() {
    _tab.dispose();
    _searchController.dispose();
    favManager.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  Color _corFabricante(String fab) {
    switch (fab) {
      case 'Fanuc':
        return const Color(0xFFE53935);
      case 'Siemens':
        return const Color(0xFF0099DB);
      case 'Haas':
        return const Color(0xFF4CAF50);
      case 'Heidenhain':
        return const Color(0xFF9C27B0);
      case 'Mazak':
        return const Color(0xFFFF6F00);
      case 'Okuma':
        return const Color(0xFF00897B);
      case 'Mitsubishi':
        return const Color(0xFFD32F2F);
      case 'Brother':
        return const Color(0xFF1565C0);
      case 'DMG':
        return const Color(0xFF37474F);
      case 'Universal':
        return Colors.grey.shade600;
      default:
        return kAmber;
    }
  }

  List<CodigoItem> get _todosM => [...codigosM, ...codigosMExtras];
  List<CodigoItem> get _todosG => [...codigosG, ...codigosGFabricantes];

  // ── Filtro com busca semântica ──────────────────────────────────────────
  List<CodigoItem> _filtrar(List<CodigoItem> lista, String maquina) {
    final base = lista.where((c) {
      final maquinaOk = c.maquina == maquina || c.maquina == 'Ambos';
      final fabOk = _fabricante == 'Todos' || c.fabricante == _fabricante;
      return maquinaOk && fabOk;
    }).toList();

    if (_busca.trim().isEmpty) return base;

    final termos = _expandirBusca(_busca);
    final comScore = base
        .map((c) => (item: c, score: _scoreItem(c, termos)))
        .where((e) => e.score > 0)
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return comScore.map((e) => e.item).toList();
  }

  List<CodigoItem> _filtrarGeral(List<CodigoItem> lista) {
    final base = lista.where((c) {
      final isGeral = c.maquina == 'Ambos';
      final fabOk = _fabricante == 'Todos' || c.fabricante == _fabricante;
      return isGeral && fabOk;
    }).toList();

    if (_busca.trim().isEmpty) return base;

    final termos = _expandirBusca(_busca);
    final comScore = base
        .map((c) => (item: c, score: _scoreItem(c, termos)))
        .where((e) => e.score > 0)
        .toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    return comScore.map((e) => e.item).toList();
  }

  List<CodigoItem> get _gCentro => _filtrar(_todosG, 'Centro de Usinagem');
  List<CodigoItem> get _gTorno => _filtrar(_todosG, 'Torno CNC');
  List<CodigoItem> get _gGeral => _filtrarGeral(_todosG);
  List<CodigoItem> get _mCentro => _filtrar(_todosM, 'Centro de Usinagem');
  List<CodigoItem> get _mTorno => _filtrar(_todosM, 'Torno CNC');
  List<CodigoItem> get _mGeral => _filtrarGeral(_todosM);

  int get _totalResultados =>
      _gCentro.length +
      _gTorno.length +
      _gGeral.length +
      _mCentro.length +
      _mTorno.length +
      _mGeral.length;

  // Muda para a aba com mais resultados automaticamente
  void _irParaMelhorAba() {
    if (_busca.isEmpty) return;
    final contagens = [
      _gCentro.length,
      _gTorno.length,
      _gGeral.length,
      _mCentro.length,
      _mTorno.length,
      _mGeral.length,
    ];
    int melhorIdx = 0;
    int melhorVal = 0;
    for (int i = 0; i < contagens.length; i++) {
      if (contagens[i] > melhorVal) {
        melhorVal = contagens[i];
        melhorIdx = i;
      }
    }
    if (melhorVal > 0) _tab.animateTo(melhorIdx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        Container(
          color: kDark,
          padding: const EdgeInsets.fromLTRB(20, 55, 20, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: const Color(0xFFBA7517),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.menu_book_rounded,
                      color: Colors.white, size: 20)),
              const SizedBox(width: 12),
              const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Biblioteca G/M',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600)),
                    Text('FANUC • SIEMENS • HAAS • HEIDENHAIN • MAZAK E MAIS',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 9,
                            letterSpacing: 1.5)),
                  ]),
            ]),
            const SizedBox(height: 14),

            // ── BARRA DE BUSCA ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                  color: const Color(0xFF252540),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Icon(Icons.search,
                    color: _busca.isEmpty ? Colors.grey.shade500 : kAmber,
                    size: 18),
                const SizedBox(width: 10),
                Expanded(
                    child: TextField(
                  controller: _searchController,
                  onChanged: (v) {
                    setState(() => _busca = v);
                    // Muda aba automaticamente após 400ms
                    Future.delayed(const Duration(milliseconds: 400), () {
                      if (mounted) _irParaMelhorAba();
                    });
                  },
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText:
                        'Ex: "furação pica pau", "rosca M10", "desbaste"...',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                )),
                if (_busca.isNotEmpty)
                  GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _busca = '');
                      },
                      child: Icon(Icons.close_rounded,
                          color: Colors.grey.shade400, size: 18)),
              ]),
            ),

            // ── RESULTADO + SUGESTÃO SEMÂNTICA ──────────────────────────
            if (_busca.isNotEmpty) ...[
              const SizedBox(height: 8),
              if (_totalResultados > 0)
                Row(children: [
                  Icon(Icons.check_circle_rounded, color: kGreen, size: 13),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(
                          '$_totalResultados resultado(s) para "$_busca"',
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 11))),
                ])
              else ...[
                Row(children: [
                  Icon(Icons.info_outline_rounded,
                      color: Colors.orange.shade300, size: 13),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(
                          'Nenhum resultado — tente: código (G83), operação (furação) ou material',
                          style: TextStyle(
                              color: Colors.orange.shade300, fontSize: 11))),
                ]),
              ],
            ],
            const SizedBox(height: 10),

            // ── FILTRO FABRICANTE ────────────────────────────────────────
            SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _fabricantes.map((fab) {
                  final ativo = _fabricante == fab;
                  final cor = _corFabricante(fab);
                  return GestureDetector(
                    onTap: () => setState(() => _fabricante = fab),
                    child: Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                          color: ativo ? cor : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: ativo ? cor : Colors.grey.shade600,
                              width: 1)),
                      child: Text(fab,
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color:
                                  ativo ? Colors.white : Colors.grey.shade400)),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // ── ABAS ─────────────────────────────────────────────────────
            TabBar(
              controller: _tab,
              labelColor: kAmber,
              unselectedLabelColor: Colors.grey,
              indicatorColor: kAmber,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelStyle:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: '⚙️ G-Centro (${_gCentro.length})'),
                Tab(text: '🔄 G-Torno (${_gTorno.length})'),
                Tab(text: '🌐 G-Geral (${_gGeral.length})'),
                Tab(text: '⚙️ M-Centro (${_mCentro.length})'),
                Tab(text: '🔄 M-Torno (${_mTorno.length})'),
                Tab(text: '🌐 M-Geral (${_mGeral.length})'),
              ],
            ),
          ]),
        ),
        Expanded(
            child: TabBarView(controller: _tab, children: [
          CodigosList(
              codigos: _gCentro,
              busca: _busca,
              maquinaLabel: 'Centro de Usinagem'),
          CodigosList(
              codigos: _gTorno, busca: _busca, maquinaLabel: 'Torno CNC'),
          CodigosList(
              codigos: _gGeral,
              busca: _busca,
              maquinaLabel: 'Ambas as máquinas'),
          CodigosList(
              codigos: _mCentro,
              busca: _busca,
              maquinaLabel: 'Centro de Usinagem'),
          CodigosList(
              codigos: _mTorno, busca: _busca, maquinaLabel: 'Torno CNC'),
          CodigosList(
              codigos: _mGeral,
              busca: _busca,
              maquinaLabel: 'Ambas as máquinas'),
        ])),
      ]),
    );
  }
}

// ─────────────────────────────────────────
// LISTA DE CÓDIGOS
// ─────────────────────────────────────────
class CodigosList extends StatelessWidget {
  final List<CodigoItem> codigos;
  final String busca;
  final String maquinaLabel;
  const CodigosList(
      {super.key,
      required this.codigos,
      required this.busca,
      required this.maquinaLabel});

  @override
  Widget build(BuildContext context) {
    if (codigos.isEmpty) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
        const SizedBox(height: 12),
        Text(
            busca.isEmpty
                ? 'Nenhum código encontrado'
                : 'Sem resultados para "$busca"',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text(maquinaLabel,
            style: TextStyle(color: Colors.grey.shade300, fontSize: 12)),
      ]));
    }

    // Quando há busca, mostra lista plana ordenada por relevância
    // Quando não há busca, agrupa por categoria
    if (busca.isNotEmpty) {
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
              child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
                children:
                    codigos.map((item) => CodigoCard(item: item)).toList()),
          )),
        ],
      );
    }

    // Agrupa por categoria (comportamento original)
    final categorias = <String, List<CodigoItem>>{};
    for (final c in codigos) {
      categorias.putIfAbsent(c.categoria, () => []).add(c);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: categorias.entries
          .map((entry) => Center(
                  child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 4),
                        child: Row(children: [
                          Container(
                              width: 4,
                              height: 16,
                              decoration: BoxDecoration(
                                  color: kAmber,
                                  borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 8),
                          Text(entry.key,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: kDark,
                                  letterSpacing: 0.5)),
                          const SizedBox(width: 6),
                          Text('(${entry.value.length})',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.grey.shade400)),
                        ]),
                      ),
                      ...entry.value.map((item) => CodigoCard(item: item)),
                      const SizedBox(height: 8),
                    ]),
              )))
          .toList(),
    );
  }
}

// ─────────────────────────────────────────
// CARD DE CÓDIGO (idêntico ao original)
// ─────────────────────────────────────────
class CodigoCard extends StatefulWidget {
  final CodigoItem item;
  const CodigoCard({super.key, required this.item});
  @override
  State<CodigoCard> createState() => _CodigoCardState();
}

class _CodigoCardState extends State<CodigoCard> {
  @override
  Widget build(BuildContext context) {
    final isFav = favManager.isCodFavorito(widget.item.codigo);
    final isG = widget.item.isG;
    final cor = isG ? const Color(0xFFBA7517) : kGreen;
    final corBg = isG ? const Color(0xFFFFF3DC) : const Color(0xFFE1F5EE);

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CodigoDetalheScreen(item: widget.item))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color:
                    isFav ? kRed.withValues(alpha: 0.3) : Colors.grey.shade100,
                width: isFav ? 1.5 : 0.5)),
        child: Row(children: [
          Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: corBg, borderRadius: BorderRadius.circular(8)),
              child: Center(
                  child: Text(widget.item.codigo,
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: cor),
                      textAlign: TextAlign.center))),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(widget.item.nome,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(widget.item.descricao,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Wrap(spacing: 4, runSpacing: 4, children: [
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                          color: _corMaquina(widget.item.maquina)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4)),
                      child: Text(widget.item.maquina,
                          style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: _corMaquina(widget.item.maquina)))),
                  if (widget.item.fabricante != 'Universal')
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: _corFabricanteCard(widget.item.fabricante)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4)),
                        child: Text(widget.item.fabricante,
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: _corFabricanteCard(
                                    widget.item.fabricante)))),
                  if (widget.item.diagramaTipo != null)
                    Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: kAmber.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4)),
                        child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.square_foot_rounded,
                                  size: 9, color: kAmber),
                              SizedBox(width: 3),
                              Text('Diagrama',
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: kAmber)),
                            ])),
                ]),
              ])),
          const SizedBox(width: 8),
          GestureDetector(
              onTap: () {
                favManager.toggleCodigo(widget.item);
                setState(() {});
              },
              child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      key: ValueKey(isFav),
                      color: isFav ? kRed : Colors.grey.shade300,
                      size: 20))),
        ]),
      ),
    );
  }

  Color _corMaquina(String m) {
    switch (m) {
      case 'Centro de Usinagem':
        return kBlue;
      case 'Torno CNC':
        return const Color(0xFF993C1D);
      default:
        return kGreen;
    }
  }

  Color _corFabricanteCard(String f) {
    switch (f) {
      case 'Fanuc':
        return const Color(0xFF0057A8);
      case 'Siemens':
        return const Color(0xFF009999);
      case 'Haas':
        return const Color(0xFFCC0000);
      case 'Heidenhain':
        return const Color(0xFF006633);
      case 'Mazak':
        return const Color(0xFF004B8D);
      case 'Okuma':
        return const Color(0xFF8B0000);
      case 'Mitsubishi':
        return const Color(0xFFCC3300);
      case 'Brother':
        return const Color(0xFF003399);
      case 'DMG':
        return const Color(0xFF333333);
      default:
        return kGreen;
    }
  }
}

// ─────────────────────────────────────────
// DETALHE DO CÓDIGO (idêntico ao original)
// ─────────────────────────────────────────
class CodigoDetalheScreen extends StatefulWidget {
  final CodigoItem item;
  const CodigoDetalheScreen({super.key, required this.item});
  @override
  State<CodigoDetalheScreen> createState() => _CodigoDetalheScreenState();
}

class _CodigoDetalheScreenState extends State<CodigoDetalheScreen> {
  @override
  Widget build(BuildContext context) {
    final cor = widget.item.isG ? const Color(0xFFBA7517) : kGreen;
    final corBg =
        widget.item.isG ? const Color(0xFFFFF3DC) : const Color(0xFFE1F5EE);
    final isFav = favManager.isCodFavorito(widget.item.codigo);

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kDark,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: Text(widget.item.codigo,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
              icon: Icon(
                  isFav
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: isFav ? kRed : Colors.grey),
              onPressed: () {
                favManager.toggleCodigo(widget.item);
                setState(() {});
              }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(spacing: 8, runSpacing: 6, children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: corBg, borderRadius: BorderRadius.circular(20)),
                  child: Text(widget.item.isG ? 'Código G' : 'Código M',
                      style: TextStyle(
                          color: cor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600))),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(widget.item.categoria,
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 12))),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: _corMaquinaBg(widget.item.maquina),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(widget.item.maquina,
                      style: TextStyle(
                          color: _corMaquina(widget.item.maquina),
                          fontSize: 12,
                          fontWeight: FontWeight.w600))),
              if (widget.item.fabricante != 'Universal')
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: _corFabricanteBg(widget.item.fabricante),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.precision_manufacturing_rounded,
                          size: 12),
                      const SizedBox(width: 4),
                      Text(widget.item.fabricante,
                          style: TextStyle(
                              color: _corFabricante(widget.item.fabricante),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ])),
            ]),
            const SizedBox(height: 16),
            if (widget.item.diagramaTipo != null) ...[
              _card(
                  'Diagrama de Movimento',
                  Icons.square_foot_rounded,
                  kAmber,
                  Center(
                      child: DiagramaCNC(
                          tipo: widget.item.diagramaTipo!, size: 220))),
              const SizedBox(height: 12),
            ],
            if (widget.item.imagemUrl != null) ...[
              _card(
                  'Foto Ilustrativa',
                  Icons.photo_camera_rounded,
                  const Color(0xFF7B1FA2),
                  _buildImagem(
                      widget.item.imagemUrl!, widget.item.imagemLegenda)),
              const SizedBox(height: 12),
            ],
            if (DiagramaCodigo.has(widget.item.codigo)) ...[
              _card('Diagrama Técnico', Icons.schema_rounded, kBlue,
                  Center(child: DiagramaCodigo(codigo: widget.item.codigo))),
              const SizedBox(height: 12),
            ],
            _card(
                'O que faz',
                Icons.info_outline_rounded,
                cor,
                Text(widget.item.descricaoCompleta,
                    style: const TextStyle(
                        fontSize: 14, height: 1.6, color: Color(0xFF333333)))),
            const SizedBox(height: 12),
            _card(
                'Sintaxe',
                Icons.code_rounded,
                cor,
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: kDark, borderRadius: BorderRadius.circular(8)),
                    child: Text(widget.item.sintaxe,
                        style: const TextStyle(
                            color: kAmber,
                            fontSize: 13,
                            fontFamily: 'monospace',
                            height: 1.5)))),
            const SizedBox(height: 12),
            if (widget.item.parametros.isNotEmpty) ...[
              _card(
                  'Parâmetros',
                  Icons.tune_rounded,
                  cor,
                  Column(
                      children: widget.item.parametros
                          .map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                            color: corBg,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: Center(
                                            child: Text(p.letra,
                                                style: TextStyle(
                                                    color: cor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w700)))),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: Text(p.descricao,
                                            style: const TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFF444444),
                                                height: 1.5))),
                                  ])))
                          .toList())),
              const SizedBox(height: 12),
            ],
            _card(
                'Exemplo real',
                Icons.play_circle_outline_rounded,
                cor,
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: kDark, borderRadius: BorderRadius.circular(8)),
                      child: Text(widget.item.exemplo,
                          style: const TextStyle(
                              color: Color(0xFF7EC8A4),
                              fontSize: 13,
                              fontFamily: 'monospace',
                              height: 1.7))),
                  const SizedBox(height: 10),
                  Text(widget.item.explicacaoExemplo,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.5)),
                ])),
            if (widget.item.dicaProfissional != null) ...[
              const SizedBox(height: 12),
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF8E1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: kAmber.withValues(alpha: 0.4))),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.star_rounded, color: kAmber, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              const Text('Dica Profissional',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: kAmber,
                                      letterSpacing: 0.5)),
                              const SizedBox(height: 6),
                              Text(widget.item.dicaProfissional!,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF5D4037),
                                      height: 1.5)),
                            ])),
                      ])),
            ],
            const SizedBox(height: 20),
          ]),
        )),
      ),
    );
  }

  Color _corMaquina(String m) {
    switch (m) {
      case 'Centro de Usinagem':
        return kBlue;
      case 'Torno CNC':
        return const Color(0xFF993C1D);
      default:
        return kGreen;
    }
  }

  Color _corMaquinaBg(String m) {
    switch (m) {
      case 'Centro de Usinagem':
        return const Color(0xFFE6F1FB);
      case 'Torno CNC':
        return const Color(0xFFFAECE7);
      default:
        return const Color(0xFFE1F5EE);
    }
  }

  Color _corFabricante(String f) {
    switch (f) {
      case 'Fanuc':
        return const Color(0xFF0057A8);
      case 'Siemens':
        return const Color(0xFF009999);
      case 'Haas':
        return const Color(0xFFCC0000);
      case 'Heidenhain':
        return const Color(0xFF006633);
      case 'Mazak':
        return const Color(0xFF004B8D);
      case 'Okuma':
        return const Color(0xFF8B0000);
      case 'Mitsubishi':
        return const Color(0xFFCC3300);
      case 'Brother':
        return const Color(0xFF003399);
      case 'DMG':
        return const Color(0xFF333333);
      default:
        return kGreen;
    }
  }

  Color _corFabricanteBg(String f) {
    switch (f) {
      case 'Fanuc':
        return const Color(0xFFE6EFF9);
      case 'Siemens':
        return const Color(0xFFE0F4F4);
      case 'Haas':
        return const Color(0xFFFAE6E6);
      case 'Heidenhain':
        return const Color(0xFFE6F4EC);
      case 'Mazak':
        return const Color(0xFFE6EEF7);
      case 'Okuma':
        return const Color(0xFFF5E6E6);
      case 'Mitsubishi':
        return const Color(0xFFFAEDE8);
      case 'Brother':
        return const Color(0xFFE6EAF5);
      case 'DMG':
        return const Color(0xFFEEEEEE);
      default:
        return const Color(0xFFE1F5EE);
    }
  }

  Widget _buildImagem(String url, String? legenda) {
    final isNetwork = url.startsWith('http');
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: isNetwork
            ? Image.network(url,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (ctx, child, progress) {
                  if (progress == null) return child;
                  return Container(
                      height: 180,
                      color: Colors.grey.shade100,
                      child: const Center(
                          child: CircularProgressIndicator(color: kAmber)));
                },
                errorBuilder: (ctx, err, st) => Container(
                    height: 140,
                    color: Colors.grey.shade100,
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.broken_image_rounded,
                              color: Colors.grey, size: 40),
                          SizedBox(height: 8),
                          Text('Imagem indisponível',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12)),
                        ])))
            : Image.asset(url,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) => Container(
                    height: 140,
                    color: Colors.grey.shade100,
                    child: const Center(
                        child: Icon(Icons.image_not_supported_rounded,
                            color: Colors.grey)))),
      ),
      if (legenda != null) ...[
        const SizedBox(height: 8),
        Text(legenda,
            style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontStyle: FontStyle.italic)),
      ],
    ]);
  }

  Widget _card(String titulo, IconData icon, Color cor, Widget child) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, size: 16, color: cor),
            const SizedBox(width: 6),
            Text(titulo,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: cor,
                    letterSpacing: 0.5)),
          ]),
          const SizedBox(height: 12),
          child,
        ]));
  }
}
