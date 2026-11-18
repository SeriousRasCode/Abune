import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../data/audio_cues.dart';
import '../data/sibhat_audio_cues.dart';
import '../services/cue_store.dart';
import '../widgets/tewahedo_pattern.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({required this.themeMode, required this.onThemeChanged,
    required this.abunePlayer, required this.sibhatPlayer,
    required this.onTimingChanged, this.abuneCueStore, super.key});

  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final AudioPlayer abunePlayer;
  final AudioPlayer sibhatPlayer;
  final VoidCallback onTimingChanged;
  final CueStore? abuneCueStore;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(padding: const EdgeInsets.all(14), children: [
      const TewahedoPattern(height: 16),
      const SizedBox(height: 9),
      Text('Settings', style: Theme.of(context).textTheme.headlineSmall),
      const SizedBox(height: 12),
      Card(child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Appearance', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('Choose a reading theme. Your choice is saved.',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 10),
          Wrap(spacing: 6, children: [
            for (final mode in ThemeMode.values)
              ChoiceChip(
                label: Text(switch (mode) {
                  ThemeMode.system => 'System',
                  ThemeMode.light => 'Day',
                  ThemeMode.dark => 'Night',
                }),
                selected: themeMode == mode,
                onSelected: (_) => onThemeChanged(mode),
              ),
          ]),
        ]),
      )),
      const SizedBox(height: 10),
      Card(child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Audio timing', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text('The lines follow the recordings automatically. Fine-tune a line here if needed.',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.graphic_eq, color: scheme.secondary),
            title: const Text('Abune & Gebriel'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => TimingEditorScreen(
                title: 'Abune & Gebriel', player: abunePlayer,
                lines: recordedLines, defaults: defaultCueMilliseconds,
                store: abuneCueStore ?? LocalCueStore(), onChanged: onTimingChanged,
              ),
            )),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.graphic_eq, color: scheme.secondary),
            title: const Text('Sibhat Tselot'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => TimingEditorScreen(
                title: 'Sibhat Tselot', player: sibhatPlayer,
                lines: sibhatRecordedLines, defaults: sibhatCueMilliseconds,
                store: LocalCueStore(key: 'sibhat_audio_cues_v1', lineCount: sibhatRecordedLines.length),
                onChanged: onTimingChanged,
              ),
            )),
          ),
        ]),
      )),
    ]);
  }
}

class TimingEditorScreen extends StatefulWidget {
  const TimingEditorScreen({required this.title, required this.player,
    required this.lines, required this.defaults, required this.store,
    required this.onChanged, super.key});

  final String title;
  final AudioPlayer player;
  final List<RecordedLine> lines;
  final List<int> defaults;
  final CueStore store;
  final VoidCallback onChanged;

  @override
  State<TimingEditorScreen> createState() => _TimingEditorScreenState();
}

class _TimingEditorScreenState extends State<TimingEditorScreen> {
  late List<int> _starts;
  int _selected = 0;

  @override
  void initState() {
    super.initState();
    _starts = List.of(widget.defaults);
    _load();
  }

  Future<void> _load() async {
    final saved = await widget.store.load();
    if (mounted && saved != null) setState(() => _starts = saved);
  }

  Future<void> _save() async {
    await widget.store.save(_starts);
    if (!mounted) return;
    widget.onChanged();
  }

  Future<void> _reset() async {
    await widget.store.clear();
    if (!mounted) return;
    setState(() => _starts = List.of(widget.defaults));
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final baseline = widget.defaults[_selected];
    final lower = _selected == 0 ? 0 : _starts[_selected - 1] + 100;
    final upper = _selected == _starts.length - 1
        ? (widget.player.duration?.inMilliseconds ?? baseline + 3000)
        : _starts[_selected + 1] - 100;
    final min = (baseline - 3000).clamp(lower, upper).toDouble();
    final max = (baseline + 3000).clamp(lower, upper).toDouble();
    final value = _starts[_selected].toDouble().clamp(min, max);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text('Adjust line timing', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('Choose a line, preview it, then move its start slightly if the highlight is early or late.'),
        const SizedBox(height: 14),
        DropdownButtonFormField<int>(
          value: _selected,
          decoration: const InputDecoration(labelText: 'Prayer line', border: OutlineInputBorder()),
          items: [for (var i = 0; i < widget.lines.length; i++)
            DropdownMenuItem(value: i, child: Text('Line ${i + 1}'))],
          onChanged: (value) { if (value != null) setState(() => _selected = value); },
        ),
        const SizedBox(height: 14),
        Card(child: Padding(padding: const EdgeInsets.all(16),
          child: Text(widget.lines[_selected].text, textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontFamily: 'MyCustomFont', height: 1.5)))),
        const SizedBox(height: 8),
        Text('Start: ${(value / 1000).toStringAsFixed(2)} s', textAlign: TextAlign.center),
        Slider(value: value, min: min, max: max,
          onChanged: min == max ? null : (next) => setState(() => _starts[_selected] = next.round()),
          onChangeEnd: min == max ? null : (_) => _save()),
        OutlinedButton.icon(
          onPressed: () async {
            await widget.player.seek(Duration(milliseconds: _starts[_selected]));
            widget.player.play();
          },
          icon: const Icon(Icons.play_arrow), label: const Text('Preview from this line')),
        TextButton(onPressed: _reset, child: const Text('Restore original timing')),
      ]),
    );
  }
}
