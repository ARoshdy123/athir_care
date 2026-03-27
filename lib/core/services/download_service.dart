import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// Result of a [DownloadService] operation.
class DownloadResult {
  final bool success;

  /// Absolute path of the saved file, or a MediaStore URI string on Android ≥ Q.
  final String path;
  final String? error;

  const DownloadResult({
    required this.success,
    required this.path,
    this.error,
  });
}

/// Cross-platform download service.
///
/// Saves files to user-visible shared storage:
///  - **Android ≥ 10 (Q)**: MediaStore Downloads (no permission needed).
///  - **Android < 10**: `Environment.DIRECTORY_DOWNLOADS` (requires
///    `WRITE_EXTERNAL_STORAGE` which is already in the manifest).
///  - **iOS**: `NSDocumentDirectory` – visible in "Files app → On My iPhone → Doctor"
///    once `UIFileSharingEnabled` and `LSSupportsOpeningDocumentsInPlace` are set
///    in `Info.plist`.
class DownloadService {
  DownloadService(this._dio);

  final Dio _dio;

  static const _channel = MethodChannel('doctor/downloads');

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  /// Downloads a remote [url] and saves it as [fileName].
  ///
  /// [onProgress] receives values from 0.0 to 1.0 as the download progresses.
  Future<DownloadResult> downloadFromUrl(
    String url, {
    required String fileName,
    String mimeType = 'application/octet-stream',
    void Function(double progress)? onProgress,
  }) async {
    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: (received, total) {
          if (total > 0 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      final bytes = Uint8List.fromList(response.data!);
      return _saveToStorage(fileName: fileName, bytes: bytes, mimeType: mimeType);
    } catch (e) {
      return DownloadResult(success: false, path: '', error: e.toString());
    }
  }

  /// Saves raw [bytes] as [fileName] to shared storage.
  Future<DownloadResult> downloadFromBytes({
    required Uint8List bytes,
    required String fileName,
    String mimeType = 'application/octet-stream',
  }) async {
    return _saveToStorage(fileName: fileName, bytes: bytes, mimeType: mimeType);
  }

  /// Loads a Flutter asset at [assetPath] and saves it to shared storage.
  Future<DownloadResult> downloadFromAsset({
    required String assetPath,
    String? fileName,
    String mimeType = 'application/pdf',
  }) async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      final name = fileName ?? p.basename(assetPath);
      return _saveToStorage(fileName: name, bytes: bytes, mimeType: mimeType);
    } catch (e) {
      return DownloadResult(success: false, path: '', error: e.toString());
    }
  }

  // ---------------------------------------------------------------------------
  // Internal helpers
  // ---------------------------------------------------------------------------

  Future<DownloadResult> _saveToStorage({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
  }) async {
    try {
      if (Platform.isAndroid) {
        return await _saveAndroid(fileName, bytes, mimeType);
      } else if (Platform.isIOS) {
        return await _saveIos(fileName, bytes);
      } else {
        // Fallback for other platforms (Desktop etc.)
        return await _saveFallback(fileName, bytes);
      }
    } catch (e) {
      return DownloadResult(success: false, path: '', error: e.toString());
    }
  }

  // ---- Android ---------------------------------------------------------------

  Future<DownloadResult> _saveAndroid(
    String fileName,
    Uint8List bytes,
    String mimeType,
  ) async {
    // Request legacy permission on Android < 10 only.
    if (!await _requestAndroidLegacyPermissionIfNeeded()) {
      return const DownloadResult(
        success: false,
        path: '',
        error: 'Storage permission denied',
      );
    }

    final savedPath = await _channel.invokeMethod<String>('saveFileToDownloads', {
      'fileName': fileName,
      'bytes': bytes,
      'mimeType': mimeType,
    }) ?? '';

    return DownloadResult(success: true, path: savedPath);
  }

  Future<bool> _requestAndroidLegacyPermissionIfNeeded() async {
    // Android 10+ uses MediaStore – no runtime permission needed.
    // We only ask for WRITE_EXTERNAL_STORAGE on Android < 10.
    if (Platform.isAndroid) {
      final sdkInt = await _getAndroidSdkInt();
      if (sdkInt < 29) {
        final status = await Permission.storage.request();
        return status.isGranted;
      }
    }
    return true;
  }

  Future<int> _getAndroidSdkInt() async {
    try {
      final result = await _channel.invokeMethod<int>('getSdkInt');
      return result ?? 29;
    } catch (_) {
      return 29; // assume modern API
    }
  }

  // ---- iOS ------------------------------------------------------------------

  Future<DownloadResult> _saveIos(String fileName, Uint8List bytes) async {
    // Save to the app's Documents directory. With UIFileSharingEnabled +
    // LSSupportsOpeningDocumentsInPlace in Info.plist this directory is
    // visible in "Files app → On My iPhone → Doctor".
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(bytes, flush: true);
    return DownloadResult(success: true, path: file.path);
  }

  // ---- Fallback (Desktop / Web) --------------------------------------------

  Future<DownloadResult> _saveFallback(String fileName, Uint8List bytes) async {
    final dir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, fileName));
    await file.writeAsBytes(bytes, flush: true);
    return DownloadResult(success: true, path: file.path);
  }
}
