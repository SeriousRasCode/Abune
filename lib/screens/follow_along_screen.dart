import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../data/audio_cues.dart';
import '../data/prayers.dart';
import '../services/cue_store.dart';

class FollowAlongScreen extends StatefulWidget {
  const FollowAlongScreen({
    required this.player,
    this.cueStore,
    this.lines,
    this.cues,
    this.description = 'Follow the spoken lines in both prayers. The opening invocation is in Read.',
    this.cueKey = 'prayer_audio_cues_v3',
    super.key,
  });

  final AudioPlayer player;
  final CueStore? cueStore;
  final List<RecordedLine>? lines;
  final List<int>? cues;
  final String description;
  final String cueKey;

  @override
  State<FollowAlongScreen> createState() => _FollowAlongScreenState();
}

class _FollowAlongScreenState extends State<FollowAlongScreen> {
  List<RecordedLine> get _lines => widget.lines ?? recordedLines;
  List<int> get _cues => widget.cues ?? defaultCueMilliseconds;
  late final CueStore _store;
  late List<int> _starts;
  final List<int> _markedStarts = [];
  bool _customTiming = false;
  bool _settingTiming = false;

  @override
  void initState() {
    super.initState();
    _starts = List.of(_cues);
    _store = widget.cueStore ?? LocalCueStore(key: widget.cueKey, lineCount: _lines.length);
    _loadSavedTiming();
  }

  Future<void> _loadSavedTiming() async {
    try {
      final saved = await _store.load();
      if (mounted && saved != null) {
        setState(() {
          _starts = saved;
          _customTiming = true;
        });
      }
    } catch (_) {
      // Estimated timing remains available if local storage cannot be read.
    }
  }

  Future<void> _beginTiming() async {
    if (widget.player.duration == null) {
      _message('Wait for the recording to load.');
      return;
    }
    await widget.player.seek(Duration.zero);
    if (!mounted) return;
    setState(() {
      _markedStarts.clear();
      _settingTiming = true;
    });
    unawaited(widget.player.play());
  }

  Future<void> _markLine() async {
    final position = widget.player.position.inMilliseconds;
    if (_markedStarts.isNotEmpty && position <= _markedStarts.last) {
      _message('Wait until the next line starts.');
      return;
    }
    if (_markedStarts.length + 1 == _lines.length) {
      final starts = [..._markedStarts, position];
      try {
        await _store.save(starts);
        if (!mounted) return;
        setState(() {
          _markedStarts.add(position);
          _starts = starts;
          _customTiming = true;
          _settingTiming = false;
        });
        _message('Line timing saved on this device.');
      } catch (_) {
        if (!mounted) return;
        setState(() => _settingTiming = false);
        _message('Could not save line timing.');
      }
    } else {
      setState(() => _markedStarts.add(position));
    }
  }

  Future<void> _resetTiming() async {
    try {
      await _store.clear();
      if (!mounted) return;
      setState(() {
        _starts = List.of(_cues);
        _customTiming = false;
        _settingTiming = false;
      });
      _message('Using the recording timing again.');
    } catch (_) {
      _message('Could not reset line timing.');
    }
  }

  void _message(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return StreamBuilder<Duration>(
      stream: widget.player.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final active = cueIndexAt(position.inMilliseconds, _starts, lineCount: _lines.length);
        final target = _markedStarts.length;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
          children: [
            Text('LISTEN',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: scheme.secondary,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 8),
            Text('Listen and follow',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(widget.description),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _settingTiming
                          ? 'SET TIMING • LINE ${target + 1} OF ${_lines.length}'
                          : 'LINE ${active + 1} OF ${_lines.length}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: scheme.secondary,
                            letterSpacing: 0.8,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _settingTiming
                          ? _lines[target].sectionTitle
                          : _lines[active].sectionTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: scheme.secondary,
                            fontFamily: 'MyCustomFont',
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _settingTiming
                          ? _lines[target].text
                          : _lines[active].text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontFamily: 'MyCustomFont',
                            height: 1.55,
                          ),
                    ),
                    const SizedBox(height: 18),
                    if (_settingTiming) ...[
                      const Text('Tap when you hear this line begin.'),
                      const SizedBox(height: 10),
                      FilledButton.icon(
                        onPressed: _markLine,
                        icon: const Icon(Icons.touch_app),
                        label: Text('Mark line ${target + 1}'),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _settingTiming = false),
                        child: const Text('Cancel'),
                      ),
                    ] else ...[
                      FilledButton.icon(
                        onPressed: widget.player.duration == null
                            ? null
                            : () async {
                                if (widget.player.playing) {
                                  await widget.player.pause();
                                } else {
                                  if (widget.player.processingState ==
                                      ProcessingState.completed) {
                                    await widget.player.seek(Duration.zero);
                                  }
                                  unawaited(widget.player.play());
                                }
                              },
                        icon: Icon(widget.player.playing
                            ? Icons.pause
                            : Icons.play_arrow),
                        label: Text(widget.player.playing ? 'Pause' : 'Play prayer'),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            if (!_settingTiming) ...[
              Text(
                _customTiming
                    ? 'Your timing is saved on this device.'
                    : 'Line timing follows this recording. Adjust it if a line appears late or early.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _beginTiming,
                    icon: const Icon(Icons.tune),
                    label: Text(_customTiming ? 'Adjust timing again' : 'Adjust timing'),
                  ),
                  if (_customTiming)
                    TextButton(
                      onPressed: _resetTiming,
                      child: const Text('Reset timing'),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Tap a line to play from there.',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              for (var index = 0; index < _lines.length; index++)
                Card(
                  color: index == active ? scheme.primaryContainer : null,
                  child: ListTile(
                    title: Text(_lines[index].text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontFamily: 'MyCustomFont',
                              height: 1.5,
                            )),
                    leading: Text('${index + 1}',
                        style: Theme.of(context).textTheme.labelLarge),
                    subtitle: index == 0 ||
                            index == prayerSections.first.lines.length - 1
                        ? Text(_lines[index].sectionTitle)
                        : null,
                    onTap: () => widget.player.seek(
                      Duration(milliseconds: _starts[index]),
                    ),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}
