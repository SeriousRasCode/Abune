import 'package:shared_preferences/shared_preferences.dart';

import '../data/audio_cues.dart';

abstract interface class CueStore {
  Future<List<int>?> load();
  Future<void> save(List<int> milliseconds);
  Future<void> clear();
}

class LocalCueStore implements CueStore {
  LocalCueStore({String key = 'prayer_audio_cues_v3', int? lineCount})
      : _key = key,
        _lineCount = lineCount ?? recordedLines.length,
        _prefs = SharedPreferencesAsync();

  final String _key;
  final int _lineCount;
  final SharedPreferencesAsync _prefs;

  @override
  Future<List<int>?> load() async {
    final stored = await _prefs.getStringList(_key);
    if (stored == null) return null;
    final starts = stored.map(int.tryParse).toList();
    if (starts.any((value) => value == null)) return null;
    final parsed = starts.cast<int>();
    return validCueStarts(parsed, lineCount: _lineCount) ? parsed : null;
  }

  @override
  Future<void> save(List<int> milliseconds) async {
    if (!validCueStarts(milliseconds, lineCount: _lineCount)) {
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
