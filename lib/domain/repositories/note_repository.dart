// 📚 FolhaVirada - Note Repository Interface
// Interface do repositório de notas

import 'package:folhavirada/domain/entities/note_entity.dart';

abstract class NoteRepository {
  /// Obter todas as notas de um livro
  Future<List<NoteEntity>> getNotesByBookId(String bookId);

  /// Obter nota por ID
  Future<NoteEntity?> getNoteById(String id);

  /// Buscar notas por conteúdo
  Future<List<NoteEntity>> searchNotes(String query);

  /// Adicionar nova nota
  Future<NoteEntity> addNote(NoteEntity note);

  /// Atualizar nota existente
  Future<NoteEntity> updateNote(NoteEntity note);

  /// Deletar nota
  Future<void> deleteNote(String id);

  /// Obter todas as notas
  Future<List<NoteEntity>> getAllNotes();

  /// Obter notas recentes
  Future<List<NoteEntity>> getRecentNotes(int limit);

  /// Contar notas de um livro
  Future<int> getNotesCountByBookId(String bookId);

  /// Deletar todas as notas de um livro
  Future<void> deleteNotesByBookId(String bookId);

  /// Exportar todas as notas
  Future<Map<String, dynamic>> exportNotes();

  /// Importar notas de backup
  Future<void> importNotes(Map<String, dynamic> data);

  /// Limpar todas as notas
  Future<void> clearAllNotes();
}
