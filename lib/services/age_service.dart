import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/age_result.dart';

class AgeService {
  static Future<AgeResult> predecirEdad(String nombre) async {
    final uri = Uri.parse('https://api.agify.io/?name=${Uri.encodeComponent(nombre)}');
    final response = await http.get(uri).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AgeResult.fromJson(json);
    } else {
      throw Exception('No se pudo consultar el servicio de edad (codigo ${response.statusCode}).');
    }
  }
}
