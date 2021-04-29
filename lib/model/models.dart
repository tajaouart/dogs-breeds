import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class BreedResponse {
  final List<Breed> breeds;
  final String error;

  BreedResponse(this.breeds, this.error);

  BreedResponse.fromJson(Map<String, dynamic> map)
      : breeds = List<Breed>.generate(
            map.keys.length,
            (int index) => Breed(
                id: Uuid().v1(),
                name: map.keys.elementAt(index),
                subBreeds: map.values.elementAt(index))),
        error = "";

  BreedResponse.withError(String errorValue)
      : breeds = [],
        error = errorValue;
}

class Breed {
  Breed(
      {@required this.id,
      @required this.name,
      @required this.subBreeds,
      // not required because imageUrl will be fetched separately
      this.imageUrl});

  String id;
  String name;
  String imageUrl;
  List<dynamic> subBreeds;

  // needed for db dao
  Map<String, dynamic> toMap() {
    return <String, String>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'subBreeds': subBreeds.join(';'),
    };
  }
}
