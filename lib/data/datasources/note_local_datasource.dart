// 📚 FolhaVirada - Note Local Datasource
// Datasource para operações locais com notas

import 'package:injectable/injectable.dart';
import 'package:folhavirada/core/services/database_service.dart';
import 'package:folhavirada/core/constants/app_constants.dart';
import 'package:folhavirada/data/models/note_model.dart';

abstract class NoteLocalDatasource {
  Future<List<NoteModel>> getNotesByBookId(String bookId);
  Future<NoteModel?> getNoteById(String id);
  Future<List<NoteModel>> searchNotes(String query);
  Future<NoteModel> insertNote(NoteModel note);
  Future<NoteModel> updateNote(NoteModel note);
  Future<void> deleteNote(String id);
  Future<List<NoteModel>> getAllNotes();
  Future<List<NoteModel>> getRecentNotes(int limit);
  Future<int> getNotesCountByBookId(String bookId);
  Future<void> deleteNotesByBookId(String bookId);
  Future<void> clearAllNotes();
}

@LazySingleton(as: NoteLocalDatasource)
class NoteLocalDatasourceImpl implements NoteLocalDatasource {
  final DatabaseService _databaseService;

  NoteLocalDatasourceImpl(this._databaseService);

  @override
  Future<List<NoteModel>> getNotesByBookId(String bookId) async {
    try {
      final results = await _databaseService.query(
        AppConstants.notesTable,
        where: 'book_id = ?',
        whereArgs: [bookId],
        orderBy: 'created_at DESC',
      );

      return results.map((map) => NoteModel.fromDatabase(map)).toList();
    } catch (e) {
      throw Exception('Failed to get notes by book id from database: $e');
    }
  }

  @override
  Future<NoteModel?> getNoteById(String id) async {
    try {
      final results = await _databaseService.query(
        AppConstants.notesTable,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (results.isEmpty) return null;
      return NoteModel.fromDatabase(results.first);
    } catch (e) {
      throw Exception('Failed to get note by id from database: $e');
    }
  }

  @override
  Future<List<NoteModel>> searchNotes(String query) async {
    try {
      final searchQuery = '%$query%';
      final results = await _databaseService.query(
        AppConstants.notesTable,
        where: 'title LIKE ? OR content LIKE ?',
        whereArgs: [searchQuery, searchQuery],
        orderBy: 'created_at DESC',
      );

      return results.map((map) => NoteModel.fromDatabase(map)).toList();
    } catch (e) {
      throw Exception('Failed to search notes in database: $e');
    }
  }

  @override
  Future<NoteModel> insertNote(NoteModel note) async {
    try {
      final noteWithTimestamps = note.copyWith(
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      await _databaseService.insert(
        AppConstants.notesTable,
        noteWithTimestamps.toDatabase(),
      );

      return noteWithTimestamps;
    } catch (e) {
      throw Exception('Failed to insert note into database: $e');
    }
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      final noteWithTimestamp = note.copyWith(
        updatedAt: DateTime.now().toIso8601String(),
      );

      final rowsAffected = await _databaseService.update(
        AppConstants.notesTable,
        noteWithTimestamp.toDatabase(),
        'id = ?',
        [note.id],
      );

      if (rowsAffected == 0) {
        throw Exception('Note not found for update');
      }

      return noteWithTimestamp;
    } catch (e) {
      throw Exception('Failed to update note in database: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      final rowsAffected = await _databaseService.delete(
        AppConstants.notesTable,
        'id = ?',
        [id],
      );

      if (rowsAffected == 0) {
        throw Exception('Note not found for deletion');
      }
    } catch (e) {
      throw Exception('Failed to delete note from database: $e');
    }
  }

  @override
  Future<List<NoteModel>> getAllNotes() async {
    try {
      final results = await _databaseService.query(
        AppConstants.notesTable,
        orderBy: 'created_at DESC',
      );

      return results.map((map) => NoteModel.fromDatabase(map)).toList();
    } catch (e) {
      throw Exception('Failed to get all notes from database: $e');
    }
  }

  @override
  Future<List<NoteModel>> getRecentNotes(int limit) async {
    try {
      final results = await _databaseService.query(
        AppConstants.notesTable,
        orderBy: 'created_at DESC',
        limit: limit,
      );

      return results.map((map) => NoteModel.fromDatabase(map)).toList();
    } catch (e) {
      throw Exception('Failed to get recent notes from database: $e');
    }
  }

  @override
  Future<int> getNotesCountByBookId(String bookId) async {
    try {
      return await _databaseService.count(
        AppConstants.notesTable,
        where: 'book_id = ?',
        whereArgs: [bookId],
      );
    } catch (e) {
      throw Exception('Failed to get notes count by book id from database: $e');
    }
  }

  @override
  Future<void> deleteNotesByBookId(String bookId) async {
    try {
      await _databaseService.delete(
        AppConstants.notesTable,
        'book_id = ?',
        [bookId],
      );
    } catch (e) {
      throw Exception('Failed to delete notes by book id from database: $e');
    }
  }

  @override
  Future<void> clearAllNotes() async {
    try {
      await _databaseService.clearTable(AppConstants.notesTable);
    } catch (e) {
      throw Exception('Failed to clear all notes from database: $e');
    }
  }
}
