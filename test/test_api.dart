import 'package:dogs_breeds/api.dart';
import 'package:dogs_breeds/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Breeds list should not be empty', () async {
    final api = Api();

    List<Breed> listOfBreeds = await api.getAllBreeds();
    expect(listOfBreeds, isNot(null));
    expect(listOfBreeds, isNotEmpty);
  });

  test('Sub-breeds list should not be empty', () async {
    final api = Api();

    List<Breed> listOfBreeds = await api.getAllBreeds();
    Breed breed =
        listOfBreeds.firstWhere((element) => element.subBreeds.isNotEmpty);

    List<String> subBreeds = await api.getSubBreeds(breed.name);

    expect(subBreeds, isNot(null));
    expect(subBreeds, isNotEmpty);
  });

  test('Random image should not be null', () async {
    final api = Api();

    List<Breed> listOfBreeds = await api.getAllBreeds();

    listOfBreeds.shuffle();
    Breed breed = listOfBreeds.first;

    String randomImage = await api.getBreedRandomImage(breed.name);

    expect(randomImage, isNot(null));
    expect(randomImage.contains(breed.name), true);
  });
}
