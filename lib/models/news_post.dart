/// Modelo para cada post devuelto por la API REST de WordPress.
class NewsPost {
  final int id;
  final String title;
  final String excerpt;
  final String link;
  final String? featuredImageUrl;
  final String date;

  NewsPost({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.link,
    required this.featuredImageUrl,
    required this.date,
  });

  factory NewsPost.fromJson(Map<String, dynamic> json) {
    // El titulo y el excerpt pueden venir con etiquetas HTML; se limpian.
    final rawTitle = json['title'] is Map
        ? (json['title']['rendered'] ?? '')
        : (json['title'] ?? '');
    final rawExcerpt = json['excerpt'] is Map
        ? (json['excerpt']['rendered'] ?? '')
        : (json['excerpt'] ?? '');

    return NewsPost(
      id: json['id'] ?? 0,
      title: _stripHtml(rawTitle),
      excerpt: _stripHtml(rawExcerpt),
      link: json['link'] ?? '',
      // La imagen destacada se resuelve aparte en NewsService usando _embedded,
      // por lo que aqui queda null por defecto y se sobreescribe luego.
      featuredImageUrl: null,
      date: json['date'] ?? '',
    );
  }

  static String _stripHtml(String input) {
    final withoutTags = input.replaceAll(RegExp(r'<[^>]*>'), ' ');
    final withoutEntities = withoutTags
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&#8217;', "'")
        .replaceAll('&#8220;', '"')
        .replaceAll('&#8221;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&hellip;', '...');
    return withoutEntities.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
