import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/sibhat_audio_cues.dart';
import '../screens/practice_screen.dart';
import '../screens/follow_along_screen.dart';
import '../screens/reading_screen.dart';
import '../screens/settings_screen.dart';
import '../services/cue_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_about_dialog.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/audio_player_bar.dart';

class AbuneApp extends StatefulWidget {
  const AbuneApp({this.cueStore, super.key});

  final CueStore? cueStore;

  @override
  State<AbuneApp> createState() => _AbuneAppState();
}

class _AbuneAppState extends State<AbuneApp> {
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _sibhatPlayer = AudioPlayer();
  ThemeMode _themeMode = ThemeMode.system;
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();
  int _tab = 0;
  int _recording = 0;
  int _timingRevision = 0;

  @override
  void initState() {
    super.initState();
    _loadAudio();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final saved = await _prefs.getString('theme_mode_v1');
      if (mounted && saved != null) {
        setState(() => _themeMode = ThemeMode.values.firstWhere(
              (mode) => mode.name == saved,
              orElse: () => ThemeMode.system,
            ));
      }
    } catch (_) {
      // Keep the system theme when device storage is unavailable.
    }
  }

  Future<void> _loadAudio() async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());
      await _player.setAsset('assets/audio/abune_tselot.mp3');
      await _sibhatPlayer.setAsset('assets/audio/sibhat_tselot.m4a');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio could not be loaded: $error')),
        );
      }
    }
  }

  void _setTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
    unawaited(_prefs.setString('theme_mode_v1', _themeMode.name)
        .catchError((Object _) {}));
  }

  Future<void> _selectRecording(int index) async {
    if (_recording == index) return;
    await (_recording == 0 ? _player : _sibhatPlayer).pause();
    if (mounted) setState(() => _recording = index);
  }

  @override
  void dispose() {
    _player.dispose();
    _sibhatPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'አቡነ ዘበሰማያት',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('አቡነ ዘበሰማያት'),
            actions: [
              IconButton(
                tooltip: 'About',
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const AppAboutDialog(),
                ),
                icon: const Icon(Icons.info_outline),
              ),
            ],
          ),
          body: IndexedStack(
            index: _tab,
            children: [
              const ReadingScreen(),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Row(children: [
                    Expanded(child: ChoiceChip(
                      label: const Text('Abune & Gebriel'),
                      selected: _recording == 0,
                      onSelected: (_) => _selectRecording(0),
                    )),
                    const SizedBox(width: 8),
                    Expanded(child: ChoiceChip(
                      label: const Text('Sibhat'),
                      selected: _recording == 1,
                      onSelected: (_) => _selectRecording(1),
                    )),
                  ]),
                ),
                Expanded(child: IndexedStack(
                  index: _recording,
                  children: [
                    FollowAlongScreen(player: _player, cueStore: widget.cueStore,
                      reloadToken: _timingRevision),
                    FollowAlongScreen(player: _sibhatPlayer,
                      title: 'Sibhat Tselot', lines: sibhatRecordedLines,
                      cues: sibhatCueMilliseconds, cueKey: 'sibhat_audio_cues_v1',
                      reloadToken: _timingRevision),
                  ],
                )),
              ]),
              const PracticeScreen(),
              SettingsScreen(
                themeMode: _themeMode,
                onThemeChanged: _setTheme,
                abunePlayer: _player,
                sibhatPlayer: _sibhatPlayer,
                abuneCueStore: widget.cueStore,
                onTimingChanged: () => setState(() => _timingRevision++),
              ),
            ],
          ),
          bottomNavigationBar: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_tab == 1)
                AudioPlayerBar(
                  key: ValueKey(_recording),
                  player: _recording == 0 ? _player : _sibhatPlayer,
                ),
              AppBottomNavigation(
                selectedIndex: _tab,
                onSelected: (index) => setState(() => _tab = index),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
