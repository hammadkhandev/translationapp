import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:norsk_tolk/views/common/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../models/language_data.dart';
import '../../service/openai_service.dart';
import '../../utils/app_constns.dart';
import '../choose_language/choose_language.dart';
import '../dashboard/widgets/mic_box.dart';
import 'language_selector.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});
  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> with TickerProviderStateMixin {
  late stt.SpeechToText _speech;
  late FlutterTts _tts;
  late OpenAIService _translator;

  // Locale codes
  late String sourceLanguageCode ;
  late String targetLanguageCode ;

  String  sourceLanguage ='', targetLanguage=''  ;

  // Display texts
  String sourceText = 'Tap Mic to talk';
  String targetText = 'Tap Mic to talk';

  bool translatingEn = false, translatingUr = false;
  bool listeningEn = false, listeningUr = false;

  late AnimationController ctlEn, ctlUr;
  late Animation<double> animEn, animUr;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
    _speech = stt.SpeechToText();
    _tts = FlutterTts();
    _translator = OpenAIService(AppConstns.gptToke);

    _speech.initialize();
    ctlEn = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    animEn = Tween(begin:1.0, end:1.2).animate(CurvedAnimation(parent: ctlEn, curve: Curves.easeInOut));
    ctlUr = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    animUr = Tween(begin:1.0, end:1.2).animate(CurvedAnimation(parent: ctlUr, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    ctlEn.dispose();
    ctlUr.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> _loadLanguages() async {
    final prefs = await SharedPreferences.getInstance();
    final allLanguages = [...freeLanguages, ];

    final savedSource = prefs.getString('sourceLanguage') ?? 'English USA';
    final savedTarget = prefs.getString('targetLanguage') ?? 'French';

    final sourceLang = allLanguages.firstWhere(
          (lang) => lang.name == savedSource,
      orElse: () => freeLanguages.first,
    );

    final targetLang = allLanguages.firstWhere(
          (lang) => lang.name == savedTarget,
      orElse: () => freeLanguages.first,
    );

    setState(() {
      sourceLanguage = sourceLang.name;
      targetLanguage = targetLang.name;
      sourceLanguageCode = sourceLang.code;
      targetLanguageCode = targetLang.code;
    });
  }

  void _openLanguageSelector(bool isSource) async {
    final currentLang = isSource ? sourceLanguage : targetLanguage;

    final allLanguages = [...freeLanguages, ];
    final matchingLang = allLanguages.firstWhere(
          (lang) => lang.name == currentLang,
      orElse: () => freeLanguages.first,
    );

    final currentLangId = matchingLang.id;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChooseLanguage(
          selectedLanguageId: currentLangId,
          onLanguageSelected: (String selectedLanguage) async {
            final prefs = await SharedPreferences.getInstance();

            // Prevent selecting same as the other
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

            final selectedLang = allLanguages.firstWhere(
                  (lang) => lang.name == selectedLanguage,
              orElse: () => freeLanguages.first,
            );

            setState(() {
              if (isSource) {
                sourceLanguage = selectedLang.name;
                sourceLanguageCode = selectedLang.code;
                prefs.setString('sourceLanguage', selectedLang.name);
              } else {
                targetLanguage = selectedLang.name;
                targetLanguageCode = selectedLang.code;
                prefs.setString('targetLanguage', selectedLang.name);
              }
            });
          },
        ),
      ),
    );
  }

  void _toggleMic(bool isEnMic) {
    final locale = isEnMic ? sourceLanguageCode : targetLanguageCode;
    final anim = isEnMic ? ctlEn : ctlUr;

    final listening = isEnMic ? listeningEn : listeningUr;
    if (listening) {
      _speech.stop();
      anim.stop();
    } else {
      setState(() {
        if (isEnMic) {
          listeningEn = true;
          sourceText = 'Listening...';
        } else {
          listeningUr = true;
          targetText = 'Listening...';
        }
      });
      anim.repeat(reverse: true);

      _speech.listen(
        localeId: locale,
        onResult: (res) {
          setState(() {
            if (isEnMic) sourceText = res.recognizedWords;
            else targetText = res.recognizedWords;
          });
        },
        listenFor: const Duration(seconds:30),
        pauseFor: const Duration(seconds:3),
        onSoundLevelChange: (_) {},
        cancelOnError: true,
      );

      _speech.statusListener = (status) {
        if (!_speech.isListening) {
          _onStop(isEnMic);
        }
      };
    }
  }

  Future<void> _onStop(bool wasEnMic) async {
    ctlEn.stop();
    ctlUr.stop();

    setState(() {
      listeningEn = listeningUr = false;
      if (wasEnMic) translatingUr = true;
      else translatingEn = true;
    });

    final spoken = wasEnMic ? sourceText : targetText;
    final translation = wasEnMic
        ? await _translator.translate(sourceLanguage, targetLanguage, spoken)
        : await _translator.translate(targetLanguage, sourceLanguage, spoken);

    setState(() {
      if (wasEnMic) {
        targetText = translation;
        translatingUr = false;
      } else {
        sourceText = translation;
        translatingEn = false;
      }
    });

    final speakLang = wasEnMic ? targetLanguageCode : sourceLanguageCode;
    await _tts.setLanguage(speakLang);
    await _tts.speak(translation);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: HomeWidget(
        child: Column(children: [
          // English Mic Box
          Transform.rotate(
            angle: -math.pi,
            child: MicTextBox(
              hintText: 'Tap Mic to speak',
              displayText: sourceText,
              isListening: listeningEn,
              isTranslating: translatingEn,
              onClear: () => setState(() => sourceText = 'Tap Mic to talk'),
              onMicTap: () => _toggleMic(true),
              animation: animEn,
            ),
          ),
          // Language selector
          LanguageSelector(
            sourceLanguage: sourceLanguage,
            targetLanguage: targetLanguage,
            onSwap: () async {
              final prefs = await SharedPreferences.getInstance();
              setState(() {
                // Swap language names
                final tempLang = sourceLanguage;
                sourceLanguage = targetLanguage;
                targetLanguage = tempLang;
        
                // Swap locale codes
                final tempCode = sourceLanguageCode;
                sourceLanguageCode = targetLanguageCode;
                targetLanguageCode = tempCode;
        
                // Save both to SharedPreferences
                prefs.setString('sourceLanguage', sourceLanguage);
                prefs.setString('targetLanguage', targetLanguage);
              });
            },
            onSourceLanguageChanged:(_) {
              _openLanguageSelector(true); // source
            },
            onTargetLanguageChanged: (_) {
              _openLanguageSelector(false); // target
            },
          ),
        
          // LanguageSelector can be hidden, since locale is hardcoded
          MicTextBox(
            hintText: 'Tap Mic to speak',
            displayText: targetText,
            isListening: listeningUr,
            isTranslating: translatingUr,
            onClear: () => setState(() => targetText = 'Tap Mic to talk'),
            onMicTap: () => _toggleMic(false),
            animation: animUr,
          ),
        ]),
      ),
    );
  }
}
