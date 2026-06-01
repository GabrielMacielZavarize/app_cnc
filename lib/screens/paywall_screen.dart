import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../constants.dart';
import '../services/purchase_service.dart';

// ─────────────────────────────────────────
// TELA DE PAYWALL — CNCIA PRO
// ─────────────────────────────────────────
class PaywallScreen extends StatefulWidget {
  /// [onClose] é chamado quando o usuário volta sem comprar
  final VoidCallback? onClose;
  const PaywallScreen({super.key, this.onClose});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  final _svc = purchaseService;

  static const _beneficios = [
    ('🤖', 'IA com Gemini 2.0', 'Análise inteligente de peças, erros e programas CNC'),
    ('📸', 'Análise por Foto', 'Tire foto do alarme ou peça e receba diagnóstico na hora'),
    ('💬', 'Consulta por Texto', 'Pergunte qualquer coisa técnica e receba resposta precisa'),
    ('⚙️', '6 Tipos de Análise', 'Geral, Alarme, Peça, Programa, Ferramenta e Parâmetros'),
    ('🔧', 'Sugestão de Parâmetros', 'Velocidade, avanço e profundidade de corte otimizados'),
    ('🌐', 'Funciona em 3 Idiomas', 'Português, inglês e espanhol'),
  ];

  @override
  void initState() {
    super.initState();
    _svc.addListener(_onServiceChange);
  }

  @override
  void dispose() {
    _svc.removeListener(_onServiceChange);
    super.dispose();
  }

  void _onServiceChange() {
    if (!mounted) return;
    setState(() {});
    // Se comprou — fecha a tela
    if (_svc.isPremium) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBeneficios(),
                  _buildPlanos(),
                  if (_svc.errorMsg != null) _buildErro(),
                  _buildRestaurar(),
                  _buildRodape(),
                  // Botão de teste — só aparece em web/Windows (desenvolvimento)
                  if (kIsWeb || defaultTargetPlatform == TargetPlatform.windows)
                    _buildBotaoTeste(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Cabeçalho ────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: kDark,
      padding: const EdgeInsets.fromLTRB(20, 55, 20, 24),
      child: Column(
        children: [
          // Botão voltar
          if (widget.onClose != null)
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: widget.onClose,
                child: const Icon(Icons.close_rounded, color: Colors.white54, size: 22),
              ),
            ),
          const SizedBox(height: 8),

          // Badge PRO
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: kAmber,
              borderRadius: BorderRadius.circular(20)),
            child: const Text('✦ CNCIA PRO',
              style: TextStyle(color: kDark, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
          ),
          const SizedBox(height: 16),

          // Ícone IA
          Container(
            width: 64, height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kAmber, kAmber.withValues(alpha: 0.7)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.auto_awesome_rounded, color: kDark, size: 32)),
          const SizedBox(height: 14),

          const Text('Desbloqueie a IA CNC',
            style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Análise inteligente para o chão de fábrica',
            style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // ── Lista de benefícios ───────────────────
  Widget _buildBeneficios() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('O QUE VOCÊ RECEBE',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
              color: Colors.grey, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          ..._beneficios.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Text(b.$1, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.$2,
                        style: const TextStyle(fontWeight: FontWeight.w600,
                          fontSize: 13, color: kDark)),
                      Text(b.$3,
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle_rounded, color: kGreen, size: 18),
              ],
            ),
          )),
        ],
      ),
    );
  }

  // ── Planos de assinatura ──────────────────
  Widget _buildPlanos() {
    final mensal    = _svc.productById(kProductMensal);
    final anual     = _svc.productById(kProductAnual);
    final vitalicio = _svc.productById(kProductVitalicio);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ESCOLHA SEU PLANO',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
              color: Colors.grey, letterSpacing: 1.2)),
          const SizedBox(height: 10),

          // Plano Mensal
          _buildPlanCard(
            produto: mensal,
            titulo: 'Mensal',
            subtitulo: 'Cancele quando quiser',
            precoFallback: 'R\$ 19,90/mês',
            icone: Icons.calendar_month_rounded,
            cor: kBlue,
            destaque: false,
          ),
          const SizedBox(height: 10),

          // Plano Anual (destaque)
          _buildPlanCard(
            produto: anual,
            titulo: 'Anual',
            subtitulo: 'Equivale a R\$ 12,50/mês • Economize 37%',
            precoFallback: 'R\$ 149,90/ano',
            icone: Icons.star_rounded,
            cor: kAmber,
            destaque: true,
            badge: 'MAIS POPULAR',
          ),
          const SizedBox(height: 10),

          // Plano Vitalício
          _buildPlanCard(
            produto: vitalicio,
            titulo: 'Vitalício',
            subtitulo: 'Pague uma vez, use para sempre',
            precoFallback: 'R\$ 79,90 único',
            icone: Icons.all_inclusive_rounded,
            cor: kGreen,
            destaque: false,
            badge: 'SEM MENSALIDADE',
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required ProductDetails? produto,
    required String titulo,
    required String subtitulo,
    required String precoFallback,
    required IconData icone,
    required Color cor,
    required bool destaque,
    String? badge,
  }) {
    final preco = produto?.price ?? precoFallback;
    final loading = _svc.isLoading;

    return GestureDetector(
      onTap: loading
        ? null
        : () => produto != null
          ? _svc.buyProduct(produto)
          : _mostrarIndisponivel(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: destaque ? kDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: destaque ? kAmber : cor.withValues(alpha: 0.3),
            width: destaque ? 2 : 1),
          boxShadow: destaque ? [
            BoxShadow(color: kAmber.withValues(alpha: 0.2), blurRadius: 16, offset: const Offset(0, 4))
          ] : []),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: destaque ? kAmber : cor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12)),
              child: Icon(icone,
                color: destaque ? kDark : cor, size: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(titulo,
                        style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 15,
                          color: destaque ? Colors.white : kDark)),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: destaque ? kAmber : cor,
                            borderRadius: BorderRadius.circular(6)),
                          child: Text(badge,
                            style: TextStyle(
                              fontSize: 9, fontWeight: FontWeight.w800,
                              color: destaque ? kDark : Colors.white,
                              letterSpacing: 0.5))),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(subtitulo,
                    style: TextStyle(
                      fontSize: 11,
                      color: destaque ? Colors.grey.shade400 : Colors.grey.shade600)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                loading
                  ? SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: destaque ? kAmber : cor))
                  : Text(preco,
                    style: TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 14,
                      color: destaque ? kAmber : cor)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: destaque ? kAmber : cor,
                    borderRadius: BorderRadius.circular(8)),
                  child: Text('Assinar',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700,
                      color: destaque ? kDark : Colors.white))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ── Mensagem de erro ──────────────────────
  Widget _buildErro() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kRed.withValues(alpha: 0.3))),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: kRed, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(_svc.errorMsg!,
              style: const TextStyle(color: kRed, fontSize: 12))),
        ],
      ),
    );
  }

  // ── Restaurar compras ─────────────────────
  Widget _buildRestaurar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: _svc.isLoading ? null : _svc.restorePurchases,
        child: Text('Restaurar compra anterior',
          style: TextStyle(
            fontSize: 13, color: Colors.grey.shade500,
            decoration: TextDecoration.underline)),
      ),
    );
  }

  // ── Rodapé legal ─────────────────────────
  Widget _buildRodape() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Text(
        'O pagamento é processado com segurança pelo Google Play. '
        'Assinaturas são renovadas automaticamente — cancele quando quiser. '
        'Nenhum dado de cartão passa pelo aplicativo.',
        style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
        textAlign: TextAlign.center),
    );
  }

  // ── Botão de desbloqueio para testes (web/Windows apenas) ──
  Widget _buildBotaoTeste() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: GestureDetector(
        onTap: () => _svc.debugUnlockPremium(),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.orange.shade200)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bug_report_rounded, size: 14, color: Colors.orange.shade700),
              const SizedBox(width: 6),
              Text('🧪 MODO TESTE — Desbloquear IA',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                  color: Colors.orange.shade700)),
            ],
          ),
        ),
      ),
    );
  }

  void _mostrarIndisponivel() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Loja indisponível. Verifique sua conexão.'),
      backgroundColor: kRed));
  }
}
