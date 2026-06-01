import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class ProgramasScreen extends StatefulWidget {
  const ProgramasScreen({super.key});
  @override
  State<ProgramasScreen> createState() => _ProgramasScreenState();
}

class _ProgramasScreenState extends State<ProgramasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  String _busca = '';

  @override
  void initState() { super.initState(); _tab = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(children: [
        Container(
          color: kDark,
          padding: const EdgeInsets.fromLTRB(20, 55, 20, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 36, height: 36,
                decoration: BoxDecoration(color: const Color(0xFF2E7D32), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.code_rounded, color: Colors.white, size: 20)),
              const SizedBox(width: 12),
              const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Banco de Programas', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                Text('EXEMPLOS REAIS DE CHÃO DE FÁBRICA', style: TextStyle(color: Colors.grey, fontSize: 9, letterSpacing: 1.5)),
              ]),
            ]),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: const Color(0xFF252540), borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                Icon(Icons.search, color: Colors.grey.shade500, size: 18),
                const SizedBox(width: 10),
                Expanded(child: TextField(
                  onChanged: (v) => setState(() => _busca = v.toLowerCase()),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Buscar programa...',
                    hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                )),
              ]),
            ),
            const SizedBox(height: 12),
            TabBar(
              controller: _tab,
              labelColor: kAmber, unselectedLabelColor: Colors.grey,
              indicatorColor: kAmber, indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true, tabAlignment: TabAlignment.start,
              labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: 'Fresamento (${_programasFresamento.length})'),
                Tab(text: 'Torneamento (${_programasTorneamento.length})'),
                Tab(text: 'Especiais (${_programasEspeciais.length})'),
              ],
            ),
          ]),
        ),
        Expanded(child: TabBarView(controller: _tab, children: [
          _ProgramasList(programas: [..._programasFresamento, ..._programasFresamentoExtras], busca: _busca),
          _ProgramasList(programas: [..._programasTorneamento, ..._programasTorneamentoExtras], busca: _busca),
          _ProgramasList(programas: [..._programasEspeciais, ..._programasEspeciaisExtras], busca: _busca),
        ])),
      ]),
    );
  }
}

// ─────────────────────────────────────────
// LISTA
// ─────────────────────────────────────────
class _ProgramasList extends StatelessWidget {
  final List<ProgramaCNC> programas;
  final String busca;
  const _ProgramasList({required this.programas, required this.busca});

  @override
  Widget build(BuildContext context) {
    final f = busca.isEmpty
      ? programas
      : programas.where((p) =>
          p.titulo.toLowerCase().contains(busca) ||
          p.descricao.toLowerCase().contains(busca) ||
          p.tags.any((t) => t.toLowerCase().contains(busca))).toList();

    if (f.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
      const SizedBox(height: 12),
      Text('Nenhum programa encontrado', style: TextStyle(color: Colors.grey.shade400)),
    ]));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: f.length,
      itemBuilder: (ctx, i) => Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: _ProgramaCard(programa: f[i]))),
    );
  }
}

// ─────────────────────────────────────────
// CARD
// ─────────────────────────────────────────
class _ProgramaCard extends StatelessWidget {
  final ProgramaCNC programa;
  const _ProgramaCard({required this.programa});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => ProgramaDetalheScreen(programa: programa))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 44, height: 44,
              decoration: BoxDecoration(
                color: programa.cor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10)),
              child: Icon(programa.icone, color: programa.cor, size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(programa.titulo,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Text(programa.subtitulo,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _corNivel(programa.nivel).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6)),
              child: Text(programa.nivel,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                  color: _corNivel(programa.nivel)))),
          ]),
          const SizedBox(height: 10),
          Text(programa.descricao,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
            maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          Row(children: [
            Icon(Icons.build_rounded, size: 12, color: Colors.grey.shade400),
            const SizedBox(width: 4),
            Expanded(child: Text(programa.ferramentas.take(2).join(' • '),
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
              maxLines: 1, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: Colors.grey.shade300, size: 18),
          ]),
          const SizedBox(height: 8),
          Wrap(spacing: 6, runSpacing: 4, children: programa.tags.map((t) =>
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
              child: Text(t, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)))).toList()),
        ]),
      ),
    );
  }

  Color _corNivel(String nivel) {
    switch (nivel) {
      case 'Básico': return kGreen;
      case 'Intermediário': return kAmber;
      case 'Avançado': return kRed;
      default: return kBlue;
    }
  }
}

// ─────────────────────────────────────────
// DETALHE DO PROGRAMA
// ─────────────────────────────────────────
class ProgramaDetalheScreen extends StatefulWidget {
  final ProgramaCNC programa;
  const ProgramaDetalheScreen({super.key, required this.programa});
  @override
  State<ProgramaDetalheScreen> createState() => _ProgramaDetalheScreenState();
}

class _ProgramaDetalheScreenState extends State<ProgramaDetalheScreen> {
  bool _mostrarExplicacao = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kDark,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context)),
        title: Text(widget.programa.titulo,
          style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_all_rounded, color: kAmber),
            tooltip: 'Copiar programa',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.programa.codigo));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('✅ Programa copiado para a área de transferência!'),
                duration: Duration(seconds: 2)));
            }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // INFO HEADER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(14)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: widget.programa.cor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10)),
                    child: Icon(widget.programa.icone, color: widget.programa.cor, size: 24)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.programa.titulo,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(widget.programa.subtitulo,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: widget.programa.cor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8)),
                    child: Text(widget.programa.nivel,
                      style: TextStyle(color: widget.programa.cor, fontSize: 11, fontWeight: FontWeight.w700))),
                ]),
                const SizedBox(height: 12),
                Text(widget.programa.descricao,
                  style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.5)),
              ]),
            ),
            const SizedBox(height: 12),

            // FERRAMENTAS
            _secao('Ferramentas Necessárias', Icons.build_rounded, kBlue,
              Column(children: widget.programa.ferramentas.asMap().entries.map((e) =>
                Padding(padding: const EdgeInsets.only(bottom: 6),
                  child: Row(children: [
                    Container(width: 24, height: 24,
                      decoration: BoxDecoration(color: const Color(0xFFE6F1FB), borderRadius: BorderRadius.circular(6)),
                      child: Center(child: Text('T${e.key+1}',
                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: kBlue)))),
                    const SizedBox(width: 10),
                    Expanded(child: Text(e.value,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF333333)))),
                  ]))).toList())),
            const SizedBox(height: 12),

            // SETUP
            _secao('Informações de Setup', Icons.settings_rounded, const Color(0xFF993C1D),
              Column(children: widget.programa.setup.asMap().entries.map((e) =>
                Padding(padding: const EdgeInsets.only(bottom: 6),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Icon(Icons.arrow_right_rounded, color: const Color(0xFF993C1D), size: 18),
                    const SizedBox(width: 4),
                    Expanded(child: Text(e.value,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4))),
                  ]))).toList())),
            const SizedBox(height: 12),

            // TOGGLE CÓDIGO / EXPLICAÇÃO
            Row(children: [
              Expanded(child: GestureDetector(
                onTap: () => setState(() => _mostrarExplicacao = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: !_mostrarExplicacao ? kDark : Colors.white,
                    borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
                    border: Border.all(color: !_mostrarExplicacao ? kAmber : Colors.grey.shade200)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.code_rounded, size: 16,
                      color: !_mostrarExplicacao ? kAmber : Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text('Código CNC', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                      color: !_mostrarExplicacao ? kAmber : Colors.grey.shade500)),
                  ])),
              )),
              Expanded(child: GestureDetector(
                onTap: () => setState(() => _mostrarExplicacao = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _mostrarExplicacao ? kDark : Colors.white,
                    borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                    border: Border.all(color: _mostrarExplicacao ? kAmber : Colors.grey.shade200)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.menu_book_rounded, size: 16,
                      color: _mostrarExplicacao ? kAmber : Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text('Com explicação', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                      color: _mostrarExplicacao ? kAmber : Colors.grey.shade500)),
                  ])),
              )),
            ]),
            const SizedBox(height: 8),

            // CÓDIGO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFF21262D), borderRadius: BorderRadius.circular(6)),
                    child: Row(children: [
                      Container(width: 10, height: 10,
                        decoration: BoxDecoration(color: widget.programa.cor, shape: BoxShape.circle)),
                      const SizedBox(width: 6),
                      Text(widget.programa.titulo,
                        style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    ])),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.programa.codigo));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Código copiado!'),
                        duration: Duration(seconds: 1)));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF21262D), borderRadius: BorderRadius.circular(6)),
                      child: const Row(children: [
                        Icon(Icons.copy_rounded, color: kAmber, size: 12),
                        SizedBox(width: 4),
                        Text('Copiar', style: TextStyle(color: kAmber, fontSize: 10)),
                      ])),
                  ),
                ]),
                const SizedBox(height: 12),
                _mostrarExplicacao
                  ? _buildCodigoExplicado(widget.programa.linhasExplicadas)
                  : SelectableText(widget.programa.codigo,
                      style: const TextStyle(color: Color(0xFFE6EDF3),
                        fontSize: 12, fontFamily: 'monospace', height: 1.6)),
              ]),
            ),
            const SizedBox(height: 12),

            // DICAS
            if (widget.programa.dicas.isNotEmpty)
              _secao('Dicas de Chão de Fábrica', Icons.lightbulb_outline_rounded, kAmber,
                Column(children: widget.programa.dicas.asMap().entries.map((e) =>
                  Padding(padding: const EdgeInsets.only(bottom: 8),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(width: 22, height: 22, margin: const EdgeInsets.only(top: 1),
                        decoration: BoxDecoration(color: const Color(0xFFFFF3DC), borderRadius: BorderRadius.circular(11)),
                        child: Center(child: Text('${e.key+1}',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFFBA7517))))),
                      const SizedBox(width: 8),
                      Expanded(child: Text(e.value,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4))),
                    ]))).toList())),
            const SizedBox(height: 20),
          ]),
        )),
      ),
    );
  }

  Widget _secao(String titulo, IconData icon, Color cor, Widget child) => Container(
    width: double.infinity, padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade100)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, size: 15, color: cor), const SizedBox(width: 6),
        Text(titulo, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: cor))]),
      const SizedBox(height: 10), child,
    ]));

  Widget _buildCodigoExplicado(List<LinhaExplicada> linhas) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: linhas.map((l) {
        if (l.isComentario) {
          return Padding(padding: const EdgeInsets.only(bottom: 2),
            child: Text(l.codigo,
              style: const TextStyle(color: Color(0xFF8B949E), fontSize: 12, fontFamily: 'monospace', height: 1.6)));
        }
        if (l.explicacao.isEmpty) {
          return Padding(padding: const EdgeInsets.only(bottom: 2),
            child: Text(l.codigo,
              style: const TextStyle(color: Color(0xFFE6EDF3), fontSize: 12, fontFamily: 'monospace', height: 1.6)));
        }
        return Padding(padding: const EdgeInsets.only(bottom: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(flex: 3, child: Text(l.codigo,
              style: const TextStyle(color: Color(0xFF79C0FF), fontSize: 12, fontFamily: 'monospace', height: 1.6))),
            const SizedBox(width: 8),
            Expanded(flex: 2, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFF21262D), borderRadius: BorderRadius.circular(4)),
              child: Text('; ${l.explicacao}',
                style: const TextStyle(color: Color(0xFF8B949E), fontSize: 10, height: 1.4)))),
          ]));
      }).toList());
  }
}

// ─────────────────────────────────────────
// MODELO
// ─────────────────────────────────────────
class ProgramaCNC {
  final String titulo, subtitulo, descricao, codigo, nivel;
  final List<String> ferramentas, setup, dicas, tags;
  final List<LinhaExplicada> linhasExplicadas;
  final Color cor;
  final IconData icone;
  const ProgramaCNC({
    required this.titulo, required this.subtitulo, required this.descricao,
    required this.codigo, required this.nivel, required this.ferramentas,
    required this.setup, required this.dicas, required this.tags,
    required this.linhasExplicadas, required this.cor, required this.icone,
  });
}

class LinhaExplicada {
  final String codigo, explicacao;
  final bool isComentario;
  const LinhaExplicada(this.codigo, {this.explicacao = '', this.isComentario = false});
}

// ─────────────────────────────────────────
// DADOS — FRESAMENTO
// ─────────────────────────────────────────
const _programasFresamento = [

  ProgramaCNC(
    titulo: 'Faceamento de Peça Retangular',
    subtitulo: 'Centro de usinagem vertical — Fanuc',
    nivel: 'Básico',
    descricao: 'Faceamento completo de uma peça retangular 100×80mm com fresa de topo plano Ø50mm. Programa didático e bem comentado.',
    cor: Color(0xFF185FA5), icone: Icons.crop_square_rounded,
    ferramentas: ['T01 — Fresa de topo plano Ø50mm, 4 dentes, metal duro', 'T02 — Fresa de topo Ø16mm (acabamento lateral se necessário)'],
    setup: [
      'Zero-peça G54: canto inferior esquerdo da peça, Z=0 no topo',
      'Peça: 100×80×30mm de aço 1020 fixada em morsa',
      'Sobremetal: 0.5mm no topo para remoção',
      'Altura segura de aproximação: Z=5mm',
    ],
    tags: ['faceamento', 'fresamento', 'retangular', 'básico', 'fanuc'],
    dicas: [
      'Nunca iniciar o faceamento com a fresa diretamente sobre a peça — sempre entrar lateralmente',
      'Sobreposição de 50% do diâmetro da fresa garante faceamento uniforme',
      'Usar G96 com velocidade de corte constante para melhor acabamento',
      'Verificar planicidade com relógio comparador após o faceamento',
    ],
    codigo: '''O0001 (FACEAMENTO 100X80MM)
;
; PROGRAMA: FACEAMENTO PEÇA RETANGULAR
; MATERIAL: ACO 1020
; MAQUINA:  CENTRO USINAGEM VERTICAL
; DATA:     CNCIA APP
;
G21 G40 G49 G80    (INIT: MM, CANCELA COMP.)
G91 G28 Z0         (RETORNO Z AO ZERO)
G91 G28 X0 Y0      (RETORNO XY AO ZERO)
G90                (MODO ABSOLUTO)
;
; ====== FERRAMENTA 1 — FRESA Ø50MM ======
T01 M06            (TROCA PARA T01)
G43 H01 Z100.      (COMP. COMPRIMENTO H01)
G54                (ZERO-PECA 1)
S800 M03           (800 RPM HORARIO)
M08                (LIGA REFRIGERACAO)
;
; --- APROXIMACAO ---
G00 X-60. Y-10.    (POSICIONA FORA DA PECA)
G00 Z2.            (APROXIMA RAPIDO)
;
; --- PASSE 1: Y=-10 (ENTRADA LATERAL) ---
G01 Z-0.5 F100.    (DESCE 0.5MM — AP DE FACE)
G01 X160. F250.    (PASSA TODA A PECA EM X)
;
; --- PASSE 2 ---
G00 Y25.           (DESLOCA 35MM EM Y)
G01 X-60. F250.    (RETORNA EM X)
;
; --- PASSE 3 ---
G00 Y60.           (DESLOCA MAIS 35MM)
G01 X160. F250.    (AVANCA EM X)
;
; --- PASSE 4 (COBRE TODA A LARGURA) ---
G00 Y90.           (POSICAO FINAL)
G01 X-60. F250.    (RETORNA)
;
; --- SAIDA SEGURA ---
G00 Z50.           (SOBE Z)
M09                (DESLIGA REFRIGERACAO)
;
; ====== FIM DO PROGRAMA ======
G91 G28 Z0         (RETORNO Z AO ZERO)
G91 G28 X0 Y0      (RETORNO XY AO ZERO)
M05                (PARA SPINDLE)
M30                (FIM E REBOBINA)''',
    linhasExplicadas: [
      LinhaExplicada('O0001 (FACEAMENTO 100X80MM)', isComentario: true),
      LinhaExplicada('G21 G40 G49 G80', explicacao: 'Inicialização — mm, cancela compensações'),
      LinhaExplicada('G91 G28 Z0', explicacao: 'Retorno Z ao zero máquina'),
      LinhaExplicada('G91 G28 X0 Y0', explicacao: 'Retorno XY ao zero máquina'),
      LinhaExplicada('G90', explicacao: 'Modo absoluto — padrão'),
      LinhaExplicada('T01 M06', explicacao: 'Troca para fresa Ø50mm'),
      LinhaExplicada('G43 H01 Z100.', explicacao: 'Ativa compensação de comprimento H01'),
      LinhaExplicada('G54', explicacao: 'Ativa zero-peça 1'),
      LinhaExplicada('S800 M03', explicacao: 'Liga 800 RPM horário'),
      LinhaExplicada('M08', explicacao: 'Liga refrigeração'),
      LinhaExplicada('G00 X-60. Y-10.', explicacao: 'Posiciona fora da peça antes de descer'),
      LinhaExplicada('G00 Z2.', explicacao: 'Aproxima rápido a 2mm da peça'),
      LinhaExplicada('G01 Z-0.5 F100.', explicacao: 'Desce 0.5mm — profundidade de faceamento'),
      LinhaExplicada('G01 X160. F250.', explicacao: 'Faceamento: avança em X passando toda a peça'),
      LinhaExplicada('G00 Y25.', explicacao: 'Desloca 35mm em Y (sobreposição 50% fresa)'),
      LinhaExplicada('G01 X-60. F250.', explicacao: 'Retorna em X faceiando o próximo passe'),
      LinhaExplicada('G00 Z50.', explicacao: 'Sobe Z para posição segura'),
      LinhaExplicada('M09', explicacao: 'Desliga refrigeração'),
      LinhaExplicada('G91 G28 Z0', explicacao: 'Retorno ao zero máquina'),
      LinhaExplicada('M05', explicacao: 'Para spindle'),
      LinhaExplicada('M30', explicacao: 'Fim do programa e rebobina'),
    ]),

  ProgramaCNC(
    titulo: 'Contorno Externo Retangular',
    subtitulo: 'Fresamento de perfil externo com compensação de raio',
    nivel: 'Intermediário',
    descricao: 'Usinagem de contorno externo 60×40mm em peça 70×50mm. Usa compensação de raio G41 para garantir as cotas exatas independente do diâmetro da fresa.',
    cor: Color(0xFF0F6E56), icone: Icons.crop_free_rounded,
    ferramentas: ['T01 — Fresa de topo Ø12mm, 4 dentes, metal duro, TiAlN'],
    setup: [
      'Zero-peça G54: centro da peça, Z=0 no topo',
      'Peça: 70×50×20mm de aço 1020 em morsa',
      'Profundidade total: 10mm (2 passes de 5mm)',
      'Offset D01 = 6.0mm (raio da fresa Ø12mm)',
    ],
    tags: ['contorno', 'fresamento', 'G41', 'compensação de raio', 'intermediário'],
    dicas: [
      'A compensação G41 permite trocar a fresa por outra de diâmetro diferente sem reprogramar — só muda o offset D',
      'Sempre entrar tangencialmente ao perfil para evitar marcas de entrada',
      'Fazer 1 passe de desbaste (D maior) e 1 de acabamento (D exato) para melhor qualidade',
      'Verificar se D01 na tabela de offsets está correto antes de iniciar',
    ],
    codigo: '''O0002 (CONTORNO EXTERNO 60X40MM)
;
; RAIO FRESA: D01 = 6.0MM (FRESA O12MM)
; ZERO: CENTRO DA PECA, Z=0 NO TOPO
;
G21 G40 G49 G80
G91 G28 Z0
G90

T01 M06
G43 H01 Z100.
G54
S2000 M03
M08

; === PASSE 1: DESBASTE (Z=-5MM) ===
G00 X0 Y-40.       (POSICAO DE ENTRADA)
G00 Z2.
G01 Z-5. F100.     (DESCE 5MM)

; ENTRADA TANGENCIAL (ARCO)
G41 D01 G01 X-30. Y-40. F200.
G03 X-30. Y-20. R20.   (ARCO DE ENTRADA)

; CONTORNO EXTERNO (HORARIO = G41 ESQUERDA)
G01 Y20.           (LATERAL ESQUERDA)
G01 X30.           (TOPO)
G01 Y-20.          (LATERAL DIREITA)
G01 X-30.          (BASE)

; SAIDA TANGENCIAL
G03 X-30. Y-40. R20.
G40 G00 X0 Y-40.   (CANCELA COMP. RAIO)

; === PASSE 2: ACABAMENTO (Z=-10MM) ===
G00 X0 Y-40.
G01 Z-10. F80.

G41 D01 G01 X-30. Y-40. F150.
G03 X-30. Y-20. R20.
G01 Y20.
G01 X30.
G01 Y-20.
G01 X-30.
G03 X-30. Y-40. R20.
G40 G00 X0 Y-40.

G00 Z50.
M09
G91 G28 Z0
G91 G28 X0 Y0
M05
M30''',
    linhasExplicadas: [
      LinhaExplicada('O0002 (CONTORNO EXTERNO 60X40MM)', isComentario: true),
      LinhaExplicada('G21 G40 G49 G80', explicacao: 'Inicialização padrão'),
      LinhaExplicada('T01 M06', explicacao: 'Fresa de topo Ø12mm'),
      LinhaExplicada('G43 H01 Z100.', explicacao: 'Compensação de comprimento'),
      LinhaExplicada('S2000 M03', explicacao: '2000 RPM — Vc ≈ 75 m/min para aço'),
      LinhaExplicada('G00 X0 Y-40.', explicacao: 'Posição de entrada — fora da peça'),
      LinhaExplicada('G01 Z-5. F100.', explicacao: 'Mergulha 5mm — 1º passe desbaste'),
      LinhaExplicada('G41 D01 G01 X-30. Y-40. F200.', explicacao: 'ATIVA compensação raio esquerda D01'),
      LinhaExplicada('G03 X-30. Y-20. R20.', explicacao: 'Arco tangencial de entrada — sem marca'),
      LinhaExplicada('G01 Y20.', explicacao: 'Lateral esquerda do contorno'),
      LinhaExplicada('G01 X30.', explicacao: 'Topo do contorno'),
      LinhaExplicada('G01 Y-20.', explicacao: 'Lateral direita do contorno'),
      LinhaExplicada('G01 X-30.', explicacao: 'Base do contorno'),
      LinhaExplicada('G03 X-30. Y-40. R20.', explicacao: 'Arco de saída — fecha o loop'),
      LinhaExplicada('G40 G00 X0 Y-40.', explicacao: 'CANCELA compensação de raio'),
      LinhaExplicada('G01 Z-10. F80.', explicacao: 'Desce para passe 2 — acabamento'),
      LinhaExplicada('M30', explicacao: 'Fim e rebobina'),
    ]),

  ProgramaCNC(
    titulo: 'Bolsão Circular (Pocket)',
    subtitulo: 'Fresamento de cavidade circular Ø40mm',
    nivel: 'Intermediário',
    descricao: 'Usinagem de bolsão circular Ø40mm com 8mm de profundidade. Estratégia de espiral crescente partindo do centro — ideal para fresamento de cavidades.',
    cor: Color(0xFF993C1D), icone: Icons.circle_outlined,
    ferramentas: ['T01 — Fresa de topo Ø10mm, 4 dentes, metal duro com fundo plano'],
    setup: [
      'Zero-peça G54: centro do bolsão, Z=0 no topo da peça',
      'Peça: qualquer dimensão maior que Ø60mm',
      'Mergulho central de 2mm para iniciar a espiral',
      'Offset D01 = 5.0mm (raio da fresa Ø10mm)',
    ],
    tags: ['bolsão', 'pocket', 'fresamento', 'circular', 'espiral'],
    dicas: [
      'Sempre mergulhar ao centro do bolsão para iniciar — nunca na parede',
      'A estratégia de espiral crescente distribui melhor o calor',
      'Último passe junto à parede (raio exato do bolsão) garante o acabamento lateral',
      'Fresa deve ter capacidade de mergulho (centro cortante) para esta estratégia',
    ],
    codigo: '''O0003 (BOLSAO CIRCULAR O40MM, P=8MM)
;
; ESTRATEGIA: ESPIRAL CRESCENTE DO CENTRO
; FRESA O10MM, 4 DENTES
; ZERO: CENTRO DO BOLSAO
;
G21 G40 G49 G80
G91 G28 Z0
G90

T01 M06
G43 H01 Z100.
G54
S3000 M03
M08

G00 X0 Y0         (POSICIONA NO CENTRO)
G00 Z2.

; === PASSE 1 (Z=-3MM) ===
G01 Z-3. F80.     (MERGULHA NO CENTRO)

; ESPIRAL: RAIO 0 -> 5 -> 10 -> 15 -> 20
G03 X5. Y0 I2.5 J0 F200.    (ARC R=2.5)
G03 X5. Y0 I-5. J0           (ARC COMPLETO R=5)
G03 X10. Y0 I-2.5 J0         (TRANSICAO)
G03 X10. Y0 I-10. J0         (ARC R=10)
G03 X15. Y0 I-2.5 J0
G03 X15. Y0 I-15. J0         (ARC R=15)
G03 X20. Y0 I-2.5 J0
G03 X20. Y0 I-20. J0         (ARC R=20 = PAREDE)

; PASSE DE ACABAMENTO LATERAL
G41 D01
G03 X20. Y0 I-20. J0 F150.   (ACABAMENTO PAREDE)
G40

; === PASSE 2 (Z=-6MM) ===
G00 X0 Y0
G01 Z-6. F80.
G03 X5. Y0 I2.5 J0 F200.
G03 X5. Y0 I-5. J0
G03 X10. Y0 I-2.5 J0
G03 X10. Y0 I-10. J0
G03 X15. Y0 I-2.5 J0
G03 X15. Y0 I-15. J0
G03 X20. Y0 I-2.5 J0
G03 X20. Y0 I-20. J0
G41 D01
G03 X20. Y0 I-20. J0 F150.
G40

; === PASSE 3 — ACABAMENTO (Z=-8MM) ===
G00 X0 Y0
G01 Z-8. F60.
G03 X5. Y0 I2.5 J0 F180.
G03 X5. Y0 I-5. J0
G03 X10. Y0 I-2.5 J0
G03 X10. Y0 I-10. J0
G03 X15. Y0 I-2.5 J0
G03 X15. Y0 I-15. J0
G03 X20. Y0 I-2.5 J0
G03 X20. Y0 I-20. J0
G41 D01
G03 X20. Y0 I-20. J0 F120.
G40

G00 Z50.
M09
G91 G28 Z0
M05
M30''',
    linhasExplicadas: [
      LinhaExplicada('O0003 (BOLSAO CIRCULAR O40MM)', isComentario: true),
      LinhaExplicada('G00 X0 Y0', explicacao: 'Centro do bolsão — posição de início'),
      LinhaExplicada('G01 Z-3. F80.', explicacao: 'Mergulha 3mm no centro — 1º passe'),
      LinhaExplicada('G03 X5. Y0 I2.5 J0 F200.', explicacao: 'Arco espiral iniciando raio 2.5mm'),
      LinhaExplicada('G03 X5. Y0 I-5. J0', explicacao: 'Círculo completo raio 5mm'),
      LinhaExplicada('G03 X20. Y0 I-20. J0', explicacao: 'Círculo completo raio 20mm = parede do bolsão'),
      LinhaExplicada('G41 D01', explicacao: 'Ativa compensação para passe de acabamento'),
      LinhaExplicada('G03 X20. Y0 I-20. J0 F150.', explicacao: 'Acabamento da parede lateral'),
      LinhaExplicada('G40', explicacao: 'Cancela compensação de raio'),
      LinhaExplicada('M30', explicacao: 'Fim do programa'),
    ]),

  ProgramaCNC(
    titulo: 'Furação em Padrão de Grade (4×3)',
    subtitulo: 'Ciclo fixo G81 com subprograma para 12 furos',
    nivel: 'Básico',
    descricao: 'Furação de 12 furos Ø8mm em padrão de grade 4 colunas × 3 linhas, espaçamento 20×25mm. Usa subprograma para código limpo.',
    cor: Color(0xFF534AB7), icone: Icons.grid_on_rounded,
    ferramentas: ['T01 — Broca de centrar Ø4mm', 'T02 — Broca helicoidal HSS Ø8mm'],
    setup: [
      'Zero-peça G54: canto inferior esquerdo, Z=0 no topo',
      'Primeiro furo: X10, Y10mm',
      'Espaçamento: 20mm em X, 25mm em Y',
      'Profundidade de furo: 20mm (passante em peça de 15mm)',
    ],
    tags: ['furação', 'grade', 'subprograma', 'G81', 'padrão', 'básico'],
    dicas: [
      'Sempre usar broca de centrar antes da broca helicoidal para garantir precisão de posição',
      'G99 (retorno ao plano R) é mais rápido que G98 entre furos próximos',
      'Verificar centralização da peça na morsa antes de iniciar',
      'Conferir posição do primeiro furo manualmente antes de rodar o programa completo',
    ],
    codigo: '''O0004 (FURACAO GRADE 4X3 — 12 FUROS)
;
; GRADE: 4 COLUNAS X 3 LINHAS
; ESPAC: 20MM EM X, 25MM EM Y
; INICIO: X10, Y10
;
G21 G40 G49 G80
G91 G28 Z0
G90

; === T01: BROCA DE CENTRAR O4MM ===
T01 M06
G43 H01 Z100.
G54
S2000 M03
M08

G99 G82 X10. Y10. Z-3. R2. P300 F80.
X30. X50. X70.         (LINHA 1)
Y35.                   (MOVE PARA LINHA 2)
X50. X30. X10.         (LINHA 2 — SENTIDO OPOSTO)
Y60.                   (MOVE PARA LINHA 3)
X30. X50. X70.         (LINHA 3)
G80
G00 Z50.
M09

; === T02: BROCA O8MM ===
T02 M06
G43 H02 Z100.
G54
S600 M03
M08

; CHAMA SUBPROGRAMA PARA CADA LINHA
G99 G83 R2. Z-22. Q6. F80.
X10. Y10.              (FURO 1,1)
X30. Y10.              (FURO 2,1)
X50. Y10.              (FURO 3,1)
X70. Y10.              (FURO 4,1)
X10. Y35.              (FURO 1,2)
X30. Y35.
X50. Y35.
X70. Y35.
X10. Y60.              (FURO 1,3)
X30. Y60.
X50. Y60.
X70. Y60.              (FURO 4,3)
G80

G00 Z50.
M09
G91 G28 Z0
G91 G28 X0 Y0
M05
M30''',
    linhasExplicadas: [
      LinhaExplicada('O0004 (FURACAO GRADE 4X3)', isComentario: true),
      LinhaExplicada('T01 M06', explicacao: 'Broca de centrar — precisão de posição'),
      LinhaExplicada('G99 G82 X10. Y10. Z-3. R2. P300 F80.', explicacao: 'Ciclo G82: centrar com pausa 0.3s no fundo'),
      LinhaExplicada('X30. X50. X70.', explicacao: 'Repete ciclo nos X seguintes — linha 1'),
      LinhaExplicada('Y35.', explicacao: 'Move para linha 2 (Y=35mm)'),
      LinhaExplicada('G80', explicacao: 'Cancela ciclo fixo'),
      LinhaExplicada('T02 M06', explicacao: 'Troca para broca Ø8mm'),
      LinhaExplicada('G99 G83 R2. Z-22. Q6. F80.', explicacao: 'G83: furação profunda, passo Q=6mm'),
      LinhaExplicada('X10. Y10.', explicacao: '1º furo: coluna 1, linha 1'),
      LinhaExplicada('X70. Y60.', explicacao: 'Último furo: coluna 4, linha 3'),
      LinhaExplicada('G80', explicacao: 'Cancela ciclo de furação'),
      LinhaExplicada('M30', explicacao: 'Fim do programa'),
    ]),
];

// ─────────────────────────────────────────
// DADOS — TORNEAMENTO
// ─────────────────────────────────────────
const _programasTorneamento = [

  ProgramaCNC(
    titulo: 'Eixo Escalonado com Chanfros',
    subtitulo: 'Torno CNC Fanuc — G71 desbaste + G70 acabamento',
    nivel: 'Intermediário',
    descricao: 'Torneamento de eixo escalonado Ø40/Ø25/Ø20mm com chanfros 2×45°. Usa ciclo G71 de desbaste automático e G70 para acabamento.',
    cor: Color(0xFF185FA5), icone: Icons.timeline_rounded,
    ferramentas: [
      'T0101 — Pastilha CNMG 80° para desbaste externo (R=0.8mm)',
      'T0202 — Pastilha DCMT 55° para acabamento externo (R=0.4mm)',
      'T0303 — Ferramenta de sangrar 3mm largura',
    ],
    setup: [
      'Zero-peça: topo direito da peça (Z=0), eixo do spindle (X=0)',
      'Matéria-prima: barra Ø45mm × 90mm de aço 1045',
      'Fixação: mandril de 3 garras, saliente 70mm',
      'Sobremetal G71: 0.4mm radial (U=0.4) e 0.1mm axial (W=0.1)',
    ],
    tags: ['torneamento', 'eixo', 'G71', 'G70', 'desbaste', 'acabamento', 'fanuc'],
    dicas: [
      'G71 executa o desbaste automaticamente — não precisa programar cada passe',
      'Sempre programar G70 após G71 para o passe de acabamento com outra pastilha',
      'Chanfros: G01 X[maior] Z[menor] com valor calculado para 45° = ap = lado do chanfro',
      'Verificar batimento axial com relógio antes de iniciar — máx. 0.05mm',
    ],
    codigo: '''O0010 (EIXO ESCALONADO O40/O25/O20MM)
;
; DIAMETROS: O40 (L=20) / O25 (L=30) / O20 (L=30)
; CHANFROS: 2X45 EM TODAS AS TRANSICOES
; ZERO: TOPO DIREITO, EIXO DO SPINDLE
;
G21 G40 G49
G28 U0 W0          (RETORNO AO ZERO TORNO)
G50 S3000           (LIMITE MAX RPM)

; === T01: DESBASTE EXTERNO ===
T0101
G96 S200 M03       (Vc=200 M/MIN CONSTANTE)
G95                (AVANCO EM MM/ROT)
M08

; --- CICLO G71 DESBASTE ---
G00 X46. Z2.       (POSICAO DE INICIO)
G71 U1.5 R0.5      (AP=1.5MM, RECUO=0.5MM)
G71 P10 Q20 U0.4 W0.1 F0.25   (SOBREMETAL ACABAMENTO)

; --- PERFIL (BLOCOS N10 A N20) ---
N10 G00 X16.       (DIAMETRO MINIMO -2MM)
G01 Z0 F0.15       (ENCOSTA NO TOPO)
G01 X20. Z-2.      (CHANFRO 2X45 ENTRADA)
G01 Z-30.          (O20 POR 30MM)
G01 X23.           (TRANSICAO)
G01 X25. Z-31.     (CHANFRO 1X45)
G01 Z-61.          (O25 POR 30MM)
G01 X38.           (TRANSICAO)
G01 X40. Z-62.     (CHANFRO 1X45)
N20 G01 Z-82.      (O40 POR 20MM)

G00 X100. Z50.     (SAI DA PECA)
M09

; === T02: ACABAMENTO EXTERNO ===
T0202
G96 S280 M03
G95
M08

G00 X46. Z2.
G70 P10 Q20        (ACABAMENTO SEGUINDO PERFIL G71)

G00 X100. Z50.
M09

; === T03: SANGRAR / CORTAR ===
T0303
G97 S400 M03       (RPM FIXO PARA SANGRAR)
G95
M08

G00 X42. Z-83.     (POSICIONA PARA CORTAR)
G01 X-1. F0.05     (CORTA PECA — DEVAGAR!)

G00 X100.
M09

G28 U0 W0
M05
M30''',
    linhasExplicadas: [
      LinhaExplicada('O0010 (EIXO ESCALONADO)', isComentario: true),
      LinhaExplicada('G50 S3000', explicacao: 'Limita RPM máximo a 3000'),
      LinhaExplicada('G96 S200 M03', explicacao: 'Velocidade de corte constante 200 m/min'),
      LinhaExplicada('G95', explicacao: 'Avanço em mm/rotação — padrão torneamento'),
      LinhaExplicada('G00 X46. Z2.', explicacao: 'Posição de início do ciclo G71'),
      LinhaExplicada('G71 U1.5 R0.5', explicacao: 'G71: profundidade 1.5mm, recuo 0.5mm'),
      LinhaExplicada('G71 P10 Q20 U0.4 W0.1 F0.25', explicacao: 'Define perfil P10→Q20, sobremetal 0.4mm radial'),
      LinhaExplicada('N10 G00 X16.', explicacao: 'Início do perfil — menor diâmetro'),
      LinhaExplicada('G01 X20. Z-2.', explicacao: 'Chanfro 2×45°: avança 2mm em X e Z'),
      LinhaExplicada('G01 Z-30.', explicacao: 'Torna diâmetro 20mm por 30mm'),
      LinhaExplicada('N20 G01 Z-82.', explicacao: 'Fim do perfil — diâmetro 40mm'),
      LinhaExplicada('G70 P10 Q20', explicacao: 'G70: acabamento seguindo mesmo perfil com T02'),
      LinhaExplicada('G01 X-1. F0.05', explicacao: 'Corte lento para separar peça — F muito baixo'),
      LinhaExplicada('M30', explicacao: 'Fim do programa'),
    ]),

  ProgramaCNC(
    titulo: 'Rosca Externa M20×2.5',
    subtitulo: 'Ciclo de rosqueamento G92 no torno CNC',
    nivel: 'Intermediário',
    descricao: 'Usinagem de rosca externa M20×2.5mm com múltiplos passes de desbaste e acabamento. Programa seguro com passes progressivos.',
    cor: Color(0xFF993C1D), icone: Icons.settings_rounded,
    ferramentas: [
      'T0101 — Pastilha CNMG para desbaste de rosca',
      'T0404 — Pastilha de rosca métrica 60° passo 2.5mm',
    ],
    setup: [
      'Peça já torneada em Ø20mm com tolerância h6',
      'Zero: topo direito da peça, Z=0',
      'Comprimento da rosca: 40mm',
      'Altura do filete M20×2.5 = 1.534mm (total = 3.067mm de profundidade)',
    ],
    tags: ['rosca', 'M20', 'G92', 'torneamento', 'filete', 'torno'],
    dicas: [
      'G92 é o ciclo de rosca do torno Fanuc — cada bloco é um passe',
      'Profundidade total da rosca M20×2.5 = 1.534mm (radial) = Ø16.933mm final',
      'Passes progressivos: mais profundo no início, mais raso no final',
      'NUNCA parar o spindle durante o rosqueamento — pode desfasar a rosca',
    ],
    codigo: '''O0011 (ROSCA EXTERNA M20X2.5MM)
;
; METODO: G92 — CICLO DE ROSCA FANUC
; PASSO: 2.5MM
; PROFUNDIDADE TOTAL: 1.534MM (RADIAL)
; DIAMETRO FINAL: O16.933MM
;
G21 G40
G28 U0 W0

T0404              (PASTILHA DE ROSCA 60°)
G97 S400 M03       (RPM FIXO — NUNCA G96 EM ROSCA!)
G95
M08

G00 X22. Z5.       (POSICAO DE INICIO — FORA DA PECA)

; === PASSES DE ROSQUEAMENTO G92 ===
; SINTAXE: G92 X[diam] Z[comprimento] F[passo]
; F=PASSO DA ROSCA (2.5MM)

G92 X19.4 Z-42. F2.5    (PASSE 1 — 0.3MM PROFUND.)
G92 X18.9 Z-42. F2.5    (PASSE 2 — 0.25MM)
G92 X18.5 Z-42. F2.5    (PASSE 3 — 0.2MM)
G92 X18.2 Z-42. F2.5    (PASSE 4 — 0.15MM)
G92 X18.0 Z-42. F2.5    (PASSE 5 — 0.1MM)
G92 X17.8 Z-42. F2.5    (PASSE 6 — 0.1MM)
G92 X17.6 Z-42. F2.5    (PASSE 7 — 0.1MM)
G92 X17.4 Z-42. F2.5    (PASSE 8 — 0.1MM)
G92 X17.2 Z-42. F2.5    (PASSE 9 — 0.1MM)
G92 X17.0 Z-42. F2.5    (PASSE 10 — 0.1MM)
G92 X16.93 Z-42. F2.5   (PASSE 11 — ACABAMENTO)
G92 X16.93 Z-42. F2.5   (PASSE 12 — LIMPEZA)

; === VERIFICACAO: PASS COM CALIBRADOR ===
; USAR CALIBRADOR DE ROSCA GO/NOGO M20
; OU PORCA M20 PARA VERIFICAR

G00 X100. Z50.
M09
G28 U0 W0
M05
M30''',
    linhasExplicadas: [
      LinhaExplicada('O0011 (ROSCA M20X2.5MM)', isComentario: true),
      LinhaExplicada('G97 S400 M03', explicacao: 'RPM FIXO obrigatório em rosca — nunca G96!'),
      LinhaExplicada('G00 X22. Z5.', explicacao: 'Posição de entrada: fora da peça em X e Z'),
      LinhaExplicada('G92 X19.4 Z-42. F2.5', explicacao: 'Ciclo G92: 1º passe, F=passo da rosca'),
      LinhaExplicada('G92 X18.9 Z-42. F2.5', explicacao: '2º passe — 0.25mm mais profundo'),
      LinhaExplicada('G92 X16.93 Z-42. F2.5', explicacao: 'Último passe — diâmetro final da rosca'),
      LinhaExplicada('G92 X16.93 Z-42. F2.5', explicacao: 'Passe de limpeza no mesmo diâmetro'),
      LinhaExplicada('M30', explicacao: 'Fim — verificar com calibrador antes de liberar'),
    ]),
];

// ─────────────────────────────────────────
// DADOS — ESPECIAIS
// ─────────────────────────────────────────
const _programasEspeciais = [

  ProgramaCNC(
    titulo: 'Subprograma — Furos em Círculo',
    subtitulo: 'M98/M99 com macro para padrão circular',
    nivel: 'Avançado',
    descricao: 'Furação de 8 furos igualmente espaçados em círculo de Ø80mm usando subprograma M98. Padrão usado em flanges e tampas.',
    cor: Color(0xFF534AB7), icone: Icons.rotate_right_rounded,
    ferramentas: ['T01 — Broca de centrar Ø3mm', 'T02 — Broca Ø8mm metal duro'],
    setup: [
      'Zero-peça G54: centro do círculo de furos, Z=0 no topo',
      'Raio do círculo: 40mm (Ø80mm PCD)',
      'Número de furos: 8 (a cada 45°)',
      'Profundidade: 15mm passante em peça de 12mm',
    ],
    tags: ['subprograma', 'M98', 'círculo', 'flange', 'avançado', 'macro'],
    dicas: [
      'Este programa usa cálculo trigonométrico para posicionar os furos — pode ser convertido para macro #',
      'Para mudar o número de furos: calcular novamente os ângulos e coordenadas XY',
      'Usando macro paramétrica (G65) é possível passar o raio e número de furos como parâmetro',
      'Verificar primeiro furo antes de autorizar os demais',
    ],
    codigo: '''O0020 (FUROS EM CIRCULO — 8 FUROS O80 PCD)
;
; 8 FUROS ESPACO 45 GRAUS
; RAIO = 40MM
; CALCULO: X=R*COS(A), Y=R*SIN(A)
;
G21 G40 G49 G80
G91 G28 Z0
G90

; === T01: BROCA DE CENTRAR ===
T01 M06
G43 H01 Z100.
G54
S2500 M03
M08

G99 G82 R2. Z-3. P300 F80.

; 8 POSICOES (0, 45, 90, 135, 180, 225, 270, 315 GRAUS)
X40.  Y0.      (0 GRAUS)
X28.3 Y28.3    (45 GRAUS)
X0.   Y40.     (90 GRAUS)
X-28.3 Y28.3   (135 GRAUS)
X-40. Y0.      (180 GRAUS)
X-28.3 Y-28.3  (225 GRAUS)
X0.   Y-40.    (270 GRAUS)
X28.3 Y-28.3   (315 GRAUS)

G80
G00 Z50.
M09

; === T02: BROCA O8MM ===
T02 M06
G43 H02 Z100.
G54
S1200 M03
M08

G99 G83 R2. Z-17. Q5. F60.

X40.  Y0.
X28.3 Y28.3
X0.   Y40.
X-28.3 Y28.3
X-40. Y0.
X-28.3 Y-28.3
X0.   Y-40.
X28.3 Y-28.3

G80
G00 Z50.
M09
G91 G28 Z0
G91 G28 X0 Y0
M05
M30

; === FORMULA PARA CALCULAR POSICOES ===
; N FUROS EM CIRCULO RAIO R:
; ANGULO = 360 / N
; Xn = R * COS(n * ANGULO)
; Yn = R * SIN(n * ANGULO)''',
    linhasExplicadas: [
      LinhaExplicada('O0020 (FUROS EM CIRCULO)', isComentario: true),
      LinhaExplicada('G99 G82 R2. Z-3. P300 F80.', explicacao: 'G82: centrar com pausa — precisão de posição'),
      LinhaExplicada('X40.  Y0.', explicacao: '0°: X=40*cos(0)=40, Y=40*sin(0)=0'),
      LinhaExplicada('X28.3 Y28.3', explicacao: '45°: X=40*cos(45)=28.3, Y=40*sin(45)=28.3'),
      LinhaExplicada('X0.   Y40.', explicacao: '90°: X=0, Y=40'),
      LinhaExplicada('X-40. Y0.', explicacao: '180°: X=-40, Y=0'),
      LinhaExplicada('G99 G83 R2. Z-17. Q5. F60.', explicacao: 'G83: furação profunda passo 5mm'),
      LinhaExplicada('M30', explicacao: 'Fim — conferir todos os 8 furos'),
    ]),

  ProgramaCNC(
    titulo: 'Macro Paramétrica — Família de Peças',
    subtitulo: 'G65 com variáveis #1-#26 (Fanuc Custom Macro)',
    nivel: 'Avançado',
    descricao: 'Programa principal chama macro para usinar furos em grade. Os parâmetros (número de furos, espaçamento) são passados como variáveis — um programa para toda uma família.',
    cor: Color(0xFF2E7D32), icone: Icons.functions_rounded,
    ferramentas: ['T01 — Broca adequada ao diâmetro programado'],
    setup: [
      'Zero-peça G54: canto inferior esquerdo, Z=0 no topo',
      'A=#1: espaçamento em X (mm)',
      'B=#2: espaçamento em Y (mm)',
      'C=#3: número de colunas',
      'I=#4: número de linhas',
      'D=#7: profundidade de furação',
    ],
    tags: ['macro', 'G65', 'paramétrico', 'família', 'variável', 'avançado'],
    dicas: [
      'Macros Fanuc usam variáveis #1 a #33 como argumentos passados por G65',
      'Com este programa, você pode furar grades de qualquer tamanho sem reprogramar',
      'A variável #4999 é o número de repetições atual — útil para debug',
      'IF [condição] GOTO N[bloco] permite lógica dentro do programa CNC',
    ],
    codigo: '''O0030 (PROGRAMA PRINCIPAL — CHAMA MACRO)
;
; PARAMETROS PASSADOS PARA MACRO O9001:
;   A=#1 = ESPAC. X (EX: A20.)
;   B=#2 = ESPAC. Y (EX: B25.)
;   C=#3 = N. COLUNAS (EX: C4.)
;   I=#4 = N. LINHAS  (EX: I3.)
;   D=#7 = PROFUNDIDADE (EX: D15.)
;
G21 G40 G49 G80
G91 G28 Z0
G90
T01 M06
G43 H01 Z100.
G54
S800 M03
M08

; CHAMA MACRO COM PARAMETROS:
; GRADE 4X3, ESPAC 20X25, PROF 15MM
G65 P9001 A20. B25. C4. I3. D15.

G00 Z50.
M09
G91 G28 Z0
M05
M30

; ====================================
; SUBPROGRAMA MACRO O9001
; FURACAO EM GRADE PARAMETRICA
; ====================================
O9001
;
; #1=ESPAC.X  #2=ESPAC.Y
; #3=N.COLUN  #4=N.LINHAS  #7=PROF
;
#10 = 0.           (CONTADOR COLUNA)
#11 = 0.           (CONTADOR LINHA)
#12 = 10.          (X INICIAL)
#13 = 10.          (Y INICIAL)

WHILE [#11 LT #4] DO1    (LOOP LINHAS)
  #10 = 0.
  #20 = #12              (X ATUAL)
  #21 = #13 + #11 * #2   (Y ATUAL)

  WHILE [#10 LT #3] DO2  (LOOP COLUNAS)
    #20 = #12 + #10 * #1  (CALCULA X)
    G99 G83 X#20 Y#21 Z-[#7+2.] R2. Q6. F80.
    #10 = #10 + 1.
  END2

  #11 = #11 + 1.
END1

G80                (CANCELA CICLO)
M99                (RETORNA AO PROGRAMA PRINCIPAL)''',
    linhasExplicadas: [
      LinhaExplicada('O0030 (PROGRAMA PRINCIPAL)', isComentario: true),
      LinhaExplicada('G65 P9001 A20. B25. C4. I3. D15.', explicacao: 'Chama macro O9001 com parâmetros'),
      LinhaExplicada('; ====== MACRO O9001 ======', isComentario: true),
      LinhaExplicada('#10 = 0.', explicacao: 'Inicializa contador de colunas'),
      LinhaExplicada('#11 = 0.', explicacao: 'Inicializa contador de linhas'),
      LinhaExplicada('WHILE [#11 LT #4] DO1', explicacao: 'Loop: enquanto linha < número de linhas'),
      LinhaExplicada('#20 = #12 + #10 * #1', explicacao: 'Calcula X atual: X_inicial + coluna × espaç.X'),
      LinhaExplicada('G99 G83 X#20 Y#21 Z-[#7+2.] R2. Q6. F80.', explicacao: 'Fura na posição calculada pelas variáveis'),
      LinhaExplicada('#10 = #10 + 1.', explicacao: 'Incrementa contador de coluna'),
      LinhaExplicada('END2', explicacao: 'Fim do loop de colunas'),
      LinhaExplicada('END1', explicacao: 'Fim do loop de linhas'),
      LinhaExplicada('M99', explicacao: 'Retorna ao programa principal O0030'),
    ]),
];

// ─── PROGRAMAS EXTRAS — Fresamento ───────────────────────────
const _programasFresamentoExtras = [

  ProgramaCNC(
    titulo: 'Bolsão Retangular (Pocket Retangular)',
    subtitulo: 'G12.1 Fresamento helicoidal de bolsão — Fanuc',
    nivel: 'Intermediário',
    tags: ['bolsão', 'pocket', 'helicoidal', 'fresamento', 'Fanuc', 'carbide'],
    descricao: 'Fresamento de bolsão retangular 60×40mm com entrada helicoidal. Evita mergulho direto, ideal para metal duro sem cobertura central.',
    cor: Color(0xFF0F6E56), icone: Icons.crop_portrait_rounded,
    ferramentas: ['T01 — Fresa de topo Ø12mm 4F carbide', 'Comprimento de corte ≥ 20mm'],
    setup: [
      'G54 — zero na face superior, canto inferior esquerdo do bolsão',
      'Tool Length H01 medida e inserida no controle',
      'Clampeamento firme — força radial elevada',
    ],
    dicas: [
      'Entrada helicoidal: ângulo de rampa 3–5° evita sobrecarga axial da fresa',
      'Engajamento máximo 50% do diâmetro (ae ≤ 6mm para Ø12) no desbaste',
      'Deixar 0.2–0.3mm na parede e fundo para passe de acabamento com alta velocidade',
      'Usar arco de saída nos cantos — evita marca de parada da ferramenta',
    ],
    codigo: '''O0050 (BOLSÃO RETANGULAR 60x40mm)
%
G90 G17 G21
G28 G91 Z0.
G90

T01 M06
G00 G90 G54 X0. Y0.
G43 H01 Z50. M03 S3000
M08

(*** PASSE DE DESBASTE ***)
G00 X30. Y20.          (CENTRO DO BOLSÃO)
Z5.
G01 Z-4. F100.         (ENTRA VERTICAL - DESBASTE)

(ESPIRAL DO CENTRO PARA FORA)
G41 D01
G01 X18. Y8. F250.
X-18.
Y-8.
X18.
Y8.
G40

(PASSE LATERAL - PAREDES)
G41 D01
G01 X27. Y17. F200.
X-27.
Y-17.
X27.
Y17.
G40

(*** PASSE DE ACABAMENTO ***)
G01 Z-5. F80.
G41 D01
G01 X30. Y20. F180.
X-30.
Y-20.
X30.
Y20.
G40

G00 Z50.
M09
G28 G91 Z0.
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('T01 M06', explicacao: 'Chama fresa de topo Ø12mm, troca automática'),
      LinhaExplicada('G43 H01 Z50. M03 S3000', explicacao: 'Compensa comprimento H01, liga spindle 3000 RPM'),
      LinhaExplicada('G00 X30. Y20.', explicacao: 'Posiciona sobre o centro do bolsão (60/2 = 30, 40/2 = 20)'),
      LinhaExplicada('G01 Z-4. F100.', explicacao: 'Mergulha axialmente para desbaste a 4mm de profundidade'),
      LinhaExplicada('G41 D01', explicacao: 'Ativa compensação de raio à esquerda — D01 = raio da fresa'),
      LinhaExplicada('G40', explicacao: 'Cancela compensação de raio — sempre antes de G28 ou troca'),
      LinhaExplicada('G01 Z-5. F80.', explicacao: 'Desce para cota final de acabamento'),
    ]),

  ProgramaCNC(
    titulo: 'Fresamento de Ranhura (Slot)',
    subtitulo: 'Ranhura passante com dois passes — Fanuc',
    nivel: 'Básico',
    tags: ['ranhura', 'slot', 'fresamento', 'dois passes', 'Fanuc', 'básico'],
    descricao: 'Ranhura 10mm de largura × 50mm comprimento × 8mm profundidade. Dois passes: desbaste (fresa Ø8) e acabamento (fresa Ø10).',
    cor: Color(0xFF185FA5), icone: Icons.horizontal_rule_rounded,
    ferramentas: ['T01 — Fresa de topo Ø8mm 4F (desbaste)', 'T02 — Fresa de topo Ø10mm 4F (acabamento)'],
    setup: [
      'G54 — zero no centro da ranhura, face superior da peça',
      'Verificar DRO antes de iniciar — conferir simetria',
    ],
    dicas: [
      'Fresa de desbaste menor que a ranhura (Ø8 para ranhura Ø10) evita carga de flanco total',
      'Profundidade por passe ≤ 1× diâmetro da fresa no desbaste de ranhura',
      'Acabamento com Ø igual à ranhura: uma passagem centralizada garante largura final',
      'Sopro de ar ou refrigeração obrigatório — cavaco fica preso na ranhura facilmente',
    ],
    codigo: '''O0060 (RANHURA 10x50x8mm)
%
G90 G17 G21
G28 G91 Z0.
G90

(*** DESBASTE — T01 Ø8mm ***)
T01 M06
G00 G90 G54 X-25. Y0.
G43 H01 Z50. M03 S4000
M08

Z5.
G01 Z-4. F100.     (1º PASSE: -4mm)
G01 X25. F300.
G00 Z5.

G01 Z-8. F80.      (2º PASSE: -8mm)
G01 X-25. F280.
G00 Z50.

(*** ACABAMENTO — T02 Ø10mm ***)
T02 M06
G00 G90 G54 X-25. Y0.
G43 H02 Z50. M03 S3500

Z2.
G41 D02            (COMP. RAIO - PAREDE ESQUERDA)
G01 Z-8. F80.
G01 X25. F200.
G40 G00 Z50.

G00 X25. Y0.
G42 D02            (COMP. RAIO - PAREDE DIREITA)
G01 Z-8. F80.
G01 X-25. F200.
G40

G00 Z50.
M09
G28 G91 Z0.
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G01 Z-4. F100.', explicacao: 'Primeiro passe de desbaste: metade da profundidade total'),
      LinhaExplicada('G01 Z-8. F80.', explicacao: 'Segundo passe: profundidade total — feed mais lento'),
      LinhaExplicada('G41 D02', explicacao: 'Compensa raio à esquerda — usina parede esquerda da ranhura'),
      LinhaExplicada('G42 D02', explicacao: 'Compensa raio à direita — usina parede direita em sentido contrário'),
      LinhaExplicada('G40 G00 Z50.', explicacao: 'Cancela compensação e sobe — nunca cancele G41/G42 em movimento linear de corte'),
    ]),

  ProgramaCNC(
    titulo: 'Ciclo de Furação e Escareamento',
    subtitulo: 'G81 + G82 + G84 — série de furos M6',
    nivel: 'Intermediário',
    tags: ['G81', 'G82', 'G84', 'furação', 'escareamento', 'rosqueamento', 'M6', 'Fanuc'],
    descricao: 'Produz 6 furos M6×1.0: pré-furo Ø5mm (G81), escareamento 90° (G82 com pausa) e rosqueamento rígido (G84). Padrão industrial completo.',
    cor: Color(0xFF534AB7), icone: Icons.radio_button_unchecked_rounded,
    ferramentas: ['T01 — Broca de centrar Ø4mm', 'T02 — Broca Ø5mm HSS-Co', 'T03 — Escareador 90° Ø12mm', 'T04 — Macho M6×1.0 rígido'],
    setup: [
      'G54 X=0 Y=0 no canto inferior esquerdo da peça',
      'Confirmar comprimento de todos os 4 ferramentas antes de iniciar',
      'Usar parafuso de fixação — furação gera vibração',
    ],
    dicas: [
      'Confirmar F=S×passo no G84: 600rpm × 1.0mm = F600. Erro aqui quebra o macho!',
      'Use G99 (retorno ao plano R) para furos em série — mais rápido que G98',
      'Sempre G28 Z antes de M06 — G80 não substitui o recuo de segurança',
      'Escareador 90° com pausa (P300 no G82) melhora acabamento do chanfro',
    ],
    codigo: '''O0070 (6x FURO M6 COMPLETO)
%
G90 G17 G21
G28 G91 Z0.
G90

(POSIÇÕES DOS 6 FUROS)
(Furo 1:X15Y15 2:X45Y15 3:X75Y15)
(Furo 4:X15Y45 5:X45Y45 6:X75Y45)

(*** T01 — CENTRAR ***)
T01 M06
G00 G90 G54 X15. Y15.
G43 H01 Z50. M03 S2000
M08

G99 G81 X15. Y15. Z-2. R2. F120.
X45.
X75.
Y45.
X45.
X15.
G80

G00 Z50.

(*** T02 — BROCAÇÃO Ø5mm ***)
T02 M06
G00 G90 G54 X15. Y15.
G43 H02 Z50. M03 S2200

G99 G83 X15. Y15. Z-18. R2. Q4. F120.
X45.
X75.
Y45.
X45.
X15.
G80

G00 Z50.

(*** T03 — ESCAREAMENTO ***)
T03 M06
G00 G90 G54 X15. Y15.
G43 H03 Z50. M03 S800

G99 G82 X15. Y15. Z-2.5 R2. P300 F80.
X45.
X75.
Y45.
X45.
X15.
G80

G00 Z50.

(*** T04 — ROSQUEAMENTO M6x1.0 ***)
T04 M06
G00 G90 G54 X15. Y15.
G43 H04 Z50. M03 S600

G99 G84 X15. Y15. Z-14. R2. F600.
X45.
X75.
Y45.
X45.
X15.
G80

G00 Z50.
M09
G28 G91 Z0.
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G99 G81 X15. Y15. Z-2. R2. F120.', explicacao: 'G81=furação simples; Z-2=profundidade; R2=plano de retorno; G99=retorna ao plano R'),
      LinhaExplicada('G99 G83 X15. Y15. Z-18. R2. Q4. F120.', explicacao: 'G83=furação profunda com pecking; Q4=incremento de peck 4mm'),
      LinhaExplicada('G99 G82 Z-2.5 R2. P300 F80.', explicacao: 'G82=fura com pausa; P300=pausa 300ms no fundo — melhora o escareamento'),
      LinhaExplicada('G99 G84 Z-14. R2. F600.', explicacao: 'G84=rosqueamento rígido; F=N×passo (600rpm × 1.0mm = F600)'),
      LinhaExplicada('G80', explicacao: 'OBRIGATÓRIO — cancela o ciclo fixo ativo. Esquecer G80 causa crash!'),
    ]),

  ProgramaCNC(
    titulo: 'Chanframento de Perfil Externo',
    subtitulo: 'Chanfro 45° × 2mm com fresa de chanfrar — Fanuc',
    nivel: 'Básico',
    tags: ['chanfro', 'chanfrar', 'G41', 'perfil externo', 'fresamento', 'Fanuc'],
    descricao: 'Chanframento do perímetro de uma peça retangular 100×60mm usando fresa de chanfrar 90°. Usa G41 para garantir simetria do chanfro.',
    cor: Color(0xFF0F6E56), icone: Icons.change_history_rounded,
    ferramentas: ['T01 — Fresa de chanfrar 90° Ø16mm', 'T02 — Fresa de face (para face prévia se necessário)'],
    setup: [
      'G54 no canto inferior esquerdo da face superior',
      'Z=0 na face superior da peça já acabada',
      'Ajustar D01 para afinar largura do chanfro',
    ],
    dicas: [
      'Profundidade do chanfro 45°×2mm = 2.0mm (tan 45°=1). Para 45°×1mm use Z-1.0',
      'G41 garante que ambos os lados fiquem simétricos — sem G41 o chanfro é assimétrico',
      'Sempre sair do contorno ANTES de G40 — nunca cancele compensação em canto',
      'Reducir avanço em cantos agudos (90°) para evitar vibração',
    ],
    codigo: '''O0080 (CHANFRO 45°x2mm - PEÇA 100x60mm)
%
G90 G17 G21
G28 G91 Z0.
G90

T01 M06
G00 G90 G54 X-10. Y-10.
G43 H01 Z50. M03 S2500
M08

(PROFUNDIDADE = largura do chanfro × tan(45°) = 2mm)
G00 Z5.
G01 Z-2. F100.

(PERCURSO DO PERFIL COM G41)
G41 D01
G01 X0. Y0. F350.     (APROXIMAÇÃO)
G01 X100.             (LADO INFERIOR)
G01 Y60.              (LADO DIREITO)
G01 X0.               (LADO SUPERIOR)
G01 Y0.               (LADO ESQUERDO)
G01 X-5. Y-5.         (SAÍDA)
G40

G00 Z50.
M09
G28 G91 Z0.
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G01 Z-2. F100.', explicacao: 'Profundidade do chanfro = 2mm (chanfro 45°×2mm)'),
      LinhaExplicada('G41 D01', explicacao: 'Compensação de raio à esquerda — ferramenta fica do lado externo do contorno'),
      LinhaExplicada('G01 X0. Y0. F350.', explicacao: 'Aproximação linear com G41 ativo — evite arcos na entrada com chanfradeira'),
      LinhaExplicada('G01 X-5. Y-5.', explicacao: 'Saída do contorno antes de cancelar G40 — evita marca na peça'),
      LinhaExplicada('G40', explicacao: 'Cancela compensação de raio — sempre com movimento de saída antes'),
    ]),

  ProgramaCNC(
    titulo: 'Contorno Externo com G41/G42 (Compensação de Raio)',
    subtitulo: 'Fresamento de perfil externo com CRC — Fanuc',
    nivel: 'Intermediário',
    descricao: 'Perfil externo retangular 80×50mm com compensação de raio ativa. Técnica profissional que permite ajustar medidas finais apenas mudando o valor D no offset da ferramenta.',
    cor: Color(0xFF2E7D32), icone: Icons.crop_free_rounded,
    ferramentas: ['T01 — Fresa de topo Ø10mm 4F carbide'],
    setup: [
      'G54 no canto inferior esquerdo da peça — face superior Z=0',
      'D01 = raio real da fresa (5.0mm) mais correção de medida',
      'Para ampliar peça: diminuir D; para reduzir: aumentar D',
    ],
    dicas: [
      'CRC (G41/G42): compensação de raio de corte — fundamental para precisão dimensional',
      'G41 = compensação à esquerda (sentido de avanço) → contorno externo no sentido anti-horário',
      'G42 = compensação à direita → contorno externo no sentido horário (mais comum)',
      'Sempre entrar/sair tangencialmente — nunca ativar G41/G42 no meio do contorno',
    ],
    tags: ['G41', 'G42', 'CRC', 'compensação raio', 'perfil externo', 'fresamento', 'Fanuc'],
    codigo: '''O0065 (CONTORNO EXT 80x50mm — G42)
%
G90 G17 G21
G28 G91 Z0.
G90

T01 M06
G00 G90 G54 X-15. Y-15.
G43 H01 Z50. M03 S3500
M08

G00 Z5.
G01 Z-5. F80.         (PROFUNDIDADE DE CORTE)

(ENTRADA TANGENCIAL — ATIVA G42)
G42 D01
G01 X0. Y-8. F280.    (APROXIMAÇÃO)
G01 Y0.               (CHEGOU NO CANTO)

(PERCURSO PERFIL EXTERNO 80x50mm)
G01 X80.              (LADO INFERIOR)
G01 Y50.              (LADO DIREITO)
G01 X0.               (LADO SUPERIOR)
G01 Y0.               (LADO ESQUERDO)
G01 X-5. Y-5.         (SAÍDA — antes do G40)
G40

G00 Z50.
M09
G28 G91 Z0.
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G42 D01', explicacao: 'Ativa compensação de raio à direita — valor D01 é o raio da fresa; ajustar aqui muda a cota final'),
      LinhaExplicada('G01 X0. Y-8. F280.', explicacao: 'Aproximação com G42 já ativo — movimento linear fora do perfil'),
      LinhaExplicada('G01 X80.', explicacao: 'Primeiro lado do contorno — controle compensará automaticamente o raio da fresa'),
      LinhaExplicada('G01 X-5. Y-5.', explicacao: 'Saída do contorno antes de G40 — necessário para evitar gouge na peça'),
      LinhaExplicada('G40', explicacao: 'Cancela CRC — sempre com movimento de afastamento antes'),
    ]),

  ProgramaCNC(
    titulo: 'Gravação de Texto em CNC (Macro B)',
    subtitulo: 'Letras com percurso paramétrico — Fanuc Macro B',
    nivel: 'Avançado',
    descricao: 'Gravação do texto "CNC" com fresa de gravar Ø1mm usando macros Fanuc. Demonstra uso de variáveis e saltos condicionais para sequência de letras.',
    cor: Color(0xFF880E4F), icone: Icons.text_fields_rounded,
    ferramentas: ['T01 — Fresa de gravar Ø1mm 60° carbide', 'T02 — Fresa de topo Ø6mm para desbaste'],
    setup: [
      'Peça fixada em morsa com face superior plana e nivelada',
      'Zero G54 no canto inferior esquerdo — Z=0 na superfície',
      'Profundidade de gravação: Z-0.3mm (regulável pela variável #1)',
    ],
    dicas: [
      'Profundidade de gravação: 0.2–0.5mm. Mais fundo aumenta contraste mas fragiliza fresa',
      'S10000+ recomendado para gravar — fresa de gravar exige alta rotação',
      'Avanço baixo F80–F120 para boa qualidade de letra — qualidade visual importa',
      'Usar parafina sólida como lubrificante na gravação de alumínio — excelente acabamento',
    ],
    tags: ['gravação', 'texto', 'macro', 'Fanuc', 'variável', 'fresa gravar', 'alumínio'],
    codigo: '''O0066 (GRAVAÇÃO "CNC" COM MACRO)
%
G90 G17 G21
G28 G91 Z0.
G90

(#1 = PROFUNDIDADE DE GRAVAÇÃO)
(#2 = ORIGEM X, #3 = ORIGEM Y)
#1 = -0.3
#2 = 10.0
#3 = 10.0

T01 M06
G00 G90 G54 X[#2] Y[#3]
G43 H01 Z5. M03 S10000
M08

(LETRA C)
G00 X[#2+5.] Y[#3+8.]
G01 Z[#1] F80.
G03 X[#2] Y[#3+4.] R4. F120.
G03 X[#2+5.] Y[#3] R4.
G00 Z5.

(LETRA N)
G00 X[#2+8.] Y[#3]
G01 Z[#1] F80.
G01 Y[#3+8.] F120.
G01 X[#2+13.] Y[#3]
G01 Y[#3+8.]
G00 Z5.

(LETRA C — segunda)
G00 X[#2+18.] Y[#3+8.]
G01 Z[#1] F80.
G03 X[#2+13.] Y[#3+4.] R4. F120.
G03 X[#2+18.] Y[#3] R4.
G00 Z5.

G00 Z50.
M09
G28 G91 Z0.
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('#1 = -0.3', explicacao: 'Variável Macro: profundidade de gravação. Mudar aqui afeta toda gravação'),
      LinhaExplicada('#2 = 10.0', explicacao: 'Ponto de origem X do texto — mudar aqui desloca toda a gravação horizontalmente'),
      LinhaExplicada('G01 Z[#1] F80.', explicacao: 'Desce até profundidade definida pela variável #1 com avanço baixo'),
      LinhaExplicada('G03 X[#2+5.] Y[#3+8.] R4.', explicacao: 'Arco para traçar a curva da letra C — raio 4mm define altura relativa da letra'),
    ]),

  ProgramaCNC(
    titulo: 'Ciclo de Rosca Fresada G12.1 (Thread Milling)',
    subtitulo: 'Rosca fresada M20×2.5 com fresa de rosca — Fanuc',
    nivel: 'Avançado',
    descricao: 'Thread milling M20×2.5 com fresa de rosca de perfil único. Superior ao machoamento em furos cegos grandes, materiais exóticos e quando não há macho disponível.',
    cor: Color(0xFF0F6E56), icone: Icons.cyclone_rounded,
    ferramentas: ['T01 — Fresa de rosca M20×2.5 carbide de perfil único'],
    setup: [
      'Pré-furo Ø17.5mm mínimo (raiz da rosca M20) — conferir profundidade',
      'Fresa de rosca: verificar diâmetro e passo no catálogo antes de calcular',
      'G41/G42: compensação de raio ativada para ajuste de folga/aperto da rosca',
    ],
    dicas: [
      'Hélice para rosca direita M20: interpolação G03 + Z desce 2.5mm por volta completa',
      'Vantagem do thread milling: gera rosca nos dois sentidos, sem quebra de macho',
      'Para apertar rosca: aumentar D (offset); para folgar: diminuir D — sem retrabalho',
      'Ideal para Ti, Inconel, aço endurecido onde machos quebram facilmente',
    ],
    tags: ['thread milling', 'rosca fresada', 'G12.1', 'M20', 'fresa rosca', 'Fanuc', 'avançado'],
    codigo: '''O0067 (THREAD MILLING M20x2.5)
%
G90 G17 G21
G28 G91 Z0.
G90

(ROSCA M20x2.5 — FRESA DE ROSCA)
(HÉLICE: DESCE 2.5mm A CADA VOLTA 360°)
(SENTIDO: G03 = ROSCA DIREITA)

T01 M06
G00 G90 G54 X0. Y0.
G43 H01 Z5. M03 S1800
M08

(POSICIONA NO CENTRO DO FURO)
G00 X0. Y0.
G00 Z-2.5        (COMEÇA 1 PASSO ABAIXO DO TOPO)

(ENTRADA HELICOIDAL — ATIVA G42)
G42 D01
G03 X10. Y0. Z-5.0 R5. F150.  (1/2 VOLTA ENTRANDO)

(VOLTA COMPLETA DE ROSCA — 360° = 1 PASSO)
G03 X10. Y0. Z-7.5 I-10. J0. F150.
G03 X10. Y0. Z-10.0 I-10. J0.
G03 X10. Y0. Z-12.5 I-10. J0.
G03 X10. Y0. Z-15.0 I-10. J0.
G03 X10. Y0. Z-17.5 I-10. J0.

(SAÍDA HELICOIDAL — CANCELA G42)
G03 X0. Y0. Z-20.0 R5. F150.
G40

G00 Z50.
M09
G28 G91 Z0.
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G03 X10. Y0. Z-5.0 R5.', explicacao: 'Entrada helicoidal: arco de 180° descendo 1/2 passo — posiciona fresa no perfil da rosca'),
      LinhaExplicada('G03 X10. Y0. Z-7.5 I-10. J0.', explicacao: 'Volta completa: 360° com descida de 2.5mm (1 passo M20×2.5) — I-10 = centro do arco'),
      LinhaExplicada('G42 D01', explicacao: 'Compensação de raio ativada — ajustar D01 controla folga/aperto da rosca final'),
      LinhaExplicada('G40', explicacao: 'Cancela G42 na saída helicoidal — sempre com movimento de saída'),
    ]),
];

// ─── PROGRAMAS EXTRAS — Torneamento ──────────────────────────
const _programasTorneamentoExtras = [

  ProgramaCNC(
    titulo: 'Torneamento Cônico Externo',
    subtitulo: 'Cone externo 10° — G01 interpolação linear — Fanuc',
    nivel: 'Intermediário',
    tags: ['cone', 'cônico', 'G71', 'G70', 'torno', 'Fanuc', 'interpolação linear'],
    descricao: 'Torneamento de cone externo com ângulo de 10° em relação ao eixo. Usa G01 com coordenadas X e Z simultâneas. Inclui desbaste G71 e acabamento G70.',
    cor: Color(0xFF993C1D), icone: Icons.change_history_rounded,
    ferramentas: ['T01 — Inserto DNMG 110408 (desbaste)', 'T02 — Inserto DCMT 11T3 (acabamento)'],
    setup: [
      'G54 Z=0 na face da peça após faceamento',
      'Peça Ø50mm, comprimento 80mm na placa',
      'Verificar folga do carro transversal antes do cone',
    ],
    dicas: [
      'Calcule o ângulo: α = arctan((D_maior - D_menor) / (2 × comprimento))',
      'G96 (CSS) mantém qualidade de superfície constante ao longo do cone',
      'G50 S3000 evita que RPM exploda quando X se aproxima do zero',
      'G71 + G70: desbaste e acabamento em passes separados garantem melhor Ra',
    ],
    codigo: '''O0090 (CONE EXTERNO 10° - Ø50 P/ Ø32 x 55mm)
%
G90 G18 G21
G28 G91 Z0. X0.
G90

(*** T01 DESBASTE — G71 ***)
T0101 M03 S800
G00 G90 X55. Z5.
G96 S180 M03    (CSS - VELOC. CORTE CONSTANTE 180m/min)
G50 S3000       (LIMITE MAX RPM)
M08

G71 U2.0 R0.5   (PASSE 2mm, RECUO 0.5mm)
G71 P100 Q200 U0.3 W0.1 F0.25

N100 G00 X32.   (INÍCIO PERFIL ACABAMENTO)
G01 Z0.
G01 X32. Z-2. F0.15   (CHANFRO ENTRADA)
G01 X50. Z-57.  (CONE: de X32 a X50 em 55mm — 10° aprox)
G01 Z-60.       (CILINDRO FINAL)
N200 G01 X55.   (SAÍDA DO PERFIL)

G00 X100. Z100.

(*** T02 ACABAMENTO — G70 ***)
T0202 M03
G96 S220 M03
G50 S3500

G00 X55. Z5.
G70 P100 Q200 F0.12   (ACABAMENTO NO PERFIL N100-N200)

G00 X100. Z100.
M09
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G96 S180 M03', explicacao: 'G96=velocidade de corte constante 180m/min — RPM varia com diâmetro'),
      LinhaExplicada('G50 S3000', explicacao: 'Limita RPM máximo a 3000 para segurança'),
      LinhaExplicada('G71 U2.0 R0.5', explicacao: 'Ciclo de desbaste: passe 2mm, recuo de saída 0.5mm'),
      LinhaExplicada('G71 P100 Q200 U0.3 W0.1 F0.25', explicacao: 'P/Q=blocos do perfil; U=sobremetal X; W=sobremetal Z; F=avanço'),
      LinhaExplicada('G01 X50. Z-57.', explicacao: 'O cone: X cresce de 32 a 50mm enquanto Z vai de 0 a -57mm — ângulo = arctan((50-32)/(2×57)) ≈ 9°'),
      LinhaExplicada('G70 P100 Q200 F0.12', explicacao: 'Acabamento no mesmo perfil N100-N200, feed mais fino'),
    ]),

  ProgramaCNC(
    titulo: 'Sangramento e Separação',
    subtitulo: 'G75 ciclo de ranhura radial + corte — Fanuc',
    nivel: 'Intermediário',
    tags: ['G75', 'sangramento', 'separação', 'grooving', 'parting', 'torno', 'Fanuc'],
    descricao: 'Sangramento (grooving) para criar ranhura de 3mm de largura e depois separação (parting) da peça. Usa G75 para ciclo de pecking radial.',
    cor: Color(0xFF0F6E56), icone: Icons.cut_rounded,
    ferramentas: ['T03 — Inserto de sangrar 3mm largura, MGMN300'],
    setup: [
      'Peça suportada com luneta ou contraponta para separação',
      'Velocidade baixa na separação — risco de vibração',
      'Usar parafina ou óleo de corte em aço inox',
    ],
    dicas: [
      'G75 velocidade baixa (60–80 m/min) — evita vibração e quebra de inserto',
      'Relação L/D < 3× largura do inserto para estabilidade no sangramento',
      'G96 S80 na separação final — RPM sobe com diâmetro menor, controle importante',
      'Contraponta ou luneta são obrigatórios em peças com L/D > 4:1',
    ],
    codigo: '''O0100 (SANGRAMENTO E SEPARAÇÃO)
%
G90 G18 G21
G28 G91 Z0. X0.
G90

T0303 M03 S600
G96 S120 M03    (CSS 120m/min)
G50 S2000
G00 G90 X52. Z-35.    (POSICIONA NA RANHURA)
M08

(*** RANHURA 3mm x 4mm PROF — G75 PECKING ***)
G75 R0.5        (RECUO ENTRE PECKS 0.5mm)
G75 X44. Z-35. P1500 Q0. F0.08
(X44=fundo ranhura, P1500=incremento radial 1.5mm, F=avanço)

G00 X52.        (RETIRA DA RANHURA)
Z-38.           (REPOSICIONA PARA 2ª RANHURA)
G75 R0.5
G75 X44. Z-38. P1500 Q0. F0.08

G00 X52. Z-36.  (CENTRO DE SEPARAÇÃO)

(*** SEPARAÇÃO — VELOCIDADE REDUZIDA ***)
G96 S80 M03
G01 X0.5 F0.05  (SEPARA DEVAGAR)
G00 X60.
Z200.

M09
G28 G91 Z0. X0.
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G75 R0.5', explicacao: 'Define recuo entre pecks de 0.5mm — evita quebra do inserto por cavacos'),
      LinhaExplicada('G75 X44. Z-35. P1500 Q0. F0.08', explicacao: 'X44=fundo, Z=posição axial, P=incremento radial (1.5mm), F=feed em mm/rot'),
      LinhaExplicada('G96 S80 M03', explicacao: 'Reduz velocidade de corte para 80m/min na separação — crítico para não vibrar'),
      LinhaExplicada('G01 X0.5 F0.05', explicacao: 'Separa a peça lentamente até X=0.5mm (quase centro) — deixa um pequeno pivô'),
    ]),

  ProgramaCNC(
    titulo: 'Perfilamento com G73 — Peça Pré-formada',
    subtitulo: 'Ciclo G73 para peças fundidas ou forjadas — Fanuc',
    nivel: 'Avançado',
    tags: ['G73', 'fundição', 'forjamento', 'pré-formado', 'torno', 'Fanuc', 'avançado'],
    descricao: 'Uso do ciclo G73 (traçado de perfil repetido) ideal para peças pré-formadas por fundição/forjamento onde o sobremetal já tem o formato aproximado do perfil.',
    cor: Color(0xFF4527A0), icone: Icons.polyline_rounded,
    ferramentas: ['T01 — Inserto CNMG 120408 desbaste', 'T02 — Inserto DCMT 11T3 acabamento'],
    setup: [
      'G73 é mais eficiente que G71 para peças fundidas — menos ar cortado',
      'Definir U e W conforme sobremetal real da fundição (tipicamente 3-5mm)',
    ],
    dicas: [
      'G73 é ideal quando a peça já tem perfil aproximado — reduz passes em vazio',
      'U = sobremetal radial total ÷ número de repetições (R)',
      'Sempre terminar com G70 P__ Q__ para acabamento de alta qualidade',
      'Verificar colisão de ferramenta em recessos — G73 segue o perfil exato',
    ],
    codigo: '''O0110 (CICLO G73 — PEÇA PRÉ-FORMADA)
%
G90 G18 G21
G28 G91 Z0. X0.
G90

T0101 M03
G96 S200 M03
G50 S3000
G00 X65. Z5.
M08

(G73: U=sobremetal radial total, W=sobremetal axial, R=nº passadas)
G73 U4.0 W2.0 R4   (4 passadas, sobremetal X=4mm, Z=2mm)
G73 P100 Q200 U0.4 W0.1 F0.2

(PERFIL DA PEÇA - forma côncava)
N100 G00 X20.
G01 Z0. F0.15
G01 X24. Z-2.         (CHANFRO 2×45°)
G01 Z-20.             (CILINDRO Ø24)
G02 X40. Z-28. R8.    (RAIO CÔNCAVO R8)
G01 Z-50.             (CILINDRO Ø40)
G01 X50. Z-52.        (CHANFRO SAÍDA)
N200 G01 X65.

T0202 M03
G96 S250 M03
G70 P100 Q200 F0.1    (ACABAMENTO)

G00 X100. Z100.
M09
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G73 U4.0 W2.0 R4', explicacao: 'U=sobremetal total em X (raio), W=sobremetal em Z, R=número de passadas de desbaste'),
      LinhaExplicada('G73 P100 Q200 U0.4 W0.1 F0.2', explicacao: 'Define o perfil (N100 a N200), sobremetal para acabamento e feed'),
      LinhaExplicada('G02 X40. Z-28. R8.', explicacao: 'Arco côncavo: de X24 para X40, raio 8mm, sentido horário (G02)'),
      LinhaExplicada('G70 P100 Q200 F0.1', explicacao: 'Acabamento percorre o perfil N100-N200 com feed mais suave'),
    ]),

  ProgramaCNC(
    titulo: 'Torneamento de Esfera (G02/G03)',
    subtitulo: 'Semiesfera Ø30mm com G02 e G03 — Fanuc',
    nivel: 'Avançado',
    tags: ['esfera', 'G02', 'G03', 'arco', 'torno', 'semiesfera', 'Fanuc', 'avançado'],
    descricao: 'Geração de perfil esférico completo usando arcos G02 e G03. Técnica usada em punções, pinos esféricos e produtos estéticos.',
    cor: Color(0xFF185FA5), icone: Icons.circle_outlined,
    ferramentas: ['T01 — Inserto VNMG 160408 (ângulo livre para raio)', 'T02 — Inserto DCMT acabamento'],
    setup: [
      'Z=0 no topo da semiesfera',
      'X=0 no centro de rotação',
      'Verificar que o raio do inserto (RE) é muito menor que o raio da esfera',
    ],
    dicas: [
      'RE do inserto deve ser ≤ 10% do raio da esfera para boa qualidade de superfície',
      'Usar G96 com S constante — velocidade de corte varia bastante no perfil esférico',
      'Ativar compensação de raio G42 no acabamento para precisão geométrica',
      'Reduzir avanço a 60% no topo da esfera onde a velocidade de corte tende a zero',
    ],
    codigo: '''O0120 (SEMIESFERA Ø30mm - RAIO R15)
%
G90 G18 G21
G28 G91 Z0. X0.
G90

T0101 M03
G96 S200 M03
G50 S4000
G00 X35. Z5.
M08

(DESBASTE EM PASSOS)
G00 X30. Z2.
G01 Z0. F0.2

(ARCO G02: I=0 K=raio no plano ZX)
(Origem: X30 Z0 → X0 Z-15 → semicírculo)
G02 X0. Z-15. R15. F0.15   (1/4 esfera)
G03 X30. Z-30. R15.         (1/4 esfera oposto - continuação)

G00 X40. Z5.

(ACABAMENTO)
T0202 M03
G96 S280 M03
G00 X30. Z2.
G01 Z0. F0.1
G02 X0. Z-15. R15. F0.08
G03 X30. Z-30. R15. F0.08

G00 X80. Z80.
M09
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G02 X0. Z-15. R15. F0.15', explicacao: 'Arco horário: de X30,Z0 para X0,Z-15 com raio 15 — primeiro quarto da esfera'),
      LinhaExplicada('G03 X30. Z-30. R15.', explicacao: 'Arco anti-horário: de X0,Z-15 para X30,Z-30 com raio 15 — segundo quarto'),
      LinhaExplicada('G96 S280 M03', explicacao: 'CSS 280m/min — velocidade aumenta no acabamento para melhor Ra'),
    ]),

  ProgramaCNC(
    titulo: 'Torneamento de Poligonal (Hexagonal) G12.1',
    subtitulo: 'Perfil hexagonal externo no torno com eixo C — Fanuc',
    nivel: 'Avançado',
    descricao: 'Torneamento de sextavado 24mm (chave 24) usando interpolação de eixo C + X em tornos com eixo C. Alternativa ao fresamento quando a peça já está no torno.',
    cor: Color(0xFF534AB7), icone: Icons.hexagon_outlined,
    ferramentas: ['T01 — Fresa de topo Ø10mm (ferramenta rotativa) no torno', 'T00 — Porta-fresa acionado axial'],
    setup: [
      'Torno com eixo C habilitado e freio de plato ativo',
      'G12.1 habilita interpolação polar (X = raio, C = ângulo)',
      'Para sextavado 24mm (s/f): raio programado = 24/(2×cos30°) = 13.856mm',
    ],
    dicas: [
      'G12.1 converte coordenadas cartesianas XY em polar XC — transparente ao programador',
      'G13.1 cancela interpolação polar — sempre chamar após o perfil',
      'Velocidade de corte da fresa, não do torno: calcular S para Ø10mm fresa',
      'Para precisão: medir entre faces com micrômetro de bico externo após 1ª peça',
    ],
    tags: ['hexagonal', 'sextavado', 'eixo C', 'G12.1', 'interpolação polar', 'torno', 'avançado'],
    codigo: '''O0115 (SEXTAVADO 24mm — EIXO C)
%
G90 G18 G21
G28 G91 Z0. X0.
G90

(POSICIONA NA COTA Z DO SEXTAVADO)
T01 M06
G00 X30. Z-5.
G43 H01 Z-5. M03 S2000
M08

(HABILITA INTERPOLAÇÃO POLAR)
G12.1

(PERFIL HEXAGONAL — 6 LADOS)
(Raio circunscrito = 24/(2*cos30) = 13.856mm)
G01 X13.856 Y0. F150.
G01 X6.928 Y12.0      (VÉRTICE 1→2, 60°)
G01 X-6.928 Y12.0     (VÉRTICE 2→3, 120°)
G01 X-13.856 Y0.      (VÉRTICE 3→4, 180°)
G01 X-6.928 Y-12.0    (VÉRTICE 4→5, 240°)
G01 X6.928 Y-12.0     (VÉRTICE 5→6, 300°)
G01 X13.856 Y0.       (FECHA HEXÁGONO)

(CANCELA INTERPOLAÇÃO POLAR)
G13.1

G00 X50. Z50.
M09
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G12.1', explicacao: 'Habilita interpolação polar: eixo X passa a ser raio, eixo Y passa a ser ângulo C'),
      LinhaExplicada('G01 X13.856 Y0. F150.', explicacao: 'Posiciona na face do hexágono: X=raio circunscrito 24/(2×cos30°)=13.856mm'),
      LinhaExplicada('G01 X6.928 Y12.0', explicacao: 'Primeiro lado do hexágono — vértice a 60° de distância'),
      LinhaExplicada('G13.1', explicacao: 'Cancela interpolação polar — obrigatório após o perfil, retorna ao modo cartesiano normal'),
    ]),

  ProgramaCNC(
    titulo: 'Torneamento de Roscas Especiais (Passo Variável)',
    subtitulo: 'Rosca de passo aumentando G32 paramétrico — Fanuc',
    nivel: 'Avançado',
    descricao: 'Rosca com passo variando de 1.5 a 3.0mm ao longo do comprimento — aplicação em molas e roscas de aperto progressivo usando Macro B com variável de passo.',
    cor: Color(0xFF4527A0), icone: Icons.trending_up_rounded,
    ferramentas: ['T03 — Inserto de rosca externo 60° tipo ER', 'Profundidade: calcular por tabela de rosca'],
    setup: [
      'G32 = rosca por passo fixo; Macro permite variar passo a cada volta',
      'Número de passes: mínimo 4-6 passes por tamanho de rosca',
      'Sincronização com encoder: G32 usa sinal do encoder — não mudar S durante ciclo',
    ],
    dicas: [
      'Rosca de passo variável não tem macho de verificação — usar comparador ou câmara',
      'Variável #100 = passo atual; incrementar #100 a cada volta para passo crescente',
      'G32 com F variável: cada bloco G32 pode ter F diferente = passo diferente',
      'Aplicação: parafuso de bancada (prensa), molas de compressão progressiva',
    ],
    tags: ['rosca passo variável', 'G32', 'macro', 'Fanuc', 'rosca especial', 'avançado'],
    codigo: '''O0116 (ROSCA PASSO VARIÁVEL 1.5→3.0mm)
%
G90 G18 G21
G28 G91 Z0. X0.
G90

T0303 M03 S400
G50 S800
G00 X35. Z5.
M08

(#100 = PASSO INICIAL 1.5mm)
(#101 = Z ATUAL — começa em 0)
(#102 = PROFUNDIDADE DO PASSE — ir incrementando)
#100 = 1.5
#101 = 0.
#102 = 0.3   (PRIMEIRO PASSE: 0.3mm profundidade)

WHILE [#101 GT -30.] DO1
  G00 X[30. - #102]        (PROFUNDIDADE DO PASSE)
  G32 Z-30. F[#100]        (ROSCA COM PASSO #100)
  G00 X35.
  G00 Z5.
  #100 = #100 + 0.1        (INCREMENTA PASSO 0.1mm)
  #102 = #102 + 0.15       (AUMENTA PROFUNDIDADE)
  IF [#102 GT 1.6] THEN #102 = 1.6  (LIMITE MÁXIMO)
END1

G00 X50. Z50.
M09 M05 M30
%''',
    linhasExplicadas: [
      LinhaExplicada('#100 = 1.5', explicacao: 'Variável do passo inicial — será incrementada a cada volta de rosca'),
      LinhaExplicada('G32 Z-30. F[#100]', explicacao: 'Rosca simples: Z=cota final, F=passo em mm. Usando variável #100 para passo dinâmico'),
      LinhaExplicada('#100 = #100 + 0.1', explicacao: 'Incrementa passo 0.1mm a cada ciclo — resulta em rosca de passo crescente'),
      LinhaExplicada('IF [#102 GT 1.6] THEN #102 = 1.6', explicacao: 'Limita profundidade máxima do passe — evita sobrecarga do inserto'),
    ]),

  ProgramaCNC(
    titulo: 'Desbaste de Escoamento com G74 (Peck Axial)',
    subtitulo: 'Ciclo de ranhuras axiais para alívio de tensão — Fanuc',
    nivel: 'Intermediário',
    descricao: 'G74 no torno para múltiplas ranhuras de escoamento (undercut) axialmente espaçadas. Usado em eixos para limitar comprimento de rosca e criar regiões de alívio mecânico.',
    cor: Color(0xFF0F6E56), icone: Icons.vertical_align_bottom_rounded,
    ferramentas: ['T05 — Inserto de sangrar axial 3mm largura MGGN300'],
    setup: [
      'G74 faz ciclo de peck axial: ideal para ranhuras de escoamento em série',
      'I = espaçamento entre ranhuras (distância X entre cortes)',
      'K = incremento de peck (profundidade por picada)',
    ],
    dicas: [
      'G74 R = recuo após cada peck — mínimo 0.5mm para quebrar cavaco',
      'Parâmetro I no G74 define o passo das ranhuras axiais no eixo X',
      'Velocidade de corte: 60-100 m/min para aço; 30-50 m/min para inox',
      'Ranhura de escoamento padrão DIN: largura 3-5mm, profundidade = raiz da rosca + 0.1mm',
    ],
    tags: ['G74', 'ranhura escoamento', 'undercut', 'sangramento axial', 'torno', 'série'],
    codigo: '''O0117 (RANHURAS DE ESCOAMENTO — G74)
%
G90 G18 G21
G28 G91 Z0. X0.
G90

(4 RANHURAS DE ESCOAMENTO Ø28mm, 3mm LARGURA)
(ESPAÇADAS DE 10mm — eixo Z)
T0505 M03
G96 S80 M03
G50 S1500
M08

G00 X32. Z-15.   (POSIÇÃO Z DA PRIMEIRA RANHURA)

(G74 CICLO DE RANHURAS AXIAIS EM SÉRIE)
(R=recuo pós-peck, X=diâm.final, Z=cota final, I=passo, K=peck, F=avanço)
G74 R0.5
G74 X28. Z-15. P3000 Q1000 F0.06
(P3000=3mm entre ranhuras no X, Q1000=1mm peck)

(4 RANHURAS INDIVIDUAIS SE NECESSÁRIO)
G00 X32. Z-25.
G74 R0.5
G74 X28. Z-25. P3000 Q1000 F0.06

G00 X100. Z100.
M09 M05 M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G74 R0.5', explicacao: 'Define recuo de 0.5mm após cada incremento de peck — necessário para quebrar cavaco'),
      LinhaExplicada('G74 X28. Z-15. P3000 Q1000 F0.06', explicacao: 'X=diâm.final da ranhura, Z=cota, P=3mm espaçamento X, Q=1mm por peck, F=0.06mm/rot'),
      LinhaExplicada('G96 S80 M03', explicacao: 'CSS 80m/min adequado para inserto de sangrar em aço — constante independente do diâmetro'),
    ]),
];

// ─── PROGRAMAS EXTRAS — Especiais ────────────────────────────
const _programasEspeciaisExtras = [

  ProgramaCNC(
    titulo: 'Ciclo de Rebaixo (Boring Cycle G76)',
    subtitulo: 'G76 ciclo de mandrilamento de acabamento — Fanuc',
    nivel: 'Avançado',
    tags: ['G76', 'mandrilamento', 'boring', 'H7', 'rebaixo', 'Fanuc', 'avançado'],
    descricao: 'Mandrilamento preciso de furo Ø30H7 com ciclo G76. Saída com orientação do spindle (M19) evita risco de marcar a parede do furo.',
    cor: Color(0xFF4527A0), icone: Icons.add_circle_outline_rounded,
    ferramentas: ['T01 — Broca Ø27mm (pré-furo)', 'T02 — Mandril ajustável Ø28-32mm'],
    setup: [
      'G76 saída com M19 (orientação) — configurar parâmetro Q do ciclo',
      'Ajustar bloco do mandril antes — medir com micrômetro de três pontos',
      'Tolerância Ø30H7: +0/+21µm',
    ],
    dicas: [
      'Medir pré-furo com calibrador antes do mandrilamento — pré-furo ideal = Ø nominal − 0.3mm',
      'Avanço lento 0.05–0.12 mm/rot no mandrilamento fino para Ra < 1.6µm',
      'Orientar eixo com M19 antes de retrair o mandril evita arranhado na superfície',
      'Compensar desvio de temperatura: medir peça fria (20°C) para precisão H7',
    ],
    codigo: '''O0130 (MANDRILAMENTO Ø30H7)
%
G90 G17 G21
G28 G91 Z0.
G90

(*** PRÉ-FURO Ø27mm ***)
T01 M06
G00 G90 G54 X0. Y0.
G43 H01 Z50. M03 S800
M08

G99 G83 X0. Y0. Z-32. R2. Q6. F120.
G80
G00 Z50.

(*** MANDRILAMENTO Ø30 H7 — G76 ***)
T02 M06
G00 G90 G54 X0. Y0.
G43 H02 Z50. M03 S600

(G76 X=diam_furo Z=prof R=plano P=pausa Q=desvio afastamento I=passe)
G76 X30.005 Z-30. R2. P0 Q100 F0.05
(Q100 = recuo 0.1mm para sair sem marcar)

G00 Z50.
M09
G28 G91 Z0.
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G99 G83 X0. Y0. Z-32. R2. Q6. F120.', explicacao: 'G83=peck drilling para pré-furo Ø27mm, Q6=peck 6mm'),
      LinhaExplicada('G76 X30.005 Z-30. R2. P0 Q100 F0.05', explicacao: 'G76=mandrilamento fino; X=diâm. alvo (30.005 para H7); Q100=recuo 0.1mm na saída'),
      LinhaExplicada('Q100', explicacao: 'Recuo radial de 0.1mm antes de subir — evita risco na parede do furo. Obrigatório no G76!'),
      LinhaExplicada('F0.05', explicacao: 'Feed muito baixo no mandrilamento — 0.05mm/rot para Ra ≤ 1.6µm (N7)'),
    ]),

  ProgramaCNC(
    titulo: 'Compensação Automática por Apalpador (G31)',
    subtitulo: 'Skip function G31 com apalpador de toque — Fanuc',
    nivel: 'Avançado',
    tags: ['G31', 'apalpador', 'probe', 'skip function', 'macro', 'Fanuc', 'automação'],
    descricao: 'Uso do G31 (skip function) para medir a peça com apalpador de toque e atualizar automaticamente o offset de comprimento de ferramenta na variável de macro.',
    cor: Color(0xFFE65100), icone: Icons.sensors_rounded,
    ferramentas: ['T09 — Apalpador de toque Renishaw (ou similar)'],
    setup: [
      'Apalpador configurado no parâmetro de salto (skip signal)',
      'Macro deve ter permissão de escrita nos offsets (#2001 em diante)',
      'Testar com M00 antes de ativar escrita automática',
    ],
    dicas: [
      'G31 para quando detecta contato — posição fica em #5061 (X), #5062 (Y), #5063 (Z)',
      'Usar F lento no toque (F50–F100) para precisão — velocidade influencia desvio de trigger',
      'Variáveis #2001–#2999 são os offsets de ferramenta — gravar com cuidado para não corromper',
      'Sempre calibrar o apalpador com peça referência antes de usar em produção',
    ],
    codigo: '''O0140 (MEDIÇÃO COM APALPADOR G31)
%
G90 G17 G21
G28 G91 Z0.
G90

T09 M06              (APALPADOR DE TOQUE)
G00 G90 G54 X0. Y0.
G43 H09 Z50. M03 S0  (SPINDLE PARADO)
M08

(DESCE DEVAGAR ATÉ TOCAR A PEÇA)
G00 Z10.
G31 Z-5. F50.        (DESCIDA COM SKIP — PARA AO TOCAR)

(#5063 = Z no momento do toque)
#100 = #5063           (SALVA POSIÇÃO DO TOQUE)

(CALCULA ERRO E CORRIGE OFFSET H01)
#101 = #100 - 0.0      (DIFERENÇA EM RELAÇÃO A Z=0 DESEJADO)
#2001 = #2001 + #101   (ATUALIZA OFFSET H01 AUTOMATICAMENTE)

G91 G28 Z0.
G90

(CONFIRMAÇÃO NO ECRÃ)
#3000 = 1 (OFFSET ATUALIZADO - VERIFICAR)

M09
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G31 Z-5. F50.', explicacao: 'G31=skip function: move Z para -5 a 50mm/min, mas PARA quando o apalpador toca'),
      LinhaExplicada('#100 = #5063', explicacao: '#5063=variável do sistema com a posição Z no momento do skip (toque)'),
      LinhaExplicada('#101 = #100 - 0.0', explicacao: 'Calcula o erro: diferença entre a posição de toque e o Z esperado (0.0 = face da peça)'),
      LinhaExplicada('#2001 = #2001 + #101', explicacao: '#2001=offset H01 na memória do Fanuc — adiciona a correção automaticamente'),
      LinhaExplicada('#3000 = 1', explicacao: 'Exibe alarme customizado nº 1 no ecrã — serve como confirmação ao operador'),
    ]),

  ProgramaCNC(
    titulo: 'Ciclo de Rosca Interior G84 / G86 (Boring)',
    subtitulo: 'Combinação mandrilamento + rosca em 1 fixação — Fanuc',
    nivel: 'Avançado',
    tags: ['G84', 'G86', 'rosca interna', 'mandrilamento', 'M30', 'Fanuc', 'avançado'],
    descricao: 'Sequência completa para rosca interna M30×2: mandrilamento a Ø27.9mm e rosqueamento G84 rígido em 1 operação. Aplicação em tampas, flanges e componentes hidráulicos.',
    cor: Color(0xFF880E4F), icone: Icons.settings_rounded,
    ferramentas: ['T01 — Broca Ø25mm', 'T02 — Fresa mandriladora Ø26-28mm', 'T03 — Macho M30×2 rígido passo 2'],
    setup: [
      'Pré-furo Ø25mm — deixar sobremetal para mandrilamento',
      'Mandrilar para Ø27.9mm ±0.02 — base para a rosca M30',
      'Macho rígido: F = S × 2.0 (passo 2mm)',
    ],
    dicas: [
      'Fórmula do avanço: F = S × passo — para M30×2 com S=150 → F300',
      'G84 usa porta-macho flutuante — G74 usa porta-macho rígido (mais preciso)',
      'Profundidade mínima de rosca útil: 1,5× diâmetro nominal (M30 → 45mm mínimo)',
      'Conferir pré-furo com calibrador antes do machoamento — furo pequeno quebra o macho',
    ],
    codigo: '''O0150 (ROSCA INTERNA M30x2)
%
G90 G17 G21
G28 G91 Z0.
G90

(*** BROCA Ø25mm ***)
T01 M06
G00 G54 X0. Y0.
G43 H01 Z50. M03 S500
M08
G99 G83 Z-42. R2. Q7. F100.
G80 G00 Z50.

(*** MANDRILAMENTO Ø27.9 — G76 ***)
T02 M06
G00 G54 X0. Y0.
G43 H02 Z50. M03 S400
G76 X27.900 Z-38. R2. Q80 F0.08
G00 Z50.

(*** ROSQUEAMENTO M30x2 — G84 RÍGIDO ***)
T03 M06
G00 G54 X0. Y0.
G43 H03 Z50. M29 S300  (M29 = MODO RÍGIDO)
(F = N x PASSO = 300 x 2.0 = 600)
G99 G84 X0. Y0. Z-38. R5. F600.
G80

G00 Z50.
M09
G28 G91 Z0.
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G99 G83 Z-42. R2. Q7. F100.', explicacao: 'Pré-furo com peck 7mm — profundidade 42mm = rosca 38mm + folga'),
      LinhaExplicada('G76 X27.900 Z-38. R2. Q80 F0.08', explicacao: 'Mandrilamento preciso Ø27.9mm — base necessária para rosca M30×2'),
      LinhaExplicada('M29 S300', explicacao: 'M29=habilita modo de rosqueamento rígido no Fanuc; S=RPM do ciclo'),
      LinhaExplicada('G99 G84 Z-38. R5. F600.', explicacao: 'G84 rígido com R5 para recuo amplo; F=S×passo=300×2=600mm/min — crítico!'),
    ]),

  ProgramaCNC(
    titulo: 'Subprograma com M98/M99 — Padrão de Furos',
    subtitulo: 'Chamada de subprograma repetido — Fanuc',
    nivel: 'Intermediário',
    descricao: 'Demonstra o uso de M98 (chama subprograma) e M99 (retorna) para criar um padrão de furos M8 em 3 grupos de 4 furos cada. Reduz o programa principal e facilita manutenção.',
    cor: Color(0xFF185FA5), icone: Icons.account_tree_rounded,
    ferramentas: ['T01 — Broca de centrar Ø4mm', 'T02 — Broca Ø6.75mm', 'T03 — Macho M8×1.25'],
    setup: [
      'Programa principal O0200 chama subprograma O9001 com M98 P9001',
      'M99 no final do subprograma retorna ao bloco seguinte do principal',
      'Usar M98 P9001 Lx para repetição automática x vezes',
    ],
    dicas: [
      'M98 P9001: chama subprograma O9001 — usar número acima de O9000 para subroutines',
      'Subprograma retorna com M99 — o controle volta ao bloco seguinte ao M98',
      'M98 P9001 L3: chama 3 vezes seguidas — economiza memória e linhas no programa',
      'Ideal para: padrões repetidos, operações múltiplas, modularização do código CNC',
    ],
    tags: ['M98', 'M99', 'subprograma', 'subroutine', 'padrão furos', 'modular', 'Fanuc'],
    codigo: '''(PROGRAMA PRINCIPAL — O0200)
O0200
%
G90 G17 G21
G28 G91 Z0.
G90

(GRUPO 1: 4 FUROS EM X10-40, Y10)
T01 M06
G43 H01 M03 S2500
G00 G54 X10. Y10.
M98 P9001         (CHAMA SUB — CENTRAR 4 FUROS)
G00 X10. Y10.
M98 P9001

(TROCA PARA BROCA)
T02 M06
G43 H02 M03 S2200
G00 G54 X10. Y10.
M98 P9002         (CHAMA SUB — BROCAÇÃO)

(TROCA PARA MACHO)
T03 M06
G43 H03 M03 S600
G00 G54 X10. Y10.
M98 P9003         (CHAMA SUB — ROSQUEAMENTO)

G28 G91 Z0.
M05 M30
%

(SUBPROGRAMA O9001 — CENTRAGEM 4 FUROS)
O9001
G99 G81 X10. Y10. Z-2. R2. F120.
X30.
X50.
X70.
G80
G00 Z50.
M99               (RETORNA AO PROGRAMA PRINCIPAL)
%

(SUBPROGRAMA O9002 — BROCAÇÃO Ø6.75mm)
O9002
G99 G83 X10. Y10. Z-22. R2. Q5. F120.
X30.
X50.
X70.
G80
G00 Z50.
M99
%

(SUBPROGRAMA O9003 — MACHO M8×1.25)
O9003
G99 G84 X10. Y10. Z-18. R5. F750.
X30.
X50.
X70.
G80
G00 Z50.
M99
%''',
    linhasExplicadas: [
      LinhaExplicada('M98 P9001', explicacao: 'Chama subprograma O9001 — controle salta para ele e executa até encontrar M99'),
      LinhaExplicada('M99', explicacao: 'Final do subprograma — retorna ao programa principal no bloco após o M98 que chamou'),
      LinhaExplicada('G99 G81 X10. Y10. Z-2. R2. F120.', explicacao: 'Ciclo de centrar no subprograma — posições relativas ao G54 ativo'),
      LinhaExplicada('M98 P9001 (L3 opcional)', explicacao: 'L3 repetiria o subprograma 3 vezes — útil para múltiplos grupos idênticos'),
    ]),

  ProgramaCNC(
    titulo: 'Usinagem de Alta Velocidade (HSM) com G05.1',
    subtitulo: 'High-Speed Machining — antecipação de trajetória Fanuc',
    nivel: 'Avançado',
    descricao: 'Ativação do modo HSM (High Speed Machining) com G05.1 Q1 no Fanuc para fresamento de moldes e superfícies complexas. Reduz erros de contorno em velocidades altas.',
    cor: Color(0xFF4527A0), icone: Icons.speed_rounded,
    ferramentas: ['T01 — Fresa de topo esférico Ø8mm 4F carbide micrograin'],
    setup: [
      'G05.1 Q1 habilita modo AI Contour Control (AICC) — antecipação de trajetória',
      'G05.1 Q0 cancela — sempre cancelar ao final do programa',
      'Parâmetro 1770 define nível de tolerância — valores menores = mais preciso, mais lento',
    ],
    dicas: [
      'HSM reduz erro de contorno de 0.05mm para 0.005mm em superfícies curvas a 10m/min',
      'G05.1 Q1 lê blocos à frente e suaviza velocidade nos cantos — evita marcas de parada',
      'Combine com F alta (5000–15000mm/min) e ap/ae pequenos (0.1-0.3mm) para moldes',
      'G08 P1 = look-ahead básico em controles mais antigos; G05.1 = versão avançada',
    ],
    tags: ['HSM', 'alta velocidade', 'G05.1', 'AICC', 'molde', 'superfície', 'Fanuc', 'avançado'],
    codigo: '''O0160 (HSM — SUPERFÍCIE FREEFORM)
%
G90 G17 G21
G28 G91 Z0.
G90

T01 M06
G00 G90 G54 X0. Y0.
G43 H01 Z10. M03 S18000
M08

(HABILITA HIGH-SPEED MACHINING MODE)
G05.1 Q1

(PARÂMETRO DE TOLERÂNCIA — menor = mais preciso)
(Inserido via parâmetro 1770 no controle)

(TRAJETÓRIA DE FACEAMENTO EM ZIGUEZAGUE)
(avanço alto: F8000mm/min com stepover 0.3mm)
G00 X-2. Y-2.
G01 Z-0.1 F500.

G01 X52. F8000.
G01 Y-2.3
G01 X-2.
G01 Y-2.6
G01 X52.
G01 Y-2.9
G01 X-2.

(CONTINUA VARREDURA — EXEMPLO COMPRIMIDO)
(CAM geraria centenas de blocos aqui)

G00 Z50.

(CANCELA MODO HSM — OBRIGATÓRIO)
G05.1 Q0

M09
G28 G91 Z0.
M05
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('G05.1 Q1', explicacao: 'Habilita AI Contour Control (AICC) — controle lê blocos à frente e suaviza trajetória para alta velocidade'),
      LinhaExplicada('G01 X52. F8000.', explicacao: 'Avanço 8m/min viável em HSM — sem G05.1 causaria vibração e erros de contorno'),
      LinhaExplicada('G01 Y-2.3', explicacao: 'Stepover de 0.3mm na direção Y — fino para superfícies de molde com Ra < 0.8µm'),
      LinhaExplicada('G05.1 Q0', explicacao: 'Cancela HSM — sempre necessário ao final. Sem cancelar, modo persiste nos próximos programas'),
    ]),

  ProgramaCNC(
    titulo: 'Troca Automática de Ferramenta com Monitoramento (ATC)',
    subtitulo: 'Gestão de vida de ferramenta com M06 + variável — Fanuc',
    nivel: 'Avançado',
    descricao: 'Programa com lógica de monitoramento de vida de ferramenta usando variáveis Macro. Conta peças usinadas e emite alerta/parada quando a ferramenta atinge o limite de vida.',
    cor: Color(0xFFE65100), icone: Icons.build_circle_rounded,
    ferramentas: ['Qualquer ferramenta — lógica aplicável universalmente'],
    setup: [
      'Variável #500 = contador de peças (memória persistente no Fanuc)',
      'Variável #501 = limite de vida (definido pelo operador ou processo)',
      'M00 = parada programada para troca manual; M01 = parada opcional',
    ],
    dicas: [
      'Variáveis #500–#999 são persistentes no Fanuc — mantêm valor após desligar',
      'Zerar #500 após trocar ferramenta: inserir manualmente ou criar subprograma de reset',
      'G10 L10 P1 R[novo_valor]: pode sobrescrever offsets programaticamente via macro',
      'Integrar com DPRNT[] para enviar dados para DNC/SCADA via RS-232/Ethernet',
    ],
    tags: ['monitoramento', 'vida ferramenta', 'macro', 'variável persistente', 'M00', 'produção', 'Fanuc'],
    codigo: '''O0170 (MONITORAMENTO VIDA FERRAMENTA)
%
G90 G17 G21
G28 G91 Z0.
G90

(#500 = CONTADOR DE PEÇAS — PERSISTENTE)
(#501 = LIMITE DE VIDA — EX: 50 PEÇAS)
IF [#501 EQ 0.] THEN #501 = 50.   (DEFINE LIMITE SE NÃO DEFINIDO)

(VERIFICA VIDA ANTES DE INICIAR)
IF [#500 GE #501] GOTO 999

(PROGRAMA NORMAL DE USINAGEM)
T01 M06
G00 G90 G54 X0. Y0.
G43 H01 Z50. M03 S3000
M08

G99 G81 X10. Y10. Z-15. R2. F120.
X30. X50. X70.
G80

G00 Z50.
M09
G28 G91 Z0.
M05

(INCREMENTA CONTADOR DE PEÇAS)
#500 = #500 + 1.

(VERIFICA SE ATINGIU LIMITE)
IF [#500 LT #501] GOTO 900

(ALERTA: FERRAMENTA NO LIMITE)
M00              (PARADA PARA TROCAR FERRAMENTA)
#500 = 0.        (ZERA CONTADOR APÓS TROCA)
N900
M30
%

N999 (FERRAMENTA JÁ NO LIMITE — PARADA DE SEGURANÇA)
M00
M30
%''',
    linhasExplicadas: [
      LinhaExplicada('#500 = #500 + 1.', explicacao: 'Incrementa contador persistente — valor mantido mesmo após desligar a máquina'),
      LinhaExplicada('IF [#500 GE #501] GOTO 999', explicacao: 'Verifica no início: se contador ≥ limite, salta para parada de segurança N999'),
      LinhaExplicada('M00', explicacao: 'Parada programada — spindle e avanço param, operador troca ferramenta e pressiona Cycle Start'),
      LinhaExplicada('#500 = 0.', explicacao: 'Zera contador após confirmação da troca — reinicia contagem para a nova ferramenta'),
    ]),
];