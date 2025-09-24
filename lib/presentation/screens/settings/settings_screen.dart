// 📚 FolhaVirada - Settings Screen
// Tela de configurações simplificada

import 'package:flutter/material.dart';
import 'package:folhavirada/core/constants/app_strings.dart';
import 'package:folhavirada/core/constants/app_colors.dart';
import 'package:folhavirada/config/routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Aparência
          _SettingsSection(
            title: 'Aparência',
            children: [
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Tema'),
                subtitle: const Text('Claro, escuro ou automático'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.goToTheme(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dados
          _SettingsSection(
            title: 'Dados',
            children: [
              ListTile(
                leading: const Icon(Icons.backup),
                title: const Text('Exportar Dados'),
                subtitle: const Text('Fazer backup dos seus livros'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showExportDialog(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever),
                title: const Text('Limpar Dados'),
                subtitle: const Text('Apagar todos os livros'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showClearDataDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Sobre
          _SettingsSection(
            title: 'Sobre',
            children: [
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('Sobre o App'),
                subtitle: const Text('Informações e créditos'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.goToAbout(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exportar Dados'),
        content: const Text(
          'Esta funcionalidade será implementada em breve. '
          'Permitirá exportar sua biblioteca para CSV ou PDF.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Todos os Dados'),
        content: const Text(
          'Tem certeza que deseja apagar todos os livros e notas? '
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implementar limpeza de dados
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade será implementada em breve'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Limpar'),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Card(
          margin: EdgeInsets.zero,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}