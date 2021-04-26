import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dogs_breeds/api.dart';
import 'package:dogs_breeds/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sqflite/sqflite.dart';

import 'dao/database.dart';

class BreedService {
  static Future<List<Breed>> getBreedsList() async {
    final List<Breed> listBreeds = await Api().getAllBreeds();

    if (listBreeds.isNotEmpty) {
      return listBreeds;
    } else {
      throw Exception('Failed to load Breeds from Server');
    }
  }
}

class BreedViewModel extends ChangeNotifier {
  List<Breed> listBreeds;

  Future<void> fetchBreeds(_preferences) async {
    if (!(_preferences.getBool('data_is_loaded') ?? false)) {
      try {
        AppDatabase database = AppDatabase(await getDatabasesPath());
        var breeds = await BreedService.getBreedsList();
        final breedDao = database.breedDao;
        breedDao.insertAllBreeds(breeds);
        _preferences.setBool("data_is_loaded", true);
        listBreeds = breeds;
        notifyListeners();
      } on TimeoutException catch (_) {
        listBreeds = null;
      } on SocketException catch (_) {
        listBreeds = null;
      }
    } else {
      listBreeds = await findAllBreeds();
      notifyListeners();
    }
  }
}

Future<List<Breed>> findAllBreeds() async {
  AppDatabase database = AppDatabase(await getDatabasesPath());
  final questionDao = database.breedDao;
  return await questionDao.findAllBreeds();
}

Future<String> getImageUrl(String breedName) async {
  try {
    var response =
        await Dio().get('https://dog.ceo/api/breed/$breedName/images/random');
    return response.data["message"] as String;
  } catch (e) {
    print(e);
    return "";
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach =>
      this.split(" ").map((str) => str.capitalize).join(" ");
}

Widget displayShimmmer(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300],
    highlightColor: Colors.grey[100],
    child: Padding(
      padding: EdgeInsets.all(0),
      child: GridView.count(
        padding: EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 24.0,
        mainAxisSpacing: 24.0,
        children: [
          for (var i = 20; i >= 1; i--)
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.width * 0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(3)),
                      child: Container(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 8),
                    child: Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.black,
                      child: Center(),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    ),
  );
}
