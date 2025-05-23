import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/iconButtonWidget/icon_button_widget.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForLM/planLM.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForLM/planLM_repository.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';

class TableScaffoldLM extends StatefulWidget {
  final int initialPageSize;
  final List<int> pageSizeOptions;
  // *** ADDED: Required parameter to know the source context ***
  final String pageSource;

  const TableScaffoldLM({
    super.key,
    required this.pageSource, // Make it required
    this.initialPageSize = 9,
    this.pageSizeOptions = const [9, 15, 30, 60],
  });

  @override
  _TableScaffoldState createState() => _TableScaffoldState();
}

class _TableScaffoldState extends State<TableScaffoldLM> {
  late Future<PaginatedResponseLM<Planlm>> _futurePlans;
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
      _futurePlans = PlanlmRepository.getPlans(
        pageSize: _pageSize,
        pageToken: _nextPageToken,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PaginatedResponseLM<Planlm>>(
        future: _futurePlans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return Center(child: Text("No records found"));
          }

          List<Planlm> plans = snapshot.data!.items;

          return Column(
            children: [
              // Table Section
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 1000, // Consider making width more dynamic if possible
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
                      // ... other DataTable properties ...
                      headingRowColor: WidgetStateProperty.all(
                        colors(context).colorGrey9!,
                      ),
                      columns: [
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
                          DataCell(Text(plan.planNo.toString())),
                          DataCell(Text(plan.authorityReferenceNo)),
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
                                  iconButtonWidget(
                                    color: colors(context).colorGrey8!,
                                    iconName: PhosphorIconsRegular.eye,
                                    onPressed: () {
                                      context.pushNamed(
                                          Pages.routeMapScreen.toPathName(),
                                          queryParameters: {
                                            'source': widget.pageSource,
                                            'selectedIndex': '7',
                                          });
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
                                _nextPageToken = null; // Reset pagination
                                _fetchPlans();
                              });
                            }
                          },
                        ),
                        Text(" per page"),
                      ],
                    ),
                    Text("${plans.length} / 60 Records"),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.chevron_left),
                          onPressed: _nextPageToken == null
                              ? null
                              : () {
                                  setState(() {
                                    _nextPageToken =
                                        (int.parse(_nextPageToken!) - _pageSize)
                                            .toString();
                                    _fetchPlans();
                                  });
                                },
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right),
                          onPressed: snapshot.data!.nextPageToken == null
                              ? null
                              : () {
                                  setState(() {
                                    _nextPageToken =
                                        snapshot.data!.nextPageToken;
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
        },
      ),
    );
  }
}
