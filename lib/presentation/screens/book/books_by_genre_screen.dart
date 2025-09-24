// 📚 FolhaVirada - Books by Genre Screen
// Tela para mostrar livros filtrados por gênero

import 'package:flutter/material.dart';
import 'package:folhavirada/core/constants/app_colors.dart';
import 'package:folhavirada/config/routes.dart';

class BooksByGenreScreen extends StatefulWidget {
  final String genre;

  const BooksByGenreScreen({
    super.key,
    required this.genre,
  });

  @override
  State<BooksByGenreScreen> createState() => _BooksByGenreScreenState();
}

class _BooksByGenreScreenState extends State<BooksByGenreScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    // TODO: Carregar livros reais por gênero
    await Future.delayed(const Duration(seconds: 1));

    // Dados mockados baseados no gênero
    List<Map<String, dynamic>> mockBooks = [];

    switch (widget.genre.toLowerCase()) {
      case 'ficção':
        mockBooks = [
          {
            'id': '1',
            'title': 'Dom Casmurro',
            'author': 'Machado de Assis',
            'status': 'reading',
            'rating': null,
            'progress': 0.65,
          },
          {
            'id': '2',
            'title': '1984',
            'author': 'George Orwell',
            'status': 'want_to_read',
            'rating': null,
            'progress': 0.0,
          },
        ];
        break;
      case 'fantasia':
        mockBooks = [
          {
            'id': '3',
            'title': 'O Senhor dos Anéis',
            'author': 'J.R.R. Tolkien',
            'status': 'read',
            'rating': 5.0,
            'progress': 1.0,
          },
          {
            'id': '4',
            'title': 'Harry Potter e a Pedra Filosofal',
            'author': 'J.K. Rowling',
            'status': 'read',
            'rating': 4.5,
            'progress': 1.0,
          },
        ];
        break;
      default:
        mockBooks = [];
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
        title: Text('Gênero: ${widget.genre}'),
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
              Icons.category_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum livro de ${widget.genre}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Adicione livros deste gênero à sua biblioteca',
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
                Icons.category,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                '${_books.length} ${_books.length == 1 ? 'livro' : 'livros'} de ${widget.genre}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
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
    final status = book['status'] ?? 'unknown';
    final rating = book['rating'];
    final progress = book['progress'] ?? 0.0;

    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.book;
    String statusLabel = 'Desconhecido';
    
    switch (status) {
      case 'want_to_read':
        statusColor = Colors.blue;
        statusIcon = Icons.bookmark_border;
        statusLabel = 'Quero Ler';
        break;
      case 'reading':
        statusColor = Colors.orange;
        statusIcon = Icons.menu_book;
        statusLabel = 'Lendo';
        break;
      case 'read':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusLabel = 'Lido';
        break;
    }

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
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.book,
                  color: statusColor,
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

                    // Status e informações extras
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                size: 12,
                                color: statusColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                statusLabel,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        if (status == 'reading' && progress > 0) ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${(progress * 100).round()}%',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.grey[300],
                                  color: statusColor,
                                  minHeight: 4,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        if (status == 'read' && rating != null) ...[
                          const SizedBox(width: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rating.toString(),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
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

  void _handleBookAction(String action, Map<String, dynamic> book) {
    switch (action) {
      case 'view':
        context.goToBookDetail(book['id']);
        break;
      case 'edit':
        context.goToEditBook(book['id']);
        break;
      case 'notes':
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
