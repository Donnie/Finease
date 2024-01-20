import 'dart:io';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';

// Function to derive a key from a password
Uint8List _deriveKey(String password, Uint8List salt) {
  var pkcs = KeyDerivator('SHA-1/HMAC/PBKDF2');
  pkcs.init(Pbkdf2Parameters(salt, 1000, 32)); // Adjust parameters as needed
  return pkcs.process(Uint8List.fromList(password.codeUnits));
}

// Function to generate a random salt
Uint8List _generateSalt() {
  var saltGen = FortunaRandom();
  saltGen.seed(KeyParameter(Uint8List(32)));
  return saltGen.nextBytes(32); // Size of the salt
}

// Function for encrypting a file
Future<void> encryptFile(
    String inputFile, String outputFile, String password) async {
  // Generate a salt
  var salt = _generateSalt();

  // Derive the key
  Uint8List key = _deriveKey(password, salt);

  // Encrypt the file
  final inputBytes = await File(inputFile).readAsBytes();

  // Initialize AES encryption
  final cipher = PaddedBlockCipher('AES/CBC/PKCS7')
    ..init(true, PaddedBlockCipherParameters(
      ParametersWithIV(KeyParameter(key), Uint8List(16)), // IV size for AES
      null,
    ));

  // Encrypt the data
  final encrypted = cipher.process(inputBytes);
  final encryptedFile = File(outputFile);

  // Write the salt and encrypted data to file
  await encryptedFile.writeAsBytes(salt.followedBy(encrypted).toList());
}

// Function for decrypting a file
Future<void> decryptFile(
    String inputFile, String outputFile, String password) async {
  // Read the encrypted file
  final encryptedFile = File(inputFile);
  final encryptedBytes = await encryptedFile.readAsBytes();

  // Extract the salt
  var salt = encryptedBytes.sublist(0, 32); // 32 bytes from salt

  // Derive the key
  Uint8List key = _deriveKey(password, salt);

  // Encrypted data is after the salt
  var encryptedData = encryptedBytes.sublist(32);

  // Initialize AES decryption
  final cipher = PaddedBlockCipher('AES/CBC/PKCS7')
    ..init(false, PaddedBlockCipherParameters(
      ParametersWithIV(KeyParameter(key), Uint8List(16)), // IV size for AES
      null,
    ));

  // Decrypt the data
  final decrypted = cipher.process(Uint8List.fromList(encryptedData));
  final decryptedFile = File(outputFile);

  // Write the decrypted data to file
  await decryptedFile.writeAsBytes(decrypted);
}

