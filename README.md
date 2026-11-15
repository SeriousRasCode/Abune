# Abune Zebesemayat

Created by Tedros Teshome.

I built Abune Zebesemayat to make two Ethiopian Orthodox prayers easier to read, hear, and memorise. The app shows **Abune Zebesemayat** and **Beselame Gebriel** in Geʽez script, with one bundled recording that contains both prayers.

## What the app offers

- **Read:** See the full text of both prayers in a clear, scrollable layout.
- **Listen:** Follow the spoken lines as the recording plays. The line timing is based on the bundled audio. The opening invocation remains in Read; it is not spoken in this recording.
- **Practice:** Hide and reveal one line at a time, then mark lines learned during the current session.
- **Comfort:** Switch between light and dark themes and seek within the recording.

## Download for Android

Download a signed APK from [GitHub Releases](https://github.com/SeriousRasCode/Abune/releases). Choose `app-arm64-v8a-release.apk` for most current Android phones or `app-armeabi-v7a-release.apk` for 32-bit ARM devices. The separate files keep downloads smaller.

I sign each release with the same key stored in the GitHub `release` environment, and every build receives a higher Android version code. That lets a newer release update an earlier release without uninstalling it. A debug build uses a different key and cannot update a release build.

The repository also contains an iOS Flutter project, but I currently publish Android builds only. For builds from `main` that do not have a version tag, the signed APKs are available as the `abune-android-release` artifact on the [Actions page](https://github.com/SeriousRasCode/Abune/actions).

## For contributors

Open an issue to discuss a change, create a branch from `main`, and send a pull request. I keep commits focused by file or purpose. GitHub Actions runs Flutter analysis, widget tests, and an Android debug build on pull requests, so contributors do not need Flutter, Java, or the Android NDK installed just to check a PR.

For local development, use a Flutter SDK compatible with [`pubspec.yaml`](pubspec.yaml) and the toolchain for the target platform:

```sh
flutter pub get
flutter run
```

The [Android workflow](.github/workflows/android.yml) builds signed, ARM-specific release APKs on `main` and version tags. It verifies their signatures and publishes tagged APKs to GitHub Releases. Flutter, Dart package, Gradle, NDK, and CMake downloads are cached between runs.

### Where the code lives

| Path | Purpose |
| --- | --- |
| [`lib/main.dart`](lib/main.dart) | Starts the app. |
| [`lib/app/abune_app.dart`](lib/app/abune_app.dart) | Connects navigation, theme, and playback. |
| [`lib/data/prayers.dart`](lib/data/prayers.dart) | Holds the prayer text. |
| [`lib/data/audio_cues.dart`](lib/data/audio_cues.dart) | Matches spoken lines to recording time. |
| [`lib/screens/`](lib/screens/) | Read, Listen, Practice, and legal screens. |
| [`lib/widgets/`](lib/widgets/) | Shared audio controls and the About dialog. |
| [`lib/services/cue_store.dart`](lib/services/cue_store.dart) | Saves optional timing adjustments on the device. |
| [`lib/theme/app_theme.dart`](lib/theme/app_theme.dart) | Light and dark visual styles. |

Practice marks last only for the current session. If a listener adjusts the timing in Listen, those timestamps are saved on their device.

## Privacy and terms

The app opens its Privacy Policy and Terms of Use from **About**. Public copies are at [Privacy Policy](https://seriousrascode.github.io/Abune/privacy.html) and [Terms of Use](https://seriousrascode.github.io/Abune/terms.html). Privacy questions can be sent to `tedroszion@gmail.com`. I keep a [Google Play preparation checklist](docs/PLAY_STORE.md) for the remaining Play Console steps.

## License and bundled media

I release my source code and documentation under the [MIT License](LICENSE). It allows use, changes, and redistribution when the copyright and license notice are kept.

The bundled `fonts/Benaiah.ttf` is a third-party font. Its publisher [announced it as freely available](https://t.me/s/Type_Habesha?before=977), but it is outside my MIT license. The recording in `assets/audio/abune_tselot.mp3` is also outside the MIT license. Anyone redistributing either file separately should check its rights with the original rights holder.
