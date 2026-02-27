import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'dart:io';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/auth_header.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/custom_bottom_sheet_picker.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/widgets/step_progress_bar.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_event.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_state.dart';
import 'package:speed_staff_mobile/config/config.dart';

class RegisterRestaurantScreen extends StatefulWidget {
  final String phone;
  final String code;

  const RegisterRestaurantScreen({super.key, required this.phone, required this.code});

  @override
  State<RegisterRestaurantScreen> createState() => _RegisterRestaurantScreenState();
}

class _RegisterRestaurantScreenState extends State<RegisterRestaurantScreen> {
  late final TextEditingController _restaurantNameController;
  String? _selectedCity;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _restaurantNameController = TextEditingController();
  }

  @override
  void dispose() {
    _restaurantNameController.dispose();
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

  final List<String> _cities = ["Tashkent", "Samarkand", "Bukhara", "Namangan", "Andijan", "Fergana", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: CustomIconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: const CustomText(
          text: "STEP 3 OF 3",
          style: TextStyle(color: AppColors.c61677D, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.5),
        ),
        centerTitle: true,
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
                  const StepProgressBar(currentStep: 3, totalSteps: 3),
                  32.g,
                  const AuthHeader(title: "Set up your restaurant", subtitle: "This helps workers find and trust you"),
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
                                child: _imageFile == null ? const Icon(Icons.restaurant, size: 40, color: AppColors.c61677D) : null,
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
                          text: "Upload Restaurant Logo",
                          style: TextStyle(color: AppColors.cF9A405, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  32.g,
                  CustomTextField(controller: _restaurantNameController, hintText: "Cafe Milano", labelText: "Restaurant Name"),
                  24.g,
                  GestureDetector(
                    onTap: () {
                      showCustomPicker(
                        context: context,
                        title: "Select City",
                        items: _cities,
                        initialSelection: _selectedCity,
                        onSelected: (value) {
                          setState(() {
                            _selectedCity = value;
                          });
                        },
                      );
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        hintText: _selectedCity ?? "Select city",
                        labelText: "City",
                        suffixIcon: const Icon(Icons.keyboard_arrow_down, color: AppColors.c61677D),
                      ),
                    ),
                  ),
                  24.g,
                  const CustomTextField(hintText: "+998 | 90 123 45 67", labelText: "Contact phone", keyboardType: TextInputType.phone),
                  32.g,
                  PrimaryButton(
                    text: state is AuthLoading ? "Creating..." : "Create Restaurant Profile →",
                    onPressed: state is AuthLoading
                        ? () {}
                        : () {
                            if (_restaurantNameController.text.isEmpty) {
                              toastification.show(
                                context: context,
                                title: const Text('Please enter restaurant name'),
                                type: ToastificationType.error,
                                style: ToastificationStyle.fillColored,
                                autoCloseDuration: const Duration(seconds: 3),
                              );
                              return;
                            }
                            context.read<AuthBloc>().add(
                              FinalizeRegistrationEvent(
                                phone: widget.phone,
                                code: widget.code,
                                password: widget.phone, // Passing phone as dummy password since UI has no field
                                role: 'employer',
                                restaurantName: _restaurantNameController.text,
                              ),
                            );
                          },
                  ),
                  16.g,
                  const CustomText(
                    text: "By clicking \"Create Restaurant Profile\", you agree to Speed\nStaff's Terms of Service and Privacy Policy.",
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
