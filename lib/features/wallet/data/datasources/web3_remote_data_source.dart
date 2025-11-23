import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

abstract class Web3RemoteDataSource {
  Future<double> getBalance(String address);
  Future<String> sendTransaction(String privateKeyHex, String to, double amount);
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

  @override
  Future<String> sendTransaction(String privateKeyHex, String to, double amount) async {
    final credentials = EthPrivateKey.fromHex(privateKeyHex);
    final recipient = EthereumAddress.fromHex(to);
    final amountInWei = EtherAmount.fromUnitAndValue(EtherUnit.ether, amount);

    final txHash = await _client.sendTransaction(
      credentials,
      Transaction(
        to: recipient,
        value: amountInWei,
      ),
      chainId: 1, // Ethereum mainnet
    );

    return txHash;
  }
}
