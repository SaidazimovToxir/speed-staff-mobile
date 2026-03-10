import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/auth_header.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/role_card.dart';

import 'package:speed_staff_mobile/config/config.dart';

class RoleSelectionScreen extends StatefulWidget {
  final String phone;
  final String code;

  const RoleSelectionScreen({super.key, required this.phone, required this.code});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  int _selectedRole = -1; // -1: none, 0: worker, 1: restaurant

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: CustomIconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeader(title: "role_title", subtitle: "role_subtitle"),
              32.g,
              RoleCard(
                icon: Icons.work_outline,
                title: "role_worker_title",
                subtitle: "role_worker_subtitle",
                isSelected: _selectedRole == 0,
                onTap: () => setState(() => _selectedRole = 0),
              ),
              16.g,
              RoleCard(
                icon: Icons.restaurant,
                title: "role_employer_title",
                subtitle: "role_employer_subtitle",
                isSelected: _selectedRole == 1,
                onTap: () => setState(() => _selectedRole = 1),
              ),
              const Spacer(),
              PrimaryButton(
                text: "continue_btn",
                onPressed: _selectedRole != -1
                    ? () {
                        if (_selectedRole == 0) {
                          context.push(RouteNames.registerWorkerScreen, extra: {'phone': widget.phone, 'code': widget.code});
                        } else {
                          context.push(RouteNames.registerRestaurantScreen, extra: {'phone': widget.phone, 'code': widget.code});
                        }
                      }
                    : () {},
                color: _selectedRole != -1 ? AppColors.cF9A405 : AppColors.cE0E5EC,
                textColor: _selectedRole != -1 ? AppColors.white : AppColors.c61677D,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
