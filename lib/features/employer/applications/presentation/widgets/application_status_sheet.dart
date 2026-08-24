import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:go_router/go_router.dart';

class _StatusOption {
  final String status;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatusOption({
    required this.status,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

const _allOptions = [
  _StatusOption(status: 'shortlisted', label: "Tanlash", subtitle: "Ushbu nomzod qiziqarli", icon: Icons.star_rounded, color: Colors.amber),
  _StatusOption(status: 'hired', label: "Qabul qilish", subtitle: "Ushbu nomzodni ishga qabul qilamiz", icon: Icons.check_circle_rounded, color: Colors.green),
  _StatusOption(status: 'rejected', label: "Rad etish", subtitle: "Ushbu safar mos kelmadi", icon: Icons.cancel_rounded, color: Colors.red),
];

class ApplicationStatusSheet extends StatefulWidget {
  final String currentStatus;
  final List<String> allowedTransitions;
  final void Function(String status, String? note) onStatusSelected;

  const ApplicationStatusSheet({
    super.key,
    required this.currentStatus,
    required this.allowedTransitions,
    required this.onStatusSelected,
  });

  @override
  State<ApplicationStatusSheet> createState() => _ApplicationStatusSheetState();
}

class _ApplicationStatusSheetState extends State<ApplicationStatusSheet> {
  String? _selectedStatus;
  final TextEditingController _noteController = TextEditingController();

  List<_StatusOption> get _availableOptions =>
      _allOptions.where((o) => widget.allowedTransitions.contains(o.status)).toList();

  @override
  void initState() {
    super.initState();
    _selectedStatus = _availableOptions.isNotEmpty ? _availableOptions.first.status : null;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom + MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44, height: 5,
                decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
              ),
            ),
            20.g,
            const Center(
              child: CustomText(text: "Status yangilash", fontSize: 18, fontWeight: FontWeight.w800),
            ),
            20.g,
            ..._availableOptions.map((opt) => _buildRow(opt)),
            16.g,
            const CustomText(text: "Izoh (ixtiyoriy)", fontSize: 13, fontWeight: FontWeight.w700),
            10.g,
            CustomTextField(
              controller: _noteController,
              hintText: "Masalan: Siz bilan bog'lanamiz...",
              maxLines: 3,
            ),
            20.g,
            PrimaryButton(
              text: "Saqlash",
              onPressed: _selectedStatus != null
                  ? () {
                      widget.onStatusSelected(
                        _selectedStatus!,
                        _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
                      );
                      context.pop();
                    }
                  : () {},
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
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? opt.color.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? opt.color : Colors.grey.shade100,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: opt.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(opt.icon, color: opt.color, size: 20),
            ),
            14.g,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: opt.label,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? opt.color : Colors.black,
                  ),
                  3.g,
                  CustomText(text: opt.subtitle, fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
                ],
              ),
            ),
            if (isSelected) Icon(Icons.check_circle_rounded, color: opt.color, size: 22),
          ],
        ),
      ),
    );
  }
}
