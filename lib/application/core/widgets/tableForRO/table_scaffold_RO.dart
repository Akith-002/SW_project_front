import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRO/cubit/ro_requests_cubit.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRO/cubit/ro_requests_state.dart';
import 'package:land_asset_valuation/application/core/widgets/view_download_button.dart';
import 'package:land_asset_valuation/application/core/widgets/download_confirmation_dialog.dart';
import 'package:land_asset_valuation/application/core/utils/download_service.dart';
import 'package:land_asset_valuation/data/models/ra_request_model.dart';

class TableScaffoldRO extends StatefulWidget {
  final int initialPageSize;
  final List<int> pageSizeOptions;
  final String pageSource;
  final Function(int)? onTotalCountChanged;

  const TableScaffoldRO({
    super.key,
    required this.pageSource,
    this.initialPageSize = 10,
    this.pageSizeOptions = const [10, 25, 50, 100],
    this.onTotalCountChanged,
  });

  @override
  State<TableScaffoldRO> createState() => TableScaffoldROState();
}

class TableScaffoldROState extends State<TableScaffoldRO> {
  late RoRequestsCubit _cubit;
  String? _nextPageToken;
  late int _pageSize;
  late List<int> _pageSizeOptions;
  int _currentPage = 1;
  int _totalItems = 0;
  String _searchQuery = '';
  String? _sortBy;
  List<RaRequestModel> _allRequests = [];
  List<RaRequestModel> _filteredRequests = [];

  @override
  void initState() {
    super.initState();
    _pageSize = widget.initialPageSize;
    _pageSizeOptions = widget.pageSizeOptions;
    _cubit = GetIt.I<RoRequestsCubit>();
    _currentPage = 1;
    _cubit.loadRequests();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void search(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _currentPage = 1; // Reset to first page on search
      _applySearchAndSort();
    });
  }

  void sort(String sortBy) {
    setState(() {
      _sortBy = sortBy;
      _applySearchAndSort();
    });
  }

  void _applySearchAndSort() {
    // Apply search filter
    _filteredRequests = _allRequests.where((request) {
      if (_searchQuery.isEmpty) return true;
      
      return request.ratingReferenceNo.toLowerCase().contains(_searchQuery) ||
             request.localAuthority.toLowerCase().contains(_searchQuery) ||
             request.yearOfRevision.toString().contains(_searchQuery) ||
             (request.status ? 'active' : 'inactive').contains(_searchQuery);
    }).toList();

    // Apply sort
    if (_sortBy != null) {
      switch (_sortBy) {
        case 'ratingReferenceNo':
          _filteredRequests.sort((a, b) => a.ratingReferenceNo.compareTo(b.ratingReferenceNo));
          break;
        case 'localAuthority':
          _filteredRequests.sort((a, b) => a.localAuthority.compareTo(b.localAuthority));
          break;
        case 'yearOfRevision':
          _filteredRequests.sort((a, b) => a.yearOfRevision.compareTo(b.yearOfRevision));
          break;
        case 'status':
          _filteredRequests.sort((a, b) => (a.status ? 1 : 0).compareTo(b.status ? 1 : 0));
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        body: BlocBuilder<RoRequestsCubit, RoRequestsState>(
          builder: (context, state) {
            if (state is RoRequestsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is RoRequestsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _cubit.refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is RoRequestsLoaded) {
              _allRequests = state.requests;
              _applySearchAndSort();
              
              // Store total count for pagination display
              _totalItems = _filteredRequests.length;
              
              // Notify parent about total count
              if (widget.onTotalCountChanged != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onTotalCountChanged!(_filteredRequests.length);
                });
              }
              
              if (_filteredRequests.isEmpty && _searchQuery.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search_off, size: 48, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text("No results found for \"$_searchQuery\""),
                    ],
                  ),
                );
              }
              
              if (_filteredRequests.isEmpty) {
                return const Center(child: Text("No records found"));
              }

              return _buildTable(_filteredRequests);
            }
            
            return const Center(child: Text('No data available'));
          },
        ),
      ),
    );
  }

  Widget _buildTable(List<RaRequestModel> requests) {
    // Calculate the items to display based on current page
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    final displayedRequests = requests.skip(startIndex).take(_pageSize).toList();
    
    return Column(
      children: [
        // Table Section
        Expanded(
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
                child: SingleChildScrollView(
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      colors(context).colorGrey9!,
                    ),
                    columns: const [
                      DataColumn(label: Text("Rating Reference No")),
                      DataColumn(label: Text("Local Authority")),
                      DataColumn(label: Text("Year of Revision")),
                      DataColumn(label: Center(child: Text("Status"))),
                      DataColumn(label: Center(child: Text("Action"))),
                    ],
                    rows: displayedRequests.map((request) {
                        return DataRow(cells: [
                          DataCell(Text(request.ratingReferenceNo)),
                          DataCell(Text(request.localAuthority)),
                          DataCell(Text(request.yearOfRevision.toString())),
                          DataCell(Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: request.status 
                                  ? Colors.green.withOpacity(0.2) 
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              request.status ? 'Active' : 'Inactive',
                              style: TextStyle(
                                color: request.status ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )),
                          DataCell(
                            SizedBox(
                              height: 52,
                              child: Row(
                                children: [
                                  CustomIconButton(
                                    imagePath: "images/pngs/eye-empty.png",
                                    backgroundColor: Colors.white,
                                    borderColor: const Color(0xffd0d5dd),
                                    iconColor: const Color(0xff4a4a4a),
                                    onPressed: () {
                                      // Determine the correct sidebar index based on the source
                                      String selectedIndex =
                                          '5'; // Default to RO
                                      switch (widget.pageSource) {
                                        case 'massRating':
                                          selectedIndex = '2'; // Mass Rating MR
                                          break;
                                        case 'ratingAssessment':
                                          selectedIndex =
                                              '3'; // Rating Assessment RA
                                          break;
                                        case 'ratingBuilding':
                                          selectedIndex =
                                              '4'; // Rating Building RB
                                          break;
                                        case 'ratingObject':
                                          selectedIndex =
                                              '5'; // Rating Object RO
                                          break;
                                      }
                                      context.goNamed(
                                        Pages.routeRoAssetsList.toPathName(),
                                        queryParameters: {
                                          'selectedIndex': selectedIndex,
                                          'source': widget.pageSource,
                                          'requestId': request.id.toString(),
                                        },
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  CustomIconButton(
                                    imagePath: "images/pngs/download.png",
                                    backgroundColor: const Color(0xFFDFF0FF),
                                    borderColor: const Color(0xff069bf1),
                                    iconColor: const Color(0xff007bce),
                                    onPressed: () {
                                      _showDownloadDialog(context, request);
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
          ),
        ),

        // Gmail-style pagination
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colors(context).colorGrey3 ?? Colors.grey.shade300,
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Page info
              Text(
                '${((_currentPage - 1) * _pageSize) + 1}–${((_currentPage - 1) * _pageSize) + displayedRequests.length} of $_totalItems',
                style: TextStyle(
                  fontSize: 13,
                  color: colors(context).colorGrey7,
                ),
              ),
              const SizedBox(width: 24),
              // Navigation buttons
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      size: 20,
                      color: _currentPage > 1 
                          ? colors(context).colorGrey7 
                          : colors(context).colorGrey3,
                    ),
                    onPressed: _currentPage > 1
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                          }
                        : null,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.chevron_right,
                      size: 20,
                      color: (_currentPage * _pageSize) < _totalItems 
                          ? colors(context).colorGrey7 
                          : colors(context).colorGrey3,
                    ),
                    onPressed: (_currentPage * _pageSize) < _totalItems
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                          }
                        : null,
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDownloadDialog(BuildContext context, RaRequestModel request) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Material(
          type: MaterialType.transparency,
          child: DownloadConfirmationDialog(
            requestNumber: request.ratingReferenceNo,
            onConfirm: () async {
              Navigator.of(dialogContext).pop();
              
              try {
                // Download the request data as JSON
                await DownloadService.downloadRaRequestAsJson(request);
                
                // Show success message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Request ${request.ratingReferenceNo} shared successfully'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              } catch (e) {
                // Show error message
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error sharing request: ${e.toString()}'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
            onCancel: () {
              Navigator.of(dialogContext).pop();
            },
          ),
        );
      },
    );
  }
}