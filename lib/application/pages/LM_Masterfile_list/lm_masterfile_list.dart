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
  final String currentPageSource;
  const LmMasterfileList({super.key, required this.currentPageSource});

  @override
  State<LmMasterfileList> createState() => _LmMasterfileListState();
}

class _LmMasterfileListState extends BasePageState<LmMasterfileList> {
  final _cubit = injection<LmMasterfileListCubit>();
  final _repository = injection<LandMiscellaneousRepository>();
  final GlobalKey<TableScaffoldLMState> _tableKey =
      GlobalKey<TableScaffoldLMState>();

  final TextEditingController searchController = TextEditingController();
  Timer? _debounceTimer;

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
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final query = searchController.text.trim();
      _tableKey.currentState?.search(query);
    });
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppString.landMiscellaneous.localize(context)!,
        leftIcon: (p0) => PhosphorIcons.pencilRuler(p0),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Breadcrumb(items: [
            BreadcrumbItem(
                label: AppString.landMiscellaneous.localize(context)!)
          ]),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${AppString.all_files.localize(context)!}0",
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
                iconButtonWidget(
                  color: colors(context).colorBlack!,
                  iconName: PhosphorIconsRegular.funnelSimple,
                  onPressed: () {},
                ),
                const SizedBox(width: 12),
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
          ),
          Expanded(
            child: TableScaffoldLM(
              key: _tableKey,
              pageSource: widget.currentPageSource,
              repository: _repository,
            ),
          ),
        ],
      ),
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
