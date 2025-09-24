// 📚 FolhaVirada - Injection Modules
// Módulos de injeção de dependência para configurar serviços externos

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:folhavirada/core/constants/app_constants.dart';

@module
abstract class InjectableModule {
  /// Configurar cliente HTTP Dio
  @lazySingleton
  Dio provideDio() {
    final dio = Dio();
    
    // Configurações base
    dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'User-Agent': '${AppConstants.appName}/${AppConstants.appVersion}',
      },
    );

    // Interceptors para logging (apenas em debug)
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (object) => print('[DIO] $object'),
        ),
      );
    }

    // Interceptor para retry automático
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          // Retry uma vez em caso de timeout ou erro de conexão
          if ((error.type == DioExceptionType.connectionTimeout ||
               error.type == DioExceptionType.receiveTimeout ||
               error.type == DioExceptionType.connectionError) &&
              error.requestOptions.extra['retryCount'] == null) {
            
            try {
              error.requestOptions.extra['retryCount'] = 1;
              final response = await dio.request(
                error.requestOptions.path,
                options: Options(
                  method: error.requestOptions.method,
                  headers: error.requestOptions.headers,
                  extra: error.requestOptions.extra,
                ),
                queryParameters: error.requestOptions.queryParameters,
                data: error.requestOptions.data,
              );
              handler.resolve(response);
              return;
            } catch (e) {
              // Se o retry falhar, continue com o erro original
            }
          }
          handler.next(error);
        },
      ),
    );

    return dio;
  }
}

// Constante para verificar se está em modo debug
const bool kDebugMode = bool.fromEnvironment('dart.vm.product') == false;
