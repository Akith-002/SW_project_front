import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/iconButtonWidget/icon_button_widget.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:land_asset_valuation/data/models/paginated_response.dart';
import 'package:land_asset_valuation/data/models/land_acquisition_master_file_model.dart';
import 'package:land_asset_valuation/domain/repositories/land_acquisition_repository.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

class TableScaffold extends StatefulWidget {
  final int initialPageSize;
  final List<int> pageSizeOptions;
  final String pageSource;
  final LandAcquisitionRepository repository;
  final Function(int)? onTotalCountChanged;

  const TableScaffold({
    super.key,
    required this.pageSource,
    required this.repository,
    this.initialPageSize = 9,
    this.pageSizeOptions = const [9, 15, 30, 60],
    this.onTotalCountChanged,
  });

  @override
  TableScaffoldState createState() => TableScaffoldState();
}

class TableScaffoldState extends State<TableScaffold> {
  late Future<PaginatedResponse<LandAcquisitionMasterFile>> _futurePlans;
  PaginatedResponse<LandAcquisitionMasterFile>? _searchResults;
  int _currentPage = 1;
  late int _pageSize;
  late List<int> _pageSizeOptions;
  bool _isSearching = false;
  String? _currentSearchQuery;
  String? _sortColumn;
  int _totalRecords = 0;
  int? _previousTotalCount;

  @override
  void initState() {
    super.initState();
    _pageSize = widget.initialPageSize;
    _pageSizeOptions = widget.pageSizeOptions;
    _fetchPlans();
  }

  void _fetchPlans() {
    if (kDebugMode) {
      print(
          'Fetching plans - Page: $_currentPage, Size: $_pageSize, SortBy: $_sortColumn');
    }

    setState(() {
      _futurePlans = widget.repository.getPaginatedMasterFiles(
        page: _currentPage,
        pageSize: _pageSize,
        sortBy: _sortColumn,
      )..then((response) {
          if (mounted) {
            if (kDebugMode) {
              print('Received response:');
              print('Total count: ${response.totalCount}');
              print('Current page: ${response.currentPage}');
              print('Page size: ${response.pageSize}');
              print('Items count: ${response.items.length}');
            }

            setState(() {
              // Update total records and notify parent
              _totalRecords = response.totalCount;
              _updateTotalCount(response.totalCount);

              // Update page size only if server enforces a different size
              if (_pageSize != response.pageSize) {
                _pageSize = response.pageSize;
              }

              // Ensure we're on a valid page
              if (_currentPage > response.totalPages &&
                  response.totalPages > 0) {
                _currentPage = response.totalPages;
                _fetchPlans(); // Refetch with corrected page
                return;
              }
            });
          }
          return response;
        });
    });
  }

  void search(String query) async {
    if (widget.pageSource == 'landAcquisition') {
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
        setState(() {
          _searchResults = results;
          _currentPage = 1;
          _isSearching = false;
          _updateTotalCount(results.totalCount);
        });
      } catch (e) {
        setState(() {
          _isSearching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Search failed: $e")),
        );
      }
    }
  }

  void _searchWithPagination(String query, int page) async {
    if (widget.pageSource == 'landAcquisition') {
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
        setState(() {
          _searchResults = results;
          _currentPage = page;
          _isSearching = false;
          _updateTotalCount(results.totalCount);
        });
      } catch (e) {
        setState(() {
          _isSearching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Search failed: $e")),
        );
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
      body: FutureBuilder<PaginatedResponse<LandAcquisitionMasterFile>>(
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
            if (kDebugMode) {
              print('Error loading data: ${snapshot.error}');
            }
            return Center(child: Text("Error loading data: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return const Center(child: Text("No records found"));
          }

          return _buildTable(snapshot.data!.items, snapshot.data);
        },
      ),
    );
  }

  Widget _buildTable(List<LandAcquisitionMasterFile> plans,
      PaginatedResponse<LandAcquisitionMasterFile>? paginationData) {
    // Calculate the current range of records being displayed
    final int startRecord = paginationData != null
        ? ((paginationData.currentPage - 1) * paginationData.pageSize) + 1
        : 1;
    final int endRecord = startRecord + plans.length - 1;
    final int totalCount = paginationData?.totalCount ?? plans.length;

    // Move callback outside of build method to prevent excessive calls
    _updateTotalCount(totalCount);

    if (kDebugMode) {
      print('Building table:');
      print('Start record: $startRecord');
      print('End record: $endRecord');
      print('Total records: $totalCount');
      print('Current page size: $_pageSize');
      print('Records in current page: ${plans.length}');
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: 1000,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colors(context).colorGrey3 ??
                          colors(context).colorGrey9!,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      colors(context).colorGrey9!,
                    ),
                    columnSpacing: 16,
                    horizontalMargin: 16,
                    columns: [
                      DataColumn(
                        label: SizedBox(
                          width: 100,
                          child: Text("Master File No"),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 150,
                          child: Text("Plan Type"),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 100,
                          child: Text("Plan No"),
                        ),
                      ),
                      DataColumn(
                        label: SizedBox(
                          width: 200,
                          child: Text("Requesting Authority Reference No"),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          width: 100,
                          alignment: Alignment.center,
                          child: Text("Status"),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                          width: 100,
                          alignment: Alignment.center,
                          child: Text("Action"),
                        ),
                      ),
                    ],
                    rows: plans.map((plan) {
                      return DataRow(
                        cells: [
                          DataCell(Text(plan.masterFileNo.toString())),
                          DataCell(Text(plan.planType)),
                          DataCell(Text(plan.planNo)),
                          DataCell(Text(plan.requestingAuthorityReferenceNo)),
                          DataCell(
                            Container(
                              alignment: Alignment.center,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: plan.status.toLowerCase() == 'success'
                                      ? Colors.green.withOpacity(0.1)
                                      : Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  plan.status,
                                  style: TextStyle(
                                    color:
                                        plan.status.toLowerCase() == 'success'
                                            ? Colors.green
                                            : Colors.orange,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.visibility),
                                    onPressed: () {
                                      context.pushNamed(
                                        Pages.routeMapScreen.toPathName(),
                                        queryParameters: {
                                          'source': widget.pageSource,
                                          'selectedIndex': '1',
                                        },
                                      );
                                    },
                                    tooltip: 'View Details',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {
                                      context.pushNamed(
                                        Pages.routeMapScreen.toPathName(),
                                        queryParameters: {
                                          'source': widget.pageSource,
                                          'selectedIndex': '1',
                                        },
                                      );
                                    },
                                    tooltip: 'Edit',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
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
}
