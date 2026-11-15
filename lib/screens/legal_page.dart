import 'package:flutter/material.dart';

import '../data/legal_text.dart';

class LegalPage extends StatelessWidget {
  const LegalPage({required this.title, required this.sections, super.key});

  final String title;
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          for (final section in sections) ...[
            Text(section.heading,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    )),
            const SizedBox(height: 6),
            Text(section.body, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}
