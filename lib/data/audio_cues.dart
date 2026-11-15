import 'prayers.dart';

final recordedLines = [
  for (final section in prayerSections)
    for (final line in section.lines)
      RecordedLine(section.title, line),
];

class RecordedLine {
  const RecordedLine(this.sectionTitle, this.text);

  final String sectionTitle;
  final String text;
}

// Approximate starts for the bundled 78-second recording. Listeners can
// replace these with their own measured starts using the in-app sync tool.
const defaultCueMilliseconds = <int>[
  0,
  3700,
  7400,
  11100,
  14800,
  18500,
  22200,
  25900,
  29600,
  33300,
  37000,
  40700,
  44400,
  48100,
  51800,
  55500,
  59200,
  62900,
  66600,
  70300,
  74000,
];

int cueIndexAt(int positionMilliseconds, List<int> starts) {
  if (starts.length != recordedLines.length) {
    throw ArgumentError('Cue count must match the recorded prayer lines.');
  }
  for (var index = starts.length - 1; index > 0; index--) {
    if (positionMilliseconds >= starts[index]) return index;
  }
  return 0;
}

bool validCueStarts(List<int> starts) {
  if (starts.length != recordedLines.length || starts.first < 0) {
    return false;
  }
  for (var index = 1; index < starts.length; index++) {
    if (starts[index] <= starts[index - 1]) return false;
  }
  return true;
}
