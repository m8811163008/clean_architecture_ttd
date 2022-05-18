import 'dart:convert';

import 'package:clean_architecture_ttd/core/errors/exception.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

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

class NumberTriviaRemoteDataSourceImp implements NumberTriviaRemoteDataSource {
  final http.Client httpclient;

  NumberTriviaRemoteDataSourceImp({required this.httpclient});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String endpoint) async {
    final serverCallResult = await httpclient.get(
        Uri.parse(
          'http://numberapi.com/$endpoint',
        ),
        headers: {'Content-type': 'application/json'});
    if (serverCallResult.statusCode == 200) {
      return NumberTriviaModel.fromJson(jsonDecode(serverCallResult.body));
    } else {
      throw ServerException();
    }
  }
}
