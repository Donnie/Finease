## Finease - Expense Tracker

> [!WARNING]
> ### ⚠️ Project Status: Archived & No Longer Maintained
> Finease is no longer actively maintained and this repository has been archived.
> 
> A new cloud-native project **Financy** has taken its place. Please check out the new project at **[github.com/FinancyOrg](https://github.com/FinancyOrg)**.

---

![](https://img.shields.io/badge/Status-Archived-inactive) ![](https://img.shields.io/badge/Platform-Flutter%203.29.2-blue) [](https://github.com/Donnie/Finease/releases/tag/v1.2.10)![](https://img.shields.io/badge/Version-1.2.10-orange)

### Screenshots

#### Mobile

| ![](images/photo1704048355.jpeg) | ![](images/photo1704048321.jpeg) | ![](images/photo1704048271.jpeg) |
| -------------------------------- | -------------------------------- | -------------------------------- |
| Mobile                           | Tablet                           | Desktop                          |

### Privacy-first budgeting.

- Double Entry Accounting
- Easy export to Google Drive or WhatsApp/Telegram
- [Encryption with AES/CBC/PKCS7](https://github.com/Donnie/Finease/wiki/Encryption)
- [Foreign currency transactions with automated retranslation.](https://github.com/Donnie/Finease/wiki/Foreign-Currency-Retranslation-%E2%80%90-Gains-and-losses-in-foreign-currency)
- Totally offline*! 100% privacy commitment.

Cultivate discipline, enjoy ease of use, and control your financial data.

 *needs internet only if you have multi currency accounts, to look up exchange rates from ECB.*

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
