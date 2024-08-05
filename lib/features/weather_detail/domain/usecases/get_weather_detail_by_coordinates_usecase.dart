

import '../../data/model/weather_detail_model.dart';
import '../repository/weather_detail_repository.dart';

class GetWeatherDetailByCoordinatesUseCase{
  final WeatherDetailRepository _weatherDetailRepository;

  const GetWeatherDetailByCoordinatesUseCase(this._weatherDetailRepository);

  Future<WeatherDetailModel?> call(double lat, double lon)async{
    return await _weatherDetailRepository.getWeatherDetailByCoordinates(lat,lon);
  }
}