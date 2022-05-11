import 'package:clean_architecture_ttd/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

///We use use case abstract class to prevent forgetting methods names
/// we specify Type as outPut of usecases and Params as input in case of implementing some sort of log
/// and passed in arguments which was called
/// `Future<Either<Failure, type> call(Params params) { debugPrint(params.toString()); }`
abstract class Usecase<Type, Params> {
  /// use call to create callable class which we can use ClassName() or ClassName.call()
  Future<Either<Failure, Type>> call({required Params params});
}

/// for useCases with no parameters such getRandomNumberTrivia
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
