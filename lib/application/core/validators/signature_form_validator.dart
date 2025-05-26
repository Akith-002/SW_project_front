import 'dart:typed_data';

class SignatureFormValidator {
  static String? validateSignature(Uint8List? signature, String fieldName) {
    if (signature == null || signature.isEmpty) {
      return '$fieldName signature is required';
    }
    return null;
  }
}
