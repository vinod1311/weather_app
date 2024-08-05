import 'package:hive/hive.dart';
import 'package:weather_app/features/weather_detail/domain/entity/weather_detail_entity.dart';

class WeatherEntityAdapter extends TypeAdapter<WeatherDetailEntity> {
  @override
  final int typeId = 0;

  @override
  WeatherDetailEntity read(BinaryReader reader) {
    return WeatherDetailEntity(
      temperature: reader.readDouble(),
      humidity: reader.readInt(),
      windSpeed: reader.readDouble(),
      name: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, WeatherDetailEntity obj) {
    writer.writeDouble(obj.temperature);
    writer.writeInt(obj.humidity);
    writer.writeDouble(obj.windSpeed);
    writer.writeString(obj.name);
  }
}
