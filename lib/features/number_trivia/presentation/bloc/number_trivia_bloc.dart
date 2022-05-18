import 'package:bloc/bloc.dart';
import 'package:clean_architecture_ttd/core/utils/input_converter.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/failure.dart';
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
      {required concrete, required random, required this.inputConverter})
      : assert(concrete != null),
        assert(random != null),
        getRandomNumberTrivia = random,
        getConcreteNumberTrivia = concrete,
        super(Empty()) {
    on<NumberTriviaEvent>((event, emit) {
      if (event is GetTriviaForConcreteNumber) {
        ///Format string from presentation layer from event
        final Either<Failure, int> formatStringEither =
            inputConverter.stringToUnsignedInteger(event.numberString);

        /// emit loading when getting data of number trivia

        /// after getting numberTriviaStateFromFormatStringEither then emit it

        formatStringEither.fold(
          (failure) {
            emit(const Error(errorMessage: invalidInput));
          },
          (integer) async {
            emit(Loading());
            final Either<Failure, NumberTrivia> numberTrivia =
                await getConcreteNumberTrivia.call(
                    params: Params(number: integer));
            final result = numberTrivia.fold(
                (failure) => const Error(errorMessage: serverFailure),
                (numberTrivia) => Loaded(trivia: numberTrivia));
            emit(result);
          },
        );
        // final FutureOr<NumberTriviaState> result = either.fold(
        //   (failure) => const Error(errorMessage: invalidInput),
        //   (integer) async {
        //     final Either<Failure, NumberTrivia> getConcreteResult =
        //         await getConcreteNumberTrivia.call(
        //             params: Params(number: integer));
        //     final NumberTriviaState resultEvent = getConcreteResult.fold(
        //       (failure) => const Error(errorMessage: serverFailure),
        //       (numberTrivia) => Loaded(
        //         trivia: numberTrivia,
        //       ),
        //     );
        //   },
        // );
        // emit(await result);
      }
    });
  }
}
