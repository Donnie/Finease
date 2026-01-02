// decrypt.dart
// A command-line tool to decrypt files that were encrypted with the
// corresponding encryption function in this app.
//
// Please see how to install Dart before using this file: https://dart.dev/get-dart
// Also do not forget to do `flutter pub get` to get all the dependencies.
//
// The script uses a password to derive a cryptographic key and extracts the IV
// from the encrypted file. It decrypts files encrypted using AES-CBC with
// PKCS7 padding. Supports both old format (no IV) and new format (with IV).
//
// Usage:
//   dart decrypt.dart <inputFile> <outputFile> <password>
//
// Arguments:
//   <inputFile>  - The path to the encrypted file that needs to be decrypted.
//   <outputFile> - The path where the decrypted file will be written.
//   <password>   - The password used to generate the key for decryption.
//
// Example:
//   dart decrypt.dart database.db.enc database.db "myPassword123"
//
// Requirements:
// - The input file must have been encrypted using the encryption function in this app
//   specifically AES-CBC with PKCS7 padding, and a key derived from the given password.
// - Dart runtime must be installed on the system to run this script.
//
// File Format:
// - New format: [salt: 32 bytes][IV: 16 bytes][encrypted data]
// - Old format: [salt: 32 bytes][encrypted data] (backward compatible)

// ignore_for_file: avoid_print

import 'dart:io';
import 'package:finease/core/encryption.dart';

void main(List<String> arguments) async {
  if (arguments.length != 3) {
    // How to correctly use the script if the wrong number of arguments are given
    print('Usage: dart decrypt.dart <inputFile> <outputFile> <password>');
    exit(1);
  }

  String inputFile = arguments[0];
  String outputFile = arguments[1];
  String password = arguments[2];

  try {
    // Call the decryptFile function (which should be properly defined in 'finease/core/encryption.dart')
    // with the provided arguments to decrypt the encrypted file.
    await decryptFile(inputFile, outputFile, password);

    // The decryption process is complete and indicate where the decrypted file can be found.
    print('Decryption complete. Decrypted file is at: $outputFile');
  } on ArgumentError catch (e) {
    // Catch ArgumentError which may be thrown for invalid padding during decryption
    if (e.message.contains('Invalid or corrupted pad block')) {
      print(
          'Error: The decryption failed. This may be due to an incorrect password or corrupted data.');
    } else {
      // Re-throw any other ArgumentError that was not related to padding
      rethrow;
    }
  }
}
