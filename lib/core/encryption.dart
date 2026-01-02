import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:pointycastle/export.dart';

// Function to derive a key from a password
Uint8List _deriveKey(String password, Uint8List salt) {
  var pkcs = KeyDerivator('SHA-1/HMAC/PBKDF2');
  pkcs.init(Pbkdf2Parameters(salt, 1000, 32)); // Adjust parameters as needed
  return pkcs.process(Uint8List.fromList(password.codeUnits));
}

// Function to generate a random salt
Uint8List _generateSalt() {
  var random = Random.secure();
  var salt = Uint8List(32);
  for (int i = 0; i < 32; i++) {
    salt[i] = random.nextInt(256);
  }
  return salt;
}

// Function to generate a random IV
Uint8List _generateIV() {
  var random = Random.secure();
  var iv = Uint8List(16);
  for (int i = 0; i < 16; i++) {
    iv[i] = random.nextInt(256);
  }
  return iv;
}

// Function for encrypting a file
Future<void> encryptFile(
    String inputFile, String outputFile, String password) async {
  // Generate a salt
  var salt = _generateSalt();

  // Generate a random IV
  var iv = _generateIV();

  // Derive the key
  Uint8List key = _deriveKey(password, salt);

  // Encrypt the file
  final inputBytes = await File(inputFile).readAsBytes();

  // Initialize AES encryption
  final cipher = PaddedBlockCipher('AES/CBC/PKCS7')
    ..init(true, PaddedBlockCipherParameters(
      ParametersWithIV(KeyParameter(key), iv),
      null,
    ));

  // Encrypt the data
  final encrypted = cipher.process(inputBytes);
  final encryptedFile = File(outputFile);

  // Write the salt, IV, and encrypted data to file
  // Format: [salt: 32 bytes][IV: 16 bytes][encrypted data]
  await encryptedFile.writeAsBytes(
      salt.followedBy(iv).followedBy(encrypted).toList());
}

// Function for decrypting a file
Future<void> decryptFile(
    String inputFile, String outputFile, String password) async {
  // Read the encrypted file
  final encryptedFile = File(inputFile);
  final encryptedBytes = await encryptedFile.readAsBytes();

  // Check file format: old format (no IV) vs new format (with IV)
  // Old format: [salt: 32 bytes][encrypted data]
  // New format: [salt: 32 bytes][IV: 16 bytes][encrypted data]
  bool hasIV = encryptedBytes.length >= 48;

  // Extract the salt (first 32 bytes)
  var salt = encryptedBytes.sublist(0, 32);

  // Extract IV and encrypted data based on format
  Uint8List iv;
  Uint8List encryptedData;
  if (hasIV) {
    // New format: extract IV (bytes 32-47)
    iv = encryptedBytes.sublist(32, 48);
    encryptedData = encryptedBytes.sublist(48);
  } else {
    // Old format: no IV stored, use zero IV (backward compatibility)
    iv = Uint8List(16); // Zero IV for old format
    encryptedData = encryptedBytes.sublist(32);
  }

  // Derive the key
  Uint8List key = _deriveKey(password, salt);

  // Initialize AES decryption
  final cipher = PaddedBlockCipher('AES/CBC/PKCS7')
    ..init(false, PaddedBlockCipherParameters(
      ParametersWithIV(KeyParameter(key), iv),
      null,
    ));

  // Decrypt the data
  final decrypted = cipher.process(Uint8List.fromList(encryptedData));
  final decryptedFile = File(outputFile);

  // Write the decrypted data to file
  await decryptedFile.writeAsBytes(decrypted);
}
