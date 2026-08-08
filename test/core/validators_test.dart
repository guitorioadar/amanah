import 'package:amanah/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty and malformed', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('not-an-email'), isNotNull);
      expect(Validators.email('a@b'), isNotNull);
    });

    test('accepts a well-formed address', () {
      expect(Validators.email('auditor@isnahalal.com'), isNull);
    });
  });

  group('Validators.password', () {
    test('rejects empty and short', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password('123'), isNotNull);
    });

    test('accepts 6+ chars', () {
      expect(Validators.password('password'), isNull);
    });
  });
}
