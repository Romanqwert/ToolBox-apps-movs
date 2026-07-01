import 'package:flutter/material.dart';
import '../models/weather_result.dart';
import '../services/weather_service.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';

enum _Estado { cargando, exito, error }

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  _Estado _estado = _Estado.cargando;
  WeatherResult? _clima;
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _cargarClima();
  }

  Future<void> _cargarClima() async {
    setState(() => _estado = _Estado.cargando);
    try {
      final clima = await WeatherService.obtenerClimaRD();
      setState(() {
        _clima = clima;
        _estado = _Estado.exito;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'No se pudo obtener el clima.\nVerifica tu conexión e inténtalo de nuevo.';
        _estado = _Estado.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clima en RD'),
        backgroundColor: AppTheme.clima,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _cargarClima,
          ),
        ],
      ),
      body: _buildContenido(),
    );
  }

  Widget _buildContenido() {
    switch (_estado) {
      case _Estado.cargando:
        return const LoadingView(mensaje: 'Obteniendo el clima de Santo Domingo...');
      case _Estado.error:
        return ErrorView(mensaje: _errorMsg, onRetry: _cargarClima);
      case _Estado.exito:
        return _buildClima();
    }
  }

  Widget _buildClima() {
    final c = _clima!;
    final hora = c.time.length >= 16 ? c.time.substring(11, 16) : c.time;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Hero del clima
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.clima, AppTheme.clima.withValues(alpha: 0.6)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Icon(c.icono, color: Colors.white, size: 80),
                const SizedBox(height: 12),
                Text(
                  '${c.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  c.descripcion,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Santo Domingo, República Dominicana',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Tarjetas de datos adicionales
          Row(
            children: [
              Expanded(
                child: _dataCard(
                  Icons.air,
                  'Viento',
                  '${c.windSpeed.toStringAsFixed(1)} km/h',
                  AppTheme.clima,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _dataCard(
                  c.isDay ? Icons.light_mode : Icons.dark_mode,
                  'Momento',
                  c.isDay ? 'Día' : 'Noche',
                  AppTheme.clima,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _dataCard(
            Icons.access_time,
            'Última actualización',
            hora.isNotEmpty ? 'Hoy a las $hora' : 'Reciente',
            Colors.grey,
          ),
          const SizedBox(height: 20),
          const Text(
            'Datos obtenidos de Open-Meteo · Santo Domingo (18.49°N, 69.93°O)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black38, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _dataCard(IconData icon, String label, String valor, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                Text(valor,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
