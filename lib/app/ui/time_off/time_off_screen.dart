import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class TimeOffScreen extends StatefulWidget {
  const TimeOffScreen({super.key});

  @override
  State<TimeOffScreen> createState() => _TimeOffScreenState();
}

class _TimeOffScreenState extends State<TimeOffScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Time Off',
        backButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.primaryBlueColor(),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: AppColor.backgroundColor(),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: defaultMargin,
            vertical: defaultMargin,
          ),
          child: Column(
            children: [
              CustomContainer(
                radius: 6,
                height: MediaQuery.of(context).size.height * 0.2,
                padding: EdgeInsets.symmetric(
                  horizontal: defaultMargin,
                  vertical: defaultMargin,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            children: [
                              TextWidget.labelLarge('Cuti Normatif'),
                              TextWidget.titleLarge('8')
                            ],
                          ),
                          VerticalDivider(
                            color: AppColor
                                .separatorColor(), // Customize the color of the divider
                            thickness: 1, // Adjust the thickness of the divider
                            // height: 40, // Set the height of the vertical divider
                          ),
                          const Column(
                            children: [
                              TextWidget.labelLarge('Cuti Bonus'),
                              TextWidget.titleLarge('8')
                            ],
                          ),
                          VerticalDivider(
                            color: AppColor
                                .separatorColor(), // Customize the color of the divider
                            thickness: 1, // Adjust the thickness of the divider
                            // height: 40, // Set the height of the vertical divider
                          ),
                          const Column(
                            children: [
                              TextWidget.labelLarge('Dispensation'),
                              TextWidget.titleLarge('Available')
                            ],
                          ),
                        ],
                      ),
                    ),
                    TextWidget.titleMedium(
                      'See Details',
                      color: AppColor.primaryBlueColor(),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    CustomButton(
                      isRounded: true,
                      borderRadius: 4,
                      backgroundColor: AppColor.secondaryColor(),
                      width: double.infinity,
                      text: TextWidget.labelLarge(
                        'Create Request',
                        color: AppColor.primaryBlueColor(),
                        fontWeight: boldWeight,
                      ),
                      leading: SvgPicture.asset(
                        'assets/icons/ic_text_snippet.svg',
                        colorFilter: ColorFilter.mode(
                          AppColor.primaryBlueColor(),
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Container(
                color: AppColor.whiteColor(),
                child: TabBar(
                  indicatorColor: AppColor.primaryBlueColor(),
                  controller: _tabController,
                  tabs: [
                    Tab(
                      child: TextWidget.bodyLarge(
                        'Request',
                        color: AppColor.primaryBlueColor(),
                      ),
                    ),
                    Tab(
                      child: TextWidget.bodyLarge(
                        'History',
                        color: AppColor.primaryBlueColor(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Tab1Screen(),
                    Tab2Screen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Tab1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: TextWidget.bodyMedium(
        'You don’t have any upcoming office trip',
      ),
    );
  }
}

class Tab2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: TextWidget.bodyMedium(
        '🐌🦄🦊🐸',
      ),
    );
  }
}
