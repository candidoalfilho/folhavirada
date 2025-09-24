// 📚 FolhaVirada - Note Use Cases
// Casos de uso para operações com notas

import 'package:injectable/injectable.dart';
import 'package:folhavirada/domain/entities/note_entity.dart';
import 'package:folhavirada/domain/repositories/note_repository.dart';
import 'package:folhavirada/domain/usecases/book_usecases.dart';
import 'package:folhavirada/core/utils/app_utils.dart';

// Parâmetros para diferentes use cases
class AddNoteParams {
  final String bookId;
  final String? title;
  final String content;
  final int? pageNumber;

  const AddNoteParams({
    required this.bookId,
    this.title,
    required this.content,
    this.pageNumber,
  });
}

// Use Cases

@injectable
class GetNotesByBookIdUseCase implements UseCase<List<NoteEntity>, String> {
  final NoteRepository _repository;

  GetNotesByBookIdUseCase(this._repository);

  @override
  Future<List<NoteEntity>> call(String bookId) async {
    if (bookId.trim().isEmpty) {
      throw ArgumentError('Book ID cannot be empty');
    }
    return await _repository.getNotesByBookId(bookId);
  }
}

@injectable
class GetNoteByIdUseCase implements UseCase<NoteEntity?, String> {
  final NoteRepository _repository;

  GetNoteByIdUseCase(this._repository);

  @override
  Future<NoteEntity?> call(String noteId) async {
    if (noteId.trim().isEmpty) {
      throw ArgumentError('Note ID cannot be empty');
    }
    return await _repository.getNoteById(noteId);
  }
}

@injectable
class SearchNotesUseCase implements UseCase<List<NoteEntity>, String> {
  final NoteRepository _repository;

  SearchNotesUseCase(this._repository);

  @override
  Future<List<NoteEntity>> call(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await _repository.searchNotes(query.trim());
  }
}

@injectable
class AddNoteUseCase implements UseCase<NoteEntity, AddNoteParams> {
  final NoteRepository _repository;

  AddNoteUseCase(this._repository);

  @override
  Future<NoteEntity> call(AddNoteParams params) async {
    // Validar dados obrigatórios
    if (params.bookId.trim().isEmpty) {
      throw ArgumentError('Book ID cannot be empty');
    }
    if (params.content.trim().isEmpty) {
      throw ArgumentError('Note content cannot be empty');
    }

    // Validar número da página
    if (params.pageNumber != null && params.pageNumber! <= 0) {
      throw ArgumentError('Page number must be greater than 0');
    }

    // Criar entidade da nota
    final now = DateTime.now();
    final note = NoteEntity(
      id: AppUtils.generateId(),
      bookId: params.bookId.trim(),
      title: params.title?.trim(),
      content: params.content.trim(),
      pageNumber: params.pageNumber,
      createdAt: now,
      updatedAt: now,
    );

    return await _repository.addNote(note);
  }
}

@injectable
class UpdateNoteUseCase implements UseCase<NoteEntity, NoteEntity> {
  final NoteRepository _repository;

  UpdateNoteUseCase(this._repository);

  @override
  Future<NoteEntity> call(NoteEntity note) async {
    // Validar dados obrigatórios
    if (note.bookId.trim().isEmpty) {
      throw ArgumentError('Book ID cannot be empty');
    }
    if (note.content.trim().isEmpty) {
      throw ArgumentError('Note content cannot be empty');
    }

    // Validar número da página
    if (note.pageNumber != null && note.pageNumber! <= 0) {
      throw ArgumentError('Page number must be greater than 0');
    }

    // Atualizar timestamp
    final updatedNote = note.copyWith(updatedAt: DateTime.now());
    return await _repository.updateNote(updatedNote);
  }
}

@injectable
class DeleteNoteUseCase implements UseCase<void, String> {
  final NoteRepository _repository;

  DeleteNoteUseCase(this._repository);

  @override
  Future<void> call(String noteId) async {
    if (noteId.trim().isEmpty) {
      throw ArgumentError('Note ID cannot be empty');
    }

    // Verificar se a nota existe
    final note = await _repository.getNoteById(noteId);
    if (note == null) {
      throw Exception('Note not found');
    }

    await _repository.deleteNote(noteId);
  }
}

@injectable
class GetAllNotesUseCase implements UseCase<List<NoteEntity>, void> {
  final NoteRepository _repository;

  GetAllNotesUseCase(this._repository);

  @override
  Future<List<NoteEntity>> call(void params) async {
    return await _repository.getAllNotes();
  }
}

@injectable
class GetRecentNotesUseCase implements UseCase<List<NoteEntity>, int> {
  final NoteRepository _repository;

  GetRecentNotesUseCase(this._repository);

  @override
  Future<List<NoteEntity>> call(int limit) async {
    if (limit <= 0) {
      throw ArgumentError('Limit must be greater than 0');
    }
    return await _repository.getRecentNotes(limit);
  }
}

@injectable
class GetNotesCountByBookIdUseCase implements UseCase<int, String> {
  final NoteRepository _repository;

  GetNotesCountByBookIdUseCase(this._repository);

  @override
  Future<int> call(String bookId) async {
    if (bookId.trim().isEmpty) {
      throw ArgumentError('Book ID cannot be empty');
    }
    return await _repository.getNotesCountByBookId(bookId);
  }
}

@injectable
class DeleteNotesByBookIdUseCase implements UseCase<void, String> {
  final NoteRepository _repository;

  DeleteNotesByBookIdUseCase(this._repository);

  @override
  Future<void> call(String bookId) async {
    if (bookId.trim().isEmpty) {
      throw ArgumentError('Book ID cannot be empty');
    }
    await _repository.deleteNotesByBookId(bookId);
  }
}

@injectable
class ExportNotesUseCase implements UseCase<Map<String, dynamic>, void> {
  final NoteRepository _repository;

  ExportNotesUseCase(this._repository);

  @override
  Future<Map<String, dynamic>> call(void params) async {
    return await _repository.exportNotes();
  }
}

@injectable
class ImportNotesUseCase implements UseCase<void, Map<String, dynamic>> {
  final NoteRepository _repository;

  ImportNotesUseCase(this._repository);

  @override
  Future<void> call(Map<String, dynamic> data) async {
    if (data.isEmpty) {
      throw ArgumentError('Import data cannot be empty');
    }
    await _repository.importNotes(data);
  }
}

@injectable
class ClearAllNotesUseCase implements UseCase<void, void> {
  final NoteRepository _repository;

  ClearAllNotesUseCase(this._repository);

  @override
  Future<void> call(void params) async {
    await _repository.clearAllNotes();
  }
}

// Use case composto para operações complexas
@injectable
class GetNotesWithBookInfoUseCase implements UseCase<Map<String, dynamic>, String> {
  final GetNotesByBookIdUseCase _getNotesUseCase;
  final GetNotesCountByBookIdUseCase _getCountUseCase;

  GetNotesWithBookInfoUseCase(
    this._getNotesUseCase,
    this._getCountUseCase,
  );

  @override
  Future<Map<String, dynamic>> call(String bookId) async {
    final notes = await _getNotesUseCase(bookId);
    final count = await _getCountUseCase(bookId);

    // Organizar notas por tipo
    final notesByType = <String, List<NoteEntity>>{};
    for (final note in notes) {
      final type = note.noteType;
      notesByType[type] = (notesByType[type] ?? [])..add(note);
    }

    // Calcular estatísticas das notas
    final totalWords = notes.fold(0, (sum, note) => sum + note.wordCount);
    final averageLength = notes.isNotEmpty ? totalWords / notes.length : 0.0;

    return {
      'notes': notes,
      'count': count,
      'notesByType': notesByType,
      'statistics': {
        'totalWords': totalWords,
        'averageLength': averageLength,
        'shortNotes': notes.where((n) => n.isShortNote).length,
        'longNotes': notes.where((n) => n.isLongNote).length,
        'recentNotes': notes.where((n) => n.isRecent).length,
      },
    };
  }
}

@injectable
class DuplicateNoteUseCase implements UseCase<NoteEntity, String> {
  final GetNoteByIdUseCase _getNoteUseCase;
  final AddNoteUseCase _addNoteUseCase;

  DuplicateNoteUseCase(
    this._getNoteUseCase,
    this._addNoteUseCase,
  );

  @override
  Future<NoteEntity> call(String noteId) async {
    // Obter nota original
    final originalNote = await _getNoteUseCase(noteId);
    if (originalNote == null) {
      throw Exception('Note not found');
    }

    // Criar cópia
    final duplicateParams = AddNoteParams(
      bookId: originalNote.bookId,
      title: originalNote.hasTitle ? '${originalNote.title} (Cópia)' : null,
      content: originalNote.content,
      pageNumber: originalNote.pageNumber,
    );

    return await _addNoteUseCase(duplicateParams);
  }
}
