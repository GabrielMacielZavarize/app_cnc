import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'services/idioma_manager.dart';
import 'screens/splash_screen.dart';
import 'services/purchase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Barra de status transparente
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  // Inicializa o serviço de compras (Google Play Billing)
  await purchaseService.initialize();

  runApp(const CNCIAApp());
}

class CNCIAApp extends StatefulWidget {
  const CNCIAApp({super.key});
  @override
  State<CNCIAApp> createState() => _CNCIAAppState();
}

class _CNCIAAppState extends State<CNCIAApp> {
  @override
  void initState() {
    super.initState();
    idiomaManager.addListener(_refresh);
  }

  @override
  void dispose() {
    idiomaManager.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CNCIA — Assistente CNC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kAmber),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: kDark,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}