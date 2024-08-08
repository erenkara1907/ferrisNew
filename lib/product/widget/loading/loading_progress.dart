import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: context.theme.colorScheme.outlineVariant,
      radius: 60,
      child: Lottie.asset(
        'assets/lottie/fr_loading.json',
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      ),
    );
  }
}
