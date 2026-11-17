import 'package:shared_preferences/shared_preferences.dart';

class StudyProgress {
  const StudyProgress(this.learned, this.section, this.line);

  final Set<String> learned;
  final int section;
  final int line;
}

class StudyStore {
  StudyStore() : _prefs = SharedPreferencesAsync();

  final SharedPreferencesAsync _prefs;
  Future<void> _pendingSave = Future<void>.value();

  Future<StudyProgress> load() async {
    final learned = await _prefs.getStringList('study_learned_v1') ?? [];
    final section = await _prefs.getInt('study_section_v1') ?? 0;
    final line = await _prefs.getInt('study_line_v1') ?? 0;
    return StudyProgress(learned.toSet(), section, line);
  }

  Future<void> save(Set<String> learned, int section, int line) {
    final snapshot = learned.toList();
    _pendingSave = _pendingSave.catchError((Object _) {}).then((_) async {
      await _prefs.setStringList('study_learned_v1', snapshot);
      await _prefs.setInt('study_section_v1', section);
      await _prefs.setInt('study_line_v1', line);
    });
    return _pendingSave;
  }
}
