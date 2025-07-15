

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/styles.dart';
import 'language_selector.dart';

class VoiceTranslationScreen extends StatefulWidget {
  const VoiceTranslationScreen({Key? key}) : super(key: key);

  @override
  State<VoiceTranslationScreen> createState() => _VoiceTranslationScreenState();
}

class _VoiceTranslationScreenState extends State<VoiceTranslationScreen>
    with TickerProviderStateMixin {
  String sourceLanguage = 'English USA';
  String targetLanguage = 'French';
  String displayText = 'Please tab Mic to Talk';
  bool _isListening = false;
  bool _isTranslating = false;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _swapLanguages() {
    setState(() {
      final temp = sourceLanguage;
      sourceLanguage = targetLanguage;
      targetLanguage = temp;
    });
  }

  void _startListening() async {
    setState(() {
      _isListening = true;
      displayText = 'Listening...';
    });

    _pulseController.repeat(reverse: true);

    // Simulate voice recognition
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isListening = false;
      _isTranslating = true;
      displayText = 'Processing...';
    });

    _pulseController.stop();
    _pulseController.reset();

    // Simulate translation
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isTranslating = false;
      displayText = 'Bonjour, comment allez-vous?';
    });
  }

  void _clearText() {
    setState(() {
      displayText = 'Please tab Mic to Talk';
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Column(
          children: [
            Column(
              children: [

                Container(
                  height:300,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                  color: backgroundColorLight,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(
                      blurRadius: 6,
                      offset: Offset(0, 3),
                      color: textColorLight.withOpacity(.03)
                  )
                  ],
                  border: Border.all(color: dividerColorLight),
                ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: TextEditingController(),
                            // focusNode: _focusNode,
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
                              hintText: 'Please tab Mic to Talk',
                              hintStyle: labelSmall(context).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color:hintTextColor,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            // onChanged: (text) => widget.onTextChanged?.call(text),
                          ),
                        ),
                      ),
                      // Bottom Bar with Clear and Mic buttons
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: dividerColorLight,width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Clear Button
                            TextButton(
                              onPressed: displayText != 'Please tab Mic to Talk' ? _clearText : null,
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: displayText != 'Please tab Mic to Talk'
                                      ? Colors.black
                                      : Colors.grey[400],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // Translate Button
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _isListening ? _pulseAnimation.value : 1.0,
                                  child: GestureDetector(
                                    onTap: !_isListening && !_isTranslating ? _startListening : null,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: _isListening
                                            ? Colors.red
                                            : (_isTranslating ? Colors.orange : Colors.blue),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: (_isListening
                                                ? Colors.red
                                                : (_isTranslating ? Colors.orange : Colors.blue))
                                                .withOpacity(0.3),
                                            spreadRadius: _isListening ? 8 : 0,
                                            blurRadius: _isListening ? 12 : 0,
                                            offset:  _isListening ? Offset(0, 2): Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child:_isTranslating
                                          ? Icon(
                                        Icons.hourglass_empty,
                                        color: Colors.white,
                                        size: 24,
                                      ):SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: FittedBox(
                                          fit: BoxFit.contain, // or BoxFit.scaleDown
                                          child: Image.asset(
                                            Images.mic,
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
                ),
                LanguageSelector(
                  sourceLanguage: sourceLanguage,
                  targetLanguage: targetLanguage,
                ),
                Container(
                  height:300,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: backgroundColorLight,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(
                        blurRadius: 6,
                        offset: Offset(0, 3),
                        color: textColorLight.withOpacity(.03)
                    )
                    ],
                    border: Border.all(color: dividerColorLight),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TextField(
                            controller: TextEditingController(),
                            // focusNode: _focusNode,
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
                              hintText: 'Please tab Mic to Talk',
                              hintStyle: labelSmall(context).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color:hintTextColor,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                            // onChanged: (text) => widget.onTextChanged?.call(text),
                          ),
                        ),
                      ),
                      // Bottom Bar with Clear and Mic buttons
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: dividerColorLight,width: 1),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Clear Button
                            TextButton(
                              onPressed: displayText != 'Please tab Mic to Talk' ? _clearText : null,
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: displayText != 'Please tab Mic to Talk'
                                      ? Colors.black
                                      : Colors.grey[400],
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),

                            // Translate Button
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _isListening ? _pulseAnimation.value : 1.0,
                                  child: GestureDetector(
                                    onTap: !_isListening && !_isTranslating ? _startListening : null,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: _isListening
                                            ? Colors.red
                                            : (_isTranslating ? Colors.orange : Colors.blue),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: (_isListening
                                                ? Colors.red
                                                : (_isTranslating ? Colors.orange : Colors.blue))
                                                .withOpacity(0.3),
                                            spreadRadius: _isListening ? 8 : 0,
                                            blurRadius: _isListening ? 12 : 0,
                                            offset:  _isListening ? Offset(0, 2): Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                      child:_isTranslating
                                          ? Icon(
                                        Icons.hourglass_empty,
                                        color: Colors.white,
                                        size: 24,
                                      ):SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: FittedBox(
                                          fit: BoxFit.contain, // or BoxFit.scaleDown
                                          child: Image.asset(
                                            Images.mic,
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
                ),
                const SizedBox(height: 40),
              ],
            ),
      

          ],
        ),
    )
    ;
  }
}

