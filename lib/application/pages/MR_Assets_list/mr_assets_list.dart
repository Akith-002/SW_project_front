import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/assetListTable/asset_list_table.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/pages/MR_Assets_list/cubit/mr_assets_list_cubit.dart';
import 'package:land_asset_valuation/injection.dart';

class MrAssetsList extends BasePage {
  const MrAssetsList({super.key});

  @override
  State<MrAssetsList> createState() => _MrAssetsListState();
}

class _MrAssetsListState extends BasePageState<MrAssetsList> {
  final _cubit = injection<MrAssetsListCubit>();

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: AppString.massRatingMR.localize(context)!),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Breadcrumb(items: [
                BreadcrumbItem(
                    label: AppString.massRatingMR.localize(context)!),
                BreadcrumbItem(
                    label: AppString.massRatingMR.localize(context)!),
                BreadcrumbItem(label: AppString.request.localize(context)!),
              ]),
              AssetListTable(),
            ],
          ),
        ));
  }

  @override
  BaseCubit<BaseState> getCubit() => _cubit;
}
