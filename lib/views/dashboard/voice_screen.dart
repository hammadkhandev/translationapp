// lib/views/dashboard/voice_screen.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:norsk_tolk/views/dashboard/widgets/mic_box.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../service/openai_service.dart';
import '../../utils/app_constns.dart';
import 'language_selector.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});
  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> with TickerProviderStateMixin {
  // Languages
  String sourceLang = 'en_US';
  String targetLang = 'fr_FR';

  // Services
  late stt.SpeechToText _speech1, _speech2;
  late FlutterTts _tts;
  late OpenAIService _translator;

  // Mic states
  String text1 = 'Tap Mic to talk';
  bool listening1 = false, translating1 = false;
  late AnimationController ctl1; late Animation<double> anim1;

  String text2 = 'Tap Mic to talk';
  bool listening2 = false, translating2 = false;
  late AnimationController ctl2; late Animation<double> anim2;

  @override
  void initState() {
    super.initState();
    _speech1 = stt.SpeechToText();
    _speech2 = stt.SpeechToText();
    _tts = FlutterTts();
    _translator = OpenAIService(AppConstns.gptToke);

    _speech1.initialize();
    _speech2.initialize();

    ctl1 = AnimationController(vsync: this, duration: Duration(milliseconds:1000))
      ..repeat(reverse: true);
    anim1 = Tween(begin:1.0,end:1.2).animate(CurvedAnimation(parent: ctl1, curve: Curves.ease));
    ctl1.stop();

    ctl2 = AnimationController(vsync: this, duration: Duration(milliseconds:1000))
      ..repeat(reverse: true);
    anim2 = Tween(begin:1.0,end:1.2).animate(CurvedAnimation(parent: ctl2, curve: Curves.ease));
    ctl2.stop();
  }

  @override
  void dispose() {
    ctl1.dispose(); ctl2.dispose();
    _tts.stop();
    super.dispose();
  }

  Future<void> handleMic({
    required int mic,
    required stt.SpeechToText speech,
    required AnimationController ctl,
    required Function(String) setText,
    required Function(bool) setListening,
    required Function(bool) setTranslating,
    required String currentLang,
    required String otherLang,
  }) async {
    setListening(true);
    setText('Listening...');
    ctl.repeat(reverse: true);
    await speech.listen(localeId: currentLang, onResult: (res) {
      if (res.finalResult) speech.stop();
    });
    await Future.doWhile(() => speech.isListening ? Future.delayed(Duration(milliseconds:100)) : Future.value(false));
    ctl.stop();

    setListening(false);
    setTranslating(true);
    setText('Translating...');

    final spoken = speech.lastRecognizedWords;
    final translation = await _translator.translate(currentLang.split('_')[0], otherLang.split('_')[0], spoken);

    setTranslating(false);
    setText(translation);

    await _tts.setLanguage(otherLang);
    await _tts.speak(translation);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Column(
      children:[
        // Mic 1 (source → target)
        Transform.rotate(
          angle: -math.pi,
          child: MicTextBox(
            hintText: 'Tap Mic to talk',
            displayText: text1,
            isListening: listening1,
            isTranslating: translating1,
            onClear: () => setState(() => text1 = 'Tap Mic to talk'),
            onMicTap: () => handleMic(
              mic:1, speech:_speech1, ctl:ctl1,
              setText:(v)=>setState(()=>text1=v),
              setListening:(v)=>setState(()=>listening1=v),
              setTranslating:(v)=>setState(()=>translating1=v),
              currentLang: sourceLang, otherLang: targetLang,
            ),
            animation: anim1,
          ),
        ),

        LanguageSelector(
          sourceLanguage: sourceLang,
          targetLanguage: targetLang,
        ),

        // Mic 2 (target → source)
        MicTextBox(
          hintText: 'Tap Mic to talk',
          displayText: text2,
          isListening: listening2,
          isTranslating: translating2,
          onClear: () => setState(() => text2 = 'Tap Mic to talk'),
          onMicTap: () => handleMic(
            mic:2, speech:_speech2, ctl:ctl2,
            setText:(v)=>setState(()=>text2=v),
            setListening:(v)=>setState(()=>listening2=v),
            setTranslating:(v)=>setState(()=>translating2=v),
            currentLang: targetLang, otherLang: sourceLang,
          ),
          animation: anim2,
        ),
      ],
    ));
  }
}
