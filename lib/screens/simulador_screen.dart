import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class SimuladorScreen extends StatefulWidget {
  const SimuladorScreen({super.key});
  @override
  State<SimuladorScreen> createState() => _SimuladorScreenState();
}

class _SimuladorScreenState extends State<SimuladorScreen> {
  final _ctrl = TextEditingController();
  final _foco = FocusNode();
  List<_BlocoExplicado> _resultados = [];
  String _erro = '';

  @override
  void dispose() { _ctrl.dispose(); _foco.dispose(); super.dispose(); }

  void _analisar() {
    final texto = _ctrl.text.trim();
    if (texto.isEmpty) return;
    setState(() {
      _erro = '';
      _resultados = _parsearPrograma(texto);
    });
  }

  List<_BlocoExplicado> _parsearPrograma(String texto) {
    final linhas = texto.split('\n');
    final resultado = <_BlocoExplicado>[];
    for (final linha in linhas) {
      final t = linha.trim();
      if (t.isEmpty) continue;
      resultado.add(_analisarLinha(t));
    }
    return resultado;
  }

  _BlocoExplicado _analisarLinha(String linha) {
    final upper = linha.toUpperCase().replaceAll('\t', ' ');
    final partes = <_Parte>[];
    final avisos = <String>[];
    String resumo = '';

    // Comentário
    if (upper.startsWith(';') || upper.startsWith('(')) {
      return _BlocoExplicado(linha: linha, partes: [
        _Parte(texto: linha, cor: const Color(0xFF8B949E), descricao: 'Comentário — não é executado pelo CNC')
      ], resumo: 'Comentário', avisos: [], tipo: 'comentario');
    }

    // Número do programa
    if (upper.startsWith('O') && upper.length >= 2) {
      final num = upper.substring(1).split(' ')[0];
      return _BlocoExplicado(linha: linha, partes: [
        _Parte(texto: linha, cor: kAmber, descricao: 'Número do programa O$num — identificação única do programa CNC')
      ], resumo: 'Programa O$num', avisos: [], tipo: 'programa');
    }

    // Parse de endereços
    final enderecos = _extrairEnderecos(upper);
    String? gCode, mCode;
    bool temF = false, temS = false, temX = false, temZ = false;

    for (final e in enderecos) {
      switch (e.letra) {
        case 'G':
          gCode = e.valorStr;
          partes.add(_Parte(
            texto: '${e.letra}${e.valorStr}',
            cor: const Color(0xFF79C0FF),
            descricao: _explicarG(e.valorStr)));
          break;
        case 'M':
          mCode = e.valorStr;
          partes.add(_Parte(
            texto: '${e.letra}${e.valorStr}',
            cor: const Color(0xFF7EC8A4),
            descricao: _explicarM(e.valorStr)));
          break;
        case 'X':
          temX = true;
          partes.add(_Parte(
            texto: 'X${e.valorStr}',
            cor: const Color(0xFFFF7B72),
            descricao: 'Posição X = ${e.valorStr}mm'));
          break;
        case 'Y':
          partes.add(_Parte(
            texto: 'Y${e.valorStr}',
            cor: const Color(0xFFFFA657),
            descricao: 'Posição Y = ${e.valorStr}mm'));
          break;
        case 'Z':
          temZ = true;
          partes.add(_Parte(
            texto: 'Z${e.valorStr}',
            cor: const Color(0xFFD2A8FF),
            descricao: 'Posição Z = ${e.valorStr}mm'));
          break;
        case 'F':
          temF = true;
          partes.add(_Parte(
            texto: 'F${e.valorStr}',
            cor: const Color(0xFFE6EDF3),
            descricao: 'Avanço = ${e.valorStr} mm/min ou mm/rot'));
          break;
        case 'S':
          temS = true;
          partes.add(_Parte(
            texto: 'S${e.valorStr}',
            cor: const Color(0xFFE6EDF3),
            descricao: 'Spindle = ${e.valorStr} RPM ou m/min (dependendo de G96/G97)'));
          break;
        case 'T':
          partes.add(_Parte(
            texto: 'T${e.valorStr}',
            cor: kAmber,
            descricao: 'Ferramenta T${e.valorStr}'));
          break;
        case 'H':
          partes.add(_Parte(
            texto: 'H${e.valorStr}',
            cor: kAmber,
            descricao: 'Offset de comprimento H${e.valorStr}'));
          break;
        case 'D':
          partes.add(_Parte(
            texto: 'D${e.valorStr}',
            cor: kAmber,
            descricao: 'Offset de raio D${e.valorStr} — compensa diâmetro da fresa'));
          break;
        case 'R':
          partes.add(_Parte(
            texto: 'R${e.valorStr}',
            cor: const Color(0xFFFFA657),
            descricao: 'Raio = ${e.valorStr}mm (arco ou plano de retorno)'));
          break;
        case 'I':
          partes.add(_Parte(
            texto: 'I${e.valorStr}',
            cor: const Color(0xFFFFA657),
            descricao: 'Centro do arco em X = ${e.valorStr}mm'));
          break;
        case 'J':
          partes.add(_Parte(
            texto: 'J${e.valorStr}',
            cor: const Color(0xFFFFA657),
            descricao: 'Centro do arco em Y = ${e.valorStr}mm'));
          break;
        case 'K':
          partes.add(_Parte(
            texto: 'K${e.valorStr}',
            cor: const Color(0xFFFFA657),
            descricao: 'Centro do arco em Z = ${e.valorStr}mm'));
          break;
        case 'N':
          partes.insert(0, _Parte(
            texto: 'N${e.valorStr}',
            cor: const Color(0xFF8B949E),
            descricao: 'Número do bloco (linha ${e.valorStr}) — referência para loops e saltos'));
          break;
        case 'P':
          partes.add(_Parte(
            texto: 'P${e.valorStr}',
            cor: const Color(0xFF7EC8A4),
            descricao: 'P${e.valorStr} — pausa (ms), subprograma ou bloco inicial do ciclo'));
          break;
        case 'Q':
          partes.add(_Parte(
            texto: 'Q${e.valorStr}',
            cor: const Color(0xFF7EC8A4),
            descricao: 'Q${e.valorStr} — passo de perfuração ou bloco final do ciclo'));
          break;
        case 'L':
          partes.add(_Parte(
            texto: 'L${e.valorStr}',
            cor: const Color(0xFF7EC8A4),
            descricao: 'L${e.valorStr} — número de repetições do subprograma'));
          break;
        case 'U':
          partes.add(_Parte(
            texto: 'U${e.valorStr}',
            cor: const Color(0xFFFF7B72),
            descricao: 'U${e.valorStr} — incremental em X (torno) ou profundidade por passe (G71)'));
          break;
        case 'W':
          partes.add(_Parte(
            texto: 'W${e.valorStr}',
            cor: const Color(0xFFD2A8FF),
            descricao: 'W${e.valorStr} — incremental em Z (torno) ou sobremetal axial'));
          break;
        case 'A':
          partes.add(_Parte(
            texto: 'A${e.valorStr}',
            cor: const Color(0xFFFFA657),
            descricao: 'Eixo A = ${e.valorStr}° (rotação em torno de X)'));
          break;
        case 'B':
          partes.add(_Parte(
            texto: 'B${e.valorStr}',
            cor: const Color(0xFFFFA657),
            descricao: 'Eixo B = ${e.valorStr}° (rotação em torno de Y)'));
          break;
        case 'C':
          partes.add(_Parte(
            texto: 'C${e.valorStr}',
            cor: const Color(0xFFFFA657),
            descricao: 'Eixo C = ${e.valorStr}° (rotação em torno de Z)'));
          break;
      }
    }

    // Avisos inteligentes
    if (gCode == '01' && !temF) avisos.add('⚠️ G01 sem F — avanço não definido! Usará o último F ativo.');
    if (gCode == '84' && !temF) avisos.add('🚨 G84 (rosqueamento) SEM F! F = passo × RPM — OBRIGATÓRIO!');
    if (gCode == '84' && temF) avisos.add('💡 G84: verifique se F = passo × RPM (ex: M10×1.5 a 300RPM → F=450)');
    if (mCode == '06' && !upper.contains('T')) avisos.add('⚠️ M06 sem número T — qual ferramenta trocar?');
    if ((gCode == '02' || gCode == '03') && !upper.contains('R') && !upper.contains('I')) {
      avisos.add('⚠️ Arco sem R ou I,J — defina o raio!');
    }
    if (gCode == '00' && temF) avisos.add('💡 F é ignorado no G00 — G00 sempre vai na velocidade máxima.');
    if (gCode == '96' && !upper.contains('G92') && !upper.contains('G50')) {
      avisos.add('💡 G96 (CSS): recomenda-se adicionar G92 S[RPM] para limitar RPM máximo.');
    }

    // Resumo
    resumo = _gerarResumo(gCode, mCode, enderecos);

    return _BlocoExplicado(linha: linha, partes: partes, resumo: resumo, avisos: avisos, tipo: _tipoBloco(gCode, mCode));
  }

  List<_Endereco> _extrairEnderecos(String linha) {
    final result = <_Endereco>[];
    final letras = ['G', 'M', 'N', 'X', 'Y', 'Z', 'F', 'S', 'T', 'H', 'D', 'R', 'I', 'J', 'K', 'P', 'Q', 'L', 'U', 'W', 'A', 'B', 'C'];
    final regex = RegExp(r'([GMNXYZFSTHDRIJKPQLUWABCO])(-?\d+\.?\d*)');
    for (final m in regex.allMatches(linha)) {
      final letra = m.group(1)!;
      final valor = m.group(2)!;
      if (letras.contains(letra)) {
        result.add(_Endereco(letra: letra, valorStr: valor));
      }
    }
    return result;
  }

  String _explicarG(String cod) {
    final map = {
      '00': 'Posicionamento RÁPIDO — sem corte, velocidade máxima',
      '01': 'Interpolação LINEAR — corte em linha reta com avanço F',
      '02': 'Arco HORÁRIO — interpolação circular CW',
      '03': 'Arco ANTI-HORÁRIO — interpolação circular CCW',
      '04': 'PAUSA (Dwell) — para todos os movimentos por tempo P',
      '10': 'Entrada de dados programável — define offsets no programa',
      '12': 'Fresamento circular HORÁRIO — ciclo de bolsão',
      '13': 'Fresamento circular ANTI-HORÁRIO — ciclo de bolsão',
      '15': 'Cancela coordenadas POLARES',
      '16': 'Ativa coordenadas POLARES — X=raio, Y=ângulo',
      '17': 'Plano XY — padrão para fresamento vertical',
      '18': 'Plano XZ — padrão para torneamento',
      '19': 'Plano YZ — fresamento lateral',
      '20': 'Unidade em POLEGADAS',
      '21': 'Unidade em MILÍMETROS',
      '28': 'Retorno ao ZERO MÁQUINA via ponto intermediário',
      '29': 'Retorno do ponto de referência ao trabalho',
      '30': 'Retorno ao 2º ponto de referência (torno)',
      '31': 'Ciclo de APALPAMENTO — captura posição no contato',
      '40': 'CANCELA compensação de raio (G41/G42)',
      '41': 'Compensação de raio ESQUERDA — fresa à esquerda do perfil',
      '42': 'Compensação de raio DIREITA — fresa à direita do perfil',
      '43': 'Compensação de COMPRIMENTO positiva — ativa offset H',
      '44': 'Compensação de comprimento NEGATIVA',
      '49': 'CANCELA compensação de comprimento (G43/G44)',
      '50': 'Cancela escala / Limita RPM máximo (torno com G96)',
      '51': 'ESCALA — amplia ou reduz coordenadas pelo fator P',
      '52': 'Sistema de coordenadas LOCAL — offset temporário',
      '53': 'Coordenadas da MÁQUINA — ignora offsets G54-G59',
      '54': 'Zero-peça 1 — primeiro sistema de coordenadas',
      '55': 'Zero-peça 2 — segunda fixação',
      '56': 'Zero-peça 3',
      '57': 'Zero-peça 4',
      '58': 'Zero-peça 5',
      '59': 'Zero-peça 6',
      '65': 'Chamada de MACRO — executa subprograma paramétrico',
      '66': 'Chamada de macro MODAL',
      '67': 'Cancela chamada modal de macro',
      '68': 'ROTAÇÃO de coordenadas — gira o sistema em R graus',
      '69': 'Cancela rotação de coordenadas',
      '70': 'Ciclo de ACABAMENTO (torno Fanuc) — passe fino após G71',
      '71': 'Ciclo de DESBASTE longitudinal (torno Fanuc)',
      '72': 'Ciclo de DESBASTE transversal (torno Fanuc)',
      '73': 'Ciclo de furação COM QUEBRA DE CAVACO (retração parcial)',
      '74': 'Rosqueamento com macho ESQUERDO (anti-horário)',
      '75': 'Ciclo de CANAL/RANHURA no torno (grooving)',
      '76': 'Mandrilamento FINO (sem riscar) / Rosca automática (torno)',
      '80': 'CANCELA ciclo fixo ativo (G73 a G89)',
      '81': 'Ciclo de furação SIMPLES — fura e retrai rapidamente',
      '82': 'Furação com PAUSA no fundo — para counterbore/rebaixo',
      '83': 'Furação PROFUNDA (peck) — retração total, evacua cavaco',
      '84': 'ROSQUEAMENTO automático com macho (F = passo × RPM!)',
      '85': 'Mandrilamento — entrada e saída com avanço F',
      '86': 'Mandrilamento — para spindle e retrai rápido',
      '89': 'Mandrilamento com PAUSA no fundo',
      '90': 'Programação ABSOLUTA — coordenadas do zero-peça',
      '91': 'Programação INCREMENTAL — relativa à posição atual',
      '92': 'Define coordenada / Limita RPM (torno + G96)',
      '93': 'Avanço por TEMPO INVERSO — para 5 eixos',
      '94': 'Avanço em MM/MIN — padrão fresamento',
      '95': 'Avanço em MM/ROT — padrão torneamento',
      '96': 'Velocidade de corte CONSTANTE (CSS) — RPM varia com diâmetro',
      '97': 'RPM CONSTANTE — cancela G96',
      '98': 'Retorna ao PLANO INICIAL nos ciclos fixos',
      '99': 'Retorna ao PLANO R nos ciclos fixos — mais rápido',
    };
    return map[cod.replaceAll('.', '')] ?? 'Código G$cod — consulte o manual';
  }

  String _explicarM(String cod) {
    final map = {
      '00': 'PARADA obrigatória — aguarda CYCLE START do operador',
      '01': 'Parada OPCIONAL — só para se chave ligada no painel',
      '02': 'FIM do programa (sem rebobinar)',
      '03': 'Liga spindle HORÁRIO (CW) — padrão para fresas',
      '04': 'Liga spindle ANTI-HORÁRIO (CCW)',
      '05': 'PARA o spindle completamente',
      '06': 'TROCA automática de ferramenta (ATC)',
      '07': 'Liga refrigeração de NÉVOA (mist)',
      '08': 'Liga refrigeração FLOOD — obrigatório para aço/inox',
      '09': 'DESLIGA toda refrigeração',
      '10': 'FECHA o chuck (mandril) do torno',
      '11': 'ABRE o chuck do torno',
      '12': 'AVANÇA contra-ponta do torno',
      '13': 'RECUA contra-ponta do torno',
      '19': 'Parada ORIENTADA do spindle (para G76)',
      '21': 'Ativa ESPELHAMENTO em X',
      '22': 'Ativa espelhamento em Y',
      '23': 'Cancela espelhamento X',
      '24': 'Cancela espelhamento Y',
      '30': 'FIM do programa + rebobina — o mais usado',
      '41': 'Gama de velocidade BAIXA — alto torque',
      '42': 'Gama de velocidade ALTA — alta rotação',
      '48': 'HABILITA overrides do painel',
      '49': 'DESABILITA overrides — obrigatório no rosqueamento',
      '50': 'Liga fluido pelo INTERIOR da ferramenta (alta pressão)',
      '51': 'Desliga fluido interno',
      '60': 'TROCA de palete (APC)',
      '98': 'CHAMA subprograma P[número]',
      '99': 'FIM de subprograma — retorna ao principal',
    };
    return map[cod.replaceAll('.', '')] ?? 'Código M$cod — consulte o manual';
  }

  String _gerarResumo(String? g, String? m, List<_Endereco> end) {
    if (g != null && m != null) return 'G$g + M$m simultâneos';
    if (g == '00') {
      final pos = end.where((e) => ['X','Y','Z'].contains(e.letra)).map((e) => '${e.letra}${e.valorStr}').join(' ');
      return 'Posicionamento rápido → $pos';
    }
    if (g == '01') {
      final pos = end.where((e) => ['X','Y','Z'].contains(e.letra)).map((e) => '${e.letra}${e.valorStr}').join(' ');
      final f = end.firstWhere((e) => e.letra == 'F', orElse: () => _Endereco(letra: 'F', valorStr: '?'));
      return 'Corte linear → $pos a F${f.valorStr}';
    }
    if (g == '02') return 'Arco horário (CW)';
    if (g == '03') return 'Arco anti-horário (CCW)';
    if (g == '81' || g == '83') return 'Ciclo de furação';
    if (g == '84') return '🔩 Rosqueamento — verifique F!';
    if (g != null) return 'Código G$g';
    if (m == '03') { final s = end.firstWhere((e) => e.letra == 'S', orElse: () => _Endereco(letra: 'S', valorStr: '?')); return 'Liga spindle ${s.valorStr} RPM CW'; }
    if (m == '04') { final s = end.firstWhere((e) => e.letra == 'S', orElse: () => _Endereco(letra: 'S', valorStr: '?')); return 'Liga spindle ${s.valorStr} RPM CCW'; }
    if (m == '05') return 'Para spindle';
    if (m == '06') { final t = end.firstWhere((e) => e.letra == 'T', orElse: () => _Endereco(letra: 'T', valorStr: '?')); return 'Troca para T${t.valorStr}'; }
    if (m == '08') return 'Liga refrigeração';
    if (m == '09') return 'Desliga refrigeração';
    if (m == '30') return 'Fim do programa';
    if (m != null) return 'Código M$m';
    return 'Bloco CNC';
  }

  String _tipoBloco(String? g, String? m) {
    if (g == '00') return 'rapido';
    if (g == '01' || g == '02' || g == '03') return 'corte';
    if (g != null && int.tryParse(g.replaceAll('.','')) != null) {
      final n = int.parse(g.replaceAll('.',''));
      if (n >= 73 && n <= 89) return 'ciclo';
      if (n >= 54 && n <= 59) return 'zeropeca';
    }
    if (m != null) return 'auxiliar';
    return 'geral';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          Container(
            color: kDark,
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF534AB7),
                        borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.terminal_rounded, color: Colors.white, size: 20)),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Simulador CNC', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                        Text('ANALISA E EXPLICA CADA BLOCO', style: TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.5)),
                      ]),
                  ]),
                const SizedBox(height: 14),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1117),
                    borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: _ctrl,
                    maxLines: 6,
                    style: const TextStyle(color: Color(0xFFE6EDF3), fontSize: 13, fontFamily: 'monospace', height: 1.6),
                    decoration: InputDecoration(
                      hintText: 'Digite ou cole blocos CNC aqui...\nEx: G01 X50.0 Y30.0 F200\n    T01 M06\n    G43 H01 Z100.',
                      hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontFamily: 'monospace'),
                      contentPadding: const EdgeInsets.all(14),
                      border: InputBorder.none),
                  )),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _analisar,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF534AB7),
                            borderRadius: BorderRadius.circular(8)),
                          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text('Analisar Programa', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                          ])))),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () { _ctrl.clear(); setState(() { _resultados = []; _erro = ''; }); },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF252540),
                          borderRadius: BorderRadius.circular(8)),
                        child: const Icon(Icons.clear_rounded, color: Colors.grey, size: 18))),
                  ]),
              ])),
          if (_erro.isNotEmpty)
            Container(
              color: kRed.withValues(alpha: 0.1),
              padding: const EdgeInsets.all(12),
              child: Text(_erro, style: const TextStyle(color: kRed, fontSize: 12))),
          Expanded(
            child: _resultados.isEmpty
              ? _buildDicas()
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _resultados.length,
                  itemBuilder: (ctx, i) => Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: _BlocoCard(bloco: _resultados[i], numero: i + 1))))),
        ],
      ),
    );
  }

  Widget _buildDicas() {
    const exemplos = [
      'G00 X50.0 Y30.0 Z5.0',
      'G01 X100.0 F200',
      'G02 X30.0 Y0 R15.0 F150',
      'T01 M06',
      'G43 H01 Z100.',
      'S2000 M03',
      'G84 X20. Y15. Z-20. R5. F450',
      'G71 U2. R0.5',
      'G28 Z0',
      'M09\nM05\nM30',
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E3A),
                  borderRadius: BorderRadius.circular(10)),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.lightbulb_outline_rounded, color: kAmber, size: 16),
                      SizedBox(width: 8),
                      Text('Como usar:', style: TextStyle(color: kAmber, fontSize: 12, fontWeight: FontWeight.w600)),
                    ]),
                    SizedBox(height: 8),
                    Text(
                      '1. Digite qualquer bloco CNC no campo acima\n'
                      '2. Pode digitar múltiplas linhas de uma vez\n'
                      '3. Clique em Analisar para ver a explicação\n'
                      '4. Avisos inteligentes detectam erros comuns',
                      style: TextStyle(color: Colors.grey, fontSize: 12, height: 1.6)),
                  ])),
              const SizedBox(height: 16),
              const Text('EXEMPLOS RÁPIDOS',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1.2)),
              const SizedBox(height: 8),
              ...exemplos.map((ex) => GestureDetector(
                onTap: () {
                  _ctrl.text = ex;
                  _analisar();
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1117),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF21262D))),
                  child: Row(children: [
                    Expanded(child: Text(ex,
                      style: const TextStyle(color: Color(0xFF7EC8A4), fontSize: 12, fontFamily: 'monospace'))),
                    const Icon(Icons.play_arrow_rounded, color: Color(0xFF534AB7), size: 16),
                  ])))),
            ],
          ))),
      ],
    );
  }
}

// ─────────────────────────────────────────
// CARD DO BLOCO
// ─────────────────────────────────────────
class _BlocoCard extends StatefulWidget {
  final _BlocoExplicado bloco;
  final int numero;
  const _BlocoCard({required this.bloco, required this.numero});
  @override
  State<_BlocoCard> createState() => _BlocoCardState();
}

class _BlocoCardState extends State<_BlocoCard> {
  bool _expandido = true;

  Color get _corTipo {
    switch (widget.bloco.tipo) {
      case 'rapido':   return const Color(0xFF79C0FF);
      case 'corte':    return const Color(0xFF7EC8A4);
      case 'ciclo':    return kAmber;
      case 'auxiliar': return const Color(0xFFFFA657);
      case 'comentario': return const Color(0xFF8B949E);
      case 'programa': return kAmber;
      default:         return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1117),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF21262D))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          GestureDetector(
            onTap: () => setState(() => _expandido = !_expandido),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 24, height: 24,
                    decoration: BoxDecoration(
                      color: _corTipo.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4)),
                    child: Center(child: Text('${widget.numero}',
                      style: TextStyle(color: _corTipo, fontSize: 10, fontWeight: FontWeight.w700)))),
                  const SizedBox(width: 10),
                  Expanded(child: Text(widget.bloco.resumo,
                    style: TextStyle(color: _corTipo, fontSize: 12, fontWeight: FontWeight.w500))),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.bloco.linha));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Linha copiada!'), duration: Duration(seconds: 1)));
                    },
                    child: const Icon(Icons.copy_rounded, color: Color(0xFF8B949E), size: 14)),
                  const SizedBox(width: 8),
                  Icon(_expandido ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: const Color(0xFF8B949E), size: 16),
                ]))),

          // CÓDIGO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF161B22),
              border: Border(top: BorderSide(color: Color(0xFF21262D)))),
            child: Wrap(
              spacing: 6, runSpacing: 4,
              children: widget.bloco.partes.map((p) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: p.cor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: p.cor.withValues(alpha: 0.3))),
                child: Text(p.texto, style: TextStyle(color: p.cor, fontSize: 13, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
              )).toList())),

          // EXPLICAÇÕES
          if (_expandido) ...[
            ...widget.bloco.partes.where((p) => p.descricao.isNotEmpty).map((p) =>
              Container(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      child: Text(p.texto, style: TextStyle(
                        color: p.cor, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.w600))),
                    const Text(' → ', style: TextStyle(color: Color(0xFF8B949E), fontSize: 11)),
                    Expanded(child: Text(p.descricao, style: const TextStyle(
                      color: Color(0xFFE6EDF3), fontSize: 11, height: 1.4))),
                  ]))),
            // AVISOS
            ...widget.bloco.avisos.map((av) => Container(
              margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: av.startsWith('🚨')
                  ? kRed.withValues(alpha: 0.15)
                  : kAmber.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6)),
              child: Text(av, style: TextStyle(
                color: av.startsWith('🚨') ? kRed : kAmber,
                fontSize: 11, height: 1.4)))),
            const SizedBox(height: 8),
          ],
        ]));
  }
}

// ─────────────────────────────────────────
// MODELOS INTERNOS
// ─────────────────────────────────────────
class _BlocoExplicado {
  final String linha, resumo, tipo;
  final List<_Parte> partes;
  final List<String> avisos;
  const _BlocoExplicado({
    required this.linha, required this.partes,
    required this.resumo, required this.avisos, required this.tipo,
  });
}

class _Parte {
  final String texto, descricao;
  final Color cor;
  const _Parte({required this.texto, required this.cor, required this.descricao});
}

class _Endereco {
  final String letra, valorStr;
  const _Endereco({required this.letra, required this.valorStr});
}