
import '../../data/model/weather_detail_model.dart';

abstract class WeatherDetailState{}

class WeatherDetailInitial extends WeatherDetailState{}

class WeatherDetailLoading extends WeatherDetailState{}

class WeatherDetailError extends WeatherDetailState{
  final String message;
  WeatherDetailError(this.message);
  @override
  List<Object?> get props => [message];
}

class WeatherDetailLoaded extends WeatherDetailState {
  final WeatherDetailModel weather;

  WeatherDetailLoaded(this.weather);

  @override
  List<Object?> get props => [weather];
}

class WeatherDetailOffline extends WeatherDetailState {
  final WeatherDetailModel weather;

  WeatherDetailOffline(this.weather);

  @override
  List<Object?> get props => [weather];
}

class WeatherDetailLocationUpdated extends WeatherDetailState {
  final String city;

  WeatherDetailLocationUpdated({required this.city});

  @override
  List<Object> get props => [city];
}