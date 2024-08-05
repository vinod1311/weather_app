import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:weather_app/core/resources/network/api_response.dart';
import 'package:weather_app/core/resources/network/network_service.dart';
import 'package:weather_app/features/weather_detail/data/model/weather_detail_model.dart';
import 'package:weather_app/features/weather_detail/domain/entity/weather_detail_entity.dart';
import 'package:weather_app/features/weather_detail/domain/repository/weather_detail_repository.dart';

import '../../../../core/resources/network/api_endpoints.dart';

class WeatherDetailDataSource implements WeatherDetailRepository{
  final NetworkService _networkService;
  final Box<WeatherDetailEntity> _weatherBox;

  const WeatherDetailDataSource(this._networkService, this._weatherBox);

  @override
  Future<WeatherDetailModel?> getWeatherDetail(String location) async{
    try{
      final  ApiResponse<dynamic>  response = await _networkService.get(ApiEndpoints.getWeatherAPIUrl(location));

      log("-----------Response Error ***-: ${response.error}");

      final data = response.data;
      final weather = WeatherDetailModel(
        temperature: data['main']['temp'],
        humidity: data['main']['humidity'],
        windSpeed: data['wind']['speed'],
          name:data['name']
      );

      await saveWeatherDetail(weather);

      return weather;
    }catch(e){
      log("----**ERROR**----- Error fetching weather details from Remote ${e.toString()}");

      // Fallback to local data
      log("----FALLBACK----- Error fetching weather details from local storage");

      final localWeather = await getLocalWeatherDetail();
      if (localWeather != null) {
        log("----FALLBACK SUCCESS----- Returning local weather data");
        return WeatherDetailModel(
          temperature: localWeather.temperature,
          humidity: localWeather.humidity,
          windSpeed: localWeather.windSpeed,
          name:  localWeather.name,
        );
      } else {
        log("----FALLBACK FAILURE----- No local weather data available");
        return null;
      }
    }
  }

  @override
  Future<WeatherDetailEntity?> getLocalWeatherDetail()async{
    try {
      WeatherDetailEntity? weather = _weatherBox.get("weather");
      if (weather != null) {
        log("----LOCAL SUCCESS----- Retrieved weather details from local storage");
      } else {
        log("----LOCAL FAILURE----- No weather details found in local storage");
      }
      return weather;
    } catch (e) {
      log("----**ERROR**----- Error fetching weather details from local: ${e.toString()}");
      return null;
    }
  }

  @override
  Future<void> saveWeatherDetail(WeatherDetailEntity weather)async {
    try{
      await _weatherBox.put("weather",weather);
    }catch(e){
      log("----**ERROR**----- Error saving WeatherDetail From Local ${e.toString()}");
    }
  }

  @override
  Future<WeatherDetailModel?> getWeatherDetailByCoordinates(double lat, double lon) async{
    try{
      final  ApiResponse<dynamic>  response = await _networkService.get(ApiEndpoints.getWeatherByCoordinatesAPIUrl(lat,lon));

      log("-----------Response Error ***-: ${response.error}");

      final data = response.data;
      final weather = WeatherDetailModel(
        temperature: data['main']['temp'],
        humidity: data['main']['humidity'],
        windSpeed: data['wind']['speed'],
        name:data['name']
      );

      await saveWeatherDetail(weather);

      return weather;
    }catch(e){
      log("----**ERROR**----- Error fetching weather details using coordinates from Remote ${e.toString()}");

      // Fallback to local data
      log("----FALLBACK----- Error fetching weather details using coordinates from local storage");

      final localWeather = await getLocalWeatherDetail();
      if (localWeather != null) {
        log("----FALLBACK SUCCESS----- Returning local weather data using coordinates");
        return WeatherDetailModel(
          temperature: localWeather.temperature,
          humidity: localWeather.humidity,
          windSpeed: localWeather.windSpeed,
          name: localWeather.name,
        );
      } else {
        log("----FALLBACK FAILURE----- No local weather data available  using coordinates");
        return null;
      }
    }
  }

}