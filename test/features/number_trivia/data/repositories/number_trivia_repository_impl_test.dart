//we know that Repository should take in he remote and local data source and also a network info object. lets create mocks for these dependencies straight away.
import 'package:clean_architecture_ttd/core/platform/network_info.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_ttd/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late final NumberTriviaRepositoryImpl repository;
  late final MockRemoteDataSource mockRemoteDataSource;
  late final MockLocalDataSource mockLocalDataSource;
  late final MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      numberTriviaRemoteDataSource: mockRemoteDataSource,
      numberTriviaLocalDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });
  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: 'test trivia', number: tNumber);
    const NumberTrivia tNumberTriviaEntity = tNumberTriviaModel;

    test('should check if the device is online', () async {
      //arrange mockito
      when(() async => await mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);
      //act
      repository.getConcreteNumberTrivia(tNumber);
      //assert
      verify(() async => mockNetworkInfo.isConnected);
    });
  });
}
