import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForLM/planLM.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForLM/planLM_repository.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

class TableScaffoldLM extends StatefulWidget {
  final int initialPageSize;
  final List<int> pageSizeOptions;
  final String pageSource; // Keep this if it's used for other logic not shown

  const TableScaffoldLM({
    super.key,
    required this.pageSource,
    this.initialPageSize = 9,
    this.pageSizeOptions = const [9, 15, 30, 60],
  });

  @override
  _TableScaffoldState createState() => _TableScaffoldState();
}

class _TableScaffoldState extends State<TableScaffoldLM> {
  // Store the whole PaginatedResponseLM object to access pagination info
  Future<PaginatedResponseLM<Planlm>>? _futurePlansResponse;
  int _currentPageNumber = 1;
  late int _pageSize;
  late List<int> _pageSizeOptions;
  bool _isLoading = false; // To prevent multiple simultaneous fetches

  @override
  void initState() {
    super.initState();
    _pageSize = widget.initialPageSize;
    _pageSizeOptions = widget.pageSizeOptions;
    _fetchPlans();
  }

  void _fetchPlans() {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      // Pass current page number and page size to the repository
      _futurePlansResponse = PlanlmRepository.getPlans(
        pageNumber: _currentPageNumber,
        pageSize: _pageSize,
        // searchQuery and sortBy can be added here if needed later
      );
    });
    // Reset loading state after fetch completes (success or error)
    _futurePlansResponse
        ?.whenComplete(() => setState(() => _isLoading = false));
  }

  void _changePageSize(int newSize) {
    if (_pageSize == newSize) return;
    setState(() {
      _pageSize = newSize;
      _currentPageNumber = 1; // Reset to first page when page size changes
    });
    _fetchPlans();
  }

  void _goToPage(int pageNumber) {
    // Assuming PaginatedResponseLM will have totalPages
    // Add checks if pageNumber is valid before fetching
    setState(() {
      _currentPageNumber = pageNumber;
    });
    _fetchPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PaginatedResponseLM<Planlm>>(
        future: _futurePlansResponse,
        builder: (context, snapshot) {
          if (_isLoading && !snapshot.hasData) {
            // Show loader if loading and no data yet
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            // This condition might be redundant if _isLoading is handled well
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return Center(child: Text("No records found"));
          }

          // Access plans and pagination data from the snapshot
          List<Planlm> plans = snapshot.data!.items;
          PaginatedResponseLM<Planlm> paginationData = snapshot.data!;

          final int startRecord =
              (paginationData.pageNumber - 1) * paginationData.pageSize + 1;
          final int endRecord = startRecord + plans.length - 1;
          final int totalCount = paginationData.totalCount;
          final bool canGoNext =
              paginationData.pageNumber < paginationData.totalPages;
          final bool canGoPrevious = paginationData.pageNumber > 1;

          return Column(
            children: [
              // Table Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: colors(context).colorGrey3 ??
                              colors(context).colorGrey9!,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: DataTable(
                        // ... other DataTable properties ...
                        headingRowColor: WidgetStateProperty.all(
                          colors(context).colorGrey9!,
                        ),
                        columns: const [
                          DataColumn(label: Text("Master File No")),
                          DataColumn(label: Text("Plan Type")),
                          DataColumn(label: Text("Plan No")),
                          DataColumn(
                              label: Text("Requesting Authority Reference No")),
                          DataColumn(label: Center(child: Text("Status"))),
                          DataColumn(label: Center(child: Text("Action"))),
                        ],
                        rows: plans.map((plan) {
                          return DataRow(cells: [
                            DataCell(Text(plan.masterFileNo.toString())),
                            DataCell(Text(plan.planType)),
                            DataCell(Text(plan.planNo)), // planNo is now String
                            DataCell(Text(plan.authorityReferenceNo)),
                            DataCell(Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: PlanStatusLMHelper.color(plan.status)
                                        .withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: PlanStatusLMHelper.color(
                                            plan.status))),
                                child: Text(
                                  PlanStatusLMHelper.displayName(plan.status),
                                  style: TextStyle(
                                      color: PlanStatusLMHelper.color(
                                          plan.status)),
                                ),
                              ),
                            )),
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(PhosphorIcons.eye(
                                        PhosphorIconsStyle.regular)),
                                    onPressed: () {
                                      print("View plan ${plan.id}");
                                      // Example: context.go('/${AppPages.lAMasterFileView}/${plan.id}');
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(PhosphorIcons.pencilSimple(
                                        PhosphorIconsStyle.regular)),
                                    onPressed: () {
                                      print("Edit plan ${plan.id}");
                                      // Example: context.go('/${AppPages.lAMasterFileEdit}/${plan.id}');
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text("Show "),
                        DropdownButton<int>(
                          value: _pageSize,
                          items: _pageSizeOptions.map((size) {
                            return DropdownMenuItem<int>(
                              value: size,
                              child: Text(size.toString()),
                            );
                          }).toList(),
                          onChanged: (newSize) {
                            if (newSize != null) {
                              _changePageSize(newSize);
                            }
                          },
                        ),
                        const Text(" per page"),
                      ],
                    ),
                    Text("$startRecord-$endRecord of $totalCount Records"),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: canGoPrevious
                              ? () => _goToPage(_currentPageNumber - 1)
                              : null, // Disable if no previous page
                        ),
                        Text(
                            "Page $_currentPageNumber of ${paginationData.totalPages}"),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: canGoNext
                              ? () => _goToPage(_currentPageNumber + 1)
                              : null, // Disable if no next page
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
