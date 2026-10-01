import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  static Database? _database;

  static const String _databaseName = 'flowly.db';
  static const int _databaseVersion = 3;

  // --------------------------------------------------------------------------
  // DATABASE INSTANCE
  // --------------------------------------------------------------------------

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  // --------------------------------------------------------------------------
  // INITIALIZE DATABASE
  // --------------------------------------------------------------------------

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // --------------------------------------------------------------------------
  // CREATE DATABASE
  // --------------------------------------------------------------------------

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    // USERS TABLE
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        created_at TEXT
      )
    ''');

    // DAILY ENTRIES TABLE
    await db.execute('''
      CREATE TABLE daily_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        entry_date TEXT NOT NULL,
        mood TEXT,
        gratitude TEXT,
        tasks TEXT,
        goals TEXT,
        wrong TEXT,
        learned TEXT,
        lesson TEXT,
        updated_at TEXT,
        UNIQUE(user_id, entry_date)
      )
    ''');

    // JOURNAL ENTRIES TABLE
    await db.execute('''
      CREATE TABLE journal_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        thoughts TEXT NOT NULL,
        mood_emoji TEXT NOT NULL,
        mood_name TEXT NOT NULL,
        entry_day TEXT NOT NULL,
        entry_date TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');
  }

  // --------------------------------------------------------------------------
  // DATABASE UPDATES
  // --------------------------------------------------------------------------

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS daily_entries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          entry_date TEXT NOT NULL,
          mood TEXT,
          gratitude TEXT,
          tasks TEXT,
          goals TEXT,
          wrong TEXT,
          learned TEXT,
          lesson TEXT,
          updated_at TEXT,
          UNIQUE(user_id, entry_date)
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS journal_entries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER NOT NULL,
          title TEXT NOT NULL,
          thoughts TEXT NOT NULL,
          mood_emoji TEXT NOT NULL,
          mood_name TEXT NOT NULL,
          entry_day TEXT NOT NULL,
          entry_date TEXT NOT NULL,
          created_at TEXT NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
    }
  }

  // ==========================================================================
  // USER METHODS
  // ==========================================================================

  Future<int> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final db = await database;

    return await db.insert(
      'users',
      {
        'name': name,
        'email': email,
        'password': password,
        'created_at': DateTime.now().toIso8601String(),
      },
    );
  }

  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [
        email,
        password,
      ],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  Future<bool> emailExists(String email) async {
    final db = await database;

    final result = await db.query(
      'users',
      columns: ['id'],
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>?> getUserById(
    int id,
  ) async {
    final db = await database;

    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;

    return await db.query(
      'users',
      orderBy: 'id DESC',
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;

    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ==========================================================================
  // DAILY ENTRY METHODS
  // ==========================================================================

  Future<int> saveDailyEntry({
    required int userId,
    required String entryDate,
    required String mood,
    required String gratitude,
    required String tasks,
    required String goals,
    required String wrong,
    required String learned,
    required String lesson,
  }) async {
    final db = await database;

    final existing = await db.query(
      'daily_entries',
      columns: ['id'],
      where: 'user_id = ? AND entry_date = ?',
      whereArgs: [
        userId,
        entryDate,
      ],
      limit: 1,
    );

    final data = {
      'user_id': userId,
      'entry_date': entryDate,
      'mood': mood,
      'gratitude': gratitude,
      'tasks': tasks,
      'goals': goals,
      'wrong': wrong,
      'learned': learned,
      'lesson': lesson,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (existing.isNotEmpty) {
      return await db.update(
        'daily_entries',
        data,
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    }

    return await db.insert(
      'daily_entries',
      data,
    );
  }

  Future<Map<String, dynamic>?> getDailyEntry({
    required int userId,
    required String entryDate,
  }) async {
    final db = await database;

    final result = await db.query(
      'daily_entries',
      where: 'user_id = ? AND entry_date = ?',
      whereArgs: [
        userId,
        entryDate,
      ],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  // ==========================================================================
  // JOURNAL METHODS
  // ==========================================================================

  Future<int> saveJournalEntry({
    required int userId,
    required String title,
    required String thoughts,
    required String moodEmoji,
    required String moodName,
    required String entryDay,
    required String entryDate,
  }) async {
    final db = await database;

    final now = DateTime.now().toIso8601String();

    return await db.insert(
      'journal_entries',
      {
        'user_id': userId,
        'title': title,
        'thoughts': thoughts,
        'mood_emoji': moodEmoji,
        'mood_name': moodName,
        'entry_day': entryDay,
        'entry_date': entryDate,
        'created_at': now,
        'updated_at': now,
      },
    );
  }

  // Get all journal entries for the logged-in user
  Future<List<Map<String, dynamic>>> getJournalEntries({
    required int userId,
  }) async {
    final db = await database;

    return await db.query(
      'journal_entries',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'id DESC',
    );
  }

  // Get one journal entry
  Future<Map<String, dynamic>?> getJournalEntryById(
    int id,
  ) async {
    final db = await database;

    final result = await db.query(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  // Delete journal entry
  Future<int> deleteJournalEntry(
    int id,
  ) async {
    final db = await database;

    return await db.delete(
      'journal_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<dynamic> getTodayEntry({required int userId, required String entryDate}) async {}

  Future<void> saveTodayEntry({required int userId, required String entryDate, required String mood, required List<String> gratitude, required List<String> todayTasks, required List<String> futureGoals, required List<String> wrongToday, required List<String> learnedToday, required String lesson}) async {}
}