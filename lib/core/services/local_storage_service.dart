// 📚 FolhaVirada - Local Storage Service
// Serviço para gerenciar armazenamento local

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:folhavirada/data/models/simple_hive_book.dart';
import 'package:folhavirada/data/models/simple_hive_note.dart';

class LocalStorageService {
  static const String _booksBoxName = 'books';
  static const String _notesBoxName = 'notes';
  
  // SharedPreferences keys
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyReadingGoal = 'reading_goal';

  late SharedPreferences _prefs;
  late Box<SimpleHiveBook> _booksBox;
  late Box<SimpleHiveNote> _notesBox;

  bool _isInitialized = false;

  /// Initialize storage service
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SimpleHiveBookAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SimpleHiveNoteAdapter());
    }

    // Open boxes
    _booksBox = await Hive.openBox<SimpleHiveBook>(_booksBoxName);
    _notesBox = await Hive.openBox<SimpleHiveNote>(_notesBoxName);

    // Initialize SharedPreferences
    _prefs = await SharedPreferences.getInstance();

    _isInitialized = true;
  }

  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('LocalStorageService not initialized');
    }
  }

  // ==================== BOOKS ====================

  List<Map<String, dynamic>> getAllBooks() {
    _ensureInitialized();
    return _booksBox.values.map((book) => book.toMap()).toList();
  }

  Map<String, dynamic>? getBookById(String id) {
    _ensureInitialized();
    final book = _booksBox.get(id);
    return book?.toMap();
  }

  Future<void> saveBook(Map<String, dynamic> bookData) async {
    _ensureInitialized();
    final book = SimpleHiveBook.fromMap(bookData);
    await _booksBox.put(book.id, book);
  }

  Future<void> deleteBook(String id) async {
    _ensureInitialized();
    await _booksBox.delete(id);
  }

  List<Map<String, dynamic>> getBooksByStatus(String status) {
    _ensureInitialized();
    return _booksBox.values
        .where((book) => book.status == status)
        .map((book) => book.toMap())
        .toList();
  }

  List<Map<String, dynamic>> searchBooks(String query) {
    _ensureInitialized();
    final lowerQuery = query.toLowerCase();
    return _booksBox.values
        .where((book) => 
            book.title.toLowerCase().contains(lowerQuery) ||
            book.author.toLowerCase().contains(lowerQuery))
        .map((book) => book.toMap())
        .toList();
  }

  // ==================== NOTES ====================

  List<Map<String, dynamic>> getNotesByBookId(String bookId) {
    _ensureInitialized();
    return _notesBox.values
        .where((note) => note.bookId == bookId)
        .map((note) => note.toMap())
        .toList();
  }

  Future<void> saveNote(Map<String, dynamic> noteData) async {
    _ensureInitialized();
    final note = SimpleHiveNote.fromMap(noteData);
    await _notesBox.put(note.id, note);
  }

  Future<void> deleteNote(String id) async {
    _ensureInitialized();
    await _notesBox.delete(id);
  }

  // ==================== SETTINGS ====================

  String getThemeMode() {
    return _prefs.getString(_keyThemeMode) ?? 'system';
  }

  Future<void> setThemeMode(String mode) async {
    await _prefs.setString(_keyThemeMode, mode);
  }

  int getReadingGoal() {
    return _prefs.getInt(_keyReadingGoal) ?? 12;
  }

  Future<void> setReadingGoal(int goal) async {
    await _prefs.setInt(_keyReadingGoal, goal);
  }

  // ==================== STATISTICS ====================

  Map<String, int> getBookCountsByStatus() {
    _ensureInitialized();
    final counts = <String, int>{
      'want_to_read': 0,
      'reading': 0,
      'read': 0,
    };

    for (final book in _booksBox.values) {
      counts[book.status] = (counts[book.status] ?? 0) + 1;
    }

    return counts;
  }

  Map<String, dynamic> getReadingStats() {
    _ensureInitialized();
    final books = getAllBooks();
    final currentYear = DateTime.now().year;
    
    final readBooks = books.where((book) => book['status'] == 'read').toList();
    final booksThisYear = readBooks.where((book) {
      final endDate = book['endDate'] != null ? DateTime.parse(book['endDate']) : null;
      final createdAt = DateTime.parse(book['createdAt']);
      return endDate?.year == currentYear || createdAt.year == currentYear;
    }).length;

    final totalPages = readBooks
        .where((book) => book['totalPages'] != null)
        .fold<int>(0, (sum, book) => sum + (book['totalPages'] as int? ?? 0));

    return {
      'totalBooks': books.length,
      'readBooks': readBooks.length,
      'booksThisYear': booksThisYear,
      'totalPages': totalPages,
      'readingGoal': getReadingGoal(),
    };
  }
}
