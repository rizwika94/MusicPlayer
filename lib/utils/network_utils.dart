import 'dart:async';

import 'package:connectivity/connectivity.dart';

class NetworkUtils {
  static final NetworkUtils _singleton = new NetworkUtils._internal();
  static NetworkUtils getInstance() => _singleton;

  NetworkUtils._internal();

  static final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  static Future<bool> isInternet() async {
    var connectivityResult = await (_connectivity.checkConnectivity());
    return _updatedConnectionStatus(connectivityResult);
  }

  connectivitySubscribe(Function onChangeNetwork) {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((result) {
      onChangeNetwork(_updatedConnectionStatus(result));
    });
  }

  connectivityUnSubscribe() {
    if (_connectivitySubscription == null) return;
    _connectivitySubscription.cancel();
  }

  static bool _updatedConnectionStatus(ConnectivityResult connectivityResult) {
    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        return true;
      case ConnectivityResult.mobile:
        return true;
      default:
        return false;
    }
  }
}
