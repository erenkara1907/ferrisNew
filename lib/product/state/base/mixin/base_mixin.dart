import 'package:ferrisfwt/product/utility/enums/view_status.dart';
import 'package:flutter/material.dart';

abstract class BaseMixin<T extends StatefulWidget> extends State<T> {
  Widget responseStatus(
      {required ViewStatus state,
      required Widget successChild,
      Widget? errorChild}) {
    errorChild = errorChild ??
        const Center(
          child: Text('failed to fetch products'),
        );
    switch (state) {
      case ViewStatus.loading:
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      case ViewStatus.failure:
        return Center(
          child: errorChild,
        );
      case ViewStatus.success:
        return successChild;
    }
  }
}
