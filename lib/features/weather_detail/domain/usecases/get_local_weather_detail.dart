import 'package:weather_app/features/weather_detail/domain/repository/weather_detail_repository.dart';

import '../entity/weather_detail_entity.dart';

class GetLocalWeatherDetailUseCase{
  final WeatherDetailRepository _weatherDetailRepository;

  const GetLocalWeatherDetailUseCase(this._weatherDetailRepository);

  Future<WeatherDetailEntity?> call()async{
    return await _weatherDetailRepository.getLocalWeatherDetail();
  }
}