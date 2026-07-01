import 'package:flutter/material.dart';
import '../models/age_result.dart';
import '../services/age_service.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';
import '../widgets/primary_button.dart';

enum _Estado { inicial, cargando, exito, error }

/// Vista 3: Prediccion de edad a partir de un nombre.
/// Consume https://api.agify.io y clasifica el resultado en
/// Joven / Adulto / Anciano con icono e imagen representativa.
class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final TextEditingController _controller = TextEditingController();
  _Estado _estado = _Estado.inicial;
  AgeResult? _resultado;
  String _errorMsg = '';

  Future<void> _calcular() async {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe un nombre primero.')),
      );
      return;
    }
    setState(() => _estado = _Estado.cargando);
    try {
      final resultado = await AgeService.predecirEdad(nombre);
      setState(() {
        _resultado = resultado;
        _estado = _Estado.exito;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'No se pudo calcular la edad. Verifica tu conexión e inténtalo de nuevo.';
        _estado = _Estado.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predicción de Edad'),
        backgroundColor: AppTheme.adulto,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _calcular(),
              decoration: const InputDecoration(
                labelText: 'Nombre de la persona',
                hintText: 'Ej. Meelad, Sofia, Pedro...',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Calcular edad',
              icon: Icons.search,
              color: AppTheme.adulto,
              onPressed: _estado == _Estado.cargando ? null : _calcular,
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
            'Escribe un nombre para estimar la edad y ver su categoría.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        );
      case _Estado.cargando:
        return const LoadingView(mensaje: 'Consultando agify.io...');
      case _Estado.error:
        return ErrorView(mensaje: _errorMsg, onRetry: _calcular);
      case _Estado.exito:
        return _buildResultado();
    }
  }

  Widget _buildResultado() {
    final r = _resultado!;
    if (r.age == null) {
      return const Center(
        child: Text(
          'No hay datos suficientes para estimar la edad de ese nombre.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54),
        ),
      );
    }

    final categoria = r.age.categoria;
    late final Color color;
    late final IconData icono;
    late final String etiqueta;
    late final String descripcion;

    switch (categoria) {
      case AgeCategory.joven:
        color = AppTheme.joven;
        icono = Icons.directions_run;
        etiqueta = 'Joven';
        descripcion = 'Etapa de energía, estudio y nuevos comienzos.';
        break;
      case AgeCategory.adulto:
        color = AppTheme.adulto;
        icono = Icons.work;
        etiqueta = 'Adulto';
        descripcion = 'Etapa de madurez profesional y responsabilidades.';
        break;
      case AgeCategory.anciano:
        color = AppTheme.anciano;
        icono = Icons.elderly;
        etiqueta = 'Anciano';
        descripcion = 'Etapa de experiencia y sabiduría acumulada.';
        break;
      case AgeCategory.desconocido:
        color = Colors.grey;
        icono = Icons.help_outline;
        etiqueta = 'Desconocido';
        descripcion = '';
        break;
    }

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
                backgroundColor: color,
                child: Icon(icono, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 18),
              Text(
                r.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                '${r.age}',
                style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: color),
              ),
              const Text('años (estimado)', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  etiqueta,
                  style: TextStyle(fontWeight: FontWeight.bold, color: color),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                descripcion,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
