import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:norsk_tolk/views/dashboard/voice_input.dart';
import 'package:norsk_tolk/views/dashboard/widgets/mic_box.dart';

import 'language_selector.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> with TickerProviderStateMixin{
  String sourceLanguage = 'English USA';
  String targetLanguage = 'French';
  // Mic 1 state
  String displayText1 = 'Please tab Mic to Talk';
  bool _isListening1 = false;
  bool _isTranslating1 = false;

// Mic 2 state
  String displayText2 = 'Please tab Mic to Talk';
  bool _isListening2 = false;
  bool _isTranslating2 = false;

// Animations
  late AnimationController _pulseController1;
  late Animation<double> _pulseAnimation1;

  late AnimationController _pulseController2;
  late Animation<double> _pulseAnimation2;
  @override
  void initState() {
    super.initState();

    _pulseController1 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation1 = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController1,
      curve: Curves.easeInOut,
    ));

    _pulseController2 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation2 = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController2,
      curve: Curves.easeInOut,
    ));
  }
  void _startListening1() async {
    setState(() {
      _isListening1 = true;
      displayText1 = 'Listening...';
    });

    _pulseController1.repeat(reverse: true);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isListening1 = false;
      _isTranslating1 = true;
      displayText1 = 'Processing...';
    });

    _pulseController1.stop();
    _pulseController1.reset();

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isTranslating1 = false;
      displayText1 = 'Bonjour, comment allez-vous?';
    });
  }

  void _startListening2() async {
    setState(() {
      _isListening2 = true;
      displayText2 = 'Listening...';
    });

    _pulseController2.repeat(reverse: true);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isListening2 = false;
      _isTranslating2 = true;
      displayText2 = 'Processing...';
    });

    _pulseController2.stop();
    _pulseController2.reset();

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isTranslating2 = false;
      displayText2 = 'Hola, ¿cómo estás?';
    });
  }

  void _clearText1() {
    setState(() {
      displayText1 = 'Please tab Mic to Talk';
    });
  }

  void _clearText2() {
    setState(() {
      displayText2 = 'Please tab Mic to Talk';
    });
  }
  @override
  void dispose() {
    _pulseController1.dispose();
    _pulseController2.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Transform.rotate(
              angle: -math.pi / 1.0,
              child: MicTextBox(
                hintText: 'Please tab Mic to Talk',
                displayText: displayText1,
                isListening: _isListening1,
                isTranslating: _isTranslating1,
                onClear: _clearText1,
                onMicTap: _startListening1,
                animation: _pulseAnimation1,
              ),
            ),
      
            LanguageSelector(
              sourceLanguage: sourceLanguage,
              targetLanguage: targetLanguage,
            ),
      
            MicTextBox(
              hintText: 'Please tab Mic to Talk',
              displayText: displayText2,
              isListening: _isListening2,
              isTranslating: _isTranslating2,
              onClear: _clearText2,
              onMicTap: _startListening2,
              animation: _pulseAnimation2,
            ),
      
      
          ],
        ),
      ),
    );
  }
}
