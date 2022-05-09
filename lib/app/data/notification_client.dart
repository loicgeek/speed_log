import 'dart:convert';

import 'package:appwrite/models.dart';
import 'package:speedest_logistics/app/data/api_client.dart';

class NotificationClient {
  late ApiClient client;
  NotificationClient(this.client);
  send({
    required String title,
    required String body,
    String? topic,
    String? token,
    Map<String, dynamic> data = const {},
  }) async {
    try {
      var message = {};
      if (topic != null) {
        message["topic"] = topic;
      }
      if (token != null) {
        message["token"] = token;
      }
      message = {
        ...message,
        "data": {
          "title": title,
          "body": body,
          ...data,
        },
        "notification": {
          "title": title,
          "body": body,
        },

        // Set Android priority to "high"
        "android": {
          "priority": "high",
        },
        // Add APNS (Apple) config
        "apns": {
          "payload": {
            "aps": {
              "contentAvailable": true,
            },
          },
          "headers": {
            "apns-push-type": "background",
            "apns-priority":
                "5", // Must be `5` when `contentAvailable` is set to true.
            "apns-topic":
                "io.flutter.plugins.firebase.messaging", // bundle identifier
          },
        },
      };

      String value = jsonEncode(message);

      Execution execution = await client.functions.createExecution(
        functionId: "627404150fbfe032a98d",
        data: jsonEncode(message),
      );
      print(execution);
    } catch (e) {
      print(e);
    }
  }
}
