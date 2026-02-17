import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/speech_to_text_provider.dart';

class SpeechPage extends ConsumerWidget {
  const SpeechPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final speech = ref.watch(speechProvider);
    final notifier = ref.read(speechProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech to Text (pt_BR)'),
        actions: [
          IconButton(
            tooltip: 'Limpar',
            onPressed: notifier.clearText,
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _InfoCard(
              isInitialized: speech.isInitialized,
              isListening: speech.isListening,
              status: speech.status,
              confidence: speech.confidence,
              errorMessage: speech.errorMessage,
            ),
            const SizedBox(height: 12),
            const Text(
              'Texto reconhecido:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    speech.recognizedText.isEmpty
                        ? '(fale algo...)'
                        : speech.recognizedText,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: speech.isInitialized
                        ? null
                        : () => notifier.initialize(),
                    icon: const Icon(Icons.power),
                    label: const Text('Inicializar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: speech.isListening
                        ? null
                        : () => notifier.startListening(localeId: 'pt_BR'),
                    icon: const Icon(Icons.mic),
                    label: const Text('Falar'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: speech.isListening ? notifier.stopListening : null,
                    icon: const Icon(Icons.stop),
                    label: const Text('Parar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed:
                        speech.isListening ? notifier.cancelListening : null,
                    icon: const Icon(Icons.cancel),
                    label: const Text('Cancelar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: speech.isListening
      //       ? notifier.stopListening
      //       : () => notifier.startListening(localeId: 'pt_BR'),
      //   icon: Icon(speech.isListening ? Icons.stop : Icons.mic),
      //   label: Text(speech.isListening ? 'Parar' : 'Push-to-talk'),
      // ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final bool isInitialized;
  final bool isListening;
  final String status;
  final double confidence;
  final String? errorMessage;

  const _InfoCard({
    required this.isInitialized,
    required this.isListening,
    required this.status,
    required this.confidence,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Inicializado: $isInitialized'),
            Text('Escutando: $isListening'),
            Text('Status: $status'),
            Text('Confiança: ${(confidence * 100).toStringAsFixed(1)}%'),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                'Erro: $errorMessage',
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}