abstract class BaseState<K> {
  const BaseState();
}

class BaseInitial extends BaseState {}

class APIFailureState<K> extends BaseState<K> {
  final String error;

  APIFailureState({required this.error});
}

class APILoadingState<K> extends BaseState<K> {}

class SessionExpireState<K> extends BaseState<K> {
  final String error;

  SessionExpireState({required this.error});
}

class ConnectionFailureState<K> extends BaseState<K> {}
