import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/sizes.dart';

class TElevatedButtonTheme {
  TElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        side: BorderSide(color: tSecondaryColor),
        foregroundColor: tWhiteColor,
        backgroundColor: tSecondaryColor,
        padding: EdgeInsets.symmetric(vertical: tButtonHeight)),
  );

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        elevation: 0,
        side: BorderSide(color: tSecondaryColor),
        foregroundColor: tSecondaryColor,
        backgroundColor: tWhiteColor,
        padding: EdgeInsets.symmetric(vertical: tButtonHeight)
    ),
  );
}
