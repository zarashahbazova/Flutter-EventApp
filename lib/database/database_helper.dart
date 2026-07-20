import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/user.dart';

class DatabaseHelper {

  static final DatabaseHelper instance =
      DatabaseHelper._init();

  DatabaseHelper._init();

  static Database? _database;

  Future<Database> get database async {

  if (_database != null) {
    return _database!;
  }

  _database = await _initDB("users.db");

  return _database!;
}

Future<Database> _initDB(String fileName) async {

  final dbPath = await getDatabasesPath();

  final path = join(dbPath, fileName);

  return await openDatabase(

    path,

    version: 1,

    onCreate: _createDB,

  );
}

Future _createDB(Database db, int version) async {

  await db.execute("""

CREATE TABLE users(

id INTEGER PRIMARY KEY AUTOINCREMENT,

fullName TEXT NOT NULL,

username TEXT NOT NULL UNIQUE,

email TEXT NOT NULL UNIQUE,

password TEXT NOT NULL

)

""");

}

Future<int> createUser(User user) async {

  final db = await instance.database;

  return await db.insert(
    "users",
    user.toMap(),
  );

}

Future<User?> getUserByUsername(
    String username,
) async {

  final db = await instance.database;

  final result = await db.query(

    "users",

    where: "username = ?",

    whereArgs: [username],

  );

  if (result.isNotEmpty) {

    return User.fromMap(result.first);

  }

  return null;

}

Future<void> printUsers() async {
  final db = await database;

  final users = await db.query("users");

  print(users);
}

Future<User?> login(

  String username,
  String password,

) async {
  await DatabaseHelper.instance.printUsers();
  final db = await instance.database;

  print("LOGIN -> username: $username");
  print("LOGIN -> password: $password");

  final result = await db.query(
    "users",
    where: "username = ? AND password = ?",
    whereArgs: [username, password],
  );

  print(result);

  if (result.isNotEmpty) {
    return User.fromMap(result.first);
  }

  return null;
}}