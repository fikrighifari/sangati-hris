import 'package:flutter/material.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      centralize: true,
      hideBackButton: true,
      hideAppBar: true,
      backgroundColor: AppColor.whiteColor(),
      child: CustomContainer(
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          children: [
            // Container(
            //   width: 120,
            //   child: Lottie.asset('assets/lottie/not-found.json'),
            // ),
            Image.asset(
              'assets/illustrations/request_created.png',
              width: 168,
            ),
            SizedBox(
              height: defaultMargin,
            ),
            const TextWidget.titleLarge('Request Submitted'),
            SizedBox(
              height: defaultMargin,
            ),

            //* Subject
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomContainer(
                      width: MediaQuery.of(context).size.width / 7,
                      child: TextWidget.labelLarge(
                        'Subject',
                        color: AppColor.primaryBlueColor(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: defaultMargin,
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextWidget.labelLarge(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                        textAlign: TextAlign.left,
                        color: AppColor.bodyColor(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: defaultMargin,
            ),

            //* Note
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomContainer(
                      width: MediaQuery.of(context).size.width / 7,
                      child: TextWidget.labelLarge(
                        'Note',
                        color: AppColor.primaryBlueColor(),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: defaultMargin,
                ),
                Expanded(
                  child: Column(
                    children: [
                      TextWidget.labelLarge(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                        textAlign: TextAlign.left,
                        color: AppColor.bodyColor(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Container(
              margin: EdgeInsets.only(top: defaultMargin),
              child: CustomButton(
                isRounded: true,
                borderRadius: 4,
                backgroundColor: AppColor.secondaryColor(),
                width: double.infinity,
                text: TextWidget.labelLarge(
                  'Back',
                  color: AppColor.primaryBlueColor(),
                  fontWeight: boldWeight,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
