import 'package:flutter/material.dart';

import '../data/sibhat_prayer.dart';

class SibhatListenScreen extends StatefulWidget {
  const SibhatListenScreen({super.key});

  @override
  State<SibhatListenScreen> createState() => _SibhatListenScreenState();
}

class _SibhatListenScreenState extends State<SibhatListenScreen> {
  int _line = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('SIBHAT TSELOT',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.secondary,
                  letterSpacing: 1.4,
                  fontWeight: FontWeight.bold,
                )),
        const SizedBox(height: 6),
        Text('Listen and read', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 4),
        const Text('Follow the recording at your own pace. The opening praise is repeated three times.'),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('LINE ${_line + 1} OF ${sibhatPrayerLines.length}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(color: scheme.secondary)),
                const SizedBox(height: 10),
                LinearProgressIndicator(value: (_line + 1) / sibhatPrayerLines.length),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 140),
                  child: Center(
                    child: Text(sibhatPrayerLines[_line],
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontFamily: 'MyCustomFont',
                              height: 1.6,
                            )),
                  ),
                ),
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _line == 0 ? null : () => setState(() => _line--),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _line == sibhatPrayerLines.length - 1
                          ? null
                          : () => setState(() => _line++),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text('Use the audio controls below to play or seek.',
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
