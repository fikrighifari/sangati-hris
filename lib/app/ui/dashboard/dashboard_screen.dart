// ignore_for_file: unused_local_variable, unnecessary_null_comparison, deprecated_member_use, unused_element, library_private_types_in_public_api, non_constant_identifier_names, unused_field, unused_catch_clause

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/database/databse_helper.dart';
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
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  String title = "Home";
  // int selectedTab = 0;
  bool isScrolling = true;
  bool isHideAppBar = false;
  bool isNotLoggedIn = false;
  DateTime preBackpress = DateTime.now();
  int? currentIndex = 0;
  int? statusVerif;
  List<ShiftData>? shiftData;

  DateTime pre_backpress = DateTime.now();
  late DateTime currentBackPressTime;
  DatabaseHelper? _databaseHelper;
  @override
  initState() {
    initConnectivity();
    _databaseHelper = DatabaseHelper.instance;
    LocalStorageService.load("statusVerif").then((value) {
      if (value != null) {
        // print(" masukkkkkk-------- " + value.toString());
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

    final newVersion = NewVersionPlus(
      iOSId: 'com.hris.sangati',
      androidId: 'com.hris.sangati',
      androidPlayStoreCountry: 'id_ID',
      // iOSId: 'com.jlantah.app',
      // androidId: 'com.jlantah.app',
      // androidPlayStoreCountry: 'id_ID',
    );

    advancedStatusCheck(newVersion);

    fetchData();

    super.initState();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      //  developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  //Advanced Popup NewVersionPlus
  advancedStatusCheck(NewVersionPlus newVersion) async {
    final status = await newVersion.getVersionStatus();

    // print("status!.localVersion " + status!.localVersion.toString());
    // print("status!.status.storeVersion " + status.storeVersion.toString());
    if (status!.localVersion != status.storeVersion) {
      // debugPrint(status.releaseNotes);
      // debugPrint(status.appStoreLink);
      // debugPrint(status.localVersion);
      // debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      // ignore: use_build_context_synchronously
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Update Tersedia',
        dialogText:
            'Versi terbaru tersedia! Silakan update aplikasi SSS Attendance Anda agar dapat menikmati fitur terbaru.',
        launchModeVersion: LaunchModeVersion.external,
        // allowDismissal: false,
        // dismissButtonText: 'Nanti Saja',
      );
    }
  }

  fetchData() {
    HomeController().getShift().then((result) async {
      if (result != null) {
        if (result.status == "success") {
          shiftData = result.shiftData;
          await _databaseHelper!.deleteTableShift();
          await _databaseHelper!.insertShift(shiftData!);
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
    //  final postMdl = Provider.of<AuthServices>(context);
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
            LocalStorageService.load("statusVerif").then((valuedd) {
              if (valuedd != null) {
                //   print(" masukkkkkk-------- " + valuedd.toString());
                setState(() {
                  statusVerif = valuedd;
                  if (valuedd == 0 || valuedd == 1) {
                    currentIndex = 4;
                  }
                });
              }
            });

            //  print(" masukkkkkk-------- " + _connectionStatus.toString());

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
                'assets/icons/ic_attendance_button.svg',
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
