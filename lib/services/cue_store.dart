import 'package:shared_preferences/shared_preferences.dart';

import '../data/audio_cues.dart';

abstract interface class CueStore {
  Future<List<int>?> load();
  Future<void> save(List<int> milliseconds);
  Future<void> clear();
}

class LocalCueStore implements CueStore {
  LocalCueStore() : _prefs = SharedPreferencesAsync();

  static const _key = 'prayer_audio_cues_v2';
  final SharedPreferencesAsync _prefs;

  @override
  Future<List<int>?> load() async {
    final stored = await _prefs.getStringList(_key);
    if (stored == null) return null;
    final starts = stored.map(int.tryParse).toList();
    if (starts.any((value) => value == null)) return null;
    final parsed = starts.cast<int>();
    return validCueStarts(parsed) ? parsed : null;
  }

  @override
  Future<void> save(List<int> milliseconds) async {
    if (!validCueStarts(milliseconds)) {
      throw ArgumentError('Invalid audio cue timings.');
    }
    await _prefs.setStringList(
      _key,
      milliseconds.map((value) => value.toString()).toList(),
    );
  }

  @override
  Future<void> clear() => _prefs.remove(_key);
}
