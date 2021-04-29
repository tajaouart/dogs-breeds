import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

import 'models.dart';

// acts as a fetcher
class BreedRepository {
  static String url = 'https://dog.ceo/api/breeds/list/all';

  final Dio _dio = Dio();

  Future<BreedResponse> getBreeds() async {
    try {
      Response response = await _dio.get(url);
      return BreedResponse.fromJson(response.data['message']);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return BreedResponse.withError("$error");
    }
  }
}

// holds the value of the bloc state
class BreedListBloc {
  final BreedRepository _breedRepository = BreedRepository();
  final BehaviorSubject<BreedResponse> _subject =
      BehaviorSubject<BreedResponse>();

  Future<void> getBreeds() async {
    BreedResponse response = (await _breedRepository.getBreeds());
    _subject.sink.add(response);
  }

  void dispose() {
    _subject.close();
  }

  BehaviorSubject<BreedResponse> get subject => _subject;
}

final breedsBloc = BreedListBloc();
