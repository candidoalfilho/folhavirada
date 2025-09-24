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

class FolhaViradaApp extends StatelessWidget {
  const FolhaViradaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Informações do app
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Temas
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Navegação
      onGenerateRoute: AppRoutes.generateRoute,

      // Tela inicial
      home: const HomeScreen(),

      // Configurações de localização
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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