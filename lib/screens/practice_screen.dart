import 'dart:async';

import 'package:flutter/material.dart';

import '../data/prayers.dart';
import '../services/study_store.dart';

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  int _sectionIndex = 0;
  int _lineIndex = 0;
  bool _revealed = true;
  final Set<String> _learned = {};
  final StudyStore _store = StudyStore();

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    StudyProgress saved;
    try {
      saved = await _store.load();
    } catch (_) {
      return;
    }
    if (!mounted) return;
    final section = saved.section.clamp(0, prayerSections.length - 1);
    setState(() {
      _learned.addAll(saved.learned);
      _sectionIndex = section;
      _lineIndex = saved.line.clamp(0, prayerSections[section].lines.length - 1);
    });
  }

  void _saveProgress() {
    unawaited(_store.save(_learned, _sectionIndex, _lineIndex).catchError((Object _) {}));
  }

  String get _key => '$_sectionIndex:$_lineIndex';

  void _chooseSection(int index) => setState(() {
        _sectionIndex = index;
        _lineIndex = 0;
        _revealed = true;
        _saveProgress();
      });

  void _move(int direction) => setState(() {
        _lineIndex += direction;
        _revealed = false;
        _saveProgress();
      });

  @override
  Widget build(BuildContext context) {
    final section = prayerSections[_sectionIndex];
    final scheme = Theme.of(context).colorScheme;
    final count = section.lines.length;
    final learnedCount = List.generate(count, (index) => '$_sectionIndex:$index')
        .where(_learned.contains)
        .length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
      children: [
        Text('PRACTICE',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: scheme.secondary,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                )),
        const SizedBox(height: 8),
        Text('Learn each line',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 6),
        const Text('Read, recall, then reveal. Your place and learned lines are saved.'),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          children: [
            for (var index = 0; index < prayerSections.length; index++)
              ChoiceChip(
                label: Text(prayerSections[index].shortTitle),
                selected: index == _sectionIndex,
                onSelected: (_) => _chooseSection(index),
              ),
          ],
        ),
        const SizedBox(height: 18),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(section.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: scheme.secondary,
                          fontFamily: 'MyCustomFont',
                        )),
                const SizedBox(height: 16),
                Text('Line ${_lineIndex + 1} of $count',
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: (_lineIndex + 1) / count),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 124),
                  child: Center(
                    child: Text(
                      _revealed ? section.lines[_lineIndex] : 'Recite from memory',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontFamily: _revealed ? 'MyCustomFont' : null,
                            height: 1.55,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => setState(() => _revealed = !_revealed),
                  icon: Icon(_revealed ? Icons.visibility_off : Icons.visibility),
                  label: Text(_revealed ? 'Hide line' : 'Reveal line'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => setState(() {
                    if (!_learned.add(_key)) _learned.remove(_key);
                    _saveProgress();
                  }),
                  icon: Icon(_learned.contains(_key)
                      ? Icons.check_circle
                      : Icons.check_circle_outline),
                  label: Text(_learned.contains(_key)
                      ? 'Marked as learned'
                      : 'Mark as learned'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Text('$learnedCount of $count lines marked as learned'),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: learnedCount / count),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _lineIndex == 0 ? null : () => _move(-1),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: _lineIndex == count - 1 ? null : () => _move(1),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
