class SpeechState {
  final bool isInitialized;
  final bool isListening;
  final String recognizedText;
  final double confidence;

  final String status; // ex: listening, done, notListening...
  final String? errorMessage;

  const SpeechState({
    this.isInitialized = false,
    this.isListening = false,
    this.recognizedText = '',
    this.confidence = 0.0,
    this.status = '',
    this.errorMessage,
  });

  SpeechState copyWith({
    bool? isInitialized,
    bool? isListening,
    String? recognizedText,
    double? confidence,
    String? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SpeechState(
      isInitialized: isInitialized ?? this.isInitialized,
      isListening: isListening ?? this.isListening,
      recognizedText: recognizedText ?? this.recognizedText,
      confidence: confidence ?? this.confidence,
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}