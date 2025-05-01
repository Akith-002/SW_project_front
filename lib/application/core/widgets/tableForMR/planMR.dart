import 'package:flutter/material.dart';

class Planmr {
  final int ratingRefNo;
  final String LocalAuthority;
  final int yearOfRevision;
  final PlanStatusMR status;

  Planmr({
    required this.ratingRefNo,
    required this.LocalAuthority,
    required this.yearOfRevision,
    required this.status,
  });
}

enum PlanStatusMR { success, pending }

extension PlanStatusMRExtension on PlanStatusMR {
  int compareTo(PlanStatusMR other) {
    return index.compareTo(other.index);
  }

  String get displayName {
    switch (this) {
      case PlanStatusMR.success:
        return "Success";
      case PlanStatusMR.pending:
        return "Pending";
    }
  }

  Color get color {
    switch (this) {
      case PlanStatusMR.success:
        return Colors.green;
      case PlanStatusMR.pending:
        return Colors.orange;
    }
  }
}
