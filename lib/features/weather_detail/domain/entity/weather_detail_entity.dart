import 'package:equatable/equatable.dart';

class WeatherDetailEntity extends Equatable{
  final double temperature;
  final int humidity;
  final double windSpeed;
  final String name;

  const WeatherDetailEntity({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.name,
  });

  @override
  List<Object?> get props => [temperature,humidity,windSpeed,name];

}