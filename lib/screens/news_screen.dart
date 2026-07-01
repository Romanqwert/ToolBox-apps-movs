import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news_post.dart';
import '../services/news_service.dart';
import '../theme/app_theme.dart';
import '../widgets/loading_view.dart';
import '../widgets/error_view.dart';

enum _Estado { cargando, exito, error }

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  _Estado _estado = _Estado.cargando;
  List<NewsPost> _noticias = [];
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _cargarNoticias();
  }

  Future<void> _cargarNoticias() async {
    setState(() => _estado = _Estado.cargando);
    try {
      final noticias = await NewsService.obtenerUltimasNoticias();
      setState(() {
        _noticias = noticias;
        _estado = _Estado.exito;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'No se pudieron cargar las noticias.\nVerifica tu conexión e inténtalo de nuevo.';
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
        title: const Text('Noticias WordPress'),
        backgroundColor: AppTheme.noticias,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar',
            onPressed: _cargarNoticias,
          ),
        ],
      ),
      body: _buildContenido(),
    );
  }

  Widget _buildContenido() {
    switch (_estado) {
      case _Estado.cargando:
        return const LoadingView(mensaje: 'Cargando últimas noticias...');
      case _Estado.error:
        return ErrorView(mensaje: _errorMsg, onRetry: _cargarNoticias);
      case _Estado.exito:
        return _buildLista();
    }
  }

  Widget _buildLista() {
    return CustomScrollView(
      slivers: [
        // Logo / header del sitio WordPress
        SliverToBoxAdapter(
          child: Container(
            color: AppTheme.noticias.withValues(alpha: 0.08),
            padding: const EdgeInsets.all(20),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rss_feed, color: AppTheme.noticias, size: 36),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WordPress.org News',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: AppTheme.noticias,
                      ),
                    ),
                    Text(
                      'Últimas 3 noticias publicadas',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Lista de noticias
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildNoticia(_noticias[index], index),
            childCount: _noticias.length,
          ),
        ),

        // Pie con URL del API
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'API: wordpress.org/news/wp-json/wp/v2/posts?per_page=3&_embed',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black38, fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoticia(NewsPost noticia, int index) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen destacada
          if (noticia.featuredImageUrl != null && noticia.featuredImageUrl!.isNotEmpty)
            Image.network(
              noticia.featuredImageUrl!,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 80,
                color: AppTheme.noticias.withValues(alpha: 0.1),
                child: const Icon(Icons.article, color: AppTheme.noticias, size: 40),
              ),
            )
          else
            Container(
              height: 60,
              color: AppTheme.noticias.withValues(alpha: 0.1),
              child: const Icon(Icons.article_outlined, color: AppTheme.noticias, size: 32),
            ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Numero de noticia
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppTheme.noticias,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Noticia ${index + 1}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),

                // Titulo
                Text(
                  noticia.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 6),

                // Resumen
                if (noticia.excerpt.isNotEmpty)
                  Text(
                    noticia.excerpt.length > 180
                        ? '${noticia.excerpt.substring(0, 180)}...'
                        : noticia.excerpt,
                    style: const TextStyle(color: Colors.black54, fontSize: 13, height: 1.4),
                  ),
                const SizedBox(height: 12),

                // Boton Visitar
                if (noticia.link.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _abrirUrl(noticia.link),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Visitar noticia'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.noticias,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
