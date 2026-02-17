import 'package:flutter_riverpod/legacy.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../states/speech_state.dart';

final speechProvider = StateNotifierProvider<SpeechToTextProvider, SpeechState>((ref) => SpeechToTextProvider());

class SpeechToTextProvider extends StateNotifier<SpeechState> {
  SpeechToTextProvider() : super(const SpeechState());

  final SpeechToText _speech = SpeechToText();

  // Se quiser expor:
  bool get isAvailable => _speech.isAvailable;

  Future<void> initialize() async {
    // limpa erro anterior
    state = state.copyWith(clearError: true);

    final available = await _speech.initialize(
      onStatus: _onStatus,
      onError: _onError,
      debugLogging: false,
    );

    state = state.copyWith(
      isInitialized: available,
      status: available ? 'initialized' : 'notAvailable',
    );
  }

  Future<void> startListening({
    String localeId = 'pt_BR',
    Duration listenFor = const Duration(seconds: 30),
    Duration pauseFor = const Duration(seconds: 3),
    void Function(String recognizedText, double confidence)? onListeningResult,
  }) async {
    state = state.copyWith(clearError: true);

    if (!state.isInitialized) {
      await initialize();
    }

    if (!_speech.isAvailable) {
      state = state.copyWith(
        isListening: false,
        status: 'notAvailable',
        errorMessage: 'Reconhecimento de fala indisponível neste aparelho.',
      );
      return;
    }

    if (_speech.isListening) return;

    state = state.copyWith(isListening: true, status: 'listening');

    await _speech.listen(
      localeId: localeId,
      listenFor: listenFor,
      pauseFor: pauseFor,
      onResult: (result) {
        state = state.copyWith(
          recognizedText: result.recognizedWords,
          confidence: result.confidence,
        );
        if (onListeningResult != null) {
          onListeningResult(result.recognizedWords, result.confidence);
        }
      },
    );
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
    state = state.copyWith(isListening: false, status: 'stopped');
  }

  Future<void> cancelListening() async {
    if (_speech.isListening) {
      await _speech.cancel();
    }
    state = state.copyWith(isListening: false, status: 'canceled');
  }

  void clearText() {
    state = state.copyWith(recognizedText: '', confidence: 0.0);
  }

  void _onStatus(String status) {
    // status típicos: listening, notListening, done
    final listeningNow = _speech.isListening;

    state = state.copyWith(
      status: status,
      isListening: listeningNow,
    );

    // quando terminar, garante flag
    if (status == 'done' || status == 'notListening') {
      state = state.copyWith(isListening: false);
    }
  }

  void _onError(SpeechRecognitionError error) {
    state = state.copyWith(
      isListening: false,
      status: 'error',
      errorMessage: '${error.errorMsg} (permanent: ${error.permanent})',
    );
  }
}