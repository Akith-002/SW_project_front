import 'dart:async';

import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_button.dart';
import 'package:land_asset_valuation/application/core/widgets/dialogbox/dialogbox.dart';
import 'package:land_asset_valuation/application/core/widgets/iconButtonWidget/icon_button_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

final sidebarExtendedController = StreamController<bool>.broadcast();

class AssetListTable extends StatefulWidget {
  const AssetListTable({super.key});

  @override
  State<AssetListTable> createState() => _AssetListTableState();
}

class _AssetListTableState extends State<AssetListTable> {
  List<bool> isChecked = List.generate(5, (index) => false);
  bool isSidebarExtended = true;

  @override
  void initState() {
    super.initState();
    sidebarExtendedController.stream.listen((extended) {
      setState(() {
        isSidebarExtended = extended;
      });
    });
  }

  void _showRatingCardDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int selectedValue = 1; // Default selected value

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            backgroundColor: colors(context).colorWhite,
            contentPadding:
                EdgeInsets.zero, // Remove default padding to control width
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Adds rounded corners
            ),
            content: SizedBox(
              width: 384, // Fixed width
              child: Padding(
                padding: EdgeInsets.all(24), // Internal padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit your rating card',
                      style: AppStyling.boldTextSize22.copyWith(
                        color: colors(context).colorBlack,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Select one of the options",
                      style: AppStyling.regularTextSize16.copyWith(
                        color: colors(context).colorGrey3,
                      ),
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          contentPadding: EdgeInsets.only(
                            left: 0,
                          ),
                          title: Text(
                            'Division',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 1,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.only(
                            left: 0,
                          ),
                          title: Text(
                            'Reconciliation',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 2,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.only(
                            left: 0,
                          ),
                          title: Text(
                            'Change number',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 3,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                        RadioListTile(
                          contentPadding: EdgeInsets.only(left: 0),
                          title: Text(
                            'Due to difficulties',
                            style: AppStyling.normalTextSize16.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                          value: 4,
                          groupValue: selectedValue,
                          activeColor:
                              colors(context).colorPrimary5, // Set blue color
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as int;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          text: AppString.cancel.localize(context)!,
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: colors(context).colorGrey1!,
                        ),
                        SizedBox(width: 20),
                        CustomButton(
                          text: AppString.submit.localize(context)!,
                          onPressed: () {
                            Navigator.pop(context);
                            debugPrint("Selected Option: $selectedValue");
                          },
                          backgroundColor: colors(context).colorPrimary5!,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate available width based on sidebar state
    double sidebarWidth = isSidebarExtended ? 256.0 : 49.0;
    double screenWidth = MediaQuery.of(context).size.width;
    double tableWidth = screenWidth - sidebarWidth - 32.0;

    // Define column widths with fixed checkbox column
    Map<int, TableColumnWidth> columnWidths = {
      0: const FixedColumnWidth(64.0), // Checkbox column
      1: FlexColumnWidth(), // Asset No
      2: FlexColumnWidth(), // Ward
      3: FlexColumnWidth(), // Rd/St
      4: FlexColumnWidth(), // Description (slightly wider)
      5: FlexColumnWidth(), // Owner
      6: FlexColumnWidth(), // Action
    };

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "${AppString.allAssets.localize(context)!}5",
                  style: AppStyling.semiBoldTextSize16.copyWith(
                    color: colors(context).colorBlack,
                  ),
                ),
                Spacer(),
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => Dialogbox(
                        dialogType: "edit",
                        mainText: "Edit rating card?",
                        subText:
                            "Are your sure you want to edit your rating card?",
                        primaryButtonText: AppString.edit.localize(context)!,
                        secondaryButtonText:
                            AppString.cancel.localize(context)!,
                        onPrimaryButtonPressed: () {
                          Navigator.pop(
                              context); // Close the confirmation dialog
                          _showRatingCardDialog(); // Show the rating card dialog
                        },
                        onSecondaryButtonPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: colors(context).colorPrimary6!,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: colors(context).colorPrimary8,
                  ),
                  child: Text(
                    AppString.decisions.localize(context)!,
                    style: AppStyling.boldTextSize12.copyWith(
                      color: colors(context).colorPrimary6,
                    ),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                SizedBox(
                  width: 290,
                  height: 37,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: AppString.search.localize(context),
                      hintStyle: AppStyling.regularTextSize14,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colors(context).colorGrey9!,
                          width: 1,
                        ),
                      ),
                      filled: true,
                      fillColor: colors(context).colorGrey1,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                iconButtonWidget(
                  iconName: PhosphorIconsRegular.funnelSimple,
                  color: colors(context).colorBlack!,
                  onPressed: () {},
                ),
                SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: colors(context).colorGrey9!,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppString.advanced.localize(context)!,
                    style: AppStyling.semiBoldTextSize12.copyWith(
                      color: colors(context).colorBlack,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              width: tableWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    cardTheme: CardTheme(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                    ),
                  ),
                  child: Table(
                    columnWidths: columnWidths,
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: colors(context).colorGrey5!,
                        width: 1,
                      ),
                    ),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: colors(context).colorGrey9,
                        ),
                        children: [
                          _buildHeaderCell('', context),
                          _buildHeaderCell('Asset No', context),
                          _buildHeaderCell('Ward', context),
                          _buildHeaderCell('Rd/St', context),
                          _buildHeaderCell('Description', context),
                          _buildHeaderCell('Owner', context),
                          _buildHeaderCell('Action', context),
                        ],
                      ),
                      ...List.generate(
                          5, (index) => _buildDataRow(index, context)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, BuildContext context) {
    return Container(
      height: 38,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        text,
        style: AppStyling.semiBoldTextSize12.copyWith(
          color: colors(context).colorGrey2,
        ),
      ),
    );
  }

  TableRow _buildDataRow(int index, BuildContext context) {
    return TableRow(
      children: [
        SizedBox(
          height: 52,
          // padding: EdgeInsets.symmetric(horizontal: 8),
          child: Checkbox(
            value: isChecked[index],
            onChanged: (bool? value) {
              setState(() {
                isChecked[index] = value!;
              });
            },
          ),
        ),
        _buildDataCell('Kottawa'),
        _buildDataCell('1'),
        _buildDataCell('Kottawa'),
        _buildDataCell('Domestic'),
        _buildDataCell('Owner'),
        SizedBox(
          height: 52,
          child: Row(
            children: [
              iconButtonWidget(
                color: colors(context).colorGrey8!,
                iconName: PhosphorIconsRegular.mapPin,
                onPressed: () {},
              ),
              SizedBox(width: 8),
              iconButtonWidget(
                color: colors(context).colorPrimary6!,
                iconName: PhosphorIconsRegular.pencilSimpleLine,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDataCell(String text) {
    return Container(
      height: 52,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(text),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
