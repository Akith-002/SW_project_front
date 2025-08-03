import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/fileList/file_list.dart';
import 'package:land_asset_valuation/application/core/widgets/table/table_scaffold.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForMR/table_scaffold_MR.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRA/table_scaffold_RA.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRB/table_scaffold_RB.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRO/table_scaffold_RO.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRA/cubit/ra_requests_cubit.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRA/cubit/ra_requests_state.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRB/cubit/rb_requests_cubit.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRB/cubit/rb_requests_state.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRO/cubit/ro_requests_cubit.dart';
import 'package:land_asset_valuation/application/core/widgets/tableForRO/cubit/ro_requests_state.dart';
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
  int _totalCount = 8;

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
      case 3:
        return 'ratingAssessment';
      case 4:
        return 'ratingBuilding';
      case 5:
        return 'ratingObject';
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
            onSort: (sortBy) {
              _tableKey.currentState?.refreshWithSort(sortBy);
            },
            pageSource: currentPageSource,
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
          body: _MRTableWithCount(pageSource: currentPageSource),
        );

      case 3: // Rating Assessment RA
        return Scaffold(
          appBar: CustomAppBar(
            title: AppString.ratingAssessmentRA.localize(context)!,
            leftIcon: (p0) => PhosphorIcons.pencilRuler(p0),
          ),
          body: _RATableWithCount(pageSource: currentPageSource),
        );

      case 4: // Rating Building RB
        return Scaffold(
          appBar: CustomAppBar(
            title: AppString.ratingBuildingRB.localize(context)!,
            leftIcon: (p0) => PhosphorIcons.pencilRuler(p0),
          ),
          body: _RBTableWithCount(pageSource: currentPageSource),
        );

      case 5: // Rating Object RO
        return Scaffold(
          appBar: CustomAppBar(
            title: AppString.ratingObjectRO.localize(context)!,
            leftIcon: (p0) => PhosphorIcons.pencilRuler(p0),
          ),
          body: _ROTableWithCount(pageSource: currentPageSource),
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

// Stateful widget to manage MR table count
class _MRTableWithCount extends StatefulWidget {
  final String pageSource;

  const _MRTableWithCount({required this.pageSource});

  @override
  State<_MRTableWithCount> createState() => _MRTableWithCountState();
}

class _MRTableWithCountState extends State<_MRTableWithCount> {
  int _totalCount = 0;
  final GlobalKey<TableScaffoldMrState> _tableKey = GlobalKey<TableScaffoldMrState>();

  @override
  Widget build(BuildContext context) {
    return FileList(
      breadcrumbItems: [
        AppString.massRating.localize(context)!,
        AppString.massRating.localize(context)!,
      ],
      totalCount: _totalCount,
      onSearch: (query) {
        _tableKey.currentState?.search(query);
      },
      onSort: (sortBy) {
        _tableKey.currentState?.sort(sortBy);
      },
      pageSource: widget.pageSource,
      table: BlocProvider<MrRequestsCubit>(
        create: (context) => injection<MrRequestsCubit>(),
        child: TableScaffoldMr(
          key: _tableKey,
          pageSource: widget.pageSource,
          onTotalCountChanged: (count) {
            setState(() {
              _totalCount = count;
            });
          },
        ),
      ),
    );
  }
}

// Stateful widget to manage RA table count
class _RATableWithCount extends StatefulWidget {
  final String pageSource;

  const _RATableWithCount({required this.pageSource});

  @override
  State<_RATableWithCount> createState() => _RATableWithCountState();
}

class _RATableWithCountState extends State<_RATableWithCount> {
  int _totalCount = 0;
  final GlobalKey<TableScaffoldRAState> _tableKey = GlobalKey<TableScaffoldRAState>();

  @override
  Widget build(BuildContext context) {
    return FileList(
      breadcrumbItems: [
        AppString.massRating.localize(context)!,
        AppString.ratingAssessment.localize(context)!,
      ],
      totalCount: _totalCount,
      onSearch: (query) {
        _tableKey.currentState?.search(query);
      },
      onSort: (sortBy) {
        _tableKey.currentState?.sort(sortBy);
      },
      pageSource: widget.pageSource,
      table: TableScaffoldRA(
        key: _tableKey,
        pageSource: widget.pageSource,
        onTotalCountChanged: (count) {
          setState(() {
            _totalCount = count;
          });
        },
      ),
    );
  }
}

// Stateful widget to manage RB table count
class _RBTableWithCount extends StatefulWidget {
  final String pageSource;

  const _RBTableWithCount({required this.pageSource});

  @override
  State<_RBTableWithCount> createState() => _RBTableWithCountState();
}

class _RBTableWithCountState extends State<_RBTableWithCount> {
  int _totalCount = 0;
  final GlobalKey<TableScaffoldRBState> _tableKey = GlobalKey<TableScaffoldRBState>();

  @override
  Widget build(BuildContext context) {
    return FileList(
      breadcrumbItems: [
        AppString.massRating.localize(context)!,
        AppString.ratingBuilding.localize(context)!,
      ],
      totalCount: _totalCount,
      onSearch: (query) {
        _tableKey.currentState?.search(query);
      },
      onSort: (sortBy) {
        _tableKey.currentState?.sort(sortBy);
      },
      pageSource: widget.pageSource,
      table: TableScaffoldRB(
        key: _tableKey,
        pageSource: widget.pageSource,
        onTotalCountChanged: (count) {
          setState(() {
            _totalCount = count;
          });
        },
      ),
    );
  }
}

// Stateful widget to manage RO table count
class _ROTableWithCount extends StatefulWidget {
  final String pageSource;

  const _ROTableWithCount({required this.pageSource});

  @override
  State<_ROTableWithCount> createState() => _ROTableWithCountState();
}

class _ROTableWithCountState extends State<_ROTableWithCount> {
  int _totalCount = 0;
  final GlobalKey<TableScaffoldROState> _tableKey = GlobalKey<TableScaffoldROState>();

  @override
  Widget build(BuildContext context) {
    return FileList(
      breadcrumbItems: [
        AppString.massRating.localize(context)!,
        AppString.ratingObject.localize(context)!,
      ],
      totalCount: _totalCount,
      onSearch: (query) {
        _tableKey.currentState?.search(query);
      },
      onSort: (sortBy) {
        _tableKey.currentState?.sort(sortBy);
      },
      pageSource: widget.pageSource,
      table: TableScaffoldRO(
        key: _tableKey,
        pageSource: widget.pageSource,
        onTotalCountChanged: (count) {
          setState(() {
            _totalCount = count;
          });
        },
      ),
    );
  }
}
