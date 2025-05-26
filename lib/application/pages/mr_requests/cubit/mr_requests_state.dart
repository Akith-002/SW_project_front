part of 'mr_requests_cubit.dart';

abstract class MrRequestsState {}

final class MrRequestsInitial extends MrRequestsState {}

final class MrRequestsLoading extends MrRequestsState {}

final class MrRequestsLoaded extends MrRequestsState {
  final PaginatedResponse<MrRequest> paginatedResponse;

  MrRequestsLoaded(this.paginatedResponse);
}

final class MrRequestsError extends MrRequestsState {
  final String errorMessage;

  MrRequestsError(this.errorMessage);
}
