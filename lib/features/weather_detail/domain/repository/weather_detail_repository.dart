import '../../data/model/weather_detail_model.dart';
import '../entity/weather_detail_entity.dart';

abstract class WeatherDetailRepository {

  Future<WeatherDetailModel?> getWeatherDetail(String location);

  Future<WeatherDetailModel?> getWeatherDetailByCoordinates(double lat, double lon);

  Future<void> saveWeatherDetail(WeatherDetailEntity weather);

  Future<WeatherDetailEntity?> getLocalWeatherDetail();
}