// 📚 FolhaVirada - Book Detail Screen
// Tela de detalhes do livro

import 'package:flutter/material.dart';
import 'package:folhavirada/core/constants/app_strings.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;

  const BookDetailScreen({
    super.key,
    required this.bookId,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Livro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navegar para edição
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showOptionsMenu(context),
          ),
        ],
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BookHeader(),
            SizedBox(height: 24),
            _BookInfo(),
            SizedBox(height: 24),
            _ReadingProgress(),
            SizedBox(height: 24),
            _BookActions(),
            SizedBox(height: 24),
            _BookNotes(),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text(AppStrings.share),
            onTap: () {
              Navigator.pop(context);
              // TODO: Implementar compartilhamento
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text(AppStrings.delete),
            onTap: () {
              Navigator.pop(context);
              _showDeleteConfirmation(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.confirmDelete),
        content: const Text(AppStrings.confirmDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Voltar para tela anterior
              // TODO: Implementar exclusão
            },
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}

class _BookHeader extends StatelessWidget {
  const _BookHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Capa do livro
        Container(
          width: 120,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.book,
            size: 48,
            color: Colors.grey,
          ),
        ),
        const SizedBox(width: 16),
        // Informações básicas
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Título do Livro', // TODO: Dados reais
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Nome do Autor', // TODO: Dados reais
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),
              // Status chip
              Chip(
                label: const Text('Quero Ler'), // TODO: Status real
                backgroundColor: Colors.purple.withOpacity(0.1),
                labelStyle: const TextStyle(color: Colors.purple),
              ),
              const SizedBox(height: 8),
              // Avaliação
              Row(
                children: [
                  ...List.generate(
                    5,
                    (index) => Icon(
                      index < 0 ? Icons.star : Icons.star_border, // TODO: Rating real
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '0.0', // TODO: Rating real
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BookInfo extends StatelessWidget {
  const _BookInfo();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informações',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: AppStrings.publisher,
              value: 'Editora Exemplo', // TODO: Dados reais
            ),
            _InfoRow(
              label: AppStrings.publishedYear,
              value: '2023', // TODO: Dados reais
            ),
            _InfoRow(
              label: AppStrings.pages,
              value: '300', // TODO: Dados reais
            ),
            _InfoRow(
              label: AppStrings.genre,
              value: 'Ficção', // TODO: Dados reais
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.description,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Descrição do livro aqui...', // TODO: Descrição real
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingProgress extends StatelessWidget {
  const _ReadingProgress();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.progress,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Página Atual',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '0', // TODO: Página atual
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total de Páginas',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '300', // TODO: Total de páginas
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Progresso',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '0%', // TODO: Progresso
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: 0.0, // TODO: Progresso real
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Atualizar progresso
                },
                icon: const Icon(Icons.edit),
                label: const Text(AppStrings.updateProgress),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookActions extends StatelessWidget {
  const _BookActions();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ações',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Iniciar leitura
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text(AppStrings.startReading),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Finalizar leitura
                    },
                    icon: const Icon(Icons.check),
                    label: const Text(AppStrings.finishReading),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BookNotes extends StatelessWidget {
  const _BookNotes();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.notes,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton.icon(
                  onPressed: () {
                    // TODO: Adicionar nota
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.note_alt_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nenhuma nota ainda',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Adicione suas primeiras anotações',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
