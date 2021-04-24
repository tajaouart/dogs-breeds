import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'breed_dao.dart';

class AppDatabase {
  Future<Database> database;
  AppDatabase(String s) {
    database = openDatabase(
      join(s, 'breeds_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE breeds(id TEXT PRIMARY KEY," +
              " name TEXT, imageUrl TEXT, subBreeds TEXT);",
        );
      },
      version: 1,
    );
  }

  BreedDao get breedDao => BreedDao(database);
}
