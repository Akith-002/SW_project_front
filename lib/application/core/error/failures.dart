import 'package:equatable/equatable.dart';



abstract class Failure extends Equatable {
  const Failure([List properties = const <dynamic>[]]);

  @override
  List<Object> get props => props;
}

// General failures
class ServerFailure extends Failure {
  //final ErrorResponseModel errorResponse;

 // ServerFailure(this.errorResponse);
}

class APIFailure extends Failure {
  //final ErrorResponseModel errorResponse;

 // APIFailure(this.errorResponse);
}

class CacheFailure extends Failure {}

class ConnectionFailure extends Failure {}

class AuthorizedFailure extends Failure {
  // final ErrorResponseModel errorResponse;
  //
  // AuthorizedFailure(this.errorResponse);
}
