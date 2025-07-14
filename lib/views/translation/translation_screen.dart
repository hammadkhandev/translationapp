import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../../utils/styles.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({Key? key}) : super(key: key);

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final TextEditingController _inputController = TextEditingController();
  String sourceLanguage = 'English USA';
  String targetLanguage = 'French';
  String translatedText = '';
  bool _isTranslating = false;
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate with demo text
    _inputController.text = 'Hello, I want to know mre about you';
    translatedText = 'Bonjour, je voudrais en savoir plus sur vous';
    _inputController.addListener(_onTextChanged);
  }
  void _onTextChanged() {
    setState(() {
      _hasText = _inputController.text.isNotEmpty;
    });

  }




  void _clearText() {
    if (_hasText){
      setState(() {
      _inputController.clear();
      translatedText = '';
    });}
  }

  void _translateText() async {
    if (_hasText) {
      if (_inputController.text.isEmpty) return;

      setState(() {
        _isTranslating = true;
      });


      // Simulate translation delay
      await Future.delayed(const Duration(milliseconds: 800));

      setState(() {
        // Simple demo translation
        translatedText = _getDemoTranslation(_inputController.text);
        _isTranslating = false;
      });
    }
  }

  String _getDemoTranslation(String text) {
    // Simple demo translations
    final translations = {
      'Hello': 'Bonjour',
      'Hello, I want to know mre about you': 'Bonjour, je voudrais en savoir plus sur vous',
      'How are you?': 'Comment allez-vous?',
      'Thank you': 'Merci',
      'Good morning': 'Bonjour',
      'Good evening': 'Bonsoir',
    };
    return translations[text] ?? 'Translation: $text';
  }

  void _speakText(String text) {
    // Implement text-to-speech functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Speaking: $text'),
        duration: const Duration(seconds: 1),
      ),
    );
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              size: 18,
              color: Colors.black),
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
            image: DecorationImage(
                image: AssetImage(
                  Images.map,
                ))),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Source Language Section
                      Container(
                        width: double.infinity,
                        // height: 250,
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
                            // Text Input Area
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 16,
                                    top: 16,
                                    right: 16
                                  ),
                                  child: Text(
                                    sourceLanguage,
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
                                padding: const EdgeInsets.only(
                                  top: 8,
                                    left: 16,
                                    bottom: 16,
                                    right: 16
                                ),
                                child:
                                TextField(
                                  controller: _inputController,
                                  focusNode: _focusNode,
                                  maxLines: null,
                                  // expands: true,
                                  textAlignVertical: TextAlignVertical.top,
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

                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16.0),
                                  child: Icon(
                                    Icons.volume_up,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                            // Bottom Bar with Clear and Translate buttons
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
                                  // Clear Button
                                  TextButton(
                                    onPressed: _inputController.text.isNotEmpty ? _clearText : null,
                                    style: TextButton.styleFrom(
                                      foregroundColor: textColorLight,
                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                    ),
                                    child: Text(
                                        'Clear',
                                        style: labelSmall(context).copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color:_hasText ? textColorLight : hintTextColor,
                                        )
                                    ),
                                  ),

                                  // Translate Button
                                  TextButton(
                                    onPressed: _inputController.text.isNotEmpty && !_isTranslating ? _translateText : null,
                                    style: TextButton.styleFrom(
                                      foregroundColor: _hasText ? primaryColor :hintTextColor,
                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
                                        style:
                                        labelSmall(context).copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color:_inputController.text.isNotEmpty ? primaryColor :hintTextColor,
                                        )
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),


                      // Input Text Area
                      // Container(
                      //   width: double.infinity,
                      //   // padding: const EdgeInsets.all(16),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(12),
                      //     border: Border.all(color: Colors.grey[300]!),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Padding(
                      //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      //         child: Text(
                      //           sourceLanguage,
                      //           style: const TextStyle(
                      //             fontSize: 16,
                      //             color: Colors.grey,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         ),
                      //       ),
                      //       // const SizedBox(height: 12),
                      //       TextField(
                      //         controller: _inputController,
                      //         maxLines: null,
                      //         style: const TextStyle(
                      //           fontSize: 18,
                      //           color: Colors.black,
                      //           height: 1.4,
                      //         ),
                      //         decoration: const InputDecoration(
                      //           filled: true,
                      //           fillColor: Colors.white,
                      //           border: InputBorder.none,
                      //           enabledBorder: InputBorder.none,
                      //           disabledBorder: InputBorder.none,
                      //           focusedBorder: InputBorder.none,
                      //           errorBorder: InputBorder.none,
                      //           focusedErrorBorder: InputBorder.none,
                      //           hintText: 'Enter text to translate',
                      //           hintStyle: TextStyle(
                      //             color: Colors.grey,
                      //             fontSize: 18,
                      //           ),
                      //         ),
                      //       ),
                      //       const SizedBox(height: 16),
                      //
                      //       // Speaker Button for Input
                      //       GestureDetector(
                      //         onTap: () => _speakText(_inputController.text),
                      //         child: Container(
                      //           padding: const EdgeInsets.all(8),
                      //           decoration: BoxDecoration(
                      //             color: Colors.blue[50],
                      //             borderRadius: BorderRadius.circular(8),
                      //           ),
                      //           child: const Icon(
                      //             Icons.volume_up,
                      //             color: Colors.blue,
                      //             size: 24,
                      //           ),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      const SizedBox(height: 24),

                      // Bottom Action Buttons
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     TextButton(
                      //       onPressed: _inputController.text.isNotEmpty ? _clearText : null,
                      //       child: Text(
                      //         'Clear',
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           color: _inputController.text.isNotEmpty
                      //               ? Colors.black
                      //               : Colors.grey,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //     ),
                      //     TextButton(
                      //       onPressed: _inputController.text.isNotEmpty && !_isTranslating
                      //           ? _translateText
                      //           : null,
                      //       child: _isTranslating
                      //           ? const SizedBox(
                      //         width: 16,
                      //         height: 16,
                      //         child: CircularProgressIndicator(
                      //           strokeWidth: 2,
                      //           color: Colors.blue,
                      //         ),
                      //       )
                      //           : Text(
                      //         'Translate',
                      //         style: TextStyle(
                      //           fontSize: 16,
                      //           color: _inputController.text.isNotEmpty
                      //               ? Colors.blue
                      //               : Colors.grey,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 20),

                      // Translation Output Section
                      if (translatedText.isNotEmpty) ...[



                        // Translation Result
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
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
                          // BoxDecoration(
                          //   color: Colors.white,
                          //   borderRadius: BorderRadius.circular(12),
                          //   border: Border.all(color: Colors.grey[300]!),
                          // ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                targetLanguage,
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

                              // Action Buttons for Translation
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _copyText(translatedText),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      // decoration: BoxDecoration(
                                      //   color: Colors.blue[50],
                                      //   borderRadius: BorderRadius.circular(8),
                                      // ),
                                      child: const Icon(
                                        Icons.copy,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () => _speakText(translatedText),
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      // decoration: BoxDecoration(
                                      //   color: Colors.blue[50],
                                      //   borderRadius: BorderRadius.circular(8),
                                      // ),
                                      child: const Icon(
                                        Icons.volume_up,
                                        color: Colors.blue,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }
}

// Demo App
class TranslationApp extends StatelessWidget {
  const TranslationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translation App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: const TranslationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}