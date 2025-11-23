import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

abstract class Web3RemoteDataSource {
  Future<double> getBalance(String address);
}

class Web3RemoteDataSourceImpl implements Web3RemoteDataSource {
  final Web3Client _client;

  // TODO: Move RPC URL to configuration/env
  static const String _rpcUrl = 'https://rpc.ankr.com/eth'; 

  Web3RemoteDataSourceImpl({Web3Client? client})
      : _client = client ?? Web3Client(_rpcUrl, Client());

  @override
  Future<double> getBalance(String address) async {
    final ethereumAddress = EthereumAddress.fromHex(address);
    final amount = await _client.getBalance(ethereumAddress);
    return amount.getValueInUnit(EtherUnit.ether);
  }
}
