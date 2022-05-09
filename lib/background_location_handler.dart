import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/settings/android_settings.dart';
import 'package:background_locator/settings/ios_settings.dart';
import 'package:background_locator/settings/locator_settings.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:speedest_logistics/profile/data/profile_repository.dart';

import 'app/data/api_client.dart';

class BackgroundLocationHandler {
  static const String _isolateName = "LocatorIsolate";
  static ReceivePort port = ReceivePort();

  static void callback(LocationDto locationDto) async {
    try {
      final SendPort? send = IsolateNameServer.lookupPortByName(_isolateName);
      send?.send(locationDto);
      print(locationDto);
      if (Platform.isAndroid) PathProviderAndroid.registerWith();
      if (Platform.isIOS) PathProviderIOS.registerWith();
      await GetStorage.init();
      var userId = GetStorage().read("user_id");
      print(userId);
      var repo = ProfileRepository(ApiClient());
      await repo.updateProfile(
        userId: userId,
        lat: locationDto.latitude,
        long: locationDto.latitude,
      );
      print("location updated");
    } catch (e) {
      print(e);
    }
  }

//Optional
  static void notificationCallback() {
    print('User clicked on the notification');
  }

  static Future<bool> checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        final permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationAlways,
        );
        if (permission == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }

      case PermissionStatus.granted:
        return true;
      default:
        return false;
    }
  }

  static Future<void> init() async {
    // try {
    //   IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    //   port.listen((dynamic data) {
    //     // do something with data
    //   });
    // } catch (e) {
    //   print(e);
    // }
    await BackgroundLocator.initialize();
  }

  static stopLocationService() {
    IsolateNameServer.removePortNameMapping(_isolateName);
    BackgroundLocator.unRegisterLocationUpdate();
  }

  static startLocationService() async {
    if (!(await checkLocationPermission())) {
      throw Exception("Permission denied");
      return;
    }
    await BackgroundLocationHandler.init();
    BackgroundLocator.registerLocationUpdate(
      BackgroundLocationHandler.callback,
      // initCallback: BackgroundLocationHandler.initCallback,
      //initDataCallback: data,
      // disposeCallback: LocationCallbackHandler.disposeCallback,
      autoStop: false,
      iosSettings: const IOSSettings(
          accuracy: LocationAccuracy.NAVIGATION, distanceFilter: 0),
      androidSettings: const AndroidSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: 5,
        distanceFilter: 0,
        androidNotificationSettings: AndroidNotificationSettings(
          notificationChannelName: 'Location tracking',
          notificationTitle: 'Start Location Tracking',
          notificationMsg: 'Track location in background',
          notificationBigMsg:
              'Background location is on to keep the app up-tp-date with your location. This is required for main features to work properly when the app is not running.',
          notificationIcon: '',
          // notificationIconColor: Colors.grey,
          notificationTapCallback:
              BackgroundLocationHandler.notificationCallback,
        ),
      ),
    );
  }
}
