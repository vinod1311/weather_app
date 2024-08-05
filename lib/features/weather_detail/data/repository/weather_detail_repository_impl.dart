
import 'package:weather_app/features/weather_detail/data/data_sources/weather_detail_data_source.dart';
import 'package:weather_app/features/weather_detail/domain/entity/weather_detail_entity.dart';

import '../../domain/repository/weather_detail_repository.dart';
import '../model/weather_detail_model.dart';

class WeatherDetailRepositoryImpl implements WeatherDetailRepository{
  final WeatherDetailDataSource _weatherDetailDataSource;

  const WeatherDetailRepositoryImpl(this._weatherDetailDataSource);

  @override
  Future<WeatherDetailEntity?> getLocalWeatherDetail() async{
    return await _weatherDetailDataSource.getLocalWeatherDetail();
  }

  @override
  Future<WeatherDetailModel?> getWeatherDetail(String location) async{
    return await _weatherDetailDataSource.getWeatherDetail(location);
  }

  @override
  Future<void> saveWeatherDetail(WeatherDetailEntity weather) async{
    return await _weatherDetailDataSource.saveWeatherDetail(weather);
  }

  @override
  Future<WeatherDetailModel?> getWeatherDetailByCoordinates(double lat, double lon) async{
    return await _weatherDetailDataSource.getWeatherDetailByCoordinates(lat, lon);
  }
  
}