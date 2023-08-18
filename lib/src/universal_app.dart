import 'dart:io';

import 'package:color_ui/color_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class UniversalApp extends StatelessWidget {
  const UniversalApp.router({
    required this.title,
    required this.localizationsDelegates,
    required this.supportedLocales,
    required this.locale,
    required this.routeInformationParser,
    required this.routerDelegate,
    required this.themeMode,
    required this.appThemeColor,
    this.routerDelegateMac,
    this.routeInformationParserMac,
    this.macThemeColor,
    super.key,
  });

  final String title;

  final Iterable<LocalizationsDelegate> localizationsDelegates;
  final Iterable<Locale> supportedLocales;
  final Locale locale;

  final RouteInformationParser<Object> routeInformationParser;
  final RouterDelegate<Object> routerDelegate;

  final ThemeMode themeMode;
  final AppThemeColor appThemeColor;

  // macOS
  final RouteInformationParser<Object>? routeInformationParserMac;
  final RouterDelegate<Object>? routerDelegateMac;
  final Color? macThemeColor;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb &&
        Platform.isMacOS &&
        routeInformationParserMac != null &&
        routerDelegateMac != null &&
        macThemeColor != null) {
          
      return MacosApp.router(
        title: title,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: false,
        routeInformationParser: routeInformationParserMac!,
        routerDelegate: routerDelegateMac!,
        theme: ColorThemeMac.lightTheme(macThemeColor!),
        darkTheme: ColorThemeMac.darkTheme(macThemeColor!),
        themeMode: themeMode,
      );
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        title: title,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        locale: locale,
        debugShowCheckedModeBanner: false,
        routeInformationParser: routeInformationParser,
        routerDelegate: routerDelegate,
        themeMode: themeMode,
        theme: ColorTheme.lightTheme(appThemeColor),
        darkTheme: ColorTheme.darkTheme(appThemeColor),
      ),
    );
  }
}
