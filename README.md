# Abune Zebesemayat

A Flutter prayer reader for **Abune Zebesemayat** and **Beselame Gebriel**. Read the prayers in Ge'ez script, listen to the bundled Abune Zebesemayat recording, and practise memorising one line at a time. The app supports light and dark themes.

## Platforms and requirements

The repository contains Android and iOS Flutter projects. GitHub Actions checks Android builds on pull requests, uploads signed APK artifacts for `main`, and attaches signed APKs to tagged GitHub Releases. An iOS build is not currently automated. To develop locally, install a Flutter SDK compatible with the Dart constraint in [`pubspec.yaml`](pubspec.yaml) and the platform toolchain for your target device. Local Flutter or Java installation is not needed to download the APK produced by GitHub Actions.

## Get the app

1. Open the repository's **Releases** page and select the latest release. For an untagged `main` build, open its successful **Android build** run under **Actions** and download the `abune-android-release` artifact.
2. Download `app-arm64-v8a-release.apk` for most current phones, or `app-armeabi-v7a-release.apk` for 32-bit ARM devices. Extract the Actions artifact first if using that route.
3. Install the APK on an Android device that permits installs from your chosen source.

The release APKs are signed with the persistent key held in the GitHub `release` environment. Each workflow run uses a higher Android version code so later release APKs can update an installed release APK. A debug APK signed with a different key requires a one-time uninstall before switching to this release build. Release builds split by ARM architecture and store debug symbols as a separate Actions artifact to keep each APK smaller.

## Develop

```sh
flutter pub get
flutter run
```

For an Android build, run `flutter build apk --debug`. The recording and font are bundled under `assets/` and `fonts/`. The app does not request prayer content from a server.

### App structure

| Location | Responsibility |
| --- | --- |
| [`lib/main.dart`](lib/main.dart) | Starts the app. |
| [`lib/app/abune_app.dart`](lib/app/abune_app.dart) | Owns navigation, theme state, and audio setup. |
| [`lib/data/prayers.dart`](lib/data/prayers.dart) | Stores the prayer sections and line text. |
| [`lib/screens/`](lib/screens/) | Reading and memorisation screens. |
| [`lib/widgets/`](lib/widgets/) | Reusable audio controls and About dialog. |
| [`lib/theme/app_theme.dart`](lib/theme/app_theme.dart) | Light and dark colors and component styles. |

Practice lets readers hide and reveal each line, move between lines, and mark lines learned during the current app session. Learned marks reset when the app closes.

## Checks and contributions

The [Android build workflow](.github/workflows/android.yml) runs on pull requests, pushes to `main`, version tags such as `v1.0.0`, and manual dispatch. It runs Flutter analysis and widget tests, checks a debug build on pull requests, and builds signed release APKs on `main` and tags. Tagged builds publish those APKs to GitHub Releases after signature verification. Open an issue for a proposed change, create a branch from `main`, keep commits focused by file or purpose, and open a pull request for review. Check the workflow result before merging.

The workflow caches the Flutter SDK, Dart packages, Gradle downloads, and the required Android NDK and CMake versions between runs. The first run fills the caches; later runs can reuse them. Contributors do not need to download these tools locally.

## Creator

Created by Tedros Teshome.

## Privacy and terms

The app links to its Privacy Policy and Terms of Use from **About**. Public copies are in [`docs/privacy.html`](docs/privacy.html) and [`docs/terms.html`](docs/terms.html). Privacy questions can be sent to tedroszion@gmail.com. See the [Google Play preparation checklist](docs/PLAY_STORE.md) before submitting the app to Play Console.

## License

The source code and documentation are available under the [MIT License](LICENSE). It permits use, modification, and redistribution with the copyright and license notice included.

The bundled `fonts/Benaiah.ttf` is a third-party font. Its publisher [announced it as freely available](https://t.me/s/Type_Habesha?before=977), but the font is not covered by this project's MIT license. Check the publisher's terms before redistributing the font separately. The recording in `assets/audio/abune_tselot.mp3` is also excluded from the MIT license until its rights are confirmed.
