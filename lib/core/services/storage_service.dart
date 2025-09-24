// 📚 FolhaVirada - Storage Service
// Serviço para gerenciar SharedPreferences e armazenamento local

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:folhavirada/core/constants/app_constants.dart';

@lazySingleton
class StorageService {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // Métodos para String
  Future<void> setString(String key, String value) async {
    final prefs = await _preferences;
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = await _preferences;
    return prefs.getString(key);
  }

  // Métodos para int
  Future<void> setInt(String key, int value) async {
    final prefs = await _preferences;
    await prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    final prefs = await _preferences;
    return prefs.getInt(key);
  }

  // Métodos para bool
  Future<void> setBool(String key, bool value) async {
    final prefs = await _preferences;
    await prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = await _preferences;
    return prefs.getBool(key);
  }

  // Métodos para double
  Future<void> setDouble(String key, double value) async {
    final prefs = await _preferences;
    await prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    final prefs = await _preferences;
    return prefs.getDouble(key);
  }

  // Métodos para List<String>
  Future<void> setStringList(String key, List<String> value) async {
    final prefs = await _preferences;
    await prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final prefs = await _preferences;
    return prefs.getStringList(key);
  }

  // Remover chave específica
  Future<void> remove(String key) async {
    final prefs = await _preferences;
    await prefs.remove(key);
  }

  // Verificar se chave existe
  Future<bool> containsKey(String key) async {
    final prefs = await _preferences;
    return prefs.containsKey(key);
  }

  // Limpar todas as preferências
  Future<void> clear() async {
    final prefs = await _preferences;
    await prefs.clear();
  }

  // Obter todas as chaves
  Future<Set<String>> getKeys() async {
    final prefs = await _preferences;
    return prefs.getKeys();
  }

  // Métodos específicos da aplicação

  /// Configurações de tema
  Future<void> setThemeMode(String themeMode) async {
    await setString(AppConstants.keyThemeMode, themeMode);
  }

  Future<String> getThemeMode() async {
    return await getString(AppConstants.keyThemeMode) ?? 'system';
  }

  /// Verificar se é o primeiro lançamento
  Future<void> setFirstLaunch(bool isFirstLaunch) async {
    await setBool(AppConstants.keyFirstLaunch, isFirstLaunch);
  }

  Future<bool> isFirstLaunch() async {
    return await getBool(AppConstants.keyFirstLaunch) ?? true;
  }

  /// Contador de anúncios
  Future<void> setAdCount(int count) async {
    await setInt(AppConstants.keyAdCount, count);
  }

  Future<int> getAdCount() async {
    return await getInt(AppConstants.keyAdCount) ?? 0;
  }

  Future<void> incrementAdCount() async {
    final currentCount = await getAdCount();
    await setAdCount(currentCount + 1);
  }

  Future<void> resetAdCount() async {
    await setAdCount(0);
  }

  /// Data do último backup
  Future<void> setLastBackupDate(DateTime date) async {
    await setString(AppConstants.keyLastBackup, date.toIso8601String());
  }

  Future<DateTime?> getLastBackupDate() async {
    final dateString = await getString(AppConstants.keyLastBackup);
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Configurações de notificação
  Future<void> setNotificationsEnabled(bool enabled) async {
    await setBool('notifications_enabled', enabled);
  }

  Future<bool> areNotificationsEnabled() async {
    return await getBool('notifications_enabled') ?? true;
  }

  /// Meta de leitura anual
  Future<void> setYearlyReadingGoal(int goal) async {
    await setInt('yearly_reading_goal', goal);
  }

  Future<int> getYearlyReadingGoal() async {
    return await getInt('yearly_reading_goal') ?? 12; // 12 livros por ano por padrão
  }

  /// Configurações de exibição
  Future<void> setGridViewEnabled(bool enabled) async {
    await setBool('grid_view_enabled', enabled);
  }

  Future<bool> isGridViewEnabled() async {
    return await getBool('grid_view_enabled') ?? false;
  }

  /// Ordenação padrão
  Future<void> setDefaultSortOption(String sortOption) async {
    await setString('default_sort_option', sortOption);
  }

  Future<String> getDefaultSortOption() async {
    return await getString('default_sort_option') ?? 'title_asc';
  }

  /// Filtro padrão
  Future<void> setDefaultFilterStatus(String status) async {
    await setString('default_filter_status', status);
  }

  Future<String> getDefaultFilterStatus() async {
    return await getString('default_filter_status') ?? 'all';
  }

  /// Configurações de privacidade
  Future<void> setAnalyticsEnabled(bool enabled) async {
    await setBool('analytics_enabled', enabled);
  }

  Future<bool> isAnalyticsEnabled() async {
    return await getBool('analytics_enabled') ?? true;
  }

  Future<void> setCrashReportingEnabled(bool enabled) async {
    await setBool('crash_reporting_enabled', enabled);
  }

  Future<bool> isCrashReportingEnabled() async {
    return await getBool('crash_reporting_enabled') ?? true;
  }

  /// Configurações de backup automático
  Future<void> setAutoBackupEnabled(bool enabled) async {
    await setBool('auto_backup_enabled', enabled);
  }

  Future<bool> isAutoBackupEnabled() async {
    return await getBool('auto_backup_enabled') ?? false;
  }

  Future<void> setAutoBackupFrequency(int days) async {
    await setInt('auto_backup_frequency', days);
  }

  Future<int> getAutoBackupFrequency() async {
    return await getInt('auto_backup_frequency') ?? 7; // 7 dias por padrão
  }

  /// Configurações de tutorial
  Future<void> setTutorialCompleted(String tutorialKey) async {
    await setBool('tutorial_${tutorialKey}_completed', true);
  }

  Future<bool> isTutorialCompleted(String tutorialKey) async {
    return await getBool('tutorial_${tutorialKey}_completed') ?? false;
  }

  /// Estatísticas de uso
  Future<void> setAppOpenCount(int count) async {
    await setInt('app_open_count', count);
  }

  Future<int> getAppOpenCount() async {
    return await getInt('app_open_count') ?? 0;
  }

  Future<void> incrementAppOpenCount() async {
    final currentCount = await getAppOpenCount();
    await setAppOpenCount(currentCount + 1);
  }

  Future<void> setLastAppOpenDate(DateTime date) async {
    await setString('last_app_open_date', date.toIso8601String());
  }

  Future<DateTime?> getLastAppOpenDate() async {
    final dateString = await getString('last_app_open_date');
    if (dateString != null) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Limpar configurações específicas (manter configurações importantes)
  Future<void> resetUserPreferences() async {
    final keysToKeep = {
      AppConstants.keyFirstLaunch,
      'analytics_enabled',
      'crash_reporting_enabled',
    };

    final allKeys = await getKeys();
    for (final key in allKeys) {
      if (!keysToKeep.contains(key)) {
        await remove(key);
      }
    }
  }

  /// Obter resumo das configurações
  Future<Map<String, dynamic>> getSettingsSummary() async {
    return {
      'themeMode': await getThemeMode(),
      'notificationsEnabled': await areNotificationsEnabled(),
      'yearlyReadingGoal': await getYearlyReadingGoal(),
      'gridViewEnabled': await isGridViewEnabled(),
      'defaultSortOption': await getDefaultSortOption(),
      'defaultFilterStatus': await getDefaultFilterStatus(),
      'autoBackupEnabled': await isAutoBackupEnabled(),
      'autoBackupFrequency': await getAutoBackupFrequency(),
      'lastBackupDate': (await getLastBackupDate())?.toIso8601String(),
      'appOpenCount': await getAppOpenCount(),
      'lastAppOpenDate': (await getLastAppOpenDate())?.toIso8601String(),
    };
  }
}
