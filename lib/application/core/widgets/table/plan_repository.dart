import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:land_asset_valuation/application/core/configurations/app_config.dart';
import 'plan.dart';

class PaginatedResponse<T> {
  final List<T> items;
  final String? nextPageToken;

  PaginatedResponse({required this.items, this.nextPageToken});
}

class PlanRepository {
  static Future<PaginatedResponse<Plan>> getPlans({
    required int pageSize,
    required String? pageToken,
    String? sortBy,
    bool sortDescending = false,
    String? searchQuery,
    String source = 'mock',
  }) async {
    if (source == 'landAcquisition') {
      final response = await http.get(
        Uri.parse("${AppConfig.apiBaseUrl}LAMasterfile"),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['masterFiles'];
        final List<Plan> plans = data.map((e) => Plan.fromJson(e)).toList();
        return PaginatedResponse(items: plans, nextPageToken: null);
      } else {
        throw Exception('Failed to load backend data');
      }
    }

    // Mock data fallback
    await Future.delayed(const Duration(milliseconds: 500));

    List<Plan> plans = List.generate(100, (index) {
      return Plan(
        id: index,
        masterFileNo: index,
        planType: "Type ${String.fromCharCode(65 + (index % 5))}${index % 10}",
        planNo: (100 + index).toString(),
        authorityReferenceNo: "00${index % 10}",
        status: index % 2 == 0 ? PlanStatus.success : PlanStatus.pending,
      );
    });

    // Apply search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      plans = plans
          .where((plan) =>
              plan.planType.toLowerCase().contains(searchQuery.toLowerCase()) ||
              plan.planNo.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
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

    // Apply pagination
    int startIndex = pageToken == null ? 0 : int.tryParse(pageToken) ?? 0;
    int endIndex = (startIndex + pageSize).clamp(0, plans.length);
    List<Plan> paginatedPlans = plans.sublist(startIndex, endIndex);
    String? nextPageToken =
        endIndex < plans.length ? endIndex.toString() : null;

    return PaginatedResponse(
        items: paginatedPlans, nextPageToken: nextPageToken);
  }

  /// 🔍 Search endpoint via POST /api/LAMasterfile/search
  static Future<List<Plan>> searchPlans(String query) async {
    final response = await http.post(
      Uri.parse("${AppConfig.apiBaseUrl}LAMasterfile/search"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['masterFiles'];
      return data.map((e) => Plan.fromJson(e)).toList();
    } else {
      throw Exception("Search failed: ${response.statusCode}");
    }
  }
}
