import 'package:weather_app/features/weather_detail/data/model/weather_detail_model.dart';
import 'package:weather_app/features/weather_detail/domain/repository/weather_detail_repository.dart';

import '../entity/weather_detail_entity.dart';

class GetWeatherDetailUseCase{
  final WeatherDetailRepository _weatherDetailRepository;

  const GetWeatherDetailUseCase(this._weatherDetailRepository);

  Future<WeatherDetailModel?> call(String location)async{
    return await _weatherDetailRepository.getWeatherDetail(location);
  }
}