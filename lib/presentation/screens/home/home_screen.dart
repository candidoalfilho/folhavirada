// 📚 FolhaVirada - Home Screen
// Tela inicial do aplicativo

import 'package:flutter/material.dart';
import 'package:folhavirada/core/constants/app_strings.dart';
import 'package:folhavirada/core/constants/app_colors.dart';
import 'package:folhavirada/config/routes.dart';
import 'package:folhavirada/core/constants/book_constants.dart';
import 'package:folhavirada/core/utils/app_utils.dart';
import 'package:folhavirada/presentation/screens/stats/stats_screen.dart';
import 'package:folhavirada/presentation/screens/settings/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeTab(),
          _buildBooksTab(),
          _buildStatsTab(),
          _buildSettingsTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Livros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Estatísticas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1 
          ? FloatingActionButton(
              onPressed: () => context.goToAddBook(),
              child: const Icon(Icons.add),
              tooltip: 'Adicionar livro',
            )
          : null,
    );
  }

  Widget _buildHomeTab() {
    return CustomScrollView(
      slivers: [
        
        
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Welcome message
              const SizedBox(height: 24),
              _buildWelcomeCard(),
              const SizedBox(height: 24),

              // Quick actions
              _buildQuickActionsSection(),
              const SizedBox(height: 24),

              // Empty state with call to action
              _buildEmptyLibraryCard(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.waving_hand,
                  color: Colors.amber,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Bem-vindo!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Organize sua biblioteca pessoal e acompanhe seus hábitos de leitura.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.goToAddBook(),
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Primeiro Livro'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações Rápidas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Adicionar Livro',
                'Cadastre um novo livro',
                Icons.add_circle_outline,
                Colors.green,
                () => context.goToAddBook(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                'Ver Estatísticas',
                'Acompanhe seu progresso',
                Icons.analytics_outlined,
                Colors.blue,
                () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyLibraryCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Sua biblioteca está vazia',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Comece adicionando seus livros favoritos para acompanhar sua jornada de leitura.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => context.goToAddBook(),
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Primeiro Livro'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBooksTab() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text('Meus Livros'),
          floating: true,
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // Filtros por status
              _buildStatusFilters(),
              const SizedBox(height: 16),
              
              // Empty state
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.library_books,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Nenhum livro encontrado',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Adicione seus primeiros livros para começar',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => context.goToAddBook(),
                        icon: const Icon(Icons.add),
                        label: const Text('Adicionar Livro'),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusFilters() {
    return Row(
      children: [
        Expanded(
          child: _buildFilterChip('Quero Ler', 0, BookStatus.wantToRead),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildFilterChip('Lendo', 0, BookStatus.reading),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildFilterChip('Lidos', 0, BookStatus.read),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, int count, BookStatus status) {
    return Card(
      child: InkWell(
        onTap: () {
          // TODO: Filtrar por status quando houver dados reais
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            children: [
              Text(
                count.toString(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsTab() {
    return const StatsScreen();
  }

  Widget _buildSettingsTab() {
    return const SettingsScreen();
  }
}