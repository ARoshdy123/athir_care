package com.example.doctor

import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterFragmentActivity() {
    private val channelName = "doctor/downloads"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    // ── NEW generic method (used by DownloadService) ──────────
                    "saveFileToDownloads" -> {
                        val fileName = call.argument<String>("fileName")
                        val bytes = call.argument<ByteArray>("bytes")
                        val mimeType = call.argument<String>("mimeType") ?: "application/octet-stream"

                        if (fileName.isNullOrBlank() || bytes == null) {
                            result.error("INVALID_ARGS", "fileName or bytes missing", null)
                            return@setMethodCallHandler
                        }
                        try {
                            val savedPath = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                saveToDownloadsMediaStore(fileName, bytes, mimeType)
                            } else {
                                @Suppress("DEPRECATION")
                                saveToDownloadsLegacy(fileName, bytes)
                            }
                            result.success(savedPath)
                        } catch (e: Exception) {
                            result.error("SAVE_FAILED", e.message, null)
                        }
                    }

                    // ── Legacy method name kept for backward-compat ───────────
                    "savePdfToDownloads" -> {
                        val fileName = call.argument<String>("fileName")
                        val bytes = call.argument<ByteArray>("bytes")

                        if (fileName.isNullOrBlank() || bytes == null) {
                            result.error("INVALID_ARGS", "fileName or bytes missing", null)
                            return@setMethodCallHandler
                        }
                        try {
                            val savedPath = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                saveToDownloadsMediaStore(fileName, bytes, "application/pdf")
                            } else {
                                @Suppress("DEPRECATION")
                                saveToDownloadsLegacy(fileName, bytes)
                            }
                            result.success(savedPath)
                        } catch (e: Exception) {
                            result.error("SAVE_FAILED", e.message, null)
                        }
                    }

                    // ── Returns the device SDK level so Dart can branch ───────
                    "getSdkInt" -> {
                        result.success(Build.VERSION.SDK_INT)
                    }

                    else -> result.notImplemented()
                }
            }
    }

    // ── MediaStore (Android 10+) ──────────────────────────────────────────────

    private fun saveToDownloadsMediaStore(
        fileName: String,
        bytes: ByteArray,
        mimeType: String,
    ): String {
        val values = ContentValues().apply {
            put(MediaStore.Downloads.DISPLAY_NAME, fileName)
            put(MediaStore.Downloads.MIME_TYPE, mimeType)
            put(MediaStore.Downloads.RELATIVE_PATH, Environment.DIRECTORY_DOWNLOADS)
            put(MediaStore.Downloads.IS_PENDING, 1)
        }

        val resolver = contentResolver
        val uri = resolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
            ?: throw IllegalStateException("Unable to create MediaStore entry")

        resolver.openOutputStream(uri)?.use { output ->
            output.write(bytes)
            output.flush()
        } ?: throw IllegalStateException("Unable to open output stream")

        values.clear()
        values.put(MediaStore.Downloads.IS_PENDING, 0)
        resolver.update(uri, values, null, null)

        return uri.toString()
    }

    // ── Legacy Downloads folder (Android < 10) ────────────────────────────────

    @Suppress("DEPRECATION")
    private fun saveToDownloadsLegacy(fileName: String, bytes: ByteArray): String {
        val downloadsDir =
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        if (!downloadsDir.exists()) downloadsDir.mkdirs()
        val file = File(downloadsDir, fileName)
        file.outputStream().use { it.write(bytes) }
        return file.absolutePath
    }
}
