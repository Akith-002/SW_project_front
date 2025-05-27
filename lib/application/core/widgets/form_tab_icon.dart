import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/widgets/conditionReportForms/land_info_form.dart';
import 'package:land_asset_valuation/application/core/widgets/conditionReportForms/construction_form.dart';
import 'package:land_asset_valuation/application/core/widgets/conditionReportForms/signatures_form.dart';

class FormTabIcons extends StatefulWidget {
  const FormTabIcons({super.key});

  @override
  State<FormTabIcons> createState() => _FormTabIconsState();
}

class _FormTabIconsState extends State<FormTabIcons>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabTitles = [
    "Land Info",
    "Building Info",
    "Other Constructions",
    "Signatures"
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabTitles.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab Bar Navigation
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TabBar(
            controller: _tabController,
            // Remove isScrollable to show all tabs
            indicator: BoxDecoration(
              color: colors(context).colorPrimary6 ?? const Color(0xff007bce),
              borderRadius: BorderRadius.circular(20),
            ),
            indicatorColor: colors(context).colorBlack ?? Colors.transparent,
            dividerColor: colors(context).colorBlack ?? Colors.transparent,
            labelColor: colors(context).colorWhite ?? Colors.white,
            unselectedLabelColor: colors(context).colorBlack ?? Colors.black87,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            labelPadding: EdgeInsets.zero, // Remove extra padding
            tabs: tabTitles.map((title) {
              return Container(
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.transparent, width: 0),
                  ),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 24),

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const LandInfoForm(),
              ConstructionForm(tabIndex: 1, tabController: _tabController),
              ConstructionForm(tabIndex: 2, tabController: _tabController),
              const SignaturesForm(),
            ],
          ),
        ),
      ],
    );
  }
}
