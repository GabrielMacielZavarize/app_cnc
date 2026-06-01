import 'package:flutter/material.dart';
import '../constants.dart';
import '../models.dart';
import 'biblioteca_screen.dart';

// ─────────────────────────────────────────
// GERENCIADOR DE FAVORITOS (Singleton)
// ─────────────────────────────────────────
class FavoritosManager {
  static final FavoritosManager _instance = FavoritosManager._internal();
  factory FavoritosManager() => _instance;
  FavoritosManager._internal();

  final Set<String> _codigosFavoritos = {};
  final Set<String> _alarmesFavoritos = {};
  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback listener) => _listeners.add(listener);
  void removeListener(VoidCallback listener) => _listeners.remove(listener);
  void _notify() { for (final l in _listeners) l(); }

  bool isCodFavorito(String codigo) => _codigosFavoritos.contains(codigo);
  bool isAlarmeFavorito(String codigo) => _alarmesFavoritos.contains(codigo);

  void toggleCodigo(CodigoItem item) {
    if (_codigosFavoritos.contains(item.codigo)) {
      _codigosFavoritos.remove(item.codigo);
    } else {
      _codigosFavoritos.add(item.codigo);
    }
    _notify();
  }

  void toggleAlarme(AlarmeItem item) {
    if (_alarmesFavoritos.contains(item.codigo)) {
      _alarmesFavoritos.remove(item.codigo);
    } else {
      _alarmesFavoritos.add(item.codigo);
    }
    _notify();
  }

  List<CodigoItem> get codigosFavoritosG =>
    codigosG.where((c) => _codigosFavoritos.contains(c.codigo)).toList();

  List<CodigoItem> get codigosFavoritosM =>
    codigosM.where((c) => _codigosFavoritos.contains(c.codigo)).toList();

  List<AlarmeItem> get alarmesFavoritosFanuc =>
    alarmesFanuc.where((a) => _alarmesFavoritos.contains(a.codigo)).toList();

  List<AlarmeItem> get alarmesFavoritosSiemens =>
    alarmesSiemens.where((a) => _alarmesFavoritos.contains(a.codigo)).toList();

  List<AlarmeItem> get alarmesFavoritosHaas =>
    alarmesHaas.where((a) => _alarmesFavoritos.contains(a.codigo)).toList();

  List<AlarmeItem> get alarmesFavoritosMazak =>
    alarmesMazak.where((a) => _alarmesFavoritos.contains(a.codigo)).toList();

  List<AlarmeItem> get alarmesFavoritosMitsubishi =>
    alarmesMitsubishi.where((a) => _alarmesFavoritos.contains(a.codigo)).toList();

  int get totalFavoritos =>
    _codigosFavoritos.length + _alarmesFavoritos.length;
}

final favManager = FavoritosManager();

// ─────────────────────────────────────────
// TELA DE FAVORITOS
// ─────────────────────────────────────────
class FavoritosScreen extends StatefulWidget {
  const FavoritosScreen({super.key});
  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    favManager.addListener(_refresh);
  }

  @override
  void dispose() {
    _tab.dispose();
    favManager.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final totalG = favManager.codigosFavoritosG.length;
    final totalM = favManager.codigosFavoritosM.length;
    final totalA = favManager.alarmesFavoritosFanuc.length +
        favManager.alarmesFavoritosSiemens.length +
        favManager.alarmesFavoritosHaas.length +
        favManager.alarmesFavoritosMazak.length +
        favManager.alarmesFavoritosMitsubishi.length;

    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        Container(
          color: kDark,
          padding: const EdgeInsets.fromLTRB(20, 55, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 36, height: 36,
                decoration: BoxDecoration(color: kRed, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20)),
              const SizedBox(width: 12),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Favoritos', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                Text('SEUS ITENS SALVOS', style: TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.5)),
              ]),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: kRed.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                child: Text('${favManager.totalFavoritos} salvos',
                  style: const TextStyle(color: kRed, fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ]),
            const SizedBox(height: 16),
            TabBar(
              controller: _tab,
              labelColor: kAmber, unselectedLabelColor: Colors.grey,
              indicatorColor: kAmber, indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true, tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: 'Códigos G ($totalG)'),
                Tab(text: 'Códigos M ($totalM)'),
                Tab(text: 'Alarmes ($totalA)'),
              ],
            ),
          ]),
        ),
        Expanded(child: TabBarView(controller: _tab, children: [
          _ListaCodigos(codigos: favManager.codigosFavoritosG, tipo: 'G'),
          _ListaCodigos(codigos: favManager.codigosFavoritosM, tipo: 'M'),
          _ListaAlarmes(),
        ])),
      ]),
    );
  }
}

// ─────────────────────────────────────────
// LISTA DE CÓDIGOS FAVORITOS
// ─────────────────────────────────────────
class _ListaCodigos extends StatelessWidget {
  final List<CodigoItem> codigos;
  final String tipo;
  const _ListaCodigos({required this.codigos, required this.tipo});

  @override
  Widget build(BuildContext context) {
    if (codigos.isEmpty) return _EmptyState(
      icon: Icons.menu_book_rounded,
      titulo: 'Nenhum código $tipo favorito',
      subtitulo: 'Toque no ❤ em qualquer código na Biblioteca para salvar aqui',
    );

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: codigos.length,
      itemBuilder: (ctx, i) => Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: _CodigoFavCard(item: codigos[i]))),
    );
  }
}

class _CodigoFavCard extends StatefulWidget {
  final CodigoItem item;
  const _CodigoFavCard({required this.item});
  @override
  State<_CodigoFavCard> createState() => _CodigoFavCardState();
}

class _CodigoFavCardState extends State<_CodigoFavCard> {
  @override
  Widget build(BuildContext context) {
    final isG = widget.item.isG;
    final cor = isG ? const Color(0xFFBA7517) : kGreen;
    final corBg = isG ? const Color(0xFFFFF3DC) : const Color(0xFFE1F5EE);

    return GestureDetector(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => CodigoDetalheScreen(item: widget.item))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100)),
        child: Row(children: [
          Container(width: 52, height: 52,
            decoration: BoxDecoration(color: corBg, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(widget.item.codigo,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cor)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.item.nome,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 3),
            Text(widget.item.descricao,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          ])),
          GestureDetector(
            onTap: () { favManager.toggleCodigo(widget.item); setState(() {}); },
            child: const Icon(Icons.favorite_rounded, color: kRed, size: 22)),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────
// LISTA DE ALARMES FAVORITOS
// ─────────────────────────────────────────
class _ListaAlarmes extends StatefulWidget {
  @override
  State<_ListaAlarmes> createState() => _ListaAlarmesState();
}

class _ListaAlarmesState extends State<_ListaAlarmes> {
  @override
  void initState() {
    super.initState();
    favManager.addListener(_refresh);
  }
  @override
  void dispose() {
    favManager.removeListener(_refresh);
    super.dispose();
  }
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final todos = [
      ...favManager.alarmesFavoritosFanuc.map((a) => _AlarmeComFab(a, 'FANUC', const Color(0xFF003087))),
      ...favManager.alarmesFavoritosSiemens.map((a) => _AlarmeComFab(a, 'SIEMENS', const Color(0xFF009999))),
      ...favManager.alarmesFavoritosHaas.map((a) => _AlarmeComFab(a, 'HAAS', const Color(0xFF8B0000))),
      ...favManager.alarmesFavoritosMazak.map((a) => _AlarmeComFab(a, 'MAZAK', const Color(0xFF1A5C2A))),
      ...favManager.alarmesFavoritosMitsubishi.map((a) => _AlarmeComFab(a, 'MITSUBISHI', const Color(0xFF8B0057))),
    ];

    if (todos.isEmpty) return _EmptyState(
      icon: Icons.warning_amber_rounded,
      titulo: 'Nenhum alarme favorito',
      subtitulo: 'Toque no ❤ em qualquer alarme na tela de Alarmes para salvar',
    );

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todos.length,
      itemBuilder: (ctx, i) => Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: _AlarmeFavCard(data: todos[i]))),
    );
  }
}

class _AlarmeComFab {
  final AlarmeItem alarme; final String fab; final Color cor;
  const _AlarmeComFab(this.alarme, this.fab, this.cor);
}

class _AlarmeFavCard extends StatefulWidget {
  final _AlarmeComFab data;
  const _AlarmeFavCard({required this.data});
  @override
  State<_AlarmeFavCard> createState() => _AlarmeFavCardState();
}

class _AlarmeFavCardState extends State<_AlarmeFavCard> {
  Color get _gc {
    switch (widget.data.alarme.gravidade) {
      case 'CRÍTICO': return kRed;
      case 'ALTO': return const Color(0xFFBA7517);
      default: return kBlue;
    }
  }
  Color get _gb {
    switch (widget.data.alarme.gravidade) {
      case 'CRÍTICO': return const Color(0xFFFCEBEB);
      case 'ALTO': return const Color(0xFFFFF3DC);
      default: return const Color(0xFFE6F1FB);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) =>
          _AlarmeDetalheFavoritoScreen(item: widget.data.alarme, cor: widget.data.cor))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100)),
        child: Row(children: [
          Container(width: 52, height: 52,
            decoration: BoxDecoration(color: _gb, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(widget.data.alarme.codigo,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: _gc),
              textAlign: TextAlign.center))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: widget.data.cor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4)),
                child: Text(widget.data.fab,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: widget.data.cor))),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: _gb, borderRadius: BorderRadius.circular(4)),
                child: Text(widget.data.alarme.gravidade,
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _gc))),
            ]),
            const SizedBox(height: 4),
            Text(widget.data.alarme.titulo,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(widget.data.alarme.descricao,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          ])),
          GestureDetector(
            onTap: () { favManager.toggleAlarme(widget.data.alarme); setState(() {}); },
            child: const Icon(Icons.favorite_rounded, color: kRed, size: 22)),
        ]),
      ),
    );
  }
}

class _AlarmeDetalheFavoritoScreen extends StatelessWidget {
  final AlarmeItem item;
  final Color cor;
  const _AlarmeDetalheFavoritoScreen({required this.item, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kDark,
        title: Text(item.codigo),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Wrap(spacing: 8, runSpacing: 6, children: [
              _badge(item.gravidade, _gravidadeCor(item.gravidade), _gravidadeBg(item.gravidade)),
              _badge(item.categoria, Colors.grey.shade600, Colors.grey.shade100),
            ]),
            const SizedBox(height: 10),
            Text(item.titulo,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kDark)),
            const SizedBox(height: 16),
            _card('O que significa', Icons.info_outline_rounded, cor,
              Text(item.descricaoCompleta,
                style: const TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF333333)))),
            const SizedBox(height: 12),
            _card('Causas prováveis', Icons.search_rounded, const Color(0xFFBA7517),
              Column(children: item.causas.asMap().entries.map((e) =>
                Padding(padding: const EdgeInsets.only(bottom: 10),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(width: 24, height: 24, margin: const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(color: const Color(0xFFFFF3DC), borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text('${e.key + 1}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFBA7517))))),
                    const SizedBox(width: 10),
                    Expanded(child: Text(e.value,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF444444), height: 1.5))),
                  ]))).toList())),
            const SizedBox(height: 12),
            _card('Como resolver', Icons.build_rounded, kGreen,
              Column(children: item.solucoes.asMap().entries.map((e) =>
                Padding(padding: const EdgeInsets.only(bottom: 10),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(width: 24, height: 24, margin: const EdgeInsets.only(top: 1),
                      decoration: BoxDecoration(color: const Color(0xFFE1F5EE), borderRadius: BorderRadius.circular(12)),
                      child: Center(child: Text('${e.key + 1}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kGreen)))),
                    const SizedBox(width: 10),
                    Expanded(child: Text(e.value,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF444444), height: 1.5))),
                  ]))).toList())),
            if (item.atencao != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity, padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFFCEBEB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: kRed.withValues(alpha: 0.3))),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.warning_amber_rounded, color: kRed, size: 20),
                  const SizedBox(width: 10),
                  Expanded(child: Text(item.atencao!,
                    style: const TextStyle(fontSize: 13, color: kRed, height: 1.5, fontWeight: FontWeight.w500))),
                ])),
            ],
          ]),
        )),
      ),
    );
  }

  Widget _badge(String texto, Color textoCor, Color fundoCor) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(color: fundoCor, borderRadius: BorderRadius.circular(20)),
    child: Text(texto, style: TextStyle(color: textoCor, fontSize: 12, fontWeight: FontWeight.w600)));

  Color _gravidadeCor(String gravidade) {
    switch (gravidade) {
      case 'CRÍTICO': return kRed;
      case 'ALTO': return const Color(0xFFBA7517);
      default: return kBlue;
    }
  }

  Color _gravidadeBg(String gravidade) {
    switch (gravidade) {
      case 'CRÍTICO': return const Color(0xFFFCEBEB);
      case 'ALTO': return const Color(0xFFFFF3DC);
      default: return const Color(0xFFE6F1FB);
    }
  }

  Widget _card(String titulo, IconData icon, Color cardCor, Widget child) => Container(
    width: double.infinity, padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade100)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, size: 15, color: cardCor), const SizedBox(width: 6),
        Text(titulo, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cardCor))]),
      const SizedBox(height: 12), child,
    ]));
}

// ─────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon; final String titulo, subtitulo;
  const _EmptyState({required this.icon, required this.titulo, required this.subtitulo});

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 80, height: 80,
          decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
          child: Icon(icon, size: 36, color: Colors.grey.shade300)),
        const SizedBox(height: 16),
        Text(titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kDark)),
        const SizedBox(height: 8),
        Text(subtitulo, style: TextStyle(fontSize: 13, color: Colors.grey.shade500, height: 1.5),
          textAlign: TextAlign.center),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(10)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.lightbulb_outline_rounded, color: kBlue, size: 16),
            const SizedBox(width: 8),
            Flexible(child: Text('Toque no ❤ em qualquer código ou alarme para salvar aqui',
              style: const TextStyle(fontSize: 12, color: kBlue, height: 1.4))),
          ])),
      ]),
    ));
  }
}
