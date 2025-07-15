import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../models/language_data.dart';
import '../../service/openai_service.dart';
import '../../utils/app_constns.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/styles.dart';
import '../choose_language/choose_language.dart';
import 'language_selector.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String sourceLanguage = '';
  String targetLanguage = '';
  final _inputController = TextEditingController();
  final _focusNode = FocusNode();
  final _translator = OpenAIService(AppConstns.gptToke);
  final FlutterTts flutterTts = FlutterTts();

  String translatedText = '';
  bool _isTranslating = false;

  // Locale codes
  late String sourceLanguageCode ;
  late String targetLanguageCode ;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
    _inputController.addListener(() {
      setState(() {}); // Refresh UI when input changes
    });
  }

  Future<void> _loadLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sourceLanguage = prefs.getString('sourceLanguage') ?? 'English USA';
      targetLanguage = prefs.getString('targetLanguage') ?? 'French';

      sourceLanguageCode = getLanguageCodeByName(sourceLanguage);
      targetLanguageCode = getLanguageCodeByName(targetLanguage);
    });
  }


  void _openLanguageSelector(bool isSource) async {
    final currentLang = isSource ? sourceLanguage : targetLanguage;
    final allLanguages = [...freeLanguages, ];

    final matchingLang = allLanguages.firstWhere(
          (lang) => lang.name == currentLang,
      orElse: () => Language(id: 1, name: 'English USA', code: 'en_US', isPremium: false),
    );

    final currentLangId = matchingLang.id;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChooseLanguage(
          selectedLanguageId: currentLangId,
          onLanguageSelected: (String selectedLanguage) async {
            final prefs = await SharedPreferences.getInstance();

            if ((isSource && selectedLanguage == targetLanguage) ||
                (!isSource && selectedLanguage == sourceLanguage)) {
              final role = isSource ? "targetLanguage" : "sourceLanguage";
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('You already selected $selectedLanguage in $role')),
              );
              return;
            }

            setState(() {
              if (isSource) {
                sourceLanguage = selectedLanguage;
                sourceLanguageCode = getLanguageCodeByName(sourceLanguage);
                prefs.setString('sourceLanguage', sourceLanguage);
              } else {
                targetLanguage = selectedLanguage;
                targetLanguageCode = getLanguageCodeByName(targetLanguage);
                prefs.setString('targetLanguage', targetLanguage);
              }
            });

          },
        ),
      ),
    );
  }

  String getLanguageCodeByName(String name) {
    final allLanguages = [...freeLanguages, ];
    return allLanguages.firstWhere((lang) => lang.name == name, orElse: () => Language(id: 0, name: '', code: 'en_US', isPremium: false)).code;
  }


  Future<void> _translateText() async {
    if (_inputController.text.isEmpty) return;

    setState(() => _isTranslating = true);
    try {
      final result = await _translator.translate(
        sourceLanguage,
        targetLanguage,
        _inputController.text,
      );
      setState(() => translatedText = result);
    } catch (e) {
      setState(() => translatedText = 'Error: $e');
    } finally {
      setState(() => _isTranslating = false);
    }
  }

  void _clearText() {
    setState(() {
      _inputController.clear();
      translatedText = '';
    });
  }

  void _speakText(String text, String langCode) async {
    await flutterTts.setLanguage(langCode);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Images.map))),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 25.sp, right: 25.sp, top: 25.sp),
              height: 80.sp,
              width: 1.sw,
              color: Theme.of(context).primaryColor,
              child: Row(
                children: [
                  Image.asset(Images.logo, height: 50.sp,),
                  const Spacer(),
                  // Icon(Icons.settings_outlined, color: textColorLight,),
                   Image.asset(Images.setting,color: textColorLight, height: 22, width: 22),
                ],
              ),
            ),

            // Language Selector
            LanguageSelector(
              sourceLanguage: sourceLanguage,
              targetLanguage: targetLanguage,
              onSwap: () async {
                final prefs = await SharedPreferences.getInstance();
                setState(() {
                  final tempLang = sourceLanguage;
                  final tempCode = sourceLanguageCode;

                  sourceLanguage = targetLanguage;
                  sourceLanguageCode = targetLanguageCode;

                  targetLanguage = tempLang;
                  targetLanguageCode = tempCode;

                  prefs.setString('sourceLanguage', sourceLanguage);
                  prefs.setString('targetLanguage', targetLanguage);
                });
              },

              onSourceLanguageChanged: (_) => _openLanguageSelector(true),
              onTargetLanguageChanged: (_) => _openLanguageSelector(false),
            ),

            // Main translation UI
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input area
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: backgroundColorLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: dividerColorLight),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                            color: textColorLight.withOpacity(.03),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              sourceLanguage,
                              style: labelSmall(context).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: textColorLight,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: _inputController,
                              focusNode: _focusNode,
                              maxLines: null,
                              style: labelSmall(context).copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: textColorLight,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: backgroundColorLight,
                                hintText: 'Write to translate',
                                hintStyle: labelSmall(context).copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: hintTextColor,
                                ),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                                child: GestureDetector(
                                  onTap: () => _speakText(_inputController.text, sourceLanguageCode),
                                  child: const Icon(Icons.volume_up, color: Colors.blue, size: 24),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: dividerColorLight),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: _inputController.text.isNotEmpty ? _clearText : null,
                                  child: Text(
                                    'Clear',
                                    style: labelSmall(context).copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: _inputController.text.isNotEmpty
                                          ? textColorLight
                                          : hintTextColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _inputController.text.isNotEmpty && !_isTranslating
                                      ? _translateText
                                      : null,
                                  child: _isTranslating
                                      ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue),
                                  )
                                      : Text(
                                    'Translate',
                                    style: labelSmall(context).copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: _inputController.text.isNotEmpty
                                          ? primaryColor
                                          : hintTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Translation output
                    if (translatedText.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColorLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: dividerColorLight),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                              color: textColorLight.withOpacity(.03),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              targetLanguage,
                              style: const TextStyle(fontSize: 16, color: textColorLight),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              translatedText,
                              style: const TextStyle(fontSize: 18, color: Colors.black, height: 1.4),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _copyText(translatedText),
                                  child: const Icon(Icons.copy, color: Colors.blue, size: 20),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () => _speakText(translatedText, targetLanguageCode),
                                  child: const Icon(Icons.volume_up, color: Colors.blue, size: 24),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
