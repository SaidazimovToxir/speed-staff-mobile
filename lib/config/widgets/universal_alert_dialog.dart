import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:speed_staff_mobile/config/widgets/custom_text.dart';


// Alert turini bildiradigan enum
enum AlertType { error, success, info, warning }

// Alert dialogni ko'rsatadigan class
class UniversalAlertDialog {
  // Alert dialog stilini sozlash uchun konfiguratsiya
  static AlertConfig config = AlertConfig();

  // Alert dialog ko'rsatish uchun asosiy metod
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    AlertType type = AlertType.info,
    List<AlertAction>? actions,
    bool barrierDismissible = true,
    Widget? content,
    bool useRootNavigator = true,
  }) async {
    // Platforma bo'yicha dialog ko'rsatish
    if (Platform.isIOS && config.usePlatformSpecificDesign) {
      return _showCupertinoDialog<T>(
        context: context,
        title: title,
        message: message,
        type: type,
        actions: actions,
        barrierDismissible: barrierDismissible,
        content: content,
        useRootNavigator: useRootNavigator,
      );
    } else {
      return _showMaterialDialog<T>(
        context: context,
        title: title,
        message: message,
        type: type,
        actions: actions,
        barrierDismissible: barrierDismissible,
        content: content,
        useRootNavigator: useRootNavigator,
      );
    }
  }

  // Material Design dialog ko'rsatish
  static Future<T?> _showMaterialDialog<T>({
    required BuildContext context,
    required String title,
    required String message,
    AlertType type = AlertType.info,
    List<AlertAction>? actions,
    bool barrierDismissible = true,
    Widget? content,
    bool useRootNavigator = true,
  }) {
    final List<Widget> dialogActions = _buildMaterialActions(context, actions);

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              _getIconForType(type, isMaterial: true),
              const SizedBox(width: 10),
              Expanded(child: CustomText(text: title, style: config.titleStyle)),
            ],
          ),
          content: content ?? CustomText(text: message, style: config.messageStyle),
          backgroundColor: config.backgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(config.borderRadius)),
          actions: dialogActions,
        );
      },
    );
  }

  // Cupertino (iOS) dialog ko'rsatish
  static Future<T?> _showCupertinoDialog<T>({
    required BuildContext context,
    required String title,
    required String message,
    AlertType type = AlertType.info,
    List<AlertAction>? actions,
    bool barrierDismissible = true,
    Widget? content,
    bool useRootNavigator = true,
  }) {
    final List<Widget> dialogActions = _buildCupertinoActions(context, actions);

    return showCupertinoDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: CustomText(text: title, style: config.titleStyle),
          content:
              content ??
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: CustomText(text: message, style: config.messageStyle),
              ),
          actions: dialogActions,
        );
      },
    );
  }

  // Material Design tugmalarini yaratish
  static List<Widget> _buildMaterialActions(BuildContext context, List<AlertAction>? actions) {
    if (actions == null || actions.isEmpty) {
      return [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: config.primaryColor),
          child: CustomText(text: config.defaultButtonText),
        ),
      ];
    }

    return actions.map((action) {
      return TextButton(
        onPressed: () {
          if (action.onPressed != null) {
            action.onPressed!();
          } else {
            Navigator.of(context).pop(action.value);
          }
        },
        style: TextButton.styleFrom(
          foregroundColor: action.isDefaultAction ? config.primaryColor : null,
          backgroundColor: action.isDestructiveAction ? config.destructiveColor.withValues(alpha: 0.1) : null,
        ),
        child: CustomText(text: action.text),
      );
    }).toList();
  }

  // Cupertino (iOS) tugmalarini yaratish
  static List<Widget> _buildCupertinoActions(BuildContext context, List<AlertAction>? actions) {
    if (actions == null || actions.isEmpty) {
      return [CupertinoDialogAction(onPressed: () => Navigator.of(context).pop(), isDefaultAction: true, child: CustomText(text: config.defaultButtonText))];
    }

    return actions.map((action) {
      return CupertinoDialogAction(
        onPressed: () {
          if (action.onPressed != null) {
            action.onPressed!();
          } else {
            Navigator.of(context).pop(action.value);
          }
        },
        isDefaultAction: action.isDefaultAction,
        isDestructiveAction: action.isDestructiveAction,
        child: CustomText(text: action.text),
      );
    }).toList();
  }

  // Alert turi uchun ikonka
  static Widget _getIconForType(AlertType type, {required bool isMaterial}) {
    IconData iconData;
    Color color;

    switch (type) {
      case AlertType.error:
        iconData = isMaterial ? Icons.error_outline : CupertinoIcons.exclamationmark_circle;
        color = config.errorColor;
        break;
      case AlertType.success:
        iconData = isMaterial ? Icons.check_circle_outline : CupertinoIcons.check_mark_circled;
        color = config.successColor;
        break;
      case AlertType.warning:
        iconData = isMaterial ? Icons.warning_amber_outlined : CupertinoIcons.exclamationmark_triangle;
        color = config.warningColor;
        break;
      case AlertType.info:
        iconData = isMaterial ? Icons.info_outline : CupertinoIcons.info_circle;
        color = config.infoColor;
        break;
    }

    return Icon(iconData, color: color, size: config.iconSize);
  }

  // Xatolik dialogni ko'rsatish uchun qisqa metod
  static Future<T?> showError<T>({
    required BuildContext context,
    required String title,
    required String message,
    List<AlertAction>? actions,
    bool barrierDismissible = true,
  }) {
    return show<T>(context: context, title: title, message: message, type: AlertType.error, actions: actions, barrierDismissible: barrierDismissible);
  }

  // Muvaffaqiyat dialogni ko'rsatish uchun qisqa metod
  static Future<T?> showSuccess<T>({
    required BuildContext context,
    required String title,
    required String message,
    List<AlertAction>? actions,
    bool barrierDismissible = true,
  }) {
    return show<T>(context: context, title: title, message: message, type: AlertType.success, actions: actions, barrierDismissible: barrierDismissible);
  }

  // Ogohlantirish dialogni ko'rsatish uchun qisqa metod
  static Future<T?> showWarning<T>({
    required BuildContext context,
    required String title,
    required String message,
    List<AlertAction>? actions,
    bool barrierDismissible = true,
  }) {
    return show<T>(context: context, title: title, message: message, type: AlertType.warning, actions: actions, barrierDismissible: barrierDismissible);
  }

  // Ma'lumot dialogni ko'rsatish uchun qisqa metod
  static Future<T?> showInfo<T>({
    required BuildContext context,
    required String title,
    required String message,
    List<AlertAction>? actions,
    bool barrierDismissible = true,
  }) {
    return show<T>(context: context, title: title, message: message, type: AlertType.info, actions: actions, barrierDismissible: barrierDismissible);
  }
}

// Alert dialog uchun tugma
class AlertAction<T> {
  final String text;
  final T? value;
  final Function? onPressed;
  final bool isDefaultAction;
  final bool isDestructiveAction;

  AlertAction({required this.text, this.value, this.onPressed, this.isDefaultAction = false, this.isDestructiveAction = false});
}

// Alert dialog stilini sozlash uchun class
class AlertConfig {
  Color primaryColor;
  Color errorColor;
  Color successColor;
  Color warningColor;
  Color infoColor;
  Color destructiveColor;
  Color backgroundColor;
  double borderRadius;
  double iconSize;
  String defaultButtonText;
  TextStyle? titleStyle;
  TextStyle? messageStyle;
  bool usePlatformSpecificDesign;

  AlertConfig({
    this.primaryColor = Colors.blue,
    this.errorColor = Colors.red,
    this.successColor = Colors.green,
    this.warningColor = Colors.orange,
    this.infoColor = Colors.blue,
    this.destructiveColor = Colors.red,
    this.backgroundColor = Colors.white,
    this.borderRadius = 10.0,
    this.iconSize = 24.0,
    this.defaultButtonText = 'OK',
    this.titleStyle,
    this.messageStyle,
    this.usePlatformSpecificDesign = true,
  });
}
