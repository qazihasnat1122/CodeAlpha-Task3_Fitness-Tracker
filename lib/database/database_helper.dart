// lib/database/database_helper.dart
// SQLite database helper using the Singleton pattern.
// Handles all CRUD operations for the fitness_activity table.

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path_helper;

import '../models/fitness_activity.dart';

class DatabaseHelper {
  // --- Singleton Setup ---
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // --- Database Constants ---
  static const String _databaseName = 'fitness_tracker.db';
  static const int _databaseVersion = 1;

  static const String _tableName = 'fitness_activity';
  static const String _colId = 'id';
  static const String _colExerciseType = 'exerciseType';
  static const String _colDuration = 'duration';
  static const String _colCalories = 'calories';
  static const String _colDate = 'date';

  // --- Database Access ---

  /// Returns the singleton database instance, initializing if needed.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Opens/creates the SQLite database file.
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final fullPath = path_helper.join(dbPath, _databaseName);

    return await openDatabase(
      fullPath,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Called once when the database is first created.
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        $_colId       INTEGER PRIMARY KEY AUTOINCREMENT,
        $_colExerciseType TEXT    NOT NULL,
        $_colDuration     INTEGER NOT NULL,
        $_colCalories     INTEGER NOT NULL,
        $_colDate         TEXT    NOT NULL
      )
    ''');
  }

  /// Called when the database version is bumped (future migrations).
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Reserved for future schema migrations.
  }

  // =========================================================
  // CRUD OPERATIONS
  // =========================================================

  /// Inserts a new activity and returns the auto-generated row ID.
  Future<int> insertActivity(FitnessActivity activity) async {
    final db = await database;
    return await db.insert(
      _tableName,
      activity.toMap()..remove('id'), // Let SQLite auto-assign id
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Returns all activities ordered by date descending (newest first).
  Future<List<FitnessActivity>> getAllActivities() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      orderBy: '$_colDate DESC',
    );
    return maps.map((m) => FitnessActivity.fromMap(m)).toList();
  }

  /// Returns all activities for a specific date (date-only comparison).
  Future<List<FitnessActivity>> getActivitiesForDate(DateTime date) async {
    final db = await database;
    // Store date as ISO string; compare prefix "yyyy-MM-dd"
    final datePrefix = '${date.year.toString().padLeft(4, '0')}'
        '-${date.month.toString().padLeft(2, '0')}'
        '-${date.day.toString().padLeft(2, '0')}';

    final maps = await db.query(
      _tableName,
      where: "$_colDate LIKE ?",
      whereArgs: ['$datePrefix%'],
    );
    return maps.map((m) => FitnessActivity.fromMap(m)).toList();
  }

  /// Returns all activities between [startDate] and [endDate] inclusive.
  Future<List<FitnessActivity>> getActivitiesForDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final start = startDate.toIso8601String();
    // End of day: add 1 day and subtract 1ms
    final end = endDate
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1))
        .toIso8601String();

    final maps = await db.query(
      _tableName,
      where: "$_colDate BETWEEN ? AND ?",
      whereArgs: [start, end],
      orderBy: '$_colDate ASC',
    );
    return maps.map((m) => FitnessActivity.fromMap(m)).toList();
  }

  /// Updates an existing activity. Returns number of rows affected.
  Future<int> updateActivity(FitnessActivity activity) async {
    assert(activity.id != null, 'Cannot update an activity without an id');
    final db = await database;
    return await db.update(
      _tableName,
      activity.toMap(),
      where: '$_colId = ?',
      whereArgs: [activity.id],
    );
  }

  /// Deletes an activity by its ID. Returns number of rows deleted.
  Future<int> deleteActivity(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: '$_colId = ?',
      whereArgs: [id],
    );
  }

  /// Closes the database connection (call only when app terminates).
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
