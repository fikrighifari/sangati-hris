// ignore_for_file: unused_local_variable, unnecessary_null_comparison, deprecated_member_use, unused_element, library_private_types_in_public_api

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/models/shift_model.dart';
import 'package:sangati/app/service/local_storage_service.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/themes/color_themes.dart';
import 'package:sangati/app/ui/absen/absen_in_screen.dart';
import 'package:sangati/app/ui/absen/absen_out_screen.dart';
import 'package:sangati/app/ui/employee/employee_screen.dart';
import 'package:sangati/app/ui/home/home_screen.dart';
import 'package:sangati/app/ui/notification/notification_screen.dart';
import 'package:sangati/app/ui/profile/profile_screen.dart';
import 'package:sangati/app/widgets/reusable_components/custom_dialog.dart';
import 'package:sangati/app/widgets/reusable_components/ui_utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String title = "Home";
  // int selectedTab = 0;
  bool isScrolling = true;
  bool isHideAppBar = false;
  bool isNotLoggedIn = false;
  DateTime preBackpress = DateTime.now();
  int? currentIndex = 0;
  int? statusVerif;
  ShiftData? shiftData;
  DateTime pre_backpress = DateTime.now();
  late DateTime currentBackPressTime;
  @override
  initState() {
    LocalStorageService.load("statusVerif").then((value) {
      if (value != null) {
        //print(" masukkkkkk-------- " + value.toString());
        setState(() {
          statusVerif = value;
          if (value == 0 || value == 1) {
            currentIndex = 4;
          } else {
            currentIndex = 0;
          }
        });
      }
    });

    fetchData();
    super.initState();
  }

  fetchData() {
    //print("MAUKKKKSSSKSKS----------------------->>;");
    HomeController().getShift().then((result) async {
      if (result != null) {
        if (result.status == "success") {
          shiftData = result.shiftData;
        }
      }
    });
  }

  Future<bool> _onBackPressed() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Keluar dari Sangati HIRS?'),
          content: const Text('Apakah Anda ingin Keluar?'),
          actions: <Widget>[
            TextButton(
              child: const Text("Tidak"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Ya"),
              onPressed: () {
                Navigator.of(context).pop(true);
                exit(0);
              },
            ),
          ],
        );
      },
    );
    // }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    clockButton() {
      return FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColor.secondaryColor(),
        child: SvgPicture.asset(
          'assets/icons/ic_login.svg',
          color: AppColor.whiteColor(),
        ),
      );
    }

    customBottomNavBar() {
      return BottomNavigationBar(
          selectedItemColor: AppColor.primaryBlueColor(),
          unselectedItemColor: AppColor.disableColor(),
          currentIndex: currentIndex!,
          onTap: (value) {
            //   print("asasasas------ " + statusVerif.toString());

            if (statusVerif == 0 || statusVerif == 1) {
            } else {
              setState(() {
                if (value == 2) {
                  LocalStorageService.load("statusAbsen").then((statusAbsen) {
                    if (statusAbsen != null) {
                      if (statusAbsen == 1) {
                        availableCameras().then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AbsenInPage(
                                    cameras: value,
                                    statusAbsen: statusAbsen,
                                    shiftData: shiftData))));
                      } else if (statusAbsen == 2) {
                        availableCameras().then((value) => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AbsenOutPage(
                                    cameras: value,
                                    statusAbsen: statusAbsen,
                                    shiftData: shiftData))));
                      } else {
                        _showFeatureDialog();
                      }
                    } else {
                      _showFeatureDialog();
                    }
                  });
                } else {
                  currentIndex = value;
                }
              });
            }
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/ic_home.svg',
                color: AppColor.disableColor(),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/ic_home.svg',
                color: AppColor.primaryBlueColor(),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/ic_round_people.svg',
                color: AppColor.disableColor(),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/ic_round_people.svg',
                color: AppColor.primaryBlueColor(),
              ),
              label: 'Employee',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/ic_clock_in_attendance.svg',
                width: 50,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/ic_notification.svg',
                color: AppColor.disableColor(),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/ic_notification.svg',
                color: AppColor.primaryBlueColor(),
              ),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/icons/ic_account.svg',
                color: AppColor.disableColor(),
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/ic_account.svg',
                color: AppColor.primaryBlueColor(),
              ),
              label: 'Profile',
            ),
          ]);
    }

    bodyContent() {
      switch (currentIndex) {
        case 0:
          return const HomeScreen();
        case 1:
          return const EmployeeScreen();
        case 2:
          return null;
        case 3:
          // return MyApp();
          return const NotificationScreen();
        case 4:
          return const ProfileScreen();

        default:
      }
    }

    return WillPopScope(
        onWillPop: () async {
          final timegap = DateTime.now().difference(pre_backpress);
          final cantExit = timegap >= const Duration(seconds: 2);
          pre_backpress = DateTime.now();
          if (cantExit) {
            UiUtils.errorMessageClose(
                "Tekan sekali lagi untuk keluar", context);
            return false;
          } else {
            _onBackPressed();
            return true;
          }
        },
        child: Scaffold(
          bottomNavigationBar: customBottomNavBar(),
          body: bodyContent(),
        ));
  }

  void _showFeatureDialog() {
    showDialog(
      builder: (_) => const CustomDialog(
          title: 'Absensi',
          message: 'Anda Sudah Melakukan Absen masuk dan absen pulang'),
      context: context,
    );
  }
}
