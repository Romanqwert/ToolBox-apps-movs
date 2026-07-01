/// Modelo para la respuesta de https://api.agify.io
class AgeResult {
  final String name;
  final int? age;
  final int count;

  AgeResult({required this.name, required this.age, required this.count});

  factory AgeResult.fromJson(Map<String, dynamic> json) {
    return AgeResult(
      name: json['name'] ?? '',
      age: json['age'],
      count: json['count'] ?? 0,
    );
  }
}

enum AgeCategory { joven, adulto, anciano, desconocido }

extension AgeCategoryX on int? {
  AgeCategory get categoria {
    if (this == null) return AgeCategory.desconocido;
    if (this! <= 25) return AgeCategory.joven;
    if (this! <= 59) return AgeCategory.adulto;
    return AgeCategory.anciano;
  }
}
