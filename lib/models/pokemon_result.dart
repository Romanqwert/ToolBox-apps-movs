/// Modelo para la respuesta de https://pokeapi.co/api/v2/pokemon/{nombre}
class PokemonResult {
  final String name;
  final int baseExperience;
  final String spriteUrl;
  final List<String> abilities;
  final String? cryUrl;

  PokemonResult({
    required this.name,
    required this.baseExperience,
    required this.spriteUrl,
    required this.abilities,
    required this.cryUrl,
  });

  factory PokemonResult.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>? ?? {};
    final abilitiesJson = json['abilities'] as List? ?? [];
    final cries = json['cries'] as Map<String, dynamic>?;

    return PokemonResult(
      name: json['name'] ?? '',
      baseExperience: json['base_experience'] ?? 0,
      spriteUrl: sprites['front_default'] ?? '',
      abilities: abilitiesJson
          .map((a) => (a['ability']?['name'] ?? '').toString())
          .where((a) => a.isNotEmpty)
          .toList(),
      cryUrl: cries != null ? (cries['latest'] ?? cries['legacy']) : null,
    );
  }

  String get nombreCapitalizado =>
      name.isEmpty ? '' : '${name[0].toUpperCase()}${name.substring(1)}';
}
