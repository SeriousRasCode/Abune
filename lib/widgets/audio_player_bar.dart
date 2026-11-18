import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerBar extends StatefulWidget {
  const AudioPlayerBar({required this.player, this.title = 'Prayer audio', super.key});

  final AudioPlayer player;
  final String title;

  @override
  State<AudioPlayerBar> createState() => _AudioPlayerBarState();
}

class _AudioPlayerBarState extends State<AudioPlayerBar> {
  late final Stream<_AudioPosition> _positionStream;

  @override
  void initState() {
    super.initState();
    _positionStream =
        Rx.combineLatest3<Duration, Duration?, PlayerState, _AudioPosition>(
      widget.player.positionStream,
      widget.player.durationStream,
      widget.player.playerStateStream,
      (position, duration, state) =>
          _AudioPosition(position, duration ?? Duration.zero, state),
    );
  }

  String _time(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_AudioPosition>(
      stream: _positionStream,
      builder: (context, snapshot) {
        final data = snapshot.data;
        final duration = data?.duration ?? Duration.zero;
        final position = data?.position ?? Duration.zero;
        final ready = duration > Duration.zero;
        final playing = data?.state.playing ?? false;
        final complete = data?.state.processingState == ProcessingState.completed;
        final scheme = Theme.of(context).colorScheme;
        return Material(
          color: scheme.surface,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: scheme.primary, borderRadius: BorderRadius.circular(14)),
                      child: IconButton(
                        tooltip: playing ? 'Pause audio' : 'Play audio',
                        color: scheme.onPrimary,
                        onPressed: ready ? () async {
                          if (playing) {
                            await widget.player.pause();
                          } else {
                            if (complete) await widget.player.seek(Duration.zero);
                            unawaited(widget.player.play());
                          }
                        } : null,
                        icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(widget.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)),
                      Text('${_time(position)} / ${_time(duration)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                    ])),
                    const Icon(Icons.graphic_eq_rounded, size: 20),
                  ],
                ),
                SizedBox(height: 32, child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(trackHeight: 3, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6)),
                  child: Slider(
                        min: 0,
                        max: ready ? duration.inMilliseconds.toDouble() : 1,
                        value: ready
                            ? position.inMilliseconds.toDouble().clamp(
                                  0, duration.inMilliseconds.toDouble())
                            : 0,
                        onChanged: ready
                            ? (value) => widget.player
                                .seek(Duration(milliseconds: value.round()))
                            : null,
                  ),
                )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AudioPosition {
  const _AudioPosition(this.position, this.duration, this.state);

  final Duration position;
  final Duration duration;
  final PlayerState state;
}
