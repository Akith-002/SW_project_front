import 'dart:math';
import 'planMR.dart';

class PlanmrRepository {
  static Future<PaginatedResponseMR<Planmr>> getPlans({
    required int pageSize,
    required String? pageToken,
    String? sortBy,
    bool sortDescending = false,
    String? searchQuery,
  }) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulating network delay

    // Generate mock data
    List<Planmr> plans = List.generate(100, (index) {
      return Planmr(
        ratingRefNo: index,
        LocalAuthority: "Dehiwala - Mount Lavinia",
        yearOfRevision: 2021 - Random().nextInt(10),
        status: index % 2 == 0 ? PlanStatusMR.success : PlanStatusMR.pending,
      );
    });

    // Apply search filter
    // if (searchQuery != null && searchQuery.isNotEmpty) {
    //   plans =
    //       plans.where((plan) => plan.planType.contains(searchQuery)).toList();
    // }

    // Apply sorting
    if (sortBy != null) {
      plans.sort((a, b) {
        int comparison;
        switch (sortBy) {
          case "ratingRefNo":
            comparison = a.ratingRefNo.compareTo(b.ratingRefNo);
            break;
          case "LocalAuthority":
            comparison = a.LocalAuthority.compareTo(b.LocalAuthority);
            break;
          case "yearOfRevision":
            comparison = a.yearOfRevision.compareTo(b.yearOfRevision);
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
    List<Planmr> paginatedPlans = plans.sublist(startIndex, endIndex);
    String? nextPageToken =
        endIndex < plans.length ? endIndex.toString() : null;

    return PaginatedResponseMR(
        items: paginatedPlans, nextPageToken: nextPageToken);
  }
}

class PaginatedResponseMR<T> {
  final List<T> items;
  final String? nextPageToken;

  PaginatedResponseMR({required this.items, this.nextPageToken});
}
