// 📚 FolhaVirada - Database Service
// Serviço para gerenciar o banco de dados SQLite

import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:folhavirada/core/constants/app_constants.dart';

@lazySingleton
class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Tabela de livros
    await db.execute('''
      CREATE TABLE ${AppConstants.booksTable} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT NOT NULL,
        publisher TEXT,
        published_year INTEGER,
        isbn TEXT,
        genre TEXT,
        description TEXT,
        cover_url TEXT,
        cover_local_path TEXT,
        total_pages INTEGER DEFAULT 0,
        current_page INTEGER DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'want_to_read',
        rating REAL DEFAULT 0.0,
        start_date TEXT,
        end_date TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Tabela de notas
    await db.execute('''
      CREATE TABLE ${AppConstants.notesTable} (
        id TEXT PRIMARY KEY,
        book_id TEXT NOT NULL,
        title TEXT,
        content TEXT NOT NULL,
        page_number INTEGER,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (book_id) REFERENCES ${AppConstants.booksTable} (id) ON DELETE CASCADE
      )
    ''');

    // Tabela de estatísticas (cache)
    await db.execute('''
      CREATE TABLE ${AppConstants.statisticsTable} (
        id TEXT PRIMARY KEY,
        stat_type TEXT NOT NULL,
        stat_value TEXT NOT NULL,
        calculated_at TEXT NOT NULL
      )
    ''');

    // Índices para melhor performance
    await db.execute('''
      CREATE INDEX idx_books_status ON ${AppConstants.booksTable} (status)
    ''');

    await db.execute('''
      CREATE INDEX idx_books_genre ON ${AppConstants.booksTable} (genre)
    ''');

    await db.execute('''
      CREATE INDEX idx_books_rating ON ${AppConstants.booksTable} (rating)
    ''');

    await db.execute('''
      CREATE INDEX idx_books_dates ON ${AppConstants.booksTable} (start_date, end_date)
    ''');

    await db.execute('''
      CREATE INDEX idx_notes_book_id ON ${AppConstants.notesTable} (book_id)
    ''');
  }

  Future<void> _upgradeDatabase(Database db, int oldVersion, int newVersion) async {
    // Implementar migrações futuras aqui
    if (oldVersion < 2) {
      // Exemplo de migração para versão 2
      // await db.execute('ALTER TABLE books ADD COLUMN new_field TEXT');
    }
  }

  // Métodos auxiliares para operações no banco

  /// Inserir dados
  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  /// Atualizar dados
  Future<int> update(
    String table,
    Map<String, dynamic> data,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    final db = await database;
    return await db.update(table, data, where: whereClause, whereArgs: whereArgs);
  }

  /// Deletar dados
  Future<int> delete(
    String table,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    final db = await database;
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  /// Buscar dados
  Future<List<Map<String, dynamic>>> query(
    String table, {
    List<String>? columns,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// Executar query SQL customizada
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  /// Executar comando SQL customizado
  Future<void> execute(String sql, [List<dynamic>? arguments]) async {
    final db = await database;
    await db.execute(sql, arguments);
  }

  /// Executar transação
  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    final db = await database;
    return await db.transaction(action);
  }

  /// Contar registros
  Future<int> count(String table, {String? where, List<dynamic>? whereArgs}) async {
    final db = await database;
    final result = await db.query(
      table,
      columns: ['COUNT(*) as count'],
      where: where,
      whereArgs: whereArgs,
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Verificar se registro existe
  Future<bool> exists(
    String table,
    String whereClause,
    List<dynamic> whereArgs,
  ) async {
    final count = await this.count(table, where: whereClause, whereArgs: whereArgs);
    return count > 0;
  }

  /// Limpar tabela
  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  /// Obter informações do banco
  Future<Map<String, dynamic>> getDatabaseInfo() async {
    final db = await database;
    final version = await db.getVersion();
    final path = db.path;
    
    // Obter tamanho do banco (aproximado)
    final tables = ['books', 'notes', 'statistics'];
    int totalRecords = 0;
    
    for (final table in tables) {
      final count = await this.count(table);
      totalRecords += count;
    }

    return {
      'path': path,
      'version': version,
      'totalRecords': totalRecords,
      'tables': tables,
    };
  }

  /// Backup do banco (exportar dados)
  Future<Map<String, List<Map<String, dynamic>>>> exportData() async {
    final books = await query(AppConstants.booksTable);
    final notes = await query(AppConstants.notesTable);
    final statistics = await query(AppConstants.statisticsTable);

    return {
      'books': books,
      'notes': notes,
      'statistics': statistics,
      'metadata': [
        {
          'exported_at': DateTime.now().toIso8601String(),
          'version': AppConstants.databaseVersion,
        }
      ],
    };
  }

  /// Restaurar backup (importar dados)
  Future<void> importData(Map<String, List<Map<String, dynamic>>> data) async {
    await transaction((txn) async {
      // Limpar dados existentes
      await txn.delete(AppConstants.notesTable);
      await txn.delete(AppConstants.booksTable);
      await txn.delete(AppConstants.statisticsTable);

      // Importar livros
      if (data['books'] != null) {
        for (final book in data['books']!) {
          await txn.insert(AppConstants.booksTable, book);
        }
      }

      // Importar notas
      if (data['notes'] != null) {
        for (final note in data['notes']!) {
          await txn.insert(AppConstants.notesTable, note);
        }
      }

      // Importar estatísticas
      if (data['statistics'] != null) {
        for (final stat in data['statistics']!) {
          await txn.insert(AppConstants.statisticsTable, stat);
        }
      }
    });
  }

  /// Fechar conexão com o banco
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// Deletar banco de dados (para reset completo)
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppConstants.databaseName);
    
    await close();
    await databaseFactory.deleteDatabase(path);
  }
}
