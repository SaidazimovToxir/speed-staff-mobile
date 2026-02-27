import 'package:flutter/material.dart';

import 'package:speed_staff_mobile/config/config.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CustomText(text: "Search screen", fontSize: 20)),
    );
  }
}
