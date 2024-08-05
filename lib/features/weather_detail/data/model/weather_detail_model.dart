
import 'package:weather_app/features/weather_detail/domain/entity/weather_detail_entity.dart';

class WeatherDetailModel extends WeatherDetailEntity {

  const WeatherDetailModel({required super.temperature, required super.humidity, required super.windSpeed,required super.name});


  // factory WeatherDetailModel.fromJson(Map<String, dynamic> json) {
  //   return WeatherDetailModel(
  //     temperature: json['uid'],
  //     humidity: json['email'],
  //     windSpeed: json['displayName'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'name':name,
    };
  }

  @override
  List<Object?> get props => [temperature,humidity,windSpeed,name];

}