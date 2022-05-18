import 'package:clean_architecture_ttd/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  //We don't mock input converter because it doesn't have any dependency
  //just want to have only a instance
  late final InputConverter inputConverter;
  setUpAll(() {
    inputConverter = InputConverter();
  });
  group('stringToUnsignedInteger', () {
    //should return something when something called
    test(
        'should return an integer when the string represent an unsigned integer',
        () async {
      //arrange
      String tNumber = '1';
      //act
      final result = inputConverter.stringToUnsignedInteger(tNumber);
      //verify interactions with mockObjects

      //assert
      expect(result, const Right(1));
    });

    //should return something when something called
    test('should return InvalidInputFailure when calls with unvalid string',
        () async {
      //arrange
      String tInvalidNumber = '1abc';
      //act
      final result = inputConverter.stringToUnsignedInteger(tInvalidNumber);
      //verify interactions with mockObjects

      //assert
      expect(result, Left(InvalidInputFailure()));
    });
    test('should return InvalidInputFailure when calls with negative string',
        () async {
      //arrange
      String tNegativeNumber = '-1';
      //act
      final result = inputConverter.stringToUnsignedInteger(tNegativeNumber);
      //verify interactions with mockObjects

      //assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
