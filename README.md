<p align="center">
  <h2>Finease - Expense Tracker</h2>
</p>

<p align="center">
  <a href="https://flutter.dev/" style="text-decoration:none" area-label="flutter">
    <img src="https://img.shields.io/badge/Platform-Flutter%203.16.5-blue">
  </a>
  <a href="https://github.com/Donnie/Finease/releases/tag/v1.0.18" style="text-decoration:none" area-label="flutter">
    <img src="https://img.shields.io/badge/Version-1.0.15-orange">
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
- Totally offline*! 100% privacy commitment.

Cultivate discipline, enjoy ease of use, and control your financial data.

*\* needs internet only if you have multi currency accounts, to look up exchange rates from ECB.*

#### Encryption Feature

Finease now includes an advanced encryption feature to enhance data security. This feature ensures that all your financial data within the app is now encrypted during exporting it to Google Drive or other places, providing an additional layer of protection against unauthorized access.

**Technical Details**:

- Encryption Algorithm: The feature leverages the AES (Advanced Encryption Standard) algorithm, renowned for its balance between strong security and efficient performance. AES operates in CBC mode (Cipher Block Chaining), which ensures that each block of data is encrypted differently.
- Key Management: Encryption keys are generated using a secure, random process and are managed using a combination of hashing and salting techniques. This approach ensures that keys are unique and cannot be easily predicted or replicated.
- Data Integrity: Alongside encryption, the application implements HMAC (Hash-Based Message Authentication Code) to verify the integrity and authenticity of the data. This ensures that any tampering with the encrypted data can be detected.

**How It Works:**

- You have to turn on `Enable Encryption` under `Database` section from the Settings.
- The encryption feature automatically encrypts your database file during exports and uses the same password to decrypt it during importing.

**Tips:**

- Remember, encryption is only as strong as your password. Use a strong, unique password for your account.
- If you want to decrypt the DB file on your computer read the [directions provided here](decrypt.dart).

**Warnings:**

- Due to the nature of latest available encryption methods, your data cannot be encrypted while being in use by the App. Therefore, if your phone is compromised, your data and password shall be available to third party.
- If you provide the unencrypted database file to anyone they would get to know your DB password.
- If you forget your password, it might be impossible to recover your encrypted data. Always keep a backup of your password in a secure place.
- Avoid sharing your password or storing it in an insecure location.

> Made with ♥ in Berlin
