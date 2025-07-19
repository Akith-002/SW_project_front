import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/assetListTable/asset_list_table.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/pages/RO_Assets_list/cubit/ro_assets_list_cubit.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:land_asset_valuation/injection.dart';

class RoAssetsList extends BasePage {
  final String? source;
  final int? requestId;

  const RoAssetsList({
    super.key,
    this.source,
    this.requestId,
  });

  @override
  State<RoAssetsList> createState() => _RoAssetsListState();
}

class _RoAssetsListState extends BasePageState<RoAssetsList> {
  final _cubit = injection<RoAssetsListCubit>();
  // Generate sample assets based on the asset type
  List<Asset> _generateSampleAssets() {
    List<Asset> assets = []; // Generate RO-specific sample data
    for (int i = 1; i <= 8; i++) {
      assets.add(Asset(
        id: i,
        assetNo: 'RO${i.toString().padLeft(3, '0')}',
        ward: 'Ward ${(i % 5) + 1}',
        rdSt: 'Object Road ${String.fromCharCode(65 + (i % 12))}',
        description:
            i % 2 == 0 ? 'Commercial Object $i' : 'Residential Object $i',
        owner: 'Object Owner $i',
        status: i % 5 == 0 ? AssetStatus.completed : AssetStatus.active,
        isRatingCard: i % 4 !=
            1, // Most assets have rating cards except every 4th starting from 1
        area: (i * 900.0) +
            (i *
                125.75), // Area in square meters, ranging from 1025.75 to 8206.0
        location:
            'Lat: ${9.8 + (i * 0.03)}, Lng: ${76.8 + (i * 0.025)}', // Sample coordinates for object area
      ));
    }

    return assets;
  }

  void _onAssetSelected(Asset asset) {
    debugPrint('Selected RO asset: ${asset.assetNo}');
    // Handle single asset selection
  }

  void _onAssetsSelected(List<Asset> assets) {
    debugPrint('Selected ${assets.length} RO assets');
    // Handle multiple asset selection
  }

  void _refreshAssets() {
    debugPrint('Refreshing RO assets...');

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
        title = AppString.ratingObjectRO.localize(context)!;
        breadcrumbItems = [
          AppString.massRating.localize(context)!,
          AppString.ratingObject.localize(context)!,
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
                assetType: 'RO',
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
