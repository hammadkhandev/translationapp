import 'package:flutter/material.dart';

import '../../../utils/colors.dart';
import '../../../utils/images.dart';
import '../../../utils/styles.dart';


class MicTextBox extends StatelessWidget {
  final String hintText;
  final String displayText;
  final bool isListening;
  final bool isTranslating;
  final VoidCallback? onClear;
  final VoidCallback? onMicTap;
  final Animation<double> animation;

  const MicTextBox({
    super.key,
    required this.hintText,
    required this.displayText,
    required this.isListening,
    required this.isTranslating,
    required this.onClear,
    required this.onMicTap,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColorLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 3),
            color: textColorLight.withOpacity(.03),
          ),
        ],
        border: Border.all(color: dividerColorLight),
      ),
      child: Column(
        children: [
          // Text display area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: TextEditingController(text: displayText),
                readOnly: true,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: labelSmall(context).copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: textColorLight,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: backgroundColorLight,
                  hintText: hintText,
                  hintStyle: labelSmall(context).copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: hintTextColor,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          // Bottom bar with clear and mic
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: dividerColorLight, width: 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: displayText != hintText ? onClear : null,
                  child: Text(
                    'Clear',
                    style: TextStyle(
                      fontSize: 18,
                      color: displayText != hintText
                          ? Colors.black
                          : Colors.grey[400],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isListening ? animation.value : 1.0,
                      child: GestureDetector(
                        onTap: !isListening && !isTranslating ? onMicTap : null,
                        child: Container(
                          width: 40,
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isListening
                                ? Colors.red
                                : (isTranslating
                                ? Colors.orange
                                : Colors.blue),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (isListening
                                    ? Colors.red
                                    : (isTranslating
                                    ? Colors.orange
                                    : Colors.blue))
                                    .withOpacity(0.3),
                                spreadRadius: isListening ? 8 : 0,
                                blurRadius: isListening ? 12 : 0,
                                offset: isListening
                                    ? const Offset(0, 2)
                                    : Offset.zero,
                              ),
                            ],
                          ),
                          child: isTranslating
                              ? const Icon(
                            Icons.hourglass_empty,
                            color: Colors.white,
                            size: 24,
                          )
                              : const SizedBox(
                            width: 24,
                            height: 24,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: ImageIcon(
                                AssetImage(Images.mic),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
