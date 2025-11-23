import 'package:equatable/equatable.dart';

class WalletEntity extends Equatable {
  final String address;
  final double balance;

  const WalletEntity({
    required this.address,
    required this.balance,
  });

  @override
  List<Object?> get props => [address, balance];
}
