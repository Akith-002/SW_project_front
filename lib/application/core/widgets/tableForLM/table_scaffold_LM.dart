import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' hide State;
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/error/failures.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/iconButtonWidget/icon_button_widget.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:land_asset_valuation/data/models/paginated_response.dart';
import 'package:land_asset_valuation/data/models/land_miscellaneous_master_file_model.dart';
import 'package:land_asset_valuation/domain/repositories/land_miscellaneous_repository.dart';
import 'package:land_asset_valuation/data/services/building_service.dart';
import 'package:land_asset_valuation/data/services/rental_evidence_service.dart';
import 'package:land_asset_valuation/injection.dart';

class TableScaffoldLM extends StatefulWidget {
  final int initialPageSize;
  final List<int> pageSizeOptions;
  final String? pageSource;
  final LandMiscellaneousRepository repository;
  final ValueChanged<int>? onTotalCountChanged;

  const TableScaffoldLM({
    super.key,
    this.pageSource,
    required this.repository,
    this.onTotalCountChanged,
    this.initialPageSize = 9,
    this.pageSizeOptions = const [9, 15, 30, 60],
  });

  @override
  TableScaffoldLMState createState() => TableScaffoldLMState();
}

class TableScaffoldLMState extends State<TableScaffoldLM> {
  late Future<Either<Failure, PaginatedResponse<LandMiscellaneousMasterFile>>>
      _futurePlans;
  PaginatedResponse<LandMiscellaneousMasterFile>? _searchResults;
  int _currentPage = 1;
  late int _pageSize;
  late List<int> _pageSizeOptions;
  bool _isSearching = false;
  String? _currentSearchQuery;
  String? _sortColumn;
  int?
      _previousTotalCount; // Cache previous count to prevent unnecessary callbacks
  final BuildingService _buildingService = BuildingService();
  final RentalEvidenceService _rentalEvidenceService =
      injection<RentalEvidenceService>();

  @override
  void initState() {
    super.initState();
    _pageSize = widget.initialPageSize;
    _pageSizeOptions = widget.pageSizeOptions;
    _fetchPlans();
  }

  void _fetchPlans() {
    setState(() {
      _futurePlans = widget.repository.getPaginatedMasterFiles(
        page: _currentPage,
        limit: _pageSize,
        sortBy: _sortColumn,
      );
    });
  }

  void search(String query) async {
    if (widget.pageSource == 'landMiscellaneous') {
      // If query is empty, clear search results and show original data
      if (query.trim().isEmpty) {
        setState(() {
          _searchResults = null;
          _isSearching = false;
          _currentSearchQuery = null;
        });
        _fetchPlans(); // Reload original paginated data
        return;
      }

      setState(() {
        _isSearching = true;
        _currentSearchQuery = query;
      });
      try {
        final results = await widget.repository.searchMasterFiles(
          query: query,
          page: 1,
          pageSize: _pageSize,
          sortBy: _sortColumn,
        );
        results.fold(
          (failure) {
            setState(() {
              _isSearching = false;
            });
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text("Search failed: ${failure.message}")),
            // );
          },
          (paginatedResponse) {
            setState(() {
              _searchResults = paginatedResponse;
              _currentPage = 1;
              _isSearching = false;
            });
          },
        );
      } catch (e) {
        setState(() {
          _isSearching = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Search failed: $e")),
        // );
      }
    }
  }

  void _searchWithPagination(String query, int page) async {
    if (widget.pageSource == 'landMiscellaneous') {
      setState(() {
        _isSearching = true;
      });
      try {
        final results = await widget.repository.searchMasterFiles(
          query: query,
          page: page,
          pageSize: _pageSize,
          sortBy: _sortColumn,
        );
        results.fold(
          (failure) {
            setState(() {
              _isSearching = false;
            });
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text("Search failed: ${failure.message}")),
            // );
          },
          (paginatedResponse) {
            setState(() {
              _searchResults = paginatedResponse;
              _currentPage = page;
              _isSearching = false;
            });
          },
        );
      } catch (e) {
        setState(() {
          _isSearching = false;
        });
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Search failed: $e")),
        // );
      }
    }
  }

  void refreshWithSort(String sortBy) {
    setState(() {
      _sortColumn = sortBy;
      _currentPage = 1;
    });

    if (_currentSearchQuery != null) {
      _searchWithPagination(_currentSearchQuery!, 1);
    } else {
      _fetchPlans();
    }
  }

  void _updateTotalCount(int totalCount) {
    // Only call callback if count has actually changed
    if (_previousTotalCount != totalCount &&
        widget.onTotalCountChanged != null) {
      _previousTotalCount = totalCount;
      // Defer the callback to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onTotalCountChanged!(totalCount);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<
          Either<Failure, PaginatedResponse<LandMiscellaneousMasterFile>>>(
        future: _futurePlans,
        builder: (context, snapshot) {
          // Show search results if available
          if (_searchResults != null) {
            return _buildTable(_searchResults!.items, _searchResults);
          }

          // Show loading indicator while searching
          if (_isSearching) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }

          return snapshot.data!.fold(
            (failure) => Center(child: Text("Error: ${failure.message}")),
            (paginatedResponse) {
              if (paginatedResponse.items.isEmpty) {
                return const Center(child: Text("No records found"));
              }
              return _buildTable(paginatedResponse.items, paginatedResponse);
            },
          );
        },
      ),
    );
  }

  Widget _buildTable(List<LandMiscellaneousMasterFile> plans,
      PaginatedResponse<LandMiscellaneousMasterFile>? paginationData) {
    final int startRecord = paginationData != null
        ? ((paginationData.currentPage - 1) * paginationData.pageSize) + 1
        : 1;
    final int endRecord = startRecord + plans.length - 1;
    final int totalCount = paginationData?.totalCount ?? plans.length;

    // Move callback outside of build method to prevent excessive calls
    _updateTotalCount(totalCount);

    return Column(
      children: [
        // Table Section - Use Flexible to only take needed space
        Flexible(
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      colors(context).colorGrey3 ?? colors(context).colorGrey9!,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fixed header
                  Container(
                    color: colors(context).colorGrey9!,
                    child: const Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text("Master File No",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text("Plan Type",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text("Plan No",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )),
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text("Authority Reference No",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(
                                  child: Text("Status",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            )),
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(
                                  child: Text("Action",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                            )),
                      ],
                    ),
                  ),
                  // Scrollable body - use Flexible to allow overflow scrolling
                  Flexible(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: plans.length,
                      itemBuilder: (context, index) {
                        final plan = plans[index];
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: colors(context).colorGrey3 ??
                                    colors(context).colorGrey9!,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    child: Text(plan.masterFileNo.toString()),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    child: Text(plan.planType),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    child: Text(plan.planNo),
                                  )),
                              Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    child: Text(
                                        plan.requestingAuthorityReferenceNo),
                                  )),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor(plan.status)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          plan.status,
                                          style: TextStyle(
                                            color: _getStatusColor(plan.status),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    child: Center(
                                      child: iconButtonWidget(
                                        color: colors(context).colorGrey8!,
                                        iconName: PhosphorIconsRegular.eye,
                                        onPressed: () async {
                                          // Clear both buildings and rental evidences for this master file when View button is tapped
                                          debugPrint(
                                              "🗑️ LM Table: View button tapped for master file ${plan.masterFileNo}");
                                          debugPrint(
                                              "   Clearing existing buildings and rental evidences for this master file...");

                                          try {
                                            // Clear buildings
                                            await _buildingService
                                                .clearBuildingsForMasterFile(
                                                    plan.masterFileNo
                                                        .toString());
                                            debugPrint(
                                                "✅ LM Table: Successfully cleared buildings for master file ${plan.masterFileNo}");

                                            // Clear rental evidences
                                            await _rentalEvidenceService
                                                .clearRentalEvidencesForMasterFile(
                                                    plan.masterFileNo
                                                        .toString());
                                            debugPrint(
                                                "✅ LM Table: Successfully cleared rental evidences for master file ${plan.masterFileNo}");
                                          } catch (e) {
                                            debugPrint(
                                                "❌ LM Table: Error clearing data: $e");
                                          }

                                          // Navigate to map screen
                                          context.pushNamed(
                                            Pages.routeMapScreen.toPathName(),
                                            queryParameters: {
                                              'source': 'landMiscellaneous',
                                              'id': plan.id.toString(),
                                              'masterFileNo':
                                                  plan.masterFileNo.toString(),
                                              'masterFileRefNo':
                                                  plan.masterFileRefNo,
                                              'planType': plan.planType,
                                              'planNo': plan.planNo,
                                              'authorityRefNo': plan
                                                  .requestingAuthorityReferenceNo,
                                              'status': plan.status,
                                              'lots': plan.lots.toString(),
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Pagination controls
        if (paginationData != null && paginationData.totalPages > 1)
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Show "),
                    DropdownButton<int>(
                      value: _pageSize,
                      items: _pageSizeOptions.map((size) {
                        return DropdownMenuItem<int>(
                          value: size,
                          child: Text("$size"),
                        );
                      }).toList(),
                      onChanged: (newSize) {
                        if (newSize != null && newSize != _pageSize) {
                          setState(() {
                            _pageSize = newSize;
                            _currentPage = 1; // Reset to first page
                            _searchResults = null; // Clear search results
                          });
                          if (_currentSearchQuery != null) {
                            _searchWithPagination(_currentSearchQuery!, 1);
                          } else {
                            _fetchPlans();
                          }
                        }
                      },
                    ),
                    Text(" per page"),
                  ],
                ),
                Text(
                  'Showing $startRecord to $endRecord of $totalCount entries',
                  style: TextStyle(
                    color: colors(context).colorGrey2,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: paginationData.hasPrevious
                          ? () {
                              setState(() {
                                _currentPage = paginationData.currentPage - 1;
                              });
                              if (_currentSearchQuery != null) {
                                _searchWithPagination(
                                    _currentSearchQuery!, _currentPage);
                              } else {
                                _fetchPlans();
                              }
                            }
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text(
                      'Page ${paginationData.currentPage} of ${paginationData.totalPages}',
                      style: TextStyle(
                        color: colors(context).colorGrey2,
                        fontSize: 14,
                      ),
                    ),
                    IconButton(
                      onPressed: paginationData.hasNext
                          ? () {
                              setState(() {
                                _currentPage = paginationData.currentPage + 1;
                              });
                              if (_currentSearchQuery != null) {
                                _searchWithPagination(
                                    _currentSearchQuery!, _currentPage);
                              } else {
                                _fetchPlans();
                              }
                            }
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
