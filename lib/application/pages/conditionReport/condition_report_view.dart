import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_cubit.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_state.dart';
import 'package:land_asset_valuation/app/base_view.dart';
import 'package:land_asset_valuation/app/cubit/base_cubit.dart';
import 'package:land_asset_valuation/app/cubit/base_state.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/breadcrumb.dart';
import 'package:land_asset_valuation/application/core/widgets/form_tab_icon.dart';

class ConditionReportView extends BasePage {
  const ConditionReportView({super.key});

  @override
  State<ConditionReportView> createState() => _ConditionReportViewState();
}

class _ConditionReportViewState extends BasePageState<ConditionReportView> {
  final _cubit = injection<ConditionReportCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.fetchMasterData();
  }

  @override
  Widget buildView(BuildContext context) {
    return BlocProvider<ConditionReportCubit>.value(
      value: _cubit,
      child: BlocBuilder<ConditionReportCubit, ConditionReportState>(
        builder: (context, state) {
          if (state is MasterDataLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MasterDataLoadFailure) {
            return Center(
                child: Text(
                    'Failed to load master data:  [31m${state.errorMessage} [0m'));
          } else if (state is MasterDataLoadSuccess) {
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ✅ Custom AppBar
                  const CustomAppBar(title: "Condition Report #1234"),

                  // ✅ Breadcrumb Navigation (Full Width)
                  Container(
                    width:
                        double.infinity, // Makes it full width like the App Bar
                    color: const Color(
                        0xFFF3F4F6), // Matches the Breadcrumb's background
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Breadcrumb(
                      items: [
                        BreadcrumbItem(label: "Land Acquisition"),
                        BreadcrumbItem(label: "Master File - #56249"),
                        BreadcrumbItem(label: "Condition Report #1234"),
                      ],
                    ),
                  ),

                  // ✅ FormTabIcons (Now fixed for proper height)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, top: 8.0, bottom: 0.0),
                      child: FormTabIcons(masterData: state.masterData),
                    ),
                  ),
                ],
              ),
            );
          }
          // Default: show loading
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  BaseCubit<BaseState> getCubit() {
    return _cubit;
  }
}
