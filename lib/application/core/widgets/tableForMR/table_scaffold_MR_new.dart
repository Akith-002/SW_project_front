import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/pages/mr_requests/cubit/mr_requests_cubit.dart';
import 'package:land_asset_valuation/data/models/mr_request_model.dart';
import 'package:land_asset_valuation/application/core/widgets/view_download_button.dart';
import 'package:land_asset_valuation/application/core/widgets/download_confirmation_dialog.dart';
import 'package:land_asset_valuation/application/core/utils/download_service.dart';

class TableScaffoldMr extends StatefulWidget {
  final int initialPageSize;
  final List<int> pageSizeOptions;
  final String pageSource;

  const TableScaffoldMr({
    super.key,
    required this.pageSource,
    this.initialPageSize = 9,
    this.pageSizeOptions = const [9, 15, 30, 60],
  });

  @override
  State<TableScaffoldMr> createState() => _TableScaffoldMrState();
}

class _TableScaffoldMrState extends State<TableScaffoldMr> {
  String? _nextPageToken;
  late int _pageSize;
  late List<int> _pageSizeOptions;

  @override
  void initState() {
    super.initState();
    _pageSize = widget.initialPageSize;
    _pageSizeOptions = widget.pageSizeOptions;

    // Load data when widget initializes
    context.read<MrRequestsCubit>().loadMassRatingRequests(
          pageSize: _pageSize,
          pageToken: _nextPageToken,
        );
  }

  void _fetchPlans() {
    context.read<MrRequestsCubit>().loadMassRatingRequests(
          pageSize: _pageSize,
          pageToken: _nextPageToken,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MrRequestsCubit, MrRequestsState>(
        builder: (context, state) {
          if (state is MrRequestsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MrRequestsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text("Error: ${state.errorMessage}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchPlans,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (state is MrRequestsLoaded) {
            final requests = state.paginatedResponse.items;

            if (requests.isEmpty) {
              return const Center(child: Text("No records found"));
            }

            return _buildTable(requests, state.paginatedResponse.nextPageToken);
          }

          return const Center(child: Text("No data available"));
        },
      ),
    );
  }

  Widget _buildTable(List<MrRequest> requests, String? nextPageToken) {
    return Column(
      children: [
        // All files count
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'All files (${requests.length})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: colors(context).colorGrey7,
                ),
              ),
            ],
          ),
        ),
        // Table Section
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: 1000,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      colors(context).colorGrey3 ?? colors(context).colorGrey9!,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
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
                rows: requests.map((request) {
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
                                String selectedIndex = '2';
                                switch (widget.pageSource) {
                                  case 'massRating':
                                    selectedIndex = '2';
                                    break;
                                  case 'ratingAssessment':
                                    selectedIndex = '3';
                                    break;
                                  case 'ratingBuilding':
                                    selectedIndex = '4';
                                    break;
                                  case 'ratingObject':
                                    selectedIndex = '5';
                                    break;
                                }
                                context.goNamed(
                                  Pages.routeMrAssetsList.toPathName(),
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

        const SizedBox(height: 16),
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
                        });
                        _fetchPlans();
                      }
                    },
                  ),
                  const Text(" per page"),
                ],
              ),
              Text("${requests.length} Records"),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _nextPageToken == null
                        ? null
                        : () {
                            setState(() {
                              _nextPageToken =
                                  (int.parse(_nextPageToken!) - _pageSize)
                                      .toString();
                            });
                            _fetchPlans();
                          },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: nextPageToken == null
                        ? null
                        : () {
                            setState(() {
                              _nextPageToken = nextPageToken;
                            });
                            _fetchPlans();
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

  void _showDownloadDialog(BuildContext context, MrRequest request) {
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
                await DownloadService.downloadRequestAsJson(request);

                // Show success message
                if (context.mounted) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text('Request ${request.ratingReferenceNo} shared successfully'),
                  //     backgroundColor: Colors.green,
                  //     duration: const Duration(seconds: 3),
                  //   ),
                  // );
                }
              } catch (e) {
                // Show error message
                if (context.mounted) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(
                  //     content: Text('Error sharing request: ${e.toString()}'),
                  //     backgroundColor: Colors.red,
                  //     duration: const Duration(seconds: 3),
                  //   ),
                  // );
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
