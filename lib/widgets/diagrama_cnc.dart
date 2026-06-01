import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../constants.dart';

// ═══════════════════════════════════════════════════════════════
// WIDGET DE DIAGRAMA CNC — Visual tipo manual técnico
// Renderizado com CustomPainter — sem imagens externas, 100% offline
// ═══════════════════════════════════════════════════════════════
class DiagramaCNC extends StatelessWidget {
  final String tipo;
  final double size;

  const DiagramaCNC({super.key, required this.tipo, this.size = 180});

  @override
  Widget build(BuildContext context) {
    final painter = _getPainter(tipo);
    if (painter == null) return const SizedBox.shrink();

    return Container(
      width: size,
      height: size * 0.7,
      decoration: BoxDecoration(
        color: kDark,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kAmber.withValues(alpha: 0.3))),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CustomPaint(painter: painter, size: Size(size, size * 0.7))),
    );
  }

  CustomPainter? _getPainter(String tipo) {
    switch (tipo) {
      case 'rapido':          return _RapidoPainter();
      case 'linear':          return _LinearPainter();
      case 'circular_cw':     return _CircularCWPainter();
      case 'circular_ccw':    return _CircularCCWPainter();
      case 'furar':           return _FurarPainter();
      case 'spindle_cw':      return _SpindleCWPainter();
      case 'spindle_ccw':     return _SpindleCCWPainter();
      case 'spindle_pos':     return _SpindlePosPainter();
      case 'refrigeracao':    return _RefrigeracaoPainter();
      case 'alta_pressao':    return _AltaPressaoPainter();
      case 'air_blow':        return _AirBlowPainter();
      case 'troca_ferramenta':return _TrocaFerramentaPainter();
      case 'chuck':           return _ChuckPainter();
      case 'contraponta':     return _ContrapontaPainter();
      case 'rosca':           return _RoscaPainter();
      case 'espelhamento':    return _EspelhamentoPainter();
      case 'medicao':         return _MedicaoPainter();
      case 'referencia':      return _ReferenciaPainter();
      case 'chip_conveyor':   return _ChipConveyorPainter();
      case 'fixador':         return _FixadorPainter();
      case 'porta':           return _PortaPainter();
      case 'trava_eixo':      return _TravaEixoPainter();
      default: return null;
    }
  }
}

// ── Helpers comuns ─────────────────────────────────────────────
Paint _paintAmber({double width = 2, bool fill = false}) => Paint()
  ..color = kAmber
  ..strokeWidth = width
  ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
  ..strokeCap = StrokeCap.round;

Paint _paintWhite({double width = 1.5, bool fill = false}) => Paint()
  ..color = Colors.white
  ..strokeWidth = width
  ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
  ..strokeCap = StrokeCap.round;

Paint _paintGreen({double width = 2, bool fill = false}) => Paint()
  ..color = kGreen
  ..strokeWidth = width
  ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
  ..strokeCap = StrokeCap.round;

Paint _paintRed({double width = 2}) => Paint()
  ..color = kRed
  ..strokeWidth = width
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round;

Paint _paintGrey({double width = 1}) => Paint()
  ..color = Colors.grey.shade700
  ..strokeWidth = width
  ..style = PaintingStyle.stroke;

void _drawArrow(Canvas c, Offset from, Offset to, Paint p) {
  c.drawLine(from, to, p);
  final angle = math.atan2(to.dy - from.dy, to.dx - from.dx);
  final size  = 8.0;
  c.drawLine(to, to - Offset(math.cos(angle - 0.5) * size, math.sin(angle - 0.5) * size), p);
  c.drawLine(to, to - Offset(math.cos(angle + 0.5) * size, math.sin(angle + 0.5) * size), p);
}

void _drawLabel(Canvas c, String text, Offset pos, Color color, {double fontSize = 10}) {
  final tp = TextPainter(
    text: TextSpan(text: text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w600)),
    textDirection: TextDirection.ltr)..layout();
  tp.paint(c, pos);
}

// ── G00 — Movimento Rápido ─────────────────────────────────────
class _RapidoPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final pDash = _paintAmber(width: 2)..shader = null;
    pDash.color = kAmber;
    // Grade de eixos
    c.drawLine(Offset(30, s.height - 20), Offset(s.width - 20, s.height - 20), _paintGrey());
    c.drawLine(Offset(30, 15), Offset(30, s.height - 20), _paintGrey());
    _drawLabel(c, 'X', Offset(s.width - 18, s.height - 20), Colors.grey.shade500);
    _drawLabel(c, 'Z', Offset(22, 8), Colors.grey.shade500);

    // Trajetória rápida (tracejada amarela)
    final path = Path()..moveTo(50, s.height - 40)..lineTo(s.width - 40, 30);
    final dashPaint = _paintAmber(width: 2);
    _drawDashedPath(c, path, dashPaint);
    _drawArrow(c, Offset(s.width - 65, 52), Offset(s.width - 40, 30), _paintAmber(width: 2.5));
    _drawLabel(c, 'G00', Offset(s.width / 2 - 10, s.height / 2 - 24), kAmber, fontSize: 12);
    _drawLabel(c, 'RÁPIDO', Offset(s.width / 2 - 18, s.height / 2 - 10), Colors.grey.shade400, fontSize: 9);

    // Pontos de início/fim
    c.drawCircle(Offset(50, s.height - 40), 5, _paintAmber(fill: true));
    c.drawCircle(Offset(s.width - 40, 30), 5, _paintWhite(fill: true));
  }

  @override bool shouldRepaint(_) => false;
}

// ── G01 — Interpolação Linear ─────────────────────────────────
class _LinearPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    c.drawLine(Offset(30, s.height - 20), Offset(s.width - 20, s.height - 20), _paintGrey());
    c.drawLine(Offset(30, 15), Offset(30, s.height - 20), _paintGrey());
    _drawLabel(c, 'X', Offset(s.width - 18, s.height - 20), Colors.grey.shade500);
    _drawLabel(c, 'Z', Offset(22, 8), Colors.grey.shade500);

    _drawArrow(c, Offset(50, s.height - 40), Offset(s.width - 40, 30), _paintGreen(width: 2.5));
    _drawLabel(c, 'G01', Offset(s.width / 2 - 10, s.height / 2 - 24), kGreen, fontSize: 12);
    _drawLabel(c, 'F = avanço', Offset(s.width / 2 - 22, s.height / 2 - 10), Colors.grey.shade400, fontSize: 9);

    c.drawCircle(Offset(50, s.height - 40), 5, _paintGreen(fill: true));
    c.drawCircle(Offset(s.width - 40, 30), 5, _paintWhite(fill: true));
  }

  @override bool shouldRepaint(_) => false;
}

// ── G02 — Circular CW ─────────────────────────────────────────
class _CircularCWPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final r = math.min(s.width, s.height) * 0.35;

    c.drawLine(Offset(20, s.height - 20), Offset(s.width - 10, s.height - 20), _paintGrey());
    c.drawLine(Offset(20, 10), Offset(20, s.height - 20), _paintGrey());

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    c.drawArc(rect, -math.pi / 2, math.pi * 1.5, false, _paintAmber(width: 2.5));

    // Seta no sentido horário
    final arrowX = cx + r * math.cos(math.pi);
    final arrowY = cy + r * math.sin(math.pi);
    _drawArrow(c, Offset(arrowX, arrowY - 8), Offset(arrowX, arrowY + 8), _paintAmber(width: 2));

    _drawLabel(c, 'G02', Offset(cx - 14, cy - 8), kAmber, fontSize: 13);
    _drawLabel(c, 'CW', Offset(cx - 8, cy + 4), Colors.grey.shade400, fontSize: 10);
    c.drawCircle(Offset(cx, cy), 2, _paintGrey(width: 1));

    c.drawCircle(Offset(cx, cy - r), 5, _paintAmber(fill: true));
    c.drawCircle(Offset(cx + r * math.cos(-math.pi / 2 + math.pi * 1.5),
        cy + r * math.sin(-math.pi / 2 + math.pi * 1.5)), 5, _paintWhite(fill: true));
  }

  @override bool shouldRepaint(_) => false;
}

// ── G03 — Circular CCW ───────────────────────────────────────
class _CircularCCWPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final r = math.min(s.width, s.height) * 0.35;

    c.drawLine(Offset(20, s.height - 20), Offset(s.width - 10, s.height - 20), _paintGrey());
    c.drawLine(Offset(20, 10), Offset(20, s.height - 20), _paintGrey());

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    c.drawArc(rect, -math.pi / 2, -math.pi * 1.5, false,
        Paint()..color = const Color(0xFF4FC3F7)..strokeWidth = 2.5..style = PaintingStyle.stroke);

    final arrowX = cx + r * math.cos(math.pi);
    final arrowY = cy + r * math.sin(math.pi);
    final bluePaint = Paint()..color = const Color(0xFF4FC3F7)..strokeWidth = 2..strokeCap = StrokeCap.round..style = PaintingStyle.stroke;
    _drawArrow(c, Offset(arrowX, arrowY + 8), Offset(arrowX, arrowY - 8), bluePaint);

    _drawLabel(c, 'G03', Offset(cx - 14, cy - 8), const Color(0xFF4FC3F7), fontSize: 13);
    _drawLabel(c, 'CCW', Offset(cx - 10, cy + 4), Colors.grey.shade400, fontSize: 10);
    c.drawCircle(Offset(cx, cy), 2, _paintGrey(width: 1));
    c.drawCircle(Offset(cx, cy - r), 5, Paint()..color = const Color(0xFF4FC3F7)..style = PaintingStyle.fill);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Ciclo de Furação ──────────────────────────────────────────
class _FurarPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2;

    // Superfície da peça
    c.drawLine(Offset(20, 30), Offset(s.width - 20, 30),
        Paint()..color = Colors.grey.shade500..strokeWidth = 3..style = PaintingStyle.stroke);
    _drawLabel(c, 'PEÇA', Offset(s.width - 44, 14), Colors.grey.shade500, fontSize: 9);

    // Furo
    c.drawLine(Offset(cx - 8, 30), Offset(cx - 8, s.height - 20), _paintGrey(width: 1));
    c.drawLine(Offset(cx + 8, 30), Offset(cx + 8, s.height - 20), _paintGrey(width: 1));

    // Descida (verde)
    _drawArrow(c, Offset(cx, 15), Offset(cx, s.height - 30), _paintGreen(width: 2.5));

    // Subida (vermelho tracejado)
    final pathUp = Path()..moveTo(cx + 3, s.height - 30)..lineTo(cx + 3, 15);
    _drawDashedPath(c, pathUp, _paintRed(width: 2));

    _drawLabel(c, '↓ avanço', Offset(cx + 12, s.height / 2 - 5), kGreen, fontSize: 9);
    _drawLabel(c, '↑ rápido', Offset(2, s.height / 2 - 5), kRed, fontSize: 9);
    _drawLabel(c, 'R', Offset(cx + 12, 20), Colors.grey.shade400, fontSize: 9);

    c.drawCircle(Offset(cx, 15), 4, _paintAmber(fill: true));
  }

  @override bool shouldRepaint(_) => false;
}

// ── Spindle CW (M03) ─────────────────────────────────────────
class _SpindleCWPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final r = math.min(s.width, s.height) * 0.3;

    // Corpo do spindle
    c.drawCircle(Offset(cx, cy), r, _paintAmber(width: 2));
    c.drawCircle(Offset(cx, cy), r * 0.3, _paintAmber(fill: true));

    // Setas de rotação CW
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final ax = cx + r * 1.2 * math.cos(angle);
      final ay = cy + r * 1.2 * math.sin(angle);
      final bx = cx + r * 1.2 * math.cos(angle + 0.5);
      final by = cy + r * 1.2 * math.sin(angle + 0.5);
      _drawArrow(c, Offset(ax, ay), Offset(bx, by), _paintAmber(width: 1.5));
    }

    _drawLabel(c, 'M03', Offset(cx - 14, cy - 8), kAmber, fontSize: 13);
    _drawLabel(c, 'HORÁRIO', Offset(cx - 22, s.height - 14), Colors.grey.shade400, fontSize: 9);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Spindle CCW (M04) ─────────────────────────────────────────
class _SpindleCCWPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final r = math.min(s.width, s.height) * 0.3;

    c.drawCircle(Offset(cx, cy), r, Paint()..color = const Color(0xFF4FC3F7)..strokeWidth = 2..style = PaintingStyle.stroke);
    c.drawCircle(Offset(cx, cy), r * 0.3, Paint()..color = const Color(0xFF4FC3F7)..style = PaintingStyle.fill);

    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final ax = cx + r * 1.2 * math.cos(angle + 0.5);
      final ay = cy + r * 1.2 * math.sin(angle + 0.5);
      final bx = cx + r * 1.2 * math.cos(angle);
      final by = cy + r * 1.2 * math.sin(angle);
      final p = Paint()..color = const Color(0xFF4FC3F7)..strokeWidth = 1.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
      _drawArrow(c, Offset(ax, ay), Offset(bx, by), p);
    }

    _drawLabel(c, 'M04', Offset(cx - 14, cy - 8), const Color(0xFF4FC3F7), fontSize: 13);
    _drawLabel(c, 'ANTI-HOR.', Offset(cx - 26, s.height - 14), Colors.grey.shade400, fontSize: 9);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Spindle Posicionado (M19/SPOS) ────────────────────────────
class _SpindlePosPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2, cy = s.height / 2;
    final r = math.min(s.width, s.height) * 0.3;

    c.drawCircle(Offset(cx, cy), r, _paintAmber(width: 1.5));
    c.drawCircle(Offset(cx, cy), r * 0.2, _paintAmber(fill: true));

    // Linha de referência (ângulo 0)
    c.drawLine(Offset(cx, cy), Offset(cx + r, cy), _paintGrey(width: 1));

    // Linha de posição
    final ang = -math.pi / 2;
    c.drawLine(Offset(cx, cy), Offset(cx + r * math.cos(ang), cy + r * math.sin(ang)), _paintAmber(width: 2));

    // Arco do ângulo
    c.drawArc(Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.4), 0, ang, false, _paintAmber(width: 1.5));
    _drawLabel(c, '90°', Offset(cx + r * 0.45, cy - 18), kAmber, fontSize: 9);

    _drawLabel(c, 'SPOS', Offset(cx - 16, s.height - 14), Colors.grey.shade400, fontSize: 9);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Refrigeração (M08) ────────────────────────────────────────
class _RefrigeracaoPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = const Color(0xFF4FC3F7)..strokeWidth = 2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;

    // Bocal
    final nozzleRect = RRect.fromRectAndRadius(Rect.fromLTWH(s.width / 2 - 12, 15, 24, 20), const Radius.circular(4));
    c.drawRRect(nozzleRect, _paintAmber(width: 2));

    // Jatos de fluido
    for (int i = 0; i < 5; i++) {
      final x = s.width / 2 - 16 + i * 8.0;
      _drawArrow(c, Offset(x, 38), Offset(x + (i - 2) * 4, s.height - 20), p);
    }

    // Peça
    c.drawRect(Rect.fromLTWH(20, s.height - 22, s.width - 40, 8),
        Paint()..color = Colors.grey.shade600..style = PaintingStyle.fill);

    _drawLabel(c, 'M08 FLOOD', Offset(s.width / 2 - 28, s.height - 14), Colors.grey.shade400, fontSize: 9);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Alta Pressão (M57/M88) ────────────────────────────────────
class _AltaPressaoPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    // Fresa com furo central
    c.drawRect(Rect.fromLTWH(s.width / 2 - 10, 15, 20, 35),
        Paint()..color = Colors.grey.shade700..style = PaintingStyle.fill);
    c.drawRect(Rect.fromLTWH(s.width / 2 - 10, 15, 20, 35), _paintGrey());
    c.drawRect(Rect.fromLTWH(s.width / 2 - 2, 15, 4, 35),
        Paint()..color = const Color(0xFF4FC3F7)..style = PaintingStyle.fill);

    // Jatos de alta pressão
    final p = Paint()..color = const Color(0xFF4FC3F7)..strokeWidth = 2.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    for (int i = 0; i < 3; i++) {
      final x = s.width / 2 - 6 + i * 6.0;
      _drawArrow(c, Offset(x, 52), Offset(x + (i - 1) * 6, s.height - 20), p);
    }

    _drawLabel(c, '70-100 bar', Offset(s.width / 2 - 28, s.height - 14), const Color(0xFF4FC3F7), fontSize: 8);

    // Símbolo de pressão
    final pArc = Paint()..color = kAmber..strokeWidth = 1.5..style = PaintingStyle.stroke;
    c.drawArc(Rect.fromCircle(center: Offset(s.width - 28, 28), radius: 14), -math.pi * 0.8, math.pi * 1.6, false, pArc);
    _drawLabel(c, '!', Offset(s.width - 32, 18), kAmber, fontSize: 14);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Sopro de Ar (M32) ─────────────────────────────────────────
class _AirBlowPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = Colors.white70..strokeWidth = 1.5..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;

    // Bocal
    final path = Path();
    path.moveTo(s.width / 2 - 5, 15);
    path.lineTo(s.width / 2 + 5, 15);
    path.lineTo(s.width / 2 + 12, 35);
    path.lineTo(s.width / 2 - 12, 35);
    path.close();
    c.drawPath(path, _paintAmber(width: 2));

    // Jatos de ar (linhas onduladas)
    for (int i = 0; i < 5; i++) {
      final x = s.width / 2 - 18 + i * 9.0;
      final wPath = Path();
      wPath.moveTo(x, 38);
      for (int j = 0; j < 5; j++) {
        wPath.quadraticBezierTo(
          x + (j % 2 == 0 ? 3 : -3), 38 + j * 8 + 4,
          x, 38 + (j + 1) * 8);
      }
      c.drawPath(wPath, p);
    }

    // Cavacos sendo removidos
    for (int i = 0; i < 4; i++) {
      final cx2 = 25.0 + i * 35.0;
      c.drawCircle(Offset(cx2, s.height - 15), 3,
          Paint()..color = Colors.grey.shade500..style = PaintingStyle.fill);
    }

    _drawLabel(c, 'AIR BLOW', Offset(s.width / 2 - 24, s.height - 12), Colors.grey.shade400, fontSize: 9);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Troca de Ferramenta (M06) ─────────────────────────────────
class _TrocaFerramentaPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    // Magazine (círculo)
    c.drawCircle(Offset(s.width - 45, 40), 32, _paintGrey(width: 1.5));

    // Ferramentas no magazine
    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final tx = s.width - 45 + 22 * math.cos(angle);
      final ty = 40 + 22 * math.sin(angle);
      c.drawCircle(Offset(tx, ty), i == 1 ? 5 : 3,
          i == 1 ? _paintAmber(fill: true) : _paintGrey(width: 1));
    }

    // Braço ATC
    c.drawLine(Offset(s.width - 45, 40), Offset(s.width / 2 + 10, s.height / 2 - 10),
        _paintAmber(width: 3));

    // Spindle
    c.drawRect(Rect.fromLTWH(s.width / 2 - 12, s.height / 2 - 10, 24, 35), _paintGrey(width: 1.5));
    c.drawCircle(Offset(s.width / 2, s.height / 2 + 12), 8, _paintWhite(width: 1.5));

    _drawLabel(c, 'T[n] M06', Offset(s.width / 2 - 22 - 30, s.height - 14), kAmber, fontSize: 9);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Chuck (M10/M11/M25/M26) ───────────────────────────────────
class _ChuckPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2, cy = s.height / 2;

    // Corpo do chuck
    c.drawCircle(Offset(cx, cy), 45, _paintGrey(width: 2));

    // Castanhas (3)
    for (int i = 0; i < 3; i++) {
      final angle = i * 2 * math.pi / 3 - math.pi / 6;
      final tx = cx + 28 * math.cos(angle);
      final ty = cy + 28 * math.sin(angle);
      final rect = Rect.fromCenter(center: Offset(tx, ty), width: 16, height: 10);
      c.drawRect(rect, Paint()..color = Colors.grey.shade600..style = PaintingStyle.fill);
      c.drawRect(rect, _paintGrey());
    }

    // Peça
    c.drawCircle(Offset(cx, cy), 10, Paint()..color = kAmber..style = PaintingStyle.fill);
    c.drawCircle(Offset(cx, cy), 10, _paintAmber());

    // Setas abrindo/fechando
    _drawArrow(c, Offset(cx + 52, cy), Offset(cx + 65, cy), _paintGreen(width: 2));
    _drawArrow(c, Offset(cx - 52, cy), Offset(cx - 65, cy), _paintGreen(width: 2));

    _drawLabel(c, 'CHUCK', Offset(cx - 16, s.height - 10), Colors.grey.shade400, fontSize: 9);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Contra-ponta (M12/M13) ────────────────────────────────────
class _ContrapontaPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    // Peça
    c.drawRect(Rect.fromLTWH(40, s.height / 2 - 12, s.width - 80, 24),
        Paint()..color = Colors.grey.shade700..style = PaintingStyle.fill);
    c.drawRect(Rect.fromLTWH(40, s.height / 2 - 12, s.width - 80, 24), _paintGrey());

    // Chuck esquerdo
    c.drawRect(Rect.fromLTWH(10, s.height / 2 - 20, 30, 40),
        Paint()..color = Colors.grey.shade600..style = PaintingStyle.fill);

    // Contra-ponta direita (triangular)
    final path = Path();
    path.moveTo(s.width - 10, s.height / 2 - 20);
    path.lineTo(s.width - 10, s.height / 2 + 20);
    path.lineTo(s.width - 30, s.height / 2);
    path.close();
    c.drawPath(path, Paint()..color = kAmber..style = PaintingStyle.fill);
    c.drawPath(path, _paintAmber());

    // Seta de avanço
    _drawArrow(c, Offset(s.width - 5, s.height / 2), Offset(s.width - 28, s.height / 2), _paintAmber(width: 2));

    _drawLabel(c, 'CONTRA-PONTA', Offset(s.width / 2 - 38, s.height - 10), Colors.grey.shade400, fontSize: 8);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Rosqueamento Rígido (M29/G84) ────────────────────────────
class _RoscaPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2;

    // Superfície
    c.drawLine(Offset(20, 25), Offset(s.width - 20, 25), _paintGrey(width: 2));

    // Macho de rosca
    c.drawRect(Rect.fromLTWH(cx - 8, 10, 16, 15), _paintAmber(width: 2));

    // Rosca helicoidal
    for (int i = 0; i < 6; i++) {
      final y = 40 + i * 14.0;
      c.drawLine(Offset(cx - 10, y), Offset(cx + 10, y + 7), _paintAmber(width: 1.5));
      c.drawLine(Offset(cx + 10, y + 7), Offset(cx - 10, y + 14), _paintAmber(width: 1.5));
    }

    // Setas (descida + subida)
    _drawArrow(c, Offset(cx - 20, 30), Offset(cx - 20, s.height - 15), _paintGreen(width: 2));
    _drawArrow(c, Offset(cx + 20, s.height - 15), Offset(cx + 20, 30), _paintRed(width: 2));

    _drawLabel(c, 'RÍGIDO', Offset(cx - 14, s.height - 10), Colors.grey.shade400, fontSize: 9);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Espelhamento (M21/M70) ────────────────────────────────────
class _EspelhamentoPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    // Linha de espelhamento
    c.drawLine(Offset(s.width / 2, 10), Offset(s.width / 2, s.height - 10),
        Paint()..color = kAmber..strokeWidth = 1.5..style = PaintingStyle.stroke
        ..shader = null);

    // Perfil original (esquerdo)
    final left = Path();
    left.moveTo(20, s.height - 30);
    left.lineTo(20, 30);
    left.lineTo(55, 30);
    left.lineTo(55, s.height / 2);
    left.lineTo(80, s.height / 2);
    c.drawPath(left, _paintGreen(width: 2));

    // Perfil espelhado (direito)
    final right = Path();
    right.moveTo(s.width - 20, s.height - 30);
    right.lineTo(s.width - 20, 30);
    right.lineTo(s.width - 55, 30);
    right.lineTo(s.width - 55, s.height / 2);
    right.lineTo(s.width - 80, s.height / 2);
    c.drawPath(right, Paint()..color = const Color(0xFF4FC3F7)..strokeWidth = 2..style = PaintingStyle.stroke);

    _drawLabel(c, 'ESPELHO', Offset(s.width / 2 - 22, s.height - 10), kAmber, fontSize: 9);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Medição de Ferramenta (M77/M78) ──────────────────────────
class _MedicaoPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    // Apalpador (tool setter)
    c.drawRect(Rect.fromLTWH(s.width / 2 - 20, s.height - 30, 40, 20),
        Paint()..color = Colors.grey.shade700..style = PaintingStyle.fill);
    c.drawRect(Rect.fromLTWH(s.width / 2 - 20, s.height - 30, 40, 20), _paintGrey());
    c.drawRect(Rect.fromLTWH(s.width / 2 - 4, s.height - 34, 8, 8),
        Paint()..color = const Color(0xFF4FC3F7)..style = PaintingStyle.fill);

    // Ferramenta descendo
    c.drawRect(Rect.fromLTWH(s.width / 2 - 8, 15, 16, 30), _paintAmber(width: 2));
    _drawArrow(c, Offset(s.width / 2, 48), Offset(s.width / 2, s.height - 35), _paintAmber(width: 2));

    // Dimensão H
    c.drawLine(Offset(s.width / 2 + 25, 15), Offset(s.width / 2 + 25, s.height - 34), _paintGrey());
    c.drawLine(Offset(s.width / 2 + 20, 15), Offset(s.width / 2 + 30, 15), _paintGrey());
    c.drawLine(Offset(s.width / 2 + 20, s.height - 34), Offset(s.width / 2 + 30, s.height - 34), _paintGrey());
    _drawLabel(c, 'H', Offset(s.width / 2 + 27, s.height / 2 - 8), kAmber, fontSize: 11);

    _drawLabel(c, 'AUTO MEASURE', Offset(s.width / 2 - 36, s.height - 10), Colors.grey.shade400, fontSize: 8);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Referência (G28/M91) ──────────────────────────────────────
class _ReferenciaPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    // Zero máquina (canto)
    c.drawCircle(Offset(s.width - 30, 25), 8, _paintAmber(fill: true));
    _drawLabel(c, 'REF', Offset(s.width - 44, 36), kAmber, fontSize: 8);

    // Eixos
    c.drawLine(Offset(30, s.height - 25), Offset(s.width - 10, s.height - 25), _paintGrey());
    c.drawLine(Offset(30, 15), Offset(30, s.height - 25), _paintGrey());
    _drawLabel(c, 'X', Offset(s.width - 15, s.height - 25), Colors.grey.shade500);
    _drawLabel(c, 'Z', Offset(22, 8), Colors.grey.shade500);

    // Trajetória de retorno
    _drawArrow(c, Offset(60, s.height - 50), Offset(s.width - 38, 28), _paintAmber(width: 2));

    c.drawCircle(Offset(60, s.height - 50), 5, _paintGreen(fill: true));

    _drawLabel(c, 'ZERO MÁQUINA', Offset(s.width / 2 - 38, s.height - 10), Colors.grey.shade400, fontSize: 8);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Chip Conveyor (M54) ───────────────────────────────────────
class _ChipConveyorPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    // Esteira
    final conveyorPaint = Paint()..color = Colors.grey.shade600..style = PaintingStyle.fill;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(15, s.height / 2 - 10, s.width - 30, 20), const Radius.circular(10)), conveyorPaint);

    // Cavacos
    for (int i = 0; i < 5; i++) {
      c.drawCircle(Offset(30 + i * 30.0, s.height / 2), 4,
          Paint()..color = Colors.grey.shade400..style = PaintingStyle.fill);
    }

    // Seta de movimento
    _drawArrow(c, Offset(20, s.height / 2 - 20), Offset(s.width - 20, s.height / 2 - 20), _paintAmber(width: 2));

    // Caixa de descarte
    c.drawRect(Rect.fromLTWH(s.width - 25, s.height / 2 - 5, 20, s.height / 2 - 10), _paintGrey());
    _drawLabel(c, '🗑️', Offset(s.width - 22, s.height - 22), Colors.grey.shade400, fontSize: 12);

    _drawLabel(c, 'CHIP CONVEYOR', Offset(s.width / 2 - 38, 10), Colors.grey.shade400, fontSize: 8);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Fixador Hidráulico (M68/M69) ──────────────────────────────
class _FixadorPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2;

    // Base do fixador
    c.drawRect(Rect.fromLTWH(20, s.height - 30, s.width - 40, 15),
        Paint()..color = Colors.grey.shade700..style = PaintingStyle.fill);

    // Corpo hidráulico (esquerdo e direito)
    c.drawRect(Rect.fromLTWH(15, s.height / 2, 20, s.height / 2 - 30), _paintGrey(width: 1.5));
    c.drawRect(Rect.fromLTWH(s.width - 35, s.height / 2, 20, s.height / 2 - 30), _paintGrey(width: 1.5));

    // Prensas
    c.drawRect(Rect.fromLTWH(30, s.height / 2 - 8, 22, 10),
        Paint()..color = kAmber..style = PaintingStyle.fill);
    c.drawRect(Rect.fromLTWH(s.width - 52, s.height / 2 - 8, 22, 10),
        Paint()..color = kAmber..style = PaintingStyle.fill);

    // Peça
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - 25, s.height / 2 - 15, 50, 30), const Radius.circular(4)),
        Paint()..color = Colors.grey.shade500..style = PaintingStyle.fill);

    // Setas de fechamento
    _drawArrow(c, Offset(40, s.height / 2), Offset(cx - 25, s.height / 2), _paintGreen(width: 2));
    _drawArrow(c, Offset(s.width - 40, s.height / 2), Offset(cx + 25, s.height / 2), _paintGreen(width: 2));

    _drawLabel(c, 'HIDRÁULICO', Offset(cx - 28, 10), Colors.grey.shade400, fontSize: 9);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Porta Automática (M80/M81) ────────────────────────────────
class _PortaPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    // Máquina (caixa)
    c.drawRect(Rect.fromLTWH(15, 15, s.width - 30, s.height - 30), _paintGrey(width: 2));

    // Porta (aberta - lateral)
    c.drawRect(Rect.fromLTWH(15, 15, 20, s.height - 30), _paintAmber(width: 2));

    // Seta da porta abrindo
    _drawArrow(c, Offset(38, s.height / 2), Offset(65, s.height / 2), _paintAmber(width: 2));

    // Robô/operador entrando
    c.drawCircle(Offset(80, s.height / 2 - 15), 8, _paintGreen(width: 2));
    c.drawLine(Offset(80, s.height / 2 - 7), Offset(80, s.height / 2 + 10), _paintGreen(width: 2));
    c.drawLine(Offset(70, s.height / 2), Offset(90, s.height / 2), _paintGreen(width: 2));

    _drawLabel(c, 'PORTA AUTO', Offset(s.width / 2 - 28, s.height - 10), Colors.grey.shade400, fontSize: 9);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Trava Eixo C (M14/M15) ────────────────────────────────────
class _TravaEixoPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final cx = s.width / 2, cy = s.height / 2;

    // Eixo (torno)
    c.drawRect(Rect.fromLTWH(20, cy - 12, s.width - 40, 24), _paintGrey(width: 2));

    // Símbolo de trava (cadeado)
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(cx - 14, cy - 24, 28, 20), const Radius.circular(4)),
        _paintAmber(width: 2));
    c.drawArc(Rect.fromLTWH(cx - 8, cy - 38, 16, 18), math.pi, math.pi, false, _paintAmber(width: 2));

    // C rotulado
    _drawLabel(c, 'C', Offset(cx - 5, cy - 22), kAmber, fontSize: 12);

    _drawLabel(c, 'EIXO C TRAVADO', Offset(s.width / 2 - 40, s.height - 10), Colors.grey.shade400, fontSize: 8);
  }

  @override bool shouldRepaint(_) => false;
}

// ── Helper: linha tracejada ────────────────────────────────────
void _drawDashedPath(Canvas c, Path path, Paint paint) {
  final metrics = path.computeMetrics();
  for (final metric in metrics) {
    double distance = 0;
    bool draw = true;
    while (distance < metric.length) {
      final next = math.min(distance + (draw ? 8 : 5), metric.length);
      if (draw) c.drawPath(metric.extractPath(distance, next), paint);
      distance = next;
      draw = !draw;
    }
  }
}
