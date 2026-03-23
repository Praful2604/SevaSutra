import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  final Connectivity _connectivity = Connectivity();

  Stream<ConnectivityResult> get connectivityStream =>
      _connectivity.onConnectivityChanged;
}