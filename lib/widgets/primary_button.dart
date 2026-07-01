import 'package:flutter/material.dart';

/// Boton de accion principal estilizado, reutilizado en todas las
/// pantallas de busqueda.
class PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        style: color != null
            ? ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              )
            : null,
      ),
    );
  }
}
