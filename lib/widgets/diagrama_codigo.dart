import 'dart:math';
import 'package:flutter/material.dart';
import '../constants.dart';

class DiagramaCodigo extends StatelessWidget {
  final String codigo;
  const DiagramaCodigo({super.key, required this.codigo});

  @override
  Widget build(BuildContext context) {
    final painter = _painterFor(codigo);
    if (painter == null) return const SizedBox.shrink();
    return Container(
      width: 280,
      height: 180,
      decoration: BoxDecoration(
        color: kDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomPaint(painter: painter, size: const Size(280, 180)),
      ),
    );
  }

  static bool has(String codigo) {
    final upper = codigo.toUpperCase();
    if (upper.startsWith('CYCL')) return true;
    const supported = {
      'G00','G01','G02','G03','G28','G32',
      'G41','G42','G81','G83','G90','G91',
      'G76','G92','G96','G97',
      'G200','G201',
      'M03','M04','M06','M08',
    };
    return supported.contains(upper);
  }

  CustomPainter? _painterFor(String cod) {
    final upper = cod.toUpperCase();
    if (upper.startsWith('CYCL')) return _CyclMilPainter();
    switch (upper) {
      case 'G00': return _G00Painter();
      case 'G01': return _G01Painter();
      case 'G02': return _G02Painter();
      case 'G03': return _G03Painter();
      case 'G28': return _G28Painter();
      case 'G32': return _G32Painter();
      case 'G41': return _G41Painter();
      case 'G42': return _G42Painter();
      case 'G81': return _G81Painter();
      case 'G83': return _G83Painter();
      case 'G90': return _G90Painter();
      case 'G91': return _G91Painter();
      case 'G76': return _RoscaPainter();
      case 'G92': return _RoscaPainter();
      case 'G96': return _G96Painter();
      case 'G97': return _G97Painter();
      case 'G200':
      case 'G201': return _G200Painter();
      case 'M03': return _M03Painter();
      case 'M04': return _M04Painter();
      case 'M06': return _M06Painter();
      case 'M08': return _M08Painter();
      default:    return null;
    }
  }
}

// ── helpers ──────────────────────────────────────────────────────────────────

Paint _pw({double w = 1.5, Color c = Colors.white}) =>
    Paint()..color = c..strokeWidth = w..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;

Paint _pf(Color c) => Paint()..color = c..style = PaintingStyle.fill;

void _arrow(Canvas cv, Offset from, Offset to, Paint p) {
  cv.drawLine(from, to, p);
  final ang = atan2(to.dy - from.dy, to.dx - from.dx);
  const len = 9.0;
  const spread = 0.42;
  final a1 = Offset(to.dx - len * cos(ang - spread), to.dy - len * sin(ang - spread));
  final a2 = Offset(to.dx - len * cos(ang + spread), to.dy - len * sin(ang + spread));
  final path = Path()..moveTo(to.dx, to.dy)..lineTo(a1.dx, a1.dy)..lineTo(a2.dx, a2.dy)..close();
  cv.drawPath(path, Paint()..color = p.color..style = PaintingStyle.fill);
}

void _dashed(Canvas cv, Offset from, Offset to, Paint p) {
  final dx = to.dx - from.dx;
  final dy = to.dy - from.dy;
  final len = sqrt(dx * dx + dy * dy);
  const dash = 6.0, gap = 4.0;
  double d = 0;
  while (d < len) {
    final t0 = d / len;
    final t1 = min((d + dash) / len, 1.0);
    cv.drawLine(
      Offset(from.dx + dx * t0, from.dy + dy * t0),
      Offset(from.dx + dx * t1, from.dy + dy * t1),
      p,
    );
    d += dash + gap;
  }
}

void _label(Canvas cv, String text, Offset pos, Color color, {double fs = 10, bool bold = false}) {
  final tp = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(color: color, fontSize: fs, fontWeight: bold ? FontWeight.bold : FontWeight.normal),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  tp.paint(cv, pos - Offset(tp.width / 2, tp.height / 2));
}

void _axes(Canvas cv, Offset origin, double len) {
  final px = _pw(w: 1.0, c: Colors.white54);
  _arrow(cv, origin, Offset(origin.dx + len, origin.dy), px);
  _arrow(cv, origin, Offset(origin.dx, origin.dy - len), px);
  _label(cv, 'X', Offset(origin.dx + len + 8, origin.dy), Colors.white54, fs: 9);
  _label(cv, 'Y', Offset(origin.dx, origin.dy - len - 8), Colors.white54, fs: 9);
}

// ── G00 – Rapid positioning ───────────────────────────────────────────────────

class _G00Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    final p = _pw(w: 2, c: kBlue);
    final start = Offset(40, 140);
    final end   = Offset(240, 50);
    _dashed(cv, start, end, p);
    _arrow(cv, Offset(end.dx - 20, end.dy + 15), end, _pw(w: 2, c: kBlue));
    cv.drawCircle(start, 5, _pf(kAmber));
    cv.drawCircle(end,   5, _pf(kGreen));
    _label(cv, 'G00 — Avanço Rápido', Offset(140, 16), kAmber, fs: 11, bold: true);
    _label(cv, 'Ponto A', Offset(start.dx, start.dy + 14), Colors.white70, fs: 9);
    _label(cv, 'Ponto B', Offset(end.dx,   end.dy - 14),   Colors.white70, fs: 9);
    _label(cv, 'Trajetória não\ncortante (rápida)', Offset(140, 100), Colors.white38, fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G01 – Linear interpolation ────────────────────────────────────────────────

class _G01Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    _axes(cv, const Offset(30, 150), 50);
    final p = _pw(w: 2.5, c: kRed);
    const a = Offset(60, 140);
    const b = Offset(230, 60);
    _arrow(cv, a, b, p);
    cv.drawCircle(a, 5, _pf(kAmber));
    cv.drawCircle(b, 5, _pf(kGreen));
    // dimension lines
    final dim = _pw(w: 1, c: Colors.white38);
    cv.drawLine(Offset(a.dx, a.dy), Offset(b.dx, a.dy), dim);
    cv.drawLine(Offset(b.dx, a.dy), Offset(b.dx, b.dy), dim);
    _label(cv, 'ΔX', Offset((a.dx + b.dx) / 2, a.dy + 10), Colors.white54, fs: 9);
    _label(cv, 'ΔY', Offset(b.dx + 12, (a.dy + b.dy) / 2), Colors.white54, fs: 9);
    _label(cv, 'F = avanço programado', Offset(140, 170), Colors.white54, fs: 9);
    _label(cv, 'G01 — Interpolação Linear', Offset(140, 16), kAmber, fs: 11, bold: true);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G02 – Circular CW ─────────────────────────────────────────────────────────

class _G02Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const center = Offset(140, 105);
    const r = 60.0;
    final arcPaint = _pw(w: 2.5, c: const Color(0xFFFF9800));
    final rect = Rect.fromCircle(center: center, radius: r);
    // draw arc from 180° to 0° clockwise (sweep -180°)
    cv.drawArc(rect, pi, -pi, false, arcPaint);
    // arrow at end point
    final endPt = Offset(center.dx + r, center.dy);
    _arrow(cv, Offset(endPt.dx - 5, endPt.dy - 12), endPt, _pw(w: 2, c: const Color(0xFFFF9800)));
    // start/end dots
    cv.drawCircle(Offset(center.dx - r, center.dy), 5, _pf(kAmber));
    cv.drawCircle(endPt, 5, _pf(kGreen));
    // radius line
    cv.drawLine(center, endPt, _pw(w: 1, c: Colors.white38));
    _label(cv, 'R', Offset(center.dx + r / 2, center.dy - 10), Colors.white70, fs: 10);
    // CW arrow indicator
    _label(cv, '↻', Offset(center.dx, center.dy), const Color(0xFFFF9800), fs: 22);
    _label(cv, 'G02 — Arco Horário (CW)', Offset(140, 16), kAmber, fs: 11, bold: true);
    _label(cv, 'I, J = centro relativo', Offset(140, 168), Colors.white54, fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G03 – Circular CCW ────────────────────────────────────────────────────────

class _G03Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const center = Offset(140, 105);
    const r = 60.0;
    final arcPaint = _pw(w: 2.5, c: kGreen);
    final rect = Rect.fromCircle(center: center, radius: r);
    cv.drawArc(rect, pi, pi, false, arcPaint);
    final endPt = Offset(center.dx - r, center.dy);
    _arrow(cv, Offset(endPt.dx + 5, endPt.dy - 12), endPt, _pw(w: 2, c: kGreen));
    cv.drawCircle(Offset(center.dx + r, center.dy), 5, _pf(kAmber));
    cv.drawCircle(endPt, 5, _pf(kGreen));
    cv.drawLine(center, Offset(center.dx + r, center.dy), _pw(w: 1, c: Colors.white38));
    _label(cv, 'R', Offset(center.dx + r / 2, center.dy - 10), Colors.white70, fs: 10);
    _label(cv, '↺', Offset(center.dx, center.dy), kGreen, fs: 22);
    _label(cv, 'G03 — Arco Anti-horário (CCW)', Offset(140, 16), kAmber, fs: 11, bold: true);
    _label(cv, 'I, J = centro relativo', Offset(140, 168), Colors.white54, fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G28 – Return to reference ─────────────────────────────────────────────────

class _G28Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    final origin = const Offset(50, 145);
    _axes(cv, origin, 55);
    // machine zero marker
    const mz = Offset(50, 145);
    cv.drawRect(Rect.fromCenter(center: mz, width: 10, height: 10),
        _pw(w: 1.5, c: kAmber));
    // current position
    const cur = Offset(210, 60);
    cv.drawCircle(cur, 6, _pf(const Color(0xFF7EC8A4)));
    // intermediate point
    const mid = Offset(210, 145);
    cv.drawCircle(mid, 4, _pf(Colors.white38));
    // path: cur → mid → origin
    _dashed(cv, cur, mid, _pw(w: 1.5, c: Colors.white38));
    _arrow(cv, mid, Offset(mz.dx + 8, mz.dy), _pw(w: 2, c: kBlue));
    _label(cv, 'G28 — Retorno à Referência', Offset(140, 16), kAmber, fs: 11, bold: true);
    _label(cv, 'Ponto\nIntermediário', Offset(mid.dx + 28, mid.dy), Colors.white54, fs: 9);
    _label(cv, 'Zero\nMáquina', Offset(mz.dx - 2, mz.dy - 22), kAmber, fs: 9);
    _label(cv, 'Posição\nAtual', Offset(cur.dx + 22, cur.dy), const Color(0xFF7EC8A4), fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G41 – Tool radius comp left ───────────────────────────────────────────────

class _G41Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    // workpiece edge
    const y = 110.0;
    cv.drawLine(const Offset(30, y), const Offset(250, y), _pw(w: 2, c: Colors.white54));
    // programmed path
    _dashed(cv, const Offset(30, y - 30), const Offset(250, y - 30), _pw(w: 1.5, c: Colors.white38));
    // tool circles along path
    for (final x in [60.0, 120.0, 180.0, 230.0]) {
      cv.drawCircle(Offset(x, y - 30), 18, _pw(w: 1.5, c: kAmber));
      cv.drawCircle(Offset(x, y - 30), 3, _pf(kAmber));
    }
    // offset arrow
    cv.drawLine(const Offset(120, y - 30), const Offset(120, y), _pw(w: 1.5, c: kRed));
    _label(cv, 'R', const Offset(128, y - 15), kRed, fs: 10);
    // direction arrow
    _arrow(cv, const Offset(60, y - 30), const Offset(230, y - 30), _pw(w: 1.5, c: kBlue));
    _label(cv, 'G41 — Compensação Esquerda', Offset(140, 16), kAmber, fs: 11, bold: true);
    _label(cv, 'Peça', const Offset(140, y + 14), Colors.white54, fs: 9);
    _label(cv, 'Trajetória\nprogramada', const Offset(140, y - 55), Colors.white38, fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G42 – Tool radius comp right ──────────────────────────────────────────────

class _G42Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const y = 80.0;
    cv.drawLine(const Offset(30, y), const Offset(250, y), _pw(w: 2, c: Colors.white54));
    _dashed(cv, const Offset(30, y + 30), const Offset(250, y + 30), _pw(w: 1.5, c: Colors.white38));
    for (final x in [60.0, 120.0, 180.0, 230.0]) {
      cv.drawCircle(Offset(x, y + 30), 18, _pw(w: 1.5, c: kAmber));
      cv.drawCircle(Offset(x, y + 30), 3, _pf(kAmber));
    }
    cv.drawLine(const Offset(120, y), const Offset(120, y + 30), _pw(w: 1.5, c: kRed));
    _label(cv, 'R', const Offset(128, y + 15), kRed, fs: 10);
    _arrow(cv, const Offset(60, y + 30), const Offset(230, y + 30), _pw(w: 1.5, c: kBlue));
    _label(cv, 'G42 — Compensação Direita', const Offset(140, 16), kAmber, fs: 11, bold: true);
    _label(cv, 'Peça', const Offset(140, y - 14), Colors.white54, fs: 9);
    _label(cv, 'Trajetória\nprogramada', const Offset(140, y + 60), Colors.white38, fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G81 – Drilling cycle ──────────────────────────────────────────────────────

class _G81Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const cx = 140.0;
    // workpiece top surface
    cv.drawLine(const Offset(40, 60), const Offset(240, 60), _pw(w: 2, c: Colors.white54));
    // reference plane R
    _dashed(cv, const Offset(40, 80), const Offset(240, 80), _pw(w: 1, c: Colors.white38));
    _label(cv, 'R', const Offset(30, 80), Colors.white54, fs: 9);
    // drill tool (rectangle + tip)
    final toolPaint = _pw(w: 1.5, c: kAmber);
    cv.drawRect(const Rect.fromLTWH(cx - 8, 20, 16, 40), toolPaint);
    final tip = Path()
      ..moveTo(cx - 8, 60)
      ..lineTo(cx, 68)
      ..lineTo(cx + 8, 60);
    cv.drawPath(tip, toolPaint);
    // hole
    cv.drawLine(Offset(cx - 6, 60), Offset(cx - 6, 145), _pw(w: 1, c: Colors.white24));
    cv.drawLine(Offset(cx + 6, 60), Offset(cx + 6, 145), _pw(w: 1, c: Colors.white24));
    // down arrow (feed)
    _arrow(cv, Offset(cx + 25, 80), Offset(cx + 25, 140), _pw(w: 2, c: kRed));
    _label(cv, 'F', Offset(cx + 38, 110), kRed, fs: 10);
    // return arrow
    _arrow(cv, Offset(cx - 25, 140), Offset(cx - 25, 80), _pw(w: 2, c: kBlue));
    _label(cv, 'R', Offset(cx - 38, 110), kBlue, fs: 10);
    // depth dimension
    cv.drawLine(const Offset(180, 80), const Offset(180, 140), _pw(w: 1, c: Colors.white38));
    _label(cv, 'Z', const Offset(192, 110), Colors.white54, fs: 9);
    _label(cv, 'G81 — Ciclo de Furação', const Offset(140, 168), kAmber, fs: 11, bold: true);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G83 – Peck drilling ───────────────────────────────────────────────────────

class _G83Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const cx = 100.0;
    cv.drawLine(const Offset(20, 50), const Offset(180, 50), _pw(w: 2, c: Colors.white54));
    _dashed(cv, const Offset(20, 65), const Offset(180, 65), _pw(w: 1, c: Colors.white38));
    _label(cv, 'R', const Offset(14, 65), Colors.white54, fs: 8);
    // hole walls
    cv.drawLine(Offset(cx - 6, 50), Offset(cx - 6, 155), _pw(w: 1, c: Colors.white24));
    cv.drawLine(Offset(cx + 6, 50), Offset(cx + 6, 155), _pw(w: 1, c: Colors.white24));
    // pecks
    final pecks = [85.0, 105.0, 125.0, 145.0];
    for (int i = 0; i < pecks.length; i++) {
      final start = i == 0 ? 65.0 : pecks[i - 1];
      // feed down
      _arrow(cv, Offset(cx + 18, start), Offset(cx + 18, pecks[i]), _pw(w: 1.5, c: kRed));
      // retract
      if (i < pecks.length - 1) {
        _arrow(cv, Offset(cx + 18, pecks[i]), Offset(cx + 18, 65), _pw(w: 1, c: kBlue));
      }
    }
    _label(cv, 'Q (passo)', const Offset(cx + 45, 105), Colors.white54, fs: 9);
    cv.drawLine(const Offset(cx + 32, 85), const Offset(cx + 32, 105), _pw(w: 1, c: Colors.white38));
    _label(cv, 'G83 — Furação com Picagem', const Offset(200, 90), kAmber, fs: 10, bold: true);
    _label(cv, 'Retrai a\ncada passo', const Offset(200, 130), Colors.white54, fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G90 – Absolute coordinates ────────────────────────────────────────────────

class _G90Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const org = Offset(40, 150);
    _axes(cv, org, 60);
    // points
    const p1 = Offset(100, 110);
    const p2 = Offset(160, 70);
    const p3 = Offset(220, 100);
    cv.drawCircle(p1, 5, _pf(kAmber));
    cv.drawCircle(p2, 5, _pf(kAmber));
    cv.drawCircle(p3, 5, _pf(kAmber));
    // dimension lines from origin
    final dim = _pw(w: 1, c: Colors.white24);
    cv.drawLine(org, Offset(p1.dx, org.dy), dim);
    cv.drawLine(Offset(p1.dx, org.dy), p1, dim);
    cv.drawLine(org, Offset(p2.dx, org.dy), dim);
    cv.drawLine(Offset(p2.dx, org.dy), p2, dim);
    _label(cv, 'X30', Offset(p1.dx, org.dy + 12), Colors.white54, fs: 9);
    _label(cv, 'X60', Offset(p2.dx, org.dy + 12), Colors.white54, fs: 9);
    _label(cv, 'G90 — Coordenadas Absolutas', Offset(140, 16), kAmber, fs: 11, bold: true);
    _label(cv, 'Sempre do zero peça', Offset(140, 168), Colors.white54, fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G91 – Incremental coordinates ────────────────────────────────────────────

class _G91Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const p0 = Offset(40, 130);
    const p1 = Offset(110, 90);
    const p2 = Offset(180, 110);
    const p3 = Offset(240, 60);
    final pts = [p0, p1, p2, p3];
    final colors = [kAmber, kGreen, const Color(0xFFFF9800), kBlue];
    for (int i = 0; i < pts.length - 1; i++) {
      _arrow(cv, pts[i], pts[i + 1], _pw(w: 2, c: colors[i + 1]));
    }
    for (final p in pts) cv.drawCircle(p, 5, _pf(kAmber));
    // incremental labels
    _label(cv, 'X+70\nY-40', Offset((p0.dx + p1.dx) / 2 - 15, (p0.dy + p1.dy) / 2 - 10), kGreen, fs: 8);
    _label(cv, 'X+70\nY+20', Offset((p1.dx + p2.dx) / 2 - 15, (p1.dy + p2.dy) / 2 + 10), const Color(0xFFFF9800), fs: 8);
    _label(cv, 'X+60\nY-50', Offset((p2.dx + p3.dx) / 2 - 15, (p2.dy + p3.dy) / 2 - 14), kBlue, fs: 8);
    _label(cv, 'G91 — Coordenadas Incrementais', Offset(140, 16), kAmber, fs: 11, bold: true);
    _label(cv, 'Relativo ao ponto anterior', Offset(140, 168), Colors.white54, fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G76/G92 – Thread profile ──────────────────────────────────────────────────

class _RoscaPainter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    final p = _pw(w: 2, c: kAmber);
    // thread profile (multiple teeth)
    const baseline = 130.0;
    const pitch = 40.0;
    const depth = 35.0;
    const startX = 30.0;
    const teeth = 5;
    final path = Path()..moveTo(startX, baseline);
    for (int i = 0; i < teeth; i++) {
      final x0 = startX + i * pitch;
      path.lineTo(x0 + pitch * 0.25, baseline);
      path.lineTo(x0 + pitch * 0.5,  baseline - depth);
      path.lineTo(x0 + pitch * 0.75, baseline);
    }
    path.lineTo(startX + teeth * pitch, baseline);
    cv.drawPath(path, p);
    // 60° angle arc indicator
    final angPath = Path()..moveTo(startX + pitch * 0.25, baseline)
      ..lineTo(startX + pitch * 0.5, baseline - depth)
      ..lineTo(startX + pitch * 0.75, baseline);
    cv.drawPath(angPath, _pw(w: 1, c: Colors.white38));
    _label(cv, '60°', Offset(startX + pitch * 0.5, baseline - depth + 14), Colors.white70, fs: 9);
    // pitch dimension
    cv.drawLine(Offset(startX + pitch * 0.5, baseline - depth - 10),
        Offset(startX + pitch * 1.5, baseline - depth - 10),
        _pw(w: 1, c: kBlue));
    _arrow(cv, Offset(startX + pitch * 0.5, baseline - depth - 10),
        Offset(startX + pitch * 0.5 + 5, baseline - depth - 10), _pw(w: 1, c: kBlue));
    _arrow(cv, Offset(startX + pitch * 1.5, baseline - depth - 10),
        Offset(startX + pitch * 1.5 - 5, baseline - depth - 10), _pw(w: 1, c: kBlue));
    _label(cv, 'P (passo)', Offset(startX + pitch, baseline - depth - 20), kBlue, fs: 9);
    // depth dimension
    cv.drawLine(Offset(startX + pitch * 2.5 + 12, baseline),
        Offset(startX + pitch * 2.5 + 12, baseline - depth),
        _pw(w: 1, c: kRed));
    _label(cv, 'h', Offset(startX + pitch * 2.5 + 24, baseline - depth / 2), kRed, fs: 9);
    _label(cv, 'G76/G92 — Ciclo de Rosca', const Offset(140, 16), kAmber, fs: 11, bold: true);
    _label(cv, 'Perfil ISO — ângulo 60°', const Offset(140, 168), Colors.white54, fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ── M03 – Spindle CW ──────────────────────────────────────────────────────────

class _M03Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const center = Offset(140, 100);
    const r = 50.0;
    cv.drawCircle(center, r, _pw(w: 2.5, c: kAmber));
    cv.drawCircle(center, 8, _pf(kAmber));
    // CW arrows around circle
    for (int i = 0; i < 4; i++) {
      final ang = i * pi / 2;
      final tip = Offset(center.dx + r * cos(ang), center.dy + r * sin(ang));
      final from = Offset(
        center.dx + r * cos(ang - 0.35),
        center.dy + r * sin(ang - 0.35),
      );
      _arrow(cv, from, tip, _pw(w: 2, c: kAmber));
    }
    _label(cv, 'S = RPM', Offset(center.dx, center.dy + r + 18), Colors.white70, fs: 10);
    _label(cv, 'M03 — Spindle Horário (CW)', const Offset(140, 16), kAmber, fs: 11, bold: true);
  }
  @override bool shouldRepaint(_) => false;
}

// ── M04 – Spindle CCW ─────────────────────────────────────────────────────────

class _M04Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const center = Offset(140, 100);
    const r = 50.0;
    cv.drawCircle(center, r, _pw(w: 2.5, c: kGreen));
    cv.drawCircle(center, 8, _pf(kGreen));
    // CCW arrows
    for (int i = 0; i < 4; i++) {
      final ang = i * pi / 2;
      final tip = Offset(center.dx + r * cos(ang), center.dy + r * sin(ang));
      final from = Offset(
        center.dx + r * cos(ang + 0.35),
        center.dy + r * sin(ang + 0.35),
      );
      _arrow(cv, from, tip, _pw(w: 2, c: kGreen));
    }
    _label(cv, 'S = RPM', Offset(center.dx, center.dy + r + 18), Colors.white70, fs: 10);
    _label(cv, 'M04 — Spindle Anti-horário (CCW)', const Offset(140, 16), kAmber, fs: 11, bold: true);
  }
  @override bool shouldRepaint(_) => false;
}

// ── M06 – Tool change ─────────────────────────────────────────────────────────

class _M06Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    // Spindle (left) — current tool
    _drawTool(cv, const Offset(70, 90), kRed, 'T atual');
    // ATC arm (center)
    cv.drawRect(const Rect.fromLTWH(105, 85, 70, 20),
        _pw(w: 1.5, c: Colors.white54));
    cv.drawCircle(const Offset(140, 95), 6, _pf(Colors.white38));
    // Arrow indicating swap
    _arrow(cv, const Offset(108, 75), const Offset(172, 75), _pw(w: 2, c: kBlue));
    _arrow(cv, const Offset(172, 115), const Offset(108, 115), _pw(w: 2, c: kAmber));
    // Magazine (right) — new tool
    _drawTool(cv, const Offset(210, 90), kGreen, 'T nova');
    _label(cv, 'M06 — Troca de Ferramenta', const Offset(140, 16), kAmber, fs: 11, bold: true);
    _label(cv, 'Braço ATC', const Offset(140, 148), Colors.white54, fs: 9);
    _label(cv, 'T= seleciona', const Offset(140, 164), Colors.white38, fs: 8);
  }

  void _drawTool(Canvas cv, Offset center, Color color, String label) {
    cv.drawRect(
      Rect.fromCenter(center: Offset(center.dx, center.dy - 20), width: 20, height: 28),
      _pw(w: 1.5, c: color),
    );
    final tip = Path()
      ..moveTo(center.dx - 6, center.dy - 6)
      ..lineTo(center.dx, center.dy + 10)
      ..lineTo(center.dx + 6, center.dy - 6)
      ..close();
    cv.drawPath(tip, _pf(color.withValues(alpha: 0.7)));
    _label(cv, label, Offset(center.dx, center.dy + 22), color, fs: 9);
  }

  @override bool shouldRepaint(_) => false;
}

// ── G32 – Single threading pass (torno) ──────────────────────────────────────

class _G32Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const cy = 100.0;
    cv.drawLine(const Offset(30, cy - 28), const Offset(240, cy - 28), _pw(w: 2, c: Colors.white54));
    cv.drawLine(const Offset(30, cy + 28), const Offset(240, cy + 28), _pw(w: 2, c: Colors.white54));
    const pitch = 22.0;
    const depth = 11.0;
    final path = Path()..moveTo(50, cy - 28);
    for (int i = 0; i < 8; i++) {
      final x0 = 50.0 + i * pitch;
      path.lineTo(x0 + pitch * 0.3, cy - 28);
      path.lineTo(x0 + pitch * 0.5, cy - 28 - depth);
      path.lineTo(x0 + pitch * 0.7, cy - 28);
    }
    cv.drawPath(path, _pw(w: 1.5, c: kAmber));
    _arrow(cv, const Offset(55, 50), const Offset(55, cy - 40), _pw(w: 2, c: kRed));
    _label(cv, 'X (profundidade)', const Offset(110, 42), kRed, fs: 9);
    _arrow(cv, const Offset(50, cy + 45), const Offset(225, cy + 45), _pw(w: 2, c: kBlue));
    _label(cv, 'F = passo (mm/rot)', const Offset(140, cy + 58), kBlue, fs: 9);
    _label(cv, 'G32 — Rosca Direta (1 passe)', const Offset(140, 16), kAmber, fs: 10, bold: true);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G96 – CSS (Constant Surface Speed) ───────────────────────────────────────

class _G96Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    final workpiece = Path()
      ..moveTo(45, 45)
      ..lineTo(45, 145)
      ..lineTo(215, 118)
      ..lineTo(215, 72)
      ..close();
    cv.drawPath(workpiece, _pw(w: 2, c: Colors.white54));
    _drawSpindleIndicator(cv, const Offset(70, 95), 24, 1, Colors.white54, 'N baixo');
    _drawSpindleIndicator(cv, const Offset(200, 95), 14, 3, kAmber, 'N alto');
    cv.drawLine(const Offset(45, 62), const Offset(215, 75), _pw(w: 1.5, c: kGreen));
    cv.drawLine(const Offset(45, 128), const Offset(215, 115), _pw(w: 1.5, c: kGreen));
    _label(cv, 'Vc = constante', const Offset(130, 91), kGreen, fs: 9, bold: true);
    _label(cv, 'G96 — Veloc. Corte Constante (CSS)', const Offset(140, 16), kAmber, fs: 10, bold: true);
    _label(cv, 'Usar G92 S[max] para limitar RPM', const Offset(140, 168), Colors.white54, fs: 8);
  }

  void _drawSpindleIndicator(Canvas cv, Offset c, double r, int arrows, Color color, String lbl) {
    cv.drawCircle(c, r, _pw(w: 1.5, c: color));
    for (int i = 0; i < arrows; i++) {
      final ang = -pi / 2 + (i * 2 * pi / arrows);
      final tip = Offset(c.dx + r * cos(ang), c.dy + r * sin(ang));
      final from = Offset(c.dx + r * cos(ang - 0.5), c.dy + r * sin(ang - 0.5));
      _arrow(cv, from, tip, _pw(w: 1.5, c: color));
    }
    _label(cv, lbl, Offset(c.dx, c.dy + r + 12), color, fs: 8);
  }

  @override bool shouldRepaint(_) => false;
}

// ── G97 – Fixed RPM ───────────────────────────────────────────────────────────

class _G97Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const center = Offset(140, 100);
    const r = 50.0;
    cv.drawCircle(center, r, _pw(w: 2, c: kBlue));
    cv.drawCircle(center, 6, _pf(kBlue));
    for (int i = 0; i < 4; i++) {
      final ang = i * pi / 2;
      final tip = Offset(center.dx + r * cos(ang), center.dy + r * sin(ang));
      final from = Offset(center.dx + r * cos(ang - 0.35), center.dy + r * sin(ang - 0.35));
      _arrow(cv, from, tip, _pw(w: 2, c: kBlue));
    }
    _label(cv, 'S', center, kAmber, fs: 18, bold: true);
    _label(cv, 'RPM fixo', Offset(center.dx, center.dy + r + 18), Colors.white70, fs: 10);
    _label(cv, 'G97 — RPM Constante', const Offset(140, 16), kAmber, fs: 11, bold: true);
    _label(cv, 'Cancela G96 — padrão fresamento', const Offset(140, 168), Colors.white54, fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ── M08 – Flood coolant ───────────────────────────────────────────────────────

class _M08Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const toolX = 115.0;
    cv.drawLine(const Offset(30, 138), const Offset(240, 138), _pw(w: 3, c: Colors.white54));
    cv.drawRect(const Rect.fromLTWH(30, 138, 210, 22), _pf(Colors.white.withValues(alpha: 0.05)));
    cv.drawRect(const Rect.fromLTWH(toolX - 8, 60, 16, 60), _pw(w: 2, c: kAmber));
    final toolTip = Path()
      ..moveTo(toolX - 8, 120)
      ..lineTo(toolX, 138)
      ..lineTo(toolX + 8, 120)
      ..close();
    cv.drawPath(toolTip, _pf(kAmber.withValues(alpha: 0.8)));
    cv.drawRect(const Rect.fromLTWH(185, 45, 32, 14), _pw(w: 1.5, c: Colors.blueGrey));
    final coolant = _pw(w: 2, c: const Color(0xFF42A5F5));
    for (int i = 0; i < 6; i++) {
      final x = 180.0 - i * 11;
      final y0 = 59.0 + i * 8;
      final p = Path()
        ..moveTo(x, y0)
        ..cubicTo(x - 4, y0 + 12, x + 4, y0 + 22, x, y0 + 30);
      cv.drawPath(p, coolant);
      cv.drawCircle(Offset(x, y0 + 30), 3, _pf(const Color(0xFF42A5F5)));
    }
    _label(cv, 'Bico de\nrefrigeração', const Offset(220, 52), Colors.blueGrey, fs: 8);
    _label(cv, 'M08 — Refrigeração Flood', const Offset(140, 16), kAmber, fs: 11, bold: true);
    _label(cv, 'Ligar ANTES do corte — apagar APÓS', const Offset(140, 168), Colors.white54, fs: 8);
  }
  @override bool shouldRepaint(_) => false;
}

// ── CYCL DEF – Heidenhain spiral pocket ──────────────────────────────────────

class _CyclMilPainter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const l = 35.0, t = 42.0, r = 245.0, b = 152.0;
    cv.drawRect(const Rect.fromLTRB(l, t, r, b), _pw(w: 2, c: Colors.white54));
    final cx = (l + r) / 2;
    final cy = (t + b) / 2;
    const maxA = 88.0, minA = 10.0;
    const steps = 72;
    final pts = <Offset>[];
    for (int i = 0; i <= steps; i++) {
      final frac = i / steps;
      final a = maxA - (maxA - minA) * frac;
      final angle = frac * 4.5 * pi - pi / 2;
      final ratio = (r - l) / (b - t);
      pts.add(Offset(cx + a * ratio * cos(angle), cy + a * sin(angle)));
    }
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (final p in pts.skip(1)) path.lineTo(p.dx, p.dy);
    cv.drawPath(path, _pw(w: 1.5, c: kAmber));
    cv.drawCircle(Offset(cx, cy), 4, _pf(kGreen));
    cv.drawCircle(pts[0], 4, _pf(kAmber));
    _arrow(cv, pts[4], pts[8], _pw(w: 1.5, c: kAmber));
    _label(cv, 'CYCL DEF — Bolsão em Espiral', const Offset(140, 16), kAmber, fs: 10, bold: true);
    _label(cv, 'Exterior → centro', const Offset(140, 168), Colors.white54, fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}

// ── G200/G201 – Heidenhain drilling / reaming ─────────────────────────────────

class _G200Painter extends CustomPainter {
  @override
  void paint(Canvas cv, Size sz) {
    const cx = 140.0;
    cv.drawLine(const Offset(30, 52), const Offset(250, 52), _pw(w: 2, c: Colors.white54));
    _dashed(cv, const Offset(30, 68), const Offset(250, 68), _pw(w: 1, c: Colors.white38));
    _label(cv, 'SCET', const Offset(20, 68), Colors.white38, fs: 7);
    cv.drawLine(Offset(cx - 7, 52), Offset(cx - 7, 148), _pw(w: 1, c: Colors.white24));
    cv.drawLine(Offset(cx + 7, 52), Offset(cx + 7, 148), _pw(w: 1, c: Colors.white24));
    cv.drawRect(Rect.fromLTWH(cx - 9, 18, 18, 34), _pw(w: 1.5, c: kAmber));
    final tip = Path()
      ..moveTo(cx - 9, 52)
      ..lineTo(cx, 64)
      ..lineTo(cx + 9, 52);
    cv.drawPath(tip, _pw(w: 1.5, c: kAmber));
    _arrow(cv, Offset(cx + 22, 68), Offset(cx + 22, 146), _pw(w: 2, c: kRed));
    _label(cv, 'F', Offset(cx + 34, 107), kRed, fs: 10);
    cv.drawLine(const Offset(178, 52), const Offset(178, 146), _pw(w: 1, c: kBlue));
    _label(cv, 'DEPTH', const Offset(198, 98), kBlue, fs: 9);
    _arrow(cv, Offset(cx - 22, 146), Offset(cx - 22, 52), _pw(w: 2, c: Colors.white38));
    _label(cv, 'G200/G201 — Furação Heidenhain', const Offset(140, 16), kAmber, fs: 10, bold: true);
    _label(cv, 'Parâmetros: SCET, DEPTH, F', const Offset(140, 168), Colors.white54, fs: 9);
  }
  @override bool shouldRepaint(_) => false;
}
