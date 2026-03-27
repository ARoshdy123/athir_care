import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/core/theming/styles.dart';
import 'package:doctor/features/medical_records/data/medical_record_model.dart';
import 'package:doctor/features/medical_records/ui/widgets/medical_record_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MedicalRecordsScreen extends StatelessWidget {
  const MedicalRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
          title: Text('Medical Records', style: TextStyles.font18DarkBlueBold),
          bottom: TabBar(
            labelColor: ColorsManager.darkBlue,
            unselectedLabelColor: ColorsManager.gray,
            labelStyle: TextStyles.font14DarkBlueMedium,
            unselectedLabelStyle: TextStyles.font14GrayRegular,
            indicatorColor: ColorsManager.mainBlue,
            indicatorWeight: 2.5,
            tabs: const [
              Tab(text: 'Lab Results'),
              Tab(text: 'Radiology'),
              Tab(text: 'Approvals'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _RecordsList(category: RecordCategory.labResults),
            _RecordsList(category: RecordCategory.radiology),
            _RecordsList(category: RecordCategory.approvals),
          ],
        ),
      ),
    );
  }
}

class _RecordsList extends StatelessWidget {
  final RecordCategory category;

  const _RecordsList({required this.category});

  @override
  Widget build(BuildContext context) {
    final records =
        mockMedicalRecords.where((r) => r.category == category).toList();

    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open_outlined,
              size: 60.r,
              color: ColorsManager.gray,
            ),
            SizedBox(height: 16.h),
            Text('No records found', style: TextStyles.font14GrayRegular),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: records.length,
      itemBuilder: (context, index) {
        return MedicalRecordCard(record: records[index]);
      },
    );
  }
}
