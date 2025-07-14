import 'package:flutter/material.dart';

import '../../utils/colors.dart';


class LanguageSelector extends StatefulWidget {
  final String sourceLanguage;
  final String targetLanguage;
  final VoidCallback? onSwap;
  final Function(String)? onSourceLanguageChanged;
  final Function(String)? onTargetLanguageChanged;

  const LanguageSelector({
    Key? key,
    this.sourceLanguage = 'English USA',
    this.targetLanguage = 'French',
    this.onSwap,
    this.onSourceLanguageChanged,
    this.onTargetLanguageChanged,
  }) : super(key: key);

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  late String sourceLanguage;
  late String targetLanguage;

  @override
  void initState() {
    super.initState();
    sourceLanguage = widget.sourceLanguage;
    targetLanguage = widget.targetLanguage;
  }

  void _swapLanguages() {
    setState(() {
      final temp = sourceLanguage;
      sourceLanguage = targetLanguage;
      targetLanguage = temp;
    });
    widget.onSwap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Source Language
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onSourceLanguageChanged?.call(sourceLanguage),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                height: 50,
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(
                    blurRadius: 6,
                    offset: Offset(0, 3),
                    color: textColorLight.withOpacity(.03)
                  )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: dividerColorLight),
                ),
                child: Center(
                  child: Text(
                    sourceLanguage,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColorLight,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10,),
          // Swap Button
          GestureDetector(
            onTap: _swapLanguages,
            child: Container(
              padding: const EdgeInsets.all(8),

              child: const Icon(
                Icons.swap_horiz,
                size: 20,
                color: textColorLight,
              ),
            ),
          ),
          SizedBox(width: 10,),
          // Target Language
          Expanded(
            child: GestureDetector(
              onTap: () => widget.onTargetLanguageChanged?.call(targetLanguage),
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: dividerColorLight),
                  boxShadow: [BoxShadow(
                      blurRadius: 6,
                      offset: Offset(0, 3),
                      color: textColorLight.withOpacity(.03)
                  )
                  ]
                ),
                child: Center(
                  child: Text(
                    targetLanguage,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColorLight,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage widget
class LanguageSelectorDemo extends StatelessWidget {
  const LanguageSelectorDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Selector'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LanguageSelector(
              sourceLanguage: 'English USA',
              targetLanguage: 'French',
            ),
            SizedBox(height: 16),
            LanguageSelector(
              sourceLanguage: 'Spanish',
              targetLanguage: 'German',
            ),
            SizedBox(height: 16),
            LanguageSelector(
              sourceLanguage: 'Japanese',
              targetLanguage: 'Korean',
            ),
          ],
        ),
      ),
    );
  }
}