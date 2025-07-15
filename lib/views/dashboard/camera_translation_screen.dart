import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/language_data.dart';
import '../../utils/app_constns.dart';
import '../../utils/colors.dart';
import '../../utils/images.dart';
import '../choose_language/choose_language.dart';
import 'language_selector.dart';

import 'package:flutter/rendering.dart'; // For applyBoxFit

class CameraTranslationScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraTranslationScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  State<CameraTranslationScreen> createState() => _CameraTranslationScreenState();
}

class _CameraTranslationScreenState extends State<CameraTranslationScreen> {
  late CameraController _cameraController;

  bool _busy = false;
  File? _capturedImage;
  bool _isPickingImage = false;


  late String sourceLanguageCode;
  late String targetLanguageCode;
  String sourceLanguage = '', targetLanguage = '';

  List<TextElement> _elements = [];
  List<String> _translatedWords = [];

  Size? _originalImageSize;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
    _cameraController = CameraController(
      widget.cameras.first,
      ResolutionPreset.high,
      imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
    );

    _initialize();
  }

  Future<void> _initialize() async {
    await _cameraController.initialize();
    setState(() {});
  }

  Future<void> _translateWithGPTVision(File imageFile) async {
    setState(() {
      _busy = true;
      _elements.clear();
      _translatedWords.clear();
    });

    try {
      // Load image size
      final decodedImage = await decodeImageFromList(imageFile.readAsBytesSync());
      _originalImageSize = Size(decodedImage.width.toDouble(), decodedImage.height.toDouble());

      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final prompt = '''
You are an OCR translator.

Extract all visible $sourceLanguage text and return:
[
  {
    "text": "original",
    "translation": "translated to $targetLanguage",
    "box": {"x": 10, "y": 20, "w": 100, "h": 30}
  }
]

Bounding box coordinates must be in pixels.
''';

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Authorization': 'Bearer ${AppConstns.gptToke}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4.1",
          "messages": [
            {"role": "user", "content": prompt},
            {
              "role": "user",
              "content": [
                {
                  "type": "image_url",
                  "image_url": {"url": "data:image/jpeg;base64,$base64Image"}
                }
              ]
            }
          ],
          "max_tokens": 2000,
        }),
      );

      if (response.statusCode == 200) {
        log(response.body.toString());
        final body = jsonDecode(response.body);
        final content = body['choices'][0]['message']['content'];

        final start = content.indexOf('[');
        final end = content.lastIndexOf(']') + 1;
        final jsonString = content.substring(start, end);

        final List<dynamic> parsed = jsonDecode(jsonString);

        _elements = [];
        _translatedWords = [];

        for (final item in parsed) {
          final box = item['box'];
          final text = item['text'];
          final translation = item['translation'];

          _elements.add(TextElement.fromTextAndBoundingBox(
            text,
            Rect.fromLTWH(
              (box['x'] as num).toDouble(),
              (box['y'] as num).toDouble(),
              (box['w'] as num).toDouble(),
              (box['h'] as num).toDouble(),
            ),
          ));

          _translatedWords.add(translation);
        }

        setState(() {
          _capturedImage = imageFile;
          _busy = false;
        });
      } else {
        throw Exception('Failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('GPT-4.1 translation error: $e');
      setState(() => _busy = false);
    }
  }

  Future<void> _captureAndTranslate() async {
    if (_busy) return;
    final file = await _cameraController.takePicture();
    await _translateWithGPTVision(File(file.path));
  }


  Future<void> _pickFromGallery() async {
    if (_busy || _isPickingImage) return;

    _isPickingImage = true;

    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        await _translateWithGPTVision(File(pickedFile.path));
      }
    } catch (e) {
      print('Image picker error: $e');
    } finally {
      _isPickingImage = false;
    }
  }


  Future<void> _loadLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    final allLanguages = [...freeLanguages, ];

    final savedSource = prefs.getString('sourceLanguage') ?? 'English USA';
    final savedTarget = prefs.getString('targetLanguage') ?? 'French';

    final sourceLang = allLanguages.firstWhere((lang) => lang.name == savedSource);
    final targetLang = allLanguages.firstWhere((lang) => lang.name == savedTarget);

    setState(() {
      sourceLanguage = sourceLang.name;
      targetLanguage = targetLang.name;
      sourceLanguageCode = sourceLang.code;
      targetLanguageCode = targetLang.code;
    });
  }

  void _copyText(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard'), duration: Duration(seconds: 1)),
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();

    super.dispose();
  }


  void _openLanguageSelector(bool isSource) async {
    if (_capturedImage != null) {
      // Clear image and show camera preview first
      setState(() {
        _capturedImage = null;
        _elements.clear();
        _translatedWords.clear();
      });

      // Give the UI a frame to update before navigating
      await Future.delayed(Duration(milliseconds: 100));
    }
    final currentLang = isSource ? sourceLanguage : targetLanguage;

    // Combine both lists and find matching language
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
                SnackBar(
                  content: Text('You already selected $selectedLanguage in $role'),
                ),
              );
              return;
            }

            setState(() {
              if (isSource) {
                sourceLanguage = selectedLanguage;
                prefs.setString('sourceLanguage', selectedLanguage);
              } else {
                targetLanguage = selectedLanguage;
                prefs.setString('targetLanguage', selectedLanguage);
              }
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_cameraController.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return WillPopScope(
      onWillPop: () async {
        if (_capturedImage != null) {
          setState(() {
            _capturedImage = null;
            _elements.clear();
            _translatedWords.clear();
          });
          return false;
        }
        return true;
      },
      child: LayoutBuilder(builder: (context, constraints) {
        Rect displayedImageRect = Rect.zero;

        if (_capturedImage != null && _originalImageSize != null) {
          final boxFit = BoxFit.contain;
          final inputSize = _originalImageSize!;
          final outputSize = Size(constraints.maxWidth, constraints.maxHeight);

          final fittedSizes = applyBoxFit(boxFit, inputSize, outputSize);
          displayedImageRect = Alignment.center.inscribe(fittedSizes.destination, Offset.zero & outputSize);
        } else {
          // For CameraPreview, use full screen
          displayedImageRect = Rect.fromLTWH(0, 0, constraints.maxWidth, constraints.maxHeight);
        }

        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fromRect(
                rect: displayedImageRect,
                child: _capturedImage != null
                    ? Image.file(_capturedImage!, fit: BoxFit.contain)
                    : CameraPreview(_cameraController),
              ),

              Positioned(
                top: 40,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    if (_capturedImage != null) {
                      setState(() {
                        _capturedImage = null;
                        _elements.clear();
                        _translatedWords.clear();
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
              ),

              Positioned(
                top: 60,
                left: 0,
                right: 0,
                child: LanguageSelector(
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
              ),

              if (_capturedImage != null)
                Positioned(
                  bottom: 60,
                  right: 40,
                  child: GestureDetector(
                    onTap: () => _copyText(_translatedWords.join(" ")),
                    child: Icon(Icons.copy, color: primaryColor),
                  ),
                )
              else ...[
                Positioned(
                  bottom: 60,
                  left: 40,
                  child: GestureDetector(
                    onTap: () async {
                      if (!_isPickingImage && !_busy) {
                        await _pickFromGallery();
                      }
                    },
                    child: Image.asset(Images.gallery, color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: MediaQuery.of(context).size.width / 2 - 25,
                  child: GestureDetector(
                    onTap: _captureAndTranslate,
                    child: Container(
                      height: 55,
                      width: 55,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                      ),
                      child: Image.asset(Images.tr, fit: BoxFit.scaleDown),
                    ),
                  ),
                ),
              ],

              if (_elements.isNotEmpty &&
                  _translatedWords.isNotEmpty &&
                  _capturedImage != null &&
                  _originalImageSize != null)
                IgnorePointer(
                  child: CustomPaint(
                    painter: _TranslatorPainter(
                      elements: _elements,
                      translations: _translatedWords,
                      originalImageSize: _originalImageSize!,
                      displayedImageRect: displayedImageRect,
                    ),
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                  ),
                ),

              if (_busy)
                const Center(child: CircularProgressIndicator(color: Colors.white)),
            ],
          ),
        );
      }),
    );
  }
}

class _TranslatorPainter extends CustomPainter {
  final List<TextElement> elements;
  final List<String> translations;

  final Size originalImageSize;
  final Rect displayedImageRect;

  _TranslatorPainter({
    required this.elements,
    required this.translations,
    required this.originalImageSize,
    required this.displayedImageRect,
  });

  final Paint _boxPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = Colors.black.withOpacity(0.5);

  double _calculateBestFontSize({
    required TextPainter textPainter,
    required String text,
    required double maxWidth,
    required double maxHeight,
    double minFontSize = 4,
    double maxFontSize = 100,
  }) {
    double left = minFontSize;
    double right = maxFontSize;
    double bestSize = minFontSize;

    while (right - left > 0.5) {
      final mid = (left + right) / 2;

      textPainter.text = TextSpan(
        text: text,
        style: TextStyle(fontSize: mid),
      );
      textPainter.layout(maxWidth: maxWidth);

      if (textPainter.height <= maxHeight && textPainter.width <= maxWidth) {
        bestSize = mid;
        left = mid;
      } else {
        right = mid;
      }
    }

    return bestSize;
  }


  @override
  void paint(Canvas canvas, Size size) {
    final tp = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    final scaleX = displayedImageRect.width / originalImageSize.width;
    final scaleY = displayedImageRect.height / originalImageSize.height;

    for (int i = 0; i < elements.length; i++) {
      final originalRect = elements[i].boundingBox;

      final scaledRect = Rect.fromLTWH(
        displayedImageRect.left + originalRect.left * scaleX,
        displayedImageRect.top + originalRect.top * scaleY,
        originalRect.width * scaleX,
        originalRect.height * scaleY,
      );

      canvas.drawRect(scaledRect, _boxPaint);

      final bestFontSize = _calculateBestFontSize(
        textPainter: tp,
        text: translations[i],
        maxWidth: scaledRect.width,
        maxHeight: scaledRect.height,
      );

      tp.text = TextSpan(
        text: translations[i],
        style: TextStyle(color: Colors.white, fontSize: bestFontSize),
      );

      tp.layout(maxWidth: scaledRect.width);

      final yOffset = scaledRect.top + (scaledRect.height - tp.height) / 2;
      final xOffset = scaledRect.left + (scaledRect.width - tp.width) / 2;

      tp.paint(canvas, Offset(xOffset, yOffset));
    }
  }

  @override
  bool shouldRepaint(covariant _TranslatorPainter old) =>
      old.elements != elements || old.translations != translations;
}

class TextElement {
  final String text;
  final Rect boundingBox;

  TextElement({required this.text, required this.boundingBox});

  factory TextElement.fromTextAndBoundingBox(String t, Rect box) =>
      TextElement(text: t, boundingBox: box);
}
