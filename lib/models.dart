import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

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

  static List<Breed> fromMap(Map<String, dynamic> map) {
    Iterable<dynamic> keys = map.keys;
    Iterable<dynamic> values = map.values;
    return List<Breed>.generate(
        map.keys.length,
        (int index) => Breed(
            id: Uuid().v1(),
            name: keys.elementAt(index),
            subBreeds: values.elementAt(index)));
  }

  Map<String, dynamic> toMap() {
    return <String, String>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'subBreeds': subBreeds.join(';'),
    };
  }
}
