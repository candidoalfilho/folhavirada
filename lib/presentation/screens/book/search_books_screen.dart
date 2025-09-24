// 📚 FolhaVirada - Search Books Screen
// Tela para buscar livros na biblioteca local

import 'package:flutter/material.dart';
import 'package:folhavirada/core/constants/app_colors.dart';
import 'package:folhavirada/core/constants/book_constants.dart';
import 'package:folhavirada/config/routes.dart';

class SearchBooksScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchBooksScreen({
    super.key,
    this.initialQuery,
  });

  @override
  State<SearchBooksScreen> createState() => _SearchBooksScreenState();
}

class _SearchBooksScreenState extends State<SearchBooksScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  
  bool _isLoading = false;
  List<Map<String, dynamic>> _searchResults = [];
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _performSearch();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Livros'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Digite título, autor ou gênero...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {});
                if (value.isNotEmpty) {
                  _performSearch();
                }
              },
              onSubmitted: (_) => _performSearch(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filtros
          _buildFilters(),
          
          // Resultados
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Todos', 'all'),
            const SizedBox(width: 8),
            _buildFilterChip('Quero Ler', BookStatus.wantToRead.value),
            const SizedBox(width: 8),
            _buildFilterChip('Lendo', BookStatus.reading.value),
            const SizedBox(width: 8),
            _buildFilterChip('Lidos', BookStatus.read.value),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? value : 'all';
        });
        _performSearch();
      },
      selectedColor: AppColors.primary.withOpacity(0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  Widget _buildSearchResults() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Buscando livros...'),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum livro encontrado',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Tente buscar com outros termos',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.goToAddBook(),
              icon: const Icon(Icons.add),
              label: const Text('Adicionar Novo Livro'),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Digite para buscar',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Encontre livros por título, autor ou gênero',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final book = _searchResults[index];
        return _buildBookCard(book);
      },
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    final title = book['title'] ?? 'Título desconhecido';
    final author = book['author'] ?? 'Autor desconhecido';
    final status = book['status'] ?? 'unknown';
    final progress = book['progress'] ?? 0.0;
    final rating = book['rating'];

    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.book;
    
    switch (status) {
      case 'want_to_read':
        statusColor = Colors.blue;
        statusIcon = Icons.bookmark_border;
        break;
      case 'reading':
        statusColor = Colors.orange;
        statusIcon = Icons.menu_book;
        break;
      case 'read':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
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
              // Ícone de status
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 24,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    
                    // Status e progresso
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
                          child: Text(
                            _getStatusLabel(status),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
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
              
              // Ações
              PopupMenuButton<String>(
                onSelected: (action) => _handleBookAction(action, book),
                itemBuilder: (context) => [
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

  String _getStatusLabel(String status) {
    switch (status) {
      case 'want_to_read':
        return 'Quero Ler';
      case 'reading':
        return 'Lendo';
      case 'read':
        return 'Lido';
      default:
        return 'Desconhecido';
    }
  }

  void _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implementar busca real
      await Future.delayed(const Duration(milliseconds: 500));

      // Dados mockados para demonstração
      final mockResults = <Map<String, dynamic>>[];

      if (query.toLowerCase().contains('dom')) {
        mockResults.add({
          'id': '1',
          'title': 'Dom Casmurro',
          'author': 'Machado de Assis',
          'status': 'reading',
          'progress': 0.65,
        });
      }

      if (query.toLowerCase().contains('senhor')) {
        mockResults.add({
          'id': '2',
          'title': 'O Senhor dos Anéis',
          'author': 'J.R.R. Tolkien',
          'status': 'read',
          'rating': 5.0,
        });
      }

      setState(() {
        _searchResults = mockResults;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
    }
  }

  void _handleBookAction(String action, Map<String, dynamic> book) {
    switch (action) {
      case 'edit':
        context.goToEditBook(book['id']);
        break;
      case 'notes':
        // TODO: Navegar para notas
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
              // TODO: Implementar exclusão real
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Livro excluído com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
              _performSearch(); // Atualizar resultados
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
