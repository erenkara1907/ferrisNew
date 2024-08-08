import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SuccessfulPopUp extends StatelessWidget {
  const SuccessfulPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Lottie.asset(
        'assets/lottie/fr_loading.json',
        width: 200,
        height: 200,
        fit: BoxFit.contain,
      ),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: Text('Exit'))
      ],
    );
  }
}
