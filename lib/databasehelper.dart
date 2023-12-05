import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:storytime/User.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        email TEXT,
        password TEXT
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<List<User>> getAllUsers() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (index) => User.fromMap(maps[index]));
  }

  Future<User?> getUserByEmail(String email) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isEmpty) {
      return null;
    }

    return User.fromMap(maps.first);
  }


  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (maps.isEmpty) {
      return null;
    }

    return User.fromMap(maps.first);
  }
}
