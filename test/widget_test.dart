import 'package:flutter_test/flutter_test.dart';
import 'package:fixy_indonesia/main.dart';

void main() {
  testWidgets('Fixy Indonesia smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FixyIndonesiaApp());
    expect(find.byType(FixyIndonesiaApp), findsOneWidget);
  });
}
