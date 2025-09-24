// 📚 FolhaVirada - Books by Author Screen
// Tela para mostrar livros filtrados por autor

import 'package:flutter/material.dart';
import 'package:folhavirada/core/constants/app_colors.dart';
import 'package:folhavirada/config/routes.dart';

class BooksByAuthorScreen extends StatefulWidget {
  final String author;

  const BooksByAuthorScreen({
    super.key,
    required this.author,
  });

  @override
  State<BooksByAuthorScreen> createState() => _BooksByAuthorScreenState();
}

class _BooksByAuthorScreenState extends State<BooksByAuthorScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _books = [];
  Map<String, dynamic>? _authorInfo;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    // TODO: Carregar livros reais por autor
    await Future.delayed(const Duration(seconds: 1));

    // Dados mockados baseados no autor
    List<Map<String, dynamic>> mockBooks = [];
    Map<String, dynamic> mockAuthorInfo = {};

    switch (widget.author.toLowerCase()) {
      case 'machado de assis':
        mockAuthorInfo = {
          'name': 'Machado de Assis',
          'birthYear': 1839,
          'deathYear': 1908,
          'nationality': 'Brasileiro',
          'description': 'Joaquim Maria Machado de Assis foi um escritor brasileiro, considerado o maior nome do realismo brasileiro.',
        };
        mockBooks = [
          {
            'id': '1',
            'title': 'Dom Casmurro',
            'year': 1899,
            'status': 'reading',
            'rating': null,
            'progress': 0.65,
            'genre': 'Romance',
          },
          {
            'id': '2',
            'title': 'O Cortiço',
            'year': 1890,
            'status': 'want_to_read',
            'rating': null,
            'progress': 0.0,
            'genre': 'Romance',
          },
          {
            'id': '3',
            'title': 'Memórias Póstumas de Brás Cubas',
            'year': 1881,
            'status': 'read',
            'rating': 4.5,
            'progress': 1.0,
            'genre': 'Romance',
          },
        ];
        break;
      case 'j.r.r. tolkien':
        mockAuthorInfo = {
          'name': 'J.R.R. Tolkien',
          'birthYear': 1892,
          'deathYear': 1973,
          'nationality': 'Britânico',
          'description': 'John Ronald Reuel Tolkien foi um escritor, professor e filólogo britânico, conhecido mundialmente por ser o autor das obras clássicas da alta fantasia.',
        };
        mockBooks = [
          {
            'id': '4',
            'title': 'O Senhor dos Anéis',
            'year': 1954,
            'status': 'read',
            'rating': 5.0,
            'progress': 1.0,
            'genre': 'Fantasia',
          },
          {
            'id': '5',
            'title': 'O Hobbit',
            'year': 1937,
            'status': 'read',
            'rating': 4.8,
            'progress': 1.0,
            'genre': 'Fantasia',
          },
        ];
        break;
      default:
        mockAuthorInfo = {
          'name': widget.author,
          'description': 'Informações sobre o autor não disponíveis.',
        };
        mockBooks = [];
    }

    setState(() {
      _books = mockBooks;
      _authorInfo = mockAuthorInfo;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.author),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goToAddBook(),
        child: const Icon(Icons.add),
        tooltip: 'Adicionar livro',
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Informações do autor
          if (_authorInfo != null) _buildAuthorInfo(),

          // Lista de livros
          _buildBooksList(),
        ],
      ),
    );
  }

  Widget _buildAuthorInfo() {
    final info = _authorInfo!;
    final name = info['name'] ?? widget.author;
    final birthYear = info['birthYear'];
    final deathYear = info['deathYear'];
    final nationality = info['nationality'];
    final description = info['description'];

    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      name.split(' ').map((n) => n[0]).take(2).join(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (birthYear != null || nationality != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            [
                              if (birthYear != null)
                                '${birthYear}${deathYear != null ? ' - $deathYear' : ''}',
                              if (nationality != null) nationality,
                            ].join(' • '),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (description != null) ...[
                const SizedBox(height: 16),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.menu_book,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${_books.length} ${_books.length == 1 ? 'livro' : 'livros'} na sua biblioteca',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
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

  Widget _buildBooksList() {
    if (_books.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.person_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Nenhum livro de ${widget.author}',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Adicione livros deste autor à sua biblioteca',
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
      );
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Livros na sua biblioteca',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _books.length,
            itemBuilder: (context, index) {
              final book = _books[index];
              return _buildBookCard(book);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    final title = book['title'] ?? 'Título desconhecido';
    final year = book['year'];
    final status = book['status'] ?? 'unknown';
    final rating = book['rating'];
    final progress = book['progress'] ?? 0.0;
    final genre = book['genre'];

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
      margin: const EdgeInsets.only(bottom: 12),
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
                    Row(
                      children: [
                        if (year != null) ...[
                          Text(
                            year.toString(),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                          if (genre != null) ...[
                            Text(
                              ' • ',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ],
                        if (genre != null)
                          Text(
                            genre,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[600],
                                ),
                          ),
                      ],
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
