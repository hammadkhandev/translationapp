import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Padding
EdgeInsets paddingSmall = EdgeInsets.all(8.sp);
EdgeInsets paddingMedium = EdgeInsets.all(12.sp);
EdgeInsets paddingDefault = EdgeInsets.all(16.sp);

// Spacing
double spacingExtraSmall = 4.sp;
double spacingSmall = 8.sp;
double spacingMedium = 12.sp;
double spacingDefault = 16.sp;
double spacingLarge = 24.sp;
double spacingExtraLarge = 32.sp;

double get radiusSmall => 8.sp;
double get radiusDefault => 12.sp;

BorderRadius get borderRadiusSmall => BorderRadius.circular(radiusSmall);
BorderRadius get borderRadiusDefault => BorderRadius.circular(radiusDefault);

TextStyle displayLarge(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.displayLarge!.copyWith(
          fontFamily: family,
        );

TextStyle displayMedium(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.displayMedium!.copyWith(
          fontFamily: family,
        );

TextStyle displaySmall(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.displaySmall!.copyWith(
          fontFamily: family,
        );

TextStyle headlineLarge(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.headlineLarge!.copyWith(
          fontFamily: family,
        );

TextStyle headlineMedium(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.headlineMedium!.copyWith(
          fontFamily: family,
        );

TextStyle headlineSmall(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontFamily: family,
        );

TextStyle titleLarge(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.titleLarge!.copyWith(
          fontFamily: family,
        );

TextStyle titleMedium(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.titleMedium!.copyWith(
          fontFamily: family,
        );

TextStyle titleSmall(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.titleSmall!.copyWith(
          fontFamily: family,
        );

TextStyle bodyLarge(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.bodyLarge!.copyWith(
          fontFamily: family,
        );

TextStyle bodyMedium(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontFamily: family,
        );

TextStyle bodySmall(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.bodySmall!.copyWith(
          fontFamily: family,
        );

TextStyle labelLarge(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.labelLarge!.copyWith(
          fontFamily: family,
        );

TextStyle labelMedium(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.labelMedium!.copyWith(
          fontFamily: family,
        );

TextStyle labelSmall(BuildContext context, {family = 'Urbanist'}) =>
    Theme.of(context).textTheme.labelSmall!.copyWith(
          fontFamily: family,
        );
