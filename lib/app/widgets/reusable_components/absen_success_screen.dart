import 'package:flutter/material.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/reusable_components/custom_scaffold.dart';
import 'package:sangati/app/widgets/reusable_components/custom_text.dart';

class AbsenSuccessScreen extends StatelessWidget {
  const AbsenSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hideBackButton: true,
      hideAppBar: true,
      centralize: true,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Image.asset(
              'assets/illustrations/clock_in.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: defaultMargin,
          ),
          TextWidget.titleLarge(
            'Clock-In Success',
            color: AppColor.headingColor(),
          ),
          SizedBox(
            height: defaultMargin,
          ),
          TextWidget.bodyMedium(
            'You have successfully clocked-in on',
            color: AppColor.bodyColor(),
          ),
          SizedBox(
            height: defaultMargin,
          ),
          TextWidget.titleMedium(
            '07:30 WIB',
            color: AppColor.headingColor(),
          ),
        ],
      ),
    );
  }
}
