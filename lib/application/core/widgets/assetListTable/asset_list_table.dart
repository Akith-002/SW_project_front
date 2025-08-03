import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/iconButtonWidget/icon_button_widget.dart';
import 'package:land_asset_valuation/application/core/widgets/editRatingCardDialog/edit_rating_card_dialog.dart';
import 'package:land_asset_valuation/application/core/widgets/advanced_search_dialog.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

// Global stream controller for sidebar state communication
final sidebarExtendedController = StreamController<bool>.broadcast();

/// A table widget that displays a list of assets with selection capabilities
/// and action buttons for rating card management
class AssetListTable extends StatefulWidget {
  final List<Asset> assets;
  final String? assetType; // Used for routing and context determination
  final Function(Asset)? onAssetSelected;
  final Function(List<Asset>)? onAssetsSelected;
  final VoidCallback? onRefresh;
  final TextEditingController? searchController;
  final Function(String)? onSearch;
  final String? ratingReferenceNo;

  const AssetListTable({
    super.key,
    this.assets = const [],
    this.assetType,
    this.onAssetSelected,
    this.onAssetsSelected,
    this.onRefresh,
    this.searchController,
    this.onSearch,
    this.ratingReferenceNo,
  });

  @override
  State<AssetListTable> createState() => _AssetListTableState();
}

class _AssetListTableState extends State<AssetListTable> {
  late List<bool> isChecked; // Tracks checkbox state for each asset
  bool isSidebarExtended = true;
  bool _showFilterDropdown = false;
  String? _selectedSortColumn;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Initialize checkbox states for all assets
    isChecked = List.generate(widget.assets.length, (index) => false);

    // Listen to sidebar state changes for responsive layout
    sidebarExtendedController.stream.listen((extended) {
      setState(() {
        isSidebarExtended = extended;
      });
    });
  }

  @override
  void didUpdateWidget(AssetListTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset checkbox states when asset list changes
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
  }

  /// Determines the appropriate button text based on selection state
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

  /// Maps asset types to their corresponding sidebar navigation indices
  String _getSelectedIndexForAssetType(String? assetType) {
    switch (assetType) {
      case 'massRating':
        return '2';
      case 'RA':
        return '3';
      case 'RB':
        return '4';
      case 'RO':
        return '5';
      default:
        return '2'; // Default to Mass Rating
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate responsive table width based on sidebar state
    double sidebarWidth = isSidebarExtended ? 256.0 : 49.0;
    double screenWidth = MediaQuery.of(context).size.width;
    double tableWidth = screenWidth - sidebarWidth - 32.0;

    // Define responsive column widths
    Map<int, TableColumnWidth> columnWidths = {
      0: const FixedColumnWidth(64.0), // Checkbox column (fixed)
      1: FlexColumnWidth(), // Asset No
      2: FlexColumnWidth(), // Ward
      3: FlexColumnWidth(), // Rd/St
      4: FlexColumnWidth(), // Description
      5: FlexColumnWidth(), // Owner
      6: FlexColumnWidth(), // Action buttons
    };

    return GestureDetector(
      onTap: () {
        // Close dropdown when tapping outside
        if (_showFilterDropdown) {
          setState(() {
            _showFilterDropdown = false;
          });
        }
      },
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Header row with title, controls, and search
                  Row(
                    children: [
                Text(
                  "${AppString.allAssets.localize(context)!}${widget.assets.length}",
                  style: AppStyling.semiBoldTextSize16.copyWith(
                    color: colors(context).colorBlack,
                  ),
                ),
                Spacer(),
                // Show decision button only when assets are selected
                if (hasSelectedAssets) ...[
                  OutlinedButton(
                    onPressed: () {
                      // Collect selected assets
                      List<Asset> selectedAssets = [];
                      for (int i = 0; i < isChecked.length; i++) {
                        if (isChecked[i]) {
                          selectedAssets.add(widget.assets[i]);
                        }
                      }

                      // Handle single vs multiple asset selection
                      if (selectedAssets.length == 1) {
                        Asset selectedAsset = selectedAssets.first;
                        if (selectedAsset.isRatingCard) {
                          // Edit existing rating card
                          EditRatingCardDialog.showEditRatingCardDialog(context,
                              asset: selectedAsset,
                              ratingReferenceNo: widget.ratingReferenceNo);
                        } else {
                          // Create new rating card
                          debugPrint('AssetListTable - Creating rating card with:');
                          debugPrint('  sourceContext: ${widget.assetType}');
                          debugPrint('  assetNo: ${selectedAsset.assetNo}');
                          debugPrint('  ratingReferenceNo: ${widget.ratingReferenceNo}');
                          EditRatingCardDialog.showAddRatingCardDialog(context,
                              sourceContext: widget.assetType,
                              asset: selectedAsset,
                              ratingReferenceNo: widget.ratingReferenceNo);
                        }
                      } else {
                        // Handle multiple asset selection
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
                  SizedBox(width: 12),
                ],
                // Add refresh button
                if (widget.onRefresh != null) ...[
                  IconButton(
                    onPressed: widget.onRefresh,
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Refresh',
                    style: IconButton.styleFrom(
                      backgroundColor: colors(context).colorPrimary8,
                      foregroundColor: colors(context).colorPrimary6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: colors(context).colorPrimary6!,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                ],

                SizedBox(
                  width: 290,
                  height: 37,
                  child: TextField(
                    controller: widget.searchController,
                    onChanged: widget.onSearch,
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
                      suffixIcon: widget.searchController?.text.isNotEmpty ?? false
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                widget.searchController?.clear();
                                widget.onSearch?.call('');
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                // Filter button
                iconButtonWidget(
                  iconName: PhosphorIconsRegular.funnelSimple,
                  color: colors(context).colorBlack!,
                  onPressed: () {
                    setState(() {
                      _showFilterDropdown = !_showFilterDropdown;
                    });
                  },
                ),
                SizedBox(width: 12),
                // Advanced button
                OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AdvancedSearchDialog(
                        onSearch: (searchCriteria) {
                          Navigator.pop(context);
                          // Handle advanced search
                          _performAdvancedSearch(searchCriteria);
                        },
                        onCancel: () {
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
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
            // Main data table
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
                      // Table header row
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
                      // Generate data rows for each asset
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
          ),
          // Filter dropdown overlay
          if (_showFilterDropdown)
            Positioned(
              top: 80, // Adjust based on your layout
              right: 100,
              child: Container(
                decoration: BoxDecoration(
                  color: colors(context).colorWhite,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: colors(context).colorGrey3!.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _sortOptions.entries.map((entry) {
                    final isSelected = _selectedSortColumn == entry.value;
                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedSortColumn = entry.value;
                          _showFilterDropdown = false;
                        });
                        // Call sort on the assets
                        _sortAssets(entry.value);
                      },
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colors(context).colorGrey9!.withOpacity(0.1)
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
                                    ? colors(context).colorPrimary1
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
                                color: colors(context).colorPrimary1,
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
    );
  }

  /// Builds a styled header cell for the table
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

  /// Builds a data row for the table with asset information and action buttons
  TableRow _buildDataRow(int index, BuildContext context) {
    final Asset asset = widget.assets[index];

    return TableRow(
      children: [
        // Checkbox for asset selection
        SizedBox(
          height: 52,
          child: Checkbox(
            value: isChecked[index],
            onChanged: (bool? value) {
              setState(() {
                isChecked[index] = value ?? false;

                // Trigger single asset selection callback
                if (value == true) {
                  widget.onAssetSelected?.call(asset);
                }

                // Collect and trigger multi-asset selection callback
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
        // Asset data cells
        _buildDataCell(asset.assetNo),
        _buildDataCell(asset.ward),
        _buildDataCell(asset.rdSt),
        _buildDataCell(asset.description),
        _buildDataCell(asset.owner),
        // Action buttons column
        SizedBox(
          height: 52,
          child: Row(
            children: [
              // Map location button
              iconButtonWidget(
                color: colors(context).colorGrey8!,
                iconName: PhosphorIconsRegular.mapPin,
                onPressed: () {
                  // Navigate to map screen with appropriate context
                  String selectedIndex =
                      _getSelectedIndexForAssetType(widget.assetType);
                  debugPrint('Selected Index: $selectedIndex');
                  debugPrint('Asset Type: ${widget.assetType}');
                  context.go(
                      '${Pages.routeAssetMapScreen.toPath()}?selectedIndex=$selectedIndex&source=${widget.assetType ?? 'massRating'}');
                },
              ),
              SizedBox(width: 8),
              // Edit/Add rating card button (icon changes based on asset state)
              iconButtonWidget(
                color: colors(context).colorPrimary6!,
                iconName: asset.isRatingCard
                    ? PhosphorIconsRegular.pencilSimpleLine // Edit existing
                    : PhosphorIconsRegular.folderSimplePlus, // Add new
                onPressed: () {
                  if (asset.isRatingCard) {
                    // Edit existing rating card
                    EditRatingCardDialog.showEditRatingCardDialog(context,
                        asset: asset,
                        ratingReferenceNo: widget.ratingReferenceNo);
                  } else {
                    // Create new rating card
                    debugPrint('AssetListTable - Creating rating card with:');
                    debugPrint('  sourceContext: ${widget.assetType}');
                    debugPrint('  assetNo: ${asset.assetNo}');
                    debugPrint('  ratingReferenceNo: ${widget.ratingReferenceNo}');
                    EditRatingCardDialog.showAddRatingCardDialog(context,
                        sourceContext: widget.assetType,
                        asset: asset,
                        ratingReferenceNo: widget.ratingReferenceNo);
                  }
                  widget.onAssetSelected?.call(asset);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a styled data cell with text content
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
    _debounceTimer?.cancel();
    super.dispose();
  }

  // Define sort options for assets
  final Map<String, String> _sortOptions = {
    'Asset No': 'assetNo',
    'Ward': 'ward',
    'Road/Street': 'rdSt',
    'Owner': 'owner',
    'Status': 'status',
  };

  void _sortAssets(String sortBy) {
    // Since assets are passed as props, we need to trigger a parent callback
    // For now, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sorting by $sortBy'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _performAdvancedSearch(Map<String, String> searchCriteria) {
    // Build search query from criteria
    String searchQuery = searchCriteria.entries
        .map((e) => '${e.key}:${e.value}')
        .join(' ');
    
    // Trigger search with advanced criteria
    widget.onSearch?.call(searchQuery);
    
    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching with ${searchCriteria.length} criteria'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
