import 'dart:io';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:finease/core/encryption.dart';

void main() {
  group('Encryption/Decryption Tests', () {
    late String password;
    late Uint8List salt;
    late String inputFile;
    late String encryptedOutputFile;
    late String decryptedOutputFile;
    late String oldEncryptedFile;
    late String oldDecryptedFile;
    late File testFile;
    late List<int> originalData;

    setUp(() {
      password = 'StrongPassword123';
      salt = Uint8List.fromList(List.generate(32, (index) => index));
      inputFile = 'test_input.txt';
      encryptedOutputFile = 'test_encrypted.txt';
      decryptedOutputFile = 'test_decrypted.txt';
      oldEncryptedFile = 'test/test_input.enc';
      oldDecryptedFile = 'test/test_input.txt';
      testFile = File(inputFile);
      originalData = List.generate(1000, (index) => index % 256);

      // Create a test file with some data to encrypt
      testFile.writeAsBytesSync(Uint8List.fromList(originalData));
    });

    tearDown(() async {
      // Clean up files after tests
      if ((await FileSystemEntity.type(inputFile)) !=
          FileSystemEntityType.notFound) {
        await File(inputFile).delete();
      }
      if ((await FileSystemEntity.type(encryptedOutputFile)) !=
          FileSystemEntityType.notFound) {
        await File(encryptedOutputFile).delete();
      }
      if ((await FileSystemEntity.type(decryptedOutputFile)) !=
          FileSystemEntityType.notFound) {
        await File(decryptedOutputFile).delete();
      }
      if ((await FileSystemEntity.type(oldDecryptedFile)) !=
          FileSystemEntityType.notFound) {
        await File(oldDecryptedFile).delete();
      }
    });

    test('File encryption produces a file with salt and encrypted data', () async {
      await encryptFile(inputFile, encryptedOutputFile, password);

      // Verify that the file was created
      expect(File(encryptedOutputFile).existsSync(), isTrue);

      // Verify that the file contains the salt and encrypted data
      final encryptedBytes = await File(encryptedOutputFile).readAsBytes();
      expect(encryptedBytes.length, greaterThan(32)); // Salt + encrypted data
      expect(encryptedBytes.sublist(0, 32), isNot(equals(salt))); // Random salt is different
    });

    test('File decryption recovers original data', () async {
      // Assuming that the `encryptFile` has already been tested successfully:
      await encryptFile(inputFile, encryptedOutputFile, password);

      // Now let's decrypt and compare the original data vs decrypted data
      await decryptFile(encryptedOutputFile, decryptedOutputFile, password);

      final decryptedBytes = await File(decryptedOutputFile).readAsBytes();
      expect(decryptedBytes, equals(originalData));
    });

    test('File decryption recovers old encrypted data', () async {
      await decryptFile(oldEncryptedFile, oldDecryptedFile, password);

      final decryptedBytes = await File(oldDecryptedFile).readAsBytes();
      String str = String.fromCharCodes(decryptedBytes);
      expect(str, equals("hello\n"));
    });
  });
}
