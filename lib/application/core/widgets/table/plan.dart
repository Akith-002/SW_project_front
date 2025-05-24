import 'package:flutter/material.dart';

class Plan {
  final int id;
  final int masterFileNo;
  final String planType;
  final String planNo;
  final String authorityReferenceNo;
  final PlanStatus status;

  Plan({
    required this.id,
    required this.masterFileNo,
    required this.planType,
    required this.planNo,
    required this.authorityReferenceNo,
    required this.status,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id'],
      masterFileNo: json['masterFileNo'],
      planType: json['planType'],
      planNo: json['planNo'],
      authorityReferenceNo: json['requestingAuthorityReferenceNo'],
      status: PlanStatusExtension.fromString(json['status']),
    );
  }
}

enum PlanStatus { success, pending }

extension PlanStatusExtension on PlanStatus {
  int compareTo(PlanStatus other) {
    return index.compareTo(other.index);
  }

  String get displayName {
    switch (this) {
      case PlanStatus.success:
        return "Success";
      case PlanStatus.pending:
        return "Pending";
    }
  }

  Color get color {
    switch (this) {
      case PlanStatus.success:
        return Colors.green;
      case PlanStatus.pending:
        return Colors.orange;
    }
  }

  static PlanStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return PlanStatus.success;
      case 'pending':
      default:
        return PlanStatus.pending;
    }
  }
}
