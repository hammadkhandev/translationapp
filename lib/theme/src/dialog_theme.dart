import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:norsk_tolk/utils/styles.dart';
import '../../utils/colors.dart';

DialogTheme dialogThemeLight(BuildContext context) => DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: borderRadiusDefault),
      backgroundColor: backgroundColorLight,
      insetPadding: EdgeInsets.all(30.sp),
    );

DialogTheme dialogThemeDark(BuildContext context) =>
    dialogThemeLight(context).copyWith(backgroundColor: backgroundColorDark);
