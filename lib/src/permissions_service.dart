import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsService {
  static Future<PermissionStatus> requestCameraPermission() async {
    if (!kIsWeb) {
      return await Permission.camera.request();
    }

    return PermissionStatus.granted;
  }

  static Future<PermissionStatus> requestPhotosPermission(int androidSdk) async {
    if (!kIsWeb) {
      if (Platform.isIOS || androidSdk >= 33) {
        return await Permission.photos.request();
      } else {
        return await Permission.storage.request();
      }
    }

    return PermissionStatus.granted;
  }
}
