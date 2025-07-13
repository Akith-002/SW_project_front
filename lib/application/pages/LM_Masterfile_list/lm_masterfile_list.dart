import 'dart:async';
import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/iconButtonWidget/icon_button_widget.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForLM/table_scaffold_LM.dart';
import 'package:land_asset_valuation/application/pages/LM_Masterfile_list/cubit/lm_masterfile_list_cubit.dart';
import 'package:land_asset_valuation/domain/repositories/land_miscellaneous_repository.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LmMasterfileList extends BasePage {
  final String? currentPageSource;
  const LmMasterfileList({super.key, this.currentPageSource});

  @override
  State<LmMasterfileList> createState() => _LmMasterfileListState();
}

class _LmMasterfileListState extends BasePageState<LmMasterfileList> {
  int _totalFiles = 0;
  final _cubit = injection<LmMasterfileListCubit>();
  final _repository = injection<LandMiscellaneousRepository>();
  final GlobalKey<TableScaffoldLMState> _tableKey =
      GlobalKey<TableScaffoldLMState>();
  final TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;
  bool _showSortDropdown = false;
  String? _selectedSortColumn;

  // Define the table headers with their API parameter names
  final Map<String, String> _sortOptions = {
    'Master File No': 'masterfileno',
    'Plan Type': 'plantype',
    'Plan No': 'planno',
    'Authority Reference No': 'requestingauthorityreferenceno',
    'Status': 'status',
  };
  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    print('Sort options: $_sortOptions'); // Debug print
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
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final query = searchController.text.trim();
      _tableKey.currentState?.search(query);
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Close dropdown when tapping outside
        if (_showSortDropdown) {
          setState(() {
            _showSortDropdown = false;
          });
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppString.landMiscellaneous.l10n(context)!,
          leftIcon: (p0) => PhosphorIcons.pencilRuler(p0),
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Breadcrumb(items: [
                  BreadcrumbItem(
                      label: AppString.landMiscellaneous.l10n(context)!)
                ]),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${AppString.all_files.l10n(context)!}$_totalFiles",
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
                            hintText: AppString.search.l10n(context),
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
                      iconButtonWidget(
                        color: colors(context).colorBlack!,
                        iconName: PhosphorIconsRegular.funnelSimple,
                        onPressed: () {
                          setState(() {
                            _showSortDropdown = !_showSortDropdown;
                          });
                          print(
                              'Dropdown state: $_showSortDropdown'); // Debug print
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TableScaffoldLM(
                    key: _tableKey,
                    pageSource: widget.currentPageSource,
                    repository: _repository,
                    onTotalCountChanged: (count) =>
                        setState(() => _totalFiles = count),
                  ),
                ),
              ],
            ),
            // Dropdown overlay
            if (_showSortDropdown)
              Positioned(
                top: 120, // Adjust this value based on your layout
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 250,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors(context).colorWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: colors(context).colorGrey5!,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Sort by Column',
                            style: AppStyling.semiBoldTextSize14.copyWith(
                              color: colors(context).colorBlack,
                            ),
                          ),
                        ),
                        Divider(height: 1, color: colors(context).colorGrey5),
                        ..._sortOptions.entries
                            .map((entry) =>
                                _buildSortOption(entry.key, entry.value))
                            .toList(),
                        const SizedBox(height: 8),
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

  Widget _buildSortOption(String displayName, String apiName) {
    final bool isSelected = _selectedSortColumn == apiName;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedSortColumn = apiName;
          _showSortDropdown = false;
        });
        // Trigger the table to refresh with the new sort option
        _tableKey.currentState?.refreshWithSort(apiName);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? colors(context).colorPrimary1?.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                displayName,
                style: AppStyling.regularTextSize14.copyWith(
                  color: isSelected
                      ? colors(context).colorPrimary1
                      : colors(context).colorBlack,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: colors(context).colorPrimary1,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  PhosphorIconsRegular.check,
                  size: 12,
                  color: colors(context).colorWhite,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
