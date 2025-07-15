

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:norsk_tolk/views/dashboard/translation_input.dart';

import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../translation/translation_screen.dart';
import 'language_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String inputText = '';
  String translatedText = '';

  String sourceLanguage = 'English USA';
  String targetLanguage = 'French';

  void _onTextChanged(String text) {
    setState(() {
      inputText = text;
    });
  }

  void _clearText() {
    setState(() {
      inputText = '';
      translatedText = '';
    });
  }

  void _translateText() {
    // Simulate translation
    setState(() {
      translatedText = 'Translated: $inputText';
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => TranslationScreen(
              inputText: inputText,
              sourceLanguage: sourceLanguage,
              targetLanguage: targetLanguage,
            )));
  }
  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    Images.map,
                  ))),
          child: Column(
            children: [
              // Image.asset(
              //   Images.map,
              //   height: 1.sh,
              //   width: 1.sw,
              //   fit: BoxFit.cover,
              // ),
              Container(
                padding: EdgeInsets.only(left: 25.sp, right: 25.sp, top: 25.sp),
                height: 80.sp,
                width: 1.sw,
                color: Theme.of(context).primaryColor,
                child: Row(
                  children: [
                    Image.asset(
                      Images.splashLogo,
                      height: 50.sp,
                      width: 100.sp,
                    ),
                    Spacer(),
                    Icon(
                      Icons.settings_outlined,
                      color: textColorLight,
                    ),
                  ],
                ),
              ),
              LanguageSelector(
                sourceLanguage: sourceLanguage,
                targetLanguage: targetLanguage,
              ),
              // TranslatorWidget(),
              TranslationInput(
                onTextChanged: _onTextChanged,
                onClear: _clearText,
                onTranslate: _translateText,
              ),
              // Positioned(
              //   bottom: 120.sp,
              //   child: LanguageSwapSelector(),
              // ),
            ],
          ),
        ));
  }
}
