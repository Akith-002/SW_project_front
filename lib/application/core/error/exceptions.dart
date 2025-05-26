class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'Server error occurred'});
}

class APIFailException implements Exception {
  // final ErrorResponseModel errorResponseModel;
  //
  // APIFailException(this.errorResponseModel);
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'Cache error occurred'});
}

class UnAuthorizedException implements Exception {
  // final ErrorResponseModel errorResponseModel;
  //
  // UnAuthorizedException(this.errorResponseModel);
}

class DioErrorException implements Exception {
  final String message;
  DioErrorException({this.message = 'Network error occurred'});
}
