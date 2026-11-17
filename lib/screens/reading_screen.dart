import 'package:flutter/material.dart';

import '../data/prayers.dart';
import '../theme/app_theme.dart';

class ReadingScreen extends StatelessWidget {
  const ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      children: [
        Text('READ',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.secondary,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                )),
        const SizedBox(height: 8),
        Text('Prayers in Geʽez',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text('Read the prayers. Use Listen to follow the recordings, or Practice to memorise each line.',
            style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 20),
        for (final section in prayerSections) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppTheme.gold,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(section.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: scheme.secondary,
                            fontFamily: 'MyCustomFont',
                          )),
                  const SizedBox(height: 16),
                  for (final line in section.lines)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(line,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontFamily: 'MyCustomFont',
                                height: 1.65,
                              )),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}
