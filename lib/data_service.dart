import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models.dart';

class DataService{
  Future<WeatherResponse> getWeather(String city) async{
  //api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}

    final queryParameters = {'q': city, 'appid': 'f5be9266a98c55d98f29a5f63dc16c08', 'units': 'metric'};
    final uri = Uri.https('api.openweathermap.org', '/data/2.5/weather', queryParameters);

    final response = await http.get(uri);
    final json = jsonDecode(response.body);

    return WeatherResponse.fromJson(json);
  }
}