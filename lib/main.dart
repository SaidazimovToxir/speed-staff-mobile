import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/config/app.dart';

import 'config/config.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    await EasyLocalization.ensureInitialized();
    EasyLocalization.logger.enableBuildModes = [];
    Bloc.observer = MyBlocObserver();
    await init();

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    runApp(
      EasyLocalization(
        saveLocale: true,
        startLocale: const Locale("uz", "UZ"),
        supportedLocales: const [Locale("uz", "UZ"), Locale("ru", "RU"), Locale("en", "EN")],
        path: "assets/translations",
        child: const MainApp(),
      ),
    );
  } catch (e, s) {
    log("Error: $e\n\n\nStack trace: $s");
  }
}
