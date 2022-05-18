import 'dart:convert';

import 'package:clean_architecture_ttd/core/errors/exception.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late final MockClient mockClient;
  late final NumberTriviaRemoteDataSourceImp sut;
  setUpAll(() {
    mockClient = MockClient();
    sut = NumberTriviaRemoteDataSourceImp(httpclient: mockClient);
  });
  void callMockClientWhenWant200StatusCode() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void callMockClientWhenWantToOtherThan200StatusCode() {
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTrivia =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    //should return something when something called
    test(
        'should call to http://numberapi.com/tNumber and check header is json when call this method',
        () async {
      //arrange //we add this test to prevent null being return in actual call
      callMockClientWhenWant200StatusCode();
      //act
      sut.getConcreteNumberTrivia(tNumber);
      //verify interactions with mockObjects
      verify(
        mockClient.get(Uri.parse('http://numberapi.com/$tNumber'),
            headers: {'Content-type': 'application/json'}),
      );
      //assert
    });
    //should return something when something called
    test(
        'should return NumberTriviaModel when get 200 response code from server',
        () async {
      //arrange
      callMockClientWhenWant200StatusCode();
      //act
      final result = await sut.getConcreteNumberTrivia(tNumber);
      //verify interactions with mockObjects

      //assert
      expect(result, tNumberTrivia);
    });

    //should return something when something called
    test('should throw a server exception when response code is not 200',
        () async {
      //arrange
      callMockClientWhenWantToOtherThan200StatusCode();
      //act
      final call = sut.getConcreteNumberTrivia;
      //verify interactions with mockObjects

      //assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });
  group('getRandomNumberTrivia', () {
    final tNumberTrivia =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    test(
        'should call to http://numberapi.com/random and check header is json when call this method',
        () async {
      //arrange //we add this test to prevent null being return in actual call
      callMockClientWhenWant200StatusCode();
      //act
      sut.getRandomNumberTrivia();
      //verify interactions with mockObjects
      verify(
        mockClient.get(Uri.parse('http://numberapi.com/random'),
            headers: {'Content-type': 'application/json'}),
      );
      //assert
    });
    //should return something when something called
    test(
        'should return NumberTriviaModel when get 200 response code from server',
        () async {
      //arrange
      callMockClientWhenWant200StatusCode();
      //act
      final result = await sut.getRandomNumberTrivia();
      //verify interactions with mockObjects

      //assert
      expect(result, tNumberTrivia);
    });

    //should return something when something called
    test('should throw a server exception when response code is not 200',
        () async {
      //arrange
      callMockClientWhenWantToOtherThan200StatusCode();
      //act
      final call = sut.getRandomNumberTrivia;
      //verify interactions with mockObjects

      //assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
