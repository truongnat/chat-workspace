import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../data/datasources/web3_remote_data_source.dart';
import '../../data/repositories/wallet_repository_impl.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';

// --- Providers ---

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final web3RemoteDataSourceProvider = Provider<Web3RemoteDataSource>((ref) {
  return Web3RemoteDataSourceImpl();
});

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepositoryImpl(
    secureStorage: ref.watch(flutterSecureStorageProvider),
    remoteDataSource: ref.watch(web3RemoteDataSourceProvider),
  );
});

final walletControllerProvider = StateNotifierProvider<WalletController, AsyncValue<WalletEntity?>>((ref) {
  return WalletController(ref.watch(walletRepositoryProvider));
});

// --- Controller ---

class WalletController extends StateNotifier<AsyncValue<WalletEntity?>> {
  final WalletRepository _repository;

  WalletController(this._repository) : super(const AsyncValue.loading()) {
    loadWallet();
  }

  Future<void> loadWallet() async {
    state = const AsyncValue.loading();
    try {
      final address = await _repository.getAddress();
      if (address != null) {
        final balance = await _repository.getBalance();
        state = AsyncValue.data(WalletEntity(address: address, balance: balance));
      } else {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createWallet() async {
    state = const AsyncValue.loading();
    try {
      final wallet = await _repository.createWallet();
      state = AsyncValue.data(wallet);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<String?> getMnemonic() async {
    return await _repository.getMnemonic();
  }
}
