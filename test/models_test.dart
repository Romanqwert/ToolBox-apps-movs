import 'package:flutter_test/flutter_test.dart';
import 'package:toolbox_jfr/models/age_result.dart';
import 'package:toolbox_jfr/models/gender_result.dart';

void main() {
  group('AgeResult', () {
    test('fromJson parsea una respuesta valida de agify.io', () {
      final result = AgeResult.fromJson({'name': 'Josue', 'age': 30, 'count': 123});

      expect(result.name, 'Josue');
      expect(result.age, 30);
      expect(result.count, 123);
    });

    test('fromJson admite age null (nombre desconocido)', () {
      final result = AgeResult.fromJson({'name': 'Xyz', 'age': null, 'count': 0});

      expect(result.age, isNull);
    });

    test('categoria clasifica correctamente segun la edad', () {
      expect(25.categoria, AgeCategory.joven);
      expect(59.categoria, AgeCategory.adulto);
      expect(60.categoria, AgeCategory.anciano);
      expect(null.categoria, AgeCategory.desconocido);
    });
  });

  group('GenderResult', () {
    test('fromJson parsea una respuesta valida de genderize.io', () {
      final result = GenderResult.fromJson({
        'name': 'Maria',
        'gender': 'female',
        'probability': 0.97,
        'count': 4500,
      });

      expect(result.isFemale, isTrue);
      expect(result.isMale, isFalse);
      expect(result.isUnknown, isFalse);
      expect(result.probability, 0.97);
    });

    test('fromJson admite gender null (nombre desconocido)', () {
      final result = GenderResult.fromJson({'name': 'Xyz', 'gender': null, 'count': 0});

      expect(result.isUnknown, isTrue);
    });
  });
}
