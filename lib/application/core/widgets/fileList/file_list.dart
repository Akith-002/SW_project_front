import 'dart:async';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/iconButtonWidget/icon_button_widget.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FileList extends StatefulWidget {
  final List<String> breadcrumbItems;
  final Widget table;
  final void Function(String)? onSearch;
  final void Function(String)? onSort;
  final int totalCount;
  final String? pageSource;

  const FileList({
    super.key,
    required this.breadcrumbItems,
    required this.table,
    this.onSearch,
    this.onSort,
    this.totalCount = 0,
    this.pageSource,
  });

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  final searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _showSortDropdown = false;
  String? _selectedSortColumn;

  // Define the table headers with their API parameter names
  Map<String, String> get _sortOptions {
    // Different sort options based on page source
    if (widget.pageSource == 'massRating' || 
        widget.pageSource == 'ratingAssessment' || 
        widget.pageSource == 'ratingBuilding' || 
        widget.pageSource == 'ratingObject') {
      return {
        'Rating Reference No': 'ratingReferenceNo',
        'Local Authority': 'localAuthority',
        'Year of Revision': 'yearOfRevision',
        'Status': 'status',
      };
    } else {
      // Default for land acquisition
      return {
        'Master File No': 'masterfileno',
        'Plan Type': 'plantype',
        'Plan No': 'planno',
        'Authority Reference No': 'requestingauthorityreferenceno',
        'Status': 'status',
      };
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
      widget.onSearch?.call(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close dropdown when tapping outside
        if (_showSortDropdown) {
          setState(() {
            _showSortDropdown = false;
          });
        }
      },
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Breadcrumb(items: [
                for (var item in widget.breadcrumbItems)
                  BreadcrumbItem(label: item),
              ]),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${AppString.all_files.localize(context)!} (${widget.totalCount})",
                      style: AppStyling.semiBoldTextSize16
                          .copyWith(color: colors(context).colorBlack),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 290,
                      height: 37,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: AppString.search.localize(context),
                          hintStyle: AppStyling.regularTextSize14,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: colors(context).colorGrey5!,
                            ),
                          ),
                          filled: true,
                          fillColor: colors(context).colorGrey1,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    RepaintBoundary(
                      child: iconButtonWidget(
                        color: colors(context).colorBlack!,
                        iconName: PhosphorIconsRegular.funnelSimple,
                        onPressed: () {
                          setState(() {
                            _showSortDropdown = !_showSortDropdown;
                          });
                        },
                      ),
                    ),
                    // Remove the Advanced button
                    // OutlinedButton(
                    //   onPressed: () {},
                    //   style: OutlinedButton.styleFrom(
                    //     side: BorderSide(
                    //       color: colors(context).colorGrey9!,
                    //       width: 1,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    //   child: Text(
                    //     AppString.advanced.localize(context)!,
                    //     style: AppStyling.semiBoldTextSize12.copyWith(
                    //       color: colors(context).colorBlack,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              Expanded(child: widget.table),
            ],
          ),
          // Dropdown overlay
          if (_showSortDropdown)
            Positioned(
              top: 120, // Adjust based on your layout
              right: 16,
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
                          _showSortDropdown = false;
                        });
                        widget.onSort?.call(entry.value);
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
                              style: AppStyling.regularTextSize14.copyWith(
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
}
