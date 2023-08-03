// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unnecessary_null_comparison, no_leading_underscores_for_local_identifiers, avoid_function_literals_in_foreach_calls, prefer_is_empty

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/database/databse_helper.dart';
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
  List<Category>? categoryMenu = [];
  late List<Attendance>? attendance = [];
  AttendOnday? attendOnday;
  DatabaseHelper? _dbHelper;
  bool? isOnline = false;
  String? attTimeIn = "";
  String? attTimeOut = "";
  // List? dataFaceDB;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    //  print("Masuk sini Home ");
    fetchData();
  }

  void _showFeatureDialog() {
    showDialog(
      builder: (_) => const CustomDialog(
          title: 'Feature Access',
          message: 'Hi, fitur ini sedang dalam masa pengembangan.'),
      context: context,
    );
  }

  void _showOfflineFeatureDialog() {
    showDialog(
      builder: (_) => const CustomDialog(
          title: 'Offline Feature',
          message: 'Hi, fitur ini tidak tersedia dalam mode Offline.'),
      context: context,
    );
  }

  fetchData() async {
    _dbHelper!.gelUserData().then((result) async {
      setState(() {
        nameProfile = result.fullName;
        depProfile = result.deptName;
        placementName = result.placementName;
        fotoUrl = result.fotoUrl;
      });
    });

    futureHome = HomeController().getHomeClass();
    futureHome.then((value) {
      if (value != null) {
        if (value.status == "success") {
          isOnline = true;
          attendOnday = value.attendOnday;
          categoryMenu = value.category;
          attendance = value.attendance;

          _dbHelper!.deleteTableCategory();
          _dbHelper!.insertCategory(categoryMenu!, attendOnday!);
          LocalStorageService.save("statusAbsen", attendOnday!.statusAbsen);
          syncDatabaseToserver();
        } else {
          fetchDataBase();
        }
      } else {
        fetchDataBase();
      }
    });

    return futureHome;
  }

  fetchDataBase() {
    _dbHelper!.getAttendOnday().then((result) async {
      setState(() {
        attTimeIn = result.timeIn;
        attTimeOut = result.timeOut;
        attendOnday = result;
        String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

        Duration diff = DateFormat('yyyy-MM-dd')
            .parse(result.dayDate!)
            .difference(DateTime.now());

        String todayDocID = DateFormat.Hm().format(DateTime.now());

        final parse1 = DateFormat('HH:mm').parse(todayDocID);
        final parse2 = DateFormat('HH:mm').parse("12:00");

        if (diff.inDays < 0) {
          attTimeIn = "";
          attTimeOut = "";
          // print("Masukkkkk enen");
          AttendOnday userToSave = AttendOnday(
            dayDate: currentDate,
            statusAbsen: 1,
            timeIn: "",
            timeOut: "",
            late: "",
            early: "",
            absent: "",
            totalAttendance: "",
          );
          _dbHelper!.updateAttendOndayOnli(userToSave);
          //  print("Harusssss Resert Data");
          if (parse1.isAfter(parse2)) {
            // print("DT1 is after DT2");
            LocalStorageService.save("statusAbsen", 2);
          } else {
            //print("DT1 is after asasas");
            LocalStorageService.save("statusAbsen", 1);
          }
        } else {
          if (parse1.isAfter(parse2) && result.timeOut == "") {
            // print("DT1 is after DT2aa");
            LocalStorageService.save("statusAbsen", 2);
          } else if (result.timeIn == "") {
            // print("DT1 is after asasasgg");
            LocalStorageService.save("statusAbsen", 1);
          }
        }
      });
    });

    _dbHelper!.getCategory().then((result) async {
      setState(() {
        categoryMenu = result;
      });
    });
  }

  syncDatabaseToserver() async {
    var allRows = await _dbHelper!.getAbsensi();

    if (allRows!.length > 0) {
      allRows.forEach((dataOff) async {
        if (dataOff.status == 1) {
          presensiToServerIn(
              dataOff.id,
              dataOff.dayDate,
              dataOff.waktu,
              dataOff.inLat,
              dataOff.inLong,
              dataOff.keterangan,
              dataOff.fotoUrl);
        } else {
          presensiToServerOut(
              dataOff.id,
              dataOff.dayDate,
              dataOff.waktu,
              dataOff.inLat,
              dataOff.inLong,
              dataOff.keterangan,
              dataOff.fotoUrl);
        }
      });
    }
  }

  Future<void> presensiToServerIn(
    int? id,
    String? todayDateNow,
    String? responseTime,
    String? positionLat,
    String? positionLong,
    String? catatan,
    String? imageFileImages,
  ) async {
    File? fileImages = File(imageFileImages!);
    HomeController()
        .postPresensiInOffline(todayDateNow, responseTime, positionLat,
            positionLong, catatan, fileImages)
        .then((result) {
      if (result != null) {
        if (result.data["status"] == "success") {
          _dbHelper!.deleteAbsensiOffline(id!);
          print("Berhasil");
        } else {
          print("Gagal 1");
        }
      } else {
        print("Gagal 2");
      }
    });
  }

  Future<void> presensiToServerOut(
    int? id,
    String? todayDateNow,
    String? responseTime,
    String? positionLat,
    String? positionLong,
    String? catatan,
    String? imageFileImages,
  ) async {
    File? fileImages = File(imageFileImages!);
    HomeController()
        .postPresensiOutOffline(todayDateNow, responseTime, positionLat,
            positionLong, catatan, fileImages)
        .then((result) {
      if (result != null) {
        if (result.data["status"] == "success") {
          _dbHelper!.deleteAbsensiOffline(id!);
          print("Berhasil");
        } else {
          print("Gagal 1");
        }
      } else {
        print("Gagal 2");
      }
    });
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
                //  print("Masuk sini kah 2 " + isOnline.toString());

                return RefreshIndicator(
                    color: AppColor.secondaryColor(),
                    key: _refreshIndicatorKey,
                    onRefresh: refreshlist,
                    child: SingleChildScrollView(
                        child: Container(
                            child: isOnline!
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
                                              color:
                                                  AppColor.primaryBlueColor(),
                                              child: Padding(
                                                padding: EdgeInsets.all(
                                                    defaultMargin),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        TextWidget.title(
                                                          nameProfile!,
                                                          color: AppColor
                                                              .whiteColor(),
                                                          fontWeight:
                                                              boldWeight,
                                                        ),
                                                        TextWidget.subtitle(
                                                          depProfile!,
                                                          color: AppColor
                                                              .whiteColor(),
                                                        ),
                                                        TextWidget.subtitle(
                                                          placementName!,
                                                          color: AppColor
                                                              .whiteColor(),
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
                                                              : SvgPicture
                                                                  .asset(
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
                                                padding: EdgeInsets.all(
                                                    defaultMargin),
                                                radius: 4,
                                                // height: clockCardHeight,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.1,
                                                containerType:
                                                    RoundedContainerType
                                                        .noOutline,
                                                backgroundColor:
                                                    AppColor.whiteColor(),
                                                shadow: [
                                                  BoxShadow(
                                                      offset:
                                                          const Offset(4, 4),
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
                                                              .format(
                                                                  currentDate),
                                                          color: AppColor
                                                              .blackColor(),
                                                        ),
                                                        TextWidget.title(
                                                          DateFormat.Hm()
                                                              .format(
                                                                  currentTime),
                                                          color: AppColor
                                                              .blackColor(),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        top: 8,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          CustomContainer(
                                                            radius: 4,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 13,
                                                            ),
                                                            width: MediaQuery.of(
                                                                        context)
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
                                                                    .withOpacity(
                                                                        0.1)
                                                                : AppColor
                                                                        .secondaryColor()
                                                                    .withOpacity(
                                                                        0.1),
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
                                                                    SvgPicture
                                                                        .asset(
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
                                                                    TextWidget
                                                                        .title(
                                                                      attendOnday!.timeIn! ==
                                                                              ""
                                                                          ? "-"
                                                                          : attendOnday!
                                                                              .timeIn!,
                                                                      fontSize:
                                                                          22,
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
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              vertical: 13,
                                                            ),
                                                            width: MediaQuery.of(
                                                                        context)
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
                                                                : AppColor
                                                                    .redColor(),
                                                            backgroundColor: attendOnday!
                                                                        .timeOut ==
                                                                    ""
                                                                ? AppColor
                                                                        .separatorColor()
                                                                    .withOpacity(
                                                                        0.1)
                                                                : AppColor
                                                                        .redColor()
                                                                    .withOpacity(
                                                                        0.1),
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
                                                                    SvgPicture
                                                                        .asset(
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
                                                                    TextWidget
                                                                        .title(
                                                                      attendOnday!.timeOut! ==
                                                                              ""
                                                                          ? "-"
                                                                          : attendOnday!
                                                                              .timeOut!,
                                                                      fontSize:
                                                                          22,
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
                                            margin: EdgeInsets.only(
                                                bottom: defaultMargin),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            backgroundColor:
                                                AppColor.whiteColor(),
                                            child: Column(
                                              children: [
                                                Container(
                                                    color: Colors.white,
                                                    child: GridView.count(
                                                      primary: true,
                                                      crossAxisCount: 3,
                                                      shrinkWrap: true,
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      childAspectRatio:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              (MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  1.8),
                                                      // mainAxisSpacing: 5.0,
                                                      crossAxisSpacing: 5.0,
                                                      children: categoryMenu!
                                                          .map((dt) {
                                                        return Container(
                                                          color: Colors.white,
                                                          child: InkWell(
                                                            splashColor: Theme
                                                                    .of(context)
                                                                .splashColor,
                                                            highlightColor: Theme
                                                                    .of(context)
                                                                .highlightColor,
                                                            onTap: () {
                                                              if (dt.id == 1) {
                                                                // print('button 1');
                                                                Modular.to.push(
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            HistoryScreen(
                                                                      isBack:
                                                                          false,
                                                                    ),
                                                                  ),
                                                                );
                                                              } else if (dt
                                                                      .id ==
                                                                  2) {
                                                                _showFeatureDialog();
                                                              } else {
                                                                _showFeatureDialog();
                                                              }
                                                            },
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <Widget>[
                                                                Center(
                                                                  child: dt.icon !=
                                                                          ""
                                                                      ? SvgPicture
                                                                          .network(
                                                                          dt.icon,
                                                                          placeholderBuilder: (context) =>
                                                                              CircularProgressIndicator(
                                                                            color:
                                                                                AppColor.secondaryColor(),
                                                                          ),
                                                                        )
                                                                      : Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5),
                                                                          child:
                                                                              SvgPicture.asset(
                                                                            'assets/images/default-image-square.svg',
                                                                            fit:
                                                                                BoxFit.fitWidth,
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
                                                                            child:
                                                                                TextWidget.labelMedium(
                                                                          dt.name,
                                                                          color:
                                                                              AppColor.primaryBlueColor(),
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
                                                  color:
                                                      AppColor.separatorColor(),
                                                ),
                                                Row(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
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
                                        //height: MediaQuery.of(context).size.height,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: defaultMargin),
                                        // margin: EdgeInsets.only(bottom: 30),
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: attendance!.length,
                                            itemBuilder: ((context, index) {
                                              var attendanceList =
                                                  attendance![index];
                                              return Column(
                                                children: [
                                                  HistoryItem(
                                                    historyItem: HistoryModel(
                                                        dateTime: attendanceList
                                                            .dayDateName,
                                                        status: attendanceList
                                                            .statusAttendance,
                                                        inClock: attendanceList
                                                            .timeIn,
                                                        outClock: attendanceList
                                                            .timeOut,
                                                        duration: attendanceList
                                                            .totalAttendance,
                                                        idHistory:
                                                            attendanceList
                                                                .attendanceId,
                                                        inLat: attendanceList
                                                            .inLat,
                                                        inLong: attendanceList
                                                            .inLong),
                                                  ),
                                                ],
                                              );
                                            })),
                                      ),
                                    ],
                                  )
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: defaultMargin,
                                      vertical: defaultMargin,
                                    ),
                                    child: _buildWidgetOffline(top)))));
            }
          },
        ),
      ),
    );
  }

  Widget _buildWidgetOffline(double top) {
    return Column(
      children: <Widget>[
        CustomContainer(
          radius: 4,
          width: double.infinity,
          containerType: RoundedContainerType.outlined,
          borderColor: AppColor.redColor(),
          backgroundColor: AppColor.redColor().withOpacity(0.1),
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          child: TextWidget.labelMedium(
            'Offline Mode',
            color: AppColor.redColor(),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            // bottom: coverHeight / 2,
            bottom: defaultMargin,
            top: defaultMargin,
          ),
          child: SizedBox(
            // height: coverHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget.title(
                      nameProfile!,
                      color: AppColor.primaryBlueColor(),
                      fontWeight: boldWeight,
                    ),
                    TextWidget.subtitle(
                      depProfile!,
                      color: AppColor.primaryBlueColor(),
                    ),
                    TextWidget.subtitle(
                      placementName!,
                      color: AppColor.primaryBlueColor(),
                    ),
                  ],
                ),
                // Image.asset('assets/dummy_profile.png')
                SizedBox(
                  height: 64,
                  width: 64,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      fotoUrl != ""
                          ? CircleAvatar(
                              backgroundColor: const Color(0xffF9F9F9),
                              backgroundImage: NetworkImage(fotoUrl!))
                          : SvgPicture.asset(
                              'assets/icons/ic_avatar.svg',
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: defaultMargin,
            vertical: defaultMargin,
          ),
          // height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF292F36).withOpacity(1.0),
                const Color(0xFF292F36).withOpacity(0.6),
              ],
              stops: const [0.0, 0.6],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextWidget.title(
                    DateFormat.yMMMMd().format(currentDate),
                    color: AppColor.whiteColor(),
                  ),
                  // TextWidget.title(

                  TextWidget.title(
                    DateFormat.Hm().format(currentTime),
                    color: AppColor.whiteColor(),
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      width: MediaQuery.of(context).size.width / 3,
                      containerType: RoundedContainerType.noOutline,
                      // borderColor: attendOnday!.timeIn == ""
                      //     ? AppColor.separatorColor()
                      //     : AppColor.secondaryColor(),
                      // backgroundColor: attendOnday!.timeIn == ""
                      //     ? AppColor.separatorColor().withOpacity(0.1)
                      //     : AppColor.secondaryColor().withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/ic_clock_plus.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColor.secondaryColor(),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              const TextWidget.subtitle(
                                'Clock-In',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextWidget.title(
                                attTimeIn! == "" ? "-" : attTimeIn!,
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      width: MediaQuery.of(context).size.width / 3,
                      containerType: RoundedContainerType.noOutline,
                      // borderColor: attendOnday!.timeOut == ""
                      //     ? AppColor.separatorColor()
                      //     : AppColor.redColor(),
                      // backgroundColor: attendOnday!.timeOut == ""
                      //     ? AppColor.separatorColor().withOpacity(0.1)
                      //     : AppColor.redColor().withOpacity(0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/ic_clock_remove.svg',
                                colorFilter: ColorFilter.mode(
                                  AppColor.redColor(),
                                  BlendMode.srcIn,
                                ),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              const TextWidget.subtitle(
                                'Clock-Out',
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextWidget.title(
                                attTimeOut! == "" ? "-" : attTimeOut!,
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
        SizedBox(
          height: defaultMargin,
        ),
        Column(
          children: [
            CustomContainer(
              padding: const EdgeInsets.fromLTRB(
                0,
                30,
                0,
                10,
              ),
              //  margin: EdgeInsets.only(bottom: defaultMargin),
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
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.8),
                        // mainAxisSpacing: 5.0,
                        crossAxisSpacing: 5.0,
                        children: categoryMenu!.map((dt) {
                          return Container(
                            color: Colors.white,
                            child: InkWell(
                              splashColor: Theme.of(context).splashColor,
                              highlightColor: Theme.of(context).highlightColor,
                              onTap: () {
                                if (dt.id == 1) {
                                  // print('button 1');
                                  // Modular.to.push(
                                  //   MaterialPageRoute(
                                  //     builder: (context) => HistoryScreen(
                                  //       isBack: false,
                                  //     ),
                                  //   ),
                                  // );
                                  _showOfflineFeatureDialog();
                                } else if (dt.id == 2) {
                                  _showFeatureDialog();
                                } else {
                                  _showFeatureDialog();
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: dt.icon != ""
                                        ? SvgPicture.network(
                                            dt.icon,
                                            placeholderBuilder: (context) =>
                                                Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30.0),
                                                    child:
                                                        const CircularProgressIndicator(
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                    )),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(5),
                                            child: SvgPicture.asset(
                                              'assets/images/default-image-square.svg',
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Flexible(
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Flexible(
                                              child: TextWidget.labelMedium(
                                            dt.name,
                                            color: AppColor.primaryBlueColor(),
                                            fontWeight: boldWeight,
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
                        margin: const EdgeInsets.only(right: 8),
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
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => HistoryScreen(
                          //       isBack: false,
                          //     ),
                          //   ),
                          // );
                          _showOfflineFeatureDialog();
                        },
                        child: TextWidget.title(
                          'View All',
                          color: AppColor.primaryBlueColor(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        CustomContainer(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.2,
            backgroundColor: AppColor.backgroundColor(),
            child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextWidget.bodyMedium(
                      'History is not available in offline mode'),
                ]))
      ],
    );
  }

//   getImageType(String? imageUrl) {
//     try {
//       return SvgPicture.network(
//         "https://upload.wikimedia.org/wikipedia/commons/2/24/malformed_url.svg",
//         width: 90,
//         fit: BoxFit.cover,
//         placeholderBuilder: (BuildContext context) => Container(
//             padding: const EdgeInsets.all(30.0),
//             child: const CircularProgressIndicator()),
//       );
//     } catch (_) {
//       return SvgPicture.asset(
//         'assets/icons/ic_history.svg',
//         width: 24,
//       );
//     }
//   }
}
