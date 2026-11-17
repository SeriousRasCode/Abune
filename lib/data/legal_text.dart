class LegalSection {
  const LegalSection(this.heading, this.body);

  final String heading;
  final String body;
}

const privacySections = <LegalSection>[
  LegalSection('About this policy',
      'Abune Zebesemayat is created by Tedros Teshome. This policy describes the current app. For privacy questions, email tedroszion@gmail.com.'),
  LegalSection('Data in the app',
      'The app has no accounts, ads, analytics, or in-app purchases. Prayer text, font, and audio are bundled in the app. Reading and playback do not send personal information to the developer. Lines marked as learned are held only in memory and are cleared when the app closes. If you set audio line timing, those timestamps are saved on your device and can be reset from Listen.'),
  LegalSection('Messages you send',
      'If you email the developer, your email address and message are used to answer your request. They may be retained in the email account until the request is resolved or you ask for deletion. Email delivery is handled by the email providers involved.'),
  LegalSection('Sharing and security',
      'The app does not share personal information with third parties. It does not request access to your contacts, location, camera, or microphone. Support email travels through your email provider and the developer’s provider; use care when sending sensitive information.'),
  LegalSection('Your choices and contact',
      'You can stop using the app or clear its local app data through Android settings. To ask about or request deletion of a support email, contact tedroszion@gmail.com.'),
  LegalSection('Changes',
      'This policy may change when app features or data practices change. The latest version will be available in the app and on the project website. Last updated: 15 November 2026.'),
];

const termsSections = <LegalSection>[
  LegalSection('About the app',
      'Abune Zebesemayat is a free prayer reader and memorisation aid created by Tedros Teshome. It is provided for personal devotional and educational use.'),
  LegalSection('Content and rights',
      'The app includes Geʽez prayer text, bundled recordings, and a third-party font. The MIT license in the project repository covers the developer’s source code and documentation, not the recordings or font. Do not assume that the app gives you permission to redistribute those third-party files separately.'),
  LegalSection('Use of the app',
      'You may read, listen, and practise with the app. Please use it lawfully and respectfully. The practice feature is a learning aid and does not certify that a prayer has been memorised or replace guidance from a teacher or church.'),
  LegalSection('Availability and changes',
      'The app is provided as available. Features and these terms may be updated. If you have questions or find a problem, email tedroszion@gmail.com. Last updated: 15 November 2026.'),
];
