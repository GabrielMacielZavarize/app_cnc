import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────
// IDs DOS PRODUTOS — devem ser idênticos
// ao cadastrado no Google Play Console
// ─────────────────────────────────────────
const kProductMensal    = 'cnc_ia_mensal';    // assinatura mensal
const kProductAnual     = 'cnc_ia_anual';     // assinatura anual
const kProductVitalicio = 'cnc_ia_vitalicio'; // compra única (lifetime)

const _kPremiumKey = 'cncia_is_premium';

// ─────────────────────────────────────────
// SERVIÇO DE COMPRAS (singleton)
// ─────────────────────────────────────────
class PurchaseService extends ChangeNotifier {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  final _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // Estado público
  bool _isPremium     = false;
  bool _isLoading     = false;
  bool _storeAvail    = false;
  String? _errorMsg;
  List<ProductDetails> _products = [];

  bool get isPremium  => _isPremium;
  bool get isLoading  => _isLoading;
  bool get storeAvail => _storeAvail;
  String? get errorMsg => _errorMsg;
  List<ProductDetails> get products => _products;

  // ── Encontra produto pelo ID ──────────────
  ProductDetails? productById(String id) {
    try { return _products.firstWhere((p) => p.id == id); }
    catch (_) { return null; }
  }

  // ── Plataforma suporta billing? ──────────
  // in_app_purchase só funciona em Android e iOS
  bool get _plataformaSuportada =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
       defaultTargetPlatform == TargetPlatform.iOS);

  // ── Inicialização ─────────────────────────
  Future<void> initialize() async {
    try {
      // Carrega status local (já comprado anteriormente)
      final prefs = await SharedPreferences.getInstance();
      _isPremium = prefs.getBool(_kPremiumKey) ?? false;

      // Em web ou Windows: billing não é suportado — libera premium automaticamente
      // pois o usuário não consegue comprar e o app deve funcionar completo
      if (!_plataformaSuportada) {
        _isPremium = true;
        notifyListeners();
        return;
      }

      // Escuta atualizações de compra da Play Store
      _subscription = _iap.purchaseStream.listen(
        _onPurchaseUpdate,
        onError: (e) {
          _errorMsg = 'Erro na loja: $e';
          _isLoading = false;
          notifyListeners();
        },
      );

      // Verifica disponibilidade da loja
      _storeAvail = await _iap.isAvailable();

      if (_storeAvail) {
        await _loadProducts();
        // Restaura compras anteriores automaticamente
        await _iap.restorePurchases();
      }

      notifyListeners();
    } catch (e) {
      // Garante que o app nunca trava por problema de billing
      debugPrint('PurchaseService: erro na inicialização: $e');
      notifyListeners();
    }
  }

  // ── Carrega produtos da Play Store ────────
  Future<void> _loadProducts() async {
    final resp = await _iap.queryProductDetails({
      kProductMensal,
      kProductAnual,
      kProductVitalicio,
    });

    if (resp.error != null) {
      _errorMsg = resp.error!.message;
    } else {
      _products = resp.productDetails;
      // Ordena: mensal, anual, vitalício
      _products.sort((a, b) {
        const ordem = [kProductMensal, kProductAnual, kProductVitalicio];
        return ordem.indexOf(a.id).compareTo(ordem.indexOf(b.id));
      });
    }
    notifyListeners();
  }

  // ── Tratamento de atualizações de compra ──
  Future<void> _onPurchaseUpdate(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _grantPremium();
          if (purchase.pendingCompletePurchase) {
            await _iap.completePurchase(purchase);
          }
          break;

        case PurchaseStatus.error:
          _errorMsg = purchase.error?.message ?? 'Erro desconhecido';
          _isLoading = false;
          notifyListeners();
          break;

        case PurchaseStatus.canceled:
          _isLoading = false;
          notifyListeners();
          break;

        case PurchaseStatus.pending:
          // Aguarda confirmação (ex: boleto, pix)
          break;
      }
    }
  }

  // ── Concede acesso premium e salva localmente ──
  Future<void> _grantPremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPremiumKey, true);
    _isPremium  = true;
    _isLoading  = false;
    _errorMsg   = null;
    notifyListeners();
  }

  // ── Comprar um produto ────────────────────
  Future<void> buyProduct(ProductDetails product) async {
    if (!_plataformaSuportada || !_storeAvail) {
      _errorMsg = 'Compras disponíveis apenas no app Android (Google Play).';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMsg  = null;
    notifyListeners();

    try {
      final param = PurchaseParam(productDetails: product);
      await _iap.buyNonConsumable(purchaseParam: param);
    } catch (e) {
      _errorMsg  = 'Erro ao iniciar compra: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Restaurar compras anteriores ──────────
  Future<void> restorePurchases() async {
    if (!_plataformaSuportada || !_storeAvail) return;
    _isLoading = true;
    _errorMsg  = null;
    notifyListeners();
    await _iap.restorePurchases();
  }

  // ── Para testes locais (remover em produção) ──
  Future<void> debugUnlockPremium() async {
    await _grantPremium();
  }

  Future<void> debugRevokePremium() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kPremiumKey, false);
    _isPremium = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

// Instância global fácil de acessar
final purchaseService = PurchaseService();
