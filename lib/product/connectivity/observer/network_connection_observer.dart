import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:ferrisfwt/product/widget/dialog/network_dialog_widget.dart';
import 'package:flutter/material.dart';

final class InternetConnectionObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      ProductStateItems.networkFailures
          .startMonitoringConnectivity((isConnected) {
        if (!isConnected) {
          NotConnectedToInternetDialog.show(ProductStateItems
              .appRouter.router.routerDelegate.navigatorKey.currentContext!);
        }
        return;
      });
    }
  }
}
