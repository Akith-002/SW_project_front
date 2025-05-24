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
      crossAxisAlignment: CrossAxisAlignment.start, // Ensure left alignment
      children: [
        // ✅ Tab Bar Navigation (Fully Left-Aligned)
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, top: 8.0, bottom: 0.0), // Ensures proper alignment
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicator: BoxDecoration(
                color: colors(context).colorPrimary6 ?? const Color(0xff007bce),
                borderRadius: BorderRadius.circular(20),
              ),
              indicatorColor: colors(context).colorBlack ??
                  Colors.transparent, // ✅ Removes the tab indicator
              dividerColor: colors(context).colorBlack ??
                  Colors
                      .transparent, // ✅ Fully removes the unwanted bottom line
              labelColor: colors(context).colorWhite ?? Colors.white,
              unselectedLabelColor:
                  colors(context).colorBlack ?? Colors.black87,
              overlayColor: MaterialStateProperty.all(
                  Colors.transparent), // Prevents extra layers
              tabs: tabTitles.map((title) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          color: Colors.transparent,
                          width: 0), // ✅ Hides bottom line completely
                    ),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),

        // ✅ Properly Spaced Below the Tabs
        const SizedBox(height: 24),

        // ✅ Tab View - Switches Forms Directly
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              LandInfoForm(),
              ConstructionForm(tabIndex: 1), // Building Info tab
              ConstructionForm(tabIndex: 2), // Other Constructions tab
              const SignaturesForm(),
            ],
          ),
        ),
      ],
    );
  }
}
