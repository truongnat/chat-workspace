import '../entities/wallet_entity.dart';

abstract class WalletRepository {
  /// Creates a new wallet and securely stores the private key.
  /// Returns the created [WalletEntity] with initial balance (likely 0).
  Future<WalletEntity> createWallet();

  /// Retrieves the current balance for the stored wallet address.
  /// Returns the updated balance.
  Future<double> getBalance();

  /// Retrieves the public address of the stored wallet.
  /// Returns null if no wallet exists.
  Future<String?> getAddress();

  /// Retrieves the private key securely.
  /// WARNING: Use with caution. Should be protected by biometric/PIN in UI.
  Future<String?> getPrivateKey();
  
  /// Retrieves the mnemonic phrase securely.
  /// WARNING: Use with caution. Should be protected by biometric/PIN in UI.
  Future<String?> getMnemonic();

  /// Verifies the user's PIN.
  Future<bool> verifyPin(String pin);

  /// Sets the user's PIN.
  Future<void> setPin(String pin);

  /// Sends a transaction to the specified address.
  Future<String> sendTransaction(String to, double amount);
}
