import 'package:flutter/material.dart';
import '../models/gender_result.dart';
import '../services/gender_service.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';
import '../widgets/primary_button.dart';

enum _Estado { inicial, cargando, exito, error }

/// Vista 2: Prediccion de genero a partir de un nombre.
/// Consume https://api.genderize.io y cambia la paleta de la pantalla
/// (azul/rosa) segun el resultado.
class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  final TextEditingController _controller = TextEditingController();
  _Estado _estado = _Estado.inicial;
  GenderResult? _resultado;
  String _errorMsg = '';

  Future<void> _predecir() async {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe un nombre primero.')),
      );
      return;
    }
    setState(() => _estado = _Estado.cargando);
    try {
      final resultado = await GenderService.predecirGenero(nombre);
      setState(() {
        _resultado = resultado;
        _estado = _Estado.exito;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'No se pudo predecir el género. Verifica tu conexión e inténtalo de nuevo.';
        _estado = _Estado.error;
      });
    }
  }

  Color get _fondo {
    if (_estado == _Estado.exito && _resultado != null) {
      if (_resultado!.isMale) return AppTheme.masculinoFondo;
      if (_resultado!.isFemale) return AppTheme.femeninoFondo;
    }
    return const Color(0xFFF6F8FB);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fondo,
      appBar: AppBar(
        title: const Text('Predicción de Género'),
        backgroundColor: AppTheme.femenino,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _predecir(),
              decoration: const InputDecoration(
                labelText: 'Nombre de la persona',
                hintText: 'Ej. Irma, Carlos, Maria...',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Predecir',
              icon: Icons.search,
              color: AppTheme.femenino,
              onPressed: _estado == _Estado.cargando ? null : _predecir,
            ),
            const SizedBox(height: 28),
            Expanded(child: _buildContenido()),
          ],
        ),
      ),
    );
  }

  Widget _buildContenido() {
    switch (_estado) {
      case _Estado.inicial:
        return const Center(
          child: Text(
            'Escribe un nombre y descubre si la app lo predice como masculino o femenino.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        );
      case _Estado.cargando:
        return const LoadingView(mensaje: 'Consultando genderize.io...');
      case _Estado.error:
        return ErrorView(mensaje: _errorMsg, onRetry: _predecir);
      case _Estado.exito:
        return _buildResultado();
    }
  }

  Widget _buildResultado() {
    final r = _resultado!;
    if (r.isUnknown) {
      return const Center(
        child: Text(
          'No se pudo determinar el género para ese nombre.\nIntenta con otro nombre.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    final esMasculino = r.isMale;
    final colorPrincipal = esMasculino ? AppTheme.masculino : AppTheme.femenino;
    final icono = esMasculino ? Icons.male : Icons.female;
    final etiqueta = esMasculino ? 'Masculino' : 'Femenino';
    final probabilidad = ((r.probability ?? 0) * 100).toStringAsFixed(0);

    return Center(
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: colorPrincipal,
                child: Icon(icono, color: Colors.white, size: 54),
              ),
              const SizedBox(height: 18),
              Text(
                r.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                etiqueta,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorPrincipal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Probabilidad: $probabilidad% (muestras: ${r.count})',
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
