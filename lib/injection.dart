import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// App setup
import 'package:land_asset_valuation/application/core/router/routes.dart';
import 'package:land_asset_valuation/application/core/router/services/router_services.dart';
import 'package:land_asset_valuation/data/datasource/shared_preference.dart';

// Dio client
import 'package:land_asset_valuation/data/datasource/remote/api/dio_client.dart';

// Condition Report Feature
import 'package:land_asset_valuation/data/datasource/remote/condition_report_remote_data_source.dart';
import 'package:land_asset_valuation/data/repositories/condition_report_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/condition_report_repository.dart';
import 'package:land_asset_valuation/domain/usecases/send_condition_report_usecase.dart';

// Rental Evidence Feature
import 'package:land_asset_valuation/data/datasource/remote/rental_evidence_remote_data_source.dart';
import 'package:land_asset_valuation/data/repositories/rental_evidence_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/rental_evidence_repository.dart';
import 'package:land_asset_valuation/domain/usecases/send_rental_evidence_usecase.dart';

// Land Acquisition Feature (Clean Architecture)
import 'package:land_asset_valuation/data/datasource/remote/land_acquisition_remote_datasource.dart';
import 'package:land_asset_valuation/data/repositories/land_acquisition_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/land_acquisition_repository.dart';
import 'package:land_asset_valuation/domain/usecases/get_all_master_files_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/search_master_files_usecase.dart';

// Cubits
import 'package:land_asset_valuation/application/pages/I2_rental_evidence/cubit/i2_rental_evidence_cubit.dart';
import 'package:land_asset_valuation/application/pages/I3_master_file_list/cubit/i3_master_file_list_cubit.dart';
import 'package:land_asset_valuation/application/pages/LA_Building_Rates/cubit/la_building_rates_cubit.dart';
import 'package:land_asset_valuation/application/pages/LA_Sales_Evidence/cubit/la_sales_evidence_cubit.dart';
import 'package:land_asset_valuation/application/pages/MR_Assets_list/cubit/mr_assets_list_cubit.dart';
import 'package:land_asset_valuation/application/pages/RA_Assets_list/cubit/ra_assets_list_cubit.dart';
import 'package:land_asset_valuation/application/pages/RB_Assets_list/cubit/rb_assets_list_cubit.dart';
import 'package:land_asset_valuation/application/pages/RO_Assets_list/cubit/ro_assets_list_cubit.dart';
import 'package:land_asset_valuation/application/pages/dashboard/cubit/dashboard_cubit.dart';
import 'package:land_asset_valuation/application/pages/inspectionReport/cubit/inspection_report_cubit.dart';
import 'package:land_asset_valuation/application/pages/pastValuation/cubit/past_valuation_cubit.dart';
import 'package:land_asset_valuation/application/pages/rental_evidence/cubit/rental_evidence_cubit.dart';
import 'package:land_asset_valuation/application/pages/settingsScreen/cubit/settings_screen_cubit.dart';
import 'package:land_asset_valuation/application/pages/signIn/cubit/signin_cubit.dart';
import 'package:land_asset_valuation/application/pages/splash/cubit/splash_cubit.dart';
import 'package:land_asset_valuation/application/pages/conditionReport/cubit/condition_report_cubit.dart';

final injection = GetIt.I;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  injection.registerLazySingleton(() => sharedPreferences);

  injection.registerSingleton(AppSharedData(injection()));
  injection.registerSingleton(RouterServices(appSharedData: injection()));
  injection.registerSingleton(AppRouter(routerServices: injection()));

  // Register Dio and DioClient
  injection.registerLazySingleton(() => Dio());
  injection.registerLazySingleton(() => DioClient(injection()));

  // ------------------------------
  // Condition Report Feature
  // ------------------------------
  injection.registerLazySingleton<ConditionReportRemoteDataSource>(
    () => ConditionReportRemoteDataSourceImpl(dioClient: injection()),
  );

  injection.registerLazySingleton<ConditionReportRepository>(
    () => ConditionReportRepositoryImpl(remoteDataSource: injection()),
  );

  injection.registerLazySingleton(
    () => SendConditionReportUseCase(injection()),
  );

  // Asset Division Feature
  injection.registerLazySingleton<AssetDivisionRemoteDataSource>(
    () => AssetDivisionRemoteDataSourceImpl(dioClient: injection()),
  );

  injection.registerLazySingleton<AssetDivisionRepository>(
    () => AssetDivisionRepositoryImpl(remoteDataSource: injection()),
  );

  injection.registerLazySingleton(
    () => DivideAssetUseCase(injection()),
  );

  injection.registerLazySingleton(
    () => ValidateAssetDivisionUseCase(injection()),
  );

  injection.registerFactory(() => AssetDivisionCubit(
        divideAssetUseCase: injection(),
        validateAssetDivisionUseCase: injection(),
      ));

  // ------------------------------
  // Rental Evidence Feature
  // ------------------------------
  injection.registerLazySingleton<RentalEvidenceRemoteDataSource>(
    () => RentalEvidenceRemoteDataSourceImpl(dioClient: injection()),
  );

  injection.registerLazySingleton<RentalEvidenceRepository>(
    () => RentalEvidenceRepositoryImpl(remoteDataSource: injection()),
  );

  injection.registerLazySingleton(
    () => SendRentalEvidenceUseCase(injection()),
  );

  // ------------------------------
  // Land Acquisition Feature (Clean Architecture)
  // ------------------------------
  injection.registerLazySingleton<LandAcquisitionRemoteDatasource>(
    () => LandAcquisitionRemoteDatasource(injection()),
  );

  injection.registerLazySingleton<LandAcquisitionRepository>(
    () => LandAcquisitionRepositoryImpl(injection()),
  );

  injection.registerLazySingleton(() => GetAllMasterFilesUseCase(injection()));
  injection.registerLazySingleton(() => SearchMasterFilesUseCase(injection()));

  injection.registerFactory(() => I3MasterFileListCubit(
        appSharedData: injection(),
        getAllUseCase: injection(),
        searchUseCase: injection(),
      ));

  // ------------------------------
  // Cubits (UI Layer)
  // ------------------------------
  injection.registerFactory(() => SplashCubit(appSharedData: injection()));
  injection.registerFactory(() => DashboardCubit(appSharedData: injection()));
  injection.registerFactory(() => SigninCubit(appSharedData: injection()));
  injection
      .registerFactory(() => LaBuildingRatesCubit(appSharedData: injection()));
  injection
      .registerFactory(() => MrAssetsListCubit(appSharedData: injection()));
  injection
      .registerFactory(() => RaAssetsListCubit(appSharedData: injection()));
  injection
      .registerFactory(() => RbAssetsListCubit(appSharedData: injection()));
  injection
      .registerFactory(() => RoAssetsListCubit(appSharedData: injection()));
  injection.registerFactory(() => RentalEvidenceCubit(
        appSharedData: injection(),
        sendRentalEvidenceUseCase: injection(),
      ));
  injection
      .registerFactory(() => I2RentalEvidenceCubit(appSharedData: injection()));
  injection
      .registerFactory(() => SettingsScreenCubit(appSharedData: injection()));
  injection
      .registerFactory(() => LaSalesEvidenceCubit(appSharedData: injection()));
  injection.registerFactory(() => ConditionReportCubit(
        appSharedData: injection(),
        sendConditionReportUseCase: injection(),
      ));
  injection
      .registerFactory(() => PastValuationCubit(appSharedData: injection()));
  injection
      .registerFactory(() => InspectionReportCubit(appSharedData: injection()));
}
