import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class Breed {
  Breed(
      {@required this.name,
      @required this.subBreeds,
      @required this.imageUrl}) {
    id = Uuid().v1();
  }

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
            name: keys.elementAt(index), subBreeds: values.elementAt(index)));
  }
}
