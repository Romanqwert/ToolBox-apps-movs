import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_result.dart';

class WeatherService {
  // Coordenadas de Santo Domingo, Republica Dominicana.
  static const double _lat = 18.4861;
  static const double _lon = -69.9312;

  static Future<WeatherResult> obtenerClimaRD() async {
    final uri = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=$_lat&longitude=$_lon'
      '&current=temperature_2m,weather_code,wind_speed_10m,is_day'
      '&timezone=America%2FSanto_Domingo',
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return WeatherResult.fromJson(json);
    } else {
      throw Exception('No se pudo obtener el clima (codigo ${response.statusCode}).');
    }
  }
}
