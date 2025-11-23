import '../../../../core/config/app_config.dart';

abstract class Web3RemoteDataSource {
  Future<double> getBalance(String address);
}

class Web3RemoteDataSourceImpl implements Web3RemoteDataSource {
  final Web3Client _client;

  Web3RemoteDataSourceImpl({Web3Client? client})
      : _client = client ?? Web3Client(AppConfig.rpcUrl, Client());

  @override
  Future<double> getBalance(String address) async {
    final ethereumAddress = EthereumAddress.fromHex(address);
    final amount = await _client.getBalance(ethereumAddress);
    return amount.getValueInUnit(EtherUnit.ether);
  }
}
