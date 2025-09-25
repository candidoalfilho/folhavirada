// 📚 FolhaVirada - Stats Screen
// Tela de estatísticas de leitura

import 'package:flutter/material.dart';
import 'package:folhavirada/core/constants/app_strings.dart';
import 'package:folhavirada/core/constants/app_colors.dart';
import 'package:folhavirada/core/utils/validators.dart';
import 'package:folhavirada/core/services/app_state_service.dart';
import 'package:folhavirada/core/di/injection.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> with AutomaticKeepAliveClientMixin {
  final _goalController = TextEditingController();
  late AppStateService _appState;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _appState = getIt<AppStateService>();
    _goalController.text = _appState.readingGoal.toString();
    _appState.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChanged);
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.statistics),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditGoalDialog(),
            tooltip: 'Editar meta',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Meta anual
          _buildYearlyGoalCard(),
          const SizedBox(height: 16),

          // Cards de estatísticas básicas
          _buildBasicStatsGrid(),
          const SizedBox(height: 24),

          // Empty state para dados futuros
          _buildEmptyDataState(),
        ],
      ),
    );
  }

  Widget _buildYearlyGoalCard() {
    final currentYear = DateTime.now().year;
    final stats = _appState.stats;
    final readingGoal = _appState.readingGoal;
    final booksThisYear = stats['booksThisYear'] ?? 0;
    final progress = readingGoal > 0 ? booksThisYear / readingGoal : 0.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meta de $currentYear',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: () => _showEditGoalDialog(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$booksThisYear / $readingGoal livros',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress >= 1.0 ? Colors.green : AppColors.primary,
                        ),
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${(progress * 100).round()}% da meta atingida',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    progress >= 1.0 ? Icons.emoji_events : Icons.flag,
                    color: progress >= 1.0 ? Colors.amber : AppColors.primary,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicStatsGrid() {
    final appStats = _appState.stats;
    final stats = [
      {
        'title': 'Total de Livros',
        'value': '${appStats['totalBooks'] ?? 0}',
        'subtitle': 'na biblioteca',
        'icon': Icons.library_books,
        'color': Colors.blue,
      },
      {
        'title': 'Páginas Lidas',
        'value': '${appStats['totalPages'] ?? 0}',
        'subtitle': 'no total',
        'icon': Icons.auto_stories,
        'color': Colors.green,
      },
      {
        'title': 'Livros Lidos',
        'value': '${appStats['readBooks'] ?? 0}',
        'subtitle': 'concluídos',
        'icon': Icons.check_circle,
        'color': Colors.orange,
      },
      {
        'title': 'Lendo Agora',
        'value': '${appStats['readingBooks'] ?? 0}',
        'subtitle': 'em progresso',
        'icon': Icons.menu_book,
        'color': Colors.amber,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (stat['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    stat['icon'] as IconData,
                    color: stat['color'] as Color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  stat['value'] as String,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  stat['title'] as String,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  stat['subtitle'] as String,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyDataState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Dados Insuficientes',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione livros à sua biblioteca para ver estatísticas detalhadas, gráficos e análises do seu progresso de leitura.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Navegar para adicionar livro
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Adicione livros para ver estatísticas!'),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Livros'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Meta Anual'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Quantos livros você pretende ler em ${DateTime.now().year}?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _goalController,
              decoration: const InputDecoration(
                labelText: 'Meta de livros',
                border: OutlineInputBorder(),
                suffixText: 'livros',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite uma meta';
                }
                final goal = int.tryParse(value);
                if (goal == null || goal <= 0) {
                  return 'Meta deve ser um número positivo';
                }
                if (goal > 1000) {
                  return 'Meta muito alta (máximo 1000)';
                }
                return null;
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newGoal = int.tryParse(_goalController.text);
              if (newGoal != null && newGoal > 0 && newGoal <= 1000) {
                await _appState.updateReadingGoal(newGoal);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Meta atualizada com sucesso!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Meta inválida'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}