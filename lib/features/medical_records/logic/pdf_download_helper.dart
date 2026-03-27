import 'package:doctor/core/di/dependency_injection.dart';
import 'package:doctor/core/services/download_service.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:flutter/material.dart';

/// Thin adapter that keeps the legacy call-site API intact while
/// delegating all real work to [DownloadService].
class PdfDownloadHelper {
  const PdfDownloadHelper._();

  /// Downloads the asset at [assetPath] and shows a result SnackBar.
  ///
  /// [onProgress] receives values from 0.0 to 1.0 during the save.
  static Future<DownloadResult> downloadAssetPdf({
    required BuildContext context,
    required String assetPath,
    void Function(double)? onProgress,
  }) async {
    final service = getIt<DownloadService>();

    final result = await service.downloadFromAsset(
      assetPath: assetPath,
      mimeType: 'application/pdf',
    );

    if (!context.mounted) return result;

    if (result.success) {
      final label = result.path.isNotEmpty ? 'Saved to Downloads' : 'PDF saved';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(label),
          backgroundColor: ColorsManager.mainBlue,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: ${result.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }

    return result;
  }
}
