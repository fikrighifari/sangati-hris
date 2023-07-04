// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/models/history_model.dart';
import 'package:sangati/app/models/home_model.dart';
import 'package:sangati/app/models/profile_model.dart';
import 'package:sangati/app/service/local_storage_service.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/ui/history/history_screen.dart';
import 'package:sangati/app/widgets/cards/history_item.dart';
import 'package:sangati/app/widgets/constant/enums/rounded_container_type.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int selectedIndex = 0;
  final double coverHeight = 165;
  final double clockCardHeight = 140;
  DataProfile? dataProfile;

  late String? nameProfile = "";
  late String? depProfile = "";
  late String? placementName = "";
  late String? fotoUrl = "";

  late DateTime currentDate = DateTime.now();
  late DateTime currentTime = DateTime.now();

  late Future<HomeModel?> futureHome;
  late List<Category>? categoryMenu = [];
  late List<Attendance>? attendance = [];
  AttendOnday? attendOnday;

  @override
  void initState() {
    super.initState();
    fetchData();
    LocalStorageService.load("profileData").then((value) {
      // setState(() => phoneNumber = value ?? "");
      // dataProfile = value;
      var jsonDat = jsonDecode(value);
      setState(() {
        // print("response  Data ewewe $value");
        // dataProfile = jsonDecode(value);
        //  print("response  Data kkkkk $jsonDat['fullName']");
        //print("response  Data kkkkk " + jsonDat['fullName'].toString());
        nameProfile = jsonDat['fullName'];
        depProfile = jsonDat['deptName'];
        placementName = jsonDat['placementName'];
        fotoUrl = jsonDat['fotoUrl'];
      });

      // dataProfile = value;
    });

    //  print("response  Data ewewe " + dataProfile!.fullName.toString());
  }

  void _showFeatureDialog() {
    showDialog(
      builder: (_) => const CustomDialog(
          title: 'Feature Access',
          message: 'Hi, fitur ini sedang dalam masa pengembangan.'),
      context: context,
    );
  }

  fetchData() {
    // print("Masuk sini Home ");
    futureHome = HomeController().getHomeClass();
    futureHome.then((value) {
      if (value != null) {
        attendOnday = value.attendOnday;
        categoryMenu = value.category;
        attendance = value.attendance;
        LocalStorageService.save("statusAbsen", attendOnday!.statusAbsen);
        // print("DAttttttttt" +
        //     DateTime("HH:mm:ss").format(DateTime.parse('00:00:00')).toString());
        // DateTime _dateTime = DateFormat("HH:mm").parse("04:00");
        // print("DAttttttttt" + _dateTime.toString());

        //  isLoading = true;
        // } else {
        //   isLoading = false;
      }
    });

    return futureHome;
  }

  Future<void> refreshlist() async {
    setState(() {
      _refreshIndicatorKey.currentState!.show();
      //  print("Masuk sini Home ffff ");
      fetchData();
    });
    // _checkJaringan();
  }

  @override
  Widget build(BuildContext context) {
    // DateTime myDate = DateTime(2023, 1, 16);
    // String formattedDate = formatIndonesianDate(myDate);

    final top = coverHeight - clockCardHeight / 2;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<HomeModel?>(
          future: futureHome,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                //  print("Masuk sini no");
                return const Text('Press button to start.');
              case ConnectionState.active:
                // print("Masuk sini kah");
                return const Text('Press button to start.');
              case ConnectionState.waiting:
                // print("Masuk sini kah 2");
                return UiUtils.customShimmerHome(context);
              // return LoadingWidgetHome();

              case ConnectionState.done:
                // print("Masuk sini kah 2");

                // return Text('Press button to start.');
                //  print("Masuk sini kah 4" + artikelListData!.length.toString());
                // return LoadingWidgetHome();
                // if (!isLoading) {
                //   return noDataWidget(context);
                // } else {

                return RefreshIndicator(
                    color: AppColor.secondaryColor(),
                    key: _refreshIndicatorKey,
                    onRefresh: refreshlist,
                    child: SingleChildScrollView(
                      child: categoryMenu!.isNotEmpty
                          ? Column(
                              children: <Widget>[
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    //* Header Content
                                    Container(
                                      margin: EdgeInsets.only(
                                          bottom: coverHeight / 2),
                                      child: Container(
                                        height: coverHeight,
                                        color: AppColor.primaryBlueColor(),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(defaultMargin),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextWidget.title(
                                                    nameProfile!,
                                                    color:
                                                        AppColor.whiteColor(),
                                                    fontWeight: boldWeight,
                                                  ),
                                                  TextWidget.subtitle(
                                                    depProfile!,
                                                    color:
                                                        AppColor.whiteColor(),
                                                  ),
                                                  TextWidget.subtitle(
                                                    placementName!,
                                                    color:
                                                        AppColor.whiteColor(),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              // Image.asset('assets/dummy_profile.png')
                                              SizedBox(
                                                height: 64,
                                                width: 64,
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  //  overflow: Overflow.visible,
                                                  children: [
                                                    fotoUrl != ""
                                                        ? CircleAvatar(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xffF9F9F9),
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    fotoUrl!))
                                                        : SvgPicture.asset(
                                                            'assets/images/ic_default_avatar.svg',
                                                          ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),

                                    //* Clock In & Out Content
                                    Positioned(
                                      top: top,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: defaultMargin),
                                        child: CustomContainer(
                                          padding:
                                              EdgeInsets.all(defaultMargin),
                                          radius: 4,
                                          // height: clockCardHeight,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.1,
                                          containerType:
                                              RoundedContainerType.noOutline,
                                          backgroundColor:
                                              AppColor.whiteColor(),
                                          shadow: [
                                            BoxShadow(
                                                offset: const Offset(4, 4),
                                                blurRadius: 30,
                                                color: Colors.black
                                                    .withOpacity(0.06))
                                          ],
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  TextWidget.title(
                                                    DateFormat.yMMMMd()
                                                        .format(currentDate),
                                                    color:
                                                        AppColor.blackColor(),
                                                  ),
                                                  // TextWidget.title(
                                                  //   formattedDate,
                                                  //   color:
                                                  //       AppColor.blackColor(),
                                                  // ),
                                                  TextWidget.title(
                                                    DateFormat.Hm()
                                                        .format(currentTime),
                                                    color:
                                                        AppColor.blackColor(),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 8,
                                                ),
                                                child: Row(
                                                  children: [
                                                    CustomContainer(
                                                      radius: 4,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 13,
                                                      ),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      containerType:
                                                          RoundedContainerType
                                                              .outlined,
                                                      borderColor: attendOnday!
                                                                  .timeIn ==
                                                              ""
                                                          ? AppColor
                                                              .separatorColor()
                                                          : AppColor
                                                              .secondaryColor(),
                                                      backgroundColor: attendOnday!
                                                                  .timeIn ==
                                                              ""
                                                          ? AppColor
                                                                  .separatorColor()
                                                              .withOpacity(0.1)
                                                          : AppColor
                                                                  .secondaryColor()
                                                              .withOpacity(0.1),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/icons/ic_clock_plus.svg',
                                                                colorFilter:
                                                                    ColorFilter
                                                                        .mode(
                                                                  AppColor
                                                                      .secondaryColor(),
                                                                  BlendMode
                                                                      .srcIn,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              const TextWidget
                                                                  .subtitle(
                                                                'Clock-In',
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              TextWidget.title(
                                                                attendOnday!.timeIn ==
                                                                        ""
                                                                    ? "-"
                                                                    : attendOnday!
                                                                        .timeIn,
                                                                fontSize: 22,
                                                              ),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              // const TextWidget
                                                              //         .subtitle(
                                                              //     'WIB'),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                    CustomContainer(
                                                      radius: 4,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 13,
                                                      ),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                      containerType:
                                                          RoundedContainerType
                                                              .outlined,
                                                      borderColor: attendOnday!
                                                                  .timeOut ==
                                                              ""
                                                          ? AppColor
                                                              .separatorColor()
                                                          : AppColor.redColor(),
                                                      backgroundColor: attendOnday!
                                                                  .timeOut ==
                                                              ""
                                                          ? AppColor
                                                                  .separatorColor()
                                                              .withOpacity(0.1)
                                                          : AppColor.redColor()
                                                              .withOpacity(0.1),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/icons/ic_clock_remove.svg',
                                                                colorFilter:
                                                                    ColorFilter
                                                                        .mode(
                                                                  AppColor
                                                                      .redColor(),
                                                                  BlendMode
                                                                      .srcIn,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              const TextWidget
                                                                  .subtitle(
                                                                'Clock-Out',
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              TextWidget.title(
                                                                attendOnday!.timeOut ==
                                                                        ""
                                                                    ? "-"
                                                                    : attendOnday!
                                                                        .timeOut,
                                                                fontSize: 22,
                                                              ),
                                                              const SizedBox(
                                                                width: 4,
                                                              ),
                                                              // const TextWidget
                                                              //         .subtitle(
                                                              //     'WIB'),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    CustomContainer(
                                      padding: const EdgeInsets.fromLTRB(
                                        44.5,
                                        24,
                                        44.5,
                                        10,
                                      ),

                                      // const EdgeInsets.symmetric(
                                      //   horizontal: 44.5,
                                      //   vertical: 24,
                                      // ),
                                      margin: EdgeInsets.only(
                                          bottom: defaultMargin),
                                      width: MediaQuery.of(context).size.width,
                                      backgroundColor: AppColor.whiteColor(),
                                      child: Column(
                                        children: [
                                          Container(
                                              color: Colors.white,
                                              child: GridView.count(
                                                primary: true,
                                                crossAxisCount: 3,
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                childAspectRatio:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        (MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            1.8),
                                                // mainAxisSpacing: 5.0,
                                                crossAxisSpacing: 5.0,
                                                children:
                                                    categoryMenu!.map((dt) {
                                                  return Container(
                                                    color: Colors.white,
                                                    child: InkWell(
                                                      splashColor:
                                                          Theme.of(context)
                                                              .splashColor,
                                                      highlightColor:
                                                          Theme.of(context)
                                                              .highlightColor,
                                                      onTap: () {
                                                        if (dt.id == 1) {
                                                          // print('button 1');
                                                          Modular.to.push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  HistoryScreen(
                                                                isBack: false,
                                                              ),
                                                            ),
                                                          );
                                                        } else if (dt.id == 2) {
                                                          print('button 2');
                                                          _showFeatureDialog();
                                                        } else {
                                                          print('button 3');
                                                          _showFeatureDialog();
                                                        }
                                                        // _checkJaringan();
                                                        // if (dt.menu == 1) {
                                                        //   if (_isLogin) {
                                                        //   } else {
                                                        //     nextScreen(context,
                                                        //         AuthScreen());
                                                        //   }
                                                        // } else if (dt.serbaJasa ==
                                                        //     1) {
                                                        //   if (_isLogin) {
                                                        //     if (checkJaringan ==
                                                        //         true) {
                                                        //       nextScreen(
                                                        //           context,
                                                        //           Serbajasa(
                                                        //             // DepositOrderCategory(
                                                        //             itemData: dt,
                                                        //           ));
                                                        //     }
                                                        //   } else {
                                                        //     nextScreen(context,
                                                        //         AuthScreen());
                                                        //   }
                                                        // } else {
                                                        //   if (checkJaringan == true) {
                                                        //     HomeController()
                                                        //         .itemDetailPage(
                                                        //             context, dt);
                                                        //   }
                                                        // }
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Center(
                                                            child: dt.icon != ""
                                                                ? SvgPicture
                                                                    .network(
                                                                    dt.icon,
                                                                    placeholderBuilder:
                                                                        (context) =>
                                                                            CircularProgressIndicator(
                                                                      color: AppColor
                                                                          .secondaryColor(),
                                                                    ),
                                                                  )
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(5),
                                                                    child: SvgPicture
                                                                        .asset(
                                                                      'assets/images/default-image-square.svg',
                                                                      fit: BoxFit
                                                                          .fitWidth,
                                                                    ),
                                                                  ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Flexible(
                                                            child: Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <Widget>[
                                                                  Flexible(
                                                                      child: TextWidget
                                                                          .labelMedium(
                                                                    dt.name,
                                                                    color: AppColor
                                                                        .primaryBlueColor(),
                                                                    fontWeight:
                                                                        boldWeight,
                                                                  )),
                                                                ]),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              )),
                                          Divider(
                                            color: AppColor.separatorColor(),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 8),
                                                child: SvgPicture.asset(
                                                  'assets/icons/ic_history.svg',
                                                  width: 24,
                                                ),
                                              ),
                                              const TextWidget.title(
                                                'Latest History',
                                              ),
                                              const Spacer(),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HistoryScreen(
                                                        isBack: false,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: TextWidget.title(
                                                  'View All',
                                                  color: AppColor
                                                      .primaryBlueColor(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height,
                                  padding: EdgeInsets.fromLTRB(
                                      defaultMargin, 0, defaultMargin, 100),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: attendance!.length,
                                      itemBuilder: ((context, index) {
                                        var attendanceList = attendance![index];
                                        return Column(
                                          children: [
                                            HistoryItem(
                                              historyItem: HistoryModel(
                                                  dateTime: attendanceList
                                                      .dayDateName,
                                                  status: attendanceList
                                                      .statusAttendance,
                                                  inClock:
                                                      attendanceList.timeIn,
                                                  outClock:
                                                      attendanceList.timeOut,
                                                  duration: attendanceList
                                                      .totalAttendance,
                                                  idHistory: attendanceList
                                                      .attendanceId,
                                                  inLat: attendanceList.inLat,
                                                  inLong:
                                                      attendanceList.inLong),
                                            ),
                                          ],
                                        );
                                      })),
                                ),
                              ],
                            )
                          : Container(),
                    ));
            }
          },
        ),
      ),
    );
  }

  String formatIndonesianDate(DateTime date) {
    var formatter = DateFormat('d MMMM y', 'id_ID');
    return formatter.format(date);
  }
}
