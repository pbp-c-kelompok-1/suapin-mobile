import 'package:flutter_test/flutter_test.dart';
import 'package:suapin_mobile/main.dart';

void main() {
  testWidgets('SuapinApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SuapinApp());
    expect(find.text('Suap.in'), findsOneWidget);
  });
}
