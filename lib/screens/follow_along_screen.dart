import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../data/audio_cues.dart';
import '../services/cue_store.dart';
import '../widgets/tewahedo_pattern.dart';

class FollowAlongScreen extends StatefulWidget {
  const FollowAlongScreen({required this.player, this.cueStore, this.lines, this.cues,
    this.title = 'Abune & Gebriel', this.cueKey = 'prayer_audio_cues_v3',
    this.reloadToken = 0, super.key});

  final AudioPlayer player;
  final CueStore? cueStore;
  final List<RecordedLine>? lines;
  final List<int>? cues;
  final String title;
  final String cueKey;
  final int reloadToken;

  @override
  State<FollowAlongScreen> createState() => _FollowAlongScreenState();
}

class _FollowAlongScreenState extends State<FollowAlongScreen> {
  List<RecordedLine> get _lines => widget.lines ?? recordedLines;
  List<int> get _defaults => widget.cues ?? defaultCueMilliseconds;
  late final CueStore _store;
  late List<int> _starts;

  @override
  void initState() {
    super.initState();
    _starts = List.of(_defaults);
    _store = widget.cueStore ?? LocalCueStore(key: widget.cueKey, lineCount: _lines.length);
    _loadTiming();
  }

  @override
  void didUpdateWidget(covariant FollowAlongScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reloadToken != widget.reloadToken) _loadTiming();
  }

  Future<void> _loadTiming() async {
    try {
      final saved = await _store.load();
      if (mounted) setState(() => _starts = saved ?? List.of(_defaults));
    } catch (_) {
      if (mounted) setState(() => _starts = List.of(_defaults));
    }
  }

  Future<void> _playFrom(int index) async {
    await widget.player.seek(Duration(milliseconds: _starts[index]));
    unawaited(widget.player.play());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return StreamBuilder<Duration>(
      stream: widget.player.positionStream,
      builder: (context, snapshot) {
        final active = cueIndexAt((snapshot.data ?? Duration.zero).inMilliseconds,
            _starts, lineCount: _lines.length);
        return Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const TewahedoPattern(height: 14),
              const SizedBox(height: 7),
              Row(children: [
                Expanded(child: Text('Listen and follow',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700))),
                Text('${active + 1}/${_lines.length}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: scheme.secondary)),
              ]),
              Text(widget.title, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: (active + 1) / _lines.length, minHeight: 3),
              const SizedBox(height: 9),
              Card(
                margin: EdgeInsets.zero,
                color: scheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    Text('LINE ${active + 1} OF ${_lines.length}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: scheme.onPrimaryContainer, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    Text(_lines[active].text, textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontFamily: 'MyCustomFont', height: 1.4,
                              color: scheme.onPrimaryContainer)),
                    Align(alignment: Alignment.centerRight,
                      child: TextButton.icon(onPressed: () => _playFrom(active),
                        icon: const Icon(Icons.replay_rounded, size: 18),
                        label: const Text('Repeat line'))),
                  ]),
                ),
              ),
            ]),
          ),
          Expanded(child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            itemCount: _lines.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Material(
                color: index == active ? scheme.secondaryContainer : scheme.surface,
                borderRadius: BorderRadius.circular(12),
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  leading: CircleAvatar(radius: 14,
                    backgroundColor: index == active ? scheme.secondary : scheme.surfaceContainerHighest,
                    child: Text('${index + 1}', style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: index == active ? scheme.onSecondary : scheme.onSurface))),
                  title: Text(_lines[index].text, maxLines: 2, overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'MyCustomFont', height: 1.35,
                      fontWeight: index == active ? FontWeight.w700 : null)),
                  onTap: () => _playFrom(index),
                ),
              ),
            ),
          )),
        ]);
      },
    );
  }
}
