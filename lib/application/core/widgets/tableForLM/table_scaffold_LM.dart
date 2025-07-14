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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Search failed: ${failure.message}")),
            );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Search failed: $e")),
        );
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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Search failed: ${failure.message}")),
            );
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
    if (widget.onTotalCountChanged != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onTotalCountChanged!(totalCount);
      });
    }

    return Column(
      children: [
        // Table Section - Use Expanded to take available space
        Expanded(
          // Table area should fill available space and scroll vertically if content overflows
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
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
                          columns: const [
                            DataColumn(label: Text("Master File No")),
                            DataColumn(label: Text("Plan Type")),
                            DataColumn(label: Text("Plan No")),
                            DataColumn(
                                label:
                                    Text("Requesting Authority Reference No")),
                            DataColumn(label: Center(child: Text("Status"))),
                            DataColumn(label: Center(child: Text("Action"))),
                          ],
                          rows: plans.map((plan) {
                            return DataRow(cells: [
                              DataCell(Text(plan.masterFileNo.toString())),
                              DataCell(Text(plan.planType)),
                              DataCell(Text(plan.planNo.toString())),
                              DataCell(
                                  Text(plan.requestingAuthorityReferenceNo)),
                              DataCell(Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(plan.status)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  plan.status,
                                  style: TextStyle(
                                      color: _getStatusColor(plan.status),
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                              DataCell(
                                SizedBox(
                                  height: 52,
                                  child: Row(
                                    children: [
                                      iconButtonWidget(
                                        color: colors(context).colorGrey8!,
                                        iconName: PhosphorIconsRegular.eye,
                                        onPressed: () {
                                          context.pushNamed(
                                            Pages.routeMapScreen.toPathName(),
                                            queryParameters: {
                                              'source': 'landMiscellaneous'
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        // Pagination Section - Fixed at bottom
        const SizedBox(height: 16),
        Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(8.0),
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
                      if (newSize != null) {
                        setState(() {
                          _pageSize = newSize;
                          _currentPage = 1;
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
              Text("$startRecord-$endRecord of $totalCount Records"),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: paginationData?.hasPrevious == true
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                            if (_currentSearchQuery != null) {
                              _searchWithPagination(
                                  _currentSearchQuery!, _currentPage);
                            } else {
                              _fetchPlans();
                            }
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: paginationData?.hasNext == true
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                            if (_currentSearchQuery != null) {
                              _searchWithPagination(
                                  _currentSearchQuery!, _currentPage);
                            } else {
                              _fetchPlans();
                            }
                          }
                        : null,
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
