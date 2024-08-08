import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import '../../utility/size/index.dart';

class SheetGapDivider extends StatelessWidget {
  const SheetGapDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      indent: context.dynamicWidth(.4),
      endIndent: context.dynamicWidth(.4),
      thickness: WidgetSizes.spacingXxs,
    );
  }
}
