import 'package:flutter/foundation.dart';

// Importação condicional: mobile usa ML Kit, web usa stub
import 'image_labeling_mobile.dart'
    if (dart.library.html) 'image_labeling_stub.dart' as _impl;

// ─────────────────────────────────────────────────────────────
// RESULTADO DA REDE NEURAL
// ─────────────────────────────────────────────────────────────
class LabelNeural {
  final String labelOriginal;   // label em inglês do ML Kit
  final String labelCnc;        // tradução CNC em português
  final double confianca;       // 0.0 a 1.0
  final String emoji;
  final String? tipoAnalise;    // sugestão de tipo: erro/peca/ferramenta/parametros

  const LabelNeural({
    required this.labelOriginal,
    required this.labelCnc,
    required this.confianca,
    required this.emoji,
    this.tipoAnalise,
  });

  String get porcentagem => '${(confianca * 100).toStringAsFixed(0)}%';
}

class ResultadoNeural {
  final List<LabelNeural> labels;
  final String? tipoAnaliseRecomendado;   // tipo que o app deve selecionar automaticamente
  final String? descricaoGeral;           // resumo do que a rede detectou

  const ResultadoNeural({
    required this.labels,
    this.tipoAnaliseRecomendado,
    this.descricaoGeral,
  });

  bool get temResultado => labels.isNotEmpty;
}

// ─────────────────────────────────────────────────────────────
// MAPEAMENTO: labels do MobileNet → contexto CNC
// ─────────────────────────────────────────────────────────────
const _mapaCnc = <String, Map<String, String>>{
  // Ferramentas e insertos
  'cutting tool':     {'pt': 'Ferramenta de Corte', 'emoji': '🔪', 'tipo': 'ferramenta'},
  'drill bit':        {'pt': 'Broca',               'emoji': '🔩', 'tipo': 'ferramenta'},
  'drill':            {'pt': 'Broca/Furação',        'emoji': '🔩', 'tipo': 'ferramenta'},
  'milling cutter':   {'pt': 'Fresa',               'emoji': '⚙️', 'tipo': 'ferramenta'},
  'lathe':            {'pt': 'Torno CNC',            'emoji': '🏭', 'tipo': 'peca'},
  'wrench':           {'pt': 'Chave/Ferramenta',     'emoji': '🔧', 'tipo': 'ferramenta'},
  'screwdriver':      {'pt': 'Ferramenta Manual',    'emoji': '🔧', 'tipo': 'ferramenta'},
  'tool':             {'pt': 'Ferramenta',           'emoji': '🔧', 'tipo': 'ferramenta'},
  'blade':            {'pt': 'Lâmina/Inserto',       'emoji': '🔪', 'tipo': 'ferramenta'},

  // Peças e materiais
  'metal':            {'pt': 'Metal/Liga Metálica',  'emoji': '⚙️', 'tipo': 'peca'},
  'steel':            {'pt': 'Aço',                  'emoji': '🔩', 'tipo': 'peca'},
  'aluminum':         {'pt': 'Alumínio',             'emoji': '⚙️', 'tipo': 'peca'},
  'iron':             {'pt': 'Ferro/Aço',            'emoji': '🔩', 'tipo': 'peca'},
  'bronze':           {'pt': 'Bronze/Latão',         'emoji': '🟡', 'tipo': 'peca'},
  'screw':            {'pt': 'Parafuso/Rosca',       'emoji': '🔩', 'tipo': 'peca'},
  'bolt':             {'pt': 'Parafuso',             'emoji': '🔩', 'tipo': 'peca'},
  'nut':              {'pt': 'Porca',                'emoji': '🔩', 'tipo': 'peca'},
  'washer':           {'pt': 'Arruela',              'emoji': '⭕', 'tipo': 'peca'},
  'gear':             {'pt': 'Engrenagem',           'emoji': '⚙️', 'tipo': 'peca'},
  'shaft':            {'pt': 'Eixo',                 'emoji': '➡️', 'tipo': 'peca'},
  'cylinder':         {'pt': 'Cilindro/Bucha',       'emoji': '🔵', 'tipo': 'peca'},
  'pipe':             {'pt': 'Tubo/Cano',            'emoji': '⬜', 'tipo': 'peca'},
  'flange':           {'pt': 'Flange',               'emoji': '⚙️', 'tipo': 'peca'},
  'part':             {'pt': 'Peça Usinada',         'emoji': '⚙️', 'tipo': 'peca'},
  'product':          {'pt': 'Peça/Produto',         'emoji': '📦', 'tipo': 'peca'},

  // Máquinas CNC
  'machine':          {'pt': 'Máquina CNC',          'emoji': '🏭', 'tipo': 'geral'},
  'machinery':        {'pt': 'Maquinário',           'emoji': '🏭', 'tipo': 'geral'},
  'manufacturing':    {'pt': 'Manufatura CNC',       'emoji': '🏭', 'tipo': 'geral'},
  'factory':          {'pt': 'Ambiente Fabril',      'emoji': '🏭', 'tipo': 'geral'},
  'industry':         {'pt': 'Industrial',           'emoji': '🏭', 'tipo': 'geral'},
  'motor':            {'pt': 'Motor/Spindle',        'emoji': '⚡', 'tipo': 'geral'},
  'engine':           {'pt': 'Motor',                'emoji': '⚡', 'tipo': 'geral'},
  'pump':             {'pt': 'Bomba/Fluido',         'emoji': '💧', 'tipo': 'geral'},

  // Alarmes / Telas
  'screen':           {'pt': 'Tela do CNC',          'emoji': '🖥️', 'tipo': 'erro'},
  'display':          {'pt': 'Painel/Display',       'emoji': '🖥️', 'tipo': 'erro'},
  'monitor':          {'pt': 'Monitor CNC',          'emoji': '🖥️', 'tipo': 'erro'},
  'text':             {'pt': 'Texto/Alarme',         'emoji': '📋', 'tipo': 'erro'},
  'number':           {'pt': 'Código/Número',        'emoji': '🔢', 'tipo': 'erro'},
  'signage':          {'pt': 'Sinalização/Alarme',   'emoji': '⚠️', 'tipo': 'erro'},
  'warning':          {'pt': 'Aviso/Alarme',         'emoji': '⚠️', 'tipo': 'erro'},
  'error':            {'pt': 'Erro/Alarme',          'emoji': '❌', 'tipo': 'erro'},

  // Medição e qualidade
  'caliper':          {'pt': 'Paquímetro',           'emoji': '📏', 'tipo': 'parametros'},
  'micrometer':       {'pt': 'Micrômetro',           'emoji': '📏', 'tipo': 'parametros'},
  'ruler':            {'pt': 'Régua/Medição',        'emoji': '📏', 'tipo': 'parametros'},
  'gauge':            {'pt': 'Instrumento de Medição','emoji': '📐', 'tipo': 'parametros'},
  'measurement':      {'pt': 'Medição/Inspeção',     'emoji': '📐', 'tipo': 'parametros'},

  // Superfícies e defeitos
  'surface':          {'pt': 'Superfície',           'emoji': '🔍', 'tipo': 'parametros'},
  'texture':          {'pt': 'Textura Superficial',  'emoji': '🔍', 'tipo': 'parametros'},
  'crack':            {'pt': 'Trinca/Defeito',       'emoji': '❌', 'tipo': 'peca'},
  'rust':             {'pt': 'Oxidação/Ferrugem',    'emoji': '🟫', 'tipo': 'peca'},
  'chip':             {'pt': 'Cavaco',               'emoji': '🌀', 'tipo': 'parametros'},
  'debris':           {'pt': 'Resíduo/Cavaco',       'emoji': '🌀', 'tipo': 'parametros'},

  // Código/Programa
  'code':             {'pt': 'Código CNC',           'emoji': '💻', 'tipo': 'programa'},
  'document':         {'pt': 'Documento/Programa',   'emoji': '📄', 'tipo': 'programa'},
  'paper':            {'pt': 'Folha/Programa',       'emoji': '📄', 'tipo': 'programa'},
};

// ─────────────────────────────────────────────────────────────
// SERVIÇO PRINCIPAL
// ─────────────────────────────────────────────────────────────
class ImageLabelingService {
  ImageLabelingService._();
  static final ImageLabelingService instance = ImageLabelingService._();

  Future<ResultadoNeural> classificar(String imagemPath) async {
    if (kIsWeb) return const ResultadoNeural(labels: []);
    try {
      // Chama implementação mobile (ML Kit MobileNet)
      final rawLabels = await _impl.classificarImagem(imagemPath);
      return _processar(rawLabels);
    } catch (_) {
      return const ResultadoNeural(labels: []);
    }
  }

  // ── Converte labels brutos para contexto CNC ──────────────
  ResultadoNeural _processar(List<Map<String, dynamic>> rawLabels) {
    if (rawLabels.isEmpty) return const ResultadoNeural(labels: []);

    final labels = <LabelNeural>[];
    final tiposDetectados = <String, double>{};

    for (final raw in rawLabels) {
      final texto    = (raw['label'] as String? ?? '').toLowerCase();
      final conf     = (raw['confidence'] as double? ?? 0.0);
      if (conf < 0.25) continue;  // ignora confiança < 25%

      // Busca mapeamento CNC
      Map<String, String>? mapa;
      String? matchKey;
      for (final entry in _mapaCnc.entries) {
        if (texto.contains(entry.key) || entry.key.contains(texto)) {
          mapa = entry.value;
          matchKey = entry.key;
          break;
        }
      }

      final labelCnc   = mapa?['pt']    ?? _traduzirGenerico(texto);
      final emoji      = mapa?['emoji'] ?? '🔍';
      final tipo       = mapa?['tipo'];

      labels.add(LabelNeural(
        labelOriginal: texto,
        labelCnc:      labelCnc,
        confianca:     conf,
        emoji:         emoji,
        tipoAnalise:   tipo,
      ));

      if (tipo != null) {
        tiposDetectados[tipo] = (tiposDetectados[tipo] ?? 0) + conf;
      }
    }

    if (labels.isEmpty) return const ResultadoNeural(labels: []);

    // Tipo de análise recomendado = o que somou maior confiança
    String? tipoRecom;
    if (tiposDetectados.isNotEmpty) {
      tipoRecom = tiposDetectados.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
    }

    // Descrição geral para o Gemini
    final topLabels = labels.take(3).map((l) => l.labelCnc).join(', ');
    final descricao = 'Rede neural detectou: $topLabels';

    return ResultadoNeural(
      labels: labels,
      tipoAnaliseRecomendado: tipoRecom,
      descricaoGeral: descricao,
    );
  }

  String _traduzirGenerico(String texto) {
    // Tradução básica de termos comuns não mapeados
    final trad = {
      'object': 'Objeto',
      'material': 'Material',
      'equipment': 'Equipamento',
      'component': 'Componente',
      'device': 'Dispositivo',
      'hardware': 'Componente Mecânico',
      'round': 'Forma Circular',
      'circular': 'Forma Circular',
      'rectangular': 'Forma Retangular',
      'flat': 'Superfície Plana',
      'silver': 'Metal/Aço',
      'gray': 'Metal/Alumínio',
      'black': 'Peça Escura',
    };
    for (final e in trad.entries) {
      if (texto.contains(e.key)) return e.value;
    }
    return texto; // retorna em inglês se não encontrar
  }
}
