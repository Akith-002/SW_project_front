import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/fileList/file_list.dart';
import 'package:land_asset_valuation/application/core/widgets/table/table_scaffold.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForLM/table_scaffold_LM.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForMR/table_scaffold_MR.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRA/table_scaffold_RA.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRB/table_scaffold_RB.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRO/table_scaffold_RO.dart';
import 'package:land_asset_valuation/application/pages/LM_Masterfile_list/LM_Masterfile_list.dart';
import 'package:land_asset_valuation/application/pages/MapScreen/map_screen.dart';
import 'package:land_asset_valuation/application/pages/dashboard/dashboard_view.dart';
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

  int _masterFileCount = 0;

  @override
  void initState() {
    super.initState();
    _repository = injection<LandAcquisitionRepository>();
    _loadMasterFileCount();
  }

  void _loadMasterFileCount() async {
    try {
      final response =
          await http.get(Uri.parse("http://10.0.2.2:5221/api/LAMasterfile"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> list = data['masterFiles'];
        setState(() {
          _masterFileCount = list.length;
        });
      }
    } catch (e) {
      print("Failed to load master file count: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildContentForIndex(widget.number);
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
            totalCount: _masterFileCount,
            onSearch: (query) {
              _tableKey.currentState?.search(query);
            },
            table: TableScaffold(
              key: _tableKey,
              pageSource: currentPageSource,
              repository: _repository,
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
            table: TableScaffoldMr(pageSource: currentPageSource),
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
