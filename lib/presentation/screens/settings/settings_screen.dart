// 📚 FolhaVirada - Settings Screen
// Tela de configurações do aplicativo

import 'package:flutter/material.dart';
import 'package:folhavirada/core/constants/app_strings.dart';
import 'package:folhavirada/config/routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsSection(
            title: 'Aparência',
            children: [
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text(AppStrings.theme),
                subtitle: const Text(AppStrings.systemTheme),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showThemeDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text(AppStrings.language),
                subtitle: const Text('Português'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguageDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Leitura',
            children: [
              ListTile(
                leading: const Icon(Icons.flag),
                title: const Text(AppStrings.readingGoal),
                subtitle: const Text('12 livros por ano'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showGoalDialog(context),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.notifications),
                title: const Text(AppStrings.notifications),
                subtitle: const Text('Lembrete de leitura diária'),
                value: true, // TODO: Valor real
                onChanged: (value) {
                  // TODO: Implementar toggle
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.grid_view),
                title: const Text('Visualização em Grade'),
                subtitle: const Text('Exibir livros em grade'),
                value: false, // TODO: Valor real
                onChanged: (value) {
                  // TODO: Implementar toggle
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Dados',
            children: [
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text(AppStrings.backup),
                subtitle: const Text('Fazer backup dos seus dados'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.goToExport(),
              ),
              ListTile(
                leading: const Icon(Icons.restore),
                title: const Text(AppStrings.restore),
                subtitle: const Text('Restaurar dados de um backup'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.goToImport(),
              ),
              ListTile(
                leading: const Icon(Icons.sync),
                title: const Text('Sincronização'),
                subtitle: const Text('Último backup: Nunca'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Implementar sincronização
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Privacidade',
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.analytics),
                title: const Text('Análise de Uso'),
                subtitle: const Text('Ajudar a melhorar o aplicativo'),
                value: true, // TODO: Valor real
                onChanged: (value) {
                  // TODO: Implementar toggle
                },
              ),
              SwitchListTile(
                secondary: const Icon(Icons.bug_report),
                title: const Text('Relatórios de Erro'),
                subtitle: const Text('Enviar relatórios de crash'),
                value: true, // TODO: Valor real
                onChanged: (value) {
                  // TODO: Implementar toggle
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Avançado',
            children: [
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Armazenamento'),
                subtitle: const Text('Gerenciar dados locais'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showStorageDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Limpar Cache'),
                subtitle: const Text('Limpar dados temporários'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showClearCacheDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Redefinir Aplicativo'),
                subtitle: const Text('Apagar todos os dados'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showResetDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _SettingsSection(
            title: 'Sobre',
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text(AppStrings.about),
                subtitle: const Text('Informações do aplicativo'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.goToAbout(),
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Avaliar Aplicativo'),
                subtitle: const Text('Deixe sua avaliação na loja'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Abrir loja de apps
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Compartilhar'),
                subtitle: const Text('Compartilhe com seus amigos'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Implementar compartilhamento
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text(AppStrings.lightTheme),
              value: 'light',
              groupValue: 'system', // TODO: Valor real
              onChanged: (value) {
                Navigator.pop(context);
                // TODO: Implementar mudança de tema
              },
            ),
            RadioListTile<String>(
              title: const Text(AppStrings.darkTheme),
              value: 'dark',
              groupValue: 'system', // TODO: Valor real
              onChanged: (value) {
                Navigator.pop(context);
                // TODO: Implementar mudança de tema
              },
            ),
            RadioListTile<String>(
              title: const Text(AppStrings.systemTheme),
              value: 'system',
              groupValue: 'system', // TODO: Valor real
              onChanged: (value) {
                Navigator.pop(context);
                // TODO: Implementar mudança de tema
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Português'),
              value: 'pt',
              groupValue: 'pt', // TODO: Valor real
              onChanged: (value) {
                Navigator.pop(context);
                // TODO: Implementar mudança de idioma
              },
            ),
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: 'pt', // TODO: Valor real
              onChanged: (value) {
                Navigator.pop(context);
                // TODO: Implementar mudança de idioma
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showGoalDialog(BuildContext context) {
    final controller = TextEditingController(text: '12');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.readingGoal),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Quantos livros você quer ler este ano?'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Meta anual',
                suffixText: 'livros',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Salvar meta
            },
            child: const Text(AppStrings.save),
          ),
        ],
      ),
    );
  }

  void _showStorageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informações de Armazenamento'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Livros: 0'),
            Text('Notas: 0'),
            Text('Imagens: 0 MB'),
            Text('Cache: 0 MB'),
            SizedBox(height: 16),
            Text('Total usado: 0 MB'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.ok),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Cache'),
        content: const Text('Isso irá remover imagens em cache e dados temporários. Tem certeza?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar limpeza de cache
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache limpo com sucesso!')),
              );
            },
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Redefinir Aplicativo'),
        content: const Text(
          'ATENÇÃO: Esta ação irá apagar TODOS os seus dados, incluindo livros, notas e configurações. Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalResetConfirmation(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Redefinir'),
          ),
        ],
      ),
    );
  }

  void _showFinalResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação Final'),
        content: const Text('Digite "REDEFINIR" para confirmar:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implementar reset
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
