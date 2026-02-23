import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityRepository {
  final Connectivity _connectivity = Connectivity();

  Stream<bool> get onConnectivityChanged => 
    _connectivity.onConnectivityChanged.map(
      (result) => result != ConnectivityResult.none
    );

  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }
}