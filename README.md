# Abune Zebesemayat

A Flutter prayer reader for **Abune Zebesemayat** and **Beselame Gebriel**. The app displays the prayers in Ge'ez script and includes a bundled audio recording of Abune Zebesemayat. Readers can switch between light and dark themes, play or pause the recording, and seek within it.

## Platforms and requirements

The repository contains Android and iOS Flutter projects. GitHub Actions checks Android builds on pull requests and publishes a signed Android release APK after a successful push to `main` or manual workflow run. An iOS build is not currently automated. To develop locally, install a Flutter SDK compatible with the Dart constraint in [`pubspec.yaml`](pubspec.yaml) and the platform toolchain for your target device. Local Flutter or Java installation is not needed to download the APK produced by GitHub Actions.

## Get the app

1. Open the latest successful **Android build** run for `main` on the repository's **Actions** tab.
2. Download the `abune-android-release` artifact and extract the APK.
3. Install the APK on an Android device that permits installs from your chosen source.

The release APK is signed with the persistent key held in the GitHub `release` environment. Each workflow run uses a higher Android version code so later release APKs can update an installed release APK. A debug APK signed with a different key requires a one-time uninstall before switching to this release build.

## Develop

```sh
flutter pub get
flutter run
```

For an Android build, run `flutter build apk --debug`. The app's prayer text is in [`lib/main.dart`](lib/main.dart), and its recording and font are bundled under `assets/` and `fonts/`. It does not request prayer content from a server.

## Checks and contributions

The [Android build workflow](.github/workflows/android.yml) runs on pull requests, pushes to `main`, and manual dispatch. It runs Flutter analysis, widget tests, and an Android build. Signed APKs are uploaded only from `main` or manual runs, after checks pass. Open an issue for a proposed change, create a branch from `main`, keep commits focused by file or purpose, and open a pull request for review. Check the workflow result before merging.

## Credits and licensing

The app's About dialog credits Tedros Teshome. The repository does not currently include a license file; ask the repository owner before reusing its source, recording, or font outside this project.
