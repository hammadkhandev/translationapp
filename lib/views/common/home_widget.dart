


import 'package:flutter/material.dart';

import '../../utils/images.dart';

class HomeWidget extends StatelessWidget {
  final Widget child;
  const HomeWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage( // AssetImage is not const
                Images.map,
              ))),
      child: child,
    );
  }
}