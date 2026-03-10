import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:speed_staff_mobile/features/employer/applications/presentation/pages/applications_screen.dart';
import 'package:speed_staff_mobile/features/employer/profile/presentation/pages/employer_profile_screen.dart';
import 'package:speed_staff_mobile/features/employer/vacancies/presentation/pages/my_vacancies_screen.dart';
import 'package:speed_staff_mobile/features/user/user_home/presentation/pages/home_screen.dart';

import 'package:speed_staff_mobile/config/config.dart';
import 'package:speed_staff_mobile/features/user/user_search/presentation/pages/search_screen.dart';
import 'bloc/tab_box/tab_box_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_event.dart';
import 'package:speed_staff_mobile/features/shared/auth/presentation/bloc/auth_state.dart';
import 'package:speed_staff_mobile/features/seeker/seeker_home/presentation/pages/seeker_home_screen.dart';
import 'package:speed_staff_mobile/features/employer/employer_home/presentation/pages/employer_home_screen.dart';

class PageConfig {
  final int index;
  final String? icon;
  final IconData? iconData;
  final String label;

  PageConfig({required this.index, this.icon, this.iconData, required this.label});
}

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<PageConfig> pages;
  final List<GlobalKey> navKeys;
  final Function(int) onItemSelected;

  const CustomNavigationBar({super.key, required this.selectedIndex, required this.pages, required this.navKeys, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), spreadRadius: 0, blurRadius: 10, offset: const Offset(0, -4))
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: pages.asMap().entries.map((entry) {
              return _IOSStyleNavItem(
                key: navKeys[entry.key],
                config: entry.value,
                isSelected: selectedIndex == entry.key,
                isDownloadPage: entry.key == 2,
                onTap: () {
                  if (Platform.isAndroid) {
                  } else {
                    HapticFeedback.lightImpact();
                  }
                  onItemSelected(entry.key);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _IOSStyleNavItem extends StatefulWidget {
  final PageConfig config;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDownloadPage;

  const _IOSStyleNavItem({super.key, required this.config, required this.isSelected, required this.onTap, required this.isDownloadPage});

  @override
  State<_IOSStyleNavItem> createState() => _IOSStyleNavItemState();
}

class _IOSStyleNavItemState extends State<_IOSStyleNavItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(1000),
          // splashColor: AppColors..withValues(alpha: 0.2),
          // highlightColor: AppColors.cFF9829.withValues(alpha: 0.2),
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.config.icon != null)
                        CustomImageView(imagePath: widget.config.icon!, width: 24, height: 24, color: widget.isSelected ? AppColors.cF9A405 : Colors.grey.shade400),
                      if (widget.config.iconData != null)
                        Icon(widget.config.iconData, size: 24, color: widget.isSelected ? AppColors.cF9A405 : Colors.grey.shade400),
                      const SizedBox(height: 4),
                      Text(widget.config.label, style: TextStyle(fontSize: 10, color: widget.isSelected ? AppColors.cF9A405 : Colors.grey.shade400, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class TabBox extends StatefulWidget {
  const TabBox({super.key});

  @override
  State<TabBox> createState() => _TabBoxState();
}

class _TabBoxState extends State<TabBox> {
  final List<GlobalKey> _navKeys = List.generate(4, (index) => GlobalKey());
  List<PageConfig> _getPagesForRole(String role) {
    if (role == 'employer') {
      return [
        PageConfig(index: 0, iconData: Icons.grid_view, label: 'Dashboard'),
        PageConfig(index: 1, iconData: Icons.list_alt, label: 'Vacancies'),
        PageConfig(index: 2, iconData: Icons.description_outlined, label: 'Applications'),
        PageConfig(index: 3, iconData: Icons.person_outline, label: 'Profile'),
      ];
    } else if (role == 'seeker') {
      return [
        PageConfig(index: 0, icon: AppIcons.homePassiveIcn, label: 'Asosiy'),
        PageConfig(index: 1, icon: AppIcons.searchPassiveIcn, label: 'Vakansiyalar'),
        PageConfig(index: 2, icon: AppIcons.profilePassiveIcn, label: 'Profil'),
      ];
    } else {
      return [
        PageConfig(index: 0, icon: AppIcons.homePassiveIcn, label: 'Asosiy'),
        PageConfig(index: 1, icon: AppIcons.searchPassiveIcn, label: 'Qidiruv'),
        PageConfig(index: 2, icon: AppIcons.profilePassiveIcn, label: 'Profil'),
      ];
    }
  }

  Widget _buildProfilePlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Profile Screen coming soon"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.cF9A405),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _getPageForIndex(int index, String role) {
    if (role == 'employer') {
      switch (index) {
        case 0:
          return const EmployerHomeScreen();
        case 1:
          return const MyVacanciesScreen();
        case 2:
          return const ApplicationsScreen(vacancyId: '1');
        case 3:
          return const EmployerProfileScreen();
        default:
          return const EmployerHomeScreen();
      }
    } else if (role == 'seeker') {
      switch (index) {
        case 0:
          return const SeekerHomeScreen();
        case 1:
          return const Center(child: Text("Seeker Vacancies coming soon"));
        case 2:
          return _buildProfilePlaceholder();
        default:
          return const SeekerHomeScreen();
      }
    } else {
      switch (index) {
        case 0:
          return const HomeScreen();
        case 1:
          return const SearchScreen();
        case 2:
          return _buildProfilePlaceholder();
        default:
          return const HomeScreen();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go(RouteNames.onboardingScreen);
        }
      },
      child: Scaffold(
        body: BlocBuilder<TabBoxBloc, TabBoxState>(
          builder: (context, state) {
            // TODO: remove this override when real auth is ready
            // Currently forcing 'employer' for UI development
            String role = 'employer';
            final authState = context.read<AuthBloc>().state;
            if (authState is AuthSuccess) {
              // Override: treat any logged-in user as employer for dev
              role = 'employer'; // authState.user.role ?? 'employer';
            } else if (authState is AuthNeedsProfileUpdate) {
              role = 'employer'; // authState.user.role ?? 'employer';
            }
            final activePages = _getPagesForRole(role);
            final safeIndex = state.selectedIndex.clamp(0, activePages.length - 1);

            return IndexedStack(index: safeIndex, children: activePages.map((page) => _getPageForIndex(page.index, role)).toList());
          },
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: BlocBuilder<TabBoxBloc, TabBoxState>(
            builder: (context, state) {
              // TODO: remove this override when real auth is ready
              String role = 'employer';
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthSuccess) {
                role = 'employer'; // authState.user.role ?? 'employer';
              } else if (authState is AuthNeedsProfileUpdate) {
                role = 'employer'; // authState.user.role ?? 'employer';
              }
              final activePages = _getPagesForRole(role);
              final safeIndex = state.selectedIndex.clamp(0, activePages.length - 1);

              return ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
                child: CustomNavigationBar(
                  selectedIndex: safeIndex,
                  pages: activePages,
                  navKeys: _navKeys,
                  onItemSelected: (index) {
                    context.read<TabBoxBloc>().add(TabBoxChangeIndexEvent(index));
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
