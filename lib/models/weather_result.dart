import 'package:flutter/material.dart';

/// Modelo para la respuesta "current" de Open-Meteo.
class WeatherResult {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final bool isDay;
  final String time;

  WeatherResult({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.isDay,
    required this.time,
  });

  factory WeatherResult.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    return WeatherResult(
      temperature: (current['temperature_2m'] as num).toDouble(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: current['weather_code'] as int,
      isDay: (current['is_day'] ?? 1) == 1,
      time: current['time'] ?? '',
    );
  }

  /// Descripcion legible en espanol segun el codigo WMO de Open-Meteo.
  String get descripcion {
    if (weatherCode == 0) return 'Cielo despejado';
    if (weatherCode <= 2) return 'Parcialmente nublado';
    if (weatherCode == 3) return 'Nublado';
    if (weatherCode == 45 || weatherCode == 48) return 'Niebla';
    if (weatherCode >= 51 && weatherCode <= 57) return 'Llovizna';
    if (weatherCode >= 61 && weatherCode <= 67) return 'Lluvia';
    if (weatherCode >= 71 && weatherCode <= 77) return 'Nieve';
    if (weatherCode >= 80 && weatherCode <= 82) return 'Chubascos';
    if (weatherCode >= 95) return 'Tormenta';
    return 'Clima variable';
  }

  IconData get icono {
    if (weatherCode == 0) return isDay ? Icons.wb_sunny : Icons.nightlight_round;
    if (weatherCode <= 2) return Icons.wb_cloudy;
    if (weatherCode == 3) return Icons.cloud;
    if (weatherCode == 45 || weatherCode == 48) return Icons.foggy;
    if (weatherCode >= 51 && weatherCode <= 67) return Icons.umbrella;
    if (weatherCode >= 71 && weatherCode <= 77) return Icons.ac_unit;
    if (weatherCode >= 80 && weatherCode <= 82) return Icons.umbrella;
    if (weatherCode >= 95) return Icons.thunderstorm;
    return Icons.cloud_queue;
  }
}
