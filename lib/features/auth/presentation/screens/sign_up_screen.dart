import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:weather_app/features/weather_detail/presentation/screen/weather_detail_screen.dart';

import '../../../../config/assets.dart';
import '../../../../config/routes/app_router.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';

@RoutePage()
class SignUpScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SIGN UP',style: Theme.of(context).appBarTheme.titleTextStyle,),centerTitle: true,),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WeatherDetailScreen()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: <Widget>[
                SizedBox(height: 40.h,),
                Image.asset(Assets.signUpImage, width: 250.w, height: 250.h),
                SizedBox(height: 20.h,),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email',),
                ),
                SizedBox(height: 20.h,),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 40.h),
                const SizedBox(height: 20),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        final email = emailController.text;
                        final password = passwordController.text;
                        context.read<AuthBloc>().add(
                          SignUpEvent(email,password),
                        );
                      },
                      child: const Text('Sign Up'),
                    );
                  },
                ),
                TextButton(
                  onPressed: () {
                    context.router.push(SignInRoute());
                  },
                  child:Text('Already have an account? Login',style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor)),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
