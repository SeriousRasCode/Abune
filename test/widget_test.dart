import 'package:abune/app/abune_app.dart';
import 'package:abune/services/cue_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });
  Widget app() => AbuneApp(cueStore: _MemoryCueStore());

  testWidgets('opens the About dialog with creator credit', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.byTooltip('About'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Created by Tedros Teshome'), findsOneWidget);
    expect(find.textContaining('I built this Flutter app'), findsOneWidget);
  });

  testWidgets('opens privacy and terms from About', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.byTooltip('About'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Privacy Policy'));
    await tester.pumpAndSettle();
    expect(find.text('Data in the app'), findsOneWidget);
    expect(find.textContaining('tedroszion@gmail.com'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terms of Use'));
    await tester.pumpAndSettle();
    expect(find.text('Content and rights'), findsOneWidget);
  });

  testWidgets('switches the theme', (tester) async {
    await tester.pumpWidget(app());
    final startsLight = find.byIcon(Icons.dark_mode).evaluate().isNotEmpty;
    await tester.tap(find.byTooltip('Toggle Day/Night Mode'));
    await tester.pumpAndSettle();

    expect(find.byIcon(startsLight ? Icons.light_mode : Icons.dark_mode),
        findsOneWidget);
  });

  testWidgets('opens follow-along for both prayers', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Listen'));
    await tester.pumpAndSettle();

    expect(find.text('Listen and follow'), findsOneWidget);
    expect(find.text('LINE 1 OF 20'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -250));
    await tester.pumpAndSettle();
    expect(find.text('Adjust timing'), findsOneWidget);
  });

  testWidgets('opens the Sibhat recording and text', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Listen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sibhat'));
    await tester.pumpAndSettle();

    expect(find.text('Listen and read'), findsOneWidget);
    expect(find.text('LINE 1 OF 33'), findsOneWidget);
    expect(find.textContaining('ስብሐት ለአብ'), findsWidgets);
  });

  testWidgets('practice hides, reveals, and tracks a line', (tester) async {
    await tester.pumpWidget(app());
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

    await tester.drag(find.byType(ListView), const Offset(0, -200));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Line 2 of 11'), findsOneWidget);
    expect(find.text('Recite from memory'), findsOneWidget);
  });
}

class _MemoryCueStore implements CueStore {
  List<int>? _saved;

  @override
  Future<List<int>?> load() async => _saved;

  @override
  Future<void> save(List<int> milliseconds) async {
    _saved = List.of(milliseconds);
  }

  @override
  Future<void> clear() async {
    _saved = null;
  }
}
