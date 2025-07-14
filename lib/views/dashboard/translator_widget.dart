


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/styles.dart';

class TranslatorWidget extends StatefulWidget {
  const TranslatorWidget({super.key});

  @override
  State<TranslatorWidget> createState() => _TranslatorWidgetState();
}

class _TranslatorWidgetState extends State<TranslatorWidget> {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        height: 300,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(
              blurRadius: 6,
              offset: Offset(0, 3),
              color: textColorLight.withOpacity(.03)
          )
          ],
          color: textColorDark,
          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: dividerColorLight),
        ),
        child: Column(
          children: [
            TextField(
                scrollPadding:EdgeInsets.zero,
              maxLines: 5,

            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Text(
                  'clear',
                  style: labelSmall(context).copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: textColorLight,
                  ),
                ),
                Text(
                  'Translate',
                  style: labelSmall(context).copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: primaryColor,
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
