import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sodium_libs/sodium_libs.dart';
import 'crypto_service.dart';

class SodiumCryptoService implements CryptoService {
  final FlutterSecureStorage _storage;
  Sodium? _sodium;

  static const String _privateKeyKey = 'private_key';
  static const String _publicKeyKey = 'public_key';

  SodiumCryptoService(this._storage);

  Future<void> init() async {
    if (_sodium != null) return;
    _sodium = await SodiumInit.init();
  }

  @override
  Future<String> generateAndSaveKeys() async {
    await init();
    final keyPair = _sodium!.crypto.box.keyPair();

    // Save keys to storage (Base64 encoded)
    final pkBase64 = base64Encode(keyPair.pk);
    final skBase64 = base64Encode(keyPair.sk);

    await _storage.write(key: _privateKeyKey, value: skBase64);
    await _storage.write(key: _publicKeyKey, value: pkBase64);

    return pkBase64;
  }

  @override
  Future<String?> getMyPublicKey() async {
    return await _storage.read(key: _publicKeyKey);
  }

  Future<Uint8List?> _getMyPrivateKey() async {
    final skBase64 = await _storage.read(key: _privateKeyKey);
    if (skBase64 == null) return null;
    return base64Decode(skBase64);
  }

  @override
  Future<String> encryptForUser(String plaintext, String recipientPublicKeyBase64) async {
    await init();
    final mySk = await _getMyPrivateKey();
    if (mySk == null) {
      throw Exception('Private key not found. Please generate keys first.');
    }

    final recipientPk = base64Decode(recipientPublicKeyBase64);
    final messageBytes = utf8.encode(plaintext);
    final nonce = _sodium!.randombytes.buf(_sodium!.crypto.box.nonceBytes);

    final ciphertext = _sodium!.crypto.box.easy(
      message: Uint8List.fromList(messageBytes),
      nonce: nonce,
      pk: recipientPk,
      sk: mySk,
    );

    // Combine Nonce + Ciphertext
    final combined = Uint8List(nonce.length + ciphertext.length);
    combined.setAll(0, nonce);
    combined.setAll(nonce.length, ciphertext);

    return base64Encode(combined);
  }

  @override
  Future<String> decryptFromUser(String ciphertextBase64, String senderPublicKeyBase64) async {
    await init();
    final mySk = await _getMyPrivateKey();
    if (mySk == null) {
      throw Exception('Private key not found. Please generate keys first.');
    }

    final combined = base64Decode(ciphertextBase64);
    final nonceLength = _sodium!.crypto.box.nonceBytes;
    
    if (combined.length < nonceLength) {
      throw Exception('Invalid ciphertext length');
    }

    final nonce = combined.sublist(0, nonceLength);
    final ciphertext = combined.sublist(nonceLength);
    final senderPk = base64Decode(senderPublicKeyBase64);

    final decryptedBytes = _sodium!.crypto.box.openEasy(
      ciphertext: ciphertext,
      nonce: nonce,
      pk: senderPk,
      sk: mySk,
    );

    return utf8.decode(decryptedBytes);
  }
}
