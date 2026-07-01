/// Modelo para cada universidad devuelta por adamix.net/proxy.php (Hipolabs Universities API)
class University {
  final String name;
  final List<String> domains;
  final List<String> webPages;
  final String country;

  University({
    required this.name,
    required this.domains,
    required this.webPages,
    required this.country,
  });

  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'] ?? 'Sin nombre',
      domains: (json['domains'] as List?)?.map((e) => e.toString()).toList() ?? [],
      webPages: (json['web_pages'] as List?)?.map((e) => e.toString()).toList() ?? [],
      country: json['country'] ?? '',
    );
  }

  String get primaryDomain => domains.isNotEmpty ? domains.first : 'No disponible';
  String get primaryWebPage => webPages.isNotEmpty ? webPages.first : '';
}
