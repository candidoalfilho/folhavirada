// 📚 FolhaVirada - Note Entity
// Entidade de domínio para notas

class NoteEntity {
  final String id;
  final String bookId;
  final String? title;
  final String content;
  final int? pageNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteEntity({
    required this.id,
    required this.bookId,
    this.title,
    required this.content,
    this.pageNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Criar cópia com alterações
  NoteEntity copyWith({
    String? id,
    String? bookId,
    String? title,
    String? content,
    int? pageNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      content: content ?? this.content,
      pageNumber: pageNumber ?? this.pageNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Métodos auxiliares

  /// Verificar se tem título
  bool get hasTitle => title != null && title!.trim().isNotEmpty;

  /// Verificar se está associada a uma página
  bool get hasPageNumber => pageNumber != null && pageNumber! > 0;

  /// Obter título efetivo (usa primeiras palavras do conteúdo se não tiver título)
  String get effectiveTitle {
    if (hasTitle) return title!;
    
    final words = content.trim().split(' ');
    if (words.length <= 5) return content.trim();
    
    return '${words.take(5).join(' ')}...';
  }

  /// Verificar se é uma nota longa
  bool get isLongNote => content.length > 200;

  /// Verificar se é uma nota curta
  bool get isShortNote => content.length <= 50;

  /// Obter preview do conteúdo
  String getContentPreview([int maxLength = 100]) {
    if (content.length <= maxLength) return content;
    return '${content.substring(0, maxLength)}...';
  }

  /// Verificar se é uma nota recente (criada nos últimos 7 dias)
  bool get isRecent {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return createdAt.isAfter(sevenDaysAgo);
  }

  /// Verificar se foi atualizada recentemente
  bool get isRecentlyUpdated {
    final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
    return updatedAt.isAfter(twoDaysAgo) && !isSameDay(createdAt, updatedAt);
  }

  /// Verificar se foi editada (criatedAt != updatedAt)
  bool get wasEdited => !isSameDay(createdAt, updatedAt);

  /// Obter categoria de tamanho da nota
  String get sizeCategory {
    if (isShortNote) return 'Curta';
    if (isLongNote) return 'Longa';
    return 'Média';
  }

  /// Contar palavras
  int get wordCount => content.trim().split(RegExp(r'\s+')).length;

  /// Contar caracteres (sem espaços)
  int get characterCount => content.replaceAll(' ', '').length;

  /// Verificar se contém uma palavra específica
  bool containsWord(String word) {
    final searchText = '${title ?? ''} $content'.toLowerCase();
    return searchText.contains(word.toLowerCase());
  }

  /// Verificar se contém alguma das palavras
  bool containsAnyWord(List<String> words) {
    return words.any((word) => containsWord(word));
  }

  /// Obter tipo de nota baseado no conteúdo
  String get noteType {
    final lowerContent = content.toLowerCase();
    
    if (lowerContent.contains('citação') || lowerContent.contains('"')) {
      return 'Citação';
    } else if (lowerContent.contains('resumo') || lowerContent.contains('capítulo')) {
      return 'Resumo';
    } else if (lowerContent.contains('reflexão') || lowerContent.contains('penso')) {
      return 'Reflexão';
    } else if (lowerContent.contains('importante') || lowerContent.contains('!')) {
      return 'Destaque';
    } else if (lowerContent.contains('dúvida') || lowerContent.contains('?')) {
      return 'Dúvida';
    } else {
      return 'Nota';
    }
  }

  /// Validar se a nota está correta
  bool get isValid {
    return content.trim().isNotEmpty &&
           bookId.trim().isNotEmpty &&
           (pageNumber == null || pageNumber! > 0);
  }

  /// Obter prioridade da nota baseada no conteúdo
  int get priority {
    final lowerContent = content.toLowerCase();
    
    if (lowerContent.contains('importante') || 
        lowerContent.contains('crucial') ||
        lowerContent.contains('!!!')) {
      return 3; // Alta
    } else if (lowerContent.contains('interessante') ||
               lowerContent.contains('nota') ||
               lowerContent.contains('!!')) {
      return 2; // Média
    } else {
      return 1; // Baixa
    }
  }

  /// Obter etiquetas baseadas no conteúdo
  List<String> get autoTags {
    final tags = <String>[];
    final lowerContent = content.toLowerCase();
    
    if (lowerContent.contains('personagem')) tags.add('Personagem');
    if (lowerContent.contains('enredo') || lowerContent.contains('história')) tags.add('Enredo');
    if (lowerContent.contains('final') || lowerContent.contains('conclusão')) tags.add('Final');
    if (lowerContent.contains('começou') || lowerContent.contains('início')) tags.add('Início');
    if (lowerContent.contains('surpresa') || lowerContent.contains('plot twist')) tags.add('Plot Twist');
    if (lowerContent.contains('romance') || lowerContent.contains('amor')) tags.add('Romance');
    if (lowerContent.contains('ação') || lowerContent.contains('luta')) tags.add('Ação');
    if (lowerContent.contains('mistério') || lowerContent.contains('segredo')) tags.add('Mistério');
    
    return tags;
  }

  /// Método auxiliar para comparar datas (mesmo dia)
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'NoteEntity{id: $id, bookId: $bookId, title: $title, hasContent: ${content.isNotEmpty}}';
  }
}
