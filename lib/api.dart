import 'package:dio/dio.dart';
import 'package:dogs_breeds/models.dart';

class Api {
  int value = 0;

  Future<List<Breed>> getAllBreeds() async {
    try {
      var response = await Dio().get('https://dog.ceo/api/breeds/list/all');
      List<Breed> breeds = Breed.fromMap(response.data["message"]);
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
}
