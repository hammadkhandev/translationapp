import 'package:flutter/material.dart';
import 'package:norsk_tolk/utils/colors.dart';
import 'package:norsk_tolk/utils/styles.dart';

BottomSheetThemeData bottomSheetThemeLight(BuildContext context) => BottomSheetThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(radiusDefault))),
      backgroundColor: backgroundColorLight,
      modalBackgroundColor: backgroundColorLight,
      elevation: 0,
    );

BottomSheetThemeData bottomSheetThemeDark(BuildContext context) => bottomSheetThemeLight(context).copyWith(
      backgroundColor: backgroundColorDark,
      modalBackgroundColor: backgroundColorDark,
    );
