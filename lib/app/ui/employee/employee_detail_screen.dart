import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/ui/absen/request_change_screen.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class EmployeeDetailScreen extends StatefulWidget {
  const EmployeeDetailScreen({super.key});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.primaryBlueColor(),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: 'Contact Detail',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultMargin, vertical: defaultMargin),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Your content here
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              top: 24,
                              bottom: 8,
                            ),
                            child: SvgPicture.asset(
                              'assets/icons/ic_avatar.svg',
                              width: 96,
                            ),
                          ),
                          const TextWidget.titleLarge('Jhon'),
                          const TextWidget.titleMedium('IT Department'),
                          const Row(
                            children: [],
                          ),
                          CustomContainer(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultMargin,
                              vertical: defaultMargin,
                            ),
                            radius: 8,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget.titleMedium(
                                          'Office',
                                          color: AppColor.primaryBlueColor(),
                                        ),
                                        SizedBox(
                                          height: defaultMargin,
                                        ),
                                        TextWidget.titleMedium(
                                          'Email',
                                          color: AppColor.primaryBlueColor(),
                                        ),
                                        SizedBox(
                                          height: defaultMargin,
                                        ),
                                        TextWidget.titleMedium(
                                          'Phone',
                                          color: AppColor.primaryBlueColor(),
                                        ),
                                        SizedBox(
                                          height: defaultMargin,
                                        ),
                                        TextWidget.titleMedium(
                                          'Gender',
                                          color: AppColor.primaryBlueColor(),
                                        ),
                                        SizedBox(
                                          height: defaultMargin,
                                        ),
                                        TextWidget.titleMedium(
                                          'Birth Date',
                                          color: AppColor.primaryBlueColor(),
                                        ),
                                        SizedBox(
                                          height: defaultMargin,
                                        ),
                                        TextWidget.titleMedium(
                                          'Join Date',
                                          color: AppColor.primaryBlueColor(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 0.0),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextWidget.bodyLarge(
                                                    'Head Office Jakarta',
                                                    color: AppColor.bodyColor(),
                                                  ),
                                                  SizedBox(
                                                    height: defaultMargin,
                                                  ),
                                                  TextWidget.bodyLarge(
                                                    'imam@sangati.com',
                                                    color: AppColor.bodyColor(),
                                                  ),
                                                  SizedBox(
                                                    height: defaultMargin,
                                                  ),
                                                  TextWidget.bodyLarge(
                                                    '081234567890',
                                                    color: AppColor.bodyColor(),
                                                  ),
                                                  SizedBox(
                                                    height: defaultMargin,
                                                  ),
                                                  TextWidget.bodyLarge(
                                                    'Male',
                                                    color: AppColor.bodyColor(),
                                                  ),
                                                  SizedBox(
                                                    height: defaultMargin,
                                                  ),
                                                  TextWidget.bodyLarge(
                                                    '24 Juni 1965',
                                                    color: AppColor.bodyColor(),
                                                  ),
                                                  SizedBox(
                                                    height: defaultMargin,
                                                  ),
                                                  TextWidget.bodyLarge(
                                                    '7 September 2022',
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
                        ],
                      )

                      // Add more content widgets as needed
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: AppColor.whiteColor(),
              padding: EdgeInsets.symmetric(
                horizontal: defaultMargin,
                vertical: defaultMargin,
              ),
              child: CustomButton(
                isRounded: true,
                borderRadius: 4,
                backgroundColor: AppColor.greenColor(),
                width: double.infinity,
                text: TextWidget.labelLarge(
                  'Chat via WhatApp',
                  color: AppColor.whiteColor(),
                  fontWeight: boldWeight,
                ),
                leading: SvgPicture.asset(
                  'assets/icons/ic_whatsapp.svg',
                  colorFilter: ColorFilter.mode(
                    AppColor.whiteColor(),
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RequestChangeScreen(),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
