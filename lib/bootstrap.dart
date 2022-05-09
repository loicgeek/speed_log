import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get_storage/get_storage.dart';
import 'package:speedest_logistics/app/presentation/theme/app_colors.dart';
import 'package:speedest_logistics/background_location_handler.dart';
import 'package:speedest_logistics/locator.dart';

String channelName = "speed_log_high_importance_channel";
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  //await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
  print('Got a message whilst in the print!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }
  FlutterRingtonePlayer.playNotification();
  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification!.title,
    message.notification!.body,
    NotificationDetails(
      android: AndroidNotificationDetails(
        channelName,
        channelName,
        importance: Importance.max,
        priority: Priority.max,
        groupKey: channelName,
        fullScreenIntent: true,
        // icon: android.smallIcon,
        // other properties...
      ),
    ),
    payload: json.encode(message.data).toString(),
  );
}

//background location

/// Bootstrap is responsible for any common setup and calls
/// [runApp] with the widget returned by [builder] in an error zone.
Future<void> bootstrap({
  required Widget Function() builder,
}) async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp();
      await GetStorage.init();

      // Set the background messaging handler early on, as a named top-level function
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);

      await flutterLocalNotificationsPlugin.initialize(
          const InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/launcher_icon"),
          ),
          onSelectNotification: onSelectedNotification);

      var channel = await _createAlertChannel(
          "speed_log_high_importance_channel", flutterLocalNotificationsPlugin);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging messaging = FirebaseMessaging.instance;

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

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        log('Foreground notificationreceived: ${message.data}');

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channelDescription: channel.description,
                  playSound: true,
                  priority: Priority.max,
                  importance: Importance.max,
                  // icon: android.smallIcon,
                  // other properties...
                ),
              ));
          FlutterRingtonePlayer.playNotification();
        }
      });

      await messaging.subscribeToTopic("all");

      setupLocator();

      await BackgroundLocationHandler.init();
      final NotificationAppLaunchDetails? notificationAppLaunchDetails =
          await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();

      if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
        notificationAppLaunchDetails!.payload;
        onSelectedNotification(notificationAppLaunchDetails.payload);
      }
      runApp(builder());
    },
    (error, stack) => log(
      error.toString(),
      stackTrace: stack,
      error: error,
    ),
  );
}

_createAlertChannel(String channelName,
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const String channelGroupId = 'com.ntech_services.speedest_logistics';
// create the group first
  AndroidNotificationChannelGroup androidNotificationChannelGroup =
      AndroidNotificationChannelGroup(
    channelGroupId,
    channelName,
    description: 'chairwatch group',
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()!
      .createNotificationChannelGroup(androidNotificationChannelGroup);

  var androidNotificationChannel = AndroidNotificationChannel(
    channelName,
    channelName,
    importance: Importance.max,
    enableVibration: true,
    groupId: channelGroupId,
    playSound: true,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
  print("CHANNEL CREATED : ${androidNotificationChannel.name}");
  return androidNotificationChannel;
}

void onSelectedNotification(String? payload) {
  print(payload);
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
