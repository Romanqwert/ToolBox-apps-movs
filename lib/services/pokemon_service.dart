import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_result.dart';

class PokemonService {
  static Future<PokemonResult> buscarPokemon(String nombre) async {
    final nombreNormalizado = nombre.trim().toLowerCase();
    final uri = Uri.parse('https://pokeapi.co/api/v2/pokemon/$nombreNormalizado');
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PokemonResult.fromJson(json);
    } else if (response.statusCode == 404) {
      throw Exception('Pokemon no encontrado. Verifica el nombre e intenta de nuevo.');
    } else {
      throw Exception('No se pudo consultar PokeAPI (codigo ${response.statusCode}).');
    }
  }
}
