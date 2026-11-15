import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../data/audio_cues.dart';
import '../data/prayers.dart';
import '../services/cue_store.dart';

class FollowAlongScreen extends StatefulWidget {
  const FollowAlongScreen({required this.player, this.cueStore, super.key});

  final AudioPlayer player;
  final CueStore? cueStore;

  @override
  State<FollowAlongScreen> createState() => _FollowAlongScreenState();
}

class _FollowAlongScreenState extends State<FollowAlongScreen> {
  late final CueStore _store;
  List<int> _starts = List.of(defaultCueMilliseconds);
  final List<int> _markedStarts = [];
  bool _customTiming = false;
  bool _settingTiming = false;

  @override
  void initState() {
    super.initState();
    _store = widget.cueStore ?? LocalCueStore();
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
    if (_markedStarts.length + 1 == recordedLines.length) {
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
        _starts = List.of(defaultCueMilliseconds);
        _customTiming = false;
        _settingTiming = false;
      });
      _message('Using estimated timing again.');
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
        final active = cueIndexAt(position.inMilliseconds, _starts);
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
            const Text('Follow both prayers as the recording plays.'),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _settingTiming
                          ? 'SET TIMING • LINE ${target + 1} OF ${recordedLines.length}'
                          : 'LINE ${active + 1} OF ${recordedLines.length}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: scheme.secondary,
                            letterSpacing: 0.8,
                          ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _settingTiming
                          ? recordedLines[target].sectionTitle
                          : recordedLines[active].sectionTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: scheme.secondary,
                            fontFamily: 'MyCustomFont',
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _settingTiming
                          ? recordedLines[target].text
                          : recordedLines[active].text,
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
                    ? 'Timing saved on this device'
                    : 'Timing is estimated. Set it once for a closer match.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _beginTiming,
                    icon: const Icon(Icons.tune),
                    label: Text(_customTiming ? 'Set timing again' : 'Set timing'),
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
              for (var index = 0; index < recordedLines.length; index++)
                Card(
                  color: index == active ? scheme.primaryContainer : null,
                  child: ListTile(
                    title: Text(recordedLines[index].text,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontFamily: 'MyCustomFont',
                              height: 1.5,
                            )),
                    leading: Text('${index + 1}',
                        style: Theme.of(context).textTheme.labelLarge),
                    subtitle: index == 0 || index == prayerSections.first.lines.length
                        ? Text(recordedLines[index].sectionTitle)
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
