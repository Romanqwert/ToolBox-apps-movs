import 'package:flutter/material.dart';

/// Indicador de carga centralizado, reutilizado en todas las pantallas
/// que consumen una API.
class LoadingView extends StatelessWidget {
  final String mensaje;
  const LoadingView({super.key, this.mensaje = 'Cargando...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(mensaje, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
