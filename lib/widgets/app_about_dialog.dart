import 'package:flutter/material.dart';

import '../data/legal_text.dart';
import '../screens/legal_page.dart';
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
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'I built this Flutter app to make Geʽez prayers easier to read, '
            'listen to, and memorise, one line at a time.',
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const LegalPage(
                title: 'Privacy Policy',
                sections: privacySections,
              ),
            )),
            icon: const Icon(Icons.privacy_tip_outlined),
            label: const Text('Privacy Policy'),
          ),
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const LegalPage(
                title: 'Terms of Use',
                sections: termsSections,
              ),
            )),
            icon: const Icon(Icons.description_outlined),
            label: const Text('Terms of Use'),
          ),
        ],
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
