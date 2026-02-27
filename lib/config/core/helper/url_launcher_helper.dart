// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/widgets/universal_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> openTelegramBot(BuildContext context, {String botUsername = 'saidazimov_uz'}) async {
    final Uri telegramUrl = Uri.parse('https://t.me/$botUsername');

    try {
      final bool launched = await launchUrl(telegramUrl, mode: LaunchMode.externalApplication);

      if (!launched) {
        _showErrorDialog(context, "Telegram ilovasini ochib bo'lmadi");
      }
    } catch (e) {
      _showErrorDialog(context, "Xatolik yuz berdi: $e");
    }
  }

  static void _showErrorDialog(BuildContext context, String message) {
    UniversalAlertDialog.showError(
      context: context,
      title: 'Xatolik',
      message: message,
      actions: [
        AlertAction(
          text: 'Tushunarli',
          isDestructiveAction: false,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
