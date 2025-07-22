import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:land_asset_valuation/application/core/router/go_router_observer.dart';
import 'package:land_asset_valuation/application/core/router/pages.dart';
import 'package:land_asset_valuation/application/core/router/services/router_services.dart';
import 'package:land_asset_valuation/application/core/widgets/sidebarlibrary/sidebar_scaffold.dart';
import 'package:land_asset_valuation/application/pages/I3_master_file_list/i3_master_file_list.dart';
import 'package:land_asset_valuation/application/pages/LA_Building_Rates/la_building_rates.dart';
import 'package:land_asset_valuation/application/pages/LA_Sales_Evidence/la_Sales_Evidence.dart';
import 'package:land_asset_valuation/application/pages/LM_Masterfile_list/lm_masterfile_list.dart';
import 'package:land_asset_valuation/application/pages/MR_Assets_list/mr_assets_list.dart';
import 'package:land_asset_valuation/application/pages/RA_Assets_list/ra_assets_list.dart';
import 'package:land_asset_valuation/application/pages/RB_Assets_list/rb_assets_list.dart';
import 'package:land_asset_valuation/application/pages/RO_Assets_list/ro_assets_list.dart';
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
import 'package:land_asset_valuation/application/pages/AssetMapScreen/asset_map_screen.dart';
import 'package:land_asset_valuation/application/pages/test.dart';

import '../../pages/I2_rental_evidence/i2_rental_evidence.dart';

// Rating Card Forms imports
import 'package:land_asset_valuation/application/pages/RatingCardForms/domestic/domestic_rating_card.dart';
import 'package:land_asset_valuation/application/pages/RatingCardForms/offices/offices_rating_card.dart';
import 'package:land_asset_valuation/application/pages/RatingCardForms/agriculture/agriculture_rating_card.dart';
import 'package:land_asset_valuation/application/pages/RatingCardForms/shops/shops_rating_card.dart';
import 'package:land_asset_valuation/application/pages/RatingCardForms/special/special_rating_card.dart';
import 'package:land_asset_valuation/data/models/master_data_model.dart';
import 'package:land_asset_valuation/data/repositories/master_data_repository_impl.dart';
import 'package:land_asset_valuation/data/datasource/remote/master_data_remote_data_source.dart';
import 'package:land_asset_valuation/domain/usecases/get_master_data_usecase.dart';
import 'package:land_asset_valuation/injection.dart';
import 'package:get_it/get_it.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

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

          return SidebarScaffold(
            selectedIndex: selectedIndex,
            onIndexChanged: (index) {
              // Navigate based on selected index
              _navigateBasedOnIndex(context, index);
            },
            child: child,
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
                child: FutureBuilder<MasterDataResponse>(
                  future: GetIt.I<GetMasterDataUseCase>()(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load master data'));
                    } else {
                      return RatingCard(masterData: snapshot.data!);
                    }
                  },
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.routeMrAssetsList.toPath(),
            name: Pages.routeMrAssetsList.toPathName(),
            pageBuilder: (context, state) {
              final String source =
                  state.uri.queryParameters['source'] ?? 'massRating';
              final String? requestIdStr =
                  state.uri.queryParameters['requestId'];
              final int? requestId =
                  requestIdStr != null ? int.tryParse(requestIdStr) : null;

              return NoTransitionPage(
                key: state.pageKey,
                child: MrAssetsList(
                  source: source,
                  requestId: requestId,
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.routeRaAssetsList.toPath(),
            name: Pages.routeRaAssetsList.toPathName(),
            pageBuilder: (context, state) {
              final String source =
                  state.uri.queryParameters['source'] ?? 'ratingAssessment';
              final String? requestIdStr =
                  state.uri.queryParameters['requestId'];
              final int? requestId =
                  requestIdStr != null ? int.tryParse(requestIdStr) : null;

              return NoTransitionPage(
                key: state.pageKey,
                child: RaAssetsList(
                  source: source,
                  requestId: requestId,
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.routeRbAssetsList.toPath(),
            name: Pages.routeRbAssetsList.toPathName(),
            pageBuilder: (context, state) {
              final String source =
                  state.uri.queryParameters['source'] ?? 'ratingBuilding';
              final String? requestIdStr =
                  state.uri.queryParameters['requestId'];
              final int? requestId =
                  requestIdStr != null ? int.tryParse(requestIdStr) : null;

              return NoTransitionPage(
                key: state.pageKey,
                child: RbAssetsList(
                  source: source,
                  requestId: requestId,
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.routeRoAssetsList.toPath(),
            name: Pages.routeRoAssetsList.toPathName(),
            pageBuilder: (context, state) {
              final String source =
                  state.uri.queryParameters['source'] ?? 'ratingObject';
              final String? requestIdStr =
                  state.uri.queryParameters['requestId'];
              final int? requestId =
                  requestIdStr != null ? int.tryParse(requestIdStr) : null;

              return NoTransitionPage(
                key: state.pageKey,
                child: RoAssetsList(
                  source: source,
                  requestId: requestId,
                ),
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
                child: FutureBuilder<MasterDataResponse>(
                  future: GetIt.I<GetMasterDataUseCase>()(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load master data'));
                    } else {
                      return I2RentalEvidence(masterData: snapshot.data!);
                    }
                  },
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.routeMapScreen.toPath(),
            name: Pages.routeMapScreen.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: MapScreen(),
              );
            },
          ),
          GoRoute(
            path: Pages.routeAssetMapScreen.toPath(),
            name: Pages.routeAssetMapScreen.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: AssetMapScreen(),
              );
            },
          ),
          GoRoute(
            path: Pages.routeInspectionReport.toPath(),
            name: Pages.routeInspectionReport.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: FutureBuilder<MasterDataResponse>(
                  future: GetIt.I<GetMasterDataUseCase>()(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load master data'));
                    } else {
                      return InspectionReportView(masterData: snapshot.data!);
                    }
                  },
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.routePastValuation.toPath(),
            name: Pages.routePastValuation.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: FutureBuilder<MasterDataResponse>(
                  future: GetIt.I<GetMasterDataUseCase>()(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load master data'));
                    } else {
                      return PastValuationView(masterData: snapshot.data!);
                    }
                  },
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.routeProfileScreen.toPath(),
            name: Pages.routeProfileScreen.toPathName(),
            pageBuilder: (context, state) {
              // Fetch username from shared preferences or session
              final appSharedData = injection<AppSharedData>();
              final username = appSharedData.getData('username');
              return NoTransitionPage(
                key: state.pageKey,
                child: ProfileScreen(username: username),
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
              }), // Rating Card Forms routes
          GoRoute(
            path: Pages.routeDomesticRatingCard.toPath(),
            name: Pages.routeDomesticRatingCard.toPathName(),
            pageBuilder: (context, state) {
              final int assetId = int.tryParse(
                    state.uri.queryParameters['assetId'] ?? '0',
                  ) ??
                  0;
              
              // Extract additional parameters for breadcrumb
              final String? assetNo = state.uri.queryParameters['assetNo'];
              final String? requestType = state.uri.queryParameters['requestType'];
              final String? ratingReferenceNo = state.uri.queryParameters['ratingReferenceNo'];

              return NoTransitionPage(
                key: state.pageKey,
                child: FutureBuilder<MasterDataResponse>(
                  future: GetIt.I<GetMasterDataUseCase>()(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load master data'));
                    } else {
                      return DomesticRatingCard(
                        assetId: assetId, 
                        masterData: snapshot.data!,
                        assetNo: assetNo,
                        requestType: requestType,
                        ratingReferenceNo: ratingReferenceNo,
                      );
                    }
                  },
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.routeOfficesRatingCard.toPath(),
            name: Pages.routeOfficesRatingCard.toPathName(),
            pageBuilder: (context, state) {
              final int assetId = int.tryParse(
                    state.uri.queryParameters['assetId'] ?? '0',
                  ) ??
                  0;
              
              // Extract additional parameters for breadcrumb
              final String? assetNo = state.uri.queryParameters['assetNo'];
              final String? requestType = state.uri.queryParameters['requestType'];
              final String? ratingReferenceNo = state.uri.queryParameters['ratingReferenceNo'];
              
              return NoTransitionPage(
                key: state.pageKey,
                child: FutureBuilder<MasterDataResponse>(
                  future: GetIt.I<GetMasterDataUseCase>()(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load master data'));
                    } else {
                      return OfficesRatingCard(
                        assetId: assetId, 
                        masterData: snapshot.data!,
                        assetNo: assetNo,
                        requestType: requestType,
                        ratingReferenceNo: ratingReferenceNo,
                      );
                    }
                  },
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.routeAgricultureRatingCard.toPath(),
            name: Pages.routeAgricultureRatingCard.toPathName(),
            pageBuilder: (context, state) {
              final int assetId = int.tryParse(
                    state.uri.queryParameters['assetId'] ?? '0',
                  ) ??
                  0;
              
              // Extract additional parameters for breadcrumb
              final String? assetNo = state.uri.queryParameters['assetNo'];
              final String? requestType = state.uri.queryParameters['requestType'];
              final String? ratingReferenceNo = state.uri.queryParameters['ratingReferenceNo'];
              
              return NoTransitionPage(
                key: state.pageKey,
                child: FutureBuilder<MasterDataResponse>(
                  future: GetIt.I<GetMasterDataUseCase>()(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load master data'));
                    } else {
                      return AgricultureRatingCard(
                        assetId: assetId,
                        masterData: snapshot.data!,
                        assetNo: assetNo,
                        requestType: requestType,
                        ratingReferenceNo: ratingReferenceNo,
                      );
                    }
                  },
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.routeShopsRatingCard.toPath(),
            name: Pages.routeShopsRatingCard.toPathName(),
            pageBuilder: (context, state) {
              final int assetId = int.tryParse(
                    state.uri.queryParameters['assetId'] ?? '0',
                  ) ??
                  0;
              
              // Extract additional parameters for breadcrumb
              final String? assetNo = state.uri.queryParameters['assetNo'];
              final String? requestType = state.uri.queryParameters['requestType'];
              final String? ratingReferenceNo = state.uri.queryParameters['ratingReferenceNo'];
              
              return NoTransitionPage(
                key: state.pageKey,
                child: FutureBuilder<MasterDataResponse>(
                  future: GetIt.I<GetMasterDataUseCase>()(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load master data'));
                    } else {
                      return ShopsRatingCard(
                        assetId: assetId,
                        masterData: snapshot.data!,
                        assetNo: assetNo,
                        requestType: requestType,
                        ratingReferenceNo: ratingReferenceNo,
                      );
                    }
                  },
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.routeSpecialRatingCard.toPath(),
            name: Pages.routeSpecialRatingCard.toPathName(),
            pageBuilder: (context, state) {
              final int assetId = int.tryParse(
                    state.uri.queryParameters['assetId'] ?? '0',
                  ) ??
                  0;
              
              // Extract additional parameters for breadcrumb
              final String? assetNo = state.uri.queryParameters['assetNo'];
              final String? requestType = state.uri.queryParameters['requestType'];
              final String? ratingReferenceNo = state.uri.queryParameters['ratingReferenceNo'];
              
              return NoTransitionPage(
                key: state.pageKey,
                child: FutureBuilder<MasterDataResponse>(
                  future: GetIt.I<GetMasterDataUseCase>()(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Failed to load master data'));
                    } else {
                      return SpecialRatingCard(
                        assetId: assetId,
                        masterData: snapshot.data!,
                        assetNo: assetNo,
                        requestType: requestType,
                        ratingReferenceNo: ratingReferenceNo,
                      );
                    }
                  },
                ),
              );
            },
          ),
          GoRoute(
            path: Pages.routeTest.toPath(),
            name: Pages.routeTest.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: const Test(), // Replace with your test page
              );
            },
          ),
          GoRoute(
            path: Pages.routeLmMasterfileList.toPath(),
            name: Pages.routeLmMasterfileList.toPathName(),
            pageBuilder: (context, state) {
              return NoTransitionPage(
                key: state.pageKey,
                child: const LmMasterfileList(),
              );
            },
          ),
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
    final String source = state.uri.queryParameters['source'] ?? '';

    print("DEBUG: _getSelectedIndexFromRoute called");
    print("DEBUG: Path: '$path'");
    print("DEBUG: Source: '$source'");
    print(
        "DEBUG: Inspection Report path: '${Pages.routeInspectionReport.toPath()}'");
    print(
        "DEBUG: Does path start with InspectionReport? ${path.startsWith(Pages.routeInspectionReport.toPath())}");
    print(
        "DEBUG: MapScreen path should be: '${Pages.routeMapScreen.toPath()}'");
    print(
        "DEBUG: I3MasterFileList path: '${Pages.routeI3MasterFileList.toPath()}'");
    print(
        "DEBUG: Does path start with MapScreen? ${path.startsWith(Pages.routeMapScreen.toPath())}");
    print(
        "DEBUG: Does path start with I3MasterFileList? ${path.startsWith(Pages.routeI3MasterFileList.toPath())}");
    print("DEBUG: All query parameters: ${state.uri.queryParameters}");

    // Check for selectedIndex in query parameters first
    if (state.uri.queryParameters.containsKey('selectedIndex')) {
      return int.tryParse(state.uri.queryParameters['selectedIndex']!) ?? 0;
    }

    // Check for rating card form routes and extract source context
    if (path.startsWith(Pages.routeDomesticRatingCard.toPath()) ||
        path.startsWith(Pages.routeOfficesRatingCard.toPath()) ||
        path.startsWith(Pages.routeAgricultureRatingCard.toPath()) ||
        path.startsWith(Pages.routeShopsRatingCard.toPath()) ||
        path.startsWith(Pages.routeSpecialRatingCard.toPath())) {
      String source = state.uri.queryParameters['source'] ?? '';
      print("DEBUG: Rating card form route with source: '$source'");

      // Map source to appropriate sidebar index
      switch (source) {
        case 'massRating':
          return 2;
        case 'ratingAssessment':
          return 3;
        case 'ratingBuilding':
          return 4;
        case 'ratingObject':
          return 5;
        case 'landAcquisition':
          return 1;
        case 'MRrentalEvidence':
          return 6;
        case 'landMiscellaneous':
          return 7;
        default:
          return 2; // Default to Mass Rating if no source specified
      }
    }

    // Check MapScreen routes BEFORE checking i3masterfilelist
    if (path.startsWith(Pages.routeMapScreen.toPath()) ||
        path.startsWith(Pages.routeI3MasterFileList.toPath())) {
      print("DEBUG: MapScreen route detected with source: '$source'");
      print(
          "DEBUG: Path starts with MapScreen: ${path.startsWith(Pages.routeMapScreen.toPath())}");
      print(
          "DEBUG: Path starts with I3MasterFileList: ${path.startsWith(Pages.routeI3MasterFileList.toPath())}");

      // Special case: If we have inspection report query parameters, treat as Land Miscellaneous
      if (state.uri.queryParameters.containsKey('masterFileNo') &&
          state.uri.queryParameters.containsKey('lotId')) {
        print(
            "DEBUG: Detected Inspection Report context with masterFileNo and lotId - returning index 7");
        return 7; // Land Miscellaneous for Inspection Report
      }

      if (source == 'MRrentalEvidence') {
        print("DEBUG: Returning index 6 for MRrentalEvidence");
        return 6;
      }
      if (source == 'landAcquisition') {
        print("DEBUG: Returning index 1 for landAcquisition");
        return 1;
      }
      if (source == 'landMiscellaneous') {
        print("DEBUG: Returning index 7 for landMiscellaneous");
        return 7;
      }
      if (source == 'massRating') {
        print("DEBUG: Returning index 2 for massRating");
        return 2;
      }

      print("DEBUG: No matching source, defaulting to index 6");
      return 6;
    }

    if (path.startsWith(Pages.routeAssetMapScreen.toPath())) {
      String source = state.uri.queryParameters['source'] ?? '';
      print("DEBUG: AssetMapScreen route with source: '$source'");

      // Map source to appropriate sidebar index
      switch (source) {
        case 'massRating':
          return 2;
        case 'ratingAssessment':
          return 3;
        case 'ratingBuilding':
          return 4;
        case 'ratingObject':
          return 5;
        case 'MRrentalEvidence':
          return 6;
        case 'landAcquisition':
          return 1;
        case 'landMiscellaneous':
          return 7;
        default:
          return 2; // Default to Mass Rating if no source specified
      }
    }

    // Otherwise map paths to indices
    if (path.startsWith(Pages.routeDashboard.toPath())) {
      return 0;
    } else if (path.startsWith(Pages.routeI3MasterFileList.toPath())) {
      // Default to Land Acquisition (1) if no specific index provided
      return 1;
    } else if (path.startsWith(Pages.routeLaSalesEvidence.toPath()) ||
        path.startsWith(Pages.routeLaBuildingRates.toPath())) {
      return 1; // Land Acquisition
    } else if (path.startsWith(Pages.routeConditionReport.toPath())) {
      return 1; // Land Acquisition - Condition Report belongs to Land Acquisition
    } else if (path.startsWith(Pages.routePastValuation.toPath())) {
      return 1; // Land Acquisition - Past Valuation belongs to Land Acquisition
    } else if (path.startsWith(Pages.routeRentalEvidence.toPath()) ||
        path.startsWith(Pages.routeI2RentalEvidence.toPath())) {
      return 6; // MR Rental Evidence
    } else if (path.startsWith(Pages.routeLmMasterfileList.toPath())) {
      return 7; // Land Miscellaneous
    } else if (path.startsWith(Pages.routeInspectionReport.toPath())) {
      print("DEBUG: Inspection Report route detected! Path: $path");
      print(
          "DEBUG: Returning index 7 for Inspection Report (Land Miscellaneous)");
      return 7; // Land Miscellaneous - Inspection Report belongs to Land Miscellaneous
    }

    // Default
    print("DEBUG: No matching route found, defaulting to index 0. Path: $path");
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
      case 2:
        // Mass Rating
        context.goNamed(
          Pages.routeI3MasterFileList.toPathName(),
          queryParameters: {'selectedIndex': index.toString()},
        );
        break;
      case 3:
        // Rating Assessment - show requests table first
        context.goNamed(
          Pages.routeI3MasterFileList.toPathName(),
          queryParameters: {'selectedIndex': index.toString()},
        );
        break;
      case 4:
        // Rating Building - show requests table first
        context.goNamed(
          Pages.routeI3MasterFileList.toPathName(),
          queryParameters: {'selectedIndex': index.toString()},
        );
        break;
      case 5:
        // Rating Object - show requests table first
        context.goNamed(
          Pages.routeI3MasterFileList.toPathName(),
          queryParameters: {'selectedIndex': index.toString()},
        );
        break;
      case 6:
        context.goNamed(
          Pages.routeAssetMapScreen.toPathName(),
          queryParameters: {'source': 'MRrentalEvidence'},
        );
        break;
      case 7:
        // Land Miscellaneous
        context.goNamed(
          Pages.routeI3MasterFileList.toPathName(),
          queryParameters: {'selectedIndex': '7'},
        );
        break;
      default:
        context.go(Pages.routeDashboard.toPath());
    }
  }
}
