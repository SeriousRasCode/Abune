import 'audio_cues.dart';
import 'sibhat_prayer.dart';

// The opening praise is spoken three times, then the prayer continues in order.
final sibhatRecordedLines = <RecordedLine>[
  for (var repeat = 0; repeat < 3; repeat++)
    RecordedLine('ስብሐት ለአብ', sibhatPrayerLines.first),
  for (final line in sibhatPrayerLines.skip(1))
    RecordedLine('ስብሐት ለአብ', line),
];

// Starts from MMS forced alignment of the bundled recording, reviewed against
// its silence boundaries. Source: PR #14 audio-align job, run 44368117258.
const sibhatCueMilliseconds = <int>[
  1880, 10220, 17620, 21640, 25200, 28460, 32520, 35900, 40280,
  43310, 43990, 46910, 47430, 49710, 50890, 53770, 54290, 58630,
  59710, 62390, 63030, 65350, 67750, 70450, 72190, 75270, 77290,
  80890, 82630, 85870, 87870, 91890, 93670, 98230, 104450,
];
