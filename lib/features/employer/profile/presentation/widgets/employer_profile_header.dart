import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

import 'package:speed_staff_mobile/features/employer/profile/domain/entities/employer_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_event.dart';

class EmployerProfileHeader extends StatelessWidget {
  final EmployerProfile data;

  const EmployerProfileHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final name = data.restaurantName;
    final location = data.address ?? 'Tashkent, Uzbekistan';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomImageView(
          imagePath: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800",
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
              stops: const [0.4, 1.0],
            ),
          ),
        ),

        Positioned(
          top: MediaQuery.paddingOf(context).top + 12,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // _iconButton(
              //   icon: Icons.arrow_back_rounded,
              //   onTap: () {
              //     if (context.canPop()) context.pop();
              //   },
              // ),
              Row(
                children: [
                  // _iconButton(icon: Icons.share_outlined, onTap: () {}),
                  // 8.g,
                  _iconButton(
                    icon: Icons.logout_outlined,
                    onTap: () {
                      context.read<AuthBloc>().add(LogoutEvent());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Restaurant name + address at cover bottom ──────
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo container
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 6)],
                ),
                child: const Center(child: Icon(Icons.restaurant, color: AppColors.cF9A405, size: 26)),
              ),
              12.g,
              // Name + address
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(text: name, fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    2.g,
                    CustomText(text: location, fontSize: 12, color: Colors.white.withValues(alpha: 0.85)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _iconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.35), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
