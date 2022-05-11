import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<dynamic> get props => const <dynamic>[];
}

//the repository will catch the Exceptions and
//return them using Either type as Failures.
//For this reason, Failure types usually exactly map to Exception type
class ServerFailure extends Failure {}

class LocalFailure extends Failure {}
