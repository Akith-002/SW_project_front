
class ErrorHandler {
  ///error_title
  static const String TITLE_ERROR = "Error";
  static const String TITLE_OOPS = "Oops!";
  static const String TITLE_SUCCESS = "Success";
  static const String TITLE_UPDATE = "Update";
  static const String TITLE_QUESTION = "Confirm";
  static const String TITLE_FAILED = "Failed";


  ///error_messages
  static const String errorSomethingWentWrong = "Something went wrong!";
  static const String errorAppVerificationFailed = "App verification failed!";
  static const String errorMessage1 = "Entered Passwords are not match";
  static const String errorMessage2 = "Invalid details. Please enter correct username and password";
  static const String errorMessage3 = "Please Enter PIN";
  static const String errorMessageAlreadyExistingNIC = "NIC already exits";
  static const String errorMessageAlreadyExistingUserName = "Username is existing, Try a different Username";

  ///error_title

  static const String ERROR_SOMETHING_WENT_WRONG = "Something went wrong!";



  // String? mapFailureToMessage(Failure failure) {
  //   switch (failure.runtimeType) {
  //     case ConnectionFailure:
  //       return 'You are not connected to the internet. Please check your internet connection and try again.';
  //     case ServerFailure:
  //       return (failure as ServerFailure).errorResponse.message;
  //     case AuthorizedFailure:
  //       return (failure as AuthorizedFailure).errorResponse.message;
  //     default:
  //       return 'Unexpected error';
  //   }
  // }
}
