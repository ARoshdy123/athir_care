import 'package:doctor/core/helpers/extensions.dart';
import 'package:doctor/core/helpers/spacing.dart';
import 'package:doctor/core/routing/routes.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/core/theming/styles.dart';
import 'package:doctor/features/medical_records/logic/pdf_download_helper.dart';
import 'package:doctor/features/medical_records/data/medical_record_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalRecordCard extends StatelessWidget {
  final MedicalRecord record;

  const MedicalRecordCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.asset(
              record.imagePath,
              width: double.infinity,
              height: 180.h,
              fit: BoxFit.cover,
            ),
          ),
          verticalSpace(12),
          // Date
          Text(
            record.date,
            style: TextStyles.font12BlueRegular.copyWith(
              color: ColorsManager.mainBlue,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          verticalSpace(6),
          // Doctor Name
          Text(record.doctorName, style: TextStyles.font18DarkBlueBold),
          verticalSpace(4),
          // Description
          Text(record.description, style: TextStyles.font14GrayRegular),
          verticalSpace(16),
          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.pushNamed(
                      Routes.pdfViewer,
                      arguments: {
                        'title': record.description,
                        'assetPath': record.pdfAssetPath,
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    side: BorderSide(color: ColorsManager.darkBlue, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    'View Report',
                    style: TextStyles.font14DarkBlueMedium,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await PdfDownloadHelper.downloadAssetPdf(
                      context: context,
                      assetPath: record.pdfAssetPath,
                    );
                  },
                  icon: Icon(Icons.download, size: 18.r, color: Colors.white),
                  label: Text(
                    'Download',
                    style: TextStyles.font14DarkBlueMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.mainBlue,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
