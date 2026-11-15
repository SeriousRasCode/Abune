import 'package:abune/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens the About dialog', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byIcon(Icons.info_outline));
    await tester.pumpAndSettle();

    expect(find.byType(AboutDialog), findsOneWidget);
    expect(find.text('Made in ❤️ by Tedros Teshome'), findsOneWidget);
  });

  testWidgets('switches the theme', (tester) async {
    await tester.pumpWidget(const MyApp());

    final startsLight = find.byIcon(Icons.dark_mode).evaluate().isNotEmpty;
    await tester.tap(find.byTooltip('Toggle Day/Night Mode'));
    await tester.pumpAndSettle();

    expect(
      find.byIcon(startsLight ? Icons.light_mode : Icons.dark_mode),
      findsOneWidget,
    );
  });
}
