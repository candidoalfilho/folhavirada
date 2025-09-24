// 📚 FolhaVirada - About Screen
// Tela com informações sobre o aplicativo

import 'package:flutter/material.dart';
import 'package:folhavirada/core/constants/app_constants.dart';
import 'package:folhavirada/core/constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo e nome do app
            _buildAppHeader(context),
            const SizedBox(height: 32),

            // Informações principais
            _buildMainInfo(context),
            const SizedBox(height: 24),

            // Recursos
            _buildFeatures(context),
            const SizedBox(height: 24),

            // Informações técnicas
            _buildTechnicalInfo(context),
            const SizedBox(height: 24),

            // Desenvolvedor
            _buildDeveloperInfo(context),
            const SizedBox(height: 24),

            // Licença e privacidade
            _buildLegalInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.menu_book,
            size: 50,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppConstants.appName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Seu companheiro de leitura digital',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMainInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Sobre o App',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'O FolhaVirada é um aplicativo simples e elegante para organizar '
              'sua biblioteca pessoal. Mantenha registro dos livros que você '
              'leu, está lendo ou pretende ler, com anotações personalizadas '
              'e estatísticas de leitura.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(context, 'Versão', AppConstants.appVersion),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Plataforma', 'Flutter'),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Tipo', 'Gratuito'),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatures(BuildContext context) {
    final features = [
      {
        'icon': Icons.library_books,
        'title': 'Biblioteca Pessoal',
        'description': 'Organize seus livros por status: quero ler, lendo, lido',
      },
      {
        'icon': Icons.note_add,
        'title': 'Anotações',
        'description': 'Faça notas e reflexões sobre suas leituras',
      },
      {
        'icon': Icons.bar_chart,
        'title': 'Estatísticas',
        'description': 'Acompanhe seu progresso e metas de leitura',
      },
      {
        'icon': Icons.star,
        'title': 'Avaliações',
        'description': 'Avalie seus livros e acompanhe suas preferências',
      },
      {
        'icon': Icons.offline_bolt,
        'title': 'Offline',
        'description': 'Funciona completamente offline, seus dados ficam no dispositivo',
      },
      {
        'icon': Icons.dark_mode,
        'title': 'Tema Escuro',
        'description': 'Interface adaptável com modo claro e escuro',
      },
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.featured_play_list,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recursos',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map((feature) => _buildFeatureItem(
                  context,
                  feature['icon'] as IconData,
                  feature['title'] as String,
                  feature['description'] as String,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.code,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Informações Técnicas',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(context, 'Framework', 'Flutter 3.24+'),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Linguagem', 'Dart 3.5+'),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Arquitetura', 'Clean Architecture + BLoC'),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Banco de Dados', 'SQLite (sqflite)'),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Design System', 'Material Design 3'),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Padrões', 'Atomic Design + Repository Pattern'),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Desenvolvedor',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Desenvolvido com ❤️',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Para todos os amantes da leitura',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.gavel,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Legal e Privacidade',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '• Todos os seus dados ficam armazenados localmente no seu dispositivo\n'
              '• Não coletamos informações pessoais\n'
              '• Não compartilhamos dados com terceiros\n'
              '• O app funciona completamente offline\n'
              '• Código fonte disponível sob licença MIT',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: Abrir política de privacidade
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Política de Privacidade em breve'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.privacy_tip),
                  label: const Text('Privacidade'),
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Abrir termos de uso
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Termos de Uso em breve'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.description),
                  label: const Text('Termos'),
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Abrir repositório no GitHub
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Código fonte em breve'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.code),
                  label: const Text('Código'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }
}