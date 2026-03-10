import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/config/config.dart';

class EditEmployerProfileScreen extends StatelessWidget {
  const EditEmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            }
          },
        ),
        title: const CustomText(
          text: "Edit Profile",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Banner selection area
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.2),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ),
                // Overlapping avatar selection
                Positioned(
                  bottom: -40,
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage("https://images.unsplash.com/photo-1552566626-52f8b828add9?w=400"),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: AppColors.cF9A405, 
                            shape: BoxShape.circle, 
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            60.g,
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(text: "Restaurant Name", fontSize: 13, fontWeight: FontWeight.w700),
                  10.g,
                  const CustomTextField(
                    hintText: "The Golden Grillhouse",
                  ),
                  20.g,
                  const CustomText(text: "Restaurant Category", fontSize: 13, fontWeight: FontWeight.w700),
                  10.g,
                  const CustomTextField(
                    hintText: "Fine Dining • European",
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
                  ),
                  20.g,
                  const CustomText(text: "Phone Number", fontSize: 13, fontWeight: FontWeight.w700),
                  10.g,
                  const CustomTextField(
                    hintText: "+998 90 123 45 67",
                  ),
                  20.g,
                  const CustomText(text: "Restaurant Description", fontSize: 13, fontWeight: FontWeight.w700),
                  10.g,
                  const CustomTextField(
                    hintText: "Describe your restaurant, values, and what makes you special...",
                    maxLines: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
         padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
         child: PrimaryButton(
           text: "Save Changes",
           onPressed: () {
             if (context.canPop()) context.pop();
           },
         ),
      ),
    );
  }
}
