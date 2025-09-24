// 📚 FolhaVirada - Edit Note Screen
// Tela para editar nota existente

import 'package:flutter/material.dart';
import 'package:folhavirada/core/utils/validators.dart';

class EditNoteScreen extends StatefulWidget {
  final String noteId;

  const EditNoteScreen({
    super.key,
    required this.noteId,
  });

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _pageController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingData = true;
  String _bookTitle = '';
  DateTime? _createdAt;

  @override
  void initState() {
    super.initState();
    _loadNoteData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _loadNoteData() async {
    // TODO: Carregar dados reais da nota
    await Future.delayed(const Duration(seconds: 1));

    // Dados mockados para demonstração
    _titleController.text = 'Primeira impressão';
    _contentController.text = 'Narrador interessante, mas parece não ser muito confiável. A narrativa em primeira pessoa cria uma atmosfera de subjetividade que me deixa questionando a veracidade dos fatos apresentados.';
    _pageController.text = '25';
    _bookTitle = 'Dom Casmurro';
    _createdAt = DateTime.now().subtract(const Duration(days: 5));

    setState(() {
      _isLoadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Editar Nota'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Editar Nota'),
            if (_bookTitle.isNotEmpty)
              Text(
                _bookTitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(),
            tooltip: 'Excluir nota',
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
              // Info da nota
              if (_createdAt != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Criada em ${_formatDate(_createdAt!)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Título (opcional)
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título (opcional)',
                  hintText: 'Ex: Primeira impressão, Capítulo favorito...',
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),

              // Página (opcional)
              TextFormField(
                controller: _pageController,
                decoration: const InputDecoration(
                  labelText: 'Página (opcional)',
                  hintText: 'Ex: 25',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bookmark),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final page = int.tryParse(value);
                    if (page == null || page <= 0) {
                      return 'Digite um número de página válido';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Conteúdo da nota
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Conteúdo da nota *',
                  hintText: 'Digite suas anotações, reflexões ou comentários...',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 8,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O conteúdo da nota é obrigatório';
                  }
                  return Validators.validateNotes(value);
                },
              ),
              const SizedBox(height: 32),

              // Botões
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _updateNote,
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
                      onPressed: () => _showDeleteDialog(),
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Excluir Nota', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.red),
                      ),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _updateNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implementar atualização real da nota
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nota atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar nota'),
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
        title: const Text('Excluir Nota'),
        content: const Text(
          'Tem certeza que deseja excluir esta nota? '
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
                  content: Text('Nota excluída com sucesso!'),
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
