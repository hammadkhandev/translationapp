import 'package:flutter/material.dart';
import 'package:norsk_tolk/utils/colors.dart';

DividerThemeData dividerThemeLight(BuildContext context) =>
    const DividerThemeData(thickness: 0.9, color: dividerColorLight, space: 0);

DividerThemeData dividerThemeDark(BuildContext context) =>
    dividerThemeLight(context).copyWith(color: dividerColorDark);
