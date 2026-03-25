import 'package:doctor/core/theming/colors.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PdfDownloadHelper {
  const PdfDownloadHelper._();

  static const MethodChannel _downloadsChannel = MethodChannel(
    'doctor/downloads',
  );

  static Future<void> downloadAssetPdf({
    required BuildContext context,
    required String assetPath,
  }) async {
    try {
      final data = await rootBundle.load(assetPath);
      final fileName = assetPath.split('/').last;
      final bytes = data.buffer.asUint8List();
      late final String savedPath;

      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        savedPath =
            await _downloadsChannel.invokeMethod<String>('savePdfToDownloads', {
              'fileName': fileName,
              'bytes': bytes,
            }) ??
            '';
      } else {
        savedPath = await FileSaver.instance.saveFile(
          name: fileName.replaceAll('.pdf', ''),
          bytes: bytes,
          ext: 'pdf',
          mimeType: MimeType.pdf,
        );
      }

      if (!context.mounted) return;

      final locationText =
          savedPath.isNotEmpty ? 'Saved to: $savedPath' : 'Saved: $fileName';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locationText),
          backgroundColor: ColorsManager.mainBlue,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
