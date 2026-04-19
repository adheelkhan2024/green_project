import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._();
  DatabaseService._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    final path = join(await getDatabasesPath(), 'sustainable_campus.db');
    _database = await openDatabase(path, version: 1, onCreate: _create);
    return _database!;
  }

  Future<void> _create(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        role TEXT NOT NULL,
        passwordHash TEXT NOT NULL,
        salt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE projects(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        status TEXT NOT NULL,
        progress INTEGER NOT NULL,
        category TEXT NOT NULL,
        startDate TEXT NOT NULL,
        dueDate TEXT NOT NULL,
        createdBy TEXT NOT NULL,
        location TEXT NOT NULL,
        budget REAL NOT NULL,
        estimatedCo2Reduction REAL NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE team_members(
        id TEXT PRIMARY KEY,
        projectId TEXT NOT NULL,
        name TEXT NOT NULL,
        role TEXT NOT NULL,
        contribution TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE project_documents(
        id TEXT PRIMARY KEY,
        projectId TEXT NOT NULL,
        fileName TEXT NOT NULL,
        filePath TEXT NOT NULL,
        uploadedAt TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE notifications(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        read INTEGER NOT NULL
      )
    ''');
  }
}