import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../../../config/core/constants/app_colors.dart';
import '../../../../config/core/widgets/primary_button.dart';
import '../../../../config/core/widgets/custom_text_field.dart';
import 'dart:io';
import '../widgets/auth_header.dart';
import '../widgets/custom_bottom_sheet_picker.dart';
import 'package:speed_staff_mobile/config/core/extensions/size_extension.dart';
import 'package:image_picker/image_picker.dart';

class RegisterWorkerScreen extends StatefulWidget {
  const RegisterWorkerScreen({super.key});

  @override
  State<RegisterWorkerScreen> createState() => _RegisterWorkerScreenState();
}

class _RegisterWorkerScreenState extends State<RegisterWorkerScreen> {
  String? _selectedPosition;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = image;
      });
    }
  }

  final List<String> _positions = [
    "Waiter",
    "Bartender",
    "Cook",
    "Chef",
    "Host",
    "Cashier",
    "Security",
    "Cleaner",
    "Other"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "STEP 3 OF 3",
          style: TextStyle(
            color: AppColors.c61677D,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "100% COMPLETED",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.cF9A405,
                      ),
                    ),
                  ),
                ],
              ),
              8.g,
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 1.0,
                  backgroundColor: AppColors.cF6F6F6,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cF9A405),
                  minHeight: 8,
                ),
              ),
              32.g,
              const AuthHeader(
                title: "Almost there!",
                subtitle: "Tell us a bit about yourself to complete your profile",
              ),
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
                              image: _imageFile != null
                                  ? DecorationImage(
                                      image: FileImage(File(_imageFile!.path)),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _imageFile == null
                                ? const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppColors.c61677D,
                                  )
                                : null,
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
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    8.g,
                    const Text(
                      "Upload Profile Photo",
                      style: TextStyle(
                        color: AppColors.cF9A405,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              32.g,
              const CustomTextField(
                hintText: "Alisher",
                labelText: "First name",
              ),
              24.g,
              const CustomTextField(
                hintText: "Karimov",
                labelText: "Last name",
              ),
              24.g,
              GestureDetector(
                onTap: () {
                  showCustomPicker(
                    context: context,
                    title: "Select Position",
                    items: _positions,
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
                    hintText: _selectedPosition ?? "Select your position",
                    labelText: "I work as a...",
                    suffixIcon: const Icon(Icons.keyboard_arrow_down, color: AppColors.c61677D),
                  ),
                ),
              ),
              32.g,
              PrimaryButton(
                text: "Create My Profile →",
                onPressed: () {
                  context.push('/success_screen');
                },
              ),
              16.g,
              const Text(
                "By clicking \"Create My Profile\", you agree to Speed\nStaff's Terms of Service and Privacy Policy.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.c61677D, height: 1.5),
              ),
              24.g,
            ],
          ),
        ),
      ),
    );
  }
}
