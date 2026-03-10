import 'package:speed_staff_mobile/features/employer/employer_home/domain/entities/dashboard_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/widgets/stat_card.dart';

class DashboardStatsGrid extends StatelessWidget {
  final EmployerStatsEntity stats;
  const DashboardStatsGrid({super.key, required this.stats});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          StatCard(
            label: "Active Vacancies",
            value: "${stats.activeVacancies}",
            subtitle: "Positions",
            actionText: "Manage →",
            iconData: Icons.work_outline_rounded,
            iconColor: AppColors.cF9A405,
            iconBgColor: AppColors.cF9A405.withValues(alpha: 0.1),
            onActionTap: () => context.push(RouteNames.myVacancies),
          ),
          20.g,
          StatCard(
            label: "Total Applications",
            value: "${stats.totalApplications}",
            subtitle: "Lifetime",
            actionText: "↗ 4% from last month",
            actionColor: Colors.green,
            iconData: Icons.person_outline_rounded,
            iconColor: Colors.blue.shade600,
            iconBgColor: Colors.blue.shade50,
            onActionTap: () => context.push(RouteNames.applications, extra: '1'),
            isDashed: true, // Optional: if I want to implement dashed border
          ),
          20.g,
          StatCard(
            label: "New today",
            value: "+${stats.newToday}",
            valueColor: AppColors.cF9A405,
            subtitle: "New candidates",
            actionText: "↗ Highest this week",
            actionColor: Colors.green,
            iconData: Icons.bolt_rounded,
            iconColor: Colors.white,
            iconBgColor: AppColors.cF9A405,
          ),
        ],
      ),
    );
  }
}
