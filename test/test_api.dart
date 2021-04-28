import 'package:dio/dio.dart';
import 'package:dogs_breeds/model/api.dart';
import 'package:dogs_breeds/model/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Breeds list should not be empty', () async {
    final api = Api();

    final List<Breed> listOfBreeds = await api.getAllBreeds();
    expect(listOfBreeds, isNot(null));
    expect(listOfBreeds, isNotEmpty);
  });

  test('Sub-breeds list should not be empty', () async {
    final api = Api();

    final List<Breed> listOfBreeds = await api.getAllBreeds();
    final Breed breed =
        listOfBreeds.firstWhere((element) => element.subBreeds.isNotEmpty);

    final List<String> subBreeds = await api.getSubBreeds(breed.name);

    expect(subBreeds, isNot(null));
    expect(subBreeds, isNotEmpty);
  });

  test('Random image should not be null', () async {
    final api = Api();

    final List<Breed> listOfBreeds = await api.getAllBreeds();

    listOfBreeds.shuffle();
    final Breed breed = listOfBreeds.first;

    final String randomImage = await api.getBreedRandomImage(breed.name);

    expect(randomImage, isNot(null));
    expect(randomImage.contains(breed.name), true);
  });

  test('Post content should be returned in the response', () async {
    final api = Api();

    dynamic reponse = await api.login('enzo', '123456');

    expect(reponse, isNot(null));
    expect(reponse['name'], 'enzo');
    expect(reponse['passwd'], '123456');
  });

  test('Post with no content should also return a response', () async {
    final response = await Dio().post('https://reqres.in/api/users');
    expect(response.data, isNot(null));
    expect(response.data['id'], isNot(null));
  });
}
