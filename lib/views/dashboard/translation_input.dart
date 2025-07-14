import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/styles.dart';

class TranslationInput extends StatefulWidget {
  final String placeholder;
  final VoidCallback? onClear;
  final VoidCallback? onTranslate;
  final Function(String)? onTextChanged;
  final double height;

  const TranslationInput({
    Key? key,
    this.placeholder = 'Write to translate',
    this.onClear,
    this.onTranslate,
    this.onTextChanged,
    this.height = 300,
  }) : super(key: key);

  @override
  State<TranslationInput> createState() => _TranslationInputState();
}

class _TranslationInputState extends State<TranslationInput> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _textController.text.isNotEmpty;
    });
    widget.onTextChanged?.call(_textController.text);
  }

  void _clearText() {
    _textController.clear();
    widget.onClear?.call();
  }

  void _translate() {
    if (_hasText) {
      widget.onTranslate?.call();
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: widget.height,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
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
                    hintText: widget.placeholder,
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
                  onChanged: (text) => widget.onTextChanged?.call(text),
                ),
              ),
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
                    onPressed: _hasText ? _clearText : null,
                    style: TextButton.styleFrom(
                      foregroundColor: textColorLight,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    onPressed: _hasText ? _translate : null,
                    style: TextButton.styleFrom(
                      foregroundColor: _hasText ? primaryColor :hintTextColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    child: Text(
                      'Translate',
                      style:
                      labelSmall(context).copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color:_hasText ? primaryColor :hintTextColor,
                      )
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
