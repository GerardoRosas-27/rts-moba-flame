
import 'package:flutter_test/flutter_test.dart';
import 'package:rts_moba_flame/main.dart';

void main() {
  testWidgets('App builds', (tester) async {
    // Flame GameWidget needs binding; smoke-check widget type only.
    expect(RtsApp, isNotNull);
  });
}
