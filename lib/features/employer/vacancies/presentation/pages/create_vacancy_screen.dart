import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/config.dart';
import 'package:go_router/go_router.dart';

class CreateVacancyScreen extends StatefulWidget {
  const CreateVacancyScreen({super.key});

  @override
  State<CreateVacancyScreen> createState() => _CreateVacancyScreenState();
}

class _CreateVacancyScreenState extends State<CreateVacancyScreen> {
  int _currentStep = 1;

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      context.pop();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      setState(() => _currentStep--);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: const CustomText(
          text: "Create Vacancy",
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: Column(
        children: [
          _buildProgressBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildStepContent(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: PrimaryButton(
              text: _currentStep == 3 ? "Post Vacancy" : "Continue",
              icon: _currentStep == 3 
                ? const Icon(Icons.play_arrow_outlined, color: Colors.white, size: 20)
                : const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
              onPressed: _nextStep,
            ),
          ),
        ],
      ),
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
              CustomText(
                text: "${(_currentStep / 3 * 100).toInt()}% Complete",
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: AppColors.cF9A405,
              ),
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
        const CustomText(
          text: "Vacancy Details",
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        24.g,
        const CustomText(text: "Vacancy Title", fontSize: 13, fontWeight: FontWeight.w700),
        10.g,
        const CustomTextField(
          hintText: "e.g., Senior Barista",
        ),
        24.g,
        const CustomText(text: "Position", fontSize: 13, fontWeight: FontWeight.w700),
        10.g,
        const CustomTextField(
          hintText: "Select position",
          suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ),
        24.g,
        const CustomText(text: "Job Description", fontSize: 13, fontWeight: FontWeight.w700),
        10.g,
        const CustomTextField(
          hintText: "Describe the role and responsibilities...",
          maxLines: 6,
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const CustomText(
              text: "Salary Range (UZS)",
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cF9A405.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const CustomText(
                text: "Monthly",
                fontSize: 10,
                color: AppColors.cF9A405,
                fontWeight: FontWeight.w800,
              ),
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
            values: const RangeValues(2500000, 7500000),
            min: 1000000,
            max: 10000000,
            onChanged: (values) {},
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: "1,000,000", fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
            CustomText(text: "10,000,000", fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
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
              const CustomText(
                text: "2,500,000 — 7,500,000 UZS",
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ],
          ),
        ),
        32.g,
        const CustomText(
          text: "Experience Required",
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
        20.g,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildOptionChip("Any", false)),
            8.g,
            Expanded(child: _buildOptionChip("0-1 yr", false)),
            8.g,
            Expanded(child: _buildOptionChip("1-3 yrs", true)),
            8.g,
            Expanded(child: _buildOptionChip("3+ yrs", false)),
          ],
        ),
        32.g,
        const CustomText(
          text: "Skills Needed",
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
        20.g,
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildSkillChip("Customer Service"),
            _buildSkillChip("POS Systems"),
            _buildSkillChip("Food Safety"),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
              ),
              child: CustomText(text: "Add more skills...", fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        14.g,
        CustomText(text: "Employers often look for specific technical skills.", fontSize: 11, color: Colors.grey.shade500),
        32.g,
        const CustomText(
          text: "Work Type",
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
        16.g,
        const CustomTextField(
          hintText: "Full-time",
          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomText(
          text: "Logistics & Location",
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
        24.g,
        const CustomText(text: "Work Type", fontSize: 12, fontWeight: FontWeight.bold),
        8.g,
        const CustomTextField(
          hintText: "Full-time",
          suffixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
        ),
        24.g,
        const CustomText(
          text: "Schedule Details",
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        12.g,
        Row(
          children: [
            Expanded(
              child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   CustomText(text: "START TIME", fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                   6.g,
                   const CustomTextField(
                     hintText: "09:00 AM",
                     prefixIcon: Icon(Icons.access_time, size: 16, color: AppColors.cF9A405),
                   ),
                 ]
              ),
            ),
            16.g,
            Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   CustomText(text: "END TIME", fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold),
                   6.g,
                   const CustomTextField(
                     hintText: "05:00 PM",
                     prefixIcon: Icon(Icons.access_time, size: 16, color: AppColors.cF9A405),
                   ),
                 ]
              ),
            ),
          ],
        ),
        16.g,
        const CustomTextField(
          hintText: "e.g., Monday to Friday, including public holidays...",
          maxLines: 3,
        ),
        24.g,
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             const CustomText(text: "Restaurant Location", fontSize: 12, fontWeight: FontWeight.bold),
             CustomText(text: "Change", fontSize: 12, color: AppColors.cF9A405, fontWeight: FontWeight.bold),
           ]
        ),
        12.g,
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Mock Map Image Idea
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    "https://tile.openstreetmap.org/12/2471/1567.png",
                    fit: BoxFit.cover,
                    headers: const {'User-Agent': 'SpeedStaffMobile/1.0'},
                    errorBuilder: (_, __, ___) => Container(
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
                      boxShadow: [
                         BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: Offset(0, 2))
                      ]
                    ),
                    child: Row(
                       children: [
                          Icon(Icons.location_on, color: AppColors.cF9A405, size: 18),
                          8.g,
                          Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                  CustomText(text: "The Golden Grillhouse", fontSize: 12, fontWeight: FontWeight.bold),
                                  CustomText(text: "123 Culinary Ave, Suite 400, Austin, TX", fontSize: 10, color: Colors.grey.shade600, maxLines: 1),
                               ],
                             )
                          )
                       ]
                    )
                 )
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionChip(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isSelected ? AppColors.cF9A405 : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: CustomText(
          text: text,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: isSelected ? AppColors.cF9A405 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSkillChip(String text) {
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
          CustomText(text: text, fontSize: 12, color: AppColors.cF9A405),
          6.g,
          const Icon(Icons.close, size: 14, color: AppColors.cF9A405),
        ],
      ),
    );
  }
}
