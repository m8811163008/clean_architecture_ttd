import '../models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  /// the user had an internet connection
  ///
  /// Throws [NoLocalDataException] if no catch data is present.
  Future<NumberTriviaModel> getLastNumber();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
