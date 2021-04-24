import 'package:dio/dio.dart';
import 'package:dogs_breeds/components.dart';
import 'package:dogs_breeds/models.dart';

class Api {
  int value = 0;

  Future<List<Breed>> getAllBreeds() async {
    try {
      var response = await Dio().get('https://dog.ceo/api/breeds/list/all');
      List<Breed> breeds = Breed.fromMap(response.data["message"]);
      for (final Breed breed in breeds) {
        breed.imageUrl = await getImageUrl(breed.name);
      }
      print(response);
      return breeds;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<String>> getSubBreeds(String beerd) async {
    try {
      var response = await Dio().get('https://dog.ceo/api/breed/$beerd/list');
      List<String> subBreeds = response.data["message"].cast<String>();
      print(response);
      return subBreeds;
    } catch (e) {
      print(e);
    }
  }

  Future<String> getBreedRandomImage(String beerd) async {
    try {
      var response =
          await Dio().get('https://dog.ceo/api/breed/$beerd/images/random');
      String randomImage = response.data["message"] as String;
      print(response);
      return randomImage;
    } catch (e) {
      print(e);
    }
  }
}
