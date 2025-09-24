// 📚 FolhaVirada - Main Application
// Ponto de entrada da aplicação

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:folhavirada/config/theme.dart';
import 'package:folhavirada/config/routes.dart';
import 'package:folhavirada/core/constants/app_constants.dart';
import 'package:folhavirada/core/di/injection.dart';
import 'package:folhavirada/presentation/screens/home/home_screen.dart';

void main() async {
  // Garantir que os bindings do Flutter estão inicializados
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientação da tela (apenas portrait)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configurar barra de status
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Configurar injeção de dependências
  await setupDependencies();

  // Executar aplicativo
  runApp(const FolhaViradaApp());
}

class FolhaViradaApp extends StatefulWidget {
  const FolhaViradaApp({super.key});

  @override
  State<FolhaViradaApp> createState() => _FolhaViradaAppState();
}

class _FolhaViradaAppState extends State<FolhaViradaApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    // TODO: Carregar tema salvo das preferências
    // final storageService = getIt<StorageService>();
    // final savedTheme = await storageService.getThemeMode();
    // setState(() {
    //   _themeMode = _parseThemeMode(savedTheme);
    // });
  }

  ThemeMode _parseThemeMode(String themeString) {
    switch (themeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Informações do app
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Temas
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,

      // Navegação
      initialRoute: AppRoutes.home,
      onGenerateRoute: AppRoutes.generateRoute,

      // Tela inicial
      home: const HomeScreen(),

      // Configurações de localização
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Builder para interceptar erros de navegação
      builder: (context, child) {
        // Configurar densidade de pixels para diferentes dispositivos
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.2),
          ),
          child: child ?? const SizedBox(),
        );
      },

      // Configurações de scroll
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
        overscroll: false,
      ),
    );
  }
}

// Classe para gerenciar configurações globais do app
class AppConfig {
  static bool get isDebug {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  static bool get isProduction => !isDebug;

  static String get appVersion => AppConstants.appVersion;

  static String get appName => AppConstants.appName;
}
