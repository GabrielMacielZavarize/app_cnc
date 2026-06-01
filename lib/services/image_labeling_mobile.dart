// Implementação real — Android/iOS
// ignore: depend_on_referenced_packages
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

/// Classifica uma imagem e retorna lista de labels com confiança.
/// Usa o modelo MobileNet V3 embutido no Google ML Kit.
Future<List<Map<String, dynamic>>> classificarImagem(String imagemPath) async {
  final options = ImageLabelerOptions(confidenceThreshold: 0.25);
  final labeler = ImageLabeler(options: options);
  try {
    final inputImage = InputImage.fromFilePath(imagemPath);
    final labels    = await labeler.processImage(inputImage);
    return labels
        .map((l) => {'label': l.label, 'confidence': l.confidence})
        .toList();
  } catch (_) {
    return [];
  } finally {
    labeler.close();
  }
}
