//we know that Repository should take in he remote and local data source and also a network info object. lets create mocks for these dependencies straight away.
import 'package:clean_architecture_ttd/core/errors/exception.dart';
import 'package:clean_architecture_ttd/core/errors/failure.dart';
import 'package:clean_architecture_ttd/core/platform/network_info.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

// @GenerateMocks([], customMocks: [
//   MockSpec<NumberTriviaRemoteDataSource>(returnNullOnMissingStub: true)
// ])
@GenerateMocks([NumberTriviaRemoteDataSource])
@GenerateMocks([NumberTriviaLocalDataSource])
@GenerateMocks([NetworkInfo])
void main() {
  late final NumberTriviaRepositoryImpl repository;
  late final MockNumberTriviaRemoteDataSource mockRemoteDataSource;
  late final MockNumberTriviaLocalDataSource mockLocalDataSource;
  late final MockNetworkInfo mockNetworkInfo;

  const tNumber = 1;
  const tNumberTriviaModel =
      NumberTriviaModel(text: 'test trivia', number: tNumber);
  const NumberTrivia tNumberTriviaEntity = tNumberTriviaModel;
  setUpAll(() {
    mockRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      numberTriviaRemoteDataSource: mockRemoteDataSource,
      numberTriviaLocalDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group(
      'should return NumberTriviaEntity when call repository.getConcreteNumberTrivia',
      () {
    test('should check if the device is online', () {
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);

      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getConcreteNumberTrivia(tNumber);
      // assert
      verify(mockNetworkInfo.isConnected);
    });
    test(
        'should return remote data when call to remote data source is successful',
        () async {
      //arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      final result = await repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      expect(result, equals(const Right(tNumberTriviaEntity)));
    });

    test(
        'should store result in local data source when call to remote data source successful',
        () async {
      //arrange
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
    });
  }, skip: true);
  group(
      'should return serverFailure when call repository.getConcreteNumberTrivia',
      () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getConcreteNumberTrivia(any))
          .thenThrow(ServerException());
    });
    test(
        'should return ServerFailure when call to remote data source is unsuccessful',
        () async {
      //arrange

      //act
      final result = await repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
      verifyZeroInteractions(mockLocalDataSource);
      expect(result, Left(ServerFailure()));
    });
  }, skip: true);
  group('when device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });
    test('should return last cached data when the cache data is present',
        () async {
      //arrange
      when(mockLocalDataSource.getLastNumber())
          .thenAnswer((_) async => tNumberTriviaModel);
      //act
      final result = await repository.getConcreteNumberTrivia(tNumber);
      //assert
      verifyZeroInteractions(mockRemoteDataSource);
      verify(mockLocalDataSource.getLastNumber());
      expect(result, const Right(tNumberTriviaEntity));
    });
  });
}
