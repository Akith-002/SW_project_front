import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/pie_chart.dart';
import 'package:land_asset_valuation/application/core/widgets/line_chart.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppString.profile.localize(context)!,
        style: AppStyling.semiBoldTextSize16
            .copyWith(color: colors(context).colorGrey6),
        leftIcon: (style) => PhosphorIcons.userCircle(style),
        rightIcon1: (style) => PhosphorIcons.bell(style),
        rightIcon2: (style) => PhosphorIcons.user(style),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileCard(),

            // Overview section
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 16.0),
              child: Text(
                AppString.overview.localize(context)!,
                style: AppStyling.semiBoldTextSize14
                    .copyWith(color: colors(context).colorGrey6),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(child: OverviewChart()), // Pie Chart
                  SizedBox(width: 24),
                  Expanded(child: LineChartSample2()), // Line Graph
                ],
              ),
            ),

            const SizedBox(height: 16),

            // My Activities Title
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                AppString.myActivities.localize(context)!,
                style: AppStyling.semiBoldTextSize14
                    .copyWith(color: colors(context).colorGrey6),
              ),
            ),

            const SizedBox(height: 12),

            // Horizontal scrollable cards
            Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: IntrinsicWidth(
                  child: Row(
                    children: [
                      CustomActivityCard(
                        title: AppString.totalActivities.localize(context)!,
                        completed: 120,
                        pending: 27,
                        icon: PhosphorIcons.pulse(PhosphorIconsStyle.regular),
                      ),
                      const SizedBox(width: 12),
                      CustomActivityCard(
                        title: AppString.landAcquisition.localize(context)!,
                        completed: 120,
                        pending: 27,
                        icon: PhosphorIcons.mapTrifold(
                            PhosphorIconsStyle.regular),
                      ),
                      const SizedBox(width: 12),
                      CustomActivityCard(
                        title: AppString.massRating.localize(context)!,
                        completed: 120,
                        pending: 27,
                        icon: PhosphorIcons.pencilRuler(
                            PhosphorIconsStyle.regular),
                      ),
                      const SizedBox(width: 12),
                      CustomActivityCard(
                        title: AppString.landMiscellaneous.localize(context)!,
                        completed: 120,
                        pending: 27,
                        icon: PhosphorIcons.ticket(PhosphorIconsStyle.regular),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: colors(context).colorPrimary7,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('images/pngs/image 1.png'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.johnDoe.localize(context)!,
                          style: AppStyling.semiBoldTextSize18.copyWith(
                            color: colors(context).colorGrey2,
                          )),
                      Text(AppString.email.localize(context)!,
                          style: AppStyling.regularTextSize14.copyWith(
                            color: colors(context).colorGrey8,
                          )),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.employeeId.localize(context)!,
                          style: AppStyling.regularTextSize12.copyWith(
                            color: colors(context).colorGrey8,
                          )),
                      Text(AppString.id.localize(context)!,
                          style: AppStyling.semiBoldTextSize16.copyWith(
                            color: colors(context).colorGrey2,
                          )),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.position.localize(context)!,
                          style: AppStyling.regularTextSize12.copyWith(
                            color: colors(context).colorGrey8,
                          )),
                      Text(AppString.adv.localize(context)!,
                          style: AppStyling.semiBoldTextSize16.copyWith(
                            color: colors(context).colorGrey2,
                          )),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppString.assignedDivision.localize(context)!,
                          style: AppStyling.regularTextSize12.copyWith(
                            color: colors(context).colorGrey8,
                          )),
                      Text(AppString.kollupitiya.localize(context)!,
                          style: AppStyling.semiBoldTextSize16.copyWith(
                            color: colors(context).colorGrey2,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomActivityCard extends StatelessWidget {
  final String title;
  final int completed;
  final int pending;
  final IconData icon;

  const CustomActivityCard({
    super.key,
    required this.title,
    required this.completed,
    required this.pending,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 239,
      height: 112,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: AppStyling.regularTextSize12.copyWith(
                    color: colors(context).colorGrey2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$completed',
                    style: AppStyling.boldTextSize22.copyWith(
                      color: colors(context).colorGrey2,
                    ),
                  ),
                  Text(
                    AppString.completed.localize(context)!,
                    style: AppStyling.semiBoldTextSize14.copyWith(
                      color: colors(context).colorPositive1,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$pending',
                    style: AppStyling.boldTextSize22.copyWith(
                      color: colors(context).colorGrey2,
                    ),
                  ),
                  Text(
                    AppString.pending.localize(context)!,
                    style: AppStyling.semiBoldTextSize14.copyWith(
                      color: colors(context).colorNotice7,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
