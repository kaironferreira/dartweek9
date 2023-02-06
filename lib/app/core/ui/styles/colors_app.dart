import 'package:flutter/material.dart';

class ColorsApp {
  static ColorsApp? _instance;

  ColorsApp._();

  static ColorsApp get instance {
    _instance ??= ColorsApp._();
    return _instance!;
  }

  Color get primary => const Color(0XFF39C166);
  Color get secundary => const Color(0XFFFF970A);
  Color get black800 => const Color(0XFF333333);
  Color get black700 => const Color(0XFF555555);
  Color get black300 => const Color(0XFF999999);
  Color get black200 => const Color(0XFFF1F5F9);

  // Color get primary => Color(0XFF007D21);
  // Color get secundary => Color(0XFFF88B0C);
}

extension ColorsAppExtensions on BuildContext {
  ColorsApp get colors => ColorsApp.instance;
}
