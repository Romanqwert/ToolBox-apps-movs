import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/tool_card.dart';
import 'gender_screen.dart';
import 'age_screen.dart';
import 'universities_screen.dart';
import 'weather_screen.dart';
import 'pokemon_screen.dart';
import 'news_screen.dart';
import 'about_screen.dart';

/// Vista 1: Home / Caja de herramientas.
/// Punto de entrada visual con la imagen de bienvenida y el grid
/// de accesos a cada una de las herramientas de la aplicacion.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.handyman, color: Colors.white),
            SizedBox(width: 8),
            Text('Toolbox App'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Hero: imagen de caja de herramientas ---
            Container(
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [AppTheme.primary, Color(0xFF4A7FB5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Imagen ilustrativa de la caja de herramientas.
                  // Si no se incluye assets/images/toolbox.png, se muestra
                  // un icono grande como respaldo automatico.
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/toolbox.png',
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.handyman, color: Colors.white, size: 80);
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                  ),
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Tu caja de herramientas digital',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Una app, muchas utilidades',
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Elige una herramienta',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // --- Grid de herramientas ---
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.05,
              children: [
                ToolCard(
                  icon: Icons.wc,
                  title: 'Predecir Género',
                  color: AppTheme.femenino,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const GenderScreen())),
                ),
                ToolCard(
                  icon: Icons.cake,
                  title: 'Predecir Edad',
                  color: AppTheme.adulto,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AgeScreen())),
                ),
                ToolCard(
                  icon: Icons.school,
                  title: 'Universidades',
                  color: AppTheme.universidades,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const UniversitiesScreen())),
                ),
                ToolCard(
                  icon: Icons.wb_sunny,
                  title: 'Clima en RD',
                  color: AppTheme.clima,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const WeatherScreen())),
                ),
                ToolCard(
                  icon: Icons.catching_pokemon,
                  title: 'Pokémon',
                  color: AppTheme.pokemonAzul,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const PokemonScreen())),
                ),
                ToolCard(
                  icon: Icons.rss_feed,
                  title: 'Noticias',
                  color: AppTheme.noticias,
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const NewsScreen())),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // --- Acceso a "Acerca de" ---
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.primary,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: const Text('Acerca de'),
                subtitle: const Text('Autor de la aplicación y contacto'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const AboutScreen())),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
