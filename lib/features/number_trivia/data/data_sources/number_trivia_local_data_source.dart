import 'dart:convert';

import 'package:clean_architecture_ttd/core/errors/exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection
  ///
  /// Throws [NoLocalDataException] if no catch data is present.
  Future<NumberTriviaModel> getLastNumber();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

//in refactor phase use const instead of hard code
const cachedNumberTrivia = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    final jsonString = jsonEncode(triviaToCache.toJson());
    return sharedPreferences.setString(cachedNumberTrivia, jsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumber() {
    String? cachedNumberJson = sharedPreferences.getString(cachedNumberTrivia);
    if (cachedNumberJson != null) {
      return Future.value(
          NumberTriviaModel.fromJson(jsonDecode(cachedNumberJson)));
    } else {
      throw CacheException();
    }
  }
}
