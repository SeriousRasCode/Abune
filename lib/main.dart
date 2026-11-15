import 'package:flutter/material.dart';
// 1. New Imports
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';

// Helper class to combine all necessary audio data into a single object
class PositionData {
  final Duration position;
  final Duration duration;
  final ProcessingState state;

  PositionData(this.position, this.duration, this.state);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _currentThemeMode = ThemeMode.system;

  // 2. Instantiate the new AudioPlayer
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Use an async function call to handle audio initialization
    _initAudioPlayer();
  }

  // 3. Audio Initialization Function
  Future<void> _initAudioPlayer() async {
    // Configure the Audio Session for background playback and notifications
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      // Load the audio asset (replaces .open() with Audio())
      await _audioPlayer.setAsset("assets/audio/abune_tselot.mp3");
    } catch (e) {
      // Log the error for debugging
      print("Audio loading error: $e");
    }
  }

  // Function to toggle between Light and Dark themes
  void _toggleTheme() {
    final isDark = _currentThemeMode == ThemeMode.dark ||
        (_currentThemeMode == ThemeMode.system &&
            WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark);
    setState(() {
      _currentThemeMode = isDark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  // --- Audio Control Functions (Simplified) ---
  void _togglePlayPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  @override
  void dispose() {
    // 4. Dispose of the new player
    _audioPlayer.dispose();
    super.dispose();
  }

  // Helper function for time formatting (remains the same)
  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    // Check if the duration is long enough to show hours
    if (d.inHours > 0) {
      return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  // 5. Combined Stream for UI Updates
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration?, ProcessingState, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.durationStream,
        _audioPlayer.processingStateStream,
        // Combine the latest values from all three streams
        (position, duration, state) =>
            PositionData(position, duration ?? Duration.zero, state),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _currentThemeMode,
      theme: ThemeData(
        fontFamily: 'MyCustomFont',
        brightness: Brightness.light,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black,
            fontFamily: 'MyCustomFont',
          ),
          headlineSmall: TextStyle(
            color: Colors.red,
            fontFamily: 'MyCustomFont',
          ),
        ),
        sliderTheme: SliderThemeData(
          thumbColor: const Color.fromARGB(255, 23, 38, 36),
          activeTrackColor: const Color.fromARGB(255, 9, 63, 58),
          inactiveTrackColor: const Color.fromARGB(255, 32, 97, 90),
          overlayColor: const Color.fromARGB(255, 36, 83, 78).withOpacity(0.2),
        ),
      ),
      darkTheme: ThemeData(
        sliderTheme: SliderThemeData(
          thumbColor: const Color.fromARGB(255, 255, 255, 255),
          activeTrackColor: const Color.fromARGB(255, 255, 255, 255),
          inactiveTrackColor: const Color.fromARGB(255, 32, 97, 90),
          overlayColor: const Color.fromARGB(
            255,
            255,
            255,
            255,
          ).withOpacity(0.2),
        ),
        fontFamily: 'MyCustomFont',
        brightness: Brightness.dark,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white,
            fontFamily: 'MyCustomFont',
          ),
          headlineSmall: TextStyle(
            color: Colors.red,
            fontFamily: 'MyCustomFont',
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          final Color? currentBodyTextColor = Theme.of(
            context,
          ).textTheme.bodyMedium?.color;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              title: const Text('አቡነ ዘበሰማያት'),
              actions: [

                // 🌙 Day/Night Mode Button
                IconButton(
                  icon: Icon(
                    Theme.of(context).brightness == Brightness.dark
                        ? Icons
                              .light_mode // Show sun icon in dark mode
                        : Icons.dark_mode, // Show moon icon in light mode
                  ),
                  onPressed: _toggleTheme,
                  tooltip: 'Toggle Day/Night Mode',
                ),
                  IconButton(
                    onPressed: () {
                      showAboutDialog(
                        context: context,
                        children: [
                          Text('Made in ❤️ by Tedros Teshome'),
                        ],
                        applicationName: 'አቡነ ዘበሰማያት',
                        applicationVersion: '1.0.0',
                        applicationIcon: const Icon(Icons.menu_book),
                      );
                    },
                   icon: Icon(Icons.info_outline,))
              ],
            ),

            // --- Body Content (Unchanged) ---
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 1.0,
                    child: Padding(
                      padding: const EdgeInsetsGeometry.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: Material(
                        child: RichText(
                          textAlign: TextAlign.justify,
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style.copyWith(
                              fontSize: 16.0,
                              height: 1.5,
                              fontFamily: 'MyCustomFont',
                              color: currentBodyTextColor,
                            ),
                            children: [
                              TextSpan(
                                text: "በስመ አብ ወወልድ ወመንፈስ ቅዱስ አሐዱ አምላክ አሜን",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: "\n\nአቡነ ዘበሰማያት በግዕዝ",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.red,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                      
                              TextSpan(
                                text:
                                    "\nአቡነ ዘበሰማያት ይትቀደስ ስምከ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: "\nትምፃእ መንግሥትከ ፣ ወይኩን ፈቃድከ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "\nበከመ በሰማይ ፣ ከማሁ በምድር",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "\nሲሳየነ ፣ ዘለለ ዕለትነ ፣ ሃበነ ዮም",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: "\nኅድግ ለነ ፣ አበሳነ ወጌጋየነ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: "\nከመ ንሕነኒ ንኅድግ ለዘአበሰ ለነ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: "\nኢታብአነ እግዚኦ ውስተ መንሱት",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: "\nኣላ አድኅነነ ወባልሐነ ፣ እምኩሉ እኩይ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: "\nእስመ ዚኣከ ፣ ይእቲ መንግሥት",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: "\nኃይል ወስብሐት ፣ ለዓለመ ዓለም ፣ አሜን",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                      
                              // Beselame Gebriel
                      
                              TextSpan(
                                text: "\n\nበሰላም ቅዱስ ገብርኤል መልአክ",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.red,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "\nበሰላመ ቅዱስ ገብርኤል መልአክ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: "\nኦ እግዝእትየ ማርያም ሰላም ለኪ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: "\nድንግል በኅሊናኪ ፣ ወድንግል በሥጋኪ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text: "\nእመ እግዚአብሔር ጸባዖት ሰላም ለኪ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "\nቡርክት አንቲ እምአንስት",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "\nወቡሩክ ፍሬ ከርሥኪ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              
                              TextSpan(
                               
                                text:
                                    "\nተፈሥሒ ፍሥሕት ኦ ምልእተ ጸጋ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "\nእግዚአብሔር ምስሌኪ ፣ ሰአሊ ወጸልዪ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "\nምሕረት በእንቲኣነ ፣ ኀበ ፍቁር ወልድኪ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              TextSpan(
                                text:
                                    "\nኢየሱስ ክርስቶስ ፣ ከመ ይሥረይ ለነ ኃጣውኢነ",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: currentBodyTextColor,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 6. Audio Controls using StreamBuilder
            bottomNavigationBar: BottomAppBar(
              child: StreamBuilder<PositionData>(
                stream: _positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  final position = positionData?.position ?? Duration.zero;
                  final totalDuration = positionData?.duration ?? Duration.zero;
                  final isReady =
                      positionData?.state != ProcessingState.idle &&
                      positionData?.state != ProcessingState.loading;

                  if (totalDuration == Duration.zero) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Loading Audio...",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Slider
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: totalDuration.inMilliseconds.toDouble(),
                          value: isReady
                              ? position.inMilliseconds.toDouble().clamp(
                                  0.0,
                                  totalDuration.inMilliseconds.toDouble(),
                                )
                              : 0.0,
                          onChanged: (value) {
                            _audioPlayer.seek(
                              Duration(milliseconds: value.toInt()),
                            );
                          },
                        ),
                      ),

                      // Control Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(_formatDuration(position)),
                          IconButton(
                            // 7. Use the player.playing state for icon logic
                            icon: Icon(
                              _audioPlayer.playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 30,
                            ),
                            onPressed: isReady
                                ? _togglePlayPause
                                : null, // Disable if not ready
                          ),
                          Text(_formatDuration(totalDuration)),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
