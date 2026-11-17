# Google Play preparation

The app's [Privacy Policy](privacy.html) and [Terms of Use](terms.html) are also available from the in-app About dialog. Privacy contact: tedroszion@gmail.com.

Before a Google Play submission:

1. Enter the publicly hosted Privacy Policy URL in Play Console and check that it loads without signing in. Google Play requires a privacy policy in the listing and in the app, even if no personal data is collected. Complete the Data safety questionnaire to match the actual app and its SDKs. [Google Play user data policy](https://support.google.com/googleplay/android-developer/answer/10144311)
2. Complete the App content declarations in Play Console, including ads, target audience, and content rating. The current app has no ads or accounts. Recheck these answers if features change. [App content help](https://support.google.com/googleplay/android-developer/answer/9859455)
3. Download the signed Android App Bundle (`.aab`) from the `abune-play-bundle` artifact on a successful `main` build. The APKs on GitHub Releases are for direct installation; a new Google Play app uses the bundle. Enrol in Play App Signing and decide how its signing key will relate to the existing direct-download key before publishing, because update compatibility matters. [Android App Bundle guide](https://developer.android.com/guide/app-bundle), [app signing guide](https://developer.android.com/studio/publish/app-signing)
4. Check the app's target API level against the [current Google Play requirement](https://developer.android.com/google/play/requirements/target-sdk) at submission time. Confirm the package name `com.example.abune` can be registered to the developer account; changing it later creates a separate Android app identity.
5. Keep records establishing redistribution rights for the bundled recordings and Benaiah font. A publicly accessible or free YouTube upload alone does not establish reuse permission. These Terms of Use describe the app; they do not grant rights to third-party media. [YouTube license guidance](https://support.google.com/youtube/answer/2797468)

Update the in-app legal text in `lib/data/legal_text.dart` when editing the public HTML pages. Review the Play declarations whenever app behavior changes.
