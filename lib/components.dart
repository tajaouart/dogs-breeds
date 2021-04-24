import 'package:dio/dio.dart';
import 'package:dogs_breeds/api.dart';
import 'package:dogs_breeds/models.dart';
import 'package:flutter/foundation.dart';

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
  List<Breed> breeds;

  Future<void> fetchBreeds() async {
    breeds = await BreedService.getBreedsList();
    notifyListeners();
  }
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
