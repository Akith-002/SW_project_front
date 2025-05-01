import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForMR/planMR.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForMR/planMR_repository.dart';

class TableScaffoldMr extends StatefulWidget {
  const TableScaffoldMr({super.key});

  @override
  State<TableScaffoldMr> createState() => _TableScaffoldMrState();
}

class _TableScaffoldMrState extends State<TableScaffoldMr> {
  late Future<PaginatedResponseMR<Planmr>> _futurePlans;
  String? _nextPageToken;
  int _pageSize = 9;
  final List<int> _pageSizeOptions = [9, 15, 30, 60];

  @override
  void initState() {
    super.initState();
    _fetchPlans();
  }

  void _fetchPlans() {
    setState(() {
      _futurePlans = PlanmrRepository.getPlans(
          pageSize: _pageSize, pageToken: _nextPageToken);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PaginatedResponseMR<Planmr>>(
        future: _futurePlans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data"));
          } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
            return Center(child: Text("No records found"));
          }

          List<Planmr> plans = snapshot.data!.items;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection:
                        Axis.vertical, // Enables vertical scrolling
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.resolveWith(
                          (states) => Color(0xffF3F4F6)),
                      headingRowHeight: 38,
                      dataRowHeight: 52,
                      headingTextStyle: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff394050)),
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
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(Icons.visibility),
                                    onPressed: () {
                                      context.pushNamed(
                                        Pages.routeMapScreen.toPathName(),
                                        queryParameters: {
                                          'source': 'massRating',
                                        },
                                      );
                                    }),
                                // IconButton(
                                //     icon: Icon(Icons.download),
                                //     onPressed: () {}),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
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
