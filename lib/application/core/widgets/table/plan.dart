import 'package:flutter/material.dart';

class Plan {
  final int masterFileNo;
  final String planType;
  final int planNo;
  final String authorityReferenceNo;
  final PlanStatus status;

  Plan({
    required this.masterFileNo,
    required this.planType,
    required this.planNo,
    required this.authorityReferenceNo,
    required this.status,
  });
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
}