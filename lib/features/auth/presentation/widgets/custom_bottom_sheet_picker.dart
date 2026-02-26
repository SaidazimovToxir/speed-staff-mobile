import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../../../config/core/constants/app_colors.dart';
import '../../../../config/core/widgets/primary_button.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';

class CustomBottomSheetPicker extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? initialSelection;
  final ValueChanged<String> onSelected;

  const CustomBottomSheetPicker({
    Key? key,
    required this.title,
    required this.items,
    this.initialSelection,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<CustomBottomSheetPicker> createState() => _CustomBottomSheetPickerState();
}

class _CustomBottomSheetPickerState extends State<CustomBottomSheetPicker> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    _selectedItem = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.only(top: 16, bottom: 32, left: 24, right: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.cE0E5EC,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          24.g,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.c61677D),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          16.g,
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.items.length,
              separatorBuilder: (context, index) => const Divider(color: AppColors.cF6F6F6, height: 1),
              itemBuilder: (context, index) {
                final item = widget.items[index];
                final isSelected = _selectedItem == item;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    item,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: AppColors.black,
                    ),
                  ),
                  trailing: Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected ? AppColors.cF9A405 : AppColors.cE0E5EC,
                  ),
                  tileColor: isSelected ? AppColors.cF9A405.withOpacity(0.05) : Colors.transparent,
                  onTap: () {
                    setState(() {
                      _selectedItem = item;
                    });
                  },
                );
              },
            ),
          ),
          24.g,
          PrimaryButton(
            text: "Confirm Selection" + (_selectedItem != null ? " \u2713" : ""), // Adding checkmark if selected
            onPressed: () {
              if (_selectedItem != null) {
                widget.onSelected(_selectedItem!);
                context.pop();
              }
            },
            color: _selectedItem != null ? AppColors.cF9A405 : AppColors.cE0E5EC,
          ),
        ],
      ),
    );
  }
}

Future<void> showCustomPicker({
  required BuildContext context,
  required String title,
  required List<String> items,
  String? initialSelection,
  required ValueChanged<String> onSelected,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: MediaQuery.of(context).padding.top + kToolbarHeight),
        child: CustomBottomSheetPicker(
          title: title,
          items: items,
          initialSelection: initialSelection,
          onSelected: onSelected,
        ),
      );
    },
  );
}
