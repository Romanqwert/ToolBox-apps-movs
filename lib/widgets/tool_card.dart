import 'package:flutter/material.dart';

/// Tarjeta del grid principal: icono + titulo + color de acento.
/// Usada en el Home para representar cada herramienta de la aplicacion.
class ToolCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const ToolCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color,
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
