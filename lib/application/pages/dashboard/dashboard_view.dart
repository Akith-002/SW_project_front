import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/dashboard_card.dart';
import 'package:land_asset_valuation/application/core/widgets/line_chart.dart';
import 'package:land_asset_valuation/application/core/widgets/pie_chart.dart';
import 'package:land_asset_valuation/application/core/widgets/table/table_scaffold.dart';

import 'package:land_asset_valuation/application/pages/dashboard/cubit/dashboard_cubit.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class DashboardView extends BasePage {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends BasePageState<DashboardView> {
  final _cubit = injection<DashboardCubit>();

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
      body: LayoutBuilder(
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
                              color:colors(context).colorGrey1,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: colors(context).colorGrey5!, width: 1),
                            ),
                            child: TextField(
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Roboto',
                                color: colors(context).colorGrey3?? Colors.grey,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(
                                10,
                                9,
                                0,
                                9,
                              ),
                              hintText: 'Search',
                              iconColor: colors(context).colorGrey3?? Colors.grey,
                              hintStyle: TextStyle(
                                  fontSize: 14, fontFamily: 'Roboto'),
                              suffixIcon: Icon(
                                  PhosphorIconsThin.magnifyingGlass,color: colors(context).colorGrey3,
                                  size: 24),
                              border: InputBorder.none,
                            ),
                          ),),
                          SizedBox(width: 8),
                          // Advanced Search Button
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors(context).colorWhite, // Background color
                              minimumSize:
                                  Size(170, 45), // Set width and height
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(8), // Rounded corners
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
                                fontWeight: FontWeight.w600, // Semi-bold weight
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
                  SizedBox(
                    width: double.infinity ,
                    height: 420, // Adjust as needed
                    child: TableScaffold(
                      pageSource: 'dashboard',
                      initialPageSize: 6,
                      pageSizeOptions: [6, 12, 18, 24, 30, 36, 42, 48, 54, 60],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
