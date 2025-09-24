// 📚 FolhaVirada - Note Repository Implementation
// Implementação do repositório de notas

import 'package:injectable/injectable.dart';
import 'package:folhavirada/data/datasources/note_local_datasource.dart';
import 'package:folhavirada/data/models/note_model.dart';
import 'package:folhavirada/domain/entities/note_entity.dart';
import 'package:folhavirada/domain/repositories/note_repository.dart';

@LazySingleton(as: NoteRepository)
class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDatasource _localDatasource;

  NoteRepositoryImpl(this._localDatasource);

  @override
  Future<List<NoteEntity>> getNotesByBookId(String bookId) async {
    try {
      final models = await _localDatasource.getNotesByBookId(bookId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get notes by book id: $e');
    }
  }

  @override
  Future<NoteEntity?> getNoteById(String id) async {
    try {
      final model = await _localDatasource.getNoteById(id);
      return model?.toEntity();
    } catch (e) {
      throw Exception('Failed to get note by id: $e');
    }
  }

  @override
  Future<List<NoteEntity>> searchNotes(String query) async {
    try {
      final models = await _localDatasource.searchNotes(query);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to search notes: $e');
    }
  }

  @override
  Future<NoteEntity> addNote(NoteEntity note) async {
    try {
      final model = NoteModel.fromEntity(note);
      final savedModel = await _localDatasource.insertNote(model);
      return savedModel.toEntity();
    } catch (e) {
      throw Exception('Failed to add note: $e');
    }
  }

  @override
  Future<NoteEntity> updateNote(NoteEntity note) async {
    try {
      final model = NoteModel.fromEntity(note);
      final updatedModel = await _localDatasource.updateNote(model);
      return updatedModel.toEntity();
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      await _localDatasource.deleteNote(id);
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  @override
  Future<List<NoteEntity>> getAllNotes() async {
    try {
      final models = await _localDatasource.getAllNotes();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get all notes: $e');
    }
  }

  @override
  Future<List<NoteEntity>> getRecentNotes(int limit) async {
    try {
      final models = await _localDatasource.getRecentNotes(limit);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get recent notes: $e');
    }
  }

  @override
  Future<int> getNotesCountByBookId(String bookId) async {
    try {
      return await _localDatasource.getNotesCountByBookId(bookId);
    } catch (e) {
      throw Exception('Failed to get notes count: $e');
    }
  }

  @override
  Future<void> deleteNotesByBookId(String bookId) async {
    try {
      await _localDatasource.deleteNotesByBookId(bookId);
    } catch (e) {
      throw Exception('Failed to delete notes by book id: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> exportNotes() async {
    try {
      final notes = await getAllNotes();
      return {
        'notes': notes.map((note) => NoteModel.fromEntity(note).toJson()).toList(),
        'exported_at': DateTime.now().toIso8601String(),
        'total_count': notes.length,
      };
    } catch (e) {
      throw Exception('Failed to export notes: $e');
    }
  }

  @override
  Future<void> importNotes(Map<String, dynamic> data) async {
    try {
      final notesList = data['notes'] as List<dynamic>;
      
      for (final noteData in notesList) {
        try {
          final noteModel = NoteModel.fromJson(noteData as Map<String, dynamic>);
          await _localDatasource.insertNote(noteModel);
        } catch (e) {
          // Log individual note import errors but continue
          print('Failed to import note: $e');
        }
      }
    } catch (e) {
      throw Exception('Failed to import notes: $e');
    }
  }

  @override
  Future<void> clearAllNotes() async {
    try {
      await _localDatasource.clearAllNotes();
    } catch (e) {
      throw Exception('Failed to clear all notes: $e');
    }
  }
}
