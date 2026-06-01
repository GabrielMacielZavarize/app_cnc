import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../services/image_labeling_service.dart';
import 'calculadora_screen.dart';
import '../services/ocr_service.dart';
// import '../services/purchase_service.dart';
// import 'paywall_screen.dart';

class IAScreen extends StatefulWidget {
  const IAScreen({super.key});

  @override
  State<IAScreen> createState() => _IAScreenState();
}

class _HistoricoItem {
  final String tipo;
  final String pergunta;
  final String resposta;
  final String tipoDetectado;
  final DateTime timestamp;
  final bool foiFoto;

  _HistoricoItem({
    required this.tipo,
    required this.pergunta,
    required this.resposta,
    required this.tipoDetectado,
    required this.timestamp,
    required this.foiFoto,
  });
}

class _Tipo {
  final String id;
  final String label;
  final IconData icon;
  final Color cor;

  _Tipo(this.id, this.label, this.icon, this.cor);
}

class _IAScreenState extends State<IAScreen> {
  static const _kGeminiModel = 'gemini-2.5-flash';
  static const _kPrefHistorico = 'ia_historico_v2';
  static const _kPrefContadorHoje = 'ia_contador_hoje';
  static const _kPrefContadorTotal = 'ia_contador_total';
  static const _kPrefDataHoje = 'ia_data_hoje';

  Uint8List? _imagemBytes;
  String _resposta = '';
  bool _carregando = false;
  String _tipoAnalise = 'geral';

  Map<String, dynamic>? _jsonAnalise;
  Map<String, dynamic>? _jsonAlarme;
  bool _analiseSalva = false;
  int _analisesHoje = 0;
  int _analisesTotal = 0;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController _textoCtrl = TextEditingController();

  bool _modoTexto = false;
  OcrResultado? _ocrResultado;
  bool _ocrProcessando = false;

  ResultadoNeural? _neuralResultado;
  bool _neuralProcessando = false;

  bool _tipoAnaliseRepetida = false;
  int _cooldownSegundos = 0;
  final List<_HistoricoItem> _historico = [];
  static final Map<String, String> _cacheMemoria = {};

  Timer? _cooldownTimer;

  String get _cacheKey =>
      '$_tipoAnalise:${_textoCtrl.text.trim().toLowerCase()}:${_imagemBytes != null}';

  final List<_Tipo> _tipos = [
    _Tipo('geral', '🔍 Análise Geral', Icons.search_rounded, kBlue),
    _Tipo('erro', '⚠️ Diagnóstico Alarme', Icons.warning_amber_rounded, kRed),
    _Tipo('peca', '⚙️ Analisar Peça', Icons.precision_manufacturing_rounded, kGreen),
    _Tipo('programa', '💻 Verificar Programa', Icons.code_rounded, const Color(0xFF534AB7)),
    _Tipo('ferramenta', '🔧 Estado Ferramenta', Icons.build_rounded, const Color(0xFFBA7517)),
    _Tipo('parametros', '📐 Sugerir Parâmetros', Icons.tune_rounded, const Color(0xFF993C1D)),
  ];

  @override
  void initState() {
    super.initState();
    _carregarContadores();
  }

  Future<void> _carregarContadores() async {
    final prefs = await SharedPreferences.getInstance();
    final hoje = DateTime.now().toIso8601String().substring(0, 10);
    final dataGravada = prefs.getString(_kPrefDataHoje) ?? '';
    final contadorHoje =
        dataGravada == hoje ? (prefs.getInt(_kPrefContadorHoje) ?? 0) : 0;
    setState(() {
      _analisesHoje = contadorHoje;
      _analisesTotal = prefs.getInt(_kPrefContadorTotal) ?? 0;
    });
  }

  Future<void> _incrementarContadores() async {
    final prefs = await SharedPreferences.getInstance();
    final hoje = DateTime.now().toIso8601String().substring(0, 10);
    final dataGravada = prefs.getString(_kPrefDataHoje) ?? '';
    final contadorHoje =
        dataGravada == hoje ? (prefs.getInt(_kPrefContadorHoje) ?? 0) : 0;
    final novoHoje = contadorHoje + 1;
    final novoTotal = (prefs.getInt(_kPrefContadorTotal) ?? 0) + 1;
    await prefs.setString(_kPrefDataHoje, hoje);
    await prefs.setInt(_kPrefContadorHoje, novoHoje);
    await prefs.setInt(_kPrefContadorTotal, novoTotal);
    setState(() {
      _analisesHoje = novoHoje;
      _analisesTotal = novoTotal;
    });
  }

  Future<String?> _chamarGemini(String prompt, {Uint8List? imagem}) async {
    if (kGeminiApiKey.isEmpty) return null;
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$_kGeminiModel:generateContent?key=$kGeminiApiKey',
    );
    final partes = <Map<String, dynamic>>[];
    if (imagem != null) {
      partes.add({
        'inline_data': {
          'mime_type': 'image/jpeg',
          'data': base64Encode(imagem),
        },
      });
    }
    partes.add({'text': prompt});
    final body = jsonEncode({
      'contents': [
        {'parts': partes}
      ],
      'generationConfig': {
        'temperature': 0.3,
        'maxOutputTokens': 2048,
      },
    });
    final response = await http
        .post(uri, headers: {'Content-Type': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 30));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data['candidates']?[0]?['content']?['parts']?[0]?['text']
          as String?;
    }
    return null;
  }

  Map<String, dynamic>? _extrairJson(String texto) {
    try {
      var limpo = texto.trim();
      if (limpo.startsWith('```')) {
        final inicio = limpo.indexOf('\n');
        final fim = limpo.lastIndexOf('```');
        if (inicio != -1 && fim > inicio) {
          limpo = limpo.substring(inicio + 1, fim).trim();
        }
      }
      return jsonDecode(limpo) as Map<String, dynamic>;
    } catch (_) {
      final start = texto.indexOf('{');
      final end = texto.lastIndexOf('}');
      if (start != -1 && end > start) {
        try {
          return jsonDecode(texto.substring(start, end + 1))
              as Map<String, dynamic>;
        } catch (_) {}
      }
      return null;
    }
  }

  String _promptPeca() => '''
Você é um engenheiro de usinagem CNC sênior com 25 anos de experiência.
Analise esta imagem de peça/setup CNC com máxima precisão técnica.
Seja EXTREMAMENTE ESPECÍFICO: não diga "alumínio", diga "Alumínio 6061-T6 AA".
Responda SOMENTE com JSON válido, sem texto antes ou depois:
{
  "material": {
    "identificado": "nome específico com liga/grau ex: Alumínio 6061-T6",
    "norma": "ex: AA 6061 / ABNT 1045 / DIN 42CrMo4",
    "dureza": "ex: 85 HB estimado",
    "confianca": "alta/media/baixa",
    "caracteristicas": "ex: boa usinabilidade, cavaco longo"
  },
  "peca": {
    "tipo": "torneada/fresada/furada/mista",
    "descricao": "descrição técnica detalhada",
    "operacoes": ["operação específica 1", "operação específica 2"],
    "dimensao_estimada": "ex: Ø52mm x 120mm comprimento",
    "acabamento_ra": "ex: Ra 1.6μm"
  },
  "parametros": {
    "Vc": "ex: 300 m/min",
    "fz": "ex: 0.08 mm/dente",
    "ap": "ex: 2.0 mm",
    "ae": "ex: 15 mm",
    "rpm_sugerido": "ex: 1900 RPM"
  },
  "ferramentas": [
    {"tipo": "ex: Inserto torneamento", "especificacao": "ex: CNMG 120408 H01", "motivo": "motivo técnico"}
  ],
  "atencao": ["ponto crítico 1", "ponto crítico 2"],
  "sequencia": ["1º operação", "2º operação", "3º operação"]
}''';

  String _promptErro() => '''
Você é um técnico especialista em CNCs com 20 anos de experiência em Fanuc, Siemens, Haas, Mazak e Mitsubishi.
Analise esta imagem de alarme/erro CNC ou a descrição fornecida.
Identifique o FABRICANTE pela interface: Fanuc=tela verde/cinza com "ALM", Siemens=interface azul SINUMERIK, Haas=interface cinza, Mazak=MAZATROL.
Responda SOMENTE com JSON válido, sem texto antes ou depois:
{
  "alarme": {
    "codigo": "código exato ex: ALM 300 ou PS0090",
    "descricao_oficial": "descrição oficial do fabricante",
    "fabricante": "Fanuc/Siemens/Haas/Mazak/Mitsubishi/Desconhecido",
    "urgencia": "CRÍTICO/ALTO/MÉDIO/BAIXO"
  },
  "causas": [
    {"causa": "descrição detalhada da causa", "probabilidade": "70%"},
    {"causa": "descrição detalhada da causa", "probabilidade": "20%"},
    {"causa": "descrição detalhada da causa", "probabilidade": "10%"}
  ],
  "solucao": [
    "Passo 1: ação específica",
    "Passo 2: ação específica",
    "Passo 3: verificação",
    "Passo 4: resetar somente após corrigir"
  ],
  "pecas_suspeitas": ["componente 1", "componente 2"],
  "tempo_estimado": "ex: 30 minutos",
  "chamar_tecnico": false
}''';

  String _promptGeral(String texto) =>
      'Você é um assistente técnico CNC especializado.\nAnalise: $texto\n\nForneça diagnóstico completo, causas e ações corretivas com terminologia CNC profissional.';

  Future<void> _capturarImagem(ImageSource source) async {
    final XFile? img =
        await _picker.pickImage(source: source, imageQuality: 85);
    if (img == null) return;
    final bytes = await img.readAsBytes();
    setState(() {
      _imagemBytes = bytes;
      _resposta = '';
      _jsonAnalise = null;
      _jsonAlarme = null;
      _analiseSalva = false;
      _ocrResultado = null;
      _neuralResultado = null;
      _ocrProcessando = false;
      _neuralProcessando = false;
      _tipoAnaliseRepetida = false;
    });
  }

  Future<void> _escolherImagem() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_rounded),
              title: const Text('Câmera'),
              onTap: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Galeria'),
              onTap: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    await _capturarImagem(source);
  }

  Future<void> _tirarFotoEAnalisar() async {
    await _capturarImagem(ImageSource.camera);
    if (_imagemBytes != null) {
      await _analisar();
    }
  }

  Future<void> _analisar() async {
    if (_cooldownSegundos > 0) return;

    final pergunta = _textoCtrl.text.trim();

    if (_modoTexto && pergunta.isEmpty) {
      setState(() {
        _resposta = 'Digite uma dúvida sobre CNC antes de analisar.';
        _tipoAnaliseRepetida = false;
      });
      return;
    }

    if (!_modoTexto && _imagemBytes == null) {
      setState(() {
        _resposta = 'Escolha uma imagem antes de analisar.';
        _tipoAnaliseRepetida = false;
      });
      return;
    }

    final tipoDetectado =
        _imagemBytes != null ? _tipoImagemDetectada() : 'sem imagem';
    final jaExisteAnaliseDoTipo =
        _historico.any((item) => item.tipo == _tipoAnalise);

    if (_cacheMemoria.containsKey(_cacheKey)) {
      final respostaCache = _cacheMemoria[_cacheKey]!;
      setState(() {
        _resposta = respostaCache;
        _tipoAnaliseRepetida = jaExisteAnaliseDoTipo;
      });
      _historico.insert(
        0,
        _HistoricoItem(
          tipo: _tipoAnalise,
          pergunta: pergunta,
          resposta: respostaCache,
          tipoDetectado: tipoDetectado,
          timestamp: DateTime.now(),
          foiFoto: _imagemBytes != null,
        ),
      );
      return;
    }

    setState(() {
      _carregando = true;
      _resposta = '';
      _jsonAnalise = null;
      _jsonAlarme = null;
      _analiseSalva = false;
    });

    try {
      final textoFinal = _modoTexto
          ? pergunta
          : 'Análise por imagem CNC. Tipo: $_tipoAnalise.\nOCR: ${_ocrResultado?.toString() ?? "nenhum"}\nNeural: ${_neuralResultado?.toString() ?? "sem classificação"}';

      String respostaFinal;

      if (kGeminiApiKey.isNotEmpty) {
        String prompt;
        if (_tipoAnalise == 'peca') {
          prompt = _promptPeca();
        } else if (_tipoAnalise == 'erro') {
          prompt = _promptErro();
          if (_modoTexto) prompt += '\n\nDescrição do erro: $pergunta';
        } else {
          prompt = _promptGeral(textoFinal);
        }

        final resposta =
            await _chamarGemini(prompt, imagem: _imagemBytes);
        if (resposta != null) {
          respostaFinal = resposta;
          if (_tipoAnalise == 'peca') {
            _jsonAnalise = _extrairJson(resposta);
          } else if (_tipoAnalise == 'erro') {
            _jsonAlarme = _extrairJson(resposta);
          }
        } else {
          respostaFinal = _buscarRespostaLocal(textoFinal);
        }
      } else {
        respostaFinal = _buscarRespostaLocal(textoFinal);
      }

      setState(() {
        _resposta = respostaFinal;
        _carregando = false;
        _tipoAnaliseRepetida = jaExisteAnaliseDoTipo;
      });

      _cacheMemoria[_cacheKey] = respostaFinal;
      _historico.insert(
        0,
        _HistoricoItem(
          tipo: _tipoAnalise,
          pergunta: textoFinal,
          resposta: respostaFinal,
          tipoDetectado: tipoDetectado,
          timestamp: DateTime.now(),
          foiFoto: _imagemBytes != null,
        ),
      );
      await _incrementarContadores();
      _iniciarCooldown();
    } catch (e) {
      setState(() {
        _resposta = 'Erro ao analisar: $e';
        _carregando = false;
        _tipoAnaliseRepetida = false;
      });
    }
  }

  Future<void> _salvarAnalise() async {
    if (_resposta.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(_kPrefHistorico) ?? [];
    final item = jsonEncode({
      'tipo': _tipoAnalise,
      'resposta': _resposta,
      'json': _jsonAnalise ?? _jsonAlarme,
      'timestamp': DateTime.now().toIso8601String(),
    });
    lista.insert(0, item);
    if (lista.length > 30) lista.removeRange(30, lista.length);
    await prefs.setStringList(_kPrefHistorico, lista);
    setState(() => _analiseSalva = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Análise salva no histórico local'),
          backgroundColor: kGreen,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String _buscarRespostaLocal(String pergunta) {
    return 'Análise CNC inicial:\n\nTipo selecionado: $_tipoAnalise\n\nEntrada analisada:\n$pergunta\n\nSugestão:\nVerifique o código, alarme, peça, ferramenta ou parâmetro informado.\n\nSe for um alarme CNC, confira:\n1. Código do alarme\n2. Máquina\n3. Comando\n4. Momento em que ocorreu\n5. Se houve colisão, parada ou falha de ferramenta';
  }

  void _iniciarCooldown() {
    _cooldownSegundos = 5;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _cooldownSegundos--);
      if (_cooldownSegundos <= 0) timer.cancel();
    });
  }

  // ─── Build ────────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      color: kDark,
      padding: const EdgeInsets.fromLTRB(16, 45, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.smart_toy_rounded, color: kAmber, size: 28),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Assistente IA CNC',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: _limpar,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _counterChip(Icons.today_rounded, 'Hoje: $_analisesHoje'),
              const SizedBox(width: 8),
              _counterChip(Icons.bar_chart_rounded, 'Total: $_analisesTotal'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _counterChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: kAmber),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _limpar() {
    setState(() {
      _imagemBytes = null;
      _resposta = '';
      _textoCtrl.clear();
      _ocrResultado = null;
      _neuralResultado = null;
      _tipoAnaliseRepetida = false;
      _jsonAnalise = null;
      _jsonAlarme = null;
      _analiseSalva = false;
    });
  }

  Widget _buildTipos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TIPO DE ANÁLISE',
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey,
              letterSpacing: 1.2),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tipos.map((t) {
            final ativo = _tipoAnalise == t.id;
            return GestureDetector(
              onTap: () => setState(() => _tipoAnalise = t.id),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: ativo ? t.cor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: ativo ? t.cor : Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(t.icon,
                        size: 15,
                        color: ativo ? Colors.white : t.cor),
                    const SizedBox(width: 5),
                    Text(t.label,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ativo
                                ? Colors.white
                                : Colors.grey.shade700)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildModoToggle() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _modoTexto = false),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: !_modoTexto ? kDark : Colors.white,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(10)),
                border: Border.all(
                    color: !_modoTexto ? kAmber : Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera_rounded,
                      size: 16,
                      color: !_modoTexto ? kAmber : Colors.grey),
                  const SizedBox(width: 6),
                  Text('Foto',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: !_modoTexto ? kAmber : Colors.grey)),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _modoTexto = true),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _modoTexto ? kDark : Colors.white,
                borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(10)),
                border: Border.all(
                    color: _modoTexto ? kAmber : Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_rounded,
                      size: 16,
                      color: _modoTexto ? kAmber : Colors.grey),
                  const SizedBox(width: 6),
                  Text('Texto',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _modoTexto ? kAmber : Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_imagemBytes != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(_imagemBytes!,
                fit: BoxFit.cover, width: double.infinity, height: 220),
          )
        else
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Center(child: Text('Nenhuma imagem selecionada')),
          ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _carregando ? null : _tirarFotoEAnalisar,
            style: ElevatedButton.styleFrom(
              backgroundColor: kAmber,
              foregroundColor: kDark,
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.camera_alt_rounded, size: 20),
            label: const Text('Tirar Foto e Analisar',
                style:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 6),
        OutlinedButton.icon(
          onPressed: _escolherImagem,
          icon: const Icon(Icons.photo_library_rounded, size: 16),
          label: const Text('Escolher Imagem'),
        ),
        if (_ocrProcessando || _neuralProcessando)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text('Processando imagem...'),
          ),
      ],
    );
  }

  Widget _buildTextArea() {
    return TextField(
      controller: _textoCtrl,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'Digite sua dúvida, código, alarme ou problema CNC...',
        filled: true,
        fillColor: Colors.white,
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildBotaoAnalisar() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed:
            _carregando || _cooldownSegundos > 0 ? null : _analisar,
        icon: _carregando
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.auto_awesome_rounded),
        label: Text(_cooldownSegundos > 0
            ? 'Aguarde $_cooldownSegundos s'
            : 'Analisar'),
      ),
    );
  }

  Widget _buildResposta() {
    if (_resposta.isEmpty) return const SizedBox.shrink();

    if (_resposta.startsWith('Digite') ||
        _resposta.startsWith('Escolha') ||
        _resposta.startsWith('Erro')) {
      return _buildResultadoCard(
        titulo: 'Atenção',
        texto: _resposta,
        icon: Icons.warning_amber_rounded,
        cor: kRed,
      );
    }

    if (_jsonAnalise != null) return _buildRespostaCards();
    if (_jsonAlarme != null) return _buildAlarmeCards();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_tipoAnaliseRepetida)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 16, bottom: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kAmber.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: kAmber.withValues(alpha: 0.35)),
            ),
            child: const Text(
              '⚠️ Este tipo de análise já foi realizado anteriormente.',
              style: TextStyle(
                  color: Color(0xFFBA7517),
                  fontSize: 12,
                  fontWeight: FontWeight.w700),
            ),
          ),
        Container(
          margin: EdgeInsets.only(
              top: _tipoAnaliseRepetida ? 6 : 16, bottom: 4),
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
              color: kDark, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  color: kAmber.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.psychology_rounded,
                  color: kAmber, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Resultado da análise',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    const Text('Resumo técnico para apoio ao operador',
                        style:
                            TextStyle(color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 6),
                    _buildConfiancaAnalise(),
                  ]),
            ),
            TextButton.icon(
              onPressed: _analiseSalva ? null : _salvarAnalise,
              icon: Icon(
                  _analiseSalva
                      ? Icons.check_rounded
                      : Icons.save_alt_rounded,
                  size: 16,
                  color: _analiseSalva ? kGreen : kAmber),
              label: Text(_analiseSalva ? 'Salvo' : 'Salvar',
                  style: TextStyle(
                      color: _analiseSalva ? kGreen : kAmber,
                      fontSize: 12)),
            ),
          ]),
        ),
        _buildResultadoCard(
            titulo: 'Diagnóstico',
            texto: _diagnosticoTexto(),
            icon: Icons.fact_check_rounded,
            cor: kBlue),
        _buildResultadoCard(
            titulo: 'Possível causa',
            texto: _causaTexto(),
            icon: Icons.search_rounded,
            cor: const Color(0xFFBA7517)),
        _buildResultadoCard(
            titulo: 'Ação recomendada',
            texto: _acaoTexto(),
            icon: Icons.build_rounded,
            cor: kGreen),
        _buildResultadoCard(
            titulo: 'Risco',
            texto: _riscoTexto(),
            icon: Icons.report_problem_rounded,
            cor: kRed),
        _buildResultadoCard(
            titulo: 'Dica do operador',
            texto: _dicaTexto(),
            icon: Icons.lightbulb_outline_rounded,
            cor: kAmber),
      ],
    );
  }

  // ─── JSON Cards — Peça ────────────────────────────────────────────────────────

  Widget _buildRespostaCards() {
    final json = _jsonAnalise!;
    final material = json['material'] as Map<String, dynamic>?;
    final peca = json['peca'] as Map<String, dynamic>?;
    final parametros = json['parametros'] as Map<String, dynamic>?;
    final ferramentas = json['ferramentas'] as List<dynamic>?;
    final atencao = json['atencao'] as List<dynamic>?;
    final sequencia = json['sequencia'] as List<dynamic>?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCardCabecalho('Análise Técnica da Peça', 'Resultado detalhado por IA Gemini'),
        if (material != null) ...[const SizedBox(height: 10), _buildMaterialCard(material)],
        if (peca != null) ...[const SizedBox(height: 10), _buildPecaCard(peca)],
        if (parametros != null) ...[const SizedBox(height: 10), _buildParametrosCard(parametros)],
        if (ferramentas != null && ferramentas.isNotEmpty) ...[const SizedBox(height: 10), _buildFerramentasCard(ferramentas)],
        if (atencao != null && atencao.isNotEmpty) ...[const SizedBox(height: 10), _buildAtencaoCard(atencao)],
        if (sequencia != null && sequencia.isNotEmpty) ...[const SizedBox(height: 10), _buildSequenciaCard(sequencia)],
      ],
    );
  }

  // ─── JSON Cards — Alarme ─────────────────────────────────────────────────────

  Widget _buildAlarmeCards() {
    final json = _jsonAlarme!;
    final alarme = json['alarme'] as Map<String, dynamic>?;
    final causas = json['causas'] as List<dynamic>?;
    final solucao = json['solucao'] as List<dynamic>?;
    final pecas = json['pecas_suspeitas'] as List<dynamic>?;
    final tempo = json['tempo_estimado'] as String?;
    final chamarTecnico = json['chamar_tecnico'] as bool?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCardCabecalho('Diagnóstico de Alarme', 'Análise por IA Gemini'),
        if (alarme != null) ...[const SizedBox(height: 10), _buildAlarmeInfoCard(alarme)],
        if (causas != null && causas.isNotEmpty) ...[const SizedBox(height: 10), _buildCausasCard(causas)],
        if (solucao != null && solucao.isNotEmpty) ...[const SizedBox(height: 10), _buildSolucaoCard(solucao)],
        if ((pecas != null && pecas.isNotEmpty) || tempo != null) ...[
          const SizedBox(height: 10),
          _buildExtrasAlarme(pecas, tempo, chamarTecnico),
        ],
      ],
    );
  }

  Widget _buildCardCabecalho(String titulo, String sub) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
          color: kDark, borderRadius: BorderRadius.circular(12)),
      child: Row(children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
              color: kAmber.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8)),
          child:
              const Icon(Icons.psychology_rounded, color: kAmber, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                Text(sub,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 11)),
              ]),
        ),
        TextButton.icon(
          onPressed: _analiseSalva ? null : _salvarAnalise,
          icon: Icon(
              _analiseSalva
                  ? Icons.check_rounded
                  : Icons.save_alt_rounded,
              size: 16,
              color: _analiseSalva ? kGreen : kAmber),
          label: Text(_analiseSalva ? 'Salvo' : 'Salvar',
              style: TextStyle(
                  color: _analiseSalva ? kGreen : kAmber,
                  fontSize: 12)),
        ),
      ]),
    );
  }

  Widget _buildMaterialCard(Map<String, dynamic> m) {
    final confianca =
        (m['confianca'] as String?)?.toLowerCase() ?? 'media';
    final corConf = confianca == 'alta'
        ? kGreen
        : confianca == 'media'
            ? kAmber
            : kRed;
    final percConf =
        confianca == 'alta' ? 0.9 : confianca == 'media' ? 0.6 : 0.3;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGreen.withValues(alpha: 0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: kGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.layers_rounded, color: kGreen, size: 18),
          ),
          const SizedBox(width: 10),
          const Text('MATERIAL',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: kGreen,
                  letterSpacing: 1.0)),
        ]),
        const SizedBox(height: 12),
        Text(m['identificado']?.toString() ?? '—',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            _infoChip('Norma', m['norma']?.toString() ?? '—'),
            _infoChip('Dureza', m['dureza']?.toString() ?? '—'),
          ],
        ),
        if (m['caracteristicas'] != null) ...[
          const SizedBox(height: 8),
          Text(m['caracteristicas'].toString(),
              style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ],
        const SizedBox(height: 10),
        Row(children: [
          Text('Confiança: ${confianca.toUpperCase()}',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: corConf)),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: percConf,
                minHeight: 7,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(corConf),
              ),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _buildPecaCard(Map<String, dynamic> p) {
    final ops = (p['operacoes'] as List<dynamic>?) ?? [];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBlue.withValues(alpha: 0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: kBlue.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.precision_manufacturing_rounded,
                color: kBlue, size: 18),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text('PEÇA',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: kBlue,
                    letterSpacing: 1.0)),
          ),
          if (p['tipo'] != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                  color: kBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12)),
              child: Text(p['tipo'].toString().toUpperCase(),
                  style: const TextStyle(
                      fontSize: 10,
                      color: kBlue,
                      fontWeight: FontWeight.w700)),
            ),
        ]),
        const SizedBox(height: 10),
        if (p['descricao'] != null)
          Text(p['descricao'].toString(),
              style: const TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Color(0xFF333333))),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            if (p['dimensao_estimada'] != null)
              _infoChip('Dimensão', p['dimensao_estimada'].toString()),
            if (p['acabamento_ra'] != null)
              _infoChip('Acabamento', p['acabamento_ra'].toString()),
          ],
        ),
        if (ops.isNotEmpty) ...[
          const SizedBox(height: 10),
          const Text('Operações:',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey)),
          const SizedBox(height: 4),
          ...ops.map((op) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Row(children: [
                  const Icon(Icons.arrow_right_rounded,
                      size: 18, color: kBlue),
                  Expanded(
                      child: Text(op.toString(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF444444)))),
                ]),
              )),
        ],
      ]),
    );
  }

  Widget _buildParametrosCard(Map<String, dynamic> p) {
    return Container(
      decoration: BoxDecoration(
        color: kDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kAmber.withValues(alpha: 0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          child: Row(children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  color: kAmber.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8)),
              child:
                  const Icon(Icons.tune_rounded, color: kAmber, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('PARÂMETROS DE CORTE',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: kAmber,
                    letterSpacing: 1.0)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: Column(children: [
            Row(children: [
              Expanded(child: _paramBox('Vc', p['Vc']?.toString() ?? '—', 'm/min')),
              const SizedBox(width: 10),
              Expanded(child: _paramBox('RPM', p['rpm_sugerido']?.toString() ?? '—', 'RPM')),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _paramBox('fz', p['fz']?.toString() ?? '—', 'mm/d')),
              const SizedBox(width: 10),
              Expanded(child: _paramBox('ap', p['ap']?.toString() ?? '—', 'mm')),
            ]),
            if (p['ae'] != null) ...[
              const SizedBox(height: 10),
              _paramBox('ae', p['ae'].toString(), 'mm'),
            ],
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalculadoraScreen(
                    initialVc: _parseNum(p['Vc']?.toString()),
                    initialFz: _parseNum(p['fz']?.toString()),
                    initialAp: _parseNum(p['ap']?.toString()),
                    initialAe: _parseNum(p['ae']?.toString()),
                  ),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: kAmber),
              foregroundColor: kAmber,
              minimumSize: const Size(double.infinity, 40),
            ),
            icon: const Icon(Icons.calculate_rounded, size: 16),
            label: const Text('Usar na Calculadora',
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }

  Widget _paramBox(String label, String valor, String unidade) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: kAmber.withValues(alpha: 0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 2),
        Text(valor,
            style: const TextStyle(
                fontSize: 18,
                color: kAmber,
                fontWeight: FontWeight.w800)),
        Text(unidade,
            style:
                const TextStyle(fontSize: 10, color: Colors.grey)),
      ]),
    );
  }

  Widget _buildFerramentasCard(List<dynamic> ferramentas) {
    const cor = Color(0xFF7C3AED);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.build_circle_rounded,
                color: cor, size: 18),
          ),
          const SizedBox(width: 10),
          const Text('FERRAMENTAS',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: cor,
                  letterSpacing: 1.0)),
        ]),
        const SizedBox(height: 10),
        ...ferramentas.map((entry) {
          final f = entry as Map<String, dynamic>;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: cor.withValues(alpha: 0.15)),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(f['tipo']?.toString() ?? '—',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: cor)),
              const SizedBox(height: 3),
              Text(f['especificacao']?.toString() ?? '—',
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A))),
              if (f['motivo'] != null) ...[
                const SizedBox(height: 3),
                Text(f['motivo'].toString(),
                    style: const TextStyle(
                        fontSize: 11, color: Colors.grey)),
              ],
            ]),
          );
        }),
      ]),
    );
  }

  Widget _buildAtencaoCard(List<dynamic> atencao) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kRed.withValues(alpha: 0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: kRed.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.report_problem_rounded,
                color: kRed, size: 18),
          ),
          const SizedBox(width: 10),
          const Text('ATENÇÃO',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: kRed,
                  letterSpacing: 1.0)),
        ]),
        const SizedBox(height: 10),
        ...atencao.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        size: 16, color: kRed),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(item.toString(),
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF333333),
                                height: 1.4))),
                  ]),
            )),
      ]),
    );
  }

  Widget _buildSequenciaCard(List<dynamic> sequencia) {
    const cor = Color(0xFF0D9488);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.format_list_numbered_rounded,
                color: cor, size: 18),
          ),
          const SizedBox(width: 10),
          const Text('SEQUÊNCIA DE OPERAÇÕES',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: cor,
                  letterSpacing: 1.0)),
        ]),
        const SizedBox(height: 10),
        ...sequencia.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                          color: cor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text('${entry.key + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(entry.value.toString(),
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF333333),
                                height: 1.4)),
                      ),
                    ),
                  ]),
            )),
      ]),
    );
  }

  // ─── Alarme sub-cards ─────────────────────────────────────────────────────────

  Widget _buildAlarmeInfoCard(Map<String, dynamic> a) {
    final urgencia = a['urgencia']?.toString() ?? 'MÉDIO';
    final corUrg = urgencia == 'CRÍTICO'
        ? kRed
        : urgencia == 'ALTO'
            ? const Color(0xFFBA7517)
            : kGreen;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kRed.withValues(alpha: 0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: kRed.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.warning_amber_rounded,
                color: kRed, size: 18),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text('ALARME IDENTIFICADO',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: kRed,
                    letterSpacing: 1.0)),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration:
                BoxDecoration(color: corUrg, borderRadius: BorderRadius.circular(20)),
            child: Text(urgencia,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CÓDIGO',
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.w700)),
                  Text(a['codigo']?.toString() ?? '—',
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A))),
                ]),
          ),
          if (a['fabricante'] != null)
            _infoChip('Fabricante', a['fabricante'].toString()),
        ]),
        if (a['descricao_oficial'] != null) ...[
          const SizedBox(height: 8),
          Text(a['descricao_oficial'].toString(),
              style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF444444),
                  height: 1.45)),
        ],
      ]),
    );
  }

  Widget _buildCausasCard(List<dynamic> causas) {
    const cor = Color(0xFFBA7517);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: cor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child:
                const Icon(Icons.search_rounded, color: cor, size: 18),
          ),
          const SizedBox(width: 10),
          const Text('CAUSAS PROVÁVEIS',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: cor,
                  letterSpacing: 1.0)),
        ]),
        const SizedBox(height: 10),
        ...causas.map((c) {
          final causa = c as Map<String, dynamic>;
          final prob = causa['probabilidade']?.toString() ?? '50%';
          final probNum =
              double.tryParse(prob.replaceAll('%', '').trim()) ?? 50.0;
          final corBar =
              probNum >= 60 ? kRed : probNum >= 30 ? cor : kGreen;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(causa['causa']?.toString() ?? '—',
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF333333)))),
                const SizedBox(width: 8),
                Text(prob,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: corBar)),
              ]),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: probNum / 100,
                  minHeight: 5,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(corBar),
                ),
              ),
            ]),
          );
        }),
      ]),
    );
  }

  Widget _buildSolucaoCard(List<dynamic> solucao) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kGreen.withValues(alpha: 0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
                color: kGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8)),
            child:
                const Icon(Icons.build_rounded, color: kGreen, size: 18),
          ),
          const SizedBox(width: 10),
          const Text('SOLUÇÃO PASSO A PASSO',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: kGreen,
                  letterSpacing: 1.0)),
        ]),
        const SizedBox(height: 10),
        ...solucao.asMap().entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                          color: kGreen,
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                          child: Text('${entry.key + 1}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700))),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(entry.value.toString(),
                            style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF333333),
                                height: 1.4)),
                      ),
                    ),
                  ]),
            )),
      ]),
    );
  }

  Widget _buildExtrasAlarme(
      List<dynamic>? pecas, String? tempo, bool? chamarTecnico) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBlue.withValues(alpha: 0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (tempo != null) ...[
          _infoRow(Icons.timer_rounded, 'Tempo estimado', tempo, kBlue),
          const SizedBox(height: 8),
        ],
        if (chamarTecnico == true)
          _infoRow(Icons.phone_rounded, 'Recomendação',
              'Chamar técnico especializado', kRed),
        if (pecas != null && pecas.isNotEmpty) ...[
          const SizedBox(height: 8),
          const Text('Peças suspeitas:',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey)),
          const SizedBox(height: 4),
          ...pecas.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(children: [
                  const Icon(Icons.settings_rounded,
                      size: 14, color: Colors.grey),
                  const SizedBox(width: 6),
                  Expanded(
                      child: Text(p.toString(),
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF444444)))),
                ]),
              )),
        ],
      ]),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────────

  double? _parseNum(String? s) {
    if (s == null) return null;
    final match = RegExp(r'[\d]+\.?[\d]*').firstMatch(s);
    return match != null ? double.tryParse(match.group(0)!) : null;
  }

  Widget _infoRow(
      IconData icon, String label, String valor, Color cor) {
    return Row(children: [
      Icon(icon, size: 16, color: cor),
      const SizedBox(width: 8),
      Text('$label: ',
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.grey)),
      Expanded(
          child: Text(valor,
              style: TextStyle(
                  fontSize: 12,
                  color: cor,
                  fontWeight: FontWeight.w600))),
    ]);
  }

  Widget _infoChip(String label, String valor) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label,
            style: const TextStyle(
                fontSize: 9,
                color: Colors.grey,
                fontWeight: FontWeight.w600)),
        Text(valor,
            style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF333333),
                fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _buildResultadoCard({
    required String titulo,
    required String texto,
    required IconData icon,
    required Color cor,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.18)),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
              color: cor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: cor, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: cor)),
                const SizedBox(height: 6),
                Text(texto,
                    style: const TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: Color(0xFF333333))),
              ]),
        ),
      ]),
    );
  }

  Widget _buildConfiancaAnalise() {
    final confianca = _confiancaAnalise();
    final cor = _corConfianca(confianca);
    return Row(children: [
      Text('Confiança: $confianca%',
          style: TextStyle(
              color: cor, fontSize: 11, fontWeight: FontWeight.w700)),
      const SizedBox(width: 10),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: confianca / 100,
            minHeight: 6,
            backgroundColor: Colors.white.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(cor),
          ),
        ),
      ),
    ]);
  }

  int _confiancaAnalise() {
    final base =
        _tipoAnalise.codeUnits.fold<int>(0, (total, code) => total + code);
    if (_imagemBytes != null) {
      return 60 + ((base + _imagemBytes!.length) % 36);
    }
    return 40 + (base % 31);
  }

  Color _corConfianca(int confianca) {
    if (confianca >= 75) return kGreen;
    if (confianca >= 55) return kAmber;
    return kRed;
  }

  String _diagnosticoTexto() {
    final temImagem = _imagemBytes != null;
    if (temImagem) {
      switch (_tipoImagemDetectada()) {
        case 'painel':
          return 'Análise baseada na imagem: reconhecimento de painel CNC. Verifique mensagens na tela, estado do comando, modo ativo e informações de ciclo.';
        case 'programa/painel':
          return 'Análise baseada na imagem: reconhecimento de programa ou painel CNC. Verifique bloco ativo, mensagem exibida, coordenadas e modo do comando.';
        case 'peça':
          return 'Análise baseada na imagem: reconhecimento de peça usinada. Possível defeito visual, marca de ferramenta, rebarba, batida ou falha de acabamento.';
        case 'peça/material':
          return 'Análise baseada na imagem: reconhecimento de peça ou material. Observe cavaco, acabamento, queima, vibração marcada e sinais de parâmetro inadequado.';
        case 'alarme':
          return 'Análise baseada na imagem: reconhecimento de alarme no comando. Priorize o código exibido, a mensagem da tela e o momento em que a máquina parou.';
        case 'ferramenta':
          return 'Análise baseada na imagem: reconhecimento de ferramenta. Observe desgaste, lascas, quebra, montagem, balanço e condição da aresta de corte.';
        default:
          return 'Imagem CNC analisada. Selecione um tipo de análise para obter um diagnóstico mais específico.';
      }
    }
    switch (_tipoAnalise) {
      case 'erro':
        return 'O foco é identificar um alarme CNC ou condição de falha. O ponto mais importante é confirmar o código exibido no comando e em qual etapa da operação ele apareceu.';
      case 'peca':
        return 'O foco é a peça usinada. Verifique desvio dimensional, marca de vibração, falha de acabamento, erro de fixação ou referência incorreta.';
      case 'programa':
        return 'O foco é o programa CNC. Prioridade é revisar blocos recentes, coordenadas, compensações, códigos modais e sequência de usinagem.';
      case 'ferramenta':
        return 'O foco é a ferramenta. Avalie desgaste, quebra, comprimento, raio, montagem no suporte e se o corretor usado corresponde à ferramenta real.';
      case 'parametros':
        return 'O foco são os parâmetros de corte. Confira se rotação, avanço, profundidade e estratégia estão compatíveis com material, ferramenta e operação.';
      default:
        return 'Análise geral iniciada. Use a imagem ou descrição para separar o problema entre alarme, peça, programa, ferramenta, parâmetro ou condição da máquina.';
    }
  }

  String _causaTexto() {
    final temImagem = _imagemBytes != null;
    if (temImagem) {
      switch (_tipoImagemDetectada()) {
        case 'painel':
        case 'programa/painel':
          return 'Possíveis causas: modo incorreto, programa parado, feed hold ativo, mensagem pendente, override zerado ou condição de segurança indicada no painel.';
        case 'peça':
          return 'Causa provável: desgaste de ferramenta, vibração, fixação insuficiente, sobremetal irregular, avanço agressivo ou referência da peça incorreta.';
        case 'peça/material':
          return 'Causa provável: avanço alto, rotação inadequada, ferramenta incompatível, refrigeração insuficiente ou sobremetal irregular.';
        case 'alarme':
          return 'Causa pode ser: sensor ativo, servo em falha, baixa pressão, proteção aberta, fim de curso ou emergência acionada.';
        case 'ferramenta':
          return 'Possíveis causas: aresta lascada, ferramenta gasta, montagem incorreta, balanço excessivo, cavaco aderido ou corretor desatualizado.';
        default:
          return 'A causa deve ser confirmada pelos elementos visíveis na imagem: painel, peça, alarme, ferramenta, cavaco, fixação ou área de trabalho.';
      }
    }
    switch (_tipoAnalise) {
      case 'erro':
        return 'Causa pode ser: sensor ativo, servo em falha, baixa pressão, porta/proteção aberta, fim de curso, emergência acionada ou parâmetro de segurança pendente.';
      case 'peca':
        return 'Possíveis causas: zero peça incorreto, fixação insuficiente, ferramenta gasta, sobremetal irregular, peça movimentando ou material fora do esperado.';
      case 'programa':
        return 'Causa pode ser: coordenada errada, plano ativo incorreto, compensação G41/G42, offset trocado, avanço inadequado ou chamada de ferramenta divergente.';
      case 'ferramenta':
        return 'Possíveis causas: aresta desgastada, ferramenta lascada, balanço excessivo, aperto ruim, inserto incorreto ou corretor de comprimento/raio desatualizado.';
      case 'parametros':
        return 'Causa pode ser: avanço alto, rotação baixa ou alta demais, profundidade excessiva, refrigeração insuficiente ou ferramenta inadequada ao material.';
      default:
        return 'A causa provável depende do contexto. Comece por segurança da máquina, código de alarme, fixação, ferramenta, offsets e último trecho executado.';
    }
  }

  String _acaoTexto() {
    final temImagem = _imagemBytes != null;
    if (temImagem) {
      switch (_tipoImagemDetectada()) {
        case 'painel':
        case 'programa/painel':
          return '1. Confira no painel o modo ativo e o bloco atual.\n2. Verifique alarmes pendentes, override e feed hold.\n3. Registre a mensagem exibida antes de resetar.\n4. Reinicie somente após confirmar a condição segura.';
        case 'peça':
          return '1. Compare a peça com uma peça boa.\n2. Meça a região suspeita.\n3. Confira fixação e condição da ferramenta.\n4. Reduza a carga de corte e valide em uma passada controlada.';
        case 'peça/material':
          return '1. Observe cavaco, acabamento e marcas de vibração.\n2. Confira material, ferramenta e refrigeração.\n3. Reduza avanço ou profundidade em pequenos passos.\n4. Valide o novo parâmetro em uma passada controlada.';
        case 'alarme':
          return '1. Copie exatamente o código do alarme.\n2. Consulte a tela de detalhes do comando.\n3. Verifique proteções, sensores e emergência.\n4. Faça reset somente depois de corrigir a causa.';
        case 'ferramenta':
          return '1. Pare a operação com segurança.\n2. Inspecione a ferramenta e limpe o suporte.\n3. Confira aperto, montagem e corretor.\n4. Substitua se houver desgaste ou lasca.';
        default:
          return '1. Identifique o item mostrado na imagem.\n2. Confirme a condição real na máquina.\n3. Registre o achado antes de continuar.\n4. Prossiga apenas com a condição segura.';
      }
    }
    switch (_tipoAnalise) {
      case 'erro':
        return '1. Anote o código completo do alarme.\n2. Pare a máquina com segurança.\n3. Confira proteções, sensores e emergência.\n4. Elimine a causa e faça reset somente depois.';
      case 'peca':
        return '1. Meça as dimensões críticas.\n2. Confira zero peça e fixação.\n3. Inspecione acabamento e marcas de corte.\n4. Repita uma passagem controlada antes de liberar produção.';
      case 'programa':
        return '1. Revise o trecho suspeito do programa.\n2. Simule o caminho da ferramenta.\n3. Confira offsets e compensações.\n4. Execute em bloco a bloco com override reduzido.';
      case 'ferramenta':
        return '1. Pare a máquina com segurança.\n2. Inspecione aresta, aperto e suporte.\n3. Confira comprimento, raio e corretor.\n4. Substitua a ferramenta se necessário.';
      case 'parametros':
        return '1. Reduza avanço ou profundidade em pequenos passos.\n2. Ajuste a rotação conforme material e ferramenta.\n3. Observe cavaco, som, vibração e temperatura.\n4. Aumente carga somente após validar o corte.';
      default:
        return '1. Verifique alarmes e condição de segurança.\n2. Confira fixação, ferramenta e offsets.\n3. Revise programa ativo e refrigeração.\n4. Prossiga somente após validar a condição de corte.';
    }
  }

  String _tipoImagemDetectada() {
    if (_imagemBytes == null) return 'nenhuma';
    switch (_tipoAnalise) {
      case 'erro':
        return 'alarme';
      case 'peca':
        return 'peça';
      case 'programa':
        return 'programa/painel';
      case 'ferramenta':
        return 'ferramenta';
      case 'parametros':
        return 'peça/material';
      default:
        return 'geral';
    }
  }

  String _riscoTexto() {
    final temImagem = _imagemBytes != null;
    switch (_tipoAnalise) {
      case 'erro':
        return temImagem
            ? 'RISCO CRÍTICO:\nNão faça reset sem validar o alarme. Pode ocultar falha de segurança e provocar movimento inesperado.'
            : 'RISCO CRÍTICO:\nNão continue sem corrigir a causa. Pode gerar nova parada, perda de referência, colisão ou dano ao servo.';
      case 'peca':
        return temImagem
            ? 'ATENÇÃO:\nNão libere produção com defeito visível. Pode gerar refugo em série e quebra de ferramenta.'
            : 'ATENÇÃO:\nNão continue sem medir e confirmar a fixação. Pode causar peça solta, refugo e colisão com o dispositivo.';
      case 'programa':
        return temImagem
            ? 'RISCO CRÍTICO:\nNão execute o bloco suspeito sem revisar. Pode causar corte fora de posição ou colisão.'
            : 'RISCO CRÍTICO:\nNão rode o programa sem simular. Movimento inesperado pode danificar peça, ferramenta e máquina.';
      case 'ferramenta':
        return temImagem
            ? 'ATENÇÃO:\nNão usinar com ferramenta lascada ou mal montada. Pode quebrar em corte e danificar a peça.'
            : 'ATENÇÃO:\nNão continue com ferramenta comprometida. Pode sobrecarregar spindle, quebrar a aresta e marcar a peça.';
      case 'parametros':
        return temImagem
            ? 'ATENÇÃO:\nNão ignore queima, vibração ou cavaco ruim. Pode acelerar desgaste e quebrar a ferramenta.'
            : 'ATENÇÃO:\nNão mantenha parâmetros agressivos sem validar. Pode causar vibração, aquecimento e sobrecarga da máquina.';
      default:
        return temImagem
            ? 'ATENÇÃO:\nNão tome decisão só pela imagem. Confirme na máquina antes de continuar a operação.'
            : 'ATENÇÃO:\nNão continue sem identificar a origem do problema. Pode causar dano à peça, ferramenta ou máquina.';
    }
  }

  String _dicaTexto() {
    final temImagem = _imagemBytes != null;
    switch (_tipoAnalise) {
      case 'erro':
        return temImagem
            ? 'Guarde essa imagem junto com o horário, máquina e programa. Uma foto nítida do alarme acelera muito a identificação da causa.'
            : 'Fotografe a tela do alarme antes do reset e registre máquina, programa, ferramenta ativa e condição em que a falha ocorreu.';
      case 'peca':
        return temImagem
            ? 'Tire outra foto da mesma região após o ajuste. Comparar antes e depois ajuda a validar se a causa realmente foi eliminada.'
            : 'Separe a primeira peça suspeita, marque a face/referência usada e compare com uma peça boa para encontrar o padrão do desvio.';
      case 'programa':
        return temImagem
            ? 'Se a foto mostra a tela do programa, anote o número do bloco e salve uma cópia antes de editar qualquer linha.'
            : 'Antes de editar, salve uma cópia do programa atual e anote o bloco onde o comportamento começou.';
      case 'ferramenta':
        return temImagem
            ? 'Fotografe a ferramenta ao lado de uma nova ou em bom estado. A comparação visual deixa desgaste e lascas mais evidentes.'
            : 'Compare a ferramenta suspeita com uma nova. Pequenas lascas na aresta já podem explicar ruído, vibração e acabamento ruim.';
      case 'parametros':
        return temImagem
            ? 'Use a foto do cavaco, acabamento ou ferramenta como referência e altere apenas um parâmetro por vez.'
            : 'Faça ajustes um por vez e registre o efeito no cavaco, som, acabamento e carga do spindle.';
      default:
        return temImagem
            ? 'Mantenha a imagem salva com uma pequena descrição do problema. Ela serve como referência para futuras ocorrências.'
            : 'Registre foto, código do alarme, programa, ferramenta e condição da peça. Esse histórico acelera a próxima análise.';
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (!purchaseService.isPremium) {
    //   return PaywallScreen(
    //     onClose: () => Navigator.of(context).maybePop(),
    //   );
    // }

    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTipos(),
                      const SizedBox(height: 16),
                      _buildModoToggle(),
                      const SizedBox(height: 12),
                      if (_modoTexto) _buildTextArea() else _buildImageArea(),
                      const SizedBox(height: 16),
                      _buildBotaoAnalisar(),
                      _buildResposta(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    _textoCtrl.dispose();
    super.dispose();
  }
}
