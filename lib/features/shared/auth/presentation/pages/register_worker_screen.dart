import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/auth_header.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/custom_bottom_sheet_picker.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_event.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_state.dart';
import 'package:speed_staff_mobile/config/config.dart';

class RegisterWorkerScreen extends StatefulWidget {
  final String phone;
  final String code;

  const RegisterWorkerScreen({super.key, required this.phone, required this.code});

  @override
  State<RegisterWorkerScreen> createState() => _RegisterWorkerScreenState();
}

class _RegisterWorkerScreenState extends State<RegisterWorkerScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  String? _selectedPosition;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  final List<String> _positions = ["Waiter", "Bartender", "Cook", "Chef", "Host", "Cashier", "Security", "Cleaner", "Other"];

  Future<void> _finalizeRegistration() async {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      toastification.show(
        context: context,
        title: Text('fill_all_fields'.tr()),
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        autoCloseDuration: const Duration(seconds: 3),
      );
      return;
    }

    if (_imageFile != null) {
      setState(() => _isUploading = true);
      try {
        final formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(_imageFile!.path, filename: 'avatar.png'),
        });
        await sl<DioClient>().post(
          'https://api.speed-staff.uz/api/upload/avatar',
          data: formData,
        );
      } catch (e) {
        if (!mounted) return;
        toastification.show(
          context: context,
          title: Text('upload_photo_failed'.tr()),
          type: ToastificationType.error,
          style: ToastificationStyle.fillColored,
          autoCloseDuration: const Duration(seconds: 3),
        );
      } finally {
        setState(() => _isUploading = false);
      }
    }

    if (mounted) {
      context.read<AuthBloc>().add(
        FinalizeRegistrationEvent(
          phone: widget.phone,
          code: widget.code,
          password: widget.phone,
          role: 'seeker',
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.locale; // Force rebuild on language change
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: context.canPop()
            ? CustomIconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => context.pop(),
              )
            : null,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go(RouteNames.main);
          } else if (state is AuthFailure) {
            toastification.show(
              context: context,
              title: Text(state.errorMessage),
              type: ToastificationType.error,
              style: ToastificationStyle.fillColored,
              autoCloseDuration: const Duration(seconds: 3),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(title: "worker_title", subtitle: "worker_subtitle"),
                  32.g,
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.cF6F6F6,
                                  shape: BoxShape.circle,
                                  image: _imageFile != null ? DecorationImage(image: FileImage(File(_imageFile!.path)), fit: BoxFit.cover) : null,
                                ),
                                child: _imageFile == null ? const Icon(Icons.person, size: 40, color: AppColors.c61677D) : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.cF9A405,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.camera_alt, size: 16, color: AppColors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        8.g,
                        const CustomText(
                          text: "upload_photo",
                          style: TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  32.g,
                  CustomTextField(controller: _firstNameController, hintText: "Alisher", labelText: "first_name"),
                  24.g,
                  CustomTextField(controller: _lastNameController, hintText: "Karimov", labelText: "last_name"),
                  24.g,
                  GestureDetector(
                    onTap: () {
                      showCustomPicker(
                        context: context,
                        title: "select_position_title".tr(),
                        items: _positions.map((e) => "position_${e.toLowerCase()}".tr()).toList(),
                        initialSelection: _selectedPosition,
                        onSelected: (value) {
                          setState(() {
                            _selectedPosition = value;
                          });
                        },
                      );
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        hintText: _selectedPosition ?? "select_position_hint",
                        labelText: "work_as",
                        suffixIcon: const Icon(Icons.keyboard_arrow_down, color: AppColors.c61677D),
                      ),
                    ),
                  ),
                  32.g,
                  PrimaryButton(
                    text: (state is AuthLoading || _isUploading) ? "creating" : "create_profile",
                    onPressed: (state is AuthLoading || _isUploading) ? () {} : _finalizeRegistration,
                  ),
                  16.g,
                  const CustomText(
                    text: "worker_tos_agreement",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.c61677D, height: 1.5),
                  ),
                  24.g,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
