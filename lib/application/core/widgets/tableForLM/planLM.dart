import 'package:flutter/material.dart';

class Planlm {
  final int masterFileNo;
  final String planType;
  final int planNo;
  final String authorityReferenceNo;
  final PlanStatusLM status;

  Planlm({
    required this.masterFileNo,
    required this.planType,
    required this.planNo,
    required this.authorityReferenceNo,
    required this.status,
  });
}

enum PlanStatusLM { success, pending }

extension PlanStatusExtension on PlanStatusLM {
  int compareTo(PlanStatusLM other) {
    return index.compareTo(other.index);
  }

  String get displayName {
    switch (this) {
      case PlanStatusLM.success:
        return "Success";
      case PlanStatusLM.pending:
        return "Pending";
    }
  }

  Color get color {
    switch (this) {
      case PlanStatusLM.success:
        return Colors.green;
      case PlanStatusLM.pending:
        return Colors.orange;
    }
  }
}
