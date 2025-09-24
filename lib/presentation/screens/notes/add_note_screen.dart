// 📚 FolhaVirada - Add Note Screen
// Tela para adicionar nova nota

import 'package:flutter/material.dart';
import 'package:folhavirada/core/utils/validators.dart';

class AddNoteScreen extends StatefulWidget {
  final String bookId;
  final int? pageNumber;

  const AddNoteScreen({
    super.key,
    required this.bookId,
    this.pageNumber,
  });

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _pageController = TextEditingController();

  bool _isLoading = false;
  String _bookTitle = '';

  @override
  void initState() {
    super.initState();
    if (widget.pageNumber != null) {
      _pageController.text = widget.pageNumber.toString();
    }
    _loadBookInfo();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _loadBookInfo() async {
    // TODO: Carregar informações reais do livro
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _bookTitle = 'Dom Casmurro'; // Mock
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nova Nota'),
            if (_bookTitle.isNotEmpty)
              Text(
                _bookTitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              const SizedBox(height: 24),

              // Dicas
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.blue[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Dicas para boas anotações',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Anote suas impressões e reflexões\n'
                      '• Registre citações marcantes\n'
                      '• Faça perguntas sobre a narrativa\n'
                      '• Compare com outros livros',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.blue[700],
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Botão salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveNote,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isLoading ? 'Salvando...' : 'Salvar Nota'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Implementar salvamento real da nota
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nota salva com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao salvar nota'),
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
}
