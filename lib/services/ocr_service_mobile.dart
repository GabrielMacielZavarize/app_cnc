// Implementação real do OCR — usada apenas em Android/iOS
// ignore: depend_on_referenced_packages
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Lê o texto de uma imagem pelo caminho do arquivo.
/// Retorna string vazia em caso de erro.
Future<String> reconhecerTexto(String imagemPath) async {
  final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
  try {
    final inputImage = InputImage.fromFilePath(imagemPath);
    final result     = await recognizer.processImage(inputImage);
    return result.text;
  } catch (_) {
    return '';
  } finally {
    recognizer.close();
  }
}
