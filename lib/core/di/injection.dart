// 📚 FolhaVirada - Dependency Injection
// Configuração do GetIt para injeção de dependências

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:folhavirada/core/services/local_storage_service.dart';
import 'package:folhavirada/core/services/app_state_service.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

/// Registrar dependências manualmente se necessário
Future<void> setupDependencies() async {
  try {
    await configureDependencies();
  } catch (e) {
    // If injectable fails, continue with manual setup
    print('Injectable setup failed: $e');
  }
  
  // Register storage service
  final storageService = LocalStorageService();
  await storageService.initialize();
  getIt.registerSingleton<LocalStorageService>(storageService);
  
  // Register app state service
  final appStateService = AppStateService();
  getIt.registerSingleton<AppStateService>(appStateService);
}
