import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechService {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;

  bool get isListening => _isListening;

  Future<void> initialize() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      await Permission.microphone.request();
    }
    await _speechToText.initialize();
  }

  Future<String> startListening() async {
    final Completer<String> completer = Completer<String>();
    String tempResult ='';
    _isListening = true;

    await _speechToText.listen(onResult: (speechResult) {
      tempResult = speechResult.recognizedWords;
      if (speechResult.finalResult) {
        _isListening = false;
        completer.complete(tempResult);
      }
    });
    return completer.future;
  }

  void stopListening() {
      _isListening = false;
      _speechToText.stop();
  }
}