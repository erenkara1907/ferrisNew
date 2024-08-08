import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class CustomSingleChildScroll extends StatelessWidget {
  const CustomSingleChildScroll({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingBottomLow,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: child,
      ),
    );
  }
}
