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

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          _HomeTab(),
          _BooksTab(),
          const StatsScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: AppStrings.myBooks,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: AppStrings.statistics,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppStrings.settings,
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () => context.goToAddBook(),
              child: const Icon(Icons.add),
              tooltip: AppStrings.addBook,
            )
          : null,
    );
  }
}

class _HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text(AppStrings.appTitle),
          floating: true,
          snap: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.goToSearchBooks(),
              tooltip: AppStrings.search,
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildWelcomeCard(context),
              const SizedBox(height: 24),
              _buildQuickStats(context),
              const SizedBox(height: 24),
              _buildQuickActions(context),
              const SizedBox(height: 24),
              _buildRecentBooks(context),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.menu_book,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.welcome,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'Organize sua biblioteca pessoal',
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

  Widget _buildQuickStats(BuildContext context) {
    // Dados mockados simples - sem processamento pesado
    final stats = [
      {'label': 'Total', 'value': '0', 'icon': Icons.library_books},
      {'label': 'Lendo', 'value': '0', 'icon': Icons.menu_book},
      {'label': 'Lidos', 'value': '0', 'icon': Icons.check_circle},
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    stat['icon'] as IconData,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stat['value'] as String,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    stat['label'] as String,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'title': 'Adicionar Livro',
        'subtitle': 'Novo livro à biblioteca',
        'icon': Icons.add_circle,
        'color': Colors.blue,
        'onTap': () => context.goToAddBook(),
      },
      {
        'title': 'Buscar Livros',
        'subtitle': 'Encontre na biblioteca',
        'icon': Icons.search,
        'color': Colors.green,
        'onTap': () => context.goToSearchBooks(),
      },
      {
        'title': 'Estatísticas',
        'subtitle': 'Progresso de leitura',
        'icon': Icons.bar_chart,
        'color': Colors.orange,
        'onTap': () => context.goToStats(),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ações Rápidas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...actions.map((action) {
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (action['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  action['icon'] as IconData,
                  color: action['color'] as Color,
                ),
              ),
              title: Text(action['title'] as String),
              subtitle: Text(action['subtitle'] as String),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: action['onTap'] as VoidCallback,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecentBooks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Atividade Recente',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navegar para lista completa
              },
              child: const Text('Ver tudo'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 120,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book_outlined,
                  size: 48,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 8),
                Text(
                  'Nenhum livro ainda',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Comece adicionando seu primeiro livro!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BooksTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: const Text(AppStrings.myBooks),
          floating: true,
          snap: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => context.goToSearchBooks(),
              tooltip: AppStrings.search,
            ),
            IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                // TODO: Mostrar filtros
              },
              tooltip: 'Filtros',
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildStatusCards(context),
              const SizedBox(height: 24),
              _buildEmptyState(context),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCards(BuildContext context) {
    final statusCards = [
      {
        'title': AppStrings.wantToRead,
        'count': 0,
        'color': Colors.blue,
        'icon': Icons.bookmark_border,
        'onTap': () => context.goToBooksByStatus(BookStatus.wantToRead.label),
      },
      {
        'title': AppStrings.readingNow,
        'count': 0,
        'color': Colors.orange,
        'icon': Icons.menu_book,
        'onTap': () => context.goToBooksByStatus(BookStatus.reading.label),
      },
      {
        'title': AppStrings.readBooks,
        'count': 0,
        'color': Colors.green,
        'icon': Icons.check_circle,
        'onTap': () => context.goToBooksByStatus(BookStatus.read.label),
      },
    ];

    return Column(
      children: statusCards.map((card) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: card['onTap'] as VoidCallback,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: (card['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      card['icon'] as IconData,
                      color: card['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card['title'] as String,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        Text(
                          '${card['count']} ${(card['count'] as int) == 1 ? 'livro' : 'livros'}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Sua biblioteca está vazia',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Comece adicionando livros que você quer ler, está lendo ou já leu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.goToAddBook(),
            icon: const Icon(Icons.add),
            label: const Text('Adicionar Primeiro Livro'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}