import 'package:amanah/core/theme/app_palette.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('brand color is the royal-blue primary (#2263F0)', () {
    // Guards the design-system ground truth (logo / CTA color).
    expect(AppPalette.brand.toARGB32(), 0xFF2263F0);
  });
}
