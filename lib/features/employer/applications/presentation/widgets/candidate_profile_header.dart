import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';

class CandidateProfileHeader extends StatelessWidget {
  final CandidateEntity candidate;
  const CandidateProfileHeader({super.key, required this.candidate});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.cF9A405.withValues(alpha: 0.2), width: 2),
            ),
            child: CircleAvatar(
              radius: 56,
              backgroundColor: AppColors.c1F3C88.withValues(alpha: 0.1),
              backgroundImage: NetworkImage(
                'https://ui-avatars.com/api/?name=${candidate.name}&background=random&size=256',
              ),
              onBackgroundImageError: (_, __) {},
            ),
          ),
          20.g,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: candidate.name,
                fontSize: 26,
                fontWeight: FontWeight.w800,
              ),
              8.g,
              const Icon(Icons.verified_rounded, color: Colors.blue, size: 22),
            ],
          ),
          6.g,
          CustomText(
            text: candidate.role ?? "Senior Barista",
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
          12.g,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_rounded, color: Colors.grey, size: 16),
              6.g,
              CustomText(
                text: "Tashkent, Uzbekistan",
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          24.g,
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: "Shortlist",
                  onPressed: () {},
                  height: 48,
                  isOutlined: true,
                ),
              ),
              16.g,
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.mail_outline_rounded, size: 18),
                        10.g,
                        const CustomText(text: "Message", fontSize: 14, fontWeight: FontWeight.w700),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          32.g,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoCard(context, Icons.star_rounded, AppColors.cF9A405, "Rating", "${candidate.rating}/5.0"),
              _buildInfoCard(context, Icons.work_outline_rounded, Colors.blue, "Experience", "3.5 Years"),
              _buildInfoCard(context, Icons.account_balance_wallet_outlined, Colors.green, "Salary", "4.5M UZS"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, IconData icon, Color color, String label, String value) {
    return Container(
      width: (context.kSize.width - 48 - 24) / 3, // Roughly 1/3
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))
        ]
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          10.g,
          CustomText(text: label, fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
          6.g,
          CustomText(text: value, fontSize: 12, fontWeight: FontWeight.w800, color: Colors.black),
        ],
      ),
    );
  }
}
