import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class NotConnectedToInternetDialog extends StatelessWidget {
  const NotConnectedToInternetDialog({super.key});

  static Future<bool?> show(BuildContext context) async {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const NotConnectedToInternetDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Lottie.asset(
        'assets/lottie/network_error.json',
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),
      content: const Text('Please check your internet connectivity'),
      actions: [
        TextButton(
          onPressed: () async {
            context.pop();
            context.push("/");
            return;
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
