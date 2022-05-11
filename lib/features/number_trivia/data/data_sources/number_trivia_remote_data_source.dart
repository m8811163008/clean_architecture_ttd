import 'package:clean_architecture_ttd/core/platform/network_info.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  NetworkInfo networkInfo;

  NumberTriviaRemoteDataSource(
      {required this.numberTriviaRemoteDataSource,
      required this.numberTriviaLocalDataSource,
      required this.networkInfo});

  /// Calls the http://numberapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error code
  Future<NumberTriviaModel> getConcreteNumberTrivia();

  /// Calls the http://numberapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error code
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
