import 'package:flutter/material.dart';

class PlanRB {
  final int ratingRefNo;
  final String LocalAuthority;
  final int yearOfRevision;
  final PlanStatusRB status;

  PlanRB({
    required this.ratingRefNo,
    required this.LocalAuthority,
    required this.yearOfRevision,
    required this.status,
  });
}

enum PlanStatusRB { success, pending }

extension PlanStatusRBExtension on PlanStatusRB {
  int compareTo(PlanStatusRB other) {
    return index.compareTo(other.index);
  }

  String get displayName {
    switch (this) {
      case PlanStatusRB.success:
        return "Success";
      case PlanStatusRB.pending:
        return "Pending";
    }
  }

  Color get color {
    switch (this) {
      case PlanStatusRB.success:
        return Colors.green;
      case PlanStatusRB.pending:
        return Colors.orange;
    }
  }
}
