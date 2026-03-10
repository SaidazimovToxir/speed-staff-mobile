import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

extension SizeExtension on BuildContext {
  bool get isMobile => MediaQuery.sizeOf(this).width < 600 && (Platform.isAndroid || Platform.isIOS);

  bool get isTablet => MediaQuery.sizeOf(this).width > 600 && (Platform.isAndroid || Platform.isIOS);

  EdgeInsets get kMargin16 =>
      EdgeInsets.only(top: MediaQuery.paddingOf(this).top, left: isMobile ? 16 : 200, right: isMobile ? 16 : 200, bottom: MediaQuery.paddingOf(this).bottom);

  EdgeInsets get kMarginBottom16 => EdgeInsets.only(bottom: MediaQuery.paddingOf(this).bottom, left: isMobile ? 16 : 200, right: isMobile ? 16 : 200);

  Size get kSize => MediaQuery.sizeOf(this);

  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
}

extension OrientationExtension on Orientation {
  bool get isPortrait => this == Orientation.portrait;
}

extension Space on num {
  Gap get g => Gap(toDouble());

  double get ph {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return 0.0;
    return (MediaQuery.sizeOf(ctx).height * ((toDouble() / 8.12) / 100)).ceilToDouble();
  }

  double get pw {
    final ctx = rootNavigatorKey.currentContext;
    if (ctx == null) return 0.0;
    return (MediaQuery.sizeOf(ctx).width * ((toDouble() / 3.75) / 100)).ceilToDouble();
  }
}
