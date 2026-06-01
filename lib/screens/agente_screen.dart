import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'biblioteca_screen.dart';
import 'calculadora_screen.dart';

class AgenteScreen extends StatefulWidget {
  const AgenteScreen({super.key});
  @override
  State<AgenteScreen> createState() => _AgenteScreenState();
}

class _Mensagem {
  final String texto;
  final bool deUsuario;
  final DateTime timestamp;
  final List<String> codigos;
  final bool abrirCalculadora;

  _Mensagem({
    required this.texto,
    required this.deUsuario,
    this.codigos = const [],
    this.abrirCalculadora = false,
  }) : timestamp = DateTime.now();
}

class _AgenteScreenState extends State<AgenteScreen> {
  final List<_Mensagem> _mensagens = [];
  bool _carregando = false;
  final _textoCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  final _sugestoes = [
    'Como fazer furo fundo?',
    'Código para rosca M10',
    'Liga refrigeração',
    'Calcular RPM Ø25mm',
    'O que é G41/G42?',
    'Diferença G0 e G1',
    'Como zerar peça',
    'G83 ciclo de furação',
  ];

  @override
  void initState() {
    super.initState();
    _mensagens.add(_Mensagem(
      texto:
          'Olá, operador! Sou seu assistente CNC.\nPode perguntar do jeito que você fala:\n\n'
          '"Como faço furo fundo?"\n'
          '"Qual código pra rosca?"\n'
          '"Calcular RPM Ø25mm"\n\n'
          'Vou entender e te ajudar!',
      deUsuario: false,
    ));
  }

  @override
  void dispose() {
    _textoCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─── Base local offline ───────────────────────────────────────────────────

  _Mensagem? _respostaLocal(String texto) {
    final t = texto.toLowerCase().trim();

    if (t.contains('furo fund') ||
        t.contains('furação profund') ||
        t.contains('ciclo furo') ||
        (t.contains('g83') && t.length < 6)) {
      return _Mensagem(
        texto: 'Para furos profundos use o G83 — ciclo de furação com retorno '
            '(peck drilling):\n\n'
            'G83 X__ Y__ Z__ R__ Q__ F__\n\n'
            '• Z = profundidade final\n'
            '• R = plano de retorno (ex: R2.)\n'
            '• Q = incremento por peck (ex: Q3.)\n'
            '• F = avanço em mm/min\n\n'
            'Exemplo — furo Ø10 a 50 mm:\n'
            'G83 X0. Y0. Z-50. R2. Q5. F80',
        deUsuario: false,
        codigos: ['G83'],
      );
    }

    if (t.contains('rosca') ||
        t.contains('macho') ||
        t.contains('rosquear') ||
        RegExp(r'\bg84\b').hasMatch(t) ||
        RegExp(r'\bg76\b').hasMatch(t) ||
        RegExp(r'\bg92\b').hasMatch(t)) {
      return _Mensagem(
        texto: 'Para rosca você tem 3 opções principais:\n\n'
            '1. G84 — Macho rígido (mais comum):\n'
            '   G84 X__ Y__ Z__ R__ F__ (F = passo)\n'
            '   Ex M10×1.5 → F1.5 com 300 RPM\n\n'
            '2. G76 — Rosca de torno (ciclo completo):\n'
            '   G76 P__ Q__ R__ X__ Z__ F__\n\n'
            '3. G32 — Rosca linha a linha (torno):\n'
            '   G32 Z__ F__\n\n'
            'Fanuc G84 (fresa + macho):\n'
            'G84 X0. Y0. Z-20. R2. F1.5',
        deUsuario: false,
        codigos: ['G84', 'G76', 'G32'],
      );
    }

    if (t.contains('refrig') ||
        t.contains('coolant') ||
        t.contains('liga refrig') ||
        t.contains('desliga refrig') ||
        RegExp(r'\bm0?8\b').hasMatch(t) ||
        RegExp(r'\bm0?9\b').hasMatch(t)) {
      return _Mensagem(
        texto: 'Códigos de refrigeração:\n\n'
            '• M08 — Liga refrigeração (flood coolant)\n'
            '• M09 — Desliga refrigeração\n'
            '• M07 — Liga névoa (mist coolant)\n\n'
            'Use M08 antes do corte e M09 antes do M30.\n\n'
            'Exemplo:\n'
            'T01 M06\n'
            'M08   ← liga refrigeração\n'
            'G0 X0 Y0\n'
            'G1 Z-5. F200\n'
            'M09   ← desliga ao terminar',
        deUsuario: false,
        codigos: ['M08', 'M09', 'M07'],
      );
    }

    if (t.contains('rpm') ||
        t.contains('rotação') ||
        t.contains('rotacao') ||
        t.contains('calcular rpm') ||
        t.contains('velocidade de corte') ||
        (t.contains('calcul') && t.contains('vc'))) {
      return _Mensagem(
        texto: 'Fórmula de RPM:\n\n'
            'N = (Vc × 1000) ÷ (π × D)\n\n'
            '• Vc = velocidade de corte em m/min\n'
            '• D = diâmetro em mm\n\n'
            'Exemplos práticos:\n'
            '• Alumínio Ø12 mm, Vc=300 → 7.960 RPM\n'
            '• Aço Ø25 mm, Vc=150 → 1.910 RPM\n'
            '• Inox Ø20 mm, Vc=80 → 1.270 RPM\n\n'
            'Use a Calculadora do app para calcular com precisão.',
        deUsuario: false,
        abrirCalculadora: true,
      );
    }

    if (t.contains('g41') ||
        t.contains('g42') ||
        (t.contains('compens') && t.contains('raio'))) {
      return _Mensagem(
        texto: 'G41/G42 — Compensação de raio de ferramenta:\n\n'
            '• G41 — Compensação à esquerda (fresar por fora)\n'
            '• G42 — Compensação à direita (fresar por dentro)\n'
            '• G40 — Cancela compensação\n\n'
            'Regras:\n'
            '• Ative G41/G42 em bloco G0 ou G1 de aproximação\n'
            '• Sempre cancele G40 antes do M30\n'
            '• D__ refere ao corretor de raio da ferramenta\n\n'
            'Exemplo:\n'
            'G41 D01\n'
            'G1 X50. F200\n'
            'G40   ← cancela ao sair',
        deUsuario: false,
        codigos: ['G41', 'G42', 'G40'],
      );
    }

    if ((t.contains('diferença') || t.contains('diferenca') || t.contains('o que é') || t.contains('o que e')) &&
        (t.contains('g0') || t.contains('g1') || t.contains('g00') || t.contains('g01'))) {
      return _Mensagem(
        texto: 'Diferença entre G0 e G1:\n\n'
            '• G00 — Movimento rápido:\n'
            '  Velocidade máxima da máquina.\n'
            '  Usado para posicionamento, NÃO corta.\n\n'
            '• G01 — Interpolação linear:\n'
            '  Velocidade controlada pelo F (avanço).\n'
            '  Usado para usinar material.\n\n'
            'Regra de ouro:\n'
            '→ G0: mover no ar (sem contato)\n'
            '→ G1: mover cortando material\n\n'
            'Nunca entre em contato com peça em G0!',
        deUsuario: false,
        codigos: ['G00', 'G01'],
      );
    }

    if (t.contains('zerar') ||
        t.contains('zero peça') ||
        t.contains('zero peca') ||
        t.contains('referenci') ||
        RegExp(r'\bg5[4-9]\b').hasMatch(t)) {
      return _Mensagem(
        texto: 'Zeragem de peça (G54–G59):\n\n'
            'G54 a G59 dizem à máquina onde a peça está.\n\n'
            'Como zerar em Fanuc:\n'
            '1. Posicione a ferramenta na face da peça\n'
            '2. Vá em OFFSET SETTING → Work Coord.\n'
            '3. Cursor em G54 → eixo desejado\n'
            '4. Digite Z0. e pressione MEASURE\n'
            '5. Repita para X e Y\n\n'
            'Dica: Use apalpador para maior precisão.',
        deUsuario: false,
        codigos: ['G54', 'G55'],
      );
    }

    if (t.contains('desgast') ||
        t.contains('ferr gast') ||
        t.contains('troca ferr') ||
        (t.contains('inserto') && t.contains('troc'))) {
      return _Mensagem(
        texto: 'Sinais de desgaste de ferramenta:\n\n'
            '• Acabamento superficial piorando\n'
            '• Ruído ou vibração anormal no corte\n'
            '• Cavaco azul/marrom (calor excessivo)\n'
            '• Carga do spindle aumentando\n'
            '• Dimensão saindo do tolerado\n\n'
            'Quando trocar:\n'
            '→ Ao atingir o limite de vida programado\n'
            '→ Quando os sinais acima aparecerem\n'
            '→ Preventivamente antes de operação crítica',
        deUsuario: false,
      );
    }

    if (t.contains('g83')) {
      return _Mensagem(
        texto: 'G83 — Ciclo de furação profunda (peck drilling):\n\n'
            'Perfura em incrementos (Q), retornando a cada passada '
            'para quebrar cavaco e permitir refrigeração.\n\n'
            'G83 X__ Y__ Z__ R__ Q__ F__\n'
            '• R = plano de retorno\n'
            '• Q = profundidade por incremento\n'
            '• F = avanço\n\n'
            'Use quando: profundidade > 3× o diâmetro da broca.',
        deUsuario: false,
        codigos: ['G83'],
      );
    }

    return null;
  }

  // ─── Servidor local ───────────────────────────────────────────────────────

  Future<_Mensagem?> _chamarServidor(String texto) async {
    try {
      // Monta histórico: pula a saudação inicial (índice 0), limita a 20 msgs
      final inicio = _mensagens.length > 21 ? _mensagens.length - 20 : 1;
      final historico = _mensagens.sublist(inicio).map((m) => {
        'role': m.deUsuario ? 'user' : 'model',
        'text': m.texto,
      }).toList();

      final uri = Uri.parse('http://localhost:8000/gerar-programa');
      final resposta = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'historico': historico}),
      ).timeout(const Duration(seconds: 30));

      if (resposta.statusCode != 200) return null;

      final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
      final textoFinal = (dados['resposta'] as String? ?? '').trim();
      if (textoFinal.isEmpty) return null;

      return _Mensagem(
        texto: textoFinal,
        deUsuario: false,
        codigos: _detectarCodigos(textoFinal),
        abrirCalculadora: _detectarCalculadora(textoFinal),
      );
    } catch (_) {
      return null;
    }
  }

  List<String> _detectarCodigos(String texto) {
    final regex = RegExp(r'\b([GM]\d{1,3})\b');
    return regex
        .allMatches(texto)
        .map((m) => m.group(1)!)
        .toSet()
        .take(4)
        .toList();
  }

  bool _detectarCalculadora(String texto) {
    final t = texto.toLowerCase();
    return t.contains('rpm') ||
        t.contains('vc =') ||
        t.contains('velocidade de corte') ||
        t.contains('calculadora');
  }

  // ─── Enviar ───────────────────────────────────────────────────────────────

  Future<void> _enviar([String? forcado]) async {
    final texto = (forcado ?? _textoCtrl.text).trim();
    if (texto.isEmpty || _carregando) return;
    _textoCtrl.clear();

    setState(() {
      _mensagens.add(_Mensagem(texto: texto, deUsuario: true));
      _carregando = true;
    });
    _scrollToBottom();

    final local = _respostaLocal(texto);
    if (local != null) {
      await Future.delayed(const Duration(milliseconds: 350));
      setState(() {
        _mensagens.add(local);
        _carregando = false;
      });
      _scrollToBottom();
      return;
    }

    final resposta = await _chamarServidor(texto);
    setState(() {
      _mensagens.add(resposta ??
          _Mensagem(
            texto: 'Não foi possível conectar ao servidor. '
                'Verifique se o server.py está rodando na porta 8000.',
            deUsuario: false,
          ));
      _carregando = false;
    });
    _scrollToBottom();
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _mensagens.length <= 1
                ? _buildTelaInicial()
                : _buildChat(),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: kDark,
      padding: const EdgeInsets.fromLTRB(16, 45, 16, 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: kAmber.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.smart_toy_rounded, color: kAmber, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Agente CNC',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700)),
                Text('Pergunte do jeito que você fala',
                    style: TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          if (_mensagens.length > 1)
            IconButton(
              onPressed: _limparChat,
              icon:
                  const Icon(Icons.refresh_rounded, color: Colors.white54, size: 20),
              tooltip: 'Nova conversa',
            ),
        ],
      ),
    );
  }

  void _limparChat() {
    setState(() {
      _mensagens.clear();
      _mensagens.add(_Mensagem(
        texto: 'Nova conversa iniciada. Como posso ajudar?',
        deUsuario: false,
      ));
    });
  }

  Widget _buildTelaInicial() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _buildBolha(_mensagens.first),
              const SizedBox(height: 24),
              const Text('SUGESTÕES',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                      letterSpacing: 1.2)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _sugestoes
                    .map((s) => GestureDetector(
                          onTap: () => _enviar(s),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: kAmber.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bolt_rounded,
                                    size: 13, color: kAmber),
                                const SizedBox(width: 5),
                                Text(s,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF333333))),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChat() {
    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      itemCount: _mensagens.length + (_carregando ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i == _mensagens.length) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: _buildTypingIndicator(),
            ),
          );
        }
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _buildBolha(_mensagens[i]),
          ),
        );
      },
    );
  }

  Widget _buildBolha(_Mensagem msg) {
    if (msg.deUsuario) {
      return Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12, left: 60),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: const BoxDecoration(
            color: kDark,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
          child: Text(msg.texto,
              style: const TextStyle(
                  color: Colors.white, fontSize: 14, height: 1.4)),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: kAmber.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.smart_toy_rounded,
                      color: kAmber, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Text(msg.texto,
                        style: const TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: Color(0xFF1A1A2E))),
                  ),
                ),
              ],
            ),
            if (msg.codigos.isNotEmpty || msg.abrirCalculadora)
              Padding(
                padding: const EdgeInsets.only(left: 38, top: 6),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...msg.codigos.map((c) => _actionChip(
                          icon: Icons.menu_book_rounded,
                          label: 'Ver $c na Biblioteca',
                          color: kBlue,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BibliotecaScreen(initialSearch: c),
                            ),
                          ),
                        )),
                    if (msg.abrirCalculadora)
                      _actionChip(
                        icon: Icons.calculate_rounded,
                        label: 'Abrir Calculadora',
                        color: kGreen,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const CalculadoraScreen()),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _actionChip({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12, left: 38),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: const SizedBox(
          width: 36,
          height: 16,
          child: _TypingDots(),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
          12, 10, 12, MediaQuery.of(context).viewInsets.bottom + 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textoCtrl,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _enviar(),
              decoration: InputDecoration(
                hintText: 'Digite sua pergunta CNC...',
                hintStyle:
                    TextStyle(color: Colors.grey.shade400, fontSize: 13),
                filled: true,
                fillColor: kBg,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: kAmber, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _carregando ? null : _enviar,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _carregando ? Colors.grey.shade300 : kAmber,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _carregando
                    ? Icons.hourglass_top_rounded
                    : Icons.send_rounded,
                color: _carregando ? Colors.grey : kDark,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Typing dots animation ────────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  const _TypingDots();
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (i) {
            final phase = ((_ctrl.value * 3) - i).clamp(0.0, 1.0);
            final opacity =
                (phase < 0.5 ? phase * 2 : (1 - phase) * 2).clamp(0.2, 1.0);
            return Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: kAmber.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
