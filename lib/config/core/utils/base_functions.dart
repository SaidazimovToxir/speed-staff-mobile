import 'dart:io';
import 'dart:ui';

import 'package:flutter/scheduler.dart';

final String defaultSystemLocale = Platform.localeName.split('_').first;

String get defaultLocale => switch (defaultSystemLocale) {
  'ru' => 'ru',
  'en' => 'en',
  'uz' => 'uz',
  _ => 'en',
};

String get defaultTheme => SchedulerBinding.instance.platformDispatcher.platformBrightness.name;

String get getApiLocale => switch (defaultSystemLocale) {
  'ru' => 'ru-RU',
  'en' => 'en-US',
  'uz' => 'uz-UZ',
  _ => 'uz-UZ',
};

Color hexToColor(String hexColor) {
  if (hexColor.length != 8) {
    throw FormatException('Invalid hex color: $hexColor');
  }
  return Color(int.parse(hexColor.substring(0, 6), radix: 16) + 0xFF000000);
}

String getPhoneNumber(String phoneNumber) {
  final String phone = '+998${phoneNumber.split(' ').join()}';
  return phone;
}

String getTimerTime(int seconds) {
  if (seconds == 0) {
    return '';
  }
  final int minutes = seconds ~/ 60;
  return "($minutes:${(seconds % 60).toString().padLeft(2, '0')})";
}
