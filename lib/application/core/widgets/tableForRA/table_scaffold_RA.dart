import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRA/planRA.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRA/planRA_repository.dart';
import 'package:land_asset_valuation/application/core/widgets/view_download_button.dart';

class TableScaffoldRA extends StatefulWidget {
  final int initialPageSize;
  final List<int> pageSizeOptions;
  final String pageSource;

  const TableScaffoldRA({
    super.key,
    required this.pageSource,
    this.initialPageSize = 9,
    this.pageSizeOptions = const [9, 15, 30, 60],
  });

  @override
  State<TableScaffoldRA> createState() => _TableScaffoldRAState();
}

class _TableScaffoldRAState extends State<TableScaffoldRA> {
  late Future<PaginatedResponseRA<PlanRA>> _futurePlans;
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
      _futurePlans = PlanRARepository.getPlans(
        pageSize: _pageSize,
        pageToken: _nextPageToken,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PaginatedResponseRA<PlanRA>>(
        future: _futurePlans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return Center(child: Text("No records found"));
          }

          List<PlanRA> plans = snapshot.data!.items;

          return Column(
            children: [
              // Table Section
              SingleChildScrollView(
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
                      columns: [
                        DataColumn(label: Text("Rating Reference No")),
                        DataColumn(label: Text("Local Authority")),
                        DataColumn(label: Text("Year of Revision")),
                        DataColumn(label: Center(child: Text("Status"))),
                        DataColumn(label: Center(child: Text("Action"))),
                      ],
                      rows: plans.map((plan) {
                        return DataRow(cells: [
                          DataCell(Text(plan.ratingRefNo.toString())),
                          DataCell(Text(plan.LocalAuthority)),
                          DataCell(Text(plan.yearOfRevision.toString())),
                          DataCell(Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: plan.status.color.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              plan.status.displayName,
                              style: TextStyle(
                                  color: plan.status.color,
                                  fontWeight: FontWeight.bold),
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
                                          '3'; // Default to RA
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
                                        Pages.routeRaAssetsList.toPathName(),
                                        queryParameters: {
                                          'selectedIndex': selectedIndex,
                                          'source': widget.pageSource,
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
                                      debugPrint("Download button pressed");
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

              SizedBox(height: 16),
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
                            if (newSize != null) {
                              setState(() {
                                _pageSize = newSize;
                                _nextPageToken = null;
                                _fetchPlans();
                              });
                            }
                          },
                        ),
                        Text(" per page"),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Total: ${plans.length}"),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: _nextPageToken != null
                              ? () {
                                  _fetchPlans();
                                }
                              : null,
                          child: Text("Load More"),
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
