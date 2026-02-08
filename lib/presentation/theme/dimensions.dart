import 'package:flutter/material.dart';

class ResponsiveBreakpoints {
  static const double phone = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

extension ScreenSize on BuildContext {
  bool get isPhone => MediaQuery.of(this).size.width < ResponsiveBreakpoints.phone;
  bool get isTablet =>
      MediaQuery.of(this).size.width >= ResponsiveBreakpoints.phone &&
      MediaQuery.of(this).size.width < ResponsiveBreakpoints.tablet;
  bool get isDesktop => MediaQuery.of(this).size.width >= ResponsiveBreakpoints.desktop;
}
