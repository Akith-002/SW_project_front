import 'package:flutter/material.dart';
import 'package:land_asset_valuation/application/core/utils/app_colors/theme_data.dart';
import 'package:land_asset_valuation/application/core/utils/app_strings.dart';
import 'package:land_asset_valuation/application/core/utils/app_styling.dart';
import 'package:land_asset_valuation/application/core/widgets/custom_app_bar.dart';
import 'package:land_asset_valuation/application/core/widgets/pie_chart.dart';
import 'package:land_asset_valuation/application/core/widgets/line_chart.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'dart:convert';
import 'package:land_asset_valuation/data/models/auth/login_response.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:land_asset_valuation/application/core/providers/auth_provider.dart';

Future<UserProfile> fetchUserProfile(String username) async {
  final dio = Dio();
  final response = await dio.post(
    'http://10.0.2.2:5221/api/Profile', // Correct URL for Android emulator
    data: {'username': username},
  );
  return UserProfile.fromJson(response.data);
}

Future<Map<String, dynamic>> fetchTaskOverviewAndSummary(
    String username) async {
  final dio = Dio();
  final overviewFuture = dio.post(
    'http://10.0.2.2:5221/api/UserTask/overview',
    data: {'username': username},
  );
  final summaryFuture = dio.post(
    'http://10.0.2.2:5221/api/UserTask/work-summary',
    data: {'username': username},
  );
  final results = await Future.wait([overviewFuture, summaryFuture]);
  return {
    'overview': results[0].data,
    'summary': results[1].data,
  };
}

class ProfileScreen extends StatelessWidget {
  final String username;
  const ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<AuthProvider>(context, listen: false).username;
    if (username == null) {
      return const Center(child: CircularProgressIndicator());
    }
    print('ProfileScreen username: ' + username);
    return FutureBuilder<UserProfile>(
      future: fetchUserProfile(username),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error:  [${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No profile data'));
        }
        final profile = snapshot.data!;
        // Fetch task overview and summary in a nested FutureBuilder
        return FutureBuilder<Map<String, dynamic>>(
          future: fetchTaskOverviewAndSummary(username),
          builder: (context, taskSnapshot) {
            if (taskSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (taskSnapshot.hasError) {
              return Center(child: Text('Error:  [${taskSnapshot.error}'));
            } else if (!taskSnapshot.hasData) {
              return const Center(child: Text('No task data'));
            }
            final overview = taskSnapshot.data!['overview'];
            final summary =
                taskSnapshot.data!['summary'] as Map<String, dynamic>;
            // Map overview data (use correct lowercase keys)
            final double landAcquisition =
                (overview['laTaskAssigned'] ?? 0).toDouble();
            final double massRating =
                (overview['mrTaskAssigned'] ?? 0).toDouble();
            final double miscAcquisition =
                (overview['lmTaskAssigned'] ?? 0).toDouble();
            final double tasksDone =
                (overview['totalTasksCompleted'] ?? 0).toDouble();
            // Debug print for pie chart values
            print(
                'Pie chart values (Profile): landAcquisition=$landAcquisition, massRating=$massRating, miscAcquisition=$miscAcquisition, tasksDone=$tasksDone');
            // Map summary data to monthly values (Jan-Dec)
            List<double> monthlyValues = List.generate(12, (i) {
              final monthKey = DateTime(DateTime.now().year, i + 1, 1)
                  .toString()
                  .substring(0, 7)
                  .replaceAll('-', '');
              // Try both 'yyyyMM' and 'yyyy-MM' keys
              return (summary[monthKey] ??
                      summary[
                          '${DateTime.now().year}${(i + 1).toString().padLeft(2, '0')}'] ??
                      0)
                  .toDouble();
            });
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
                    ProfileCard(profile: profile),
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
                        children: [
                          Expanded(
                            child: OverviewChart(
                              landAcquisition: landAcquisition,
                              massRating: massRating,
                              miscAcquisition: miscAcquisition,
                              tasksDone: tasksDone,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: LineChartSample2(
                              monthlyValues: monthlyValues,
                            ),
                          ),
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
                                title: AppString.totalActivities
                                    .localize(context)!,
                                completed: overview['TotalTasksCompleted'] ?? 0,
                                pending: (overview['TotalTasksAssigned'] ?? 0) -
                                    (overview['TotalTasksCompleted'] ?? 0),
                                icon: PhosphorIcons.pulse(
                                    PhosphorIconsStyle.regular),
                              ),
                              const SizedBox(width: 12),
                              CustomActivityCard(
                                title: AppString.landAcquisition
                                    .localize(context)!,
                                completed: overview['LaTaskCompleted'] ?? 0,
                                pending: (overview['LaTaskAssigned'] ?? 0) -
                                    (overview['LaTaskCompleted'] ?? 0),
                                icon: PhosphorIcons.mapTrifold(
                                    PhosphorIconsStyle.regular),
                              ),
                              const SizedBox(width: 12),
                              CustomActivityCard(
                                title: AppString.massRating.localize(context)!,
                                completed: overview['MrTaskCompleted'] ?? 0,
                                pending: (overview['MrTaskAssigned'] ?? 0) -
                                    (overview['MrTaskCompleted'] ?? 0),
                                icon: PhosphorIcons.pencilRuler(
                                    PhosphorIconsStyle.regular),
                              ),
                              const SizedBox(width: 12),
                              CustomActivityCard(
                                title: AppString.landMiscellaneous
                                    .localize(context)!,
                                completed: overview['LandMiscelleneous'] ?? 0,
                                pending: (overview['LmTaskAssigned'] ?? 0) -
                                    (overview['LandMiscelleneous'] ?? 0),
                                icon: PhosphorIcons.ticket(
                                    PhosphorIconsStyle.regular),
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
          },
        );
      },
    );
  }
}

class ProfileCard extends StatelessWidget {
  final UserProfile profile;
  const ProfileCard({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (profile.profilePicture != null && profile.profilePicture!.isNotEmpty) {
      imageProvider = MemoryImage(base64Decode(profile.profilePicture!));
    } else {
      imageProvider = const AssetImage('images/pngs/image 1.png');
    }
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
            CircleAvatar(
              radius: 40,
              backgroundImage: imageProvider,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.empName,
                          style: AppStyling.semiBoldTextSize18.copyWith(
                            color: colors(context).colorGrey2,
                          )),
                      Text(profile.empEmail,
                          style: AppStyling.regularTextSize14.copyWith(
                            color: colors(context).colorGrey8,
                          )),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Employee Id',
                          style: AppStyling.regularTextSize12.copyWith(
                            color: colors(context).colorGrey8,
                          )),
                      Text(profile.empId,
                          style: AppStyling.semiBoldTextSize16.copyWith(
                            color: colors(context).colorGrey2,
                          )),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Position',
                          style: AppStyling.regularTextSize12.copyWith(
                            color: colors(context).colorGrey8,
                          )),
                      Text(profile.position,
                          style: AppStyling.semiBoldTextSize16.copyWith(
                            color: colors(context).colorGrey2,
                          )),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Assigned Division',
                          style: AppStyling.regularTextSize12.copyWith(
                            color: colors(context).colorGrey8,
                          )),
                      Text(profile.assignedDivision,
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
