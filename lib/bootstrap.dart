import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:speedest_logistics/app/presentation/theme/app_colors.dart';
import 'package:speedest_logistics/locator.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  print('Got a message whilst in the print!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }
  // if (!AwesomeStringUtils.isNullOrEmpty(message.notification?.title,
  //         considerWhiteSpaceAsEmpty: true) ||
  //     !AwesomeStringUtils.isNullOrEmpty(message.notification?.body,
  //         considerWhiteSpaceAsEmpty: true)) {
  //   print('message also contained a notification: ${message.notification}');

  //   String? imageUrl;
  //   imageUrl ??= message.notification!.android?.imageUrl;
  //   imageUrl ??= message.notification!.apple?.imageUrl;

  //   Map<String, dynamic> notificationAdapter = {
  //     NOTIFICATION_CHANNEL_KEY: 'basic_channel',
  //     NOTIFICATION_ID: message.data[NOTIFICATION_CONTENT]?[NOTIFICATION_ID] ??
  //         message.messageId ??
  //         Random().nextInt(2147483647),
  //     NOTIFICATION_TITLE: message.data[NOTIFICATION_CONTENT]
  //             ?[NOTIFICATION_TITLE] ??
  //         message.notification?.title,
  //     NOTIFICATION_BODY: message.data[NOTIFICATION_CONTENT]
  //             ?[NOTIFICATION_BODY] ??
  //         message.notification?.body,
  //     NOTIFICATION_LAYOUT:
  //         AwesomeStringUtils.isNullOrEmpty(imageUrl) ? 'Default' : 'BigPicture',
  //     NOTIFICATION_BIG_PICTURE: imageUrl
  //   };

  //   AwesomeNotifications().createNotificationFromJsonData(notificationAdapter);
  // } else {
  //   AwesomeNotifications().createNotificationFromJsonData(message.data);
  // }
}

/// Bootstrap is responsible for any common setup and calls
/// [runApp] with the widget returned by [builder] in an error zone.
Future<void> bootstrap({
  required Widget Function() builder,
}) async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // AwesomeNotifications().initialize(
      //   null,
      //   [
      //     NotificationChannel(
      //       channelGroupKey: 'deliveries',
      //       channelKey: 'delivery_boy',
      //       channelName: 'Alarms Channel',
      //       channelDescription: 'Channel with alarm ringtone',
      //       defaultColor: AppColors.primary,
      //       importance: NotificationImportance.Max,
      //       ledColor: AppColors.primary,
      //       channelShowBadge: true,
      //       locked: true,
      //       defaultRingtoneType: DefaultRingtoneType.Alarm,
      //     ),
      //   ],
      //   channelGroups: [
      //     NotificationChannelGroup(
      //       channelGroupName: 'Deliveries',
      //       channelGroupKey: 'deliveries',
      //     ),
      //   ],
      //   debug: true,
      // );

      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      FirebaseMessaging messaging = FirebaseMessaging.instance;

      if (!Platform.isAndroid) {
        NotificationSettings settings = await messaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        log('User granted permission: ${settings.authorizationStatus}');
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        log('Got a message whilst in the foreground!');
        log('Message data: ${message.data}');

        if (message.notification != null) {
          log('Message also contained a notification: ${message.notification}');
        }
      });

      setupLocator();
      runApp(builder());
    },
    (error, stack) => log(
      error.toString(),
      stackTrace: stack,
      error: error,
    ),
  );
}
