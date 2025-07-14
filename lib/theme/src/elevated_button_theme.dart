import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:norsk_tolk/utils/styles.dart';

ElevatedButtonThemeData elevatedButtonThemeData(BuildContext context) => ElevatedButtonThemeData(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0), // No shadow
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 50.sp)), // Full width
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: borderRadiusDefault),
        ), // Rounded corners
       
        textStyle: WidgetStatePropertyAll(bodyMedium(context).copyWith(color: Colors.white)),
      ),
    );
