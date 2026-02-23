import 'package:flutter/material.dart';
import 'package:speed_staff_mobile/config/widgets/custom_text.dart';

class CustomToast {
  static OverlayEntry? _overlayEntry;
  static bool _isVisible = false;
  static const Duration _animationDuration = Duration(milliseconds: 500);
  static const Duration _displayDuration = Duration(seconds: 2);

  static void show(BuildContext context, {required String message, Color backgroundColor = Colors.black87, Color textColor = Colors.white}) {
    if (_isVisible) {
      _overlayEntry?.remove();
      _isVisible = false;
    }

    final overlay = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(message: message, backgroundColor: backgroundColor, textColor: textColor, onDismissed: hide),
    );

    _isVisible = true;
    overlay.insert(_overlayEntry!);

    Future.delayed(_displayDuration + _animationDuration, () {
      hide();
    });
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isVisible = false;
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onDismissed;

  const _ToastWidget({required this.message, required this.backgroundColor, required this.textColor, required this.onDismissed});

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _animation = Tween<double>(
      begin: -100.0,
      end: 50.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack, reverseCurve: Curves.easeInBack));

    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn, reverseCurve: Curves.easeOut));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        widget.onDismissed();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          top: _animation.value,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: SafeArea(
              child: Opacity(
                opacity: _opacity.value,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.2), offset: const Offset(0, 4), blurRadius: 8)],
                  ),
                  child: CustomText(text: widget.message, textAlign: TextAlign.center, fontSize: 16, color: widget.textColor, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
