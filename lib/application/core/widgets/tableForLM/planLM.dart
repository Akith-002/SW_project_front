import 'package:flutter/material.dart';

class Planlm {
  final int id; // Added id field
  final int masterFileNo;
  final String planType;
  final String planNo; // Changed to String
  final String authorityReferenceNo;
  final PlanStatusLM status;

  Planlm({
    required this.id, // Added id
    required this.masterFileNo,
    required this.planType,
    required this.planNo,
    required this.authorityReferenceNo,
    required this.status,
  });

  factory Planlm.fromJson(Map<String, dynamic> json) {
    return Planlm(
      id: json['id'],
      masterFileNo: json['masterFileNo'],
      planType: json['planType'],
      planNo: json['planNo'],
      authorityReferenceNo: json['requestingAuthorityReferenceNo'],
      status: PlanStatusLMHelper.fromString(json['status']),
    );
  }
}

enum PlanStatusLM { success, pending, unknown } // Added unknown for safety

// Helper class for PlanStatusLM
class PlanStatusLMHelper {
  static PlanStatusLM fromString(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return PlanStatusLM.success;
      case 'pending':
        return PlanStatusLM.pending;
      default:
        return PlanStatusLM.unknown; // Handle unexpected status
    }
  }

  static String displayName(PlanStatusLM status) {
    switch (status) {
      case PlanStatusLM.success:
        return "Success";
      case PlanStatusLM.pending:
        return "Pending";
      case PlanStatusLM.unknown:
        return "Unknown";
    }
  }

  static Color color(PlanStatusLM status) {
    switch (status) {
      case PlanStatusLM.success:
        return Colors.green;
      case PlanStatusLM.pending:
        return Colors.orange;
      case PlanStatusLM.unknown:
        return Colors.grey;
    }
  }
}

// Extension for direct use on enum if preferred, but helper might be cleaner for fromString
extension PlanStatusExtension on PlanStatusLM {
  int compareTo(PlanStatusLM other) {
    return index.compareTo(other.index);
  }

  String get displayName => PlanStatusLMHelper.displayName(this);
  Color get color => PlanStatusLMHelper.color(this);
}
