part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

///for empty response
class Empty extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

///for loading state
class Loading extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  const Loaded({required this.trivia});

  @override
  List<Object> get props => [trivia];
}

// for invalid input , cache exception or remote exception
class Error extends NumberTriviaState {
  final String errorMessage;

  const Error({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
