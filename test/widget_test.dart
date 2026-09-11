import 'package:flutter_test/flutter_test.dart';

import 'package:meal4u/main.dart';

void main() {
  testWidgets('App boots without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const Meal4UApp());

    expect(find.text('Login screen goes here next'), findsOneWidget);
  });
}