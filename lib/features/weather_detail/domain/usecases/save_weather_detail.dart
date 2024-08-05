import '../entity/weather_detail_entity.dart';
import '../repository/weather_detail_repository.dart';

class SaveWeatherDetailUseCase{
  final WeatherDetailRepository _weatherDetailRepository;

  const SaveWeatherDetailUseCase(this._weatherDetailRepository);

  Future<void> call(WeatherDetailEntity weatherDetail)async{
    await _weatherDetailRepository.saveWeatherDetail(weatherDetail);
  }
}