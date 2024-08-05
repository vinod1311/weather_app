
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_app/features/weather_detail/domain/entity/weather_detail_entity.dart';
import 'package:weather_app/features/weather_detail/domain/usecases/get_weather_detail_usecase.dart';
import 'package:weather_app/features/weather_detail/presentation/bloc/weather_detail_bloc.dart';
import 'config/routes/app_router.dart';
import 'config/theme/theme_data_style.dart';
import 'config/config_injection.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/sign_in_usecase.dart';
import 'features/auth/domain/usecases/sign_out_usecase.dart';
import 'features/auth/domain/usecases/sign_up_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/weather_detail/domain/entity/weather_detail_entity_adapter.dart';
import 'features/weather_detail/domain/usecases/get_weather_detail_by_coordinates_usecase.dart';


void main() async{

  //------ widget binding
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();

  //------- Hive setup
  Hive.initFlutter();
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(WeatherEntityAdapter());
  await Hive.openBox<WeatherDetailEntity>('weatherBox');

  //-------DI configure
  configureDependencies();

  //------- device orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);


  runApp(
    //---------- list of all bloc provider
    MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(
              signInUseCase: locator<SignInUseCase>(),
              signUpUseCase: locator<SignUpUseCase>(),
              signOutUseCase: locator<SignOutUseCase>(),
              getCurrentUserUseCase: locator<GetCurrentUserUseCase>(),
            )..add(CheckAuthStatusEvent()),
          ),
          BlocProvider(
            create: (_) => WeatherDetailBloc(
              getWeatherDetailUseCase: locator<GetWeatherDetailUseCase>(),
              getWeatherDetailByCoordinatesUseCase: locator<GetWeatherDetailByCoordinatesUseCase>(),
            ),
          ),
        ],
    child: const MyApp())
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context,child){
          return MaterialApp.router(
            title: 'WEATHER APP',
            debugShowCheckedModeBanner: false,
            theme: ThemeDataStyle.light,
            darkTheme: ThemeDataStyle.dark,
            themeMode: ThemeMode.system,
            routerConfig: _appRouter.config(),
          );
        }
    );
  }
}






