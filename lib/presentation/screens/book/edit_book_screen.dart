// 📚 FolhaVirada - Edit Book Screen
// Tela para editar livros existentes

import 'package:flutter/material.dart';
import 'package:folhavirada/core/constants/app_strings.dart';
import 'package:folhavirada/core/utils/validators.dart';
import 'package:folhavirada/core/constants/book_constants.dart';

class EditBookScreen extends StatefulWidget {
  final String bookId;

  const EditBookScreen({
    super.key,
    required this.bookId,
  });

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _publisherController = TextEditingController();
  final _yearController = TextEditingController();
  final _pagesController = TextEditingController();
  final _currentPageController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedStatus = BookStatus.wantToRead.value;
  String? _selectedGenre;
  double _rating = 0.0;
  bool _isLoading = false;
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    _loadBookData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _yearController.dispose();
    _pagesController.dispose();
    _currentPageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _loadBookData() async {
    // TODO: Carregar dados reais do livro
    // Simulando carregamento por enquanto
    await Future.delayed(const Duration(seconds: 1));
    
    // Dados mockados para demonstração
    _titleController.text = 'Dom Casmurro';
    _authorController.text = 'Machado de Assis';
    _publisherController.text = 'Editora Ática';
    _yearController.text = '1899';
    _pagesController.text = '256';
    _currentPageController.text = '150';
    _descriptionController.text = 'Romance clássico da literatura brasileira.';
    _selectedStatus = BookStatus.reading.value;
    _selectedGenre = BookGenre.fiction.value;
    _rating = 4.5;

    setState(() {
      _isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Livro'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Livro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(),
            tooltip: 'Excluir livro',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informações básicas
              _buildBasicInfo(),
              const SizedBox(height: 24),

              // Progresso de leitura
              if (_selectedStatus == BookStatus.reading.value) ...[
                _buildReadingProgress(),
                const SizedBox(height: 24),
              ],

              // Avaliação
              if (_selectedStatus == BookStatus.read.value) ...[
                _buildRating(),
                const SizedBox(height: 24),
              ],

              // Informações adicionais
              _buildAdditionalInfo(),
              const SizedBox(height: 24),

              // Descrição
              _buildDescription(),
              const SizedBox(height: 32),

              // Botões
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações Básicas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título *',
                border: OutlineInputBorder(),
              ),
              validator: Validators.validateTitle,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Autor *',
                border: OutlineInputBorder(),
              ),
              validator: Validators.validateAuthor,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: BookStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status.value,
                  child: Text(status.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingProgress() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progresso de Leitura',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _currentPageController,
                    decoration: const InputDecoration(
                      labelText: 'Página Atual',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      final totalPages = int.tryParse(_pagesController.text);
                      return Validators.validateCurrentPage(value, totalPages);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _pagesController,
                    decoration: const InputDecoration(
                      labelText: 'Total de Páginas',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validators.validatePages,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Barra de progresso
            if (_pagesController.text.isNotEmpty && _currentPageController.text.isNotEmpty) ...[
              const Text('Progresso:'),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _calculateProgress(),
                backgroundColor: Colors.grey[300],
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                '${(_calculateProgress() * 100).round()}% concluído',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Avaliação',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Sua avaliação: '),
                ...List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      _rating > index ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1.0;
                      });
                    },
                  );
                }),
                Text('(${_rating.toStringAsFixed(1)})'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações Adicionais',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _publisherController,
                    decoration: const InputDecoration(
                      labelText: 'Editora',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _yearController,
                    decoration: const InputDecoration(
                      labelText: 'Ano',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: Validators.validateYear,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGenre,
              decoration: const InputDecoration(
                labelText: 'Gênero',
                border: OutlineInputBorder(),
              ),
              items: BookGenre.values.map((genre) {
                return DropdownMenuItem(
                  value: genre.value,
                  child: Text(genre.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrição',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Descrição do livro (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              validator: Validators.validateNotes,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _updateBook,
            icon: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.save),
            label: Text(_isLoading ? 'Salvando...' : 'Salvar Alterações'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Navegar para notas do livro
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade de notas em desenvolvimento'),
                ),
              );
            },
            icon: const Icon(Icons.note_add),
            label: const Text('Gerenciar Notas'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateProgress() {
    final current = int.tryParse(_currentPageController.text) ?? 0;
    final total = int.tryParse(_pagesController.text) ?? 1;
    return total > 0 ? (current / total).clamp(0.0, 1.0) : 0.0;
  }

  void _updateBook() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implementar atualização real do livro
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Livro atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar livro'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir Livro'),
        content: const Text(
          'Tem certeza que deseja excluir este livro? '
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // TODO: Implementar exclusão real
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Livro excluído com sucesso!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
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
