import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weather_app/config/routes/app_router.dart';

import '../bloc/weather_detail_bloc.dart';
import '../bloc/weather_detail_event.dart';

@RoutePage()
class LocationSelectionScreen extends StatefulWidget {
  const LocationSelectionScreen({super.key});

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {

  final TextEditingController _controller = TextEditingController();

  //----- this list for showing location example
  final List<String> _locations = ['Ahmedabad', 'Gandhinagar', 'New Delhi', 'Mumbai','Pune','Indore'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SELECT LOCATION',style: Theme.of(context).appBarTheme.titleTextStyle,),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //----------------- Text field for Searching location
            TypeAheadField<String>(
              controller: _controller,
              suggestionsCallback: (pattern) async {
                return _locations
                    .where((location) => location.toLowerCase().contains(pattern.toLowerCase()))
                    .toList();
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              onSelected: (suggestion) {
                _controller.text = suggestion;
                context.read<WeatherDetailBloc>().add(UpdateLocation(city: suggestion));
                Navigator.pop(context, suggestion);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<WeatherDetailBloc>()
                    .add(UpdateLocation(city: _controller.text));
                context.router.popUntilRouteWithName(WeatherDetailRoute.name);
              },
              child: const Text('Search'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
