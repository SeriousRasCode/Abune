import 'prayers.dart';

final recordedLines = [
  // The printed opening invocation is not spoken in this recording.
  for (final line in prayerSections.first.lines.skip(1))
    RecordedLine(prayerSections.first.title, line),
  for (final line in prayerSections[1].lines)
    RecordedLine(prayerSections[1].title, line),
];

class RecordedLine {
  const RecordedLine(this.sectionTitle, this.text);

  final String sectionTitle;
  final String text;
}

// Audio-derived starts from the bundled recording, reviewed against the pause
// and transcription output of GitHub Actions run 43744881189. The two short
// combined phrases at 58.98s and 70.68s use their nearest pause boundary.
const defaultCueMilliseconds = <int>[
  880,
  4800,
  8540,
  12560,
  17760,
  21100,
  26200,
  30060,
  34620,
  37720,
  41180,
  44280,
  48700,
  52640,
  56500,
  58980,
  61540,
  65820,
  70680,
  74940,
];

int cueIndexAt(int positionMilliseconds, List<int> starts, {int? lineCount}) {
  if (starts.length != (lineCount ?? recordedLines.length)) {
    throw ArgumentError('Cue count must match the recorded prayer lines.');
  }
  for (var index = starts.length - 1; index > 0; index--) {
    if (positionMilliseconds >= starts[index]) return index;
  }
  return 0;
}

bool validCueStarts(List<int> starts, {int? lineCount}) {
  if (starts.length != (lineCount ?? recordedLines.length) || starts.isEmpty || starts.first < 0) {
    return false;
  }
  for (var index = 1; index < starts.length; index++) {
    if (starts[index] <= starts[index - 1]) return false;
  }
  return true;
}
