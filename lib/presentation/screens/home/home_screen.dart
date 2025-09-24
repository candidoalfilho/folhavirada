// 📚 FolhaVirada - Home Screen
// Tela principal do aplicativo

import 'package:flutter/material.dart';
import 'package:folhavirada/core/constants/app_strings.dart';
import 'package:folhavirada/config/routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    const _BooksTab(),
    const _StatsTab(),
    const _SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: AppStrings.books,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: AppStrings.stats,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: AppStrings.settings,
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1 // Mostrar apenas na aba de livros
          ? FloatingActionButton(
              onPressed: () => context.goToAddBook(),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

// Tab Início
class _HomeTab extends StatelessWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.goToSearchBooks(),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WelcomeCard(),
            SizedBox(height: 24),
            _CurrentlyReadingSection(),
            SizedBox(height: 24),
            _RecentBooksSection(),
            SizedBox(height: 24),
            _QuickStatsSection(),
          ],
        ),
      ),
    );
  }
}

// Tab Livros
class _BooksTab extends StatelessWidget {
  const _BooksTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.books),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.goToSearchBooks(),
          ),
          IconButton(
            icon: const Icon(Icons.cloud_download),
            onPressed: () => context.goToSearchOnline(),
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              AppStrings.noBooks,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              AppStrings.emptyLibraryMessage,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tab Estatísticas
class _StatsTab extends StatelessWidget {
  const _StatsTab();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.stats),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.analytics,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              AppStrings.emptyStats,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              AppStrings.emptyStatsMessage,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tab Configurações
class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

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
                onTap: () {
                  // TODO: Implementar seletor de tema
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
            ],
          ),
        ],
      ),
    );
  }
}

// Componentes auxiliares

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.auto_stories,
                  size: 32,
                  color: Colors.blue,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem-vindo ao ${AppStrings.appName}!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Organize sua biblioteca pessoal',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.goToAddBook(),
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Primeiro Livro'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentlyReadingSection extends StatelessWidget {
  const _CurrentlyReadingSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.currentlyReading,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(
                  Icons.menu_book,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Nenhum livro sendo lido no momento',
                    style: Theme.of(context).textTheme.bodyMedium,
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

class _RecentBooksSection extends StatelessWidget {
  const _RecentBooksSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Adicionados Recentemente',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                // TODO: Navegar para todos os livros
              },
              child: const Text('Ver Todos'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 0, // Temporário
            itemBuilder: (context, index) {
              return const SizedBox(); // Placeholder
            },
          ),
        ),
        if (true) // Se não há livros
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.book,
                      size: 48,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nenhum livro adicionado ainda',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _QuickStatsSection extends StatelessWidget {
  const _QuickStatsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Estatísticas Rápidas',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => context.goToStats(),
              child: const Text('Ver Mais'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                icon: Icons.library_books,
                title: AppStrings.totalBooks,
                value: '0',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _StatCard(
                icon: Icons.check_circle,
                title: AppStrings.booksRead,
                value: '0',
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
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
