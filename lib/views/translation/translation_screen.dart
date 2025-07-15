import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../service/openai_service.dart';
import '../../utils/app_constns.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/styles.dart';
import 'package:flutter_tts/flutter_tts.dart';


class TranslationScreen extends StatefulWidget {
  final String inputText;
  final String sourceLanguage;
  final String targetLanguage;
  const TranslationScreen({
    required this.inputText,
    Key? key,
    required this.sourceLanguage,
    required this.targetLanguage,
  }) : super(key: key);

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _translator = OpenAIService(AppConstns.gptToke);

  String translatedText = '';
  bool _isTranslating = false;
  bool _hasText = false;

  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _inputController.text = widget.inputText;
    _onTranslatePressed();
    _inputController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _inputController.text.isNotEmpty;
    });
  }

  void _clearText() {
    if (_hasText) {
      setState(() {
        _inputController.clear();
        translatedText = '';
      });
    }
  }

  void _translateText() {
    if (_hasText && _inputController.text.isNotEmpty) {
      setState(() {
        _isTranslating = true;
      });

      _onTranslatePressed();
    }
  }

  Future<void> _onTranslatePressed() async {
    setState(() => _isTranslating = true);
    try {
      final result = await _translator.translate(
        widget.sourceLanguage,
        widget.targetLanguage,
        _inputController.text,
      );
      setState(() => translatedText = result);
    } catch (e) {
      setState(() => translatedText = 'Error: $e');
    } finally {
      setState(() => _isTranslating = false);
    }
  }

  void _speakText(String text,String language ) async {
    await flutterTts.setLanguage(language); // You can make this dynamic per language
    await flutterTts.setSpeechRate(0.5); // Optional: Adjust rate
    await flutterTts.speak(text);
    debugPrint(text);
  }


  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Translation',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(Images.map)),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input Area
                    Container(
                      width: double.infinity,
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
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  widget.sourceLanguage,
                                  style: labelSmall(context).copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: textColorLight,
                                  ),
                                ),
                              ),
                            ],
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
                                focusedErrorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 16.0),
                                child: GestureDetector(
                                    onTap: () {
                                      _speakText(_inputController.text, 'en-US');
                                    },
                                    child: Icon(Icons.volume_up,
                                        color: Colors.blue, size: 24)),
                              ),
                            ],
                          ),
                          // Action buttons
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: Colors.grey[200]!),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: _hasText ? _clearText : null,
                                  style: TextButton.styleFrom(
                                    foregroundColor: textColorLight,
                                  ),
                                  child: Text(
                                    'Clear',
                                    style: labelSmall(context).copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: _hasText
                                          ? textColorLight
                                          : hintTextColor,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: _hasText && !_isTranslating
                                      ? _translateText
                                      : null,
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        _hasText ? primaryColor : hintTextColor,
                                  ),
                                  child: _isTranslating
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.blue,
                                          ),
                                        )
                                      : Text(
                                          'Translate',
                                          style: labelSmall(context).copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: _hasText
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
                    // Translated output
                    if (translatedText.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.targetLanguage,
                              style: const TextStyle(
                                fontSize: 16,
                                color: textColorLight,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              translatedText,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => _copyText(translatedText),
                                  child: const Icon(Icons.copy,
                                      color: Colors.blue, size: 20),
                                ),
                                const SizedBox(width: 12),
                                GestureDetector(
                                  onTap: () => _speakText(translatedText,'fr'),
                                  child: const Icon(Icons.volume_up,
                                      color: Colors.blue, size: 24),
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
