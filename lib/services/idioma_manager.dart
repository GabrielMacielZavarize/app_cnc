import 'package:flutter/foundation.dart';

enum AppIdioma { pt, en, es }

class IdiomaManager extends ChangeNotifier {
  static final IdiomaManager _instance = IdiomaManager._();
  static IdiomaManager get instance => _instance;
  IdiomaManager._();

  AppIdioma _idioma = AppIdioma.pt;
  AppIdioma get idioma => _idioma;

  void setIdioma(AppIdioma novo) {
    _idioma = novo;
    notifyListeners();
  }

  String? tr(String chave) {
    return _traducoes[_idioma]?[chave] ?? _traducoes[AppIdioma.pt]?[chave] ?? chave;
  }

  static const _traducoes = {
    AppIdioma.pt: {
      // App
      'app.subtitulo': 'Assistente CNC Inteligente',
      'app.slogan': 'TECNOLOGIA PARA O CHÃO DE FÁBRICA',

      // Navegação
      'nav.inicio': 'Início',
      'nav.biblioteca': 'Biblioteca',
      'nav.alarmes': 'Alarmes',
      'nav.ia': 'IA',
      'nav.mais': 'Mais',

      // Home
      'home.online': 'Online',
      'home.offline': 'Offline',
      'home.bemvindo': 'Bem-vindo,',
      'home.operador': 'Operador CNC',
      'home.buscar': 'Buscar código, alarme ou material...',
      'home.acessorapido': 'Acesso Rápido',
      'home.recentes': 'Recentes',
      'home.analisaria': 'Analisar com IA',
      'home.analisaria.sub': 'Diagnóstico inteligente por foto ou texto',
      'home.guia': 'Guia Rápido',
      'home.guia.sub': 'Dicas e boas práticas para o operador',
      'home.novo': 'NOVO',

      // IA / Offline
      'ia.offline': 'Sem conexão com internet',
      'ia.offline.sub': 'A análise por IA requer conexão com a internet.',

      // Geral
      'geral.fechar': 'Fechar',
      'geral.buscar': 'Buscar',
      'geral.offline.msg': 'Você está offline. Alguns recursos podem estar indisponíveis.',

      // Módulos — títulos
      'mod.biblioteca': 'Biblioteca',
      'mod.biblioteca.sub': 'Códigos G e M completos',
      'mod.alarmes': 'Alarmes CNC',
      'mod.alarmes.sub': '7 fabricantes catalogados',
      'mod.calculadora': 'Calculadora',
      'mod.calculadora.sub': 'RPM, avanço, rosca e mais',
      'mod.materiais': 'Materiais',
      'mod.materiais.sub': '30 materiais de usinagem',
      'mod.tabelas.sub': 'Tabelas de referência técnica',
      'mod.programas': 'Programas',
      'mod.programas.sub': 'Exemplos e templates CNC',
      'mod.favoritos': 'Favoritos',
      'mod.guia.sub': 'Dicas e boas práticas CNC',

      // Seções do menu Mais
      'mais.titulo': 'Ferramentas',
      'mais.ferramentas': 'Ferramentas de Cálculo',
      'mais.programacao': 'Programação CNC',
      'mais.pessoal': 'Pessoal',

      // Calculadora
      'calc.titulo': 'Calculadora CNC',
      'calc.rpm': 'RPM',
      'calc.avanco': 'Avanço',
      'calc.potencia': 'Potência',
      'calc.tempo': 'Tempo de Corte',
      'calc.rosca': 'Rosca',

      // Materiais
      'mat.titulo': 'Materiais',
      'mat.fresamento': 'Fresamento',
      'mat.torneamento': 'Torneamento',
      'mat.furacao': 'Furação',

      // Tabelas
      'tab.titulo': 'Tabelas',

      // Outros módulos
      'prog.titulo': 'Programas CNC',
      'guia.titulo': 'Guia do Operador',
      'cod.codigoG': 'Código G',

      // Configurações
      'config.titulo': 'Configurações',
      'config.idioma': 'Idioma',
      'config.pt': 'Português',
      'config.en': 'English',
      'config.es': 'Español',
      'config.sobre': 'Sobre',
      'config.versao': 'Versão',
      'config.feito': 'Pronto',
      'config.ativo': 'Ativo',
    },

    AppIdioma.en: {
      // App
      'app.subtitulo': 'Smart CNC Assistant',
      'app.slogan': 'TECHNOLOGY FOR THE SHOP FLOOR',

      // Navigation
      'nav.inicio': 'Home',
      'nav.biblioteca': 'Library',
      'nav.alarmes': 'Alarms',
      'nav.ia': 'AI',
      'nav.mais': 'More',

      // Home
      'home.online': 'Online',
      'home.offline': 'Offline',
      'home.bemvindo': 'Welcome,',
      'home.operador': 'CNC Operator',
      'home.buscar': 'Search code, alarm or material...',
      'home.acessorapido': 'Quick Access',
      'home.recentes': 'Recent',
      'home.analisaria': 'Analyze with AI',
      'home.analisaria.sub': 'Smart diagnosis by photo or text',
      'home.guia': 'Quick Guide',
      'home.guia.sub': 'Tips and best practices for operators',
      'home.novo': 'NEW',

      // AI / Offline
      'ia.offline': 'No internet connection',
      'ia.offline.sub': 'AI analysis requires internet connection.',

      // General
      'geral.fechar': 'Close',
      'geral.buscar': 'Search',
      'geral.offline.msg': 'You are offline. Some features may be unavailable.',

      // Modules — titles
      'mod.biblioteca': 'Library',
      'mod.biblioteca.sub': 'Complete G and M codes',
      'mod.alarmes': 'CNC Alarms',
      'mod.alarmes.sub': '7 cataloged manufacturers',
      'mod.calculadora': 'Calculator',
      'mod.calculadora.sub': 'RPM, feed, thread and more',
      'mod.materiais': 'Materials',
      'mod.materiais.sub': '30 machining materials',
      'mod.tabelas.sub': 'Technical reference tables',
      'mod.programas': 'Programs',
      'mod.programas.sub': 'CNC examples and templates',
      'mod.favoritos': 'Favorites',
      'mod.guia.sub': 'CNC tips and best practices',

      // More menu sections
      'mais.titulo': 'Tools',
      'mais.ferramentas': 'Calculation Tools',
      'mais.programacao': 'CNC Programming',
      'mais.pessoal': 'Personal',

      // Calculator
      'calc.titulo': 'CNC Calculator',
      'calc.rpm': 'RPM',
      'calc.avanco': 'Feed Rate',
      'calc.potencia': 'Power',
      'calc.tempo': 'Cutting Time',
      'calc.rosca': 'Thread',

      // Materials
      'mat.titulo': 'Materials',
      'mat.fresamento': 'Milling',
      'mat.torneamento': 'Turning',
      'mat.furacao': 'Drilling',

      // Tables
      'tab.titulo': 'Tables',

      // Other modules
      'prog.titulo': 'CNC Programs',
      'guia.titulo': 'Operator Guide',
      'cod.codigoG': 'G Code',

      // Settings
      'config.titulo': 'Settings',
      'config.idioma': 'Language',
      'config.pt': 'Português',
      'config.en': 'English',
      'config.es': 'Español',
      'config.sobre': 'About',
      'config.versao': 'Version',
      'config.feito': 'Done',
      'config.ativo': 'Active',
    },

    AppIdioma.es: {
      // App
      'app.subtitulo': 'Asistente CNC Inteligente',
      'app.slogan': 'TECNOLOGÍA PARA EL TALLER',

      // Navegación
      'nav.inicio': 'Inicio',
      'nav.biblioteca': 'Biblioteca',
      'nav.alarmes': 'Alarmas',
      'nav.ia': 'IA',
      'nav.mais': 'Más',

      // Home
      'home.online': 'En línea',
      'home.offline': 'Sin conexión',
      'home.bemvindo': 'Bienvenido,',
      'home.operador': 'Operador CNC',
      'home.buscar': 'Buscar código, alarma o material...',
      'home.acessorapido': 'Acceso Rápido',
      'home.recentes': 'Recientes',
      'home.analisaria': 'Analizar con IA',
      'home.analisaria.sub': 'Diagnóstico inteligente por foto o texto',
      'home.guia': 'Guía Rápida',
      'home.guia.sub': 'Consejos y buenas prácticas para operadores',
      'home.novo': 'NUEVO',

      // IA / Sin conexión
      'ia.offline': 'Sin conexión a internet',
      'ia.offline.sub': 'El análisis de IA requiere conexión a internet.',

      // General
      'geral.fechar': 'Cerrar',
      'geral.buscar': 'Buscar',
      'geral.offline.msg': 'Estás sin conexión. Algunas funciones pueden no estar disponibles.',

      // Módulos — títulos
      'mod.biblioteca': 'Biblioteca',
      'mod.biblioteca.sub': 'Códigos G y M completos',
      'mod.alarmes': 'Alarmas CNC',
      'mod.alarmes.sub': '7 fabricantes catalogados',
      'mod.calculadora': 'Calculadora',
      'mod.calculadora.sub': 'RPM, avance, rosca y más',
      'mod.materiais': 'Materiales',
      'mod.materiais.sub': '30 materiales de mecanizado',
      'mod.tabelas.sub': 'Tablas de referencia técnica',
      'mod.programas': 'Programas',
      'mod.programas.sub': 'Ejemplos y plantillas CNC',
      'mod.favoritos': 'Favoritos',
      'mod.guia.sub': 'Consejos y buenas prácticas CNC',

      // Secciones del menú Más
      'mais.titulo': 'Herramientas',
      'mais.ferramentas': 'Herramientas de Cálculo',
      'mais.programacao': 'Programación CNC',
      'mais.pessoal': 'Personal',

      // Calculadora
      'calc.titulo': 'Calculadora CNC',
      'calc.rpm': 'RPM',
      'calc.avanco': 'Avance',
      'calc.potencia': 'Potencia',
      'calc.tempo': 'Tiempo de Corte',
      'calc.rosca': 'Rosca',

      // Materiales
      'mat.titulo': 'Materiales',
      'mat.fresamento': 'Fresado',
      'mat.torneamento': 'Torneado',
      'mat.furacao': 'Taladrado',

      // Tablas
      'tab.titulo': 'Tablas',

      // Otros módulos
      'prog.titulo': 'Programas CNC',
      'guia.titulo': 'Guía del Operador',
      'cod.codigoG': 'Código G',

      // Configuración
      'config.titulo': 'Configuración',
      'config.idioma': 'Idioma',
      'config.pt': 'Português',
      'config.en': 'English',
      'config.es': 'Español',
      'config.sobre': 'Acerca de',
      'config.versao': 'Versión',
      'config.feito': 'Listo',
      'config.ativo': 'Activo',
    },
  };
}

IdiomaManager get idiomaManager => IdiomaManager.instance;
