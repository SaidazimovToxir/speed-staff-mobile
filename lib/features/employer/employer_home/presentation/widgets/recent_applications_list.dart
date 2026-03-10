import 'package:speed_staff_mobile/features/employer/applications/domain/entities/application_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/widgets/recent_application_item.dart';

class RecentApplicationsList extends StatelessWidget {
  final List<ApplicationEntity> applications;
  const RecentApplicationsList({super.key, required this.applications});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Recent Applications",
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  TextButton(
                    onPressed: () =>
                        context.push(RouteNames.applications, extra: '1'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerRight,
                    ),
                    child: const CustomText(
                      text: "View All",
                      color: AppColors.cF9A405, // Orange link color from design
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            8.g,
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: applications.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
              itemBuilder: (context, index) => InkWell(
                onTap: () => context.push(RouteNames.candidateProfile, extra: applications[index].id),
                child: RecentApplicationItem(application: applications[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
