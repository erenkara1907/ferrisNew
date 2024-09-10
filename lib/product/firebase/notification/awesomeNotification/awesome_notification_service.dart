// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ferrisfwt/product/firebase/notification/notification_constants.dart';
import 'package:ferrisfwt/product/state/container/product_state_items.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AwesomeNotificationService {
  AwesomeNotificationService._init();

  static final AwesomeNotificationService _instance =
      AwesomeNotificationService._init();

  static AwesomeNotificationService get instance => _instance;

  static final _awesomeNotifications = AwesomeNotifications();

  Future<void> init() async {
    await initializeNotificationChannel();
  }

  static void listenBackgroundNotificationActions() {
    _awesomeNotifications.setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );
  }

  static void showNotification(RemoteMessage message) {
    final title = message.notification?.title;
    final body = message.notification?.body;
    if (title != null && body != null) {
      _awesomeNotifications.createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: NotificationConsts.channelKey,
            title: title,
            body: body,
            backgroundColor: const Color(0xffF59500),
            payload: {'data': json.encode(message.data)}),
      );
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction action) async {
    {
      if (ProductStateItems.hiveDatabaseManager.getUserModel() == null) return;
      if (action.payload?.isNotEmpty ?? false) {
        // eğer bildirimle açıldıysa uygulama
        final payload = json.decode(action.payload!['data'] ?? '') as Map;
      }
    }
  }

  Future<bool> requestPermissionToSendNotifications() {
    // Uygulamadan bildirim atmak için izin istediğimiz kısım
    return _awesomeNotifications.requestPermissionToSendNotifications(
      channelKey: NotificationConsts.channelKey,
      permissions: [
        NotificationPermission.Sound,
        NotificationPermission.Alert,
        NotificationPermission.Light,
        NotificationPermission.Badge,
        NotificationPermission.Vibration,
      ],
    );
  }

  Future<List<NotificationPermission>> checkPermissionList() {
    return _awesomeNotifications.checkPermissionList(
      channelKey: NotificationConsts.channelKey,
      permissions: [
        NotificationPermission.Alert,
        NotificationPermission.Sound,
        NotificationPermission.Light,
        NotificationPermission.Badge,
        NotificationPermission.Vibration,
      ],
    );
  }

  Future<void> initializeNotificationChannel() async {
    await _awesomeNotifications.initialize(
      'resource://drawable/res_app_icon',
      [
        NotificationChannel(
          channelGroupKey: NotificationConsts.channelKey,
          channelKey: NotificationConsts.channelKey,
          channelName: NotificationConsts.channelName,
          channelShowBadge: true,
          criticalAlerts: true,
          importance: NotificationImportance.High,
          channelDescription: NotificationConsts.channelDescription,
        ),
      ],
    );
  }
}
