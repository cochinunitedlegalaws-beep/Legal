import 'package:encrypt/encrypt.dart' as enc;

/// AES-256 encryption/decryption utility for Chamber documents.
/// Encrypts document content before persisting and decrypts on read.
class DocumentCrypto {
  DocumentCrypto._();

  // 32-byte AES-256 key (Cochin United Chamber internal key)
  static final _key = enc.Key.fromUtf8('CochinUnitedChamber2026SecureKy!'); // exactly 32 chars
  // 16-byte IV
  static final _iv = enc.IV.fromUtf8('CULegalIV2026!!!' ); // exactly 16 chars

  static final _encrypter = enc.Encrypter(enc.AES(_key, mode: enc.AESMode.cbc, padding: 'PKCS7'));

  /// Encrypts plain text content and returns a base64-encoded string.
  static String encryptContent(String plainText) {
    final encrypted = _encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  /// Decrypts a base64-encoded encrypted string and returns plain text.
  static String decryptContent(String encryptedBase64) {
    try {
      final decrypted = _encrypter.decrypt64(encryptedBase64, iv: _iv);
      return decrypted;
    } catch (_) {
      return '';
    }
  }
}
