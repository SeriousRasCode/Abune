import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerBar extends StatefulWidget {
  const AudioPlayerBar({required this.player, super.key});

  final AudioPlayer player;

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
        return Material(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.graphic_eq, size: 20),
                    const SizedBox(width: 8),
                    const Expanded(child: Text('Prayer recording')),
                    IconButton(
                      tooltip: playing ? 'Pause audio' : 'Play audio',
                      onPressed: ready
                          ? () async {
                              if (playing) {
                                await widget.player.pause();
                              } else {
                                if (complete) await widget.player.seek(Duration.zero);
                                await widget.player.play();
                              }
                            }
                          : null,
                      icon: Icon(playing ? Icons.pause_circle : Icons.play_circle),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(_time(position)),
                    Expanded(
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
                    ),
                    Text(_time(duration)),
                  ],
                ),
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
