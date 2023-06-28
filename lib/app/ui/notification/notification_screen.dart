import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/reusable_components/custom_container.dart';
import 'package:sangati/app/widgets/reusable_components/custom_scaffold.dart';
import 'package:sangati/app/widgets/reusable_components/custom_text.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hideAppBar: true,
      hideBackButton: true,
      centralize: true,
      child: Padding(
        padding: EdgeInsets.all(defaultMargin),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextWidget.titleMedium(
            //   'Today',
            // ),
            // CustomContainer(
            //   margin: EdgeInsets.only(
            //     top: 12,
            //     bottom: 12,
            //   ),
            //   radius: 8,
            //   padding: EdgeInsets.symmetric(
            //     vertical: 16,
            //   ),
            //   width: double.infinity,
            //   child: TextWidget.bodyMedium(
            //     'You don’t have any notification',
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            // CustomContainer(
            //   margin: EdgeInsets.only(
            //     top: 12,
            //     bottom: 12,
            //   ),
            //   radius: 8,
            //   width: double.infinity,
            //   child: Container(
            //     padding: EdgeInsets.all(12),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             TextWidget.labelMedium(
            //               'Category',
            //               color: AppColor.primaryBlueColor(),
            //             ),
            //             TextWidget.bodySmall('32min'),
            //           ],
            //         ),
            //         TextWidget.titleSmall('Title'),
            //         TextWidget.bodySmall(
            //             'Cillum duis consequat commodo officia consequat fugiat non. Minim irure ullamco aliqua enim mollit pariatur consectetur officia occaecat fugiat.')
            //       ],
            //     ),
            //   ),
            // ),
            FeatureAccess()
          ],
        ),
      ),
    );
  }
}

class FeatureAccess extends StatelessWidget {
  const FeatureAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(defaultMargin),
      child: CustomContainer(
        radius: 8,
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Lottie.asset("assets/lottie/under_maintenance.json",
                  width: MediaQuery.of(context).size.width * 4.0,
                  fit: BoxFit.cover),
              // SvgPicture.asset(
              //     'assets/illustrations/feature_development.svg',
              //     height: MediaQuery.of(context).size.height * 0.2,
              //     fit: BoxFit.cover),
            ),
            SizedBox(
              height: defaultMargin,
            ),
            TextWidget.titleLarge(
              'Feature Access',
              color: AppColor.headingColor(),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: defaultMargin,
            ),
            TextWidget.titleMedium(
              'Hi, fitur ini sedang dalam masa pengembangan.',
              color: AppColor.headingColor(),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
