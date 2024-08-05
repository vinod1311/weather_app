
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/features/weather_detail/data/model/weather_detail_model.dart';
import 'package:weather_app/features/weather_detail/presentation/bloc/weather_detail_event.dart';
import 'package:weather_app/features/weather_detail/presentation/bloc/weather_detail_state.dart';
import '../../domain/usecases/get_weather_detail_by_coordinates_usecase.dart';
import '../../domain/usecases/get_weather_detail_usecase.dart';

class WeatherDetailBloc extends Bloc<WeatherDetailEvent,WeatherDetailState>{

  final GetWeatherDetailUseCase getWeatherDetailUseCase;
  final GetWeatherDetailByCoordinatesUseCase getWeatherDetailByCoordinatesUseCase;

  WeatherDetailBloc({required this.getWeatherDetailUseCase,required this.getWeatherDetailByCoordinatesUseCase}) : super(WeatherDetailInitial()){
    on<FetchWeatherDetail>(_onFetchWeatherDetail);
    on<UpdateLocation>(_onUpdateLocation);
    on<FetchWeatherDetailByCoordinates>(_onFetchWeatherDetailByCoordinates);
  }

  //------ Fetching weather detail using city name
  Future<void> _onFetchWeatherDetail(FetchWeatherDetail event,Emitter<WeatherDetailState> emit)async{
    emit(WeatherDetailLoading());
    try{
      WeatherDetailModel? weather = await getWeatherDetailUseCase.call(event.city);
      if(weather != null){
        emit(WeatherDetailLoaded(weather));
      }else{
        emit(WeatherDetailError("weather detail not found"));
      }
    }catch(e){
      emit(WeatherDetailError(e.toString()));
    }
  }

  //------ Fetching weather detail using coordinates
  Future<void> _onFetchWeatherDetailByCoordinates(FetchWeatherDetailByCoordinates event, Emitter<WeatherDetailState> emit) async {
    emit(WeatherDetailLoading());
    try {
      final currentPosition = await _getCurrentLocation(emit);
      if (currentPosition != null) {
        WeatherDetailModel? weather = await getWeatherDetailByCoordinatesUseCase.call(currentPosition.latitude, currentPosition.longitude);
        if (weather != null) {
          emit(WeatherDetailLoaded(weather));
        } else {
          emit(WeatherDetailError("Weather detail not found"));
        }
      }
    } catch (e) {
      emit(WeatherDetailError(e.toString()));
    }
  }

  //------ Fetching current coordinates and checks location is enable or not
  Future<Position?> _getCurrentLocation(Emitter<WeatherDetailState> emit) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      emit(WeatherDetailError('Location services are disabled.'));
      return null;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        emit(WeatherDetailError('Location permissions are denied.'));
        return null;
      }
    }

    // Get the current position
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      emit(WeatherDetailError('Failed to fetch location: $e'));
      return null;
    }
  }



  //------- Updating the location
  void _onUpdateLocation(
      UpdateLocation event, Emitter<WeatherDetailState> emit) {
    emit(WeatherDetailLocationUpdated(city: event.city));
    add(FetchWeatherDetail(city: event.city));
  }
}