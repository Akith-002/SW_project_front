import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/fileList/file_list.dart';
import 'package:land_asset_valuation/application/core/widgets/table/table_scaffold.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForLM/table_scaffold_LM.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForMR/table_scaffold_MR.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRA/table_scaffold_RA.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRB/table_scaffold_RB.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRO/table_scaffold_RO.dart';
import 'package:land_asset_valuation/application/pages/I3_master_file_list/cubit/i3_master_file_list_cubit.dart';
import 'package:land_asset_valuation/application/pages/MapScreen/map_screen.dart';
import 'package:land_asset_valuation/application/pages/dashboard/dashboard_view.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
  final GlobalKey<TableScaffoldState> _tableKey = GlobalKey<TableScaffoldState>();

  int _masterFileCount = 0;

  @override
  void initState() {
    super.initState();
    _loadMasterFileCount();
  }

  void _loadMasterFileCount() async {
    try {
      final response = await http.get(Uri.parse("http://10.0.2.2:5221/api/LAMasterfile"));
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
  Widget buildView(BuildContext context) {
    debugPrint("Building content for index: ${widget.number}");
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
            totalCount: _masterFileCount, // ✅ dynamic file count
            onSearch: (query) {
              _tableKey.currentState?.search(query);
            },
            table: TableScaffold(
              key: _tableKey,
              pageSource: currentPageSource,
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
            table: TableScaffoldMr(
              pageSource: currentPageSource,
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
            table: TableScaffoldRA(
              pageSource: currentPageSource,
            ),
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
            table: TableScaffoldRB(
              pageSource: currentPageSource,
            ),
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
            table: TableScaffoldRO(
              pageSource: currentPageSource,
            ),
          ),
        );

      case 6: // Map Screen
        return MapScreen();

      case 7: // Land Miscellaneous
        return Scaffold(
          appBar: CustomAppBar(
            title: AppString.landMiscellaneous.localize(context)!,
            leftIcon: (p0) => PhosphorIcons.pencilRuler(p0),
          ),
          body: FileList(
            breadcrumbItems: [
              AppString.landMiscellaneous.localize(context)!,
            ],
            totalCount: 0,
            table: TableScaffoldLM(
              pageSource: currentPageSource,
            ),
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
