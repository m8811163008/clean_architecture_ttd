import 'package:bloc/bloc.dart';
import 'package:clean_architecture_ttd/core/utils/input_converter.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

//localize error codes
const String invalidInput = 'Invalid input';
const String serverFailure = 'Server failure';
const String cacheFailure = 'Cache failure';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  //create use cases variable and depend on it and input converter
  late final GetConcreteNumberTrivia getConcreteNumberTrivia;
  late final GetRandomNumberTrivia getRandomNumberTrivia;
  late final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if (event is GetTriviaForConcreteNumber) {
        emit(Loading());

        ///Format string from presentation layer from event
        final Either<Failure, int> formatStringEither =
            inputConverter.stringToUnsignedInteger(event.numberString);

        /// emit loading when getting data of number trivia

        /// after getting numberTriviaStateFromFormatStringEither then emit it

        await formatStringEither.fold(
          (failure) {
            emit(const Error(errorMessage: invalidInput));
          },
          (integer) async {
            final Either<Failure, NumberTrivia> numberTrivia =
                await getConcreteNumberTrivia.call(
                    params: Params(number: integer));
            final result = numberTrivia.fold(
              (failure) => Error(errorMessage: mapErrorToString(failure)),
              (numberTrivia) => Loaded(trivia: numberTrivia),
            );
            emit(result);
          },
        );
      } else if (event is GetTriviaForRandomNumber) {
        final Either<Failure, NumberTrivia> numberTrivia =
            await getRandomNumberTrivia.call(params: NoParams());
        final result = numberTrivia.fold(
            (failure) => Error(errorMessage: mapErrorToString(failure)),
            (numberTrivia) => Loaded(trivia: numberTrivia));
        emit(result);
      }
    });
  }

  String mapErrorToString(Failure failure) {
    if (failure is LocalFailure) {
      return serverFailure;
    } else if (failure is ServerFailure) {
      return cacheFailure;
    }
    return 'Unexpected Error';
  }
}
