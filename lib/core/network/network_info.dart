abstract class NetworkInfo {
  //creating contract
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker dataConnectionChecker;

  NetworkInfoImpl(this.dataConnectionChecker);

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}

class DataConnectionChecker {
  Future<bool> get hasConnection {
    return Future.value(true);
  }
}
