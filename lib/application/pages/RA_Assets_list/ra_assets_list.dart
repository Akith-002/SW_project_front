import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/assetListTable/asset_list_table.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/pages/RA_Assets_list/cubit/ra_assets_list_cubit.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:land_asset_valuation/injection.dart';

class RaAssetsList extends BasePage {
  final String? source;
  final int? requestId;

  const RaAssetsList({
    super.key,
    this.source,
    this.requestId,
  });

  @override
  State<RaAssetsList> createState() => _RaAssetsListState();
}

class _RaAssetsListState extends BasePageState<RaAssetsList> {
  final _cubit = injection<RaAssetsListCubit>();
  // Generate sample assets based on the asset type
  List<Asset> _generateSampleAssets() {
    List<Asset> assets = []; // Generate RA-specific sample data
    for (int i = 1; i <= 6; i++) {
      assets.add(Asset(
        id: i,
        assetNo: 'RA${i.toString().padLeft(3, '0')}',
        ward: 'Ward ${(i % 3) + 1}',
        rdSt: 'Assessment Road ${String.fromCharCode(65 + (i % 8))}',
        description: i % 2 == 0
            ? 'Assessment Property Type A'
            : 'Assessment Property Type B',
        owner: 'Assessment Owner $i',
        status: i % 4 == 0 ? AssetStatus.completed : AssetStatus.active,
        isRatingCard: i % 2 == 0, // Alternating pattern for rating cards
        area: (i * 800.0) +
            (i *
                150.25), // Area in square meters, ranging from 950.25 to 5701.5
        location:
            'Lat: ${9.5 + (i * 0.02)}, Lng: ${76.5 + (i * 0.015)}', // Sample coordinates for assessment area
      ));
    }
    return assets;
  }

  void _onAssetSelected(Asset asset) {
    debugPrint('Selected RA asset: ${asset.assetNo}');
    // Handle single asset selection
  }

  void _onAssetsSelected(List<Asset> assets) {
    debugPrint('Selected ${assets.length} RA assets');
    // Handle multiple asset selection
  }

  @override
  Widget buildView(BuildContext context) {
    // Generate dynamic assets based on source
    List<Asset> assets = _generateSampleAssets();

    // Determine title and breadcrumb based on source
    String title;
    List<String> breadcrumbItems;

    switch (widget.source) {
      case 'ratingAssessment':
        title = AppString.ratingAssessmentRA.l10n(context)!;
        breadcrumbItems = [
          AppString.massRating.l10n(context)!,
          AppString.ratingAssessment.l10n(context)!,
          AppString.request.l10n(context)!,
        ];
        break;
      case 'ratingBuilding':
        title = AppString.ratingBuildingRB.l10n(context)!;
        breadcrumbItems = [
          AppString.massRating.l10n(context)!,
          AppString.ratingBuilding.l10n(context)!,
          AppString.request.l10n(context)!,
        ];
        break;
      case 'ratingObject':
        title = AppString.ratingObjectRO.l10n(context)!;
        breadcrumbItems = [
          AppString.massRating.l10n(context)!,
          AppString.ratingObject.l10n(context)!,
          AppString.request.l10n(context)!,
        ];
        break;
      case 'massRating':
      default:
        title = AppString.ratingAssessmentRA.l10n(context)!;
        breadcrumbItems = [
          AppString.massRating.l10n(context)!,
          AppString.ratingAssessment.l10n(context)!,
          AppString.request.l10n(context)!,
        ];
        break;
    }

    return Scaffold(
        appBar: CustomAppBar(title: title),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Breadcrumb(items: [
                for (var item in breadcrumbItems) BreadcrumbItem(label: item),
              ]),
              AssetListTable(
                assets: assets,
                assetType: 'RA',
                onAssetSelected: _onAssetSelected,
                onAssetsSelected: _onAssetsSelected,
              ),
            ],
          ),
        ));
  }

  @override
  BaseCubit<BaseState> getCubit() => _cubit;
}
