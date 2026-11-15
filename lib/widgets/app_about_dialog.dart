import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppAboutDialog extends StatelessWidget {
  const AppAboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.navy,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.menu_book, color: AppTheme.gold),
          ),
          const SizedBox(height: 18),
          Text('አቡነ ዘበሰማያት',
              style: theme.textTheme.titleLarge?.copyWith(
                fontFamily: 'MyCustomFont',
              )),
          const SizedBox(height: 5),
          Text('Created by Tedros Teshome',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.secondary,
              )),
        ],
      ),
      content: const Text(
        'I built this Flutter app to make Geʽez prayers easier to read, '
        'listen to, and memorise, one line at a time.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
