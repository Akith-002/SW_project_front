

class ServerException implements Exception {
  // final ErrorResponseModel errorResponseModel;

  // ServerException(this.errorResponseModel);
}

class APIFailException implements Exception {
  // final ErrorResponseModel errorResponseModel;
  //
  // APIFailException(this.errorResponseModel);
}

class CacheException implements Exception {}

class UnAuthorizedException implements Exception {
  // final ErrorResponseModel errorResponseModel;
  //
  // UnAuthorizedException(this.errorResponseModel);
}

class DioErrorException implements Exception {
  // final ErrorResponseModel errorResponseModel;
  //
  // DioErrorException({required this.errorResponseModel});
}
