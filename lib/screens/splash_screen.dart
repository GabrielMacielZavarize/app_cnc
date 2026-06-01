import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _progressCtrl;
  late AnimationController _particleCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _subtitleOpacity;
  late Animation<double> _progress;
  late Animation<double> _particleRotation;

  @override
  void initState() {
    super.initState();

    // Logo
    _logoCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _logoScale   = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _logoCtrl, curve: const Interval(0, 0.5)));

    // Texto
    _textCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _textSlide   = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _subtitleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textCtrl, curve: const Interval(0.4, 1.0)));

    // Progresso
    _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut));

    // Partículas giratórias
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    _particleRotation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_particleCtrl);

    // Sequência de animações
    _logoCtrl.forward().then((_) {
      _textCtrl.forward();
      _progressCtrl.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 300), _goToHome);
      });
    });
  }

  void _goToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ));
  }

  @override
  void dispose() {
    _logoCtrl.dispose(); _textCtrl.dispose();
    _progressCtrl.dispose(); _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kDark,
      body: Stack(children: [

        // FUNDO — grid industrial
        CustomPaint(painter: _GridPainter(), size: size),

        // PARTÍCULAS GIRATÓRIAS
        Center(child: AnimatedBuilder(
          animation: _particleRotation,
          builder: (_, __) => CustomPaint(
            painter: _ParticlePainter(_particleRotation.value),
            size: const Size(300, 300)))),

        // CONTEÚDO CENTRAL
        Center(child: Column(mainAxisSize: MainAxisSize.min, children: [

          // LOGO
          AnimatedBuilder(
            animation: _logoCtrl,
            builder: (_, __) => Opacity(
              opacity: _logoOpacity.value,
              child: Transform.scale(
                scale: _logoScale.value,
                child: _buildLogo()))),

          const SizedBox(height: 32),

          // NOME
          AnimatedBuilder(
            animation: _textCtrl,
            builder: (_, __) => Opacity(
              opacity: _textOpacity.value,
              child: SlideTransition(
                position: _textSlide,
                child: Column(children: [
                  RichText(text: const TextSpan(children: [
                    TextSpan(text: 'CNC',
                      style: TextStyle(color: Colors.white, fontSize: 42,
                        fontWeight: FontWeight.w900, letterSpacing: 4)),
                    TextSpan(text: 'IA',
                      style: TextStyle(color: kAmber, fontSize: 42,
                        fontWeight: FontWeight.w900, letterSpacing: 4)),
                  ])),
                  const SizedBox(height: 6),
                  Opacity(
                    opacity: _subtitleOpacity.value,
                    child: const Text('ASSISTENTE INDUSTRIAL',
                      style: TextStyle(color: Colors.grey, fontSize: 13,
                        letterSpacing: 6, fontWeight: FontWeight.w300))),
                ])))),

          const SizedBox(height: 60),

          // BARRA DE PROGRESSO
          AnimatedBuilder(
            animation: _progress,
            builder: (_, __) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: Column(children: [
                SizedBox(
                  width: 240,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _progress.value,
                      backgroundColor: const Color(0xFF252540),
                      valueColor: const AlwaysStoppedAnimation<Color>(kAmber),
                      minHeight: 3))),
                const SizedBox(height: 12),
                Text(_getLoadingText(_progress.value),
                  style: const TextStyle(color: Colors.grey, fontSize: 11, letterSpacing: 1.5)),
              ])),
          ),
        ])),

        // VERSÃO NO RODAPÉ
        Positioned(bottom: 32, left: 0, right: 0,
          child: AnimatedBuilder(
            animation: _textCtrl,
            builder: (_, __) => Opacity(
              opacity: _subtitleOpacity.value,
              child: Column(children: [
                const Text('v1.0.0', style: TextStyle(color: Color(0xFF444466), fontSize: 11)),
                const SizedBox(height: 4),
                Text('🇧🇷 Feito no Brasil para o mundo',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 11)),
              ])))),
      ]),
    );
  }

  String _getLoadingText(double p) {
    if (p < 0.2) return 'CARREGANDO CÓDIGOS G/M...';
    if (p < 0.4) return 'CARREGANDO ALARMES...';
    if (p < 0.6) return 'CARREGANDO MATERIAIS...';
    if (p < 0.8) return 'CARREGANDO PROGRAMAS...';
    return 'PRONTO!';
  }

  Widget _buildLogo() {
    return Container(
      width: 110, height: 110,
      decoration: BoxDecoration(
        color: kAmber,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: kAmber.withValues(alpha: 0.4), blurRadius: 40, spreadRadius: 5),
          BoxShadow(color: kAmber.withValues(alpha: 0.2), blurRadius: 80, spreadRadius: 10),
        ]),
      child: Stack(alignment: Alignment.center, children: [
        const Icon(Icons.settings, color: Color(0xFF1A1400), size: 64),
        Positioned(right: 16, bottom: 16,
          child: Container(
            width: 24, height: 24,
            decoration: BoxDecoration(
              color: kDark, borderRadius: BorderRadius.circular(6)),
            child: const Center(child: Text('AI',
              style: TextStyle(color: kAmber, fontSize: 8, fontWeight: FontWeight.w900))))),
      ]),
    );
  }
}

// ─────────────────────────────────────────
// PINTORES CUSTOMIZADOS
// ─────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF252540).withValues(alpha: 0.5)
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Círculo decorativo grande
    final circlePaint = Paint()
      ..color = const Color(0xFF252540)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 200, circlePaint);
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 280, circlePaint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _ParticlePainter extends CustomPainter {
  final double rotation;
  _ParticlePainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..style = PaintingStyle.fill;

    // 8 pontos orbitando
    for (int i = 0; i < 8; i++) {
      final angle = rotation + (i * math.pi / 4);
      final radius = 130.0 + (i % 2 == 0 ? 0 : 20);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      final size2 = i % 2 == 0 ? 3.0 : 2.0;
      paint.color = (i % 2 == 0 ? kAmber : Colors.white).withValues(alpha: 0.3 + (i % 3) * 0.15);
      canvas.drawCircle(Offset(x, y), size2, paint);
    }

    // 4 pontos internos (contra-rotação)
    for (int i = 0; i < 4; i++) {
      final angle = -rotation * 0.6 + (i * math.pi / 2);
      const radius = 80.0;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      paint.color = kAmber.withValues(alpha: 0.15);
      canvas.drawCircle(Offset(x, y), 2.0, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.rotation != rotation;
}