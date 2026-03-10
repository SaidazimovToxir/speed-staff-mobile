import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:go_router/go_router.dart';

class EmployerProfileHeader extends StatelessWidget {
  final Map<String, dynamic> data;

  const EmployerProfileHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final name = data['name'] ?? 'The Golden Grill';
    final location = data['location'] ?? 'Tashkent, Uzbekistan';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Cover image ──────────────────────────────────
        CustomImageView(
          imagePath: "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800",
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
        ),

        // ── Dark gradient overlay (bottom half) ───────────
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.7),
              ],
              stops: const [0.4, 1.0],
            ),
          ),
        ),

        // ── Top controls: back + share buttons ─────────────
        Positioned(
          top: MediaQuery.paddingOf(context).top + 12,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _iconButton(
                icon: Icons.arrow_back_rounded,
                onTap: () {
                  if (context.canPop()) context.pop();
                },
              ),
              _iconButton(
                icon: Icons.share_outlined,
                onTap: () {},
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(Icons.restaurant, color: AppColors.cF9A405, size: 26),
                ),
              ),
              12.g,
              // Name + address
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: name,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    2.g,
                    CustomText(
                      text: location,
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
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
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
