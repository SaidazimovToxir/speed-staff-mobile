import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../../../config/core/constants/app_colors.dart';
import '../../../../config/core/widgets/primary_button.dart';
import '../widgets/auth_header.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

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
        leading: IconButton(
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
              const AuthHeader(
                title: "Who are you?",
                subtitle: "Choose your role to get started",
              ),
              32.g,
              _buildRoleCard(
                index: 0,
                icon: Icons.work_outline,
                title: "I'm looking for work",
                subtitle: "Waiter • Bartender • Cook • and more",
              ),
              16.g,
              _buildRoleCard(
                index: 1,
                icon: Icons.restaurant,
                title: "I'm hiring staff",
                subtitle: "Post vacancies • Find workers fast",
              ),
              const Spacer(),
              PrimaryButton(
                text: "Continue",
                onPressed: _selectedRole != -1
                    ? () {
                        // Pass role or handle state
                        context.push('/onboarding_screen');
                      }
                    : () {}, // disabled state visually if we wanted, but keeping simple
                color: _selectedRole != -1 ? AppColors.cF9A405 : AppColors.cE0E5EC,
              ),
              16.g,
              const Center(
                child: Text(
                  "Step 1 of 3",
                  style: TextStyle(color: AppColors.c61677D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedRole == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cF9A405.withOpacity(0.05) : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.cF9A405 : AppColors.cE0E5EC,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.cF9A405.withOpacity(0.2) : AppColors.cF6F6F6,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppColors.cF9A405 : AppColors.c61677D,
              ),
            ),
            16.g,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  4.g,
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.c61677D,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.cF9A405 : AppColors.cE0E5EC,
            ),
          ],
        ),
      ),
    );
  }
}
