import 'package:easy_localization/easy_localization.dart';
import 'package:ferrisfwt/feature/home/presentation/bloc/home_bloc.dart';
import 'package:ferrisfwt/product/extensions/context_extensions.dart';
import 'package:ferrisfwt/product/firebase/notification/notification_service.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FCMManager {
  final List<int> _notificationJobIds = [];

  setFCMUp() {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> setupInteractedMessage({
    required BuildContext context,
  }) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(
        message: initialMessage,
        context: context,
      );
    }
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(
        message: message,
        context: context,
      );
    });
  }

  Future<void> _handleMessage({
    required RemoteMessage message,
    required BuildContext context,
  }) async {
    _onJobAssignmentAnnouncement(
      context: context,
      message: message,
    );
  }

  String _formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    return dateFormat.format(dateTime);
  }

  void _onJobAssignmentAnnouncement({
    required BuildContext context,
    required RemoteMessage message,
  }) async {
    // show the dialog and wait for the user to confirm the job
    final data = JobAssignmentAnnouncementData.fromMap(message.data);
    if (data.jobId == null) throw ArgumentError('jobId is null');
    if (_notificationJobIds.contains(data.jobId)) return;
    _notificationJobIds.add(data.jobId!);
    showDialog(
      context: ProductStateItems.appRouter.router.routerDelegate.navigatorKey
          .currentContext as BuildContext,
      builder: (context) {
        return AlertDialog(
          backgroundColor: context.theme.colorScheme.surface,
          title: Text(
            'Confirm Job',
            style: context.textTheme.titleLarge
                ?.copyWith(color: context.theme.colorScheme.primaryContainer),
          ),
          content: SizedBox(
            height: context.dynamicHeight(0.35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Reg Number: ',
                      style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.primary),
                    ),
                    Text(
                      '${data.regNumber}',
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: context.theme.colorScheme.primary),
                    )
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                Row(
                  children: [
                    Text(
                      'Date: ',
                      style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.primary),
                    ),
                    Text(
                      _formatDate(
                          data.scheduleDate ?? DateTime.now().toString()),
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: context.theme.colorScheme.primary),
                    )
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                Row(
                  children: [
                    Text(
                      'Movement Type: ',
                      style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.primary),
                    ),
                    Text(
                      data.movementTypeName!,
                      style: context.textTheme.bodyMedium
                          ?.copyWith(color: context.theme.colorScheme.primary),
                    )
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'From: ',
                        style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.primary),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        '${data.startAddress}',
                        style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.colorScheme.primary),
                      ),
                    )
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'To: ',
                        style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.theme.colorScheme.primary),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        '${data.endAddress}',
                        style: context.textTheme.bodyMedium?.copyWith(
                            color: context.theme.colorScheme.primary),
                      ),
                    )
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: context.textTheme.bodyLarge?.copyWith(
                    color: context.theme.colorScheme.primaryContainer),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: context.theme.colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size(
                      context.dynamicWidth(0.07), context.dynamicHeight(0.04))),
              onPressed: () {
                Navigator.pop(context);
                context.read<HomeBloc>().add(ConfirmJob(data.jobId!, false));
              },
              child: Text(
                'Confirm',
                style:
                    context.textTheme.bodyLarge?.copyWith(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    // abort the progress according to dialog result or send the
    // confirmation request to the server

    // if main jobs are loaded, replace the job with the confirmed status
    //burda modelin statusu copywith ile trueya çek
  }

  Future<String?> getToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  // singleton
  static FCMManager? _instance;

  factory FCMManager() => _instance ??= FCMManager._internal();

  FCMManager._internal();
}
