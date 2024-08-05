
abstract class WeatherDetailEvent {}


class FetchWeatherDetail extends WeatherDetailEvent {
  final String city;

  FetchWeatherDetail({required this.city});
}

class FetchWeatherDetailByCoordinates extends WeatherDetailEvent {
  FetchWeatherDetailByCoordinates();
}


class UpdateLocation extends WeatherDetailEvent {
  final String city;

  UpdateLocation({required this.city});

  @override
  List<Object> get props => [city];
}