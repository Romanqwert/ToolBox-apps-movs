import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_post.dart';

class NewsService {
  /// API REST nativa de WordPress (wp-json/wp/v2/posts) sobre el blog oficial
  /// de noticias de WordPress.org. Es la URL que se publica en el foro.
  /// Si se desea usar otro sitio WordPress, basta con cambiar esta constante
  /// (debe terminar en /wp-json/wp/v2/posts).
  static const String baseUrl = 'https://wordpress.org/news/wp-json/wp/v2/posts';

  // Alternativa de respaldo documentada en el TRD, por si el sitio principal
  // no estuviera disponible en el momento de la demo:
  // static const String baseUrl = 'https://techcrunch.com/wp-json/wp/v2/posts';

  static Future<List<NewsPost>> obtenerUltimasNoticias({int cantidad = 3}) async {
    final uri = Uri.parse('$baseUrl?per_page=$cantidad&_embed');
    final response = await http.get(uri).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as List;
      return decoded.map((item) {
        final map = item as Map<String, dynamic>;
        // Extraer imagen destacada desde _embedded si esta presente.
        String? imagen;
        try {
          final embedded = map['_embedded'] as Map<String, dynamic>?;
          final media = embedded?['wp:featuredmedia'] as List?;
          if (media != null && media.isNotEmpty) {
            imagen = media[0]['source_url'];
          }
        } catch (_) {
          imagen = null;
        }
        final post = NewsPost.fromJson(map);
        return NewsPost(
          id: post.id,
          title: post.title,
          excerpt: post.excerpt,
          link: post.link,
          featuredImageUrl: imagen ?? post.featuredImageUrl,
          date: post.date,
        );
      }).toList();
    } else {
      throw Exception('No se pudieron obtener las noticias (codigo ${response.statusCode}).');
    }
  }
}
