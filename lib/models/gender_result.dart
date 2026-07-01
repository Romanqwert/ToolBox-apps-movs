/// Modelo para la respuesta de https://api.genderize.io
class GenderResult {
  final String name;
  final String? gender; // "male", "female" o null
  final double? probability;
  final int count;

  GenderResult({
    required this.name,
    required this.gender,
    required this.probability,
    required this.count,
  });

  factory GenderResult.fromJson(Map<String, dynamic> json) {
    return GenderResult(
      name: json['name'] ?? '',
      gender: json['gender'],
      probability: (json['probability'] is num)
          ? (json['probability'] as num).toDouble()
          : null,
      count: json['count'] ?? 0,
    );
  }

  bool get isMale => gender == 'male';
  bool get isFemale => gender == 'female';
  bool get isUnknown => gender == null;
}
