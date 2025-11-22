import 'dart:typed_data';

class KeyPair {
  final Uint8List pk;
  final Uint8List sk;

  KeyPair({required this.pk, required this.sk});
}

abstract class CryptoService {
  /// Generates a new KeyPair, saves the Private Key to Secure Storage,
  /// and returns the Public Key as a Base64 string.
  Future<String> generateAndSaveKeys();

  /// Retrieves the stored Public Key as a Base64 string.
  Future<String?> getMyPublicKey();

  /// Encrypts a message for a recipient.
  /// [plaintext] is the message to encrypt.
  /// [recipientPublicKeyBase64] is the recipient's Public Key.
  /// Returns Base64(Nonce + Ciphertext).
  Future<String> encryptForUser(String plaintext, String recipientPublicKeyBase64);

  /// Decrypts a message from a sender.
  /// [ciphertextBase64] is the Base64(Nonce + Ciphertext) string.
  /// [senderPublicKeyBase64] is the sender's Public Key.
  /// Returns the decrypted plaintext.
  Future<String> decryptFromUser(String ciphertextBase64, String senderPublicKeyBase64);
}
