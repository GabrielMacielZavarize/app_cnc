import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import '../constants.dart';
import '../services/idioma_manager.dart';
import 'biblioteca_screen.dart';
import 'calculadora_screen.dart';
import 'diagnostico_screen.dart';
import 'dicionario_screen.dart';
import 'favoritos_screen.dart';
import 'guia_screen.dart';
import 'historico_manager.dart';
import 'agente_screen.dart';
import '../database/cnc_local_db.dart';
import '../views/chips_atalho.dart';
import '../views/resultado_ia_view.dart';
import '../services/api_service.dart';
import 'ia_screen.dart';
import 'programas_screen.dart';
import 'simulador_screen.dart';
import 'tabelas_screen.dart';
import 'checklist_screen.dart';
import 'ordem_producao_screen.dart';
import 'manual_screen.dart';
import 'tolerancias_screen.dart';
import 'acabamento_screen.dart';
import 'vida_ferramenta_screen.dart';
import 'setup_historico_screen.dart';
import '../materias/materiais_screen.dart';

// ─────────────────────────────────────────
// GERENCIADOR DE CONECTIVIDADE
// ─────────────────────────────────────────
class ConectividadeManager {
  static final ConectividadeManager _i = ConectividadeManager._();
  factory ConectividadeManager() => _i;
  ConectividadeManager._();

  bool _online = true;
  bool get online => _online;

  final _listeners = <VoidCallback>[];
  void addListener(VoidCallback l) => _listeners.add(l);
  void removeListener(VoidCallback l) => _listeners.remove(l);
  void _notify() { for (final l in _listeners) l(); }

  Timer? _timer;

  void startChecking() {
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _check());
    _check();
  }

  void stopChecking() => _timer?.cancel();

  Future<void> _check() async {
    // No Flutter Web, sempre considera online
    // A IA vai mostrar erro se realmente não tiver internet
    if (!_online) {
      _online = true;
      _notify();
    }
    try {
      final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 5));
      final novoOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      if (novoOnline != _online) {
        _online = novoOnline;
        _notify();
      }
    } catch (_) {
      // No web, ignora erros de DNS — considera online
      if (!_online) { _online = true; _notify(); }
    }
  }
}

final conectividadeManager = ConectividadeManager();

// ─────────────────────────────────────────
// HOME SCREEN
// ─────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    favManager.addListener(_refresh);
    idiomaManager.addListener(_refresh);
    conectividadeManager.addListener(_refresh);
    conectividadeManager.startChecking();
  }

  @override
  void dispose() {
    favManager.removeListener(_refresh);
    idiomaManager.removeListener(_refresh);
    conectividadeManager.removeListener(_refresh);
    conectividadeManager.stopChecking();
    super.dispose();
  }

  void _refresh() => setState(() {});

  String tr(String k) => idiomaManager.tr(k) ?? k;

  @override
  Widget build(BuildContext context) {
    final totalFav = favManager.totalFavoritos;
    final online = conectividadeManager.online;

    final telas = [
      HomeContent(
        onNavigate: (i) => setState(() => _currentIndex = i),
        online: online,
      ),
      const BibliotecaScreen(),
      const DiagnosticoScreen(),
      const IAScreen(),
      _MaisScreen(online: online),
    ];

    return Scaffold(
      body: Stack(children: [
        IndexedStack(index: _currentIndex, children: telas),
        // BANNER OFFLINE
        if (!online) Positioned(
          top: 0, left: 0, right: 0,
          child: SafeArea(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFBA7517),
              child: Row(children: [
                const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(tr('geral.offline.msg'),
                  style: const TextStyle(color: Colors.white, fontSize: 11))),
              ]),
            ),
          )),
      ]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12, offset: const Offset(0, -2))]),
        child: SafeArea(child: SizedBox(height: 60, child: Row(children: [
          _NavItem(icon: Icons.home_rounded, label: tr('nav.inicio'), index: 0, current: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i)),
          _NavItem(icon: Icons.menu_book_rounded, label: tr('nav.biblioteca'), index: 1, current: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i)),
          _NavItem(icon: Icons.warning_amber_rounded, label: tr('nav.alarmes'), index: 2, current: _currentIndex,
            onTap: (i) => setState(() => _currentIndex = i)),
          // IA com indicador offline
          Expanded(child: GestureDetector(
            onTap: () {
              if (!online) {
                _mostrarAvisoOffline(context);
              } else {
                setState(() => _currentIndex = 3);
              }
            },
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Stack(children: [
                Icon(Icons.camera_alt_rounded,
                  color: _currentIndex == 3 ? kAmber : online ? Colors.grey.shade400 : Colors.grey.shade300,
                  size: 24),
                if (!online) Positioned(right: 0, bottom: 0,
                  child: Container(width: 10, height: 10,
                    decoration: BoxDecoration(color: Colors.grey.shade400,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5)),
                    child: const Icon(Icons.wifi_off, color: Colors.white, size: 6))),
              ]),
              const SizedBox(height: 3),
              Text(tr('nav.ia'), style: TextStyle(fontSize: 10,
                fontWeight: _currentIndex == 3 ? FontWeight.w600 : FontWeight.normal,
                color: _currentIndex == 3 ? kAmber : Colors.grey.shade400)),
            ]),
          )),
          // MAIS
          Expanded(child: GestureDetector(
            onTap: () => setState(() => _currentIndex = 4),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Stack(children: [
                Icon(Icons.grid_view_rounded,
                  color: _currentIndex == 4 ? kAmber : Colors.grey.shade400, size: 24),
                if (totalFav > 0) Positioned(right: 0, top: 0,
                  child: Container(width: 8, height: 8,
                    decoration: const BoxDecoration(color: kRed, shape: BoxShape.circle))),
              ]),
              const SizedBox(height: 3),
              Text(tr('nav.mais'), style: TextStyle(fontSize: 10,
                fontWeight: _currentIndex == 4 ? FontWeight.w600 : FontWeight.normal,
                color: _currentIndex == 4 ? kAmber : Colors.grey.shade400)),
            ]),
          )),
        ]))),
      ),
    );
  }

  void _mostrarAvisoOffline(BuildContext context) {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(children: [
        const Icon(Icons.wifi_off_rounded, color: Color(0xFFBA7517)),
        const SizedBox(width: 10),
        Text(tr('home.offline')),
      ]),
      content: Text('${tr('ia.offline')}\n\n${tr('ia.offline.sub')}'),
      actions: [TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(tr('geral.fechar')))],
    ));
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon; final String label; final int index, current;
  final void Function(int) onTap;
  const _NavItem({required this.icon, required this.label, required this.index,
    required this.current, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final ativo = index == current;
    return Expanded(child: GestureDetector(
      onTap: () => onTap(index),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, color: ativo ? kAmber : Colors.grey.shade400, size: 24),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(fontSize: 10,
          fontWeight: ativo ? FontWeight.w600 : FontWeight.normal,
          color: ativo ? kAmber : Colors.grey.shade400)),
      ]),
    ));
  }
}

// ─────────────────────────────────────────
// TELA "MAIS"
// ─────────────────────────────────────────
class _MaisScreen extends StatefulWidget {
  final bool online;
  const _MaisScreen({required this.online});
  @override
  State<_MaisScreen> createState() => _MaisScreenState();
}

class _MaisScreenState extends State<_MaisScreen> {
  bool get online => widget.online;
  String tr(String k) => idiomaManager.tr(k) ?? k;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        Container(
          color: kDark,
          padding: const EdgeInsets.fromLTRB(20, 55, 20, 20),
          child: Row(children: [
            Container(width: 36, height: 36,
              decoration: BoxDecoration(color: kAmber, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.grid_view_rounded, color: kDark, size: 20)),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(tr('mais.titulo'), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
              const Text('CNCIA', style: TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.5)),
            ]),
            const Spacer(),
            // BOTÃO DE CONFIGURAÇÕES
            GestureDetector(
              onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ConfigScreen())),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF252540), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.settings_rounded, color: Colors.grey, size: 20))),
          ]),
        ),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _labelSecao(tr('mais.ferramentas')),
              const SizedBox(height: 10),
              _ModuloCard(icone: Icons.calculate_rounded, titulo: tr('calc.titulo'),
                subtitulo: '${tr("calc.rpm")}, ${tr("calc.avanco")}, ${tr("calc.potencia")}, ${tr("calc.tempo")}, ${tr("calc.rosca")}',
                cor: kBlue, corBg: const Color(0xFFE6F1FB),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CalculadoraScreen()))),
              _ModuloCard(icone: Icons.layers_rounded, titulo: tr('mat.titulo'),
                subtitulo: '30 ${tr("mod.materiais.sub")} — ${tr("mat.fresamento")}, ${tr("mat.torneamento")}, ${tr("mat.furacao")}',
                cor: const Color(0xFF993C1D), corBg: const Color(0xFFFAECE7),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MateriaisScreen()))),
              _ModuloCard(icone: Icons.table_chart_rounded, titulo: tr('tab.titulo'),
                subtitulo: tr('mod.tabelas.sub'),
                cor: const Color(0xFF0F6E56), corBg: const Color(0xFFE1F5EE),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TabelasScreen()))),
              _ModuloCard(icone: Icons.checklist_rounded, titulo: 'Checklist do Operador',
                subtitulo: '28 passos — pré-partida, setup, operação e fim de turno',
                cor: const Color(0xFF2E7D32), corBg: const Color(0xFFE8F5E9),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChecklistScreen()))),
              _ModuloCard(icone: Icons.assignment_rounded, titulo: 'Ordens de Produção',
                subtitulo: 'Controle de peças, ciclos, rejeições e eficiência por turno',
                cor: const Color(0xFF1565C0), corBg: const Color(0xFFE3F2FD),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdemProducaoScreen()))),
              _ModuloCard(icone: Icons.auto_stories_rounded, titulo: 'Manual Ilustrado',
                subtitulo: 'G02/G03, ciclos de furação, G41/G42, coord. e parâmetros de corte',
                cor: const Color(0xFF7B2FBE), corBg: const Color(0xFFF3E5F5),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManualScreen()))),
              _ModuloCard(icone: Icons.tune_rounded, titulo: 'Tolerâncias ISO',
                subtitulo: 'Calculadora H7/h6, limites µm, ajustes comuns e tabela IT',
                cor: const Color(0xFF00695C), corBg: const Color(0xFFE0F2F1),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TolerenciasScreen()))),
              _ModuloCard(icone: Icons.texture_rounded, titulo: 'Acabamento Superficial',
                subtitulo: 'Ra/Rz, graus N1–N12, por processo, tabela completa',
                cor: const Color(0xFF4527A0), corBg: const Color(0xFFEDE7F6),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AcabamentoScreen()))),
              _ModuloCard(icone: Icons.precision_manufacturing_rounded, titulo: 'Vida da Ferramenta',
                subtitulo: 'Contador por ferramenta, alerta de troca, histórico de uso',
                cor: const Color(0xFFC62828), corBg: const Color(0xFFFFEBEE),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VidaFerramentaScreen()))),
              _ModuloCard(icone: Icons.history_edu_rounded, titulo: 'Histórico de Setup',
                subtitulo: 'Offsets G54–G59, ferramentas, observações por máquina e peça',
                cor: const Color(0xFF01579B), corBg: const Color(0xFFE3F2FD),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SetupHistoricoScreen()))),
              const SizedBox(height: 20),
              _labelSecao(tr('mais.programacao')),
              const SizedBox(height: 10),
              _ModuloCard(icone: Icons.code_rounded, titulo: tr('prog.titulo'),
                subtitulo: tr('mod.programas.sub'),
                cor: const Color(0xFF2E7D32), corBg: const Color(0xFFE8F5E9),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgramasScreen()))),
              _ModuloCard(icone: Icons.lightbulb_rounded, titulo: tr('guia.titulo'),
                subtitulo: tr('mod.guia.sub'),
                cor: kAmber, corBg: const Color(0xFFFFF3DC),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GuiaScreen()))),
              _ModuloCard(icone: Icons.terminal_rounded, titulo: 'Simulador CNC',
                subtitulo: 'Digite um bloco e entenda o que faz',
                cor: const Color(0xFF534AB7), corBg: const Color(0xFFF0EEFF),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SimuladorScreen()))),
              _ModuloCard(icone: Icons.translate_rounded, titulo: 'Dicionário Técnico',
                subtitulo: '60+ termos em PT 🇧🇷 EN 🇺🇸 ES 🇪🇸',
                cor: kGreen, corBg: const Color(0xFFE1F5EE),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DicionarioScreen()))),
              const SizedBox(height: 20),
              _labelSecao(tr('mais.pessoal')),
              const SizedBox(height: 10),
              _ModuloCard(icone: Icons.favorite_rounded, titulo: tr('mod.favoritos'),
                subtitulo: '${favManager.totalFavoritos} ${tr("mod.favoritos.sub")}',
                cor: kRed, corBg: const Color(0xFFFCEBEB),
                badge: favManager.totalFavoritos > 0 ? '${favManager.totalFavoritos}' : null,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritosScreen()))),
              _ModuloCard(icone: Icons.history_rounded, titulo: 'Histórico & Notas',
                subtitulo: 'Consultas e notas pessoais',
                cor: kBlue, corBg: const Color(0xFFE6F1FB),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HistoricoScreen()))),
              const SizedBox(height: 20),
              // INFO DO APP
              Container(
                width: double.infinity, padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(14)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(width: 40, height: 40,
                      decoration: BoxDecoration(color: kAmber, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.settings, color: kDark, size: 22)),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('CNCIA', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                      Text(tr('app.subtitulo'), style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ]),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: online ? const Color(0xFF0F6E56).withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8)),
                      child: Row(children: [
                        Icon(online ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                          color: online ? kGreen : Colors.grey, size: 12),
                        const SizedBox(width: 4),
                        Text(online ? idiomaManager.tr('home.online')! : idiomaManager.tr('home.offline')!,
                          style: TextStyle(color: online ? kGreen : Colors.grey, fontSize: 10)),
                      ])),
                  ]),
                  const SizedBox(height: 14),
                  const Divider(color: Color(0xFF252540)),
                  const SizedBox(height: 10),
                  _infoRow(Icons.menu_book_rounded, '80+ ${tr("mod.biblioteca.sub")}'),
                  _infoRow(Icons.warning_amber_rounded, '7 ${tr("mod.alarmes.sub")}'),
                  _infoRow(Icons.layers_rounded, '30 ${tr("mod.materiais.sub")}'),
                  _infoRow(Icons.code_rounded, '8 ${tr("prog.subtitulo").toLowerCase()}'),
                  _infoRow(Icons.lightbulb_rounded, '11 ${tr("guia.subtitulo").toLowerCase()}'),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: kAmber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8)),
                    child: Text(tr('config.feito'),
                      style: const TextStyle(color: kAmber, fontSize: 12, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center)),
                ]),
              ),
              const SizedBox(height: 20),
            ]),
          )),
        )),
      ]),
    );
  }

  Widget _labelSecao(String t) => Text(t,
    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1.2));

  Widget _infoRow(IconData icon, String desc) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      Icon(icon, size: 13, color: kAmber),
      const SizedBox(width: 8),
      Expanded(child: Text(desc, style: const TextStyle(color: Colors.grey, fontSize: 11))),
    ]));
}

class _ModuloCard extends StatelessWidget {
  final IconData icone; final String titulo, subtitulo;
  final Color cor, corBg; final VoidCallback onTap; final String? badge;
  const _ModuloCard({required this.icone, required this.titulo, required this.subtitulo,
    required this.cor, required this.corBg, required this.onTap, this.badge});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100)),
      child: Row(children: [
        Container(width: 46, height: 46,
          decoration: BoxDecoration(color: corBg, borderRadius: BorderRadius.circular(10)),
          child: Icon(icone, color: cor, size: 22)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 3),
          Text(subtitulo, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ])),
        if (badge != null)
          Container(margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: kRed, borderRadius: BorderRadius.circular(12)),
            child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
        Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300, size: 20),
      ]),
    ));
}

// ─────────────────────────────────────────
// BARRA DE PESQUISA INTELIGENTE
// ─────────────────────────────────────────
class BarraPesquisaInteligente extends StatefulWidget {
  final void Function(int) aoMudarAba;
  final TextEditingController? controller;
  final void Function(String)? onSubmit;
  const BarraPesquisaInteligente({super.key, required this.aoMudarAba, this.controller, this.onSubmit});

  @override
  State<BarraPesquisaInteligente> createState() =>
      _BarraPesquisaInteligenteState();
}

class _BarraPesquisaInteligenteState extends State<BarraPesquisaInteligente> {
  late final TextEditingController _controller;
  bool _ownsController = false;
  List<ItemBuscaOffline> _sugestoes = [];
  bool _mostrarDropdown = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
    _controller.addListener(_filtrarResultados);
  }

  @override
  void dispose() {
    _controller.removeListener(_filtrarResultados);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _filtrarResultados() {
    final texto = _controller.text.trim().toLowerCase();
    if (texto.isEmpty) {
      setState(() {
        _sugestoes = [];
        _mostrarDropdown = false;
      });
      return;
    }
    final resultados = CncLocalDb.dadosOffline
        .where((item) =>
            item.termo.toLowerCase().contains(texto) ||
            item.titulo.toLowerCase().contains(texto) ||
            item.descricao.toLowerCase().contains(texto))
        .take(6)
        .toList();
    setState(() {
      _sugestoes = resultados;
      _mostrarDropdown = true;
    });
  }

  IconData _obterIcone(String categoria) {
    switch (categoria) {
      case 'ciclo':      return Icons.sync_rounded;
      case 'codigo':     return Icons.code_rounded;
      case 'ferramenta': return Icons.build_rounded;
      case 'alarme':     return Icons.warning_amber_rounded;
      default:           return Icons.help_outline_rounded;
    }
  }

  Color _obterCor(String categoria) {
    switch (categoria) {
      case 'ciclo':      return kGreen;
      case 'codigo':     return kBlue;
      case 'ferramenta': return kAmber;
      case 'alarme':     return kRed;
      default:           return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Campo de pesquisa ──────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)
            ],
          ),
          child: TextField(
            controller: _controller,
            onSubmitted: (v) {
              final t = v.trim();
              if (t.isNotEmpty) widget.onSubmit?.call(t);
            },
            decoration: InputDecoration(
              hintText: 'Buscar ciclos, códigos, ferramentas...',
              hintStyle:
                  TextStyle(color: Colors.grey.shade400, fontSize: 13),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              icon: Icon(Icons.search_rounded,
                  color: Colors.grey.shade400, size: 18),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.close_rounded,
                          size: 16, color: Colors.grey.shade400),
                      onPressed: _controller.clear,
                    )
                  : null,
            ),
          ),
        ),

        // ── Dropdown de resultados ─────────────────────────────────────────
        if (_mostrarDropdown && _sugestoes.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 350),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4))
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _sugestoes.length,
              separatorBuilder: (_, __) =>
                  Divider(height: 1, color: Colors.grey.shade100),
              itemBuilder: (ctx, i) {
                final item = _sugestoes[i];
                final cor = _obterCor(item.categoria);
                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: cor.withValues(alpha: 0.12),
                    child: Icon(_obterIcone(item.categoria),
                        color: cor, size: 18),
                  ),
                  title: Text(
                    '${item.termo} — ${item.titulo}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  subtitle: Text(
                    item.descricao,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 11),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: cor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      item.categoria.toUpperCase(),
                      style: TextStyle(
                          color: cor,
                          fontSize: 9,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  onTap: () {
                    _controller.clear();
                    FocusScope.of(context).unfocus();
                    widget.aoMudarAba(1);
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────
// HOME CONTENT
// ─────────────────────────────────────────
class HomeContent extends StatefulWidget {
  final void Function(int) onNavigate;
  final bool online;
  const HomeContent({super.key, required this.onNavigate, required this.online});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _buscaCtrl = TextEditingController();

  void Function(int) get _onNavigate => widget.onNavigate;
  bool get _online => widget.online;
  String tr(String k) => idiomaManager.tr(k) ?? k;

  @override
  void dispose() {
    _buscaCtrl.dispose();
    super.dispose();
  }

  Future<void> _dispararConsultaIa(String texto) async {
    final t = texto.trim();
    if (t.isEmpty) return;
    FocusScope.of(context).unfocus();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: kAmber),
      ),
    );

    final resultado = await ApiService().enviarDadosPeca(
      materialBruto: '',
      dimensoesFinais: '',
      comandoMaquina: t,
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (resultado['sucesso'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultadoIaView(dadosIa: resultado),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(resultado['erro'] ?? 'Erro ao contatar o servidor.'),
        backgroundColor: kRed,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        _buildHeader(context),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildSearchBar(context),
              ChipsAtalho(aoSelecionarSugestao: (t) {
                _buscaCtrl.text = t;
                _dispararConsultaIa(t);
              }),
              const SizedBox(height: 20),
              _label(tr('home.acessorapido')),
              const SizedBox(height: 10),
              _buildGrid(context),
              const SizedBox(height: 20),
              _buildIACard(context),
              const SizedBox(height: 10),
              _buildAgenteCard(context),
              const SizedBox(height: 20),
              _buildGuiaCard(context),
              const SizedBox(height: 20),
              _label(tr('home.recentes')),
              const SizedBox(height: 10),
              _buildRecentes(),
              const SizedBox(height: 20),
            ]),
          )),
        )),
      ]),
    );
  }

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
          letterSpacing: 1.2));

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: kDark,
      padding: const EdgeInsets.fromLTRB(20, 55, 20, 16),
      child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Container(width: 36, height: 36,
                decoration: BoxDecoration(color: kAmber, borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.settings, color: kDark, size: 20)),
              const SizedBox(width: 10),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                RichText(text: const TextSpan(children: [
                  TextSpan(text: 'CNC', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                  TextSpan(text: 'IA', style: TextStyle(color: kAmber, fontSize: 17, fontWeight: FontWeight.w700)),
                ])),
                Text(tr('app.slogan'), style: const TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.2)),
              ]),
            ]),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: const Color(0xFF252540), borderRadius: BorderRadius.circular(20)),
              child: Row(children: [
                Icon(_online ? Icons.circle : Icons.wifi_off_rounded,
                    color: _online ? const Color(0xFF4CAF50) : Colors.grey, size: 8),
                const SizedBox(width: 6),
                Text(_online ? tr('home.online') : tr('home.offline'),
                    style: const TextStyle(color: Colors.white, fontSize: 11)),
              ]),
            ),
          ]),
          const SizedBox(height: 14),
          Text(tr('home.bemvindo'), style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 2),
          Text(tr('home.operador'), style: const TextStyle(color: kAmber, fontSize: 20, fontWeight: FontWeight.w500)),
        ]),
      )),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return BarraPesquisaInteligente(
      aoMudarAba: _onNavigate,
      controller: _buscaCtrl,
      onSubmit: _dispararConsultaIa,
    );
  }

  Widget _buildGrid(BuildContext context) {
    final mods = [
      _Mod(tr('mod.biblioteca'), tr('mod.biblioteca.sub'),
          Icons.menu_book_rounded, const Color(0xFFFFF3DC),
          const Color(0xFFBA7517), 1, null),
      _Mod(tr('mod.alarmes'), tr('mod.alarmes.sub'),
          Icons.warning_amber_rounded, const Color(0xFFFCEBEB), kRed, 2, null),
      _Mod(tr('mod.calculadora'), tr('mod.calculadora.sub'),
          Icons.calculate_rounded, const Color(0xFFE6F1FB), kBlue, -1, null),
      _Mod(tr('mod.materiais'), tr('mod.materiais.sub'), Icons.layers_rounded,
          const Color(0xFFFAECE7), const Color(0xFF993C1D), -2, null),
    ];
    return Column(children: [
      Row(children: [
        Expanded(child: _ModCardHome(m: mods[0], onNav: _onNavigate, ctx: context)),
        const SizedBox(width: 10),
        Expanded(child: _ModCardHome(m: mods[1], onNav: _onNavigate, ctx: context)),
      ]),
      const SizedBox(height: 10),
      Row(children: [
        Expanded(child: _ModCardHome(m: mods[2], onNav: _onNavigate, ctx: context)),
        const SizedBox(width: 10),
        Expanded(child: _ModCardHome(m: mods[3], onNav: _onNavigate, ctx: context)),
      ]),
    ]);
  }

  Widget _buildIACard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!_online) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    title: Row(children: [
                      const Icon(Icons.wifi_off_rounded,
                          color: Color(0xFFBA7517)),
                      const SizedBox(width: 10),
                      Text(tr('home.offline')),
                    ]),
                    content: Text(
                        '${tr("ia.offline")}\n\n${tr("ia.offline.sub")}'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'))
                    ],
                  ));
        } else {
          _onNavigate(3);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration:
            BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                  color: _online ? kAmber : Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(12)),
              child: Icon(
                  _online ? Icons.camera_alt_rounded : Icons.wifi_off_rounded,
                  color: Colors.white,
                  size: 28)),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(tr('home.analisaria'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(
                    _online
                        ? tr('home.analisaria.sub')
                        : tr('ia.offline'),
                    style:
                        const TextStyle(color: Colors.grey, fontSize: 12)),
              ])),
          Icon(Icons.chevron_right,
              color: _online ? kAmber : Colors.grey, size: 24),
        ]),
      ),
    );
  }

  Widget _buildAgenteCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AgenteScreen())),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kBlue.withValues(alpha: 0.25))),
        child: Row(children: [
          Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                  color: const Color(0xFFE6F1FB),
                  borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.smart_toy_rounded,
                  color: kBlue, size: 24)),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Agente CNC',
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  SizedBox(height: 2),
                  Text('Pergunte do jeito que você fala — offline + IA',
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                ]),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: kBlue, borderRadius: BorderRadius.circular(8)),
            child: const Text('NOVO',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w800)),
          ),
        ]),
      ),
    );
  }

  Widget _buildGuiaCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const GuiaScreen())),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: kAmber.withValues(alpha: 0.3))),
        child: Row(children: [
          Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                  color: const Color(0xFFFFF3DC),
                  borderRadius: BorderRadius.circular(10)),
              child:
                  const Icon(Icons.lightbulb_rounded, color: kAmber, size: 24)),
          const SizedBox(width: 14),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(tr('home.guia'),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(tr('home.guia.sub'),
                    style: TextStyle(
                        fontSize: 11, color: Colors.grey.shade500)),
              ])),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
                color: kAmber, borderRadius: BorderRadius.circular(8)),
            child: Text(tr('home.novo'),
                style: const TextStyle(
                    color: kDark,
                    fontSize: 10,
                    fontWeight: FontWeight.w800))),
        ]),
      ),
    );
  }

  Widget _buildRecentes() {
    return Column(children: [
      _RecentItem(
          label: 'G84 — ${tr("calc.rosca")} M10×1.5 a 300 RPM',
          tag: tr('cod.codigoG'),
          color: kAmber),
      _RecentItem(
          label: 'AL.410 Fanuc — Servo speed error',
          tag: tr('nav.alarmes'),
          color: kRed),
      _RecentItem(
          label: 'Inox 304 — Vc: 80-150 m/min',
          tag: tr('mod.materiais'),
          color: kGreen),
      _RecentItem(
          label: '${tr("calc.rpm")} Alumínio Ø12mm → 10610',
          tag: tr('calc.titulo'),
          color: kBlue),
    ]);
  }
}

class _Mod {
  final String title, desc; final IconData icon; final Color bg, color;
  final int nav; final String? badge;
  const _Mod(this.title, this.desc, this.icon, this.bg, this.color, this.nav, this.badge);
}

class _ModCardHome extends StatelessWidget {
  final _Mod m; final void Function(int) onNav; final BuildContext ctx;
  const _ModCardHome({super.key, required this.m, required this.onNav, required this.ctx});
  @override
  Widget build(BuildContext _) => GestureDetector(
    onTap: () {
      if (m.nav >= 0) { onNav(m.nav); }
      else if (m.nav == -1) { Navigator.push(ctx, MaterialPageRoute(builder: (_) => const CalculadoraScreen())); }
      else { Navigator.push(ctx, MaterialPageRoute(builder: (_) => MateriaisScreen())); }
    },
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 38, height: 38,
          decoration: BoxDecoration(color: m.bg, borderRadius: BorderRadius.circular(8)),
          child: Icon(m.icon, color: m.color, size: 20)),
        const SizedBox(height: 10),
        Text(m.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(m.desc, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ]),
    ));
}

class _RecentItem extends StatelessWidget {
  final String label, tag; final Color color;
  const _RecentItem({super.key, required this.label, required this.tag, required this.color});
  @override
  Widget build(BuildContext _) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade100)),
    child: Row(children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
      Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(5)),
        child: Text(tag, style: TextStyle(fontSize: 10, color: Colors.grey.shade500))),
    ]));
}

// ─────────────────────────────────────────
// TELA DE CONFIGURAÇÕES
// ─────────────────────────────────────────
class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});
  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  String tr(String k) => idiomaManager.tr(k) ?? k;

  @override
  void initState() {
    super.initState();
    idiomaManager.addListener(_refresh);
  }

  @override
  void dispose() {
    idiomaManager.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kDark,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text(tr('config.titulo'),
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // SEÇÃO IDIOMA
            _secaoTitulo(tr('config.idioma'), Icons.language_rounded, kBlue),
            const SizedBox(height: 10),

            _IdiomaCard(
              flag: '🇧🇷', nome: tr('config.pt'),
              idioma: AppIdioma.pt,
              ativo: idiomaManager.idioma == AppIdioma.pt,
              onTap: () { idiomaManager.setIdioma(AppIdioma.pt); setState(() {}); }),

            _IdiomaCard(
              flag: '🇺🇸', nome: tr('config.en'),
              idioma: AppIdioma.en,
              ativo: idiomaManager.idioma == AppIdioma.en,
              onTap: () { idiomaManager.setIdioma(AppIdioma.en); setState(() {}); }),

            _IdiomaCard(
              flag: '🇪🇸', nome: tr('config.es'),
              idioma: AppIdioma.es,
              ativo: idiomaManager.idioma == AppIdioma.es,
              onTap: () { idiomaManager.setIdioma(AppIdioma.es); setState(() {}); }),

            const SizedBox(height: 24),

            // SOBRE O APP
            _secaoTitulo(tr('config.sobre'), Icons.info_outline_rounded, kGreen),
            const SizedBox(height: 10),

            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 48, height: 48,
                    decoration: BoxDecoration(color: kAmber, borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.settings, color: kDark, size: 26)),
                  const SizedBox(width: 14),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('CNCIA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kDark)),
                    Text(tr('app.subtitulo'), style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ]),
                ]),
                const SizedBox(height: 14),
                const Divider(),
                const SizedBox(height: 10),
                _sobreRow(tr('config.versao'), '1.0.0'),
                _sobreRow('Plataforma', 'Flutter / Android'),
                _sobreRow(tr('mod.biblioteca'), '80+ códigos G/M'),
                _sobreRow(tr('mod.alarmes'), '7 fabricantes'),
                _sobreRow(tr('mod.materiais'), '30 materiais'),
                _sobreRow(tr('mod.programas'), '8 programas'),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kAmber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8)),
                  child: Text(tr('config.feito'),
                    style: const TextStyle(color: kAmber, fontSize: 12, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center)),
              ]),
            ),
            const SizedBox(height: 20),
          ]),
        )),
      ),
    );
  }

  Widget _secaoTitulo(String t, IconData icon, Color cor) => Row(children: [
    Icon(icon, size: 16, color: cor), const SizedBox(width: 8),
    Text(t, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: cor)),
  ]);

  Widget _sobreRow(String label, String valor) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
      Text(valor, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kDark)),
    ]));
}

class _IdiomaCard extends StatelessWidget {
  final String flag, nome; final AppIdioma idioma;
  final bool ativo; final VoidCallback onTap;
  const _IdiomaCard({required this.flag, required this.nome, required this.idioma,
    required this.ativo, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ativo ? kDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ativo ? kAmber : Colors.grey.shade100,
          width: ativo ? 1.5 : 0.5)),
      child: Row(children: [
        Text(flag, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 14),
        Expanded(child: Text(nome, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,
          color: ativo ? Colors.white : kDark))),
        if (ativo) Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: kAmber, borderRadius: BorderRadius.circular(8)),
          child: Text(idiomaManager.tr('config.ativo')!,
            style: const TextStyle(color: kDark, fontSize: 10, fontWeight: FontWeight.w800))),
      ]),
    ));
}