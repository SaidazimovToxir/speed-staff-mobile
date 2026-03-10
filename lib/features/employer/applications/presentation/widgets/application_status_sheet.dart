import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:go_router/go_router.dart';

class _StatusOption {
  final String status;
  final String subtitle;
  final Widget icon;

  const _StatusOption({required this.status, required this.subtitle, required this.icon});
}

class ApplicationStatusSheet extends StatefulWidget {
  final Function(String) onStatusSelected;

  const ApplicationStatusSheet({super.key, required this.onStatusSelected});

  @override
  State<ApplicationStatusSheet> createState() => _ApplicationStatusSheetState();
}

class _ApplicationStatusSheetState extends State<ApplicationStatusSheet> {
  String _selectedStatus = 'Viewed';
  final TextEditingController _noteController = TextEditingController();

  final List<_StatusOption> _options = [
    _StatusOption(
      status: 'Sent',
      subtitle: 'Initial state',
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
        child: Icon(Icons.send_outlined, color: Colors.blue.shade400, size: 22),
      ),
    ),
    _StatusOption(
      status: 'Viewed',
      subtitle: 'You reviewed this profile',
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.cF9A405.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.remove_red_eye_outlined, color: AppColors.cF9A405, size: 22),
      ),
    ),
    _StatusOption(
      status: 'Shortlisted',
      subtitle: 'Candidate looks promising',
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(10)),
        child: Icon(Icons.star_outline, color: Colors.amber.shade600, size: 22),
      ),
    ),
    _StatusOption(
      status: 'Hired',
      subtitle: 'You hired this person',
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(10)),
        child: Icon(Icons.check_circle, color: Colors.green.shade600, size: 22),
      ),
    ),
    _StatusOption(
      status: 'Rejected',
      subtitle: 'Not a fit this time',
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(10)),
        child: const Icon(Icons.close, color: Colors.red, size: 22),
      ),
    ),
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom + MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48, height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            24.g,
            const Center(
              child: CustomText(
                text: "Update Status",
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            24.g,
            ..._options.map((opt) => _buildRow(opt)),
            24.g,
            const CustomText(text: "Add a Note (Optional)", fontSize: 13, fontWeight: FontWeight.w700),
            12.g,
            CustomTextField(
              controller: _noteController,
              hintText: 'e.g., Candidates profile looks good, let\'s interview...',
              maxLines: 4,
            ),
            24.g,
            PrimaryButton(
              text: 'Update Status',
              onPressed: () {
                widget.onStatusSelected(_selectedStatus);
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(_StatusOption opt) {
    final isSelected = _selectedStatus == opt.status;
    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = opt.status),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cF9A405.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.cF9A405 : Colors.grey.shade100,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            opt.icon,
            16.g,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: opt.status, fontSize: 14, fontWeight: FontWeight.w800, color: isSelected ? AppColors.cF9A405 : Colors.black),
                  2.g,
                  CustomText(text: opt.subtitle, fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.cF9A405, size: 24),
          ],
        ),
      ),
    );
  }
}
