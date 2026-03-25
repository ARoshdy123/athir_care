import 'package:doctor/core/helpers/constants.dart';
import 'package:doctor/core/helpers/shared_pref_helper.dart';
import 'package:doctor/core/theming/colors.dart';
import 'package:doctor/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeTopBar extends StatefulWidget {
  const HomeTopBar({super.key});

  @override
  State<HomeTopBar> createState() => _HomeTopBarState();
}

class _HomeTopBarState extends State<HomeTopBar> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await SharedPrefHelper.getString(SharedPrefKeys.userName);
    if (mounted) {
      setState(() => _userName = name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome Back, ${_userName.isEmpty ? '' : '$_userName!'}',
              style: TextStyles.font18DarkBlueBold,
            ),
            Text('How are you today?', style: TextStyles.font12GrayRegular),
          ],
        ),
        const Spacer(),
        CircleAvatar(
          radius: 24,
          backgroundColor: ColorsManager.superLightGray2,
          child: SvgPicture.asset('assets/svgs/notifications.svg'),
        ),
      ],
    );
  }
}
