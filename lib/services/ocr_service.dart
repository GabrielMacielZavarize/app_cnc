import 'package:flutter/foundation.dart';

// ── Em web o ML Kit não existe — importamos condicionalmente ──
// ignore: depend_on_referenced_packages
import 'ocr_service_mobile.dart'
    if (dart.library.html) 'ocr_service_stub.dart' as _impl;

// ─────────────────────────────────────────────────────────────
// RESULTADO DO OCR
// ─────────────────────────────────────────────────────────────
class OcrResultado {
  /// Texto completo extraído da imagem
  final String textoCompleto;

  /// Alarmes CNC detectados (ex: ["414", "PS0010", "700"])
  final List<String> alarmes;

  /// Códigos G/M detectados (ex: ["G00", "M06", "G54"])
  final List<String> codigosCnc;

  /// Sugestão de busca montada automaticamente
  final String? sugestaoBusca;

  const OcrResultado({
    required this.textoCompleto,
    required this.alarmes,
    required this.codigosCnc,
    this.sugestaoBusca,
  });

  bool get temResultado => textoCompleto.isNotEmpty;
  bool get temAlarme => alarmes.isNotEmpty;
  bool get temCodigo => codigosCnc.isNotEmpty;
}

// ─────────────────────────────────────────────────────────────
// SERVIÇO PRINCIPAL (fachada — chama implementação correta)
// ─────────────────────────────────────────────────────────────
class OcrService {
  OcrService._();
  static final OcrService instance = OcrService._();

  /// Reconhece texto em uma foto (path do arquivo).
  /// Retorna OcrResultado vazio em web ou se falhar.
  Future<OcrResultado> reconhecer(String imagemPath) async {
    if (kIsWeb) return _vazio();
    try {
      final texto = await _impl.reconhecerTexto(imagemPath);
      return _analisar(texto);
    } catch (_) {
      return _vazio();
    }
  }

  // ── Analisa o texto bruto e extrai padrões CNC ────────────
  OcrResultado _analisar(String texto) {
    if (texto.trim().isEmpty) return _vazio();

    final alarmes   = <String>{};
    final codigos   = <String>{};

    // ── Padrões de alarme Fanuc: 3-4 dígitos sozinhos ────────
    final reAlarme = RegExp(r'\b(\d{3,4})\b');
    for (final m in reAlarme.allMatches(texto)) {
      final n = int.tryParse(m.group(1)!);
      if (n != null && _ehNumeroAlarme(n)) alarmes.add(m.group(1)!);
    }

    // ── Alarmes Fanuc com prefixo PS/OT/SV/SP/IO ─────────────
    final rePrefixo = RegExp(r'\b(PS|OT|SV|SP|IO|DS|MC|BG|SR)\s*(\d{4})\b', caseSensitive: false);
    for (final m in rePrefixo.allMatches(texto)) {
      alarmes.add('${m.group(1)!.toUpperCase()}${m.group(2)}');
    }

    // ── Alarmes Siemens: "Alarm XXXXX" ───────────────────────
    final reSiemens = RegExp(r'[Aa]larm\s+(\d{4,6})');
    for (final m in reSiemens.allMatches(texto)) {
      alarmes.add('Alarm ${m.group(1)}');
    }

    // ── Códigos G/M ──────────────────────────────────────────
    final reCodigo = RegExp(r'\b([GM]\d{1,3}(?:\.\d)?)\b', caseSensitive: false);
    for (final m in reCodigo.allMatches(texto)) {
      codigos.add(m.group(1)!.toUpperCase());
    }

    // ── Monta sugestão de busca ───────────────────────────────
    String? sugestao;
    if (alarmes.isNotEmpty) {
      sugestao = 'Alarme ${alarmes.first}';
    } else if (codigos.isNotEmpty) {
      sugestao = 'O que faz ${codigos.first}';
    }

    return OcrResultado(
      textoCompleto: texto.trim(),
      alarmes: alarmes.toList(),
      codigosCnc: codigos.take(10).toList(),
      sugestaoBusca: sugestao,
    );
  }

  // ── Faixas numéricas conhecidas de alarmes Fanuc ─────────
  bool _ehNumeroAlarme(int n) {
    return (n >= 1 && n <= 999)     // Fanuc geral
        || (n >= 1000 && n <= 1999) // Fanuc eixo/servo
        || (n >= 2000 && n <= 2999) // Fanuc I/O
        || (n >= 3000 && n <= 3999) // Fanuc programa
        || (n >= 4000 && n <= 5999) // Fanuc sistema
        || (n >= 7000 && n <= 7999); // Macro B
  }

  OcrResultado _vazio() => const OcrResultado(
    textoCompleto: '', alarmes: [], codigosCnc: []);
}
