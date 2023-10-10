import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(

        side: BorderSide(color: tSecondaryColor),
        foregroundColor: tSecondaryColor,
        padding: EdgeInsets.symmetric(vertical: tButtonHeight)),
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        side: BorderSide(color: tWhiteColor),
        foregroundColor: tWhiteColor,
        padding: EdgeInsets.symmetric(vertical: tButtonHeight)),
  );
}
