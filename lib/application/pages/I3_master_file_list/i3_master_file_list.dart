import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/fileList/file_list.dart';
import 'package:land_asset_valuation/application/core/widgets/table/table_scaffold.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForLM/table_scaffold_LM.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForMR/table_scaffold_MR.dart';
import 'package:land_asset_valuation/application/pages/I3_master_file_list/cubit/i3_master_file_list_cubit.dart';
import 'package:land_asset_valuation/application/pages/MapScreen/map_screen.dart';
import 'package:land_asset_valuation/application/pages/dashboard/dashboard_view.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// Main navigation hub for the application that renders different content
/// based on the provided index number.
class I3MasterFileList extends BasePage {
  final int number;

  const I3MasterFileList({
    required this.number,
    super.key,
  });

  @override
  State<I3MasterFileList> createState() => _I3MasterFileListState();
}

class _I3MasterFileListState extends BasePageState<I3MasterFileList> {
  final _cubit = injection<I3MasterFileListCubit>();
  final searchController = TextEditingController();

  @override
  Widget buildView(BuildContext context) {
    // Use widget.number directly
    debugPrint("Building content for index: ${widget.number}");
    return _buildContentForIndex(widget.number);
  }

  /// Maps navigation indices to their corresponding data source identifiers
  /// used by the table scaffolds.
  String _determinePageSource(int index) {
    switch (index) {
      case 1:
        return 'landAcquisition';
      case 8:
        return 'landMiscellaneous';
      // Add other cases if TableScaffold is used elsewhere with a specific source needed
      default:
        return 'unknown'; // Or a sensible default
    }
  }
  // **********************************************************

  Widget _buildContentForIndex(int index) {
    // *** Determine the source for the current index ***
    final String currentPageSource = _determinePageSource(index);
    // ************************************************

    switch (index) {
      case 0:
        return DashboardView();
      case 1: // Land Acquisition
        return Scaffold(
          appBar: CustomAppBar(
            title: AppString.landAcquisition.localize(context)!,
          ),
          body: FileList(
            breadcrumbItems: [
              AppString.landAcquisition.localize(context)!,
            ],
            // *** Pass the determined source ***
            table: TableScaffold(
              pageSource: currentPageSource, // Should be 'landAcquisition'
              // Add other TableScaffold args like initialPageSize if needed
            ),
            // *******************************
          ),
        );
      case 3: // Mass Rating MR
        return Scaffold(
          appBar: CustomAppBar(
            title: AppString.massRatingMR.localize(context)!,
            leftIcon: (p0) => PhosphorIcons.pencilRuler(p0),
          ),
          body: FileList(
            breadcrumbItems: [
              AppString.massRating.localize(context)!,
              AppString.massRating.localize(context)!,
            ],
            table: TableScaffoldMr(), // Assumes this doesn't need the source
          ),
        );
      case 4: // Rating Assessment RA
        return Scaffold(
          appBar: CustomAppBar(
            title: AppString.ratingAssessmentRA.localize(context)!,
            leftIcon: (p0) => PhosphorIcons.pencilRuler(p0),
          ),
          body: FileList(
            breadcrumbItems: [
              AppString.massRating.localize(context)!,
              AppString.ratingAssessment.localize(context)!,
            ],
            table: TableScaffoldMr(), // Assumes this doesn't need the source
          ),
        );
      case 5: // Rating Building RB
        return Scaffold(
          appBar: CustomAppBar(
            title: AppString.ratingBuildingRB.localize(context)!,
            leftIcon: (p0) => PhosphorIcons.pencilRuler(p0),
          ),
         body: FileList(
            breadcrumbItems: [
              AppString.massRating.localize(context)!,
              AppString.ratingBuilding.localize(context)!,
            ],
            table: TableScaffoldMr(), // Assumes this doesn't need the source
          ),
        );
      case 6: // Rating Object RO
        return Scaffold(
          appBar: CustomAppBar(
            title: AppString.ratingObjectRO.localize(context)!,
            leftIcon: (p0) => PhosphorIcons.pencilRuler(p0),
          ),
          body: FileList(
            breadcrumbItems: [
              AppString.massRating.localize(context)!,
              AppString.ratingObject.localize(context)!,
            ],
            table: TableScaffoldMr(), // Assumes this doesn't need the source
          ),
        );
      case 7: // Map Screen
        // Usually navigated to directly, not built here unless it's the only content
        return MapScreen();
      case 8: // Land Miscellaneous
        return Scaffold(
          appBar: CustomAppBar(
            title: AppString.landMiscellaneous.localize(context)!,
            leftIcon: (p0) => PhosphorIcons.pencilRuler(p0),
          ),
          body: FileList(
            breadcrumbItems: [
              AppString.landMiscellaneous.localize(context)!,
            ],
            // *** Pass the determined source ***
            table: TableScaffoldLM(
              pageSource: currentPageSource, // Should be 'landMiscellaneous'
              // Add other TableScaffold args like initialPageSize if needed
            ),
            // *******************************
          ),
        );
      default:
        return Center(child: Text("Content not available for index $index"));
    }
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
