import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:weather_app/core/resources/network/network_service.dart';
import 'package:weather_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:weather_app/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:weather_app/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:weather_app/features/weather_detail/data/data_sources/weather_detail_data_source.dart';
import 'package:weather_app/features/weather_detail/domain/entity/weather_detail_entity.dart';
import 'package:weather_app/features/weather_detail/domain/usecases/get_weather_detail_by_coordinates_usecase.dart';
import '../features/auth/data/data_sources/firebase_auth_data_source.dart';
import '../features/auth/data/repository/auth_repository_impl.dart';
import '../features/auth/domain/repository/auth_repository.dart';
import '../features/auth/domain/usecases/sign_in_usecase.dart';
import '../features/weather_detail/data/repository/weather_detail_repository_impl.dart';
import '../features/weather_detail/domain/repository/weather_detail_repository.dart';
import '../features/weather_detail/domain/usecases/get_local_weather_detail.dart';
import '../features/weather_detail/domain/usecases/get_weather_detail_usecase.dart';
import '../features/weather_detail/domain/usecases/save_weather_detail.dart';

final GetIt locator = GetIt.instance;

void configureDependencies() {
  // Register FirebaseAuth
  locator.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Register FireBase Auth Data Sources
  locator.registerLazySingleton<FirebaseAuthDataSource>(
        () => FirebaseAuthDataSource(locator<FirebaseAuth>()),
  );

  // Register Auth Repositories
  locator.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(locator<FirebaseAuthDataSource>()),
  );

  // Register Sign In Use Cases
  locator.registerFactory<SignInUseCase>(
        () => SignInUseCase(locator<AuthRepository>()),
  );

  // Register Sign Up Use Cases
  locator.registerFactory<SignUpUseCase>(
        () => SignUpUseCase(locator<AuthRepository>()),
  );

  // Register Sign Out Use Cases
  locator.registerFactory<SignOutUseCase>(
        () => SignOutUseCase(locator<AuthRepository>()),
  );

  // Register Sign Out Use Cases
  locator.registerFactory<GetCurrentUserUseCase>(
        () => GetCurrentUserUseCase(locator<AuthRepository>()),
  );



  locator.registerLazySingleton<Dio>(() => Dio(BaseOptions(
    baseUrl: '',
    connectTimeout: const Duration(milliseconds: 5000),
    receiveTimeout: const Duration(milliseconds: 3000),
  )));

  locator.registerLazySingleton<NetworkService>(() => NetworkService(locator<Dio>()));

  locator.registerLazySingleton<Box<WeatherDetailEntity>>(() => Hive.box<WeatherDetailEntity>('weatherBox'));
  locator.registerLazySingleton<WeatherDetailDataSource>(() => WeatherDetailDataSource(locator<NetworkService>(), locator<Box<WeatherDetailEntity>>()));
  locator.registerLazySingleton<WeatherDetailRepository>(() => WeatherDetailRepositoryImpl(locator<WeatherDetailDataSource>()));

  locator.registerFactory<GetLocalWeatherDetailUseCase>(() => GetLocalWeatherDetailUseCase(locator<WeatherDetailRepository>()));
  locator.registerFactory<SaveWeatherDetailUseCase>(() => SaveWeatherDetailUseCase(locator<WeatherDetailRepository>()));
  locator.registerFactory<GetWeatherDetailUseCase>(() => GetWeatherDetailUseCase(locator<WeatherDetailRepository>()));
  locator.registerFactory<GetWeatherDetailByCoordinatesUseCase>(() => GetWeatherDetailByCoordinatesUseCase(locator<WeatherDetailRepository>()));

}