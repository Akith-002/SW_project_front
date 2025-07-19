import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/fileList/file_list.dart';
import 'package:land_asset_valuation/application/core/widgets/table/table_scaffold.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForMR/table_scaffold_MR.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRA/table_scaffold_RA.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRB/table_scaffold_RB.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRO/table_scaffold_RO.dart';
import 'package:land_asset_valuation/application/pages/I3_master_file_list/cubit/i3_master_file_list_cubit.dart';
import 'package:land_asset_valuation/application/pages/LM_Masterfile_list/LM_Masterfile_list.dart';
import 'package:land_asset_valuation/application/pages/MapScreen/map_screen.dart';
import 'package:land_asset_valuation/application/pages/dashboard/dashboard_view.dart';
import 'package:land_asset_valuation/application/pages/mr_requests/cubit/mr_requests_cubit.dart';
import 'package:land_asset_valuation/domain/repositories/land_acquisition_repository.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class I3MasterFileList extends StatefulWidget {
  final int number;

  const I3MasterFileList({
    required this.number,
    super.key,
  });

  @override
  State<I3MasterFileList> createState() => _I3MasterFileListState();
}

class _I3MasterFileListState extends State<I3MasterFileList> {
  final searchController = TextEditingController();
  final GlobalKey<TableScaffoldState> _tableKey =
      GlobalKey<TableScaffoldState>();
  late final LandAcquisitionRepository _repository;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _repository = injection<LandAcquisitionRepository>();
  }

  void _updateTotalCount(int count) {
    if (mounted && _totalCount != count) {
      setState(() {
        _totalCount = count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<I3MasterFileListCubit>(
      create: (_) => injection<I3MasterFileListCubit>(),
      child: Builder(
        // ✅ fixes the context issue
        builder: (context) => _buildContentForIndex(widget.number),
      ),
    );
  }

  String _determinePageSource(int index) {
    switch (index) {
      case 1:
        return 'landAcquisition';
      case 2:
        return 'massRating';
      case 7:
        return 'landMiscellaneous';
      default:
        return 'unknown';
    }
  }

  Widget _buildContentForIndex(int index) {
    final String currentPageSource = _determinePageSource(index);

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
            totalCount: _totalCount,
            onSearch: (query) {
              _tableKey.currentState?.search(query);
            },
            table: TableScaffold(
              key: _tableKey,
              pageSource: currentPageSource,
              repository: _repository,
              onTotalCountChanged: _updateTotalCount,
            ),
          ),
        );

      case 2: // Mass Rating MR
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
            totalCount: 0,
            table: BlocProvider<MrRequestsCubit>(
              create: (context) => injection<MrRequestsCubit>(),
              child: TableScaffoldMr(pageSource: currentPageSource),
            ),
          ),
        );

      case 3: // Rating Assessment RA
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
            totalCount: 0,
            table: TableScaffoldRA(pageSource: currentPageSource),
          ),
        );

      case 4: // Rating Building RB
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
            totalCount: 0,
            table: TableScaffoldRB(pageSource: currentPageSource),
          ),
        );

      case 5: // Rating Object RO
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
            totalCount: 0,
            table: TableScaffoldRO(pageSource: currentPageSource),
          ),
        );

      case 6:
        return MapScreen();

      case 7:
        return LmMasterfileList(
          currentPageSource: currentPageSource,
        );

      default:
        return const Center(
            child: Text("Content not available for this index."));
    }
  }
}
