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
  @override
  void initState() {
    super.initState();
    if (widget.triggerDownload) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _downloadPdf());
    }
  }

  Future<void> _downloadPdf() async {
    await PdfDownloadHelper.downloadAssetPdf(
      context: context,
      assetPath: widget.assetPath,
    );
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
          IconButton(
            icon: const Icon(Icons.download, color: ColorsManager.mainBlue),
            onPressed: _downloadPdf,
          ),
        ],
      ),
      body: PdfViewer.asset(widget.assetPath),
    );
  }
}
