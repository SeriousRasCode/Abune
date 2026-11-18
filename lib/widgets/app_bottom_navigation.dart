import 'package:flutter/material.dart';

import 'tewahedo_pattern.dart';

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({required this.selectedIndex, required this.onSelected, super.key});

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = <(IconData, String)>[
    (Icons.menu_book_rounded, 'Read'),
    (Icons.hearing_rounded, 'Listen'),
    (Icons.school_rounded, 'Practice'),
    (Icons.tune_rounded, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      child: SafeArea(
        top: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const TewahedoPattern(height: 12),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 3, 8, 5),
            child: Row(children: [
              for (var index = 0; index < _items.length; index++)
                Expanded(
                  child: Semantics(
                    selected: index == selectedIndex,
                    button: true,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => onSelected(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        constraints: const BoxConstraints(minHeight: 52),
                        decoration: BoxDecoration(
                          color: index == selectedIndex ? scheme.primaryContainer : null,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(_items[index].$1,
                              size: 21,
                              color: index == selectedIndex ? scheme.onPrimaryContainer : scheme.onSurfaceVariant),
                          const SizedBox(height: 2),
                          Text(_items[index].$2,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: index == selectedIndex ? FontWeight.w700 : FontWeight.w500,
                                    color: index == selectedIndex ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
                                  )),
                        ]),
                      ),
                    ),
                  ),
                ),
            ]),
          ),
        ]),
      ),
    );
  }
}
