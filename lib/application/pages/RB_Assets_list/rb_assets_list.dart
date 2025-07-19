import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/assetListTable/asset_list_table.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/pages/RB_Assets_list/cubit/rb_assets_list_cubit.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:land_asset_valuation/injection.dart';

class RbAssetsList extends BasePage {
  final String? source;
  final int? requestId;

  const RbAssetsList({
    super.key,
    this.source,
    this.requestId,
  });

  @override
  State<RbAssetsList> createState() => _RbAssetsListState();
}

class _RbAssetsListState extends BasePageState<RbAssetsList> {
  final _cubit = injection<RbAssetsListCubit>();
  // Generate sample assets based on the asset type
  List<Asset> _generateSampleAssets() {
    List<Asset> assets = []; // Generate RB-specific sample data
    for (int i = 1; i <= 7; i++) {
      assets.add(Asset(
        id: i,
        assetNo: 'RB${i.toString().padLeft(3, '0')}',
        ward: 'Ward ${(i % 4) + 1}',
        rdSt: 'Building Road ${String.fromCharCode(65 + (i % 10))}',
        description: i % 3 == 0 ? 'Building Complex $i' : 'Building Unit $i',
        owner: 'Building Owner $i',
        status: i % 3 == 0 ? AssetStatus.completed : AssetStatus.active,
        isRatingCard: i <= 4, // First 4 assets have rating cards
        area: (i * 650.0) +
            (i * 75.5), // Area in square meters, ranging from 725.5 to 5078.5
        location:
            'Lat: ${10.2 + (i * 0.025)}, Lng: ${76.2 + (i * 0.02)}', // Sample coordinates for building area
      ));
    }

    return assets;
  }

  void _onAssetSelected(Asset asset) {
    debugPrint('Selected RB asset: ${asset.assetNo}');
    // Handle single asset selection
  }

  void _onAssetsSelected(List<Asset> assets) {
    debugPrint('Selected ${assets.length} RB assets');
    // Handle multiple asset selection
  }

  void _refreshAssets() {
    debugPrint('Refreshing RB assets...');

    // Show a brief loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing assets...'),
        duration: Duration(seconds: 1),
      ),
    );

    // In a real app, this would reload data from the cubit
    setState(() {
      // This will trigger a rebuild and regenerate the sample data
    });
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
        title = AppString.ratingAssessmentRA.localize(context)!;
        breadcrumbItems = [
          AppString.massRating.localize(context)!,
          AppString.ratingAssessment.localize(context)!,
          AppString.request.localize(context)!,
        ];
        break;
      case 'ratingBuilding':
        title = AppString.ratingBuildingRB.localize(context)!;
        breadcrumbItems = [
          AppString.massRating.localize(context)!,
          AppString.ratingBuilding.localize(context)!,
          AppString.request.localize(context)!,
        ];
        break;
      case 'ratingObject':
        title = AppString.ratingObjectRO.localize(context)!;
        breadcrumbItems = [
          AppString.massRating.localize(context)!,
          AppString.ratingObject.localize(context)!,
          AppString.request.localize(context)!,
        ];
        break;
      case 'massRating':
      default:
        title = AppString.ratingBuildingRB.localize(context)!;
        breadcrumbItems = [
          AppString.massRating.localize(context)!,
          AppString.ratingBuilding.localize(context)!,
          AppString.request.localize(context)!,
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
                assetType: 'RB',
                onAssetSelected: _onAssetSelected,
                onAssetsSelected: _onAssetsSelected,
                onRefresh: _refreshAssets,
              ),
            ],
          ),
        ));
  }

  @override
  BaseCubit<BaseState> getCubit() => _cubit;
}
