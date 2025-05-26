import 'package:flutter/material.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/assetListTable/asset_list_table.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/pages/MR_Assets_list/cubit/mr_assets_list_cubit.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:land_asset_valuation/injection.dart';

class MrAssetsList extends BasePage {
  final String? source;

  const MrAssetsList({
    super.key,
    this.source,
  });

  @override
  State<MrAssetsList> createState() => _MrAssetsListState();
}

class _MrAssetsListState extends BasePageState<MrAssetsList> {
  final _cubit = injection<MrAssetsListCubit>();

  // Generate sample assets based on the asset type
  List<Asset> _generateSampleAssets() {
    List<Asset> assets = [];

    // Determine asset type prefix based on source
    String typePrefix = '';
    switch (widget.source) {
      case 'ratingAssessment':
        typePrefix = 'RA';
        break;
      case 'ratingBuilding':
        typePrefix = 'RB';
        break;
      case 'ratingObject':
        typePrefix = 'RO';
        break;
      case 'massRating':
      default:
        typePrefix = 'MR';
        break;
    } // Generate sample data
    for (int i = 1; i <= 8; i++) {
      assets.add(Asset(
        id: i,
        assetNo: '$typePrefix${i.toString().padLeft(3, '0')}',
        ward: 'Ward ${(i % 5) + 1}',
        rdSt: 'Road ${String.fromCharCode(65 + (i % 10))}',
        description:
            i % 2 == 0 ? 'Commercial Property' : 'Residential Property',
        owner: 'Owner $i',
        status: i % 3 == 0 ? AssetStatus.completed : AssetStatus.pending,
        isRatingCard: i % 3 != 0, // Some assets have rating cards, some don't
        area: (i * 1000.0) +
            (i *
                250.5), // Area in square meters, ranging from 1250.5 to 10004.0
        location:
            'Lat: ${10.0 + (i * 0.01)}, Lng: ${76.0 + (i * 0.01)}', // Sample coordinates
      ));
    }

    return assets;
  }

  void _onAssetSelected(Asset asset) {
    debugPrint('Selected asset: ${asset.assetNo}');
    // Handle single asset selection
  }

  void _onAssetsSelected(List<Asset> assets) {
    debugPrint('Selected ${assets.length} assets');
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
        title = AppString.massRatingMR.localize(context)!;
        breadcrumbItems = [
          AppString.massRating.localize(context)!,
          AppString.massRating.localize(context)!,
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
                assetType: widget.source,
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
