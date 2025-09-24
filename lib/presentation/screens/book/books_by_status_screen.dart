// 📚 FolhaVirada - Books by Status Screen
// Tela para mostrar livros filtrados por status

import 'package:flutter/material.dart';
import 'package:folhavirada/core/constants/app_colors.dart';
import 'package:folhavirada/core/constants/book_constants.dart';
import 'package:folhavirada/config/routes.dart';

class BooksByStatusScreen extends StatefulWidget {
  final String status;

  const BooksByStatusScreen({
    super.key,
    required this.status,
  });

  @override
  State<BooksByStatusScreen> createState() => _BooksByStatusScreenState();
}

class _BooksByStatusScreenState extends State<BooksByStatusScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _books = [];
  String _sortBy = 'title'; // title, author, date_added, date_read

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    // TODO: Carregar livros reais por status
    await Future.delayed(const Duration(seconds: 1));

    // Dados mockados baseados no status
    List<Map<String, dynamic>> mockBooks = [];

    switch (widget.status) {
      case 'Quero Ler':
        mockBooks = [
          {
            'id': '1',
            'title': '1984',
            'author': 'George Orwell',
            'cover': null,
            'dateAdded': DateTime.now().subtract(const Duration(days: 10)),
          },
          {
            'id': '2',
            'title': 'O Pequeno Príncipe',
            'author': 'Antoine de Saint-Exupéry',
            'cover': null,
            'dateAdded': DateTime.now().subtract(const Duration(days: 5)),
          },
        ];
        break;
      case 'Lendo Agora':
        mockBooks = [
          {
            'id': '3',
            'title': 'Dom Casmurro',
            'author': 'Machado de Assis',
            'cover': null,
            'progress': 0.65,
            'currentPage': 150,
            'totalPages': 230,
            'dateStarted': DateTime.now().subtract(const Duration(days: 15)),
          },
        ];
        break;
      case 'Lido':
        mockBooks = [
          {
            'id': '4',
            'title': 'O Senhor dos Anéis',
            'author': 'J.R.R. Tolkien',
            'cover': null,
            'rating': 5.0,
            'dateRead': DateTime.now().subtract(const Duration(days: 30)),
          },
          {
            'id': '5',
            'title': 'Harry Potter e a Pedra Filosofal',
            'author': 'J.K. Rowling',
            'cover': null,
            'rating': 4.5,
            'dateRead': DateTime.now().subtract(const Duration(days: 60)),
          },
        ];
        break;
    }

    setState(() {
      _books = mockBooks;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.status),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
              _sortBooks();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'title',
                child: Row(
                  children: [
                    Icon(Icons.sort_by_alpha),
                    SizedBox(width: 8),
                    Text('Por Título'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'author',
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 8),
                    Text('Por Autor'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'date_added',
                child: Row(
                  children: [
                    Icon(Icons.calendar_today),
                    SizedBox(width: 8),
                    Text('Data de Adição'),
                  ],
                ),
              ),
              if (widget.status == 'Lido')
                const PopupMenuItem(
                  value: 'date_read',
                  child: Row(
                    children: [
                      Icon(Icons.event_available),
                      SizedBox(width: 8),
                      Text('Data de Leitura'),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildBooksContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goToAddBook(),
        child: const Icon(Icons.add),
        tooltip: 'Adicionar livro',
      ),
    );
  }

  Widget _buildBooksContent() {
    if (_books.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getStatusIcon(),
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum livro ${widget.status.toLowerCase()}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptyMessage(),
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
      );
    }

    return Column(
      children: [
        // Header com contagem
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surface,
          child: Row(
            children: [
              Icon(
                _getStatusIcon(),
                color: _getStatusColor(),
              ),
              const SizedBox(width: 8),
              Text(
                '${_books.length} ${_books.length == 1 ? 'livro' : 'livros'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                'Ordenado por ${_getSortLabel()}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),

        // Lista de livros
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _books.length,
            itemBuilder: (context, index) {
              final book = _books[index];
              return _buildBookCard(book);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    final title = book['title'] ?? 'Título desconhecido';
    final author = book['author'] ?? 'Autor desconhecido';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.goToBookDetail(book['id'] ?? ''),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Capa ou ícone
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.book,
                  color: _getStatusColor(),
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),

              // Informações do livro
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      author,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),

                    // Informações específicas do status
                    _buildStatusSpecificInfo(book),
                  ],
                ),
              ),

              // Menu de ações
              PopupMenuButton<String>(
                onSelected: (action) => _handleBookAction(action, book),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility),
                        SizedBox(width: 8),
                        Text('Ver Detalhes'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'notes',
                    child: Row(
                      children: [
                        Icon(Icons.note),
                        SizedBox(width: 8),
                        Text('Notas'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Excluir', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSpecificInfo(Map<String, dynamic> book) {
    switch (widget.status) {
      case 'Lendo Agora':
        final progress = book['progress'] ?? 0.0;
        final currentPage = book['currentPage'];
        final totalPages = book['totalPages'];
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentPage != null && totalPages != null)
              Text(
                'Página $currentPage de $totalPages',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: _getStatusColor(),
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
            const SizedBox(height: 4),
            Text(
              '${(progress * 100).round()}% concluído',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        );

      case 'Lido':
        final rating = book['rating'];
        final dateRead = book['dateRead'] as DateTime?;
        
        return Row(
          children: [
            if (rating != null) ...[
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 16,
              ),
              Text(
                rating.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(width: 16),
            ],
            if (dateRead != null) ...[
              Icon(
                Icons.event_available,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'Lido em ${dateRead.day}/${dateRead.month}/${dateRead.year}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        );

      default:
        final dateAdded = book['dateAdded'] as DateTime?;
        if (dateAdded != null) {
          return Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'Adicionado em ${dateAdded.day}/${dateAdded.month}/${dateAdded.year}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        }
        return const SizedBox();
    }
  }

  IconData _getStatusIcon() {
    switch (widget.status) {
      case 'Quero Ler':
        return Icons.bookmark_border;
      case 'Lendo Agora':
        return Icons.menu_book;
      case 'Lido':
        return Icons.check_circle;
      default:
        return Icons.book;
    }
  }

  Color _getStatusColor() {
    switch (widget.status) {
      case 'Quero Ler':
        return Colors.blue;
      case 'Lendo Agora':
        return Colors.orange;
      case 'Lido':
        return Colors.green;
      default:
        return AppColors.primary;
    }
  }

  String _getEmptyMessage() {
    switch (widget.status) {
      case 'Quero Ler':
        return 'Adicione livros que você pretende ler';
      case 'Lendo Agora':
        return 'Comece a ler um novo livro';
      case 'Lido':
        return 'Marque livros como lidos após terminar';
      default:
        return 'Nenhum livro encontrado';
    }
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'title':
        return 'título';
      case 'author':
        return 'autor';
      case 'date_added':
        return 'data de adição';
      case 'date_read':
        return 'data de leitura';
      default:
        return 'título';
    }
  }

  void _sortBooks() {
    setState(() {
      _books.sort((a, b) {
        switch (_sortBy) {
          case 'title':
            return a['title'].compareTo(b['title']);
          case 'author':
            return a['author'].compareTo(b['author']);
          case 'date_added':
            final dateA = a['dateAdded'] as DateTime?;
            final dateB = b['dateAdded'] as DateTime?;
            if (dateA == null && dateB == null) return 0;
            if (dateA == null) return 1;
            if (dateB == null) return -1;
            return dateB.compareTo(dateA); // Mais recente primeiro
          case 'date_read':
            final dateA = a['dateRead'] as DateTime?;
            final dateB = b['dateRead'] as DateTime?;
            if (dateA == null && dateB == null) return 0;
            if (dateA == null) return 1;
            if (dateB == null) return -1;
            return dateB.compareTo(dateA); // Mais recente primeiro
          default:
            return 0;
        }
      });
    });
  }

  void _handleBookAction(String action, Map<String, dynamic> book) {
    switch (action) {
      case 'view':
        context.goToBookDetail(book['id']);
        break;
      case 'edit':
        context.goToEditBook(book['id']);
        break;
      case 'notes':
        // TODO: Implementar navegação para notas
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Funcionalidade de notas em desenvolvimento'),
          ),
        );
        break;
      case 'delete':
        _showDeleteDialog(book);
        break;
    }
  }

  void _showDeleteDialog(Map<String, dynamic> book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Livro'),
        content: Text(
          'Tem certeza que deseja excluir "${book['title']}"? '
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _books.removeWhere((b) => b['id'] == book['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Livro excluído com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
