import 'dart:async';

import 'package:dogs_breeds/models.dart';
import 'package:sqflite/sqflite.dart';

class BreedDao {
  Future<Database> database;

  BreedDao(Future<Database> db) {
    database = db;
  }

  Future<void> insertAlphabet(Breed breed) async {
    await (await database).insert(
      'breeds',
      breed.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAllBreeds(List<Breed> breeds) async {
    database.then((value) {
      breeds.forEach((alphabet) {
        value.insert(
          'breeds',
          alphabet.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    });
  }

  Future<List<Breed>> findAllBreeds() async {
    // Query the table for all The breeds.
    final List<Map<String, dynamic>> maps =
        await (await database).query('breeds');

    // Convert the List<Map<String, dynamic> into a List<Breed>.
    return List.generate(maps.length, (i) {
      return Breed(
        id: maps[i]['id'].toString(),
        name: maps[i]['name'],
        imageUrl: maps[i]['imageUrl'],
        subBreeds: maps[i]['subBreeds'].toString().isEmpty
            ? []
            : maps[i]['subBreeds'].toString().split(';'),
      );
    });
  }
}
