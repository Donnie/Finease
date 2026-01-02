// encrypt.dart
// A command-line tool to encrypt files using the same encryption function
// used by this app.
//
// Please see how to install Dart before using this file: https://dart.dev/get-dart
// Also do not forget to do `flutter pub get` to get all the dependencies.
//
// The script uses a password to derive a cryptographic key and generates a
// random IV for each encryption. It encrypts files using AES-CBC with
// PKCS7 padding. The encrypted file format includes salt and IV.
//
// Usage:
//   dart encrypt.dart <inputFile> <outputFile> <password>
//
// Arguments:
//   <inputFile>  - The path to the file that needs to be encrypted.
//   <outputFile> - The path where the encrypted file will be written.
//   <password>   - The password used to generate the key for encryption.
//
// Example:
//   dart encrypt.dart database.db database.db.enc "myPassword123"
//
// Requirements:
// - Dart runtime must be installed on the system to run this script.
// - The input file must exist and be readable.
//
// File Format:
// - Output format: [salt: 32 bytes][IV: 16 bytes][encrypted data]
// - Each encryption uses a unique random salt and IV for security.

// ignore_for_file: avoid_print

import 'dart:io';
import 'package:finease/core/encryption.dart';

void main(List<String> arguments) async {
  if (arguments.length != 3) {
    // How to correctly use the script if the wrong number of arguments are given
    print('Usage: dart encrypt.dart <inputFile> <outputFile> <password>');
    exit(1);
  }

  String inputFile = arguments[0];
  String outputFile = arguments[1];
  String password = arguments[2];

  // Check if input file exists
  final input = File(inputFile);
  if (!await input.exists()) {
    print('Error: Input file does not exist: $inputFile');
    exit(1);
  }

  try {
    // Call the encryptFile function (which should be properly defined in 'finease/core/encryption.dart')
    // with the provided arguments to encrypt the file.
    await encryptFile(inputFile, outputFile, password);

    // The encryption process is complete and indicate where the encrypted file can be found.
    print('Encryption complete. Encrypted file is at: $outputFile');
  } on FileSystemException catch (e) {
    print('Error: Failed to read or write file: ${e.message}');
    exit(1);
  } catch (e) {
    print('Error: Encryption failed: $e');
    exit(1);
  }
}

