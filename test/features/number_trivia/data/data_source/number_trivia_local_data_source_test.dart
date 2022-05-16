import 'dart:convert';

import 'package:clean_architecture_ttd/core/errors/exception.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late NumberTriviaLocalDataSourceImpl uut;
  late MockSharedPreferences mockSharedPreferences;
  final tNumberTrivia =
      NumberTriviaModel.fromJson(jsonDecode(fixture('cached_trivia.json')));
  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    uut = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });
  group('getLastNumber', () {
    //should return something when something called
    test('should return NumberTriviaEntity when there is one in the cache',
        () async {
      //arrange mocked or fixtures
      when(mockSharedPreferences.getString(any))
          .thenAnswer((_) => fixture('cached_trivia.json'));
      //act
      final NumberTriviaModel result = await uut.getLastNumber();
      //verify interactions with mockObjects
      verify(mockSharedPreferences.getString(cachedNumberTrivia));

      //assert
      expect(result, equals(tNumberTrivia));
    });
    //should return something when something called
    test('should throw CachedException when there is no data in cache',
        () async {
      //arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      //act
      final call = uut.getLastNumber;
      //verify interactions with mockObjects
      //we verify  interaction in last test so we don't need it in this test
      //assert
      //we expect when we call this higher order function inside call variable it throw a CacheException
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });
  group('cacheNumberTrivia', () {
    //we could use json to generate triviaToCache but we have should keep ourself close to method definitions which required a NumberTriviaModel
    const triviaToCache = NumberTriviaModel(text: 'test text', number: 1);

    test(
        'should cached numberTrivia converted to json String when called this method',
        () async {
      //arrange
      when(mockSharedPreferences.setString(any, any))
          .thenAnswer((realInvocation) async => true);
      //act
      uut.cacheNumberTrivia(triviaToCache);
      final jsonString = jsonEncode(triviaToCache.toJson());
      //verify interactions with mockObjects
      verify(mockSharedPreferences.setString(cachedNumberTrivia, jsonString));
      //assert
    });
  });
}
