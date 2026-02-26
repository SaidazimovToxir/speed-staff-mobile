import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/config/router/router.dart';
import 'package:toastification/toastification.dart';

import 'core/constants/constants.dart';
import 'core/providers/bloc_providers.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: MyBlocProviders.providers,
      child: ToastificationWrapper(
        child: MaterialApp.router(
          routerConfig: AppRouter.router,
          locale: context.locale,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          scrollBehavior: const MaterialScrollBehavior().copyWith(physics: const BouncingScrollPhysics()),
          theme: ThemeData(
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xFFFCDC09),
              selectionColor: Color(0xFFFCDC09),
              selectionHandleColor: Color(0xFFFCDC09),
            ),
            datePickerTheme: DatePickerThemeData(
              todayBorder: WidgetStateBorderSide.resolveWith((states) => const BorderSide(color: AppColors.c1F3C88)),
              elevation: 0,
              backgroundColor: const Color(0xFFFFFFFF),
              todayBackgroundColor: WidgetStateColor.resolveWith((states) => Colors.transparent),
              todayForegroundColor: WidgetStateColor.resolveWith((states) => Colors.black),
              headerBackgroundColor: WidgetStateColor.resolveWith((states) => AppColors.c1F3C88),
              headerForegroundColor: WidgetStateColor.resolveWith((states) => AppColors.white),
              rangePickerHeaderBackgroundColor: WidgetStateColor.resolveWith((states) => AppColors.c1F3C88),
              rangePickerHeaderForegroundColor: WidgetStateColor.resolveWith((states) => AppColors.white),
              rangePickerHeaderHeadlineStyle: const TextStyle(fontWeight: FontWeight.w500, fontFamily: "Nunito"),
              dayStyle: const TextStyle(fontWeight: FontWeight.w500, fontFamily: "Nunito"),
              weekdayStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontFamily: "Nunito"),
              cancelButtonStyle: ButtonStyle(foregroundColor: WidgetStateProperty.resolveWith((states) => Colors.red)),
              confirmButtonStyle: ButtonStyle(foregroundColor: WidgetStateProperty.resolveWith((states) => AppColors.c1F3C88)),
              dividerColor: Colors.grey,
            ),
            useMaterial3: false,
            fontFamily: "Nunito",

            // scaffoldBackgroundColor: Color(0xFF2c2c2c),
            expansionTileTheme: const ExpansionTileThemeData(
              iconColor: AppColors.c1F3C88,
              collapsedIconColor: AppColors.c1F3C88,
              collapsedShape: RoundedRectangleBorder(side: BorderSide.none),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            actionIconTheme: ActionIconThemeData(
              backButtonIconBuilder: (BuildContext context) => IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
