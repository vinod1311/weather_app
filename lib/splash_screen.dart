import 'dart:async';
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/config/assets.dart';
import 'package:weather_app/features/auth/presentation/screens/sign_in_screen.dart';

import 'config/routes/app_router.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer? timer;

  //------init method
  @override
  void initState() {
    super.initState();
    timer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      navigateToHome(context);
    });
  }

  // ---- method for navigating to home screen
  void navigateToHome(BuildContext context) async {
    timer = Timer(
      const Duration(seconds: 3),
          () async{
        context.router.replace(SignInRoute());
      },
    );
  }

  //------dispose method
  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  //------build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.splashImage, width: 250.w, height: 250.h),
            SizedBox(height: 20.h),
            Text(
              'Weather App',
              style: Theme.of(context).textTheme.displayMedium,
            )
          ],
        ),
      ),
    );
  }
}