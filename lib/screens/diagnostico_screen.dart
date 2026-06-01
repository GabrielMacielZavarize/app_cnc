import 'package:flutter/material.dart';

import '../constants.dart';
import '../data/alarmes_extras.dart';
import '../models.dart';
import 'favoritos_screen.dart';

class DiagnosticoScreen extends StatefulWidget {
  const DiagnosticoScreen({super.key});

  @override
  State<DiagnosticoScreen> createState() => _DiagnosticoScreenState();
}

class _DiagnosticoScreenState extends State<DiagnosticoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _busca = '';

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 8, vsync: this);
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
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        Container(
          color: kDark,
          padding: const EdgeInsets.fromLTRB(20, 55, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: kRed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Alarmes CNC',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '7 FABRICANTES - DIAGNOSTICO MUNDIAL',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 9,
                    letterSpacing: 1.5,
                  ),
                ),
              ]),
            ]),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF252540),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Icon(
                  Icons.search,
                  color: _busca.isEmpty ? Colors.grey.shade500 : kAmber,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (v) => setState(() => _busca = v.toLowerCase()),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Buscar codigo ou descricao do alarme...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 10),
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
                Tab(text: 'FANUC'),
                Tab(text: 'SIEMENS'),
                Tab(text: 'HAAS'),
                Tab(text: 'MAZAK'),
                Tab(text: 'MITSUBISHI'),
                Tab(text: 'HEIDENHAIN'),
                Tab(text: 'OKUMA'),
                Tab(text: 'ROMI'),
              ],
            ),
          ]),
        ),
        Expanded(
          child: TabBarView(controller: _tab, children: [
            AlarmesList(
              alarmes: alarmesFanucCompleto,
              busca: _busca,
              cor: const Color(0xFF003087),
              fabricante: 'FANUC',
              descFab: 'Serie 0i, 30i, 31i, 32i - PS/OT/SV/OH',
            ),
            AlarmesList(
              alarmes: alarmesSiemensCompleto,
              busca: _busca,
              cor: const Color(0xFF009999),
              fabricante: 'SIEMENS',
              descFab: 'SINUMERIK 828D, 840D sl',
            ),
            AlarmesList(
              alarmes: alarmesHaasCompleto,
              busca: _busca,
              cor: const Color(0xFF8B0000),
              fabricante: 'HAAS',
              descFab: 'VF, ST, UMC Series',
            ),
            AlarmesList(
              alarmes: alarmesMazak,
              busca: _busca,
              cor: const Color(0xFF1A5C2A),
              fabricante: 'MAZAK',
              descFab: 'Mazatrol SmoothX, Matrix',
            ),
            AlarmesList(
              alarmes: alarmesMitsubishi,
              busca: _busca,
              cor: const Color(0xFF8B0057),
              fabricante: 'MITSUBISHI',
              descFab: 'M70, M80, M800 Series',
            ),
            AlarmesList(
              alarmes: alarmesHeidenhain,
              busca: _busca,
              cor: const Color(0xFF1A237E),
              fabricante: 'HEIDENHAIN',
              descFab: 'TNC 640, TNC 620, iTNC 530',
            ),
            AlarmesList(
              alarmes: alarmesOkumaCompleto,
              busca: _busca,
              cor: const Color(0xFF4A148C),
              fabricante: 'OKUMA',
              descFab: 'OSP-P300, OSP-P200',
            ),
            AlarmesList(
              alarmes: alarmesRomi,
              busca: _busca,
              cor: const Color(0xFF003366),
              fabricante: 'ROMI',
              descFab: 'D600, GL240, Galaxy, I Series',
            ),
          ]),
        ),
      ]),
    );
  }
}

class AlarmesList extends StatelessWidget {
  final List<AlarmeItem> alarmes;
  final String busca;
  final String fabricante;
  final String descFab;
  final Color cor;

  const AlarmesList({
    super.key,
    required this.alarmes,
    required this.busca,
    required this.cor,
    required this.fabricante,
    required this.descFab,
  });

  @override
  Widget build(BuildContext context) {
    final filtrados = busca.isEmpty
        ? alarmes
        : alarmes.where((a) {
            return a.codigo.toLowerCase().contains(busca) ||
                a.titulo.toLowerCase().contains(busca) ||
                a.descricao.toLowerCase().contains(busca) ||
                a.categoria.toLowerCase().contains(busca);
          }).toList();

    return Column(children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: cor.withValues(alpha: 0.08),
          border: Border(
            bottom: BorderSide(color: cor.withValues(alpha: 0.2), width: 1),
          ),
        ),
        child: Row(children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            fabricante,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cor),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '- $descFab',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: cor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${filtrados.length} alarmes',
              style: TextStyle(fontSize: 10, color: cor, fontWeight: FontWeight.w600),
            ),
          ),
        ]),
      ),
      if (filtrados.isEmpty)
        Expanded(
          child: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                busca.isEmpty ? 'Nenhum alarme cadastrado' : 'Sem resultados para "$busca"',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ]),
          ),
        )
      else
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filtrados.length,
            itemBuilder: (ctx, i) => Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: AlarmeCard(item: filtrados[i], cor: cor),
              ),
            ),
          ),
        ),
    ]);
  }
}

class AlarmeCard extends StatefulWidget {
  final AlarmeItem item;
  final Color cor;

  const AlarmeCard({super.key, required this.item, required this.cor});

  @override
  State<AlarmeCard> createState() => _AlarmeCardState();
}

class _AlarmeCardState extends State<AlarmeCard> {
  Color get _gravidadeCor {
    switch (widget.item.gravidade) {
      case 'CRÍTICO':
        return kRed;
      case 'ALTO':
        return const Color(0xFFBA7517);
      default:
        return kBlue;
    }
  }

  Color get _gravidadeBg {
    switch (widget.item.gravidade) {
      case 'CRÍTICO':
        return const Color(0xFFFCEBEB);
      case 'ALTO':
        return const Color(0xFFFFF3DC);
      default:
        return const Color(0xFFE6F1FB);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFav = favManager.isAlarmeFavorito(widget.item.codigo);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AlarmeDetalheScreen(item: widget.item, cor: widget.cor),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isFav ? kRed.withValues(alpha: 0.3) : Colors.grey.shade100,
            width: isFav ? 1.5 : 0.5,
          ),
        ),
        child: Row(children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _gravidadeBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                widget.item.codigo,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _gravidadeCor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                  child: Text(
                    widget.item.titulo,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: _gravidadeBg,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    widget.item.gravidade,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: _gravidadeCor,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 3),
              Text(
                widget.item.descricao,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  widget.item.categoria,
                  style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                ),
              ),
            ]),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              favManager.toggleAlarme(widget.item);
              setState(() {});
            },
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                key: ValueKey(isFav),
                color: isFav ? kRed : Colors.grey.shade300,
                size: 22,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class AlarmeDetalheScreen extends StatefulWidget {
  final AlarmeItem item;
  final Color cor;

  const AlarmeDetalheScreen({super.key, required this.item, required this.cor});

  @override
  State<AlarmeDetalheScreen> createState() => _AlarmeDetalheScreenState();
}

class _AlarmeDetalheScreenState extends State<AlarmeDetalheScreen> {
  @override
  Widget build(BuildContext context) {
    final isFav = favManager.isAlarmeFavorito(widget.item.codigo);

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.item.codigo,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? kRed : Colors.grey,
            ),
            onPressed: () {
              favManager.toggleAlarme(widget.item);
              setState(() {});
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 8, runSpacing: 6, children: [
                _badge(
                  widget.item.gravidade,
                  _gravidadeCor(widget.item.gravidade),
                  _gravidadeBg(widget.item.gravidade),
                ),
                _badge(widget.item.categoria, Colors.grey.shade600, Colors.grey.shade100),
                _badge(_fabricanteLabel(widget.cor), widget.cor, widget.cor.withValues(alpha: 0.1)),
              ]),
              const SizedBox(height: 10),
              Text(
                widget.item.titulo,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kDark),
              ),
              const SizedBox(height: 16),
              _card(
                'O que significa',
                Icons.info_outline_rounded,
                widget.cor,
                Text(
                  widget.item.descricaoCompleta,
                  style: const TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF333333)),
                ),
              ),
              const SizedBox(height: 12),
              _card(
                'Causas provaveis',
                Icons.search_rounded,
                const Color(0xFFBA7517),
                Column(
                  children: widget.item.causas.asMap().entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(top: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF3DC),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${e.key + 1}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFBA7517),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            e.value,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF444444),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ]),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              _card(
                'Como resolver',
                Icons.build_rounded,
                kGreen,
                Column(
                  children: widget.item.solucoes.asMap().entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(top: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1F5EE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              '${e.key + 1}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: kGreen,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            e.value,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF444444),
                              height: 1.5,
                            ),
                          ),
                        ),
                      ]),
                    );
                  }).toList(),
                ),
              ),
              if (widget.item.atencao != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCEBEB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kRed.withValues(alpha: 0.3)),
                  ),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Icon(Icons.warning_amber_rounded, color: kRed, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.item.atencao!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: kRed,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _badge(String texto, Color textoCor, Color fundoCor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: fundoCor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        texto,
        style: TextStyle(color: textoCor, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  String _fabricanteLabel(Color cor) {
    if (cor == const Color(0xFF003087)) return 'FANUC';
    if (cor == const Color(0xFF009999)) return 'SIEMENS';
    if (cor == const Color(0xFF8B0000)) return 'HAAS';
    if (cor == const Color(0xFF1A5C2A)) return 'MAZAK';
    if (cor == const Color(0xFF8B0057)) return 'MITSUBISHI';
    if (cor == const Color(0xFF1A237E)) return 'HEIDENHAIN';
    if (cor == const Color(0xFF4A148C)) return 'OKUMA';
    return 'ROMI';
  }

  Color _gravidadeCor(String gravidade) {
    switch (gravidade) {
      case 'CRÍTICO':
        return kRed;
      case 'ALTO':
        return const Color(0xFFBA7517);
      default:
        return kBlue;
    }
  }

  Color _gravidadeBg(String gravidade) {
    switch (gravidade) {
      case 'CRÍTICO':
        return const Color(0xFFFCEBEB);
      case 'ALTO':
        return const Color(0xFFFFF3DC);
      default:
        return const Color(0xFFE6F1FB);
    }
  }

  Widget _card(String titulo, IconData icon, Color cor, Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, size: 15, color: cor),
          const SizedBox(width: 6),
          Text(
            titulo,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cor),
          ),
        ]),
        const SizedBox(height: 12),
        child,
      ]),
    );
  }
}
