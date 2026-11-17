import 'package:abune/services/study_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  setUp(() {
    SharedPreferencesAsyncPlatform.instance = InMemorySharedPreferencesAsync.empty();
  });

  test('learned lines and study position survive a new store instance', () async {
    final first = StudyStore();
    await first.save({'0:1', '2:4'}, 2, 4);

    final restored = await StudyStore().load();
    expect(restored.learned, {'0:1', '2:4'});
    expect(restored.section, 2);
    expect(restored.line, 4);
  });
}
