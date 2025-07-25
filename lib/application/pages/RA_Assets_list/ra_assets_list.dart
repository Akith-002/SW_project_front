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

  void _refreshAssets() {
    debugPrint('Refreshing RA assets...');

    // Show a brief loading indicator
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //     content: Text('Refreshing assets...'),
    //     duration: Duration(seconds: 1),
    //   ),
    // );

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
        title = AppString.ratingAssessmentRA.localize(context)!;
        breadcrumbItems = [
          AppString.massRating.localize(context)!,
          AppString.ratingAssessment.localize(context)!,
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
                assetType: 'RA',
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
