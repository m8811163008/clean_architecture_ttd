part of 'number_trivia_bloc.dart';

//TODO: Naming convention
abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
  //never put logic inside classes where it doesn't belong

}

//we have 2 use case or event in our app so we create for them 2 class event
class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  //we have one state which is String and we don't put logic inside event and put
  //logic inside business logic section
  /// We get number string in form of String so we pass it as it is and handle formatting inside
  /// business logic or domain layer or core layer for later uses
  final String numberString;

  const GetTriviaForConcreteNumber(this.numberString);

  @override
  List<Object?> get props => [numberString];
}

//add class for another use case
class GetTriviaForRandomNumber extends NumberTriviaEvent {
  @override
  List<Object?> get props => [];
}
