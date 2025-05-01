import 'dart:math';

import 'package:land_asset_valuation/application/core/widgets/tableForLM/planLM.dart';

class PlanlmRepository {
  static Future<PaginatedResponseLM<Planlm>> getPlans({
    required int pageSize,
    required String? pageToken,
    String? sortBy,
    bool sortDescending = false,
    String? searchQuery,
  }) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulating network delay

    // Generate mock data
    List<Planlm> plans = List.generate(100, (index) {
      return Planlm(
        masterFileNo: index,
        planType: "Type ${String.fromCharCode(65 + (index % 5))}${index % 10}",
        planNo: Random().nextInt(1000),
        authorityReferenceNo: "00${index % 10}",
        status: index % 2 == 0 ? PlanStatusLM.success : PlanStatusLM.pending,
      );
    });

    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      plans =
          plans.where((plan) => plan.planType.contains(searchQuery)).toList();
    }

    // Apply sorting
    if (sortBy != null) {
      plans.sort((a, b) {
        int comparison;
        switch (sortBy) {
          case "masterFileNo":
            comparison = a.masterFileNo.compareTo(b.masterFileNo);
            break;
          case "planType":
            comparison = a.planType.compareTo(b.planType);
            break;
          case "planNo":
            comparison = a.planNo.compareTo(b.planNo);
            break;
          case "requestingAuthorityRefNo":
            comparison =
                a.authorityReferenceNo.compareTo(b.authorityReferenceNo);
            break;
          case "status":
            comparison = a.status.compareTo(b.status);
            break;
          default:
            comparison = 0;
        }
        return sortDescending ? -comparison : comparison;
      });
    }

    // Paginate
    int startIndex = pageToken == null ? 0 : int.tryParse(pageToken) ?? 0;
    int endIndex = (startIndex + pageSize).clamp(0, plans.length);
    List<Planlm> paginatedPlans = plans.sublist(startIndex, endIndex);
    String? nextPageToken =
        endIndex < plans.length ? endIndex.toString() : null;

    return PaginatedResponseLM(
        items: paginatedPlans, nextPageToken: nextPageToken);
  }
}

class PaginatedResponseLM<T> {
  final List<T> items;
  final String? nextPageToken;

  PaginatedResponseLM({required this.items, this.nextPageToken});
}
