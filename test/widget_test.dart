import 'package:flutter_test/flutter_test.dart';
import 'package:coderecall/main.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const CodeRecallApp(initSuccess: true));
    expect(find.byType(CodeRecallApp), findsOneWidget);
  });
}
