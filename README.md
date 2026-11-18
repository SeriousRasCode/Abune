# Abune Zebesemayat

Created by Tedros Teshome.

I built Abune Zebesemayat to make Ethiopian Orthodox prayers easier to read, hear, and memorise. The app includes **Abune Zebesemayat**, **Beselame Gebriel**, and **Sibhat Tselot** in Geʽez script. Two bundled recordings cover the three prayers.

## What the app offers

- **Read:** See the full text of all three prayers in a clear, scrollable layout.
- **Listen:** Switch between the recordings and follow the spoken line automatically in a compact reader. Sibhat includes the three spoken repetitions of its opening line. Tap any line to replay from there. The opening invocation for Abune remains in Read because it is not spoken in that recording.
- **Practice:** Hide and reveal one line at a time. The app saves learned lines and your place across sessions, with progress shown for each prayer.
- **Settings:** Choose System, Day, or Night theme. Your choice is remembered. Both recordings have playback and seeking controls, and you can fine-tune a line's timing in Settings if needed.

## Download for Android

Download a signed APK from [GitHub Releases](https://github.com/SeriousRasCode/Abune/releases). I publish a new release automatically after a successful build on `main`. Choose `app-arm64-v8a-release.apk` for most current Android phones or `app-armeabi-v7a-release.apk` for 32-bit ARM devices. The separate files keep downloads smaller.

I sign each release with the same key stored in the GitHub `release` environment, and every build receives a higher Android version code. That lets a newer release update an earlier release without uninstalling it. A debug build uses a different key and cannot update a release build.

The repository also contains an iOS Flutter project, but I currently publish Android builds only. Each signed build is also available as the `abune-android-release` artifact on the [Actions page](https://github.com/SeriousRasCode/Abune/actions).

## For contributors

Open an issue to discuss a change, create a branch from `main`, and send a pull request. I keep commits focused by file or purpose. GitHub Actions runs Flutter analysis, widget tests, and an Android debug build on pull requests, so contributors do not need Flutter, Java, or the Android NDK installed just to check a PR.

For local development, use a Flutter SDK compatible with [`pubspec.yaml`](pubspec.yaml) and the toolchain for the target platform:

```sh
flutter pub get
flutter run
```

The [Android workflow](.github/workflows/android.yml) builds signed, ARM-specific release APKs on `main` and version tags. It verifies their signatures and publishes a GitHub Release automatically after a successful build. It also builds a signed Android App Bundle as an Actions artifact for Play Console preparation. Flutter, Dart package, Gradle, NDK, and CMake downloads are cached between runs.

### Where the code lives

| Path | Purpose |
| --- | --- |
| [`lib/main.dart`](lib/main.dart) | Starts the app. |
| [`lib/app/abune_app.dart`](lib/app/abune_app.dart) | Connects navigation, theme, and playback. |
| [`lib/data/prayers.dart`](lib/data/prayers.dart) | Holds the prayer collection. |
| [`lib/data/sibhat_prayer.dart`](lib/data/sibhat_prayer.dart) | Holds Sibhat text checked against an Ethiopian Orthodox prayer source. |
| [`lib/data/audio_cues.dart`](lib/data/audio_cues.dart), [`lib/data/sibhat_audio_cues.dart`](lib/data/sibhat_audio_cues.dart) | Match spoken lines to recording time. |
| [`lib/screens/`](lib/screens/) | Read, Listen, Practice, Settings, and legal screens. |
| [`lib/widgets/`](lib/widgets/) | Shared navigation, audio controls, ornament, and the About dialog. |
| [`lib/services/cue_store.dart`](lib/services/cue_store.dart) | Saves optional timing adjustments on the device. |
| [`lib/services/study_store.dart`](lib/services/study_store.dart) | Saves learning progress and your place. |
| [`lib/theme/app_theme.dart`](lib/theme/app_theme.dart) | Light and dark visual styles. |

Sibhat's Geʽez wording was checked against the [Medhanie Alem Ethiopian Orthodox Tewahedo Church prayer page](https://sites.google.com/site/medhanialemgrandrapids/prayers). I aligned its bundled recording to the text and included those cue times in the app. If a listener adjusts a line's timing in Settings, that adjustment is saved on their device.

## Privacy and terms

The app opens its Privacy Policy and Terms of Use from **About**. Public copies are at [Privacy Policy](https://seriousrascode.github.io/Abune/privacy.html) and [Terms of Use](https://seriousrascode.github.io/Abune/terms.html). Privacy questions can be sent to `tedroszion@gmail.com`. I keep a [Google Play preparation checklist](docs/PLAY_STORE.md) for the remaining Play Console steps.

## License and bundled media

I release my source code and documentation under the [MIT License](LICENSE). It allows use, changes, and redistribution when the copyright and license notice are kept.

The bundled `fonts/Benaiah.ttf` is a third-party font. Its publisher [announced it as freely available](https://t.me/s/Type_Habesha?before=977), but it is outside my MIT license. The recordings in `assets/audio/` are also outside the MIT license. Anyone redistributing these files separately should check their rights with the original rights holders.
