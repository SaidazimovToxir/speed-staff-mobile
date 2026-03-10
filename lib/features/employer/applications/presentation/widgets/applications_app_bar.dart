import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:go_router/go_router.dart';

class ApplicationsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ApplicationsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          }
        },
      ),
      title: const CustomText(
        text: "Applications",
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
