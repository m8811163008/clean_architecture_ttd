import 'package:clean_architecture_ttd/core/errors/exception.dart';
import 'package:clean_architecture_ttd/core/errors/failure.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/platform/network_info.dart';
import '../data_sources/number_trivia_local_data_source.dart';
import '../data_sources/number_trivia_remote_data_source.dart';
import '../models/number_trivia_model.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  NumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  NumberTriviaLocalDataSource numberTriviaLocalDataSource;
  NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.numberTriviaRemoteDataSource,
      required this.numberTriviaLocalDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    if (await networkInfo.isConnected) {
      try {
        final NumberTriviaModel result =
            await numberTriviaRemoteDataSource.getConcreteNumberTrivia(number);
        numberTriviaLocalDataSource.cacheNumberTrivia(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Right(await numberTriviaLocalDataSource.getLastNumber());
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
