import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_bloc.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_event.dart';
import 'package:speed_staff_mobile/features/seeker/profile/presentation/bloc/seeker_profile_state.dart';
import 'package:speed_staff_mobile/features/shared/locations/presentation/bloc/location_bloc.dart';
import 'package:speed_staff_mobile/features/shared/locations/presentation/bloc/location_state.dart';
import 'package:speed_staff_mobile/features/shared/locations/data/models/location_model.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/custom_bottom_sheet_picker.dart';

class EditSeekerProfileScreen extends StatefulWidget {
  const EditSeekerProfileScreen({super.key});
  @override
  State<EditSeekerProfileScreen> createState() => _EditSeekerProfileScreenState();
}

class _EditSeekerProfileScreenState extends State<EditSeekerProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameCtrl;
  late TextEditingController _lastNameCtrl;
  late TextEditingController _middleNameCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _expYearsCtrl;
  late TextEditingController _salaryMinCtrl;
  late TextEditingController _salaryMaxCtrl;

  String? _gender;
  bool _isAvailable = true;
  bool _initialized = false;
  RegionModel? _selectedRegion;
  DistrictModel? _selectedDistrict;
  File? _avatarFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _firstNameCtrl = TextEditingController();
    _lastNameCtrl = TextEditingController();
    _middleNameCtrl = TextEditingController();
    _bioCtrl = TextEditingController();
    _expYearsCtrl = TextEditingController();
    _salaryMinCtrl = TextEditingController();
    _salaryMaxCtrl = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final profile = context.read<SeekerProfileBloc>().state.profile;
      if (profile != null) {
        _firstNameCtrl.text = profile.firstName;
        _lastNameCtrl.text = profile.lastName;
        _middleNameCtrl.text = profile.middleName ?? '';
        _bioCtrl.text = profile.bio ?? '';
        _expYearsCtrl.text = profile.experienceYears > 0 ? '${profile.experienceYears}' : '';
        _salaryMinCtrl.text = profile.expectedSalaryMin != null ? '${profile.expectedSalaryMin}' : '';
        _salaryMaxCtrl.text = profile.expectedSalaryMax != null ? '${profile.expectedSalaryMax}' : '';
        _gender = profile.gender;
        _isAvailable = profile.isAvailable;
        _tryMatchLocation(profile.city, profile.district);
      }
    }
  }

  void _tryMatchLocation(String? city, String? district) {
    if (city == null) return;
    final regions = context.read<LocationBloc>().state.regions;
    for (final r in regions) {
      if (r.nameUz == city || r.nameRu == city) {
        _selectedRegion = r;
        if (district != null) {
          for (final d in r.districts) {
            if (d.nameUz == district || d.nameRu == district) {
              _selectedDistrict = d;
              break;
            }
          }
        }
        break;
      }
    }
    if (_selectedRegion != null) setState(() {});
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _middleNameCtrl.dispose();
    _bioCtrl.dispose();
    _expYearsCtrl.dispose();
    _salaryMinCtrl.dispose();
    _salaryMaxCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxWidth: 800);
    if (picked != null) {
      setState(() => _avatarFile = File(picked.path));
      if (mounted) {
        context.read<SeekerProfileBloc>().add(UploadSeekerAvatar(picked.path));
      }
    }
  }

  void _showRegionPicker() {
    final regions = context.read<LocationBloc>().state.regions;
    if (regions.isEmpty) return;
    showCustomPicker(
      context: context,
      title: 'Viloyat tanlang',
      items: regions.map((r) => r.nameUz.isNotEmpty ? r.nameUz : r.nameRu).toList(),
      onSelected: (val) {
        final region = regions.firstWhere((r) => (r.nameUz.isNotEmpty ? r.nameUz : r.nameRu) == val);
        setState(() {
          _selectedRegion = region;
          _selectedDistrict = null;
        });
      },
    );
  }

  void _showDistrictPicker() {
    if (_selectedRegion == null) return;
    final districts = _selectedRegion!.districts;
    if (districts.isEmpty) return;
    showCustomPicker(
      context: context,
      title: 'Tuman tanlang',
      items: districts.map((d) => d.nameUz.isNotEmpty ? d.nameUz : d.nameRu).toList(),
      onSelected: (val) {
        final d = districts.firstWhere((d) => (d.nameUz.isNotEmpty ? d.nameUz : d.nameRu) == val);
        setState(() => _selectedDistrict = d);
      },
    );
  }

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.male_rounded),
              title: const Text('Erkak'),
              onTap: () {
                setState(() => _gender = 'male');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.female_rounded),
              title: const Text('Ayol'),
              onTap: () {
                setState(() => _gender = 'female');
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    if (!_formKey.currentState!.validate()) return;
    final payload = <String, dynamic>{
      'first_name': _firstNameCtrl.text.trim(),
      'last_name': _lastNameCtrl.text.trim(),
      if (_middleNameCtrl.text.trim().isNotEmpty) 'middle_name': _middleNameCtrl.text.trim(),
      if (_bioCtrl.text.trim().isNotEmpty) 'bio': _bioCtrl.text.trim(),
      'is_available': _isAvailable,
      if (_gender != null) 'gender': _gender,
      if (_expYearsCtrl.text.trim().isNotEmpty) 'experience_years': int.tryParse(_expYearsCtrl.text) ?? 0,
      if (_salaryMinCtrl.text.trim().isNotEmpty) 'expected_salary_min': int.tryParse(_salaryMinCtrl.text.replaceAll(' ', '')),
      if (_salaryMaxCtrl.text.trim().isNotEmpty) 'expected_salary_max': int.tryParse(_salaryMaxCtrl.text.replaceAll(' ', '')),
      if (_selectedRegion != null) 'city': _selectedRegion!.nameUz.isNotEmpty ? _selectedRegion!.nameUz : _selectedRegion!.nameRu,
      if (_selectedDistrict != null) 'district': _selectedDistrict!.nameUz.isNotEmpty ? _selectedDistrict!.nameUz : _selectedDistrict!.nameRu,
    };
    context.read<SeekerProfileBloc>().add(UpdateSeekerProfile(payload));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SeekerProfileBloc, SeekerProfileState>(
      listenWhen: (prev, curr) => curr.status == SeekerProfileStatus.success || curr.status == SeekerProfileStatus.failure,
      listener: (context, state) {
        if (state.status == SeekerProfileStatus.success && state.successMessage == 'Profil yangilandi') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Profil muvaffaqiyatli saqlandi'), backgroundColor: Colors.green.shade600, behavior: SnackBarBehavior.floating),
          );
          if (context.canPop()) context.pop();
        }
        if (state.status == SeekerProfileStatus.failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'Xatolik'), backgroundColor: AppColors.cFF0000, behavior: SnackBarBehavior.floating));
          context.read<SeekerProfileBloc>().add(const ClearSeekerProfileMessages());
        }
      },
      builder: (context, state) {
        final isLoading = state.status == SeekerProfileStatus.loading;
        final profile = state.profile;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
              onPressed: () {
                if (context.canPop()) context.pop();
              },
            ),
            title: const CustomText(text: 'Profilni tahrirlash', fontSize: 17, fontWeight: FontWeight.w800),
            actions: [
              TextButton(
                onPressed: isLoading ? null : _saveChanges,
                child: CustomText(text: 'Saqlash', color: isLoading ? Colors.grey : AppColors.cF9A405, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Center(
                    child: GestureDetector(
                      onTap: _pickAvatar,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 52,
                            backgroundColor: Colors.grey.shade200,
                            backgroundImage: _avatarFile != null
                                ? FileImage(_avatarFile!) as ImageProvider
                                : (profile?.avatarUrl != null ? NetworkImage(profile!.avatarUrl!) : null),
                            child: (profile?.avatarUrl == null && _avatarFile == null) ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.cF9A405,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  24.g,
                  _label('Ismi *'), 8.g,
                  CustomTextField(controller: _firstNameCtrl, hintText: 'Jasur', validator: (v) => v?.isEmpty == true ? 'Ism kiriting' : null),
                  16.g,
                  _label('Familiyasi *'), 8.g,
                  CustomTextField(controller: _lastNameCtrl, hintText: 'Toshmatov', validator: (v) => v?.isEmpty == true ? 'Familiya kiriting' : null),
                  16.g,
                  _label('Sharifi'), 8.g,
                  CustomTextField(controller: _middleNameCtrl, hintText: 'Aliyevich'),
                  20.g,
                  _label('Jins'), 8.g,
                  GestureDetector(
                    onTap: _showGenderPicker,
                    child: AbsorbPointer(
                      child: CustomTextField(
                        hintText: _gender == 'male' ? 'Erkak' : (_gender == 'female' ? 'Ayol' : 'Tanlang'),
                        suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                        validator: (v) => null, // Skip default validation for hint-based fields
                      ),
                    ),
                  ),
                  20.g,
                  _label('Joylashuv'), 8.g,
                  BlocBuilder<LocationBloc, LocationState>(
                    builder: (ctx, locState) => Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _showRegionPicker,
                            child: AbsorbPointer(
                              child: CustomTextField(
                                hintText: _selectedRegion != null
                                    ? (_selectedRegion!.nameUz.isNotEmpty ? _selectedRegion!.nameUz : _selectedRegion!.nameRu)
                                    : 'Viloyat',
                                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                                validator: (v) => null, // Skip default validation
                              ),
                            ),
                          ),
                        ),
                        12.g,
                        Expanded(
                          child: GestureDetector(
                            onTap: _showDistrictPicker,
                            child: AbsorbPointer(
                              child: CustomTextField(
                                hintText: _selectedDistrict != null
                                    ? (_selectedDistrict!.nameUz.isNotEmpty ? _selectedDistrict!.nameUz : _selectedDistrict!.nameRu)
                                    : 'Tuman',
                                suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                                validator: (v) => null, // Skip default validation
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  20.g,
                  _label('Tajriba (yil)'), 8.g,
                  CustomTextField(controller: _expYearsCtrl, hintText: '3', keyboardType: TextInputType.number),
                  20.g,
                  _label('Kutilayotgan maosh'), 8.g,
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(controller: _salaryMinCtrl, hintText: 'Min (so\'m)', keyboardType: TextInputType.number),
                      ),
                      12.g,
                      Expanded(
                        child: CustomTextField(controller: _salaryMaxCtrl, hintText: 'Max (so\'m)', keyboardType: TextInputType.number),
                      ),
                    ],
                  ),
                  20.g,
                  _label('Bio'), 8.g,
                  CustomTextField(controller: _bioCtrl, hintText: 'O\'zingiz haqingizda...', maxLines: 4),
                  20.g,
                  // Availability
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.work_outline_rounded, color: AppColors.cF9A405),
                        16.g,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CustomText(text: 'Ishga tayyor', fontWeight: FontWeight.w700),
                              3.g,
                              CustomText(text: 'Ish beruvchilar topishi mumkin', fontSize: 12, color: Colors.grey.shade500),
                            ],
                          ),
                        ),
                        Switch(
                          value: _isAvailable,
                          onChanged: (v) => setState(() => _isAvailable = v),
                          activeTrackColor: AppColors.cF9A405,
                          activeThumbColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  32.g,
                  if (isLoading)
                    const Center(child: CircularProgressIndicator(color: AppColors.cF9A405))
                  else
                    PrimaryButton(text: 'Saqlash', onPressed: _saveChanges),
                  32.g,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _label(String text) => CustomText(text: text, fontSize: 13, fontWeight: FontWeight.w700, color: Colors.blueGrey);
}
