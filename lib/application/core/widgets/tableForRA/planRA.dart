import 'package:flutter/material.dart';

class PlanRA {
  final int ratingRefNo;
  final String LocalAuthority;
  final int yearOfRevision;
  final PlanStatusRA status;

  PlanRA({
    required this.ratingRefNo,
    required this.LocalAuthority,
    required this.yearOfRevision,
    required this.status,
  });
}

enum PlanStatusRA { success, pending }

extension PlanStatusRAExtension on PlanStatusRA {
  int compareTo(PlanStatusRA other) {
    return index.compareTo(other.index);
  }

  String get displayName {
    switch (this) {
      case PlanStatusRA.success:
        return "Success";
      case PlanStatusRA.pending:
        return "Pending";
    }
  }

  Color get color {
    switch (this) {
      case PlanStatusRA.success:
        return Colors.green;
      case PlanStatusRA.pending:
        return Colors.orange;
    }
  }
}
