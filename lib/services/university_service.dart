import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/university.dart';

class UniversityService {
  static Future<List<University>> buscarUniversidades(String pais) async {
    final uri = Uri.parse('https://adamix.net/proxy.php?country=${Uri.encodeComponent(pais)}');
    final response = await http.get(uri).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is List) {
        return decoded
            .map((item) => University.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      // Algunos proxies envuelven el listado en un campo "data" o similar.
      if (decoded is Map && decoded['data'] is List) {
        return (decoded['data'] as List)
            .map((item) => University.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return [];
    } else {
      throw Exception('No se pudo consultar el servicio de universidades (codigo ${response.statusCode}).');
    }
  }
}
