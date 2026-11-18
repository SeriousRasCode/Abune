import 'package:abune/data/audio_cues.dart';
import 'package:abune/data/prayers.dart';
import 'package:abune/data/sibhat_audio_cues.dart';
import 'package:abune/data/sibhat_prayer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the recording covers both prayer sections', () {
    expect(recordedLines.length,
        prayerSections.first.lines.length - 1 + prayerSections[1].lines.length);
    expect(defaultCueMilliseconds.length, recordedLines.length);
    expect(validCueStarts(defaultCueMilliseconds), isTrue);
    expect(recordedLines.first.text, prayerSections.first.lines[1]);
    expect(recordedLines.last.text, prayerSections[1].lines.last);
  });

  test('line selection changes at cue boundaries', () {
    expect(cueIndexAt(0, defaultCueMilliseconds), 0);
    expect(cueIndexAt(defaultCueMilliseconds[1] - 1, defaultCueMilliseconds), 0);
    expect(cueIndexAt(defaultCueMilliseconds[1], defaultCueMilliseconds), 1);
    expect(cueIndexAt(defaultCueMilliseconds.last + 1000, defaultCueMilliseconds),
        recordedLines.length - 1);
  });

  test('Sibhat cues follow the full recording with three opening repetitions', () {
    expect(sibhatRecordedLines.length, sibhatPrayerLines.length + 2);
    expect(sibhatCueMilliseconds.length, sibhatRecordedLines.length);
    expect(validCueStarts(sibhatCueMilliseconds,
        lineCount: sibhatRecordedLines.length), isTrue);
    expect(sibhatRecordedLines[0].text, sibhatPrayerLines.first);
    expect(sibhatRecordedLines[2].text, sibhatPrayerLines.first);
    expect(sibhatRecordedLines.last.text, sibhatPrayerLines.last);
    expect(cueIndexAt(60000, sibhatCueMilliseconds,
        lineCount: sibhatRecordedLines.length), 18);
  });
}
