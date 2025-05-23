import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/iconButtonWidget/icon_button_widget.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'plan.dart';
import 'plan_repository.dart';

class TableScaffold extends StatefulWidget {
  final int initialPageSize;
  final List<int> pageSizeOptions;
  final String pageSource;

  const TableScaffold({
    super.key,
    required this.pageSource,
    this.initialPageSize = 9,
    this.pageSizeOptions = const [9, 15, 30, 60],
  });

  @override
  TableScaffoldState createState() => TableScaffoldState();
}

class TableScaffoldState extends State<TableScaffold> {
  late Future<PaginatedResponse<Plan>> _futurePlans;
  List<Plan>? _searchResults;
  String? _nextPageToken;
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
      _futurePlans = PlanRepository.getPlans(
        pageSize: _pageSize,
        pageToken: _nextPageToken,
        source: widget.pageSource,
      );
      _searchResults = null;
    });
  }

  void search(String query) async {
    if (widget.pageSource == 'landAcquisition') {
      try {
        final results = await PlanRepository.searchPlans(query);
        setState(() {
          _searchResults = results;
          _nextPageToken = null;
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
      body: FutureBuilder<PaginatedResponse<Plan>>(
        future: _futurePlans,
        builder: (context, snapshot) {
          if (_searchResults != null) {
            return _buildTable(_searchResults!);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return const Center(child: Text("No records found"));
          }

          return _buildTable(snapshot.data!.items, snapshot.data!.nextPageToken);
        },
      ),
    );
  }

  Widget _buildTable(List<Plan> plans, [String? nextPageToken]) {
    return Column(
      children: [
        // Table Section
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1000,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Master File No")),
                DataColumn(label: Text("Plan Type")),
                DataColumn(label: Text("Plan No")),
                DataColumn(label: Text("Requesting Authority Reference No")),
                DataColumn(label: Center(child: Text("Status"))),
                DataColumn(label: Center(child: Text("Action"))),
              ],
              rows: plans.map((plan) {
                return DataRow(cells: [
                  DataCell(Text(plan.masterFileNo.toString())),
                  DataCell(Text(plan.planType)),
                  DataCell(Text(plan.planNo.toString())),
                  DataCell(Text(plan.authorityReferenceNo)),
                  DataCell(Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: plan.status.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      plan.status.displayName,
                      style: TextStyle(
                        color: plan.status.color,
                        fontWeight: FontWeight.bold,
                      ),
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
                                queryParameters: {'source': 'landAcquisition'},
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

        // Footer Section
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
                        child: Text("$size"),
                      );
                    }).toList(),
                    onChanged: (newSize) {
                      if (newSize != null) {
                        setState(() {
                          _pageSize = newSize;
                          _nextPageToken = null;
                          _fetchPlans();
                        });
                      }
                    },
                  ),
                  const Text(" per page"),
                ],
              ),
              Text("${plans.length} Records"),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _nextPageToken == null
                        ? null
                        : () {
                            setState(() {
                              _nextPageToken =
                                  (int.parse(_nextPageToken!) - _pageSize).toString();
                              _fetchPlans();
                            });
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _searchResults != null || nextPageToken == null
                        ? null
                        : () {
                            setState(() {
                              _nextPageToken = nextPageToken;
                              _fetchPlans();
                            });
                          },
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
