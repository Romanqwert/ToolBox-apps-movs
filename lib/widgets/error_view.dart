import 'package:flutter/material.dart';

/// Mensaje de error con boton de reintentar, reutilizado en todas
/// las pantallas que consumen una API.
class ErrorView extends StatelessWidget {
  final String mensaje;
  final VoidCallback? onRetry;

  const ErrorView({super.key, required this.mensaje, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
