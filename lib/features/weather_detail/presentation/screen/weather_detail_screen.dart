import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../config/assets.dart';
import '../../../../config/routes/app_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../data/model/weather_detail_model.dart';
import '../bloc/weather_detail_bloc.dart';
import '../bloc/weather_detail_event.dart';
import '../bloc/weather_detail_state.dart';
import 'location_selection_screen.dart';

@RoutePage()
class WeatherDetailScreen extends StatefulWidget {
  const WeatherDetailScreen({super.key});

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      //---------- fetching weather detail using current coordinates
      context.read<WeatherDetailBloc>().add(FetchWeatherDetailByCoordinates());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('WEATHER APP',style: Theme.of(context).appBarTheme.titleTextStyle,),centerTitle: true,
        actions: [
          //-----sign out button
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutEvent(context));
            },
          ),
        ],
      ),

      body: BlocConsumer<WeatherDetailBloc, WeatherDetailState>(
        listener: (context, state) {
          if (state is WeatherDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is WeatherDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WeatherDetailLoaded) {
            return _WeatherDetails(weather: state.weather);
          } else if (state is WeatherDetailOffline) {
            return _WeatherDetails(
              weather: state.weather,
              isOffline: true,
            );
          } else {
            return const Center(
              child: Text('Please try again later.'),
            );
          }
        },
      ),
    );
  }


}


//----------- Weather Detail Widget
class _WeatherDetails extends StatelessWidget {
  final WeatherDetailModel weather;
  final bool isOffline;

  const _WeatherDetails({required this.weather, this.isOffline = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Column(
              children: [

                //-----Search Text Field
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: InkWell(
                    onTap: () {
                      context.router.push(const LocationSelectionRoute());
                    },
                    child: const TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Search Location',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40.h),

                //-----Weather Image
                Image.asset(Assets.weatherImage, width: 150.w, height: 150.h),
                SizedBox(height: 20.h),

                //-----City Name
                Text(
                  weather.name,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),

          //-----Temperature, Humidity, Wind
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeatherInfo(
                icon: FontAwesomeIcons.temperatureHigh,
                label: 'Temperature',
                value: '${weather.temperature} °C',
              ),
              _WeatherInfo(
                icon: FontAwesomeIcons.droplet,
                label: 'Humidity',
                value: '${weather.humidity} %',
              ),
              _WeatherInfo(
                icon: FontAwesomeIcons.wind,
                label: 'Wind',
                value: '${weather.windSpeed} km/h',
              ),
            ],
          ),

          //if user no internet then it shows message
          if (isOffline)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                'You are viewing offline data',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red[300],
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}


//------ Weather Info Widget it shows icon label and value of weather
class _WeatherInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FaIcon(icon, size: 40.sp),
        SizedBox(height: 8.h),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).disabledColor),
        ),
      ],
    );
  }
}


