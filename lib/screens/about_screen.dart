import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _abrirUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: AppTheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con degradado y foto
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF4A7FB5)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 36, 20, 36),
              child: Column(
                children: [
                  // Foto de perfil desde assets
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/foto2x2.png',
                        width: 114,
                        height: 114,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.person,
                          size: 70,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Josue Fondeur Román',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Estudiante de Desarrollo de Software',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Tarjeta de descripcion
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppTheme.primary),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Desarrollador de software con un enfoque sólido en arquitectura Full-Stack, desarrollo móvil y automatización de procesos.  '
                          'Especializado en el diseño de arquitecturas MVC, aplicaciones web progresivas (PWA) y la integración de inteligencia artificial para resolver problemas complejos de gestión de datos, con particular interés en el cumplimiento normativo fiscal de la República Dominicana y la auditoría de TI.',
                          style: TextStyle(color: Colors.black87, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Seccion de contacto
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'CONTACTO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black45,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),

            // Email
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEA4335),
                    child: Icon(Icons.email, color: Colors.white, size: 20),
                  ),
                  title: const Text('Email'),
                  subtitle: const Text('josueroman3005@gmail.com'),
                  trailing: const Icon(Icons.open_in_new,
                      size: 16, color: Colors.black38),
                  onTap: () =>
                      _abrirUrl(context, 'mailto:josueroman3005@gmail.com'),
                ),
              ),
            ),

            // LinkedIn
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF0A66C2),
                    child: Icon(Icons.work, color: Colors.white, size: 20),
                  ),
                  title: const Text('LinkedIn'),
                  subtitle: const Text('Josue Fondeur Roman'),
                  trailing: const Icon(Icons.open_in_new,
                      size: 16, color: Colors.black38),
                  onTap: () => _abrirUrl(
                    context,
                    'https://www.linkedin.com/in/josue-fondeur-roman-56560533a/',
                  ),
                ),
              ),
            ),

            // GitHub
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              child: Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF24292F),
                    child: Icon(Icons.code, color: Colors.white, size: 20),
                  ),
                  title: const Text('GitHub'),
                  subtitle: const Text('github.com/Romanqwert'),
                  trailing: const Icon(Icons.open_in_new,
                      size: 16, color: Colors.black38),
                  onTap: () =>
                      _abrirUrl(context, 'https://github.com/Romanqwert'),
                ),
              ),
            ),

            // Pie de pagina
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Toolbox App v1.0 · Josue Fondeur Román · 2026',
                style: TextStyle(color: Colors.black38, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
