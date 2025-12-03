import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDatabase() async {
  final dbPath = await sql.getDatabasesPath();

  return await sql.openDatabase(
    path.join(dbPath, 'meals.db'),
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE user_meals(id TEXT , name TEXT, image TEXT, time TEXT, price TEXT, ingredients TEXT, steps TEXT)',
      );

      await db.execute('CREATE TABLE favorite_meals(id TEXT PRIMARY KEY)');
    },
  );
}
