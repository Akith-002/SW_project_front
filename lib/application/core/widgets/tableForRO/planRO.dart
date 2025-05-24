import 'package:flutter/material.dart';

class PlanRO {
  final int ratingRefNo;
  final String LocalAuthority;
  final int yearOfRevision;
  final PlanStatusRO status;

  PlanRO({
    required this.ratingRefNo,
    required this.LocalAuthority,
    required this.yearOfRevision,
    required this.status,
  });
}

enum PlanStatusRO { success, pending }

extension PlanStatusROExtension on PlanStatusRO {
  int compareTo(PlanStatusRO other) {
    return index.compareTo(other.index);
  }

  String get displayName {
    switch (this) {
      case PlanStatusRO.success:
        return "Success";
      case PlanStatusRO.pending:
        return "Pending";
    }
  }

  Color get color {
    switch (this) {
      case PlanStatusRO.success:
        return Colors.green;
      case PlanStatusRO.pending:
        return Colors.orange;
    }
  }
}
