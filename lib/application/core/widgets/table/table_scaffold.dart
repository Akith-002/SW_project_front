import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/iconButtonWidget/icon_button_widget.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:land_asset_valuation/data/models/paginated_response.dart';
import 'package:land_asset_valuation/data/models/land_acquisition_master_file_model.dart';
import 'package:land_asset_valuation/domain/repositories/land_acquisition_repository.dart';

class TableScaffold extends StatefulWidget {
  final int initialPageSize;
  final List<int> pageSizeOptions;
  final String pageSource;
  final LandAcquisitionRepository repository;

  const TableScaffold({
    super.key,
    required this.pageSource,
    required this.repository,
    this.initialPageSize = 9,
    this.pageSizeOptions = const [9, 15, 30, 60],
  });

  @override
  TableScaffoldState createState() => TableScaffoldState();
}

class TableScaffoldState extends State<TableScaffold> {
  late Future<PaginatedResponse<LandAcquisitionMasterFile>> _futurePlans;
  List<LandAcquisitionMasterFile>? _searchResults;
  int _currentPage = 1;
  late int _pageSize;
  late List<int> _pageSizeOptions;

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
        pageSize: _pageSize,
      );
    });
  }

  void search(String query) async {
    if (widget.pageSource == 'landAcquisition') {
      try {
        final results = await widget.repository.searchMasterFiles(query);
        setState(() {
          _searchResults = results;
          _currentPage = 1;
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
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<PaginatedResponse<LandAcquisitionMasterFile>>(
              future: _futurePlans,
              builder: (context, snapshot) {
                if (_searchResults != null) {
                  return _buildTable(_searchResults!, null);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text("Error loading data: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                  return const Center(child: Text("No records found"));
                }

                return _buildTable(snapshot.data!.items, snapshot.data);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable(List<LandAcquisitionMasterFile> plans,
      PaginatedResponse<LandAcquisitionMasterFile>? paginationData) {
    final int startRecord = paginationData != null
        ? (paginationData.currentPage * paginationData.pageSize) + 1
        : 1;
    final int endRecord = startRecord + plans.length - 1;
    final int totalCount = paginationData?.totalCount ?? plans.length;

    return Column(
      children: [
        // Table Section
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 20,
                horizontalMargin: 12,
                columns: const [
                  DataColumn(label: Text("Master File No")),
                  DataColumn(label: Text("Plan Type")),
                  DataColumn(label: Text("Plan No")),
                  DataColumn(label: Text("Requesting Authority Ref No")),
                  DataColumn(label: Center(child: Text("Status"))),
                  DataColumn(label: Center(child: Text("Action"))),
                ],
                rows: plans.map((plan) {
                  return DataRow(cells: [
                    DataCell(Text(plan.masterFileNo.toString())),
                    DataCell(Text(plan.planType)),
                    DataCell(Text(plan.planNo.toString())),
                    DataCell(Text(plan.requestingAuthorityReferenceNo)),
                    DataCell(Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getStatusColor(plan.status).withOpacity(0.2),
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
                    )),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          iconButtonWidget(
                            color: colors(context).colorGrey8!,
                            iconName: PhosphorIconsRegular.eye,
                            onPressed: () {
                              context.pushNamed(
                                Pages.routeMapScreen.toPathName(),
                                queryParameters: {'source': 'landAcquisition'},
                              );
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

        // Footer Section
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Show "),
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
                          _fetchPlans();
                        });
                      }
                    },
                  ),
                  const Text(" per page"),
                ],
              ),
              Text("$startRecord-$endRecord of $totalCount Records"),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: paginationData?.hasPrevious == true
                        ? () {
                            setState(() {
                              _currentPage--;
                              _fetchPlans();
                            });
                          }
                        : null,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: paginationData?.hasNext == true
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
