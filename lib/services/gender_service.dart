import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gender_result.dart';

class GenderService {
  static Future<GenderResult> predecirGenero(String nombre) async {
    final uri = Uri.parse('https://api.genderize.io/?name=${Uri.encodeComponent(nombre)}');
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return GenderResult.fromJson(json);
    } else {
      throw Exception('No se pudo consultar el servicio de genero (codigo ${response.statusCode}).');
    }
  }
}
