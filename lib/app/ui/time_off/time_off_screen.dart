import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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
                    GestureDetector(
                      onTap: () {
                        Modular.to.pushNamed('/time_off/detail_time_off');
                      },
                      child: TextWidget.titleMedium(
                        'See Details',
                        color: AppColor.primaryBlueColor(),
                      ),
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
                  children: const [
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
  const Tab1Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget.bodyMedium(
            'You don’t have any upcoming office trip',
          ),
          ProfileContentMenu(
            menuTitle: 'Time off Type',
            subTitle: 'Date Start - Date End',
            menuIcon: 'ic_work_off',
            onTap: () {
              // _showFeatureDialog();
            },
          ),
          ProfileContentMenu(
            menuTitle: 'Time off Type',
            subTitle: 'Date Start - Date End',
            menuIcon: 'ic_work_off',
            onTap: () {
              // _showFeatureDialog();
            },
          ),
          ProfileContentMenu(
            menuTitle: 'Time off Type',
            subTitle: 'Date Start - Date End',
            menuIcon: 'ic_work_off',
            onTap: () {
              // _showFeatureDialog();
            },
          ),
        ],
      ),
    );
  }
}

class Tab2Screen extends StatelessWidget {
  const Tab2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: TextWidget.bodyMedium(
        '🐌🦄🦊🐸',
      ),
    );
  }
}

class ProfileContentMenu extends StatelessWidget {
  final String? menuTitle;
  final String? subTitle;
  final String? menuIcon;
  final Function()? onTap;
  const ProfileContentMenu({
    super.key,
    this.menuTitle,
    this.subTitle,
    this.menuIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomContainer(
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
          vertical: defaultMargin,
        ),
        radius: 8,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 32,
                    width: 32,
                    margin: const EdgeInsets.only(
                      right: 12,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryBlueColor(),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/$menuIcon.svg',
                      colorFilter: ColorFilter.mode(
                        AppColor.whiteColor(),
                        BlendMode.srcIn,
                      ),
                    )),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget.titleSmall(
                                menuTitle.toString(),
                                color: AppColor.primaryBlueColor(),
                              ),
                              TextWidget.titleSmall(
                                subTitle.toString(),
                                color: AppColor.primaryBlueColor(),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // CustomContainer(
                    //   radius: 4,
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 8.5,
                    //     vertical: 4,
                    //   ),
                    //   margin: const EdgeInsets.only(
                    //     right: 4,
                    //   ),
                    //   backgroundColor: AppColor.secondaryColor(),
                    //   child: const TextWidget.labelMedium('3'),
                    // ),
                    // TextWidget.bodySmall(
                    //   'Pending',
                    //   color: AppColor.bodyColor(),
                    // ),
                    SvgPicture.asset(
                      'assets/icons/ic_arrow_next.svg',
                      colorFilter: ColorFilter.mode(
                        AppColor.separatorColor(),
                        BlendMode.srcIn,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
