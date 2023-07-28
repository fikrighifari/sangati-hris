import 'package:flutter/material.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class TimeOffRequestScreen extends StatefulWidget {
  const TimeOffRequestScreen({super.key});

  @override
  State<TimeOffRequestScreen> createState() => _TimeOffRequestScreenState();
}

class _TimeOffRequestScreenState extends State<TimeOffRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold.withAppBar(
      title: 'Time-off Request',
      centerTitle: true,
      isScrolling: true,
      child: Container(
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          children: [
            CustomContainer(
              margin: EdgeInsets.only(bottom: defaultMargin),
              padding: EdgeInsets.all(defaultMargin),
              width: double.infinity,
              shadow: [
                BoxShadow(
                    offset: const Offset(4, 4),
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.06))
              ],
              radius: 8,
              child: Column(
                children: [
                  TextWidget.bodyMedium(
                    'Time Off',
                    color: AppColor.bodyColor(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextWidget.bodyMedium(
                        '29 January 2023',
                        color: AppColor.bodyColor(),
                      ),
                      TextWidget.bodyMedium(
                        ' - ',
                        color: AppColor.bodyColor(),
                      ),
                      TextWidget.bodyMedium(
                        '30 January 2023',
                        color: AppColor.bodyColor(),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
