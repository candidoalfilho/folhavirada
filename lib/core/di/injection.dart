// 📚 FolhaVirada - Dependency Injection
// Configuração do GetIt para injeção de dependências

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async => getIt.init();

/// Registrar dependências manualmente se necessário
Future<void> setupDependencies() async {
  await configureDependencies();
  
  // Registros adicionais podem ser feitos aqui se necessário
  // Exemplo:
  // getIt.registerLazySingleton<ExampleService>(() => ExampleService());
}
