import 'package:flutter/material.dart';

import 'colors.dart';
import 'dimens.dart';

/// theme for tablet mode

class MyTheme {
  static const String fontFamily = 'Roboto';

  static const bool _isLightMode = true;

  static bool get isLightMode => _isLightMode;

  static ThemeData lightTheme() {
    return ThemeData(
      primaryColor: MyColors.primaryColor,
      dividerColor: MyColors.greyColor,
      scaffoldBackgroundColor: MyColors.dayColor,
      primaryTextTheme: const TextTheme(
        displayLarge: TextStyle(
          color: MyColors.whiteColor,
          fontWeight: FontWeight.w700,
          fontSize: Dimens.size36,
          fontFamily: fontFamily,
        ),
        displayMedium: TextStyle(
          color: MyColors.whiteColor,
          fontWeight: FontWeight.w700,
          fontSize: Dimens.size24,
          fontFamily: fontFamily,
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      primaryColor: MyColors.primaryColor,
      dividerColor: MyColors.greyColor,
      scaffoldBackgroundColor: MyColors.nightColor,
      // cardColor: MyColors.sellColor,

      // // ignore: deprecated_member_use
      // primaryColorDark: MyColors.blackColor,
      // indicatorColor: MyColors.calendarTabColor,
      // iconTheme: const IconThemeData(
      //   color: MyColors.accentColor,
      //   size: Dimens.iconSize,
      // ),
      primaryTextTheme: const TextTheme(
        displayLarge: TextStyle(
          color: MyColors.whiteColor,
          fontWeight: FontWeight.w700,
          fontSize: Dimens.size36,
          fontFamily: fontFamily,
        ),
        displayMedium: TextStyle(
          color: MyColors.whiteColor,
          fontWeight: FontWeight.w700,
          fontSize: Dimens.size24,
          fontFamily: fontFamily,
        ),
      ),
    );
  }
}
