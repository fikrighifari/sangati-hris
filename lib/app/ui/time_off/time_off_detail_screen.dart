import 'package:flutter/material.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class TimeOffDetailScreen extends StatefulWidget {
  const TimeOffDetailScreen({super.key});

  @override
  State<TimeOffDetailScreen> createState() => _TimeOffDetailScreenState();
}

class _TimeOffDetailScreenState extends State<TimeOffDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold.withAppBar(
      title: 'Time Off',
      centerTitle: true,
      isScrolling: true,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
          vertical: defaultMargin,
        ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget.titleMedium('Cuti'),
                  const Divider(),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget.titleSmall(
                        'Cuti Normatif',
                        color: AppColor.primaryBlueColor(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget.titleSmall(
                                      '1',
                                      color: AppColor.blackColor(),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget.titleSmall(
                        'Cuti Bonus',
                        color: AppColor.primaryBlueColor(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(bottom: 0.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextWidget.titleSmall(
                                      '8',
                                      color: AppColor.blackColor(),
                                    ),
                                    TextWidget.titleSmall(
                                      ' (Expired 21 Januari 2023)',
                                      color: AppColor.bodyColor(),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget.titleMedium('Dispensation Permision'),
                  const Divider(),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextWidget.titleSmall(
                        'Januari',
                        color: AppColor.primaryBlueColor(),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 0.0),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget.titleSmall(
                                  'Available',
                                  color: AppColor.primaryBlueColor(),
                                ),
                              ]),
                        ),
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
