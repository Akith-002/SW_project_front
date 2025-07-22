import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/assetListTable/asset_list_table.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/pages/MR_Assets_list/cubit/mr_assets_list_cubit.dart';
import 'package:land_asset_valuation/application/pages/MR_Assets_list/cubit/mr_assets_list_state.dart';
import 'package:land_asset_valuation/data/models/asset.dart';
import 'package:land_asset_valuation/domain/usecases/get_request_by_id_usecase.dart';
import 'package:land_asset_valuation/injection.dart';

class MrAssetsList extends BasePage {
  final String? source;
  final int? requestId; // Add requestId parameter

  const MrAssetsList({
    super.key,
    this.source,
    this.requestId,
  });

  @override
  State<MrAssetsList> createState() => _MrAssetsListState();
}

class _MrAssetsListState extends BasePageState<MrAssetsList> {
  final _cubit = injection<MrAssetsListCubit>();
  String? _requestReferenceNo;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load assets with requestType = 1 for MR assets
    _loadAssets();
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
    }
  }

  void _loadAssets() {
    // Use the provided requestId or default to 1
    final requestIdToUse = widget.requestId ?? 1;

    _cubit.loadAssets(
      requestId: requestIdToUse,
      requestType: 'MR',
    );
  }

  void _searchAssets(String query) {
    final requestIdToUse = widget.requestId ?? 1;

    if (query.trim().isEmpty) {
      _loadAssets();
      return;
    }

    _cubit.searchAssets(
      requestId: requestIdToUse,
      requestType: 'MR',
      query: query,
    );
  }

  void _loadMoreAssets(String? nextPageToken) {
    if (nextPageToken == null) return;

    final requestIdToUse = widget.requestId ?? 1;

    _cubit.loadMoreAssets(
      requestId: requestIdToUse,
      requestType: 'MR',
      pageSize: 20,
      nextPageToken: nextPageToken,
    );
  }

  void _onAssetSelected(Asset asset) {
    debugPrint('Selected asset: ${asset.assetNo}');
    // Handle single asset selection
  }

  void _onAssetsSelected(List<Asset> assets) {
    debugPrint('Selected ${assets.length} assets');
    // Handle multiple asset selection
  }

  void _refreshAssets() {
    debugPrint('Refreshing assets...');

    // Clear any existing search
    _searchController.clear();
    
    // Show a brief loading indicator
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing assets...'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Force a fresh load by emitting loading state first
    _cubit.emit(MrAssetsListLoading());
    
    // Small delay to ensure loading state is shown
    Future.delayed(const Duration(milliseconds: 100), () {
      _loadAssets();
    });
  }

  @override
  Widget buildView(BuildContext context) {
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
        title = AppString.massRatingMR.localize(context)!;
        breadcrumbItems = [
          AppString.massRating.localize(context)!,
          AppString.massRating.localize(context)!,
          requestLabel,
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
            // Refresh button section
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            
            ),
            BlocBuilder<MrAssetsListCubit, BaseState<MrAssetsListState>>(
              bloc: _cubit,
              builder: (context, state) {
                if (state is MrAssetsListLoading) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is MrAssetsListError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading assets: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadAssets,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (state is MrAssetsListLoaded) {
                  return AssetListTable(
                    assets: state.assets,
                    assetType: widget.source,
                    onAssetSelected: _onAssetSelected,
                    onAssetsSelected: _onAssetsSelected,
                    onRefresh: _refreshAssets,
                    searchController: _searchController,
                    onSearch: _searchAssets,
                  );
                } else if (state is MrAssetsListSearchLoaded) {
                  return AssetListTable(
                    assets: state.searchResults,
                    assetType: widget.source,
                    onAssetSelected: _onAssetSelected,
                    onAssetsSelected: _onAssetsSelected,
                    onRefresh: _refreshAssets,
                    searchController: _searchController,
                    onSearch: _searchAssets,
                  );
                } else {
                  // Initial state - show empty state or loading
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('Loading assets...'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  BaseCubit<BaseState> getCubit() => _cubit;
}
