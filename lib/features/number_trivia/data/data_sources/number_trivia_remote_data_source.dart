import 'package:clean_architecture_ttd/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numberapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error code
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numberapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error code
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
