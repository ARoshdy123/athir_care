import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/core/theming/styles.dart';
import 'package:doctor/features/medical_records/logic/pdf_download_helper.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String assetPath;
  final bool triggerDownload;

  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.assetPath,
    this.triggerDownload = false,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    if (widget.triggerDownload) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _downloadPdf());
    }
  }

  Future<void> _downloadPdf() async {
    if (_isDownloading) return;
    setState(() => _isDownloading = true);
    try {
      final result = await PdfDownloadHelper.downloadAssetPdf(
        context: context,
        assetPath: widget.assetPath,
      );
      // Offer "Open" button if context is still alive and save succeeded.
      if (mounted && result.success && result.path.isNotEmpty) {
        // SnackBar with Open action is already shown by PdfDownloadHelper.
        // Here we also update the AppBar icon back to normal.
      }
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: ColorsManager.darkBlue,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(widget.title, style: TextStyles.font18DarkBlueSemiBold),
        actions: [
          _isDownloading
              ? Padding(
                padding: const EdgeInsets.all(14.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      ColorsManager.mainBlue,
                    ),
                  ),
                ),
              )
              : IconButton(
                icon: const Icon(Icons.download, color: ColorsManager.mainBlue),
                onPressed: _downloadPdf,
              ),
        ],
      ),
      body: PdfViewer.asset(widget.assetPath),
    );
  }
}
