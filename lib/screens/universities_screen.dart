import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/university.dart';
import '../services/university_service.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';
import '../widgets/primary_button.dart';

enum _Estado { inicial, cargando, exito, error }

class UniversitiesScreen extends StatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  State<UniversitiesScreen> createState() => _UniversitiesScreenState();
}

class _UniversitiesScreenState extends State<UniversitiesScreen> {
  final TextEditingController _controller = TextEditingController();
  _Estado _estado = _Estado.inicial;
  List<University> _universidades = [];
  String _errorMsg = '';

  Future<void> _buscar() async {
    final pais = _controller.text.trim();
    if (pais.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe el nombre del país en inglés.')),
      );
      return;
    }
    setState(() => _estado = _Estado.cargando);
    try {
      final lista = await UniversityService.buscarUniversidades(pais);
      setState(() {
        _universidades = lista;
        _estado = _Estado.exito;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'No se pudo obtener la lista de universidades.\nVerifica tu conexión e inténtalo de nuevo.';
        _estado = _Estado.error;
      });
    }
  }

  Future<void> _abrirUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
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
        title: const Text('Universidades por País'),
        backgroundColor: AppTheme.universidades,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _buscar(),
                  decoration: const InputDecoration(
                    labelText: 'País (en inglés)',
                    hintText: 'Ej. Dominican Republic, Mexico, Spain...',
                    prefixIcon: Icon(Icons.flag),
                  ),
                ),
                const SizedBox(height: 12),
                PrimaryButton(
                  label: 'Buscar universidades',
                  icon: Icons.search,
                  color: AppTheme.universidades,
                  onPressed: _estado == _Estado.cargando ? null : _buscar,
                ),
              ],
            ),
          ),
          Expanded(child: _buildContenido()),
        ],
      ),
    );
  }

  Widget _buildContenido() {
    switch (_estado) {
      case _Estado.inicial:
        return const Center(
          child: Text(
            'Escribe el nombre de un país en inglés\npara ver sus universidades.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        );
      case _Estado.cargando:
        return const LoadingView(mensaje: 'Buscando universidades...');
      case _Estado.error:
        return ErrorView(mensaje: _errorMsg, onRetry: _buscar);
      case _Estado.exito:
        if (_universidades.isEmpty) {
          return const Center(
            child: Text(
              'No se encontraron universidades para ese país.\nVerifica el nombre e inténtalo de nuevo.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemCount: _universidades.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final u = _universidades[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: AppTheme.universidades,
                          child: Icon(Icons.school, color: Colors.white, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            u.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.language, size: 15, color: Colors.black45),
                        const SizedBox(width: 4),
                        Text(u.primaryDomain,
                            style: const TextStyle(color: Colors.black54, fontSize: 13)),
                      ],
                    ),
                    if (u.primaryWebPage.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _abrirUrl(u.primaryWebPage),
                          icon: const Icon(Icons.open_in_new, size: 16),
                          label: const Text('Visitar sitio web'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.universidades,
                            side: const BorderSide(color: AppTheme.universidades),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
    }
  }
}
