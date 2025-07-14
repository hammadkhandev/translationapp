import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SvgPictureDisplay extends StatelessWidget {
  final String assetName;
  final double? height;
  final double? width;
  final Function()? onTap;
  const SvgPictureDisplay({super.key, required this.assetName, this.height, this.width, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(
        assetName,
        height: height ?? 15.sp,
        width: width ?? 15.sp,
        fit: BoxFit.contain,
      ),
    );
  }
}
