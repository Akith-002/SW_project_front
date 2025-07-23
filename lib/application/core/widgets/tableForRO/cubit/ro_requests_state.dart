import 'package:equatable/equatable.dart';
import 'package:land_asset_valuation/data/models/ra_request_model.dart';

abstract class RoRequestsState extends Equatable {
  const RoRequestsState();

  @override
  List<Object?> get props => [];
}

class RoRequestsInitial extends RoRequestsState {}

class RoRequestsLoading extends RoRequestsState {}

class RoRequestsLoaded extends RoRequestsState {
  final List<RaRequestModel> requests;

  const RoRequestsLoaded({required this.requests});

  @override
  List<Object?> get props => [requests];
}

class RoRequestsError extends RoRequestsState {
  final String message;

  const RoRequestsError({required this.message});

  @override
  List<Object?> get props => [message];
}