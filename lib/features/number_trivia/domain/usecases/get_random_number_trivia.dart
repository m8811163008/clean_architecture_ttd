import 'package:clean_architecture_ttd/core/errors/failure.dart';
import 'package:clean_architecture_ttd/core/usecases/usecase.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia extends Usecase<NumberTrivia, NoParams> {
  NumberTriviaRepository repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call({required NoParams params}) {
    return repository.getRandomNumberTrivia();
  }
}
