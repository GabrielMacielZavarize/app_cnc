import 'package:flutter/material.dart';
import '../constants.dart';

class DicionarioScreen extends StatefulWidget {
  const DicionarioScreen({super.key});
  @override
  State<DicionarioScreen> createState() => _DicionarioScreenState();
}

class _DicionarioScreenState extends State<DicionarioScreen> {
  String _busca = '';
  String _cat = 'Todos';
  final _ctrl = TextEditingController();

  List<_Termo> get _filtrados {
    var lista = _termos;
    if (_cat != 'Todos') lista = lista.where((t) => t.categoria == _cat).toList();
    if (_busca.isNotEmpty) {
      final b = _busca.toLowerCase();
      lista = lista.where((t) =>
        t.pt.toLowerCase().contains(b) ||
        t.en.toLowerCase().contains(b) ||
        t.es.toLowerCase().contains(b) ||
        t.descricao.toLowerCase().contains(b)).toList();
    }
    return lista;
  }

  List<String> get _categorias {
    final s = <String>{'Todos'};
    for (final t in _termos) s.add(t.categoria);
    final l = s.toList()..sort();
    return l;
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final filtrados = _filtrados;
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          Container(
            color: kDark,
            padding: const EdgeInsets.fromLTRB(20, 55, 20, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: kGreen, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.translate_rounded, color: Colors.white, size: 20)),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Dicionário Técnico CNC',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                        Text('PT 🇧🇷 • EN 🇺🇸 • ES 🇪🇸',
                          style: TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.5)),
                      ]),
                  ]),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF252540),
                    borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      Icon(Icons.search,
                        color: _busca.isEmpty ? Colors.grey.shade500 : kAmber, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          onChanged: (v) => setState(() => _busca = v),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Buscar em PT, EN ou ES...',
                            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero))),
                      if (_busca.isNotEmpty)
                        GestureDetector(
                          onTap: () { _ctrl.clear(); setState(() => _busca = ''); },
                          child: Icon(Icons.close_rounded, color: Colors.grey.shade400, size: 18)),
                    ])),
                const SizedBox(height: 8),
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categorias.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (ctx, i) {
                      final cat = _categorias[i];
                      final ativo = _cat == cat;
                      return GestureDetector(
                        onTap: () => setState(() => _cat = cat),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: ativo ? kAmber : const Color(0xFF252540),
                            borderRadius: BorderRadius.circular(6)),
                          child: Text(cat,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: ativo ? kDark : Colors.grey.shade400))));
                    })),
              ])),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text('${filtrados.length} termos',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500))),
          Expanded(
            child: filtrados.isEmpty
              ? Center(
                  child: Text('Nenhum resultado para "$_busca"',
                    style: TextStyle(color: Colors.grey.shade400)))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtrados.length,
                  itemBuilder: (ctx, i) => Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: _TermoCard(termo: filtrados[i]))))),
        ]));
  }
}

class _TermoCard extends StatefulWidget {
  final _Termo termo;
  const _TermoCard({super.key, required this.termo});
  @override
  State<_TermoCard> createState() => _TermoCardState();
}

class _TermoCardState extends State<_TermoCard> {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expandido = !_expandido),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _expandido ? kGreen.withValues(alpha: 0.3) : Colors.grey.shade100,
            width: _expandido ? 1.5 : 0.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(widget.termo.pt,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: kDark))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(4)),
                              child: Text(widget.termo.categoria,
                                style: TextStyle(fontSize: 9, color: Colors.grey.shade500))),
                          ]),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _badge('EN', widget.termo.en, kBlue),
                            const SizedBox(width: 8),
                            _badge('ES', widget.termo.es, const Color(0xFF993C1D)),
                          ]),
                      ])),
                  const SizedBox(width: 8),
                  Icon(
                    _expandido ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                    color: Colors.grey.shade400, size: 18),
                ])),
            if (_expandido)
              Container(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(height: 12),
                    Text(widget.termo.descricao,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.5)),
                    if (widget.termo.exemplo.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: kDark,
                          borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Exemplo:',
                              style: TextStyle(
                                color: kAmber, fontSize: 10, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(widget.termo.exemplo,
                              style: const TextStyle(
                                color: Color(0xFF7EC8A4),
                                fontSize: 12,
                                fontFamily: 'monospace',
                                height: 1.5)),
                          ])),
                    ],
                  ])),
          ])));
  }

  Widget _badge(String lang, String texto, Color cor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: cor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(3)),
          child: Text(lang,
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: cor))),
        const SizedBox(width: 4),
        Flexible(
          child: Text(texto,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            overflow: TextOverflow.ellipsis)),
      ]);
  }
}

class _Termo {
  final String pt, en, es, descricao, exemplo, categoria;
  const _Termo({
    required this.pt, required this.en, required this.es,
    required this.descricao, this.exemplo = '', required this.categoria});
}

const _termos = [
  // ══ MÁQUINAS ══
  _Termo(pt: 'Centro de Usinagem', en: 'Machining Center', es: 'Centro de Mecanizado',
    descricao: 'Máquina CNC com trocador automático de ferramenta (ATC). Capaz de fresar, furar e roscar sem intervenção do operador.',
    categoria: 'Máquinas'),
  _Termo(pt: 'Torno CNC', en: 'CNC Lathe', es: 'Torno CNC',
    descricao: 'Máquina CNC para torneamento. A peça gira enquanto a ferramenta realiza o corte. Eixos X (diâmetro) e Z (comprimento).',
    categoria: 'Máquinas'),
  _Termo(pt: 'Fresadora', en: 'Milling Machine', es: 'Fresadora',
    descricao: 'Máquina para fresamento. A ferramenta gira e a mesa se move. Pode ser vertical ou horizontal.',
    categoria: 'Máquinas'),
  _Termo(pt: 'Retificadora', en: 'Grinding Machine', es: 'Rectificadora',
    descricao: 'Máquina com rebolo abrasivo para acabamento de alta precisão em peças endurecidas.',
    categoria: 'Máquinas'),
  _Termo(pt: 'Eletroerosão (EDM)', en: 'EDM - Electrical Discharge Machining', es: 'Electroerosión (EDM)',
    descricao: 'Remove material por descargas elétricas. Para formas complexas em materiais duros.',
    categoria: 'Máquinas'),

  // ══ OPERAÇÕES ══
  _Termo(pt: 'Fresamento', en: 'Milling', es: 'Fresado',
    descricao: 'Operação onde fresa rotativa remove material em várias direções.',
    exemplo: 'G01 X50.0 Y30.0 F200  ; Fresamento linear',
    categoria: 'Operações'),
  _Termo(pt: 'Torneamento', en: 'Turning', es: 'Torneado',
    descricao: 'A peça gira e ferramenta remove material para criar formas cilíndricas.',
    exemplo: 'G01 Z-50.0 F0.2  ; Torneamento longitudinal',
    categoria: 'Operações'),
  _Termo(pt: 'Furação', en: 'Drilling', es: 'Taladrado',
    descricao: 'Criação de furos cilíndricos com broca.',
    exemplo: 'G81 X20. Y15. Z-20. R2. F100  ; Ciclo de furação',
    categoria: 'Operações'),
  _Termo(pt: 'Mandrilamento', en: 'Boring', es: 'Mandrinado',
    descricao: 'Alargamento de furo existente para melhorar precisão e acabamento.',
    exemplo: 'G85 X30. Z-25. R2. F50  ; Mandrilamento',
    categoria: 'Operações'),
  _Termo(pt: 'Rosqueamento', en: 'Threading / Tapping', es: 'Roscado',
    descricao: 'Criação de roscas internas (macho G84) ou externas (G92 no torno). F = passo × RPM.',
    exemplo: 'G84 X20. Z-20. R5. F450  ; M10×1.5 a 300RPM',
    categoria: 'Operações'),
  _Termo(pt: 'Faceamento', en: 'Facing', es: 'Refrentado',
    descricao: 'Usinagem da face plana de uma peça para criar superfície perpendicular ao eixo.',
    categoria: 'Operações'),
  _Termo(pt: 'Sangramento', en: 'Grooving / Parting', es: 'Ranurado / Tronzado',
    descricao: 'Criação de canais (grooves) ou corte/separação de peças no torno.',
    exemplo: 'G75 R0.5\nG75 X16. Z-25. P1000 Q0 F0.05',
    categoria: 'Operações'),
  _Termo(pt: 'Chanframento', en: 'Chamfering', es: 'Achaflanado',
    descricao: 'Criação de bisel (ângulo 45°) nos cantos para facilitar montagem e eliminar rebarbas.',
    categoria: 'Operações'),
  _Termo(pt: 'Desbaste', en: 'Roughing', es: 'Desbaste',
    descricao: 'Remove grande quantidade de material com tolerâncias largas. Prepara para o acabamento.',
    categoria: 'Operações'),
  _Termo(pt: 'Acabamento', en: 'Finishing', es: 'Acabado',
    descricao: 'Fase final que garante dimensões finais e acabamento superficial desejado.',
    categoria: 'Operações'),

  // ══ FERRAMENTAS ══
  _Termo(pt: 'Fresa de Topo', en: 'End Mill', es: 'Fresa Frontal',
    descricao: 'Fresa cilíndrica com corte na ponta e laterais. 2, 3, 4 ou mais dentes (flutes).',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Fresa de Face', en: 'Face Mill', es: 'Fresa de Plaquita',
    descricao: 'Fresa grande com pastilhas intercambiáveis, para faceamento de superfícies planas.',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Broca', en: 'Drill Bit', es: 'Broca',
    descricao: 'Ferramenta rotativa para criação de furos. HSS (aço rápido) ou carbeto (metal duro).',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Macho de Roscar', en: 'Tap', es: 'Macho de Roscar',
    descricao: 'Ferramenta para criar roscas internas. Na CNC usa ciclo G84.',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Pastilha Intercambiável', en: 'Indexable Insert', es: 'Plaquita Intercambiable',
    descricao: 'Elemento de corte removível e substituível. CNMG, DCMT, CCMT são formas comuns.',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Porta-ferramenta', en: 'Tool Holder', es: 'Portaherramientas',
    descricao: 'Suporte que conecta a ferramenta ao spindle. Tipos: BT30, BT40, BT50, HSK.',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Apalpador / Sonda', en: 'Probe / Touch Probe', es: 'Palpador / Sonda',
    descricao: 'Ao tocar a peça envia sinal ao CNC para capturar posição (G31). Para medição automática.',
    categoria: 'Ferramentas'),

  // ══ PARÂMETROS ══
  _Termo(pt: 'Velocidade de Corte (Vc)', en: 'Cutting Speed (Vc)', es: 'Velocidad de Corte (Vc)',
    descricao: 'Velocidade da aresta em relação à peça, em m/min. Fórmula: Vc = π × D × n / 1000.',
    exemplo: 'Vc=200 m/min → n = 200×1000÷(π×10) = 6366 RPM',
    categoria: 'Parâmetros'),
  _Termo(pt: 'Avanço por Dente (fz)', en: 'Feed per Tooth (fz)', es: 'Avance por Diente (fz)',
    descricao: 'Espessura do cavaco por dente. fz = Vf ÷ (z × n).',
    exemplo: 'fz=0.05mm, 4 dentes, 3000RPM → Vf=600mm/min',
    categoria: 'Parâmetros'),
  _Termo(pt: 'Profundidade Axial (ap)', en: 'Axial Depth of Cut (ap)', es: 'Profundidad Axial (ap)',
    descricao: 'Profundidade de corte no eixo Z. Quanto a ferramenta mergulha na peça.',
    categoria: 'Parâmetros'),
  _Termo(pt: 'Profundidade Radial (ae)', en: 'Radial Depth of Cut (ae)', es: 'Profundidad Radial (ae)',
    descricao: 'Largura de corte. Quanto da fresa está em contato com a peça lateralmente.',
    categoria: 'Parâmetros'),
  _Termo(pt: 'Rotação (n / RPM)', en: 'Spindle Speed (RPM)', es: 'Velocidad de Husillo (RPM)',
    descricao: 'Rotações por minuto do spindle. n = Vc × 1000 ÷ (π × D).',
    exemplo: 'G97 S3000 M03  ; 3000 RPM fixo',
    categoria: 'Parâmetros'),

  // ══ USINAGEM ══
  _Termo(pt: 'Sobremetal', en: 'Stock / Allowance', es: 'Sobrante',
    descricao: 'Material extra deixado intencionalmente para ser removido no passe de acabamento.',
    exemplo: 'G71 P10 Q20 U0.4 W0.1  ; U=0.4mm sobremetal radial',
    categoria: 'Usinagem'),
  _Termo(pt: 'Encruamento', en: 'Work Hardening', es: 'Endurecimiento por Deformación',
    descricao: 'Endurecimento do material durante usinagem. Crítico em inox e Inconel — nunca parar no corte.',
    categoria: 'Usinagem'),
  _Termo(pt: 'Cavaco', en: 'Chip', es: 'Viruta',
    descricao: 'Material removido durante o corte. Forma, cor e tamanho indicam saúde do processo.',
    categoria: 'Usinagem'),
  _Termo(pt: 'Fluido de Corte', en: 'Cutting Fluid / Coolant', es: 'Fluido de Corte',
    descricao: 'Resfria ferramenta e peça, lubrifica e remove cavaco. M08 liga, M09 desliga.',
    categoria: 'Usinagem'),
  _Termo(pt: 'Chatter / Vibração', en: 'Chatter', es: 'Vibración',
    descricao: 'Vibração ressonante que causa marcas na superfície. Solução: mudar RPM ±10%.',
    categoria: 'Usinagem'),
  _Termo(pt: 'Fresamento Concordante', en: 'Climb Milling', es: 'Fresado en Avalancha',
    descricao: 'Fresa avança na mesma direção do avanço de mesa. Melhor acabamento, menos calor.',
    categoria: 'Usinagem'),
  _Termo(pt: 'Fresamento Discordante', en: 'Conventional Milling', es: 'Fresado en Oposición',
    descricao: 'Fresa em sentido contrário ao avanço. Mais vibração mas tolerante a folgas.',
    categoria: 'Usinagem'),

  // ══ PROGRAMAÇÃO ══
  _Termo(pt: 'Zero-Peça', en: 'Work Zero / Work Offset', es: 'Cero Pieza',
    descricao: 'Ponto de referência do programa CNC na peça. Definido nos offsets G54-G59.',
    exemplo: 'G54  ; Ativa zero-peça 1',
    categoria: 'Programação'),
  _Termo(pt: 'Zero Máquina', en: 'Machine Home', es: 'Cero Máquina',
    descricao: 'Ponto de referência absoluto da máquina. Base para todos os sistemas de coordenadas.',
    exemplo: 'G28 Z0  ; Retorna ao zero máquina',
    categoria: 'Programação'),
  _Termo(pt: 'Offset de Ferramenta', en: 'Tool Offset', es: 'Offset de Herramienta',
    descricao: 'Corrige comprimento (H) ou raio (D) da ferramenta. Essencial para precisão.',
    exemplo: 'G43 H01 Z100.  ; Ativa offset H01',
    categoria: 'Programação'),
  _Termo(pt: 'Subprograma', en: 'Subprogram', es: 'Subprograma',
    descricao: 'Programa auxiliar chamado com M98. Evita repetição de código.',
    exemplo: 'M98 P1001 L3  ; Chama O1001 três vezes',
    categoria: 'Programação'),
  _Termo(pt: 'Modal', en: 'Modal Command', es: 'Comando Modal',
    descricao: 'Comando que permanece ativo até ser cancelado. G01, G90, G94 são modais.',
    categoria: 'Programação'),
  _Termo(pt: 'Interpolação', en: 'Interpolation', es: 'Interpolación',
    descricao: 'Cálculo do caminho da ferramenta entre dois pontos. Linear (G01), circular (G02/G03).',
    categoria: 'Programação'),
  _Termo(pt: 'DNC', en: 'Direct Numeric Control', es: 'DNC',
    descricao: 'Transferência de programas CNC do computador para a máquina via RS-232, USB ou rede.',
    categoria: 'Programação'),
  _Termo(pt: 'Macro Paramétrica', en: 'Custom Macro / Parametric', es: 'Macro Paramétrica',
    descricao: 'Programação com variáveis, cálculos e lógica condicional no CNC (G65).',
    exemplo: 'G65 P9001 A20. B25.  ; Chama macro com parâmetros',
    categoria: 'Programação'),

  // ══ QUALIDADE ══
  _Termo(pt: 'Rugosidade (Ra)', en: 'Surface Roughness (Ra)', es: 'Rugosidad (Ra)',
    descricao: 'Textura superficial. Ra = média aritmética dos desvios. Ra 0.8μm = acabamento fino.',
    categoria: 'Qualidade'),
  _Termo(pt: 'Tolerância', en: 'Tolerance', es: 'Tolerancia',
    descricao: 'Variação dimensional permitida. Ex: 25.00 ±0.05mm → peça entre 24.95 e 25.05mm.',
    categoria: 'Qualidade'),
  _Termo(pt: 'Ajuste ISO', en: 'ISO Fit', es: 'Ajuste ISO',
    descricao: 'Sistema normalizado de tolerâncias. H7/h6 (deslizante), H7/p6 (interferência leve).',
    categoria: 'Qualidade'),
  _Termo(pt: 'Dureza HRC', en: 'Hardness HRC', es: 'Dureza HRC',
    descricao: 'Escala Rockwell C. Aço mole: 20-30HRC. Aço ferramenta endurecido: 58-64HRC.',
    categoria: 'Qualidade'),
  _Termo(pt: 'Planeza', en: 'Flatness', es: 'Planitud',
    descricao: 'Grau em que uma superfície é plana. Verificada com régua de precisão ou apalpador.',
    categoria: 'Qualidade'),

  // ══ SEGURANÇA ══
  _Termo(pt: 'Override de Avanço', en: 'Feed Override', es: 'Override de Avance',
    descricao: 'Botão no painel que ajusta o avanço F (0-200%). Bloquear com M49 no rosqueamento.',
    categoria: 'Segurança'),
  _Termo(pt: 'Dry Run', en: 'Dry Run', es: 'Pasada en Seco',
    descricao: 'Execução do programa sem cortar material para verificar trajetórias e detectar colisões.',
    categoria: 'Segurança'),
  _Termo(pt: 'Single Block', en: 'Single Block', es: 'Bloque a Bloque',
    descricao: 'Execução bloco a bloco. A máquina para após cada linha aguardando CYCLE START.',
    categoria: 'Segurança'),
  _Termo(pt: 'Colisão', en: 'Crash / Collision', es: 'Colisión',
    descricao: 'Contato não intencional entre ferramenta e peça/mesa. Causa danos graves à máquina.',
    categoria: 'Segurança'),
  _Termo(pt: 'Ponto Seguro', en: 'Safe Position', es: 'Posición Segura',
    descricao: 'Posição Z suficientemente alta para a ferramenta não tocar a peça durante posicionamento.',
    categoria: 'Segurança'),

  // ══ FERRAMENTAS AVANÇADAS ══
  _Termo(pt: 'Fresa de Raio (Ball Nose)', en: 'Ball Nose End Mill', es: 'Fresa de Radio / Bola',
    descricao: 'Fresa com ponta esférica. Usada para superfícies 3D, concordâncias e cavidades côncavas. Vc calculada no equador.',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Fresa de Chanfrar', en: 'Chamfer Mill', es: 'Fresa de Chaflanar',
    descricao: 'Fresa cônica 45°, 60° ou 90° para fazer chanfros em arestas. O ângulo da fresa define o ângulo do chanfro.',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Alargador (Reamer)', en: 'Reamer', es: 'Escariador',
    descricao: 'Ferramenta de acabamento para furos com tolerância H7/H8. Opera com baixo avanço e velocidade, removendo 0.1–0.3mm.',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Mandril (Boring Bar)', en: 'Boring Bar', es: 'Barra de Mandrilar',
    descricao: 'Ferramenta de mandrilamento para furos precisos. Ajuste micrométrico do raio permite atingir IT6 ou melhor.',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Pastilha CNMG', en: 'CNMG Insert', es: 'Plaquita CNMG',
    descricao: 'Inserto romboidal 80° — desbaste. C=forma 80°, N=sem ângulo de saída, M=tolerância M, G=quebra-cavaco.',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Pastilha DCMT', en: 'DCMT Insert', es: 'Plaquita DCMT',
    descricao: 'Inserto romboidal 55° — acabamento e perfilamento. D=55°, C=7° saída, M=tolerância, T=com furo e quebra-cavaco.',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Porta-Ferramenta HSK', en: 'HSK Tool Holder', es: 'Portaherramientas HSK',
    descricao: 'Interface cônica oca (Hollow Shank Taper). Alta rigidez e repetibilidade. Substitui o BT/ISO em centros modernos.',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Porta-Ferramenta BT40', en: 'BT40 Tool Holder', es: 'Portaherramientas BT40',
    descricao: 'Conestandard japonês 40° amplamente usado. BT40 é o mais comum em centros de médio porte no Brasil.',
    categoria: 'Ferramentas'),
  _Termo(pt: 'Collet / Pinça', en: 'Collet', es: 'Pinza / Collet',
    descricao: 'Pinça de fixação por compressão. Alta precisão de concentricidade (< 0.005mm). Tipos ER11, ER20, ER32, ER40.',
    categoria: 'Ferramentas'),

  // ══ PARÂMETROS DE CORTE ══
  _Termo(pt: 'Chatter / Vibração', en: 'Chatter', es: 'Vibración / Chatter',
    descricao: 'Vibração regenerativa entre ferramenta e peça. Causa marcas ondulatórias, quebra de ferramenta e ruído elevado. Reduzir ae ou ap.',
    categoria: 'Parâmetros'),
  _Termo(pt: 'Climb Milling (Concordante)', en: 'Climb Milling', es: 'Fresado Concordante',
    descricao: 'A ferramenta gira no mesmo sentido do avanço. Melhor acabamento, menor calor, mas exige máquina rígida. Padrão no CNC.',
    categoria: 'Parâmetros'),
  _Termo(pt: 'Conventional Milling (Discordante)', en: 'Conventional Milling', es: 'Fresado Discordante',
    descricao: 'Ferramenta gira contra o avanço. Menor risco de puxar a peça, útil em materiais endurecidos ou fixações precárias.',
    categoria: 'Parâmetros'),
  _Termo(pt: 'MRR — Taxa de Remoção', en: 'Material Removal Rate (MRR)', es: 'Tasa de Remoción (MRR)',
    descricao: 'Volume de material removido por minuto (cm³/min). MRR = ae × ap × Vf / 1000. Indicador de produtividade.',
    categoria: 'Parâmetros'),
  _Termo(pt: 'Tensão de Corte Específica (Kc)', en: 'Specific Cutting Force (Kc)', es: 'Fuerza Específica de Corte (Kc)',
    descricao: 'Força necessária para cortar 1mm² de seção de cavaco do material. Alumínio ≈ 700 N/mm², Aço 1020 ≈ 2500 N/mm².',
    categoria: 'Parâmetros'),
  _Termo(pt: 'Engajamento Radial (ae)', en: 'Radial Engagement (ae)', es: 'Enganche Radial (ae)',
    descricao: 'Largura de corte radial — quanto da fresa está em contato com o material. ae = 50% D é o padrão; ae > 80% = desbaste pesado.',
    categoria: 'Parâmetros'),
  _Termo(pt: 'Engajamento Axial (ap)', en: 'Axial Depth of Cut (ap)', es: 'Profundidad Axial (ap)',
    descricao: 'Profundidade axial do corte. ap ≤ 1×D em aço; ap ≤ 2×D em alumínio. Exceder causa vibração e quebra.',
    categoria: 'Parâmetros'),

  // ══ CNC / CONTROLE ══
  _Termo(pt: 'MDI — Entrada Manual de Dados', en: 'MDI — Manual Data Input', es: 'MDI — Entrada Manual de Datos',
    descricao: 'Modo de operação onde o operador digita um bloco G-code diretamente e executa sem programa salvo. Útil para movimentos pontuais.',
    categoria: 'CNC'),
  _Termo(pt: 'DNC — Controle Numérico Direto', en: 'DNC — Direct Numerical Control', es: 'DNC — Control Numérico Directo',
    descricao: 'Transmissão de programas CNC em tempo real por RS-232, USB ou rede. Usado para programas maiores que a memória do controle.',
    categoria: 'CNC'),
  _Termo(pt: 'G54–G59 — Offsets de Trabalho', en: 'Work Offsets G54–G59', es: 'Offsets de Trabajo G54–G59',
    descricao: 'Sistemas de coordenadas de trabalho no CNC. G54 é o padrão; G55–G59 para múltiplas fixações na mesma operação.',
    categoria: 'CNC'),
  _Termo(pt: 'Macro Paramétrica', en: 'Parametric Macro', es: 'Macro Paramétrica',
    descricao: 'Programa CNC com variáveis (#1–#33 usuário, #100–#199 locais) para criar famílias de peças e ciclos customizados.',
    categoria: 'CNC'),
  _Termo(pt: 'Plano de Trabalho G17/G18/G19', en: 'Work Plane G17/G18/G19', es: 'Plano de Trabajo G17/G18/G19',
    descricao: 'Define o plano de interpolação. G17=XY (fresamento), G18=XZ (torneamento), G19=YZ. Afeta G02/G03 e compensação de raio.',
    categoria: 'CNC'),
  _Termo(pt: 'M30 vs M02', en: 'M30 vs M02', es: 'M30 vs M02',
    descricao: 'M30 fim de programa + rebobina (reinicia do início). M02 apenas fim de programa sem rebobinar. No Fanuc, M30 é o padrão.',
    categoria: 'CNC'),
  _Termo(pt: 'Ciclo Fixo (Canned Cycle)', en: 'Canned Cycle', es: 'Ciclo Fijo',
    descricao: 'G80–G89: ciclos pré-programados para furação, rosqueamento e mandrilamento. Simplificam a programação repetitiva.',
    categoria: 'CNC'),
  _Termo(pt: 'Subprograma', en: 'Subprogram', es: 'Subprograma',
    descricao: 'Programa auxiliar chamado por M98 e encerrado com M99. Permite reutilizar sequências como furos ou perfis repetidos.',
    categoria: 'CNC'),
  _Termo(pt: 'G28 — Retorno à Referência', en: 'G28 — Return to Reference', es: 'G28 — Retorno a Referencia',
    descricao: 'Retorna os eixos ao ponto de referência da máquina (home/zero máquina). Obrigatório antes da troca de ferramenta manual.',
    categoria: 'CNC'),

  // ══ METROLOGIA ══
  _Termo(pt: 'Micrômetro Externo', en: 'Outside Micrometer', es: 'Micrómetro Exterior',
    descricao: 'Instrumento para medir diâmetros externos com resolução 0.01mm (analógico) ou 0.001mm (digital). Faixa típica: 0–25mm por peça.',
    categoria: 'Qualidade'),
  _Termo(pt: 'Micrômetro de 3 Pontos (Bore Gauge)', en: 'Three-Point Inside Micrometer', es: 'Micrómetro de 3 Puntos',
    descricao: 'Mede furos de precisão. Três contatos garantem medição no diâmetro real. Essencial para furos H6/H7.',
    categoria: 'Qualidade'),
  _Termo(pt: 'Relógio Comparador (DTI)', en: 'Dial Test Indicator (DTI)', es: 'Reloj Comparador (DTI)',
    descricao: 'Mede desvios de até 0.001mm. Usado para alinhar peças, verificar batimento e encontrar borda (edge finding).',
    categoria: 'Qualidade'),
  _Termo(pt: 'Rugosímetro', en: 'Surface Roughness Tester', es: 'Rugosímetro',
    descricao: 'Instrumento que mede Ra, Rz, Rmax etc. com uma ponta de diamante deslizando sobre a superfície. Portátil ou de bancada.',
    categoria: 'Qualidade'),
  _Termo(pt: 'CMM — Máquina de Medir por Coordenadas', en: 'CMM — Coordinate Measuring Machine', es: 'MMC — Máquina de Medir por Coordenadas',
    descricao: 'Equipamento de metrologia de alta precisão. Mede formas, posições e tolerâncias complexas com apalpador 3D.',
    categoria: 'Qualidade'),
  _Termo(pt: 'Paquímetro', en: 'Vernier Caliper', es: 'Calibrador Vernier / Pie de Rey',
    descricao: 'Instrumento de medição universal (externo, interno, profundidade, degrau). Resolução 0.02mm (analógico) ou 0.01mm (digital).',
    categoria: 'Qualidade'),

  // ══ MATERIAIS ══
  _Termo(pt: 'Aço SAE 1020', en: 'SAE 1020 Steel', es: 'Acero SAE 1020',
    descricao: 'Aço de baixo carbono (0.18-0.23% C). Boa usinabilidade, soldabilidade. Dureza ≈ 140 HB. Vc recomendada: 180-250 m/min.',
    categoria: 'Materiais'),
  _Termo(pt: 'Aço SAE 4140', en: 'SAE 4140 Steel', es: 'Acero SAE 4140',
    descricao: 'Aço cromo-molibdênio. Excelente resistência mecânica. Usinado normalizado: Vc 150-200 m/min. Temperado: 80-120 m/min.',
    categoria: 'Materiais'),
  _Termo(pt: 'Aço Inoxidável 304', en: 'Stainless Steel 304', es: 'Acero Inoxidable 304',
    descricao: 'Liga austenítica 18%Cr-8%Ni. Alta resistência à corrosão, encruamento severo. Vc 100-150 m/min, fz baixo, refrigeração abundante.',
    categoria: 'Materiais'),
  _Termo(pt: 'Alumínio 6061', en: 'Aluminum 6061', es: 'Aluminio 6061',
    descricao: 'Liga Al-Mg-Si. Excelente usinabilidade. Vc 400-1200 m/min, fz alto, aresta viva essencial para evitar BUE.',
    categoria: 'Materiais'),
  _Termo(pt: 'Ferro Fundido Cinzento', en: 'Gray Cast Iron', es: 'Hierro Fundido Gris',
    descricao: 'Usinagem a seco possível (grafita lubrifica). Cavaco quebradiço. Vc 80-150 m/min. Sensível a impacto — evitar interrupções.',
    categoria: 'Materiais'),
  _Termo(pt: 'Titânio Ti-6Al-4V', en: 'Titanium Ti-6Al-4V', es: 'Titanio Ti-6Al-4V',
    descricao: 'Material difícil de usinar. Baixa condutividade térmica — calor fica na aresta. Vc 40-60 m/min, flood coolant obrigatório.',
    categoria: 'Materiais'),
];