<p align="center">
  <h2>Finease - Expense Tracker</h2>
</p>

<p align="center">
  <a href="https://flutter.dev/" style="text-decoration:none" area-label="flutter">
    <img src="https://img.shields.io/badge/Platform-Flutter%203.29.2-blue">
  </a>
  <a href="https://github.com/Donnie/Finease/releases/tag/v1.2.1" style="text-decoration:none" area-label="flutter">
    <img src="https://img.shields.io/badge/Version-1.2.1-orange">
  </a>
  <a href="https://github.com/Donnie/Finease/actions/workflows/android_release.yml" style="text-decoration:none" area-label="flutter">
    <img src="https://github.com/Donnie/Finease/actions/workflows/android_release.yml/badge.svg">
  </a>
</p>

### Screen shots

#### Mobile

| <img src="images/photo1704048355.jpeg" width="150"/> | <img src="images/photo1704048321.jpeg" width="200"/> | <img src="images/photo1704048271.jpeg" width="300"/> |
| :--------------------------------------------------: | :--------------------------------------------------: | :--------------------------------------------------: |
|                        Mobile                        |                        Tablet                        |                       Desktop                        |

### Privacy-first budgeting.

- Double Entry Accounting
- Easy export to Google Drive or WhatsApp/Telegram
- [Encryption with AES/CBC/PKCS7](https://github.com/Donnie/Finease/wiki/Encryption)
- [Foreign currency transactions with automated retranslation.](https://github.com/Donnie/Finease/wiki/Foreign-Currency-Retranslation-%E2%80%90-Gains-and-losses-in-foreign-currency)
- Totally offline*! 100% privacy commitment.

Cultivate discipline, enjoy ease of use, and control your financial data.

*\* needs internet only if you have multi currency accounts, to look up exchange rates from ECB.*

### Technical Details

#### Automated Release Process
The app uses GitHub Actions for automated releases. When a new version tag (e.g., `v1.0.29`) is pushed, the workflow:
1. Sets up a Flutter 3.22.0 environment
2. Builds the Android APK
3. Signs the APK with release keys
4. Creates a GitHub release with the versioned APK
5. Generates release notes automatically

The process is fully automated and secured using GitHub Secrets for signing keys.

#### Local Development

To run the app locally on macOS:

```bash
flutter pub get
flutter run -d macos
```

> Made with ♥ in Berlin
