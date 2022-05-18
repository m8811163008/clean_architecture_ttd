//we create class which can be mocked like abstracts classes in test
//we are gonna mock this class
//It is like model is responsible for shielding the domain layer from the influence of remote API
// and json , input converter is like shield layer for domain for input conversion
//domain layer doesn't care the number is string, and this class should convert it or care about
// int numbers
//This kinds of classes lives in edge of layers
// This class is actually a presentation layer class
import 'package:dartz/dartz.dart';

import '../errors/failure.dart';

class InputConverter {
  // This class have only one method which return Either
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      final int result = int.parse(str);
      if (result < 0) throw const FormatException();
      return Right(result);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
