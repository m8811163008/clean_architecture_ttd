import 'dart:convert';

import 'package:clean_architecture_ttd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../fixtures/fixture_reader.dart';

void main() {
  //create variable which we need it for this test
  //create expected variables
  const NumberTriviaModel tNumberTrivia =
      NumberTriviaModel(text: 'test text', number: 1);

  test('Should NumberTrivia model is subclass of NumberTrivia entity',
      () async {
    //arrange
    //act
    //assert
    expect(tNumberTrivia, isA<NumberTrivia>());
  });

  group('from json', () {
    test('It should return valid model when json number is an integer',
        () async {
      //arrange test
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      //act
      final NumberTriviaModel result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, equals(tNumberTrivia)); // we can skip equals
    });
    test(
        'It should return valid model when json number is regarded as a double',
        () async {
      //arrange test
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));
      //act
      final NumberTriviaModel result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, equals(tNumberTrivia)); // we can skip equals
    });
  });
  group('to json', () {
    test('should return a valid json', () async {
      //arrange
      //act
      Map<String, dynamic> result = tNumberTrivia.toJson();
      final matcherJson = {"text": "test text", "number": 1};
      //assert
      expect(result, matcherJson);
    });
  });
}
