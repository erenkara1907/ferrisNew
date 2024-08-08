import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ferrisfwt/product/connectivity/manager/network_manager.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/utility/enums/network_result.dart';

extension NetworkResultExtension on NetworkResult {
  static NetworkResult checkConnectivityResult(ConnectivityResult result) {
    return result == ConnectivityResult.none
        ? NetworkResult.off
        : NetworkResult.on;
  }

  static StreamSubscription<ConnectivityResult> handleNetworkChange(
    NetworkCallBack onChange,
  ) {
    return ProductStateItems.connectivity.onConnectivityChanged.listen((event) {
      onChange.call(NetworkResult.checkConnectivityResult(event));
    });
  }
}
