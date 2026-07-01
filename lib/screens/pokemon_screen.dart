import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/pokemon_result.dart';
import '../services/pokemon_service.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';
import '../widgets/primary_button.dart';

enum _Estado { inicial, cargando, exito, error }

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});

  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final TextEditingController _controller = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  _Estado _estado = _Estado.inicial;
  PokemonResult? _pokemon;
  String _errorMsg = '';
  bool _reproduciendo = false;

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _buscar() async {
    final nombre = _controller.text.trim();
    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe el nombre de un Pokémon.')),
      );
      return;
    }
    setState(() => _estado = _Estado.cargando);
    try {
      final pokemon = await PokemonService.buscarPokemon(nombre);
      setState(() {
        _pokemon = pokemon;
        _estado = _Estado.exito;
      });
    } catch (e) {
      setState(() {
        _errorMsg = e.toString().replaceFirst('Exception: ', '');
        _estado = _Estado.error;
      });
    }
  }

  Future<void> _reproducirSonido() async {
    final url = _pokemon?.cryUrl;
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay sonido disponible para este Pokémon.')),
      );
      return;
    }
    setState(() => _reproduciendo = true);
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo reproducir el sonido.')),
        );
      }
    } finally {
      if (mounted) setState(() => _reproduciendo = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscador de Pokémon'),
        backgroundColor: AppTheme.pokemonAzul,
      ),
      body: Column(
        children: [
          // Cabecera amarilla de Pokémon
          Container(
            color: AppTheme.pokemonAmarillo,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _buscar(),
                  style: const TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Nombre del Pokémon',
                    hintText: 'Ej. pikachu, charizard, mewtwo...',
                    prefixIcon: const Icon(Icons.catching_pokemon),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                PrimaryButton(
                  label: 'Buscar',
                  icon: Icons.search,
                  color: AppTheme.pokemonAzul,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.catching_pokemon, size: 64, color: Colors.black12),
              SizedBox(height: 12),
              Text(
                'Escribe el nombre de un Pokémon\npara ver sus datos.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        );
      case _Estado.cargando:
        return const LoadingView(mensaje: 'Consultando PokéAPI...');
      case _Estado.error:
        return ErrorView(mensaje: _errorMsg, onRetry: _buscar);
      case _Estado.exito:
        return _buildPokemon();
    }
  }

  Widget _buildPokemon() {
    final p = _pokemon!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Sprite del Pokémon
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (p.spriteUrl.isNotEmpty)
                    Image.network(
                      p.spriteUrl,
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.catching_pokemon,
                        size: 100,
                        color: Colors.black26,
                      ),
                    )
                  else
                    const Icon(Icons.catching_pokemon, size: 100, color: Colors.black26),
                  const SizedBox(height: 8),
                  Text(
                    p.nombreCapitalizado,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Experiencia base
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.pokemonAzul,
                child: Icon(Icons.bolt, color: Colors.white),
              ),
              title: const Text('Experiencia Base'),
              trailing: Text(
                '${p.baseExperience}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.pokemonAzul,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Habilidades
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome, color: AppTheme.pokemonAzul),
                      SizedBox(width: 8),
                      Text(
                        'Habilidades',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: p.abilities
                        .map((a) => Chip(
                              label: Text(a, style: const TextStyle(fontSize: 12)),
                              backgroundColor: AppTheme.pokemonAmarillo.withValues(alpha: 0.3),
                              side: const BorderSide(color: AppTheme.pokemonAmarillo),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Sonido
          Card(
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.pokemonAmarillo,
                child: Icon(Icons.volume_up, color: Colors.black87),
              ),
              title: const Text('Sonido del Pokémon'),
              subtitle: Text(p.cryUrl != null ? 'Cry disponible' : 'No disponible'),
              trailing: ElevatedButton.icon(
                onPressed: (p.cryUrl != null && !_reproduciendo) ? _reproducirSonido : null,
                icon: _reproduciendo
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.play_arrow),
                label: const Text('Reproducir'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.pokemonAzul,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
