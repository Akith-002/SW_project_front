import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/assetListTable/asset_list_table.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/pages/RB_Assets_list/cubit/rb_assets_list_cubit.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:land_asset_valuation/domain/usecases/get_request_by_id_usecase.dart';
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
  String? _requestReferenceNo;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _fetchRequestDetails();
  }

  Future<void> _fetchRequestDetails() async {
    if (widget.requestId != null) {
      try {
        final getRequestById = injection<GetRequestByIdUseCase>();
        final request = await getRequestById(widget.requestId!);
        if (mounted) {
          setState(() {
            _requestReferenceNo = request.ratingReferenceNo;
            debugPrint('RbAssetsList - Loaded ratingReferenceNo: $_requestReferenceNo');
          });
        }
      } catch (e) {
        debugPrint('Error fetching request details: $e');
        // Fallback to a default format
        if (mounted) {
          setState(() {
            _requestReferenceNo = 'Request ${widget.requestId}';
          });
        }
      }
    } else {
      // For testing, use a dummy reference number
      setState(() {
        _requestReferenceNo = 'RB-REF-2024-001';
        debugPrint('RbAssetsList - Using dummy ratingReferenceNo: $_requestReferenceNo');
      });
    }
  }

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

  void _searchAssets(String query) {
    debugPrint('Searching RB assets...');
    // In a real implementation, this would filter the assets
    // For now, just rebuild to show the same data
    setState(() {});
  }

  List<BreadcrumbItem> _buildBreadcrumbItems(List<String> breadcrumbItems) {
    final items = <BreadcrumbItem>[];
    
    for (int i = 0; i < breadcrumbItems.length; i++) {
      final label = breadcrumbItems[i];
      final isLast = i == breadcrumbItems.length - 1;
      
      // Don't make the last item clickable (current page)
      if (isLast) {
        items.add(BreadcrumbItem(label: label));
      } else {
        items.add(BreadcrumbItem(
          label: label,
          onTap: () => _navigateToBreadcrumb(i, label),
        ));
      }
    }
    
    return items;
  }

  void _navigateToBreadcrumb(int index, String label) {
    // First breadcrumb is always "Mass Rating" main section
    if (index == 0) {
      // Navigate to Mass Rating main page
      context.goNamed(
        Pages.routeI3MasterFileList.toPathName(),
        queryParameters: {'selectedIndex': '2'},
      );
    } 
    // Second breadcrumb is the sub-section (Mass Rating, Rating Assessment, etc.)
    else if (index == 1) {
      String selectedIndex = '4'; // Default to Rating Building
      
      switch (widget.source) {
        case 'ratingAssessment':
          selectedIndex = '3';
          break;
        case 'ratingBuilding':
          selectedIndex = '4';
          break;
        case 'ratingObject':
          selectedIndex = '5';
          break;
        case 'massRating':
          selectedIndex = '2';
          break;
        default:
          selectedIndex = '4'; // Default to Rating Building for RB
          break;
      }
      
      // Navigate to the appropriate sub-section
      context.goNamed(
        Pages.routeI3MasterFileList.toPathName(),
        queryParameters: {'selectedIndex': selectedIndex},
      );
    }
  }

  @override
  Widget buildView(BuildContext context) {
    // Generate dynamic assets based on source
    List<Asset> assets = _generateSampleAssets();
    // Determine title and breadcrumb based on source
    String title;
    List<String> breadcrumbItems;

    // Use request reference number if available, otherwise use 'Request'
    final String requestLabel = _requestReferenceNo ?? AppString.request.localize(context)!;

    switch (widget.source) {
      case 'ratingAssessment':
        title = AppString.ratingAssessmentRA.localize(context)!;
        breadcrumbItems = [
          AppString.massRating.localize(context)!,
          AppString.ratingAssessment.localize(context)!,
          requestLabel,
        ];
        break;
      case 'ratingBuilding':
        title = AppString.ratingBuildingRB.localize(context)!;
        breadcrumbItems = [
          AppString.massRating.localize(context)!,
          AppString.ratingBuilding.localize(context)!,
          requestLabel,
        ];
        break;
      case 'ratingObject':
        title = AppString.ratingObjectRO.localize(context)!;
        breadcrumbItems = [
          AppString.massRating.localize(context)!,
          AppString.ratingObject.localize(context)!,
          requestLabel,
        ];
        break;
      case 'massRating':
      default:
        title = AppString.ratingBuildingRB.localize(context)!;
        breadcrumbItems = [
          AppString.massRating.localize(context)!,
          AppString.ratingBuilding.localize(context)!,
          requestLabel,
        ];
        break;
    }

    return Scaffold(
        appBar: CustomAppBar(title: title),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Breadcrumb(items: _buildBreadcrumbItems(breadcrumbItems)),
              AssetListTable(
                assets: assets,
                assetType: 'ratingBuilding',
                onAssetSelected: _onAssetSelected,
                onAssetsSelected: _onAssetsSelected,
                onRefresh: _refreshAssets,
                searchController: _searchController,
                onSearch: _searchAssets,
                ratingReferenceNo: _requestReferenceNo,
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  BaseCubit<BaseState> getCubit() => _cubit;
}
