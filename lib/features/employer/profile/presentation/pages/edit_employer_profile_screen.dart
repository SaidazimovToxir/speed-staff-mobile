import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_bloc.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_event.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/bloc/employer_profile_state.dart';
import 'package:speed_staff_mobile/features/shared/locations/presentation/bloc/location_bloc.dart';
import 'package:speed_staff_mobile/features/shared/locations/presentation/bloc/location_state.dart';
import 'package:speed_staff_mobile/features/shared/locations/data/models/location_model.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/custom_bottom_sheet_picker.dart';

class EditEmployerProfileScreen extends StatefulWidget {
  const EditEmployerProfileScreen({super.key});

  @override
  State<EditEmployerProfileScreen> createState() => _EditEmployerProfileScreenState();
}

class _EditEmployerProfileScreenState extends State<EditEmployerProfileScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();

  File? _logoFile;
  final ImagePicker _picker = ImagePicker();

  RegionModel? _selectedRegion;
  DistrictModel? _selectedDistrict;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final profile = context.read<EmployerProfileBloc>().state.profile;
      if (profile != null) {
        _nameController.text = profile.restaurantName;
        _phoneController.text = profile.phone ?? '';
        _descController.text = profile.description ?? '';
        _addressController.text = profile.address ?? '';
        _websiteController.text = profile.website ?? '';
        // Try to match city/district from loaded regions
        _tryMatchRegionFromProfile(profile.city, profile.district);
      }
    }
  }

  void _tryMatchRegionFromProfile(String? city, String? district) {
    if (city == null) return;
    final regions = context.read<LocationBloc>().state.regions;
    for (final region in regions) {
      if (region.nameUz == city || region.nameRu == city || region.nameEn == city) {
        _selectedRegion = region;
        if (district != null) {
          for (final d in region.districts) {
            if (d.nameUz == district || d.nameRu == district || d.nameEn == district) {
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

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (image != null) {
      setState(() => _logoFile = File(image.path));
    }
  }

  void _showRegionPicker() {
    final regions = context.read<LocationBloc>().state.regions;
    if (regions.isEmpty) {
      toastification.show(
        context: context,
        title: const Text('Locations are loading, please wait...'),
        type: ToastificationType.info,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 2),
      );
      return;
    }
    showCustomPicker(
      context: context,
      title: 'Select Region',
      items: regions.map((r) => r.nameUz.isNotEmpty ? r.nameUz : r.nameRu).toList(),
      onSelected: (val) {
        final region = regions.firstWhere(
          (r) => (r.nameUz.isNotEmpty ? r.nameUz : r.nameRu) == val,
        );
        setState(() {
          _selectedRegion = region;
          _selectedDistrict = null; // reset district when region changes
        });
      },
    );
  }

  void _showDistrictPicker() {
    if (_selectedRegion == null) {
      toastification.show(
        context: context,
        title: const Text('Please select a region first.'),
        type: ToastificationType.warning,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 2),
      );
      return;
    }
    final districts = _selectedRegion!.districts;
    if (districts.isEmpty) {
      toastification.show(
        context: context,
        title: const Text('No districts available for this region.'),
        type: ToastificationType.info,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 2),
      );
      return;
    }
    showCustomPicker(
      context: context,
      title: 'Select District',
      items: districts.map((d) => d.nameUz.isNotEmpty ? d.nameUz : d.nameRu).toList(),
      onSelected: (val) {
        final district = districts.firstWhere(
          (d) => (d.nameUz.isNotEmpty ? d.nameUz : d.nameRu) == val,
        );
        setState(() => _selectedDistrict = district);
      },
    );
  }

  void _saveProfile() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      toastification.show(
        context: context,
        title: const Text('Restaurant name is required.'),
        type: ToastificationType.warning,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    final data = <String, dynamic>{
      'restaurant_name': name,
      if (_phoneController.text.trim().isNotEmpty) 'phone': _phoneController.text.trim(),
      if (_descController.text.trim().isNotEmpty) 'description': _descController.text.trim(),
      if (_addressController.text.trim().isNotEmpty) 'address': _addressController.text.trim(),
      if (_websiteController.text.trim().isNotEmpty) 'website': _websiteController.text.trim(),
      if (_selectedRegion != null)
        'city': _selectedRegion!.nameUz.isNotEmpty ? _selectedRegion!.nameUz : _selectedRegion!.nameRu,
      if (_selectedDistrict != null)
        'district': _selectedDistrict!.nameUz.isNotEmpty ? _selectedDistrict!.nameUz : _selectedDistrict!.nameRu,
    };

    final profileState = context.read<EmployerProfileBloc>().state;
    if (profileState.profile != null) {
      context.read<EmployerProfileBloc>().add(UpdateEmployerProfile(data, logoPath: _logoFile?.path));
    } else {
      context.read<EmployerProfileBloc>().add(CreateEmployerProfile(data, logoPath: _logoFile?.path));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployerProfileBloc, EmployerProfileState>(
      listenWhen: (prev, curr) =>
          curr.status == ProfileStatus.success || curr.status == ProfileStatus.failure,
      listener: (context, state) {
        if (state.status == ProfileStatus.success) {
          toastification.show(
            context: context,
            title: const Text('Profile saved successfully!'),
            type: ToastificationType.success,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 3),
          );
          if (context.canPop()) context.pop();
        } else if (state.status == ProfileStatus.failure) {
          toastification.show(
            context: context,
            title: Text(state.errorMessage ?? 'An error occurred'),
            type: ToastificationType.error,
            style: ToastificationStyle.fillColored,
            autoCloseDuration: const Duration(seconds: 4),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == ProfileStatus.loading;
        final profile = state.profile;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
              onPressed: isLoading ? null : () { if (context.canPop()) context.pop(); },
            ),
            title: CustomText(
              text: profile != null ? "Edit Profile" : "Create Profile",
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Logo Section ──────────────────────────────────
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage("https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(color: Colors.black.withValues(alpha: 0.25)),
                    ),
                    Positioned(
                      bottom: -44,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 48,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: _logoFile != null
                                    ? FileImage(_logoFile!) as ImageProvider
                                    : (profile?.logoUrl != null
                                        ? NetworkImage(profile!.logoUrl!)
                                        : const NetworkImage("https://images.unsplash.com/photo-1552566626-52f8b828add9?w=400")),
                              ),
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
                                child: const Icon(Icons.add_a_photo_rounded, color: Colors.white, size: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),

                // ── Form Fields ───────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel("Restaurant Name *"),
                      10.g,
                      CustomTextField(
                        controller: _nameController,
                        hintText: "e.g., The Golden Grillhouse",
                      ),
                      20.g,

                      _sectionLabel("Phone Number"),
                      10.g,
                      CustomTextField(
                        controller: _phoneController,
                        hintText: "+998 90 123 45 67",
                        keyboardType: TextInputType.phone,
                      ),
                      20.g,

                      _sectionLabel("Description"),
                      10.g,
                      CustomTextField(
                        controller: _descController,
                        hintText: "Tell job seekers about your restaurant...",
                        maxLines: 4,
                      ),
                      20.g,

                      // ── Location ─────────────────────────────
                      _sectionLabel("Location"),
                      10.g,
                      BlocBuilder<LocationBloc, LocationState>(
                        builder: (context, locState) {
                          return Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: _showRegionPicker,
                                  child: AbsorbPointer(
                                    child: CustomTextField(
                                      hintText: _selectedRegion != null
                                          ? (_selectedRegion!.nameUz.isNotEmpty
                                              ? _selectedRegion!.nameUz
                                              : _selectedRegion!.nameRu)
                                          : "Select Region",
                                      suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
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
                                          ? (_selectedDistrict!.nameUz.isNotEmpty
                                              ? _selectedDistrict!.nameUz
                                              : _selectedDistrict!.nameRu)
                                          : "Select District",
                                      suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      20.g,

                      _sectionLabel("Street Address"),
                      10.g,
                      CustomTextField(
                        controller: _addressController,
                        hintText: "e.g., Amir Temur st. 12",
                      ),
                      20.g,

                      _sectionLabel("Website"),
                      10.g,
                      CustomTextField(
                        controller: _websiteController,
                        hintText: "www.yourrestaurant.uz",
                        keyboardType: TextInputType.url,
                      ),
                      32.g,
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.cF9A405))
                : PrimaryButton(
                    text: profile != null ? "Save Changes" : "Create Profile",
                    onPressed: _saveProfile,
                  ),
          ),
        );
      },
    );
  }

  Widget _sectionLabel(String text) {
    return CustomText(text: text, fontSize: 13, fontWeight: FontWeight.w700);
  }
}
