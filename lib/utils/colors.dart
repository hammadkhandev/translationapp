import 'package:flutter/material.dart';

Color primaryColor = const Color(0xff1A98FF);

Color secondaryColor = Colors.white;

// background colors#1A98FF
const Color backgroundColorLight = Colors.white;
const Color backgroundColorDark = Color(0xFF0E0E0E);

// card colors
const Color cardColorLight = Color(0xFFFAFAFA);
const Color cardColorDark = Color(0xFF181a20);

const Color transparent = Colors.transparent;

// shadow colors
const Color shadowColorLight = Color(0xFFE8E8E8);
const Color shadowColorDark = Color(0xFF3A3A3A);

// divider colors

const Color dividerColorLight = Color(0xFFF3F4F6);
const Color dividerColorDark = Color(0xFF35383F);

// disabled colors
const Color disabledColorLight = Color(0xffA0A0A0);
Color disabledColorDark = const Color(0xFFB0B0B0);

// hint colors
const Color hintColorLight = Color(0xff606060);
const Color hintColorDark = Color(0xFF909090);
const Color hintTextColor = Color(0xFF6B7280);

// text colors
const Color textColorLight = Colors.black;
const Color textColorDark = Colors.white;

// icon colors
const Color iconColorLight = Color(0xff606060);
const Color iconColorDark = Colors.white;

const Color primaryButtonBorderColor = Color.fromARGB(255, 96, 96, 96);
const Color outlinedButtonBorderLightColor = Color.fromARGB(255, 144, 144, 144);

const Color buttonColorDark = Color(0xFF35383F);
const Color buttonColorLight = Color(0xFFF7ECFF);

// gradient
LinearGradient get primaryGradient => LinearGradient(
      colors: [secondaryColor, primaryColor],
      stops: const [0.2, 1.0],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );
