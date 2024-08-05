import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/features/auth/presentation/screens/sign_in_screen.dart';

import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/weather_detail/presentation/screen/location_selection_screen.dart';
import '../../features/weather_detail/presentation/screen/weather_detail_screen.dart';
import '../../splash_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: SignInRoute.page),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: LocationSelectionRoute.page),
    AutoRoute(page: WeatherDetailRoute.page),
  ];
}