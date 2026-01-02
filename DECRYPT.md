# Encryption/Decryption Commands

## Encrypt a File

Use the command-line tool to encrypt files:

```bash
dart encrypt.dart <inputFile> <outputFile> <password>
```

### Example

```bash
# Encrypt a database file
dart encrypt.dart database.db database.db.enc "your_password"
```

**Note:** Encryption is done through the app's export feature.

## Decrypt a File

Use the command-line tool to decrypt files:

```bash
dart decrypt.dart <inputFile> <outputFile> <password>
```

### Example

```bash
# Decrypt an exported database file
dart decrypt.dart database_20241201_120000.db.enc database.db "your_password"
```

### Requirements

- Dart runtime installed
- Run `flutter pub get` to install dependencies
- Encrypted file must be created by this app's encryption function

### File Format

- **New format**: `[salt: 32 bytes][IV: 16 bytes][encrypted data]` (secure, random IV)
- **Old format**: `[salt: 32 bytes][encrypted data]` (backward compatible, uses zero IV)

The decryption tool automatically detects the format and handles both.

