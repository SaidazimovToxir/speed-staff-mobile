import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_event.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_state.dart';
import 'package:speed_staff_mobile/features/seeker/profile/domain/entities/seeker_profile.dart';

class AddExperienceScreen extends StatefulWidget {
  final SeekerExperience? experience; // If null, adding new. Otherwise, editing.

  const AddExperienceScreen({super.key, this.experience});

  @override
  State<AddExperienceScreen> createState() => _AddExperienceScreenState();
}

class _AddExperienceScreenState extends State<AddExperienceScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _companyCtrl;
  late TextEditingController _positionCtrl;
  late TextEditingController _descCtrl;

  DateTime? _startDate;
  DateTime? _endDate;
  bool _currentlyWorking = false;

  @override
  void initState() {
    super.initState();
    _companyCtrl = TextEditingController(text: widget.experience?.companyName ?? '');
    _positionCtrl = TextEditingController(text: widget.experience?.position ?? '');
    _descCtrl = TextEditingController(text: widget.experience?.description ?? '');

    if (widget.experience != null) {
      // Parse dates if available
      try {
        if (widget.experience!.startDate.isNotEmpty) {
          List<String> parts = widget.experience!.startDate.split('-');
          if (parts.length >= 2) {
            _startDate = DateTime(int.parse(parts[0]), int.parse(parts[1]));
          }
        }
        if (widget.experience!.endDate != null && widget.experience!.endDate!.isNotEmpty) {
          List<String> parts = widget.experience!.endDate!.split('-');
          if (parts.length >= 2) {
            _endDate = DateTime(int.parse(parts[0]), int.parse(parts[1]));
          }
        }
      } catch (_) {}
      _currentlyWorking = widget.experience!.currentlyWorkHere;
    }
  }

  @override
  void dispose() {
    _companyCtrl.dispose();
    _positionCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _saveExperience() {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Start date is required')));
      return;
    }
    if (!_currentlyWorking && _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('End date is required if not currently working here')));
      return;
    }

    final String formattedStart = '${_startDate!.year}-${_startDate!.month.toString().padLeft(2, '0')}-01';
    final String? formattedEnd = _currentlyWorking ? null : '${_endDate!.year}-${_endDate!.month.toString().padLeft(2, '0')}-01';

    final payload = {
      'company_name': _companyCtrl.text.trim(),
      'position': _positionCtrl.text.trim(),
      'start_date': formattedStart,
      'end_date': formattedEnd,
      'description': _descCtrl.text.trim(),
    };

    if (widget.experience != null) {
      context.read<SeekerProfileBloc>().add(EditSeekerExperience(widget.experience!.id, payload));
    } else {
      context.read<SeekerProfileBloc>().add(AddSeekerExperience(payload));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeekerProfileBloc, SeekerProfileState>(
      listener: (context, state) {
        if (state.status == SeekerProfileStatus.success &&
            (state.successMessage == 'Experience added successfully' || state.successMessage == 'Experience updated successfully')) {
          if (context.canPop()) context.pop();
        }
        if (state.status == SeekerProfileStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Operation failed'), backgroundColor: Colors.red));
          context.read<SeekerProfileBloc>().add(const ClearSeekerProfileMessages());
        }
      },
      builder: (context, state) {
        final isLoading = state.status == SeekerProfileStatus.loading;
        final title = widget.experience == null ? 'ADD EXPERIENCE' : 'EDIT EXPERIENCE';

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(title, isLoading),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField('Company Name', _companyCtrl, 'e.g. Acme Corp'),
                  24.g,
                  _buildTextField('Job Title / Position', _positionCtrl, 'e.g. Senior Developer'),
                  24.g,
                  _buildDateSelectors(),
                  24.g,
                  _buildTextField('Description (Optional)', _descCtrl, 'Describe your responsibilities...', maxLines: 4),
                  if (widget.experience != null) ...[
                    40.g,
                    SizedBox(
                      width: double.infinity,
                      child: TextButton.icon(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<SeekerProfileBloc>().add(DeleteSeekerExperience(widget.experience!.id));
                              },
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                        label: const Text(
                          'Delete Experience',
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          bottomNavigationBar: _buildBottomButton(isLoading),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(String title, bool isLoading) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
        onPressed: () {
          if (context.canPop()) context.pop();
        },
      ),
      title: CustomText(text: title, fontSize: 16, fontWeight: FontWeight.w800),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.check_rounded, color: isLoading ? Colors.grey : AppColors.cF9A405),
          onPressed: isLoading ? null : _saveExperience,
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.blueGrey),
        ),
        8.g,
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: Colors.grey.shade50,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.cF9A405),
            ),
          ),
          validator: (maxLines == 1) ? (val) => val == null || val.isEmpty ? 'Required field' : null : null,
        ),
      ],
    );
  }

  Widget _buildDateSelectors() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildDatePicker('Start Date', _startDate, (date) => setState(() => _startDate = date))),
            16.g,
            Expanded(
              child: _currentlyWorking
                  ? Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        'Present',
                        style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                      ),
                    )
                  : _buildDatePicker('End Date', _endDate, (date) => setState(() => _endDate = date), minDate: _startDate),
            ),
          ],
        ),
        16.g,
        Row(
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Checkbox(
                value: _currentlyWorking,
                activeColor: AppColors.cF9A405,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (val) {
                  setState(() {
                    _currentlyWorking = val ?? false;
                    if (_currentlyWorking) _endDate = null;
                  });
                },
              ),
            ),
            12.g,
            const Text(
              'I currently work here',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueGrey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime? selectedDate, ValueChanged<DateTime> onDateSelected, {DateTime? minDate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.blueGrey),
        ),
        8.g,
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? now,
              firstDate: DateTime(1970),
              lastDate: now,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(primary: AppColors.cF9A405, onPrimary: Colors.white, onSurface: Colors.black),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) onDateSelected(date);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate != null ? '${_monthName(selectedDate.month)} ${selectedDate.year}' : 'MM YYYY',
                  style: TextStyle(color: selectedDate != null ? Colors.black : Colors.grey.shade500),
                ),
                Icon(Icons.calendar_today_rounded, size: 18, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  Widget _buildBottomButton(bool isLoading) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: ElevatedButton(
          onPressed: isLoading ? null : _saveExperience,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cF9A405,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
                  widget.experience == null ? 'Add Experience' : 'Save Changes',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white),
                ),
        ),
      ),
    );
  }
}
