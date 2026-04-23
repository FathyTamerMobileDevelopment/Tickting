import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';

abstract class EncryptionService {
  String encryptData(Uint8List data, String keyString);
}

class EncryptionServiceImpl implements EncryptionService {
  @override
  String encryptData(Uint8List data, String keyString) {
    final key = encrypt.Key.fromUtf8(keyString.padRight(32).substring(0, 32));
    final iv = encrypt.IV.fromLength(16);

    final encrypter = encrypt.Encrypter(
      encrypt.AES(key, mode: encrypt.AESMode.cbc),
    );

    final encrypted = encrypter.encryptBytes(data, iv: iv);
    final combined = iv.bytes + encrypted.bytes;

    return Base64Encoder().convert(combined);
  }
}

