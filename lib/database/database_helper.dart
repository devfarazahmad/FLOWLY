import 'dart:convert';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance =
      DatabaseHelper._internal();

  factory DatabaseHelper() {
    return instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  static const String _databaseName = 'flowly.db';

  // ============================================================
  // DATABASE VERSION
  // ============================================================
  //
  // Version 3 already exists in your project.
  //
  // Version 4 adds:
  // task_completion table
  //
  // This means existing user / To-Do / Journal data remains safe.
  // ============================================================

  static const int _databaseVersion = 4;

  // ==========================================================================
  // DATABASE
  // ==========================================================================

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();

    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();

    final path = join(
      databasePath,
      _databaseName,
    );

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // ==========================================================================
  // CREATE DATABASE
  // ==========================================================================

  Future<void> _onCreate(
    Database db,
    int version,
  ) async {
    // ------------------------------------------------------------------------
    // USERS
    // ------------------------------------------------------------------------

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        password TEXT,
        created_at TEXT
      )
    ''');

    // ------------------------------------------------------------------------
    // DAILY / TO-DO ENTRIES
    // ------------------------------------------------------------------------

    await db.execute('''
      CREATE TABLE daily_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        user_id INTEGER NOT NULL,

        entry_date TEXT NOT NULL,

        mood TEXT,

        gratitude TEXT,

        today_tasks TEXT,

        future_goals TEXT,

        wrong_today TEXT,

        learned_today TEXT,

        lesson TEXT,

        updated_at TEXT,

        UNIQUE(user_id, entry_date)
      )
    ''');

    // ------------------------------------------------------------------------
    // JOURNAL ENTRIES
    // ------------------------------------------------------------------------

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

    // ------------------------------------------------------------------------
    // TASK COMPLETION
    // ------------------------------------------------------------------------
    //
    // This table remembers which task from today's To-Do list
    // has been completed.
    //
    // Example:
    //
    // user_id    = 1
    // entry_date = 2026-10-01
    // task_index = 0
    // completed  = 1
    //
    // This means today's first task is completed.
    // ------------------------------------------------------------------------

    await _createTaskCompletionTable(db);
  }

  // ==========================================================================
  // DATABASE UPGRADE
  // ==========================================================================

  Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    // ------------------------------------------------------------------------
    // VERSION 2
    // ------------------------------------------------------------------------

    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS daily_entries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,

          user_id INTEGER NOT NULL,

          entry_date TEXT NOT NULL,

          mood TEXT,

          gratitude TEXT,

          today_tasks TEXT,

          future_goals TEXT,

          wrong_today TEXT,

          learned_today TEXT,

          lesson TEXT,

          updated_at TEXT,

          UNIQUE(user_id, entry_date)
        )
      ''');
    }

    // ------------------------------------------------------------------------
    // VERSION 3
    // ------------------------------------------------------------------------

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

    // ------------------------------------------------------------------------
    // VERSION 4
    // ------------------------------------------------------------------------
    //
    // NEW:
    // Task completion storage for Home screen progress.
    // ------------------------------------------------------------------------

    if (oldVersion < 4) {
      await _createTaskCompletionTable(db);
    }
  }

  // ==========================================================================
  // CREATE TASK COMPLETION TABLE
  // ==========================================================================

  Future<void> _createTaskCompletionTable(
    Database db,
  ) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS task_completion (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        user_id INTEGER NOT NULL,

        entry_date TEXT NOT NULL,

        task_index INTEGER NOT NULL,

        completed INTEGER NOT NULL DEFAULT 0,

        UNIQUE(
          user_id,
          entry_date,
          task_index
        )
      )
    ''');
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
        'created_at':
            DateTime.now().toIso8601String(),
      },
    );
  }

  // --------------------------------------------------------------------------
  // LOGIN
  // --------------------------------------------------------------------------

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

  // --------------------------------------------------------------------------
  // CHECK EMAIL
  // --------------------------------------------------------------------------

  Future<bool> emailExists(
    String email,
  ) async {
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

  // --------------------------------------------------------------------------
  // GET USER
  // --------------------------------------------------------------------------

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

  // ==========================================================================
  // SAVE TODAY / TO-DO
  // ==========================================================================

  Future<int> saveTodayEntry({
    required int userId,
    required String entryDate,
    required String mood,
    required List<String> gratitude,
    required List<String> todayTasks,
    required List<String> futureGoals,
    required List<String> wrongToday,
    required List<String> learnedToday,
    required String lesson,
  }) async {
    final db = await database;

    // ------------------------------------------------------------------------
    // Convert lists into JSON strings.
    // ------------------------------------------------------------------------

    final String gratitudeJson =
        jsonEncode(gratitude);

    final String todayTasksJson =
        jsonEncode(todayTasks);

    final String futureGoalsJson =
        jsonEncode(futureGoals);

    final String wrongTodayJson =
        jsonEncode(wrongToday);

    final String learnedTodayJson =
        jsonEncode(learnedToday);

    // ------------------------------------------------------------------------
    // Check whether today's record already exists.
    // ------------------------------------------------------------------------

    final existing = await db.query(
      'daily_entries',
      columns: ['id'],
      where:
          'user_id = ? AND entry_date = ?',
      whereArgs: [
        userId,
        entryDate,
      ],
      limit: 1,
    );

    final Map<String, dynamic> data = {
      'user_id': userId,
      'entry_date': entryDate,
      'mood': mood,
      'gratitude': gratitudeJson,
      'today_tasks': todayTasksJson,
      'future_goals': futureGoalsJson,
      'wrong_today': wrongTodayJson,
      'learned_today': learnedTodayJson,
      'lesson': lesson,
      'updated_at':
          DateTime.now().toIso8601String(),
    };

    // ------------------------------------------------------------------------
    // UPDATE existing day
    // ------------------------------------------------------------------------

    if (existing.isNotEmpty) {
      final result = await db.update(
        'daily_entries',
        data,
        where: 'id = ?',
        whereArgs: [
          existing.first['id'],
        ],
      );

      // --------------------------------------------------------------
      // IMPORTANT
      // --------------------------------------------------------------
      //
      // If the user edits/replaces today's task list,
      // old completion indexes can become invalid.
      //
      // Example:
      //
      // Old:
      // 0 = Study
      // 1 = Exercise
      // 2 = Read
      //
      // New:
      // 0 = Work
      // 1 = Shopping
      //
      // Therefore remove completion records for indexes
      // that are no longer valid.
      // --------------------------------------------------------------

      await _cleanInvalidTaskCompletions(
        db: db,
        userId: userId,
        entryDate: entryDate,
        taskCount: todayTasks.length,
      );

      return result;
    }

    // ------------------------------------------------------------------------
    // INSERT new day
    // ------------------------------------------------------------------------

    final result = await db.insert(
      'daily_entries',
      data,
    );

    return result;
  }

  // ==========================================================================
  // GET TODAY / TO-DO
  // ==========================================================================

  Future<Map<String, dynamic>?> getTodayEntry({
    required int userId,
    required String entryDate,
  }) async {
    final db = await database;

    final result = await db.query(
      'daily_entries',
      where:
          'user_id = ? AND entry_date = ?',
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
  // TASK COMPLETION
  // ==========================================================================

  Future<void> setTaskCompleted({
    required int userId,
    required String entryDate,
    required int taskIndex,
    required bool completed,
  }) async {
    final db = await database;

    await db.insert(
      'task_completion',
      {
        'user_id': userId,
        'entry_date': entryDate,
        'task_index': taskIndex,
        'completed': completed ? 1 : 0,
      },
      conflictAlgorithm:
          ConflictAlgorithm.replace,
    );
  }

  // ==========================================================================
  // GET COMPLETED TASK INDEXES
  // ==========================================================================

  Future<List<int>> getCompletedTaskIndexes({
    required int userId,
    required String entryDate,
  }) async {
    final db = await database;

    final result = await db.query(
      'task_completion',
      columns: [
        'task_index',
      ],
      where: '''
        user_id = ?
        AND entry_date = ?
        AND completed = 1
      ''',
      whereArgs: [
        userId,
        entryDate,
      ],
      orderBy: 'task_index ASC',
    );

    return result
        .map(
          (row) => int.parse(
            row['task_index'].toString(),
          ),
        )
        .toList();
  }

  // ==========================================================================
  // CHECK SINGLE TASK STATUS
  // ==========================================================================

  Future<bool> isTaskCompleted({
    required int userId,
    required String entryDate,
    required int taskIndex,
  }) async {
    final db = await database;

    final result = await db.query(
      'task_completion',
      columns: [
        'completed',
      ],
      where: '''
        user_id = ?
        AND entry_date = ?
        AND task_index = ?
      ''',
      whereArgs: [
        userId,
        entryDate,
        taskIndex,
      ],
      limit: 1,
    );

    if (result.isEmpty) {
      return false;
    }

    return result.first['completed'] == 1;
  }

  // ==========================================================================
  // DELETE TASK COMPLETION
  // ==========================================================================

  Future<int> deleteTaskCompletion({
    required int userId,
    required String entryDate,
    required int taskIndex,
  }) async {
    final db = await database;

    return await db.delete(
      'task_completion',
      where: '''
        user_id = ?
        AND entry_date = ?
        AND task_index = ?
      ''',
      whereArgs: [
        userId,
        entryDate,
        taskIndex,
      ],
    );
  }

  // ==========================================================================
  // DELETE ALL COMPLETIONS FOR A DAY
  // ==========================================================================

  Future<int> clearTaskCompletions({
    required int userId,
    required String entryDate,
  }) async {
    final db = await database;

    return await db.delete(
      'task_completion',
      where: '''
        user_id = ?
        AND entry_date = ?
      ''',
      whereArgs: [
        userId,
        entryDate,
      ],
    );
  }

  // ==========================================================================
  // CLEAN INVALID COMPLETION RECORDS
  // ==========================================================================

  Future<void> _cleanInvalidTaskCompletions({
    required Database db,
    required int userId,
    required String entryDate,
    required int taskCount,
  }) async {
    await db.delete(
      'task_completion',
      where: '''
        user_id = ?
        AND entry_date = ?
        AND task_index >= ?
      ''',
      whereArgs: [
        userId,
        entryDate,
        taskCount,
      ],
    );
  }

  // ==========================================================================
  // JOURNAL
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

    final now =
        DateTime.now().toIso8601String();

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

  // ==========================================================================
  // GET JOURNAL ENTRIES
  // ==========================================================================

  Future<List<Map<String, dynamic>>>
      getJournalEntries({
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

  // ==========================================================================
  // DELETE JOURNAL ENTRY
  // ==========================================================================

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
}