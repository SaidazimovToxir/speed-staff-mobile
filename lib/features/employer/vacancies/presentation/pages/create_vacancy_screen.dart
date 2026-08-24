import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_bloc.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_event.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/bloc/vacancies_state.dart';
import 'package:speed_staff_mobile/features/shared/locations/presentation/bloc/location_bloc.dart';
import 'package:speed_staff_mobile/features/shared/locations/presentation/bloc/location_state.dart';
import 'package:speed_staff_mobile/features/shared/skills/presentation/bloc/skills_bloc.dart';
import 'package:speed_staff_mobile/features/shared/skills/presentation/bloc/skills_state.dart';
import 'package:speed_staff_mobile/features/shared/skills/data/models/skill_model.dart';
import 'package:speed_staff_mobile/features/shared/locations/data/models/location_model.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/custom_bottom_sheet_picker.dart';
import 'package:intl/intl.dart';

class CreateVacancyScreen extends StatefulWidget {
  const CreateVacancyScreen({super.key});

  @override
  State<CreateVacancyScreen> createState() => _CreateVacancyScreenState();
}

class _CreateVacancyScreenState extends State<CreateVacancyScreen> {
  int _currentStep = 1;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _scheduleDetailsController = TextEditingController();

  String? _selectedPosition;
  String? _selectedWorkType;
  RegionModel? _selectedRegion;

  RangeValues _salaryRange = const RangeValues(2500000, 7500000);

  String _selectedExperience = "1-3 yrs";
  final List<SkillModel> _selectedSkills = [];

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final List<String> _positions = ["Barista", "Chef", "Waiter", "Manager", "Bartender", "Cleaner"];
  final List<String> _workTypes = ["Full-time", "Part-time", "Contract", "Freelance"];
  final List<String> _experiences = ["Any", "0-1 yr", "1-3 yrs", "3+ yrs"];

  final _currencyFormat = NumberFormat("#,##0", "en_US");

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scheduleDetailsController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (_titleController.text.isEmpty || _selectedPosition == null || _descriptionController.text.isEmpty) {
        toastification.show(
          context: context,
          title: const Text("Please fill all fields."),
          type: ToastificationType.warning,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
        return;
      }
    } else if (_currentStep == 2) {
      if (_selectedSkills.isEmpty || _selectedWorkType == null) {
        toastification.show(
          context: context,
          title: const Text("Please select work type and add at least one skill."),
          type: ToastificationType.warning,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
        return;
      }
    } else if (_currentStep == 3) {
      if (_startTime == null || _endTime == null || _scheduleDetailsController.text.isEmpty || _selectedRegion == null) {
        toastification.show(
          context: context,
          title: const Text("Please provide schedule details and select a location."),
          type: ToastificationType.warning,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
        return;
      }
    }

    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      final startStr = _startTime?.format(context) ?? "09:00 AM";
      final endStr = _endTime?.format(context) ?? "05:00 PM";

      context.read<VacanciesBloc>().add(
        CreateVacancy({
          "request": {
            "title": _titleController.text,
            "position": _selectedPosition,
            "description": _descriptionController.text,
            "work_type": _selectedWorkType,
            "salary_type": "range",
            "salary_min": _salaryRange.start.toInt(),
            "salary_max": _salaryRange.end.toInt(),
            "experience_min": _selectedExperience == "Any" ? 0 : (_selectedExperience == "0-1 yr" ? 0 : (_selectedExperience == "1-3 yrs" ? 1 : 3)),
            "experience_max": _selectedExperience == "Any" ? 0 : (_selectedExperience == "0-1 yr" ? 1 : (_selectedExperience == "1-3 yrs" ? 3 : 10)),
            "schedule": "$startStr - $endStr\n${_scheduleDetailsController.text}",
            "location": _selectedRegion?.nameUz ?? "Unknown",
          },
          "skills": _selectedSkills.map((s) => {"skill_id": s.id, "is_required": true}).toList(),
        }),
      );
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      if (context.canPop()) context.pop();
    }
  }

  void _showAddSkillDialog() {
    final allSkills = context.read<SkillsBloc>().state.skills; // read CURRENT state at call time
    if (allSkills.isEmpty) {
      toastification.show(
        context: context,
        title: const Text("Skills are still loading, please wait..."),
        type: ToastificationType.info,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }
    showCustomPicker(
      context: context,
      title: "Select Skill",
      items: allSkills.map((e) => e.nameUz.isNotEmpty ? e.nameUz : e.nameRu).toList(),
      onSelected: (val) {
        final skill = allSkills.firstWhere((element) => (element.nameUz.isNotEmpty ? element.nameUz : element.nameRu) == val);
        if (!_selectedSkills.any((s) => s.id == skill.id)) {
          setState(() {
            _selectedSkills.add(skill);
          });
        }
      },
    );
  }

  void _showLocationPicker(List<RegionModel> regions) {
    if (regions.isEmpty) {
      toastification.show(
        context: context,
        title: const Text("Locations are still loading, please wait..."),
        type: ToastificationType.info,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }
    showCustomPicker(
      context: context,
      title: "Select Location",
      items: regions.map((e) => e.nameUz.isNotEmpty ? e.nameUz : e.nameRu).toList(),
      initialSelection: _selectedRegion != null ? (_selectedRegion!.nameUz.isNotEmpty ? _selectedRegion!.nameUz : _selectedRegion!.nameRu) : null,
      onSelected: (val) {
        final region = regions.firstWhere((element) => (element.nameUz.isNotEmpty ? element.nameUz : element.nameRu) == val);
        setState(() {
          _selectedRegion = region;
        });
      },
    );
  }

  Future<void> _pickTime(bool isStart) async {
    final t = await showTimePicker(
      context: context,
      initialTime: isStart ? (_startTime ?? const TimeOfDay(hour: 9, minute: 0)) : (_endTime ?? const TimeOfDay(hour: 17, minute: 0)),
    );
    if (t != null) {
      setState(() {
        if (isStart) {
          _startTime = t;
        } else {
          _endTime = t;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VacanciesBloc, VacanciesState>(
      bloc: context.read<VacanciesBloc>(),
      listener: (context, state) {
        if (state.status == VacanciesStatus.success) {
          if (context.canPop()) context.pop();
          toastification.show(
            context: context,
            title: const Text("Vacancy created successfully!"),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 3),
          );
        } else if (state.status == VacanciesStatus.failure) {
          if (state.errorMessage == 'VACANCY_LIMIT_REACHED') {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Limit Reached'),
                content: const Text('You have reached the limit of 3 active vacancies. Please upgrade your plan or close an existing vacancy.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (ctx.canPop()) ctx.pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          } else {
            toastification.show(
              context: context,
              title: Text(state.errorMessage ?? "An error occurred"),
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black, size: 24),
              onPressed: _prevStep,
            ),
            title: const CustomText(text: "Create Vacancy", fontSize: 18, fontWeight: FontWeight.w800),
          ),
          body: Column(
            children: [
              _buildProgressBar(),
              Expanded(
                child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: _buildStepContent()),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: PrimaryButton(
                  text: _currentStep == 3 ? "Post Vacancy" : "Continue",
                  icon: _currentStep == 3
                      ? const Icon(Icons.play_arrow_outlined, color: Colors.white, size: 20)
                      : const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                  onPressed: state.status == VacanciesStatus.loading ? () {} : _nextStep,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: _currentStep == 3 ? "FINAL STEP" : "STEP $_currentStep OF 3",
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: _currentStep == 3 ? AppColors.cF9A405 : Colors.grey.shade500,
              ),
              CustomText(text: "${(_currentStep / 3 * 100).toInt()}% Complete", fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.cF9A405),
            ],
          ),
          10.g,
          LinearProgressIndicator(
            value: _currentStep / 3,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cF9A405),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return _buildStep1();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(text: "Vacancy Details", fontSize: 16, fontWeight: FontWeight.w800),
        24.g,
        const CustomText(text: "Vacancy Title", fontSize: 13, fontWeight: FontWeight.w700),
        10.g,
        CustomTextField(controller: _titleController, hintText: "e.g., Senior Barista"),
        24.g,
        const CustomText(text: "Position", fontSize: 13, fontWeight: FontWeight.w700),
        10.g,
        GestureDetector(
          onTap: () {
            showCustomPicker(
              context: context,
              title: "Select Position",
              items: _positions,
              initialSelection: _selectedPosition,
              onSelected: (val) => setState(() => _selectedPosition = val),
            );
          },
          child: AbsorbPointer(
            child: CustomTextField(
              hintText: _selectedPosition ?? "Select position",
              suffixIcon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ),
          ),
        ),
        24.g,
        const CustomText(text: "Job Description", fontSize: 13, fontWeight: FontWeight.w700),
        10.g,
        CustomTextField(controller: _descriptionController, hintText: "Describe the role and responsibilities...", maxLines: 6),
        24.g,
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cF9A405.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cF9A405.withValues(alpha: 0.1)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColors.cF9A405, size: 22),
              14.g,
              const Expanded(
                child: CustomText(
                  text: "A detailed description helps attract 40% more qualified candidates. Include key tasks and required certifications.",
                  fontSize: 12,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    final formatRange =
        "${_currencyFormat.format(_salaryRange.start.toInt()).replaceAll(',', ' ')} — ${_currencyFormat.format(_salaryRange.end.toInt()).replaceAll(',', ' ')} UZS";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(text: "Salary Range (UZS)", fontSize: 16, fontWeight: FontWeight.w800),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.cF9A405.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(100)),
              child: const CustomText(text: "Monthly", fontSize: 10, color: AppColors.cF9A405, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        32.g,
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.cF9A405,
            inactiveTrackColor: Colors.grey.shade200,
            thumbColor: AppColors.cF9A405,
            trackHeight: 6,
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
            overlayColor: AppColors.cF9A405.withValues(alpha: 0.1),
          ),
          child: RangeSlider(
            values: _salaryRange,
            min: 1000000,
            max: 20000000,
            divisions: 38,
            onChanged: (values) {
              setState(() {
                _salaryRange = values;
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: "1,000,000", fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
            CustomText(text: "20,000,000", fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
          ],
        ),
        24.g,
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              CustomText(text: "Selected Range", fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              8.g,
              CustomText(text: formatRange, fontSize: 18, fontWeight: FontWeight.w800),
            ],
          ),
        ),
        32.g,
        const CustomText(text: "Experience Required", fontSize: 15, fontWeight: FontWeight.w800),
        20.g,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _experiences.map((exp) {
            final isSelected = _selectedExperience == exp;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: GestureDetector(onTap: () => setState(() => _selectedExperience = exp), child: _buildOptionChip(exp, isSelected)),
              ),
            );
          }).toList(),
        ),
        32.g,
        const CustomText(text: "Skills Needed", fontSize: 15, fontWeight: FontWeight.w800),
        20.g,
        BlocConsumer<SkillsBloc, SkillsState>(
          bloc: context.read<SkillsBloc>(),
          listenWhen: (prev, curr) => curr.status == SkillsStatus.failure && prev.status != SkillsStatus.failure,
          listener: (context, state) {
            // Toast shown in listener — NEVER in builder to avoid setState-during-build
            toastification.show(
              context: context,
              title: Text("Skills load error: ${state.errorMessage}"),
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 3),
            );
          },
          buildWhen: (prev, curr) => curr.status != prev.status || curr.skills != prev.skills,
          builder: (context, state) {
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ..._selectedSkills.map((e) => _buildSkillChip(e)),
                GestureDetector(
                  onTap: () => _showAddSkillDialog(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                    ),
                    child: CustomText(text: "+ Add skill", fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            );
          },
        ),
        14.g,
        CustomText(text: "Employers often look for specific technical skills.", fontSize: 11, color: Colors.grey.shade500),
        32.g,
        const CustomText(text: "Work Type", fontSize: 15, fontWeight: FontWeight.w800),
        16.g,
        GestureDetector(
          onTap: () {
            showCustomPicker(
              context: context,
              title: "Select Work Type",
              items: _workTypes,
              initialSelection: _selectedWorkType,
              onSelected: (val) => setState(() => _selectedWorkType = val),
            );
          },
          child: AbsorbPointer(
            child: CustomTextField(
              hintText: _selectedWorkType ?? "Select work type",
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(text: "Logistics & Location", fontSize: 16, fontWeight: FontWeight.w800),
        24.g,
        const CustomText(text: "Schedule Details", fontSize: 14, fontWeight: FontWeight.bold),
        12.g,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "START TIME", fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                  6.g,
                  GestureDetector(
                    onTap: () => _pickTime(true),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        hintText: _startTime?.format(context) ?? "09:00 AM",
                        prefixIcon: const Icon(Icons.access_time, size: 16, color: AppColors.cF9A405),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            16.g,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: "END TIME", fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                  6.g,
                  GestureDetector(
                    onTap: () => _pickTime(false),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        hintText: _endTime?.format(context) ?? "05:00 PM",
                        prefixIcon: const Icon(Icons.access_time, size: 16, color: AppColors.cF9A405),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        16.g,
        CustomTextField(controller: _scheduleDetailsController, hintText: "e.g., Monday to Friday, including public holidays...", maxLines: 3),
        24.g,
        BlocBuilder<LocationBloc, LocationState>(
          bloc: context.read<LocationBloc>(),
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomText(text: "Region Location", fontSize: 12, fontWeight: FontWeight.bold),
                GestureDetector(
                  onTap: () => _showLocationPicker(state.regions),
                  child: const CustomText(text: "Change", fontSize: 12, color: AppColors.cF9A405, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
        ),
        12.g,
        Container(
          height: 120,
          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(16)),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    "https://tile.openstreetmap.org/12/2471/1567.png",
                    fit: BoxFit.cover,
                    headers: const {'User-Agent': 'SpeedStaffMobile/1.0'},
                    errorBuilder: (_, _, _) => Container(
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.map, size: 48, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.cF9A405, size: 18),
                      8.g,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: _selectedRegion != null
                                  ? (_selectedRegion!.nameUz.isNotEmpty ? _selectedRegion!.nameUz : _selectedRegion!.nameRu)
                                  : "Select a region",
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(text: "Uzbekistan", fontSize: 10, color: Colors.grey.shade600, maxLines: 1),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionChip(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: isSelected ? AppColors.cF9A405 : Colors.grey.shade200, width: isSelected ? 2 : 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: CustomText(
          text: text,
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: isSelected ? AppColors.cF9A405 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSkillChip(SkillModel skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.cF9A405),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(text: skill.nameUz.isNotEmpty ? skill.nameUz : skill.nameRu, fontSize: 12, color: AppColors.cF9A405),
          6.g,
          GestureDetector(
            onTap: () {
              setState(() => _selectedSkills.removeWhere((s) => s.id == skill.id));
            },
            child: const Icon(Icons.close, size: 14, color: AppColors.cF9A405),
          ),
        ],
      ),
    );
  }
}
