import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/fileList/file_list.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForLM/table_scaffold_LM.dart';
import 'package:land_asset_valuation/application/pages/LM_Masterfile_list/cubit/lm_masterfile_list_cubit.dart';
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

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppString.landMiscellaneous.localize(context)!,
        leftIcon: (p0) => PhosphorIcons.pencilRuler(p0),
      ),
      body: FileList(
        breadcrumbItems: [
          AppString.landMiscellaneous.localize(context)!,
        ],
        totalCount: 0,
        table: TableScaffoldLM(pageSource: widget.currentPageSource),
      ),
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
