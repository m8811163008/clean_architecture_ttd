import 'package:clean_architecture_ttd/core/errors/failure.dart';
import 'package:clean_architecture_ttd/core/usecases/usecase.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcreteNumberTrivia implements Usecase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);
  @override
  Future<Either<Failure, NumberTrivia>> call({required Params params}) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

/// to be more clean create some data holder named Param
/// It is for all of the use cases
/// and Params class holds the all parameters for the call method
/// for now it is only a int number
class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
