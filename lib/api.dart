import 'package:dio/dio.dart';
import 'package:dogs_breeds/models.dart';

class Api {
  int value = 0;

  Future<List<Breed>> getAllBreeds() async {
    try {
      final response = await Dio().get('https://dog.ceo/api/breeds/list/all');
      List<Breed> breeds = Breed.fromMap(response.data['message']);

      return breeds;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<String>> getSubBreeds(String breed) async {
    try {
      final response = await Dio().get('https://dog.ceo/api/breed/$breed/list');
      List<String> subBreeds = response.data['message'].cast<String>();
      return subBreeds;
    } catch (e) {
      print(e);
    }
    return <String>[];
  }

  Future<String> getBreedRandomImage(String breed) async {
    try {
      final response =
          await Dio().get('https://dog.ceo/api/breed/$breed/images/random');
      String randomImage = response.data['message'] as String;
      return randomImage;
    } catch (e) {
      print(e);
    }
    return '';
  }

  Future<dynamic> login(String name, String passwd) async {
    try {
      final response = await Dio().post('https://reqres.in/api/users',
          data: {'name': name, 'passwd': passwd});
      return response.data;
    } catch (e) {
      print(e);
    }
  }
}
