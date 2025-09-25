// 📚 FolhaVirada - App State Service
// Serviço para gerenciar estado da aplicação

import 'package:flutter/material.dart';
import 'package:folhavirada/core/services/local_storage_service.dart';
import 'package:folhavirada/core/di/injection.dart';

class AppStateService extends ChangeNotifier {
  late LocalStorageService _storage;
  
  // Theme state
  ThemeMode _themeMode = ThemeMode.system;
  
  // Reading goal state
  int _readingGoal = 12;
  
  // Statistics cache
  Map<String, dynamic>? _statsCache;
  
  AppStateService() {
    _storage = getIt<LocalStorageService>();
    _loadSettings();
  }

  // Getters
  ThemeMode get themeMode => _themeMode;
  int get readingGoal => _readingGoal;
  Map<String, dynamic> get stats => _statsCache ?? {};

  // Load settings from storage
  void _loadSettings() {
    final themeModeString = _storage.getThemeMode();
    _themeMode = _parseThemeMode(themeModeString);
    
    _readingGoal = _storage.getReadingGoal();
    
    _refreshStats();
  }

  ThemeMode _parseThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  // Update theme
  Future<void> updateThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _storage.setThemeMode(_themeModeToString(mode));
    notifyListeners();
  }

  // Update reading goal
  Future<void> updateReadingGoal(int goal) async {
    _readingGoal = goal;
    await _storage.setReadingGoal(goal);
    _refreshStats(); // Refresh stats when goal changes
    notifyListeners();
  }

  // Refresh statistics
  void _refreshStats() {
    _statsCache = _storage.getReadingStats();
  }

  // Add book
  Future<void> addBook(Map<String, dynamic> bookData) async {
    // Ensure required fields
    bookData['id'] = bookData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
    bookData['createdAt'] = bookData['createdAt'] ?? DateTime.now().toIso8601String();
    bookData['updatedAt'] = bookData['updatedAt'] ?? DateTime.now().toIso8601String();
    
    await _storage.saveBook(bookData);
    _refreshStats();
    notifyListeners();
  }

  // Update book
  Future<void> updateBook(Map<String, dynamic> bookData) async {
    bookData['updatedAt'] = DateTime.now().toIso8601String();
    await _storage.saveBook(bookData);
    _refreshStats();
    notifyListeners();
  }

  // Delete book
  Future<void> deleteBook(String id) async {
    await _storage.deleteBook(id);
    _refreshStats();
    notifyListeners();
  }

  // Get all books
  List<Map<String, dynamic>> getAllBooks() {
    return _storage.getAllBooks();
  }

  // Get book by ID
  Map<String, dynamic>? getBookById(String id) {
    return _storage.getBookById(id);
  }

  // Get books by status
  List<Map<String, dynamic>> getBooksByStatus(String status) {
    return _storage.getBooksByStatus(status);
  }

  // Search books
  List<Map<String, dynamic>> searchBooks(String query) {
    return _storage.searchBooks(query);
  }

  // Get book counts by status
  Map<String, int> getBookCountsByStatus() {
    return _storage.getBookCountsByStatus();
  }

  // Add note
  Future<void> addNote(Map<String, dynamic> noteData) async {
    noteData['id'] = noteData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString();
    noteData['createdAt'] = noteData['createdAt'] ?? DateTime.now().toIso8601String();
    noteData['updatedAt'] = noteData['updatedAt'] ?? DateTime.now().toIso8601String();
    
    await _storage.saveNote(noteData);
    notifyListeners();
  }

  // Get notes by book ID
  List<Map<String, dynamic>> getNotesByBookId(String bookId) {
    return _storage.getNotesByBookId(bookId);
  }

  // Delete note
  Future<void> deleteNote(String id) async {
    await _storage.deleteNote(id);
    notifyListeners();
  }

  // Force refresh stats (call after any book operation)
  void refreshStats() {
    _refreshStats();
    notifyListeners();
  }
}
