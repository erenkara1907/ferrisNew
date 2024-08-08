import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ferrisfwt/product/extensions/network_extensions.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/network_result.dart';

typedef NetworkCallBack = void Function(NetworkResult result);

abstract interface class INetworkChangeManager {
  Future<NetworkResult> checkNetworkFirstTime();
  StreamSubscription<ConnectivityResult> handleNetworkChange(
      NetworkCallBack onChange);

  void startMonitoringConnectivity(void Function(bool) callback) {}
}

class NetworkListener implements INetworkChangeManager {
  @override
  Future<NetworkResult> checkNetworkFirstTime() async {
    final connectivityResult =
        await ProductStateItems.connectivity.checkConnectivity();
    return NetworkResultExtension.checkConnectivityResult(connectivityResult);
  }

  @override
  StreamSubscription<ConnectivityResult> handleNetworkChange(
      NetworkCallBack onChange) {
    return ProductStateItems.connectivity.onConnectivityChanged.listen((event) {
      onChange.call(NetworkResultExtension.checkConnectivityResult(event));
    });
  }

  @override
  void startMonitoringConnectivity(void Function(bool) callback) {
    handleNetworkChange((result) {
      callback(result == NetworkResult.on);
    });
  }
}
