import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/config/core/constants/app_colors.dart';
import 'package:speed_staff_mobile/features/shared/notifications/presentation/bloc/notification_bloc.dart';
import 'package:speed_staff_mobile/features/shared/notifications/presentation/widgets/notification_tile.dart';
import 'package:speed_staff_mobile/config/widgets/custom_icon_button.dart';

import 'package:speed_staff_mobile/config/widgets/custom_text.dart';


class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        centerTitle: true,
        leading: CustomIconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const CustomText(text: "Notifications",
          style: TextStyle(color: AppColors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading || state is NotificationInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.cF9A405));
          } else if (state is NotificationError) {
            return Center(child: CustomText(text: state.message));
          } else if (state is NotificationLoaded) {
            return ListView.builder(
              itemCount: state.notifications.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return NotificationTile(notification: state.notifications[index], onTap: () {});
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
