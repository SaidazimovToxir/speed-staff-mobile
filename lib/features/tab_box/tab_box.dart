import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speed_staff_mobile/features/home/presentation/pages/home_screen.dart';

import '../../config/config.dart';
import '../search/presentation/pages/search_screen.dart';
import 'bloc/tab_box/tab_box_bloc.dart';

class PageConfig {
  final int index;
  final String icon;
  final String label;
  final String activeIcon;

  PageConfig({required this.index, required this.icon, required this.label, required this.activeIcon});
}

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<PageConfig> pages;
  final List<GlobalKey> navKeys;
  final Function(int) onItemSelected;

  const CustomNavigationBar({super.key, required this.selectedIndex, required this.pages, required this.navKeys, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Container(
        decoration: BoxDecoration(
          // color: AppColors.c262626.withValues(alpha: 0.8),
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.3), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, -3))],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [CustomImageView(imagePath: widget.config.icon, width: 24, height: 24, color: widget.isSelected ? Colors.amber : null)],
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
  final List<PageConfig> _pages = [
    PageConfig(index: 0, icon: AppIcons.homePassiveIcn, label: 'Asosiy', activeIcon: AppIcons.homePassiveIcn),
    PageConfig(index: 1, icon: AppIcons.searchPassiveIcn, label: 'Qidiruv', activeIcon: AppIcons.searchPassiveIcn),
    // PageConfig(index: 2, icon: AppIcons.listPassiveIcn, label: 'Sevimlilar', activeIcon: AppIcons.listActiveIcn),
    // PageConfig(index: 3, icon: AppIcons.profilePassiveIcn, label: 'Profil', activeIcon: AppIcons.profileActiveIcn),
  ];

  Widget _getPageForIndex(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return SearchScreen();
      // case 2:
      //   return MyListScreen();
      // case 3:
      //   return ProfileScreen();
      default:
        return HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<TabBoxBloc, TabBoxState>(
        builder: (context, state) {
          return IndexedStack(index: state.selectedIndex, children: _pages.map((page) => _getPageForIndex(page.index)).toList());
        },
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: BlocBuilder<TabBoxBloc, TabBoxState>(
          builder: (context, state) {
            return ClipRRect(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(0), topRight: Radius.circular(0)),
              child: CustomNavigationBar(
                selectedIndex: state.selectedIndex,
                pages: _pages,
                navKeys: _navKeys,
                onItemSelected: (index) {
                  context.read<TabBoxBloc>().add(TabBoxChangeIndexEvent(index));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

/* import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lola_animation/config/config.dart';
import 'package:lola_animation/features/home/presentation/pages/home_screen.dart';
import 'package:lola_animation/features/tab_box/bloc/tab_box/tab_box_bloc.dart';

import '../my_list/presentation/pages/my_list_screen.dart';
import '../profile/presentation/pages/profile_screen.dart';
import '../search/presentation/pages/search_screen.dart';

class TabBox extends StatefulWidget {
  final int initialTab;
  const TabBox({super.key, this.initialTab = 0});

  @override
  State<TabBox> createState() => _TabBoxState();
}

class _TabBoxState extends State<TabBox> {
  late int _selectedIndex;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final List<GlobalKey> _navKeys = List.generate(4, (index) => GlobalKey());

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openInitialTab();
    });
  }

  void _openInitialTab() {
    final RenderBox renderBox = _navKeys[_selectedIndex]
        .currentContext!
        .findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _navigatorKey.currentState?.pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return _getPageForIndex(_selectedIndex);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          final xCenter = position.dx + size.width / 1;
          final yCenter = position.dy + size.height / 1;

          final beginOffset = Offset(
            (xCenter - screenWidth / 2) / screenWidth,
            (yCenter - screenHeight / 2) / screenHeight,
          );

          final end = Offset.zero;
          final curve = Curves.easeOutBack;

          // Scale animatsiyasi
          var scaleAnimation = Tween(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve,
          ));

          var slideAnimation = Tween(
            begin: beginOffset,
            end: end,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve,
          ));

          return ScaleTransition(
            scale: scaleAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          );
        },
      ),
    );

    context.read<TabBoxBloc>().add(TabNavigated());
  }

  final List<PageConfig> _pages = [
    PageConfig(
      index: 0,
      // title: 'Asosiy Sahifa',
      icon: AppIcons.homePassiveIcn,
      label: 'Asosiy',
      activeIcon: AppIcons.homeActiveIcn,
      // color: Colors.blue,
    ),
    PageConfig(
      index: 1,
      // title: 'Qidiruv Sahifasi',
      icon: AppIcons.searchPassiveIcn,
      label: 'Qidiruv',
      activeIcon: AppIcons.searchActiveIcn,
      // color: Colors.green,
    ),
    PageConfig(
      index: 2,
      // title: 'Sevimlilar Sahifasi',
      icon: AppIcons.listPassiveIcn,
      label: 'Sevimlilar',
      activeIcon: AppIcons.listActiveIcn,
      // color: Colors.red,
    ),
    PageConfig(
      index: 3,
      // title: 'Profil Sahifasi',
      icon: AppIcons.profilePassiveIcn,
      label: 'Profil',
      activeIcon: AppIcons.profileActiveIcn,
      // color: Colors.purple,
    ),
  ];

  Widget _getPageForIndex(int index) {
    switch (index) {
      case 0:
        return _buildPageWithPopHandler(HomeScreen());
      case 1:
        return _buildPageWithPopHandler(SearchScreen());
      case 2:
        return MyListScreen();
      case 3:
        return ProfileScreen();
      default:
        return HomeScreen();
    }
  }

  Widget _buildPageWithPopHandler(Widget page) {
    return PopScope(
      canPop: false,
      child: page,
    );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    final RenderBox renderBox =
        _navKeys[index].currentContext!.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _navigatorKey.currentState?.pushReplacement(
      PageRouteBuilder(
        fullscreenDialog: true, // Muhim parametr
        opaque: true, // Muhim parametr
        pageBuilder: (context, animation, secondaryAnimation) {
          return _getPageForIndex(index);
        },

        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Ekranning markazidan boshlang'ich pozitsiyagacha bo'lgan masofani hisoblash
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          final xCenter = position.dx + size.width / 2;
          final yCenter = position.dy + size.height / 2;

          final beginOffset = Offset(
            (xCenter - screenWidth / 2) / screenWidth,
            (yCenter - screenHeight / 2) / screenHeight,
          );

          final end = Offset.zero;
          final curve = Curves.easeOutBack;

          // Scale animatsiyasi
          var scaleAnimation = Tween(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve,
          ));

          // Position animatsiyasi
          var slideAnimation = Tween(
            begin: beginOffset,
            end: end,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: curve,
          ));

          return ScaleTransition(
            scale: scaleAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => Container(
              color: Colors.white,
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        // borderRadius: BorderRadius.only(
        //   topLeft: Radius.circular(20),
        //   topRight: Radius.circular(20),
        // ),
        child: CustomNavigationBar(
          selectedIndex: _selectedIndex,
          pages: _pages,
          navKeys: _navKeys,
          onItemSelected: _onItemTapped,
        ),
      ),
    );
  }
}

class PageConfig {
  final int index;
  // final String title;
  final String icon;
  final String label;
  final String activeIcon;
  // final Color color;

  PageConfig({
    required this.index,
    // required this.title,
    required this.icon,
    required this.label,
    required this.activeIcon,
    // required this.color,
  });
}

class CustomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<PageConfig> pages;
  final List<GlobalKey> navKeys;
  final Function(int) onItemSelected;

  const CustomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.pages,
    required this.navKeys,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.c262626.withOpacity(0.8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: pages.asMap().entries.map((entry) {
                return _IOSStyleNavItem(
                  key: navKeys[entry.key],
                  config: entry.value,
                  isSelected: selectedIndex == entry.key,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    onItemSelected(entry.key);
                  },
                );
              }).toList(),
            ),
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

  const _IOSStyleNavItem({
    super.key,
    required this.config,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_IOSStyleNavItem> createState() => _IOSStyleNavItemState();
}

class _IOSStyleNavItemState extends State<_IOSStyleNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
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
          splashColor: AppColors.cFF9829.withOpacity(0.2),
          highlightColor: AppColors.cFF9829.withOpacity(0.2),
          onTap: widget.onTap,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomImageView(
                        imagePath: widget.isSelected
                            ? widget.config.activeIcon
                            : widget.config.icon,
                        width: 24,
                        height: 24,
                      ),
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
} */
