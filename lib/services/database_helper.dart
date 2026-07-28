import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pour n'avoir qu'une seule instance de la base de données
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Création de la base de données
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'kh_support.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Création des tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        role TEXT,
        token TEXT,
        last_sync TEXT
      )
    ''');
  }

  // ✅ SAUVEGARDER L'UTILISATEUR (Après connexion réussie)
  Future<void> saveUserLocally(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'name': userData['name'] ?? '',
        'email': userData['email'] ?? '',
        'role': userData['role'] ?? 'user',
        'token': userData['token'] ?? '',
        'last_sync': DateTime.now().toString(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ LIRE L'UTILISATEUR (Pour connexion hors-ligne)
  Future<Map<String, dynamic>?> getLocalUser(String email) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  // ✅ SUPPRIMER TOUT (Lors de la déconnexion)
  Future<void> clearLocalData() async {
    final db = await database;
    await db.delete('users');
  }
}