import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/iconButtonWidget/icon_button_widget.dart';
import 'package:land_asset_valuation/application/core/widgets/editRatingCardDialog/edit_rating_card_dialog.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

final sidebarExtendedController = StreamController<bool>.broadcast();

class AssetListTable extends StatefulWidget {
  final List<Asset> assets;
  final String? assetType;
  final Function(Asset)? onAssetSelected;
  final Function(List<Asset>)? onAssetsSelected;

  const AssetListTable({
    super.key,
    this.assets = const [],
    this.assetType,
    this.onAssetSelected,
    this.onAssetsSelected,
  });

  @override
  State<AssetListTable> createState() => _AssetListTableState();
}

class _AssetListTableState extends State<AssetListTable> {
  late List<bool> isChecked;
  bool isSidebarExtended = true;

  @override
  void initState() {
    super.initState();
    isChecked = List.generate(widget.assets.length, (index) => false);
    sidebarExtendedController.stream.listen((extended) {
      setState(() {
        isSidebarExtended = extended;
      });
    });
  }

  @override
  void didUpdateWidget(AssetListTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assets.length != widget.assets.length) {
      isChecked = List.generate(widget.assets.length, (index) => false);
    }
  }

  // Helper method to check if any assets are selected
  bool get hasSelectedAssets {
    return isChecked.any((checked) => checked);
  }

  // Helper method to check if all selected assets have rating cards
  bool get selectedAssetsHaveRatingCards {
    List<int> selectedIndices = [];
    for (int i = 0; i < isChecked.length; i++) {
      if (isChecked[i]) {
        selectedIndices.add(i);
      }
    }

    if (selectedIndices.isEmpty) return false;

    // Check if all selected assets have rating cards
    return selectedIndices.every((index) =>
        index < widget.assets.length && widget.assets[index].isRatingCard);
  } // Helper method to get button text based on selection state

  String _getButtonText(BuildContext context) {
    // Get selected assets count
    int selectedCount = isChecked.where((checked) => checked).length;

    if (selectedCount == 1) {
      // Single asset selected - check if it has rating card
      for (int i = 0; i < isChecked.length; i++) {
        if (isChecked[i]) {
          Asset selectedAsset = widget.assets[i];
          return selectedAsset.isRatingCard ? "Decisions" : "Decisions";
        }
      }
    }

    // Multiple assets selected
    return AppString.decisions.localize(context)!;
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
                  "${AppString.allAssets.localize(context)!}${widget.assets.length}",
                  style: AppStyling.semiBoldTextSize16.copyWith(
                    color: colors(context).colorBlack,
                  ),
                ),
                Spacer(), // Only show Decisions button when assets are selected
                if (hasSelectedAssets) ...[
                  OutlinedButton(
                    onPressed: () {
                      // Get selected assets
                      List<Asset> selectedAssets = [];
                      for (int i = 0; i < isChecked.length; i++) {
                        if (isChecked[i]) {
                          selectedAssets.add(widget.assets[i]);
                        }
                      } // Check number of selected assets
                      if (selectedAssets.length == 1) {
                        // Single asset selected
                        Asset selectedAsset = selectedAssets.first;
                        if (selectedAsset.isRatingCard) {
                          // Show edit rating card dialog for existing rating card
                          EditRatingCardDialog.showEditRatingCardDialog(
                              context);
                        } else {
                          // Show create rating card dialog for new rating card
                          EditRatingCardDialog.showAddRatingCardDialog(context,
                              sourceContext: widget.assetType);
                        }
                      } else {
                        // Multiple assets selected - show multi-select decision dialog
                        EditRatingCardDialog
                            .showMultiSelectEditRatingCardDialog(
                                context, selectedAssets);
                      }
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
                      _getButtonText(context),
                      style: AppStyling.boldTextSize12.copyWith(
                        color: colors(context).colorPrimary6,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                ],
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
                      ), // Dynamic data rows
                      ...List.generate(
                        widget.assets.length,
                        (index) => _buildDataRow(index, context),
                      ),
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
    final Asset asset = widget.assets[index];

    return TableRow(
      children: [
        SizedBox(
          height: 52,
          child: Checkbox(
            value: isChecked[index],
            onChanged: (bool? value) {
              setState(() {
                isChecked[index] = value ?? false;

                // Handle callbacks
                if (value == true) {
                  // Asset selected
                  widget.onAssetSelected?.call(asset);
                }

                // Get all selected assets
                List<Asset> selectedAssets = [];
                for (int i = 0; i < isChecked.length; i++) {
                  if (isChecked[i]) {
                    selectedAssets.add(widget.assets[i]);
                  }
                }
                widget.onAssetsSelected?.call(selectedAssets);
              });
            },
          ),
        ),
        _buildDataCell(asset.assetNo),
        _buildDataCell(asset.ward),
        _buildDataCell(asset.rdSt),
        _buildDataCell(asset.description),
        _buildDataCell(asset.owner),
        SizedBox(
          height: 52,
          child: Row(
            children: [
              iconButtonWidget(
                color: colors(context).colorGrey8!,
                iconName: PhosphorIconsRegular.mapPin,
                onPressed: () {
                  context.go(Pages.routeMapScreen.toPath());
                },
              ),
              SizedBox(width: 8),
              iconButtonWidget(
                color: colors(context).colorPrimary6!,
                iconName: asset.isRatingCard
                    ? PhosphorIconsRegular
                        .pencilSimpleLine // Edit existing rating card
                    : PhosphorIconsRegular
                        .folderSimplePlus, // Add new rating card
                onPressed: () {
                  // Handle edit action for this specific asset
                  widget.onAssetSelected?.call(asset);
                },
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
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(
        text,
        style: AppStyling.normalTextSize14,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
