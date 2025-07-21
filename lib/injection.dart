import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:land_asset_valuation/application/pages/LM_Masterfile_list/cubit/lm_masterfile_list_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:logger/logger.dart';

import 'package:land_asset_valuation/application/core/configurations/app_config.dart';

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

// Asset Division Feature
import 'package:land_asset_valuation/data/datasource/remote/asset_division_remote_data_source.dart';
import 'package:land_asset_valuation/data/repositories/asset_division_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/asset_division_repository.dart';
import 'package:land_asset_valuation/domain/usecases/asset_division_usecases.dart';
import 'package:land_asset_valuation/application/pages/asset_division/cubit/asset_division_cubit.dart';

// Rental Evidence Feature
import 'package:land_asset_valuation/data/datasource/remote/rental_evidence_remote_data_source.dart';
import 'package:land_asset_valuation/data/repositories/rental_evidence_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/rental_evidence_repository.dart';
import 'package:land_asset_valuation/domain/usecases/send_rental_evidence_usecase.dart';

// Land Acquisition Feature (Clean Architecture)
import 'package:land_asset_valuation/data/datasource/remote/land_acquisition_remote_datasource.dart';
import 'package:land_asset_valuation/data/repositories/land_acquisition_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/land_acquisition_repository.dart';
import 'package:land_asset_valuation/domain/usecases/get_paginated_master_files_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/search_master_files_usecase.dart';

// MR Requests Feature (Clean Architecture)
import 'package:land_asset_valuation/data/datasource/remote/mr_request_remote_datasource.dart';
import 'package:land_asset_valuation/data/repositories/mr_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/mr_request_repository.dart';
import 'package:land_asset_valuation/domain/usecases/mr_requests_usecases.dart';
import 'package:land_asset_valuation/domain/usecases/get_request_by_id_usecase.dart';

// Asset Feature (Clean Architecture)
import 'package:land_asset_valuation/data/datasource/remote/asset_remote_data_source.dart';
import 'package:land_asset_valuation/data/repositories/asset_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/asset_repository.dart';
import 'package:land_asset_valuation/domain/usecases/asset_usecases.dart';

// Land Miscellaneous Feature (Clean Architecture)
import 'package:land_asset_valuation/data/datasource/remote/land_miscellaneous_remote_datasource.dart';
import 'package:land_asset_valuation/data/repositories/land_miscellaneous_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/land_miscellaneous_repository.dart';
import 'package:land_asset_valuation/domain/usecases/get_all_lm_master_files_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/get_paginated_lm_master_files_usecase.dart';
import 'package:land_asset_valuation/domain/usecases/search_lm_master_files_usecase.dart';

// Asset Change Feature (Clean Architecture)
import 'package:land_asset_valuation/data/datasource/remote/asset_change_remote_data_source.dart';
import 'package:land_asset_valuation/data/repositories/asset_change_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/asset_change_repository.dart';
import 'package:land_asset_valuation/domain/usecases/change_asset_number_usecase.dart';

// Cubits
import 'package:land_asset_valuation/application/pages/I2_rental_evidence/cubit/i2_rental_evidence_cubit.dart';
import 'package:land_asset_valuation/application/pages/I3_master_file_list/cubit/i3_master_file_list_cubit.dart';
import 'package:land_asset_valuation/application/pages/LA_Building_Rates/cubit/la_building_rates_cubit.dart';
import 'package:land_asset_valuation/application/pages/LA_Sales_Evidence/cubit/la_sales_evidence_cubit.dart';
import 'package:land_asset_valuation/application/pages/MR_Assets_list/cubit/mr_assets_list_cubit.dart';
import 'package:land_asset_valuation/application/pages/mr_requests/cubit/mr_requests_cubit.dart';
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
import 'package:land_asset_valuation/data/datasource/secure_storage.dart';
import 'package:land_asset_valuation/data/repositories/auth_repository.dart';
import 'package:land_asset_valuation/data/services/sign_in_service.dart';
import 'package:land_asset_valuation/data/datasource/remote/rental_assessment_remote_datasource.dart';
import 'package:land_asset_valuation/data/repositories/rental_assessment_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/rental_assessment_repository.dart';
import 'package:land_asset_valuation/domain/usecases/get_rental_assessments_usecase.dart';
import 'package:land_asset_valuation/application/pages/rental_assessment/cubit/rental_assessment_cubit.dart';

// Add repository import if you create one

// Domestic Rating Card Feature
import 'package:land_asset_valuation/data/datasource/remote/domestic_rating_card_remote_data_source.dart';
import 'package:land_asset_valuation/data/repositories/domestic_rating_card_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/domestic_rating_card_repository.dart';
import 'package:land_asset_valuation/domain/usecases/save_domestic_rating_card.dart';
import 'package:land_asset_valuation/domain/usecases/get_domestic_rating_card_autofill.dart';
import 'package:land_asset_valuation/application/pages/RatingCardForms/domestic/cubit/domestic_rating_card_cubit.dart';

// Offices Rating Card
import 'package:land_asset_valuation/data/datasource/remote/offices_rating_card_remote_data_source.dart';
import 'package:land_asset_valuation/data/repositories/offices_rating_card_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/offices_rating_card_repository.dart';
import 'package:land_asset_valuation/domain/usecases/save_offices_rating_card.dart';
import 'package:land_asset_valuation/domain/usecases/get_offices_rating_card_autofill.dart';
import 'package:land_asset_valuation/application/pages/RatingCardForms/offices/cubit/offices_rating_card_cubit.dart';

// Master Data Feature
import 'package:land_asset_valuation/data/datasource/remote/master_data_remote_data_source.dart';
import 'package:land_asset_valuation/data/repositories/master_data_repository_impl.dart';
import 'package:land_asset_valuation/domain/repositories/master_data_repository.dart';
import 'package:land_asset_valuation/domain/usecases/get_master_data_usecase.dart';

final injection = GetIt.I;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  injection.registerLazySingleton(() => sharedPreferences);

  injection.registerSingleton(AppSharedData(injection()));
  injection.registerSingleton(RouterServices(appSharedData: injection()));
  injection.registerSingleton(AppRouter(routerServices: injection()));
  // Register Dio and DioClient
  injection.registerLazySingleton(() {
    final dio = Dio();
    dio.options.baseUrl = AppConfig.apiBaseUrl;
    return dio;
  });
  injection.registerLazySingleton(() => DioClient(injection()));
  injection.registerLazySingleton(() => Logger());

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
  // ------------------------------
  // Asset Division Feature
  // ------------------------------
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

  // ------------------------------
  // Domestic Rating Card Feature
  // ------------------------------
  injection.registerLazySingleton<DomesticRatingCardRemoteDataSource>(
    () => DomesticRatingCardRemoteDataSourceImpl(
      client: injection(),
      logger: injection(),
    ),
  );

  injection.registerLazySingleton<DomesticRatingCardRepository>(
    () => DomesticRatingCardRepositoryImpl(remoteDataSource: injection()),
  );

  injection.registerLazySingleton(
    () => SaveDomesticRatingCard(injection()),
  );

  injection.registerLazySingleton(
    () => GetDomesticRatingCardAutofill(injection()),
  );

  // ------------------------------
  // Offices Rating Card Feature
  // ------------------------------
  injection.registerLazySingleton<OfficesRatingCardRemoteDataSource>(
    () => OfficesRatingCardRemoteDataSourceImpl(
      client: injection(),
      logger: injection(),
    ),
  );

  injection.registerLazySingleton<OfficesRatingCardRepository>(
    () => OfficesRatingCardRepositoryImpl(remoteDataSource: injection()),
  );

  injection.registerLazySingleton(
    () => SaveOfficesRatingCard(injection()),
  );

  injection.registerLazySingleton(
    () => GetOfficesRatingCardAutofill(injection()),
  );

  // ------------------------------
  // Asset Change Feature
  // ------------------------------
  injection.registerLazySingleton<AssetChangeRemoteDataSource>(
    () => AssetChangeRemoteDataSourceImpl(dioClient: injection()),
  );

  injection.registerLazySingleton<AssetChangeRepository>(
    () => AssetChangeRepositoryImpl(remoteDataSource: injection()),
  );

  injection.registerLazySingleton(
    () => ChangeAssetNumberUseCase(injection()),
  );

  // ------------------------------
  // Rental Assessment Feature
  // ------------------------------
  if (!injection.isRegistered<RentalAssessmentRemoteDataSource>()) {
    injection.registerLazySingleton<RentalAssessmentRemoteDataSource>(
      () => RentalAssessmentRemoteDataSourceImpl(dioClient: injection()),
    );
  }

  if (!injection.isRegistered<RentalAssessmentRepository>()) {
    injection.registerLazySingleton<RentalAssessmentRepository>(
      () => RentalAssessmentRepositoryImpl(
        remoteDataSource: injection(),
      ),
    );
  }

  if (!injection.isRegistered<GetRentalAssessmentsUseCase>()) {
    injection.registerLazySingleton(
      () => GetRentalAssessmentsUseCase(injection()),
    );
  }

  // Factory registrations don't need isRegistered check as they create new instances
  injection.registerFactory(
    () => RentalAssessmentCubit(
      getRentalAssessmentsUseCase: injection(),
    ),
  );

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
  injection
      .registerLazySingleton(() => GetPaginatedMasterFilesUseCase(injection()));
  injection.registerLazySingleton(() => SearchMasterFilesUseCase(injection()));

  // ------------------------------
  // Land Miscellaneous Feature (Clean Architecture)
  // ------------------------------
  injection.registerLazySingleton<LandMiscellaneousRemoteDatasource>(
    () => LandMiscellaneousRemoteDatasource(injection()),
  );

  injection.registerLazySingleton<LandMiscellaneousRepository>(
    () => LandMiscellaneousRepositoryImpl(injection(), injection()),
  );
  injection
      .registerLazySingleton(() => GetAllLmMasterFilesUseCase(injection()));
  injection.registerLazySingleton(
      () => GetPaginatedLMMasterFilesUseCase(injection()));
  injection
      .registerLazySingleton(() => SearchLmMasterFilesUseCase(injection()));

  // ------------------------------
  // MR Requests Feature (Clean Architecture)
  // ------------------------------
  injection.registerLazySingleton<MRRequestRemoteDataSource>(
    () => MRRequestRemoteDataSourceImpl(dioClient: injection()),
  );

  injection.registerLazySingleton<MrRequestRepository>(
    () => MrRepositoryImpl(remoteDataSource: injection()),
  );
  injection.registerLazySingleton(() => GetMrRequestsUseCase(injection()));
  injection
      .registerLazySingleton(() => GetMrRequestsPaginatedUseCase(injection()));
  injection.registerLazySingleton(
      () => GetRequestByIdUseCase(repository: injection()));

  // ------------------------------
  // Asset Feature (Clean Architecture)
  // ------------------------------
  injection.registerLazySingleton<AssetRemoteDataSource>(
    () => AssetRemoteDataSourceImpl(dioClient: injection()),
  );

  injection.registerLazySingleton<AssetRepository>(
    () => AssetRepositoryImpl(remoteDataSource: injection()),
  );

  injection.registerLazySingleton(() => GetAssetsUseCase(injection()));
  injection.registerLazySingleton(() => GetAssetsPaginatedUseCase(injection()));
  injection.registerLazySingleton(() => SearchAssetsUseCase(injection()));

  // ------------------------------
  // Master Data Feature
  // ------------------------------
  injection.registerLazySingleton<MasterDataRemoteDataSource>(
    () => MasterDataRemoteDataSourceImpl(dioClient: injection()),
  );
  injection.registerLazySingleton<MasterDataRepository>(
    () => MasterDataRepositoryImpl(remoteDataSource: injection()),
  );
  injection.registerLazySingleton(
    () => GetMasterDataUseCase(injection()),
  );

  // ------------------------------
  // Cubits (UI Layer)
  // ------------------------------
  injection.registerFactory(() => SplashCubit(appSharedData: injection()));
  injection.registerFactory(() => DashboardCubit(appSharedData: injection()));
  injection.registerFactory(() => SigninCubit(
        appSharedData: injection(),
        authRepository: injection(),
      ));
  injection
      .registerFactory(() => LaBuildingRatesCubit(appSharedData: injection()));
  injection.registerFactory(() => MrAssetsListCubit(
        appSharedData: injection(),
        getAssetsUseCase: injection(),
        getAssetsPaginatedUseCase: injection(),
        searchAssetsUseCase: injection(),
      ));
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
        getMasterDataUseCase: injection(),
      ));

  injection.registerFactory(() => DomesticRatingCardCubit(
        saveDomesticRatingCard: injection(),
        getDomesticRatingCardAutofill: injection(),
      ));

  injection.registerFactory(() => OfficesRatingCardCubit(
        saveOfficesRatingCard: injection(),
        getOfficesRatingCardAutofill: injection(),
      ));

  injection
      .registerFactory(() => PastValuationCubit(appSharedData: injection()));
  injection
      .registerFactory(() => InspectionReportCubit(appSharedData: injection()));

  // ------------------------------
  // Auth Dependencies
  // ------------------------------
  injection.registerLazySingleton(() => SecureStorage());
  injection.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(injection(), injection()),
  );
  injection.registerLazySingleton(
    () => SignInService(authRepository: injection()),
  );
  injection.registerFactory(() => I3MasterFileListCubit(
        appSharedData: injection(),
        getPaginatedUseCase: injection(),
        searchUseCase: injection(),
      ));

  injection.registerFactory(() => MrRequestsCubit(
        appSharedData: injection(),
        getMrRequestsPaginatedUseCase: injection(),
      ));

  injection.registerFactory(() => AssetDivisionCubit(
        divideAssetUseCase: injection(),
        validateAssetDivisionUseCase: injection(),
      ));
  injection.registerFactory(() => LmMasterfileListCubit(
        appSharedData: injection(),
        getAllUseCase: injection(),
        getPaginatedUseCase: injection(),
        searchUseCase: injection(),
      ));
}
