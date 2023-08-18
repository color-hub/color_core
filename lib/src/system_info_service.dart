import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

enum SystemPlatform {
  web,
  macOS,
  android,
  iOS,
  windows,
  unknown,
}

class SystemInfoService {
  SystemInfoService({
    required this.platform,
    required this.packageVersion,
    required this.buildNumber,
    required this.iOSVersion,
    required this.androidSdk,
  });

  static Future<SystemInfoService> init() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    SystemPlatform platform = SystemPlatform.unknown;
    if (kIsWeb) {
      platform = SystemPlatform.web;
    } else {
      if (Platform.isAndroid) platform = SystemPlatform.android;
      if (Platform.isIOS) platform = SystemPlatform.iOS;
      if (Platform.isMacOS) platform = SystemPlatform.macOS;
      if (Platform.isWindows) platform = SystemPlatform.windows;
    }

    final int? iOSVersion = await getIOSVersion();
    final int? androidSdk = await getAndroidSdkVersion();

    return SystemInfoService(
      platform: platform,
      packageVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      iOSVersion: iOSVersion ?? 0,
      androidSdk: androidSdk ?? 0,
    );
  }

  final SystemPlatform platform;
  final String packageVersion;
  final String buildNumber;
  final int iOSVersion;
  final int androidSdk;

  static Future<int?> getIOSVersion() async {
    if (!kIsWeb && Platform.isIOS) {
      final IosDeviceInfo iosInfo = await DeviceInfoPlugin().iosInfo;

      return int.tryParse(iosInfo.systemVersion.substring(0, 2));
    }

    return null;
  }

  static Future<int?> getAndroidSdkVersion() async {
    if (!kIsWeb && Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;

      return androidInfo.version.sdkInt;
    }

    return null;
  }

  String get appVersion => '$packageVersion ($buildNumber)';

  bool get isSystemThemeAvailable => kIsWeb || iOSVersion > 12 || androidSdk > 28;

  String get platformString => platform.name;

  String get emailDescription => '$platformString $appVersion';
}
