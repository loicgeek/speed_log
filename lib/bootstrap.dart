import 'dart:async';
import 'dart:developer';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/widgets.dart';
import 'package:test_app_write/locator.dart';

/// Bootstrap is responsible for any common setup and calls
/// [runApp] with the widget returned by [builder] in an error zone.
Future<void> bootstrap({
  required Widget Function() builder,
}) async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    setupLocator();

    runApp(builder());
  }, (error, stack) => log(error.toString(), stackTrace: stack, error: error));
}
