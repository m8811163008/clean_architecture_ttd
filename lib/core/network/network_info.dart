import 'package:clean_architecture_ttd/core/network/data_connection.dart';

abstract class NetworkInfo {
  //creating contract
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker dataConnectionChecker;

  NetworkInfoImpl(this.dataConnectionChecker);

  @override
  // TODO: implement isConnected
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
