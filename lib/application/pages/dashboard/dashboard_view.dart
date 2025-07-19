import 'dart:async';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/table/table_scaffold.dart';
import 'package:land_asset_valuation/application/pages/dashboard/cubit/dashboard_cubit.dart';
import 'package:land_asset_valuation/application/core/widgets/dashboard_card.dart';
import 'package:land_asset_valuation/application/core/widgets/line_chart.dart';
import 'package:land_asset_valuation/application/core/widgets/pie_chart.dart';
import 'package:land_asset_valuation/domain/repositories/land_acquisition_repository.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DashboardView extends BasePage {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends BasePageState<DashboardView> {
  final _cubit = injection<DashboardCubit>();
  final _repository = injection<LandAcquisitionRepository>();
  final GlobalKey<TableScaffoldState> _tableKey =
      GlobalKey<TableScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _showSortDropdown = false;
  String? _selectedSortColumn;
  int _totalFiles = 0;

  // Define the table headers with their API parameter names
  final Map<String, String> _sortOptions = {
    'Master File No': 'masterfileno',
    'Plan Type': 'plantype',
    'Plan No': 'planno',
    'Authority Reference No': 'requestingauthorityreferenceno',
    'Status': 'status',
  };

  void _updateTotalFiles(int count) {
    if (_totalFiles != count) {
      setState(() {
        _totalFiles = count;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      final query = searchController.text.trim();
      _tableKey.currentState?.search(query);
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        leftIcon: (style) => PhosphorIcons.squaresFour(),
        onLeftIconPressed: () {},
        rightIcon1: (style) => PhosphorIcons.bell(style),
        onRightIcon1Pressed: () {},
        rightIcon2: (style) => PhosphorIcons.user(style),
        onRightIcon2Pressed: () {},
      ),
      body: GestureDetector(
        onTap: () {
          // Close dropdown when tapping outside
          if (_showSortDropdown) {
            setState(() {
              _showSortDropdown = false;
            });
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Activity Cards - Wrapped in a Grid for better responsiveness
                    GridView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4, // Adjust for responsiveness
                        childAspectRatio: 2.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      children: [
                        DashboardCard(
                            icon: PhosphorIcons.mapTrifold(),
                            number: '120',
                            title: 'Land Acquisition'),
                        DashboardCard(
                            icon: PhosphorIcons.pencilRuler(),
                            number: '142',
                            title: 'Mass Rating'),
                        DashboardCard(
                            icon: PhosphorIcons.ticket(),
                            number: '96',
                            title: 'Miscellaneous Acquisition'),
                        DashboardCard(
                            icon: PhosphorIcons.check(),
                            number: '28',
                            title: 'Tasks Done'),
                      ],
                    ),
                    // SizedBox(height: 16),

                    /// Charts Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Overview of Acquisitions', // Title for Pie Chart
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 32), // Spacing
                              OverviewChart(),
                            ],
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Activity Trends', // Title for Line Chart
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20), // Spacing
                              LineChartSample2(),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // SizedBox(height: 16),

                    /// Row for Master Files and Search Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Master Files Text
                        Text(
                          'Master Files',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600, // Semi-bold
                          ),
                        ),
                        Row(
                          children: [
                            // Search Bar
                            Container(
                              width: 256,
                              height: 45,
                              decoration: BoxDecoration(
                                color: colors(context).colorGrey1,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: colors(context).colorGrey5!,
                                    width: 1),
                              ),
                              child: TextField(
                                controller: searchController,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Roboto',
                                  color:
                                      colors(context).colorGrey3 ?? Colors.grey,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                    10,
                                    9,
                                    0,
                                    9,
                                  ),
                                  hintText: 'Search',
                                  iconColor:
                                      colors(context).colorGrey3 ?? Colors.grey,
                                  hintStyle: TextStyle(
                                      fontSize: 14, fontFamily: 'Roboto'),
                                  suffixIcon: Icon(
                                      PhosphorIconsThin.magnifyingGlass,
                                      color: colors(context).colorGrey3,
                                      size: 24),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            // Sort Button
                            Container(
                              decoration: BoxDecoration(
                                color: colors(context).colorGrey1,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: colors(context).colorGrey5!,
                                    width: 1),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _showSortDropdown = !_showSortDropdown;
                                  });
                                },
                                icon: Icon(
                                  PhosphorIconsRegular.funnelSimple,
                                  color: colors(context).colorGrey3,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            // Advanced Search Button
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colors(context)
                                    .colorWhite, // Background color
                                minimumSize:
                                    Size(170, 45), // Set width and height
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                  side: BorderSide(
                                    color: Color(0xffD2D5DB), // Border color
                                    width: 1, // Border width
                                  ),
                                ),
                              ),
                              child: Text(
                                'Advanced Search',
                                style: TextStyle(
                                  color: colors(context).colorGrey2,
                                  fontSize: 15, // Font size
                                  fontWeight:
                                      FontWeight.w600, // Semi-bold weight
                                  fontFamily:
                                      'Inter', // Ensure font is set to 'Inter'
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 16),

                    /// Table Section
                    Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 420, // Adjust as needed
                          child: TableScaffold(
                            key: _tableKey,
                            pageSource: 'landAcquisition',
                            repository: _repository,
                            onTotalCountChanged: _updateTotalFiles,
                          ),
                        ),
                        // Dropdown overlay
                        if (_showSortDropdown)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colors(context).colorWhite,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: colors(context)
                                        .colorGrey3!
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _sortOptions.entries.map((entry) {
                                  final isSelected =
                                      _selectedSortColumn == entry.value;
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectedSortColumn = entry.value;
                                        _showSortDropdown = false;
                                      });
                                      _tableKey.currentState
                                          ?.refreshWithSort(entry.value);
                                    },
                                    child: Container(
                                      width: 200,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? colors(context)
                                                .colorGrey9!
                                                .withOpacity(0.1)
                                            : null,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            entry.key,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: isSelected
                                                  ? colors(context)
                                                      .colorPrimary1
                                                  : colors(context).colorBlack,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                          const Spacer(),
                                          if (isSelected)
                                            Icon(
                                              Icons.check,
                                              size: 16,
                                              color:
                                                  colors(context).colorPrimary1,
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
