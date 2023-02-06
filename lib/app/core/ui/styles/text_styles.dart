import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  static TextStyles? _instance;

  TextStyles._();

  static TextStyles get instance {
    _instance ??= TextStyles._();
    return _instance!;
  }

  // String get font => 'mplus1';

  TextStyle get textLight => GoogleFonts.nunito(
        fontWeight: FontWeight.w300,
      );

  TextStyle get textRegular => GoogleFonts.nunito(
        fontWeight: FontWeight.normal,
      );

  TextStyle get textMedium => GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
      );

  TextStyle get textSemiBold => GoogleFonts.nunito(
        fontWeight: FontWeight.w600,
      );

  TextStyle get textBold => GoogleFonts.nunito(
        fontWeight: FontWeight.bold,
      );

  TextStyle get textExtraBold =>
      GoogleFonts.nunito(fontWeight: FontWeight.w800);

  TextStyle get textButtonLabel => textBold.copyWith(fontSize: 14);

  TextStyle get textTitle => textBold.copyWith(fontSize: 26);
}

extension TextStylesExtensions on BuildContext {
  TextStyles get textStyles => TextStyles.instance;
}
