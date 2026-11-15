import 'package:abune/app/abune_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('opens the About dialog with creator credit', (tester) async {
    await tester.pumpWidget(const AbuneApp());
    await tester.tap(find.byTooltip('About'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Created by Tedros Teshome'), findsOneWidget);
    expect(find.textContaining('I built this Flutter app'), findsOneWidget);
  });

  testWidgets('switches the theme', (tester) async {
    await tester.pumpWidget(const AbuneApp());
    final startsLight = find.byIcon(Icons.dark_mode).evaluate().isNotEmpty;
    await tester.tap(find.byTooltip('Toggle Day/Night Mode'));
    await tester.pumpAndSettle();

    expect(find.byIcon(startsLight ? Icons.light_mode : Icons.dark_mode),
        findsOneWidget);
  });

  testWidgets('practice hides, reveals, and tracks a line', (tester) async {
    await tester.pumpWidget(const AbuneApp());
    await tester.tap(find.text('Practice').last);
    await tester.pumpAndSettle();

    expect(find.text('Line 1 of 11'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -300));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hide line'));
    await tester.pumpAndSettle();
    expect(find.text('Recite from memory'), findsOneWidget);

    await tester.tap(find.text('Reveal line'));
    await tester.pumpAndSettle();
    expect(find.text('በስመ አብ ወወልድ ወመንፈስ ቅዱስ አሐዱ አምላክ አሜን'),
        findsOneWidget);

    await tester.tap(find.text('Mark as learned'));
    await tester.pumpAndSettle();
    expect(find.text('1 of 11 lines marked as learned'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Line 2 of 11'), findsOneWidget);
    expect(find.text('Recite from memory'), findsOneWidget);
  });
}
