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
  List<LandAcquisitionMasterFile>? _searchResults;
  String? _nextPageToken;
  late int _pageSize;
  late List<int> _pageSizeOptions;
  int _currentPage = 1;
  int _totalRecords = 0;

  @override
  void initState() {
    super.initState();
    _pageSize = widget.initialPageSize;
    _pageSizeOptions = widget.pageSizeOptions;
    _fetchPlans();
  }

  void _fetchPlans() {
    if (kDebugMode) {
      print('Fetching plans - Page: $_currentPage, Size: $_pageSize');
    }

    setState(() {
      _futurePlans = widget.repository.getPaginatedMasterFiles(
        page: _currentPage,
        pageSize: _pageSize,
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
              widget.onTotalCountChanged?.call(response.totalCount);

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
      try {
        final results = await widget.repository.searchMasterFiles(query);
        setState(() {
          _searchResults = results;
          _currentPage = 1;
          _totalRecords = results.length;
          widget.onTotalCountChanged?.call(results.length);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Search failed: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PaginatedResponse<LandAcquisitionMasterFile>>(
        future: _futurePlans,
        builder: (context, snapshot) {
          if (_searchResults != null) {
            return _buildTable(_searchResults!, null);
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
    final int startRecord =
        _searchResults != null ? 1 : ((_currentPage - 1) * _pageSize) + 1;

    final int endRecord = _searchResults != null
        ? _searchResults!.length
        : math.min(startRecord + plans.length - 1, _totalRecords);

    if (kDebugMode) {
      print('Building table:');
      print('Start record: $startRecord');
      print('End record: $endRecord');
      print('Total records: $_totalRecords');
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
                      return DataRow(cells: [
                        DataCell(
                          SizedBox(
                            width: 100,
                            child: Text(plan.masterFileNo.toString()),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 150,
                            child: Text(plan.planType),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 100,
                            child: Text(plan.planNo.toString()),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            width: 200,
                            child: Text(plan.requestingAuthorityReferenceNo),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 100,
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
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
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Container(
                            width: 100,
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 52,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  iconButtonWidget(
                                    color: colors(context).colorGrey8!,
                                    iconName: PhosphorIconsRegular.eye,
                                    onPressed: () {
                                      context.pushNamed(
                                        Pages.routeMapScreen.toPathName(),
                                        queryParameters: {
                                          'source': widget.pageSource,
                                          'selectedIndex': '1',
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
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
                      if (newSize != null && newSize != _pageSize) {
                        setState(() {
                          _pageSize = newSize;
                          _currentPage = 1; // Reset to first page
                          _searchResults = null; // Clear search results
                          _fetchPlans();
                        });
                      }
                    },
                  ),
                  Text(" per page"),
                ],
              ),
              Text("$startRecord-$endRecord of $_totalRecords Records"),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: _currentPage > 1
                        ? () {
                            setState(() {
                              _currentPage--;
                              _fetchPlans();
                            });
                          }
                        : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: _currentPage <
                            ((_totalRecords + _pageSize - 1) ~/ _pageSize)
                        ? () {
                            setState(() {
                              _currentPage++;
                              _fetchPlans();
                            });
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
