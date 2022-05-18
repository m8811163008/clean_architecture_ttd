//mocks useCases and converters

import 'package:bloc_test/bloc_test.dart';
import 'package:clean_architecture_ttd/core/utils/input_converter.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_ttd/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:clean_architecture_ttd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late NumberTriviaBloc sut;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  const String tNumberString = '1';
  const int tNumberParsed = 1;
  const NumberTrivia tNumberTrivia =
      NumberTrivia(text: 'test trivia', number: 1);
  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    sut = NumberTriviaBloc(
        concrete: mockGetConcreteNumberTrivia,
        random: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);

    //bloc emit state , one of state[Empty, Loaded, Loading, Error] which is Loaded emits NumberTrivia

    when(mockGetConcreteNumberTrivia.call(params: anyNamed('params')))
        .thenAnswer((_) async => const Right(tNumberTrivia));
  });

  //first thing is that bloc emits its initial state
  group('NumberTriviaBloc', () {
    test('initial value is empty', () {
      expect(sut.state, Empty());
    });
  });
  //test events
  group('GetTriviaForConcreteNumber', () {
    //the first thing that should happen when this GetTriviaForConcreteNumber event is dispatch from ui will be that the bloc should call input converter that validate and convert string to unsigned integer
    blocTest('should call input converter to validate input',
        build: () => sut,
        setUp: () {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(const Right(tNumberParsed));
        },
        act: (NumberTriviaBloc bloc) =>
            bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        verify: (NumberTriviaBloc bloc) =>
            bloc.inputConverter.stringToUnsignedInteger(tNumberString));

    blocTest('bloc should emit [Error] when the input is invalid',
        build: () => sut,
        setUp: () {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(Left(InvalidInputFailure()));
        },
        act: (NumberTriviaBloc bloc) =>
            bloc.add(const GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [const Error(errorMessage: invalidInput)]);

    blocTest('should get data from concrete use case',
        setUp: () {
          when(mockInputConverter.stringToUnsignedInteger(any))
              .thenReturn(const Right(tNumberParsed));
        },
        build: () => sut,
        act: (NumberTriviaBloc bloc) => bloc.add(
              const GetTriviaForConcreteNumber(tNumberString),
            ),
        verify: (NumberTriviaBloc bloc) {
          bloc.getConcreteNumberTrivia(
              params: const Params(number: tNumberParsed));
        });

    blocTest(
      'should emit [Loading, Loaded()] when data gotten successfully',
      build: () => sut,
      setUp: () {
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
      },
      expect: () => [Loading(), const Loaded(trivia: tNumberTrivia)],
      act: (NumberTriviaBloc bloc) => bloc.add(
        const GetTriviaForConcreteNumber(tNumberString),
      ),
    );
  });
}
