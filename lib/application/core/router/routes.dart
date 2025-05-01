import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/go_router_observer.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/router/services/router_services.dart';
import 'package:land_asset_valuation/application/core/widgets/sidebarlibrary/sidebar_scaffold.dart';
import 'package:land_asset_valuation/application/pages/I3_master_file_list/i3_master_file_list.dart';
import 'package:land_asset_valuation/application/pages/LA_Building_Rates/la_building_rates.dart';
import 'package:land_asset_valuation/application/pages/LA_Sales_Evidence/la_Sales_Evidence.dart';
import 'package:land_asset_valuation/application/pages/MR_Assets_list/mr_assets_list.dart';
import 'package:land_asset_valuation/application/pages/ProfileScreen/profile_screen.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/condition_report_view.dart';
import 'package:land_asset_valuation/application/pages/dashboard/dashboard_view.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/inspection_report_view.dart';
import 'package:land_asset_valuation/application/pages/rental_evidence/rental_evidence_view.dart';
import 'package:land_asset_valuation/application/pages/pastValuation/past_valuation_view.dart';
import 'package:land_asset_valuation/application/pages/settingsScreen/settings_screen.dart';
import 'package:land_asset_valuation/application/pages/signIn/signin_view.dart';
import 'package:land_asset_valuation/application/pages/splash/splash_view.dart';
import 'package:land_asset_valuation/application/pages/RatingCard/rating_card_view.dart';
import 'package:land_asset_valuation/application/pages/MapScreen/map_screen.dart';
import 'package:sidebarx/sidebarx.dart';

import '../../pages/I2_rental_evidence/i2_rental_evidence.dart';

class AppRouter {
  final RouterServices routerServices;

  AppRouter({required this.routerServices});

  GoRouter get router => _goRouter;

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

  late final GoRouter _goRouter = GoRouter(
    debugLogDiagnostics: false,
    refreshListenable: routerServices,
    navigatorKey: _rootNavigatorKey,
    redirectLimit: 7,
    observers: [GoRouterObserver()],
    routes: [
      // Routes outside the shell (non-authenticated routes)
      GoRoute(
        path: "/",
        name: Pages.routeSplash.toPathName(),
        pageBuilder: (context, state) {
          return NoTransitionPage(key: state.pageKey, child: SplashView());
        },
      ),

      GoRoute(
        path: Pages.routeSignIn.toPath(),
        name: Pages.routeSignIn.toPathName(),
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (context, state) {
          return NoTransitionPage(
              key: state.pageKey, child: const SignInView());
        },
      ),

      // Shell route for authenticated pages with sidebar
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          // Get the selected index from route or query parameters
          int selectedIndex = _getSelectedIndexFromRoute(state);

          print("ShellRoute rebuilding with selectedIndex: $selectedIndex");

          // Create a controller for the sidebar with the correct selected index
          final controller =
              SidebarXController(selectedIndex: selectedIndex, extended: true);

          return PopScope(
            canPop: !(_shellNavigatorKey.currentState?.canPop() ?? false),
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }

              final NavigatorState? shellNavigator =
                  _shellNavigatorKey.currentState;
              if (shellNavigator != null && shellNavigator.canPop()) {
                shellNavigator.pop();
              }
            },
            child: Scaffold(
              body: Row(
                children: [
                  // Shared sidebar across all shell routes
                  ExampleSidebarX(
                    controller: controller,
                    onSelectedIndexChanged: (index) {
                      // This callback handles navigation based on sidebar selection
                      _navigateBasedOnIndex(context, index);
                    },
                  ),

                  // Page-specific content from child routes
                  Expanded(child: child),
                ],
              ),
            ),
          );
        },
        routes: [
          // Dashboard route
          GoRoute(
            path: Pages.routeDashboard.toPath(),
            name: Pages.routeDashboard.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: DashboardView(),
              );
            },
          ),

          // Master File List route - handling multiple views based on index
          GoRoute(
            path: Pages.routeI3MasterFileList.toPath(),
            name: Pages.routeI3MasterFileList.toPathName(),
            pageBuilder: (context, state) {
              final selectedIndex = int.tryParse(
                    state.uri.queryParameters['selectedIndex'] ?? '0',
                  ) ??
                  0;

              return NoTransitionPage(
                key: state.pageKey,
                child: I3MasterFileList(
                  number: selectedIndex,
                ),
              );
            },
          ),

          // Other individual routes
          GoRoute(
            path: Pages.routeConditionReport.toPath(),
            name: Pages.routeConditionReport.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: ConditionReportView(),
              );
            },
          ),
          GoRoute(
            path: Pages.routeRatingCardReport.toPath(),
            name: Pages.routeRatingCardReport.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: RatingCard(),
              );
            },
          ),
          GoRoute(
            path: Pages.routeMrAssetsList.toPath(),
            name: Pages.routeMrAssetsList.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: MrAssetsList(),
              );
            },
          ),
          GoRoute(
            path: Pages.routeRentalEvidence.toPath(),
            name: Pages.routeRentalEvidence.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: RentalEvidenceView(),
              );
            },
          ),
          GoRoute(
            path: Pages.routeLaSalesEvidence.toPath(),
            name: Pages.routeLaSalesEvidence.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: const LaSalesEvidence(),
              );
            },
          ),
          GoRoute(
            path: Pages.routeLaBuildingRates.toPath(),
            name: Pages.routeLaBuildingRates.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: const LaBuildingRates(),
              );
            },
          ),
          GoRoute(
            path: Pages.routeI2RentalEvidence.toPath(),
            name: Pages.routeI2RentalEvidence.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: I2RentalEvidence(),
              );
            },
          ),
          GoRoute(
            path: Pages.routeMapScreen.toPath(),
            name: Pages.routeMapScreen.toPathName(),
            pageBuilder: (context, state) {
              // Extract source from extra or query parameters
              final extra = state.extra as Map<String, dynamic>? ?? {};
              final String source = extra['source'] as String? ??
                  state.uri.queryParameters['source'] ??
                  '';

              return NoTransitionPage(
                key: state.pageKey,
                child: MapScreen(),
              );
            },
          ),
          GoRoute(
            path: Pages.routeInspectionReport.toPath(),
            name: Pages.routeInspectionReport.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: InspectionReportView(),
              );
            },
          ),
          GoRoute(
            path: Pages.routePastValuation.toPath(),
            name: Pages.routePastValuation.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: PastValuationView(),
              );
            },
          ),
          GoRoute(
            path: Pages.routeProfileScreen.toPath(),
            name: Pages.routeProfileScreen.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: ProfileScreen(),
              );
            },
          ),
          GoRoute(
              path: Pages.routeSettingsScreen.toPath(),
              name: Pages.routeSettingsScreen.toPathName(),
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: SettingsScreen(),
                );
              }),
        ],
      ),
    ],
    redirect: (context, state) {
      // Add your authentication redirect logic here if needed
      return null;
    },
  );

  // Helper method to determine sidebar index from current route
  int _getSelectedIndexFromRoute(GoRouterState state) {
    final String path = state.matchedLocation;

    // Check for selectedIndex in query parameters first
    if (state.uri.queryParameters.containsKey('selectedIndex')) {
      return int.tryParse(state.uri.queryParameters['selectedIndex']!) ?? 0;
    }

    if (path.startsWith(Pages.routeMapScreen.toPath())) {
      String source = state.uri.queryParameters['source'] ?? '';
      print("DEBUG: MapScreen route with source: '$source'");

      if (source == 'MRrentalEvidence') {
        return 7; // MR Rental Evidence tab
      }
      if (source == 'landAcquisition') {
        return 1; // Land Acquisition tab
      }
      if (source == 'landMiscellaneous') {
        return 8; // Land Miscellaneous tab - add this case
      }
      if (source == 'massRating') {
        return 2; // Mass Rating tab
      }

      // Default to MR Rental Evidence if no specific source
      return 7;
    }

    // Otherwise map paths to indices
    if (path.startsWith(Pages.routeDashboard.toPath())) {
      return 0;
    } else if (path.startsWith(Pages.routeI3MasterFileList.toPath())) {
      // Default to Land Acquisition (1) if no specific index provided
      return 1;
    } else if (path.startsWith(Pages.routeMapScreen.toPath())) {
      return 7;
    } else if (path.startsWith(Pages.routeLaSalesEvidence.toPath()) ||
        path.startsWith(Pages.routeLaBuildingRates.toPath())) {
      return 1; // Land Acquisition
    } else if (path.startsWith(Pages.routeRentalEvidence.toPath()) ||
        path.startsWith(Pages.routeI2RentalEvidence.toPath())) {
      return 7; // MR Rental Evidence
    }

    // Default
    return 0;
  }

  // Helper method to navigate based on sidebar index
  void _navigateBasedOnIndex(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(Pages.routeDashboard.toPath());
        break;
      case 1:
        context.goNamed(
          Pages.routeI3MasterFileList.toPathName(),
          queryParameters: {'selectedIndex': '1'},
        );
        break;
      case 3:
      case 4:
      case 5:
      case 6:
        // Mass Rating section
        context.goNamed(
          Pages.routeI3MasterFileList.toPathName(),
          queryParameters: {'selectedIndex': index.toString()},
        );
        break;
      case 7:
        context.goNamed(
          Pages.routeMapScreen.toPathName(),
          queryParameters: {'source': 'MRrentalEvidence'},
        );
        break;
      case 8:
        // Land Miscellaneous
        context.goNamed(
          Pages.routeI3MasterFileList.toPathName(),
          queryParameters: {'selectedIndex': '8'},
        );
        break;
      default:
        context.go(Pages.routeDashboard.toPath());
    }
  }
}
