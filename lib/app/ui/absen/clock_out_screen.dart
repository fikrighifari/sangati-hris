// ignore_for_file: unused_field, unused_local_variable, use_build_context_synchronously, sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/database/databse_helper.dart';
import 'package:sangati/app/models/absensi_offline_model.dart';
import 'package:sangati/app/models/home_model.dart';
import 'package:sangati/app/models/shift_model.dart';
import 'package:sangati/app/service/local_storage_service.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/constant/enums/rounded_container_type.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class ClockOutScreen extends StatefulWidget {
  const ClockOutScreen({
    Key? key,
    required this.picture,
    required this.position,
    this.shiftData,
    required this.alamatKar,
  }) : super(key: key);
  final File? picture;

  final Position position;
  final List<ShiftData>? shiftData;
  final alamatKar;
  @override
  State<ClockOutScreen> createState() => _ClockOutScreenState();
}

class _ClockOutScreenState extends State<ClockOutScreen> {
  final TextEditingController _noteController = TextEditingController();
  File? _imageFile;
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  late LatLng startLocation;
  String location = "Location Name:";
  bool isShowPass = false;
  bool onError = false;
  List<ShiftData>? _shiftData;
  String? responseTime;
  bool? isLoading;
  DatabaseHelper? _dbHelper;
  @override
  void initState() {
    super.initState();

    _dbHelper = DatabaseHelper.instance;
    _imageFile = widget.picture;
    _shiftData = widget.shiftData;
    startLocation = LatLng(widget.position.latitude, widget.position.longitude);
  }

  // @override
  // void dispose() {
  //   _cameraController!.dispose();
  //   super.dispose();
  // }

  Widget googleMapUI() {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      // height: MediaQuery.of(context).size.height / 1.8,
      height: MediaQuery.of(context).size.height / 3,
      width: width,
      child: Stack(
        children: <Widget>[
          Stack(children: [
            GoogleMap(
              //Map widget from google_maps_flutter package
              zoomGesturesEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              //enable Zoom in, out on map
              initialCameraPosition: CameraPosition(
                //innital position in map
                target: startLocation, //initial position
                zoom: 14.0, //initial zoom level
              ),
              mapType: MapType.normal, //map type
              onMapCreated: (controller) {
                //method called when map is created
                setState(() {
                  mapController = controller;
                });
              },
              onCameraMove: (CameraPosition cameraPositiona) {
                cameraPosition = cameraPositiona; //when map is dragging
              },
              onCameraIdle: () async {},
            ),
            Center(
              //picker image on google map
              child: Image.asset(
                "assets/icons/ic_picker.png",
                width: 100,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> presensi() async {
    bool timeAuto = await DatetimeSetting.timeIsAuto();
    bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();

    if (!timezoneAuto || !timeAuto) {
      Navigator.pop(context);
      showDialog(
        barrierDismissible: false,
        builder: (_) => const CustomDialog(
          title: "Silahkan Ganti Setting Tanggal dan Waktu",
          message:
              'Tanggal dan Waktu tidak terdeteksi secara Outomatis Segera ganti Tanggal dan Waktu Outomatis untuk menghindari kecurangan Absensi',
        ),
        context: context,
      ).then((value) {
        if (value != null) {
          // print(value);
          DatetimeSetting.openSetting();
        }
      });
    } else {
      DateTime now = DateTime.now();
      String todayDocID = DateFormat.Hm().format(now);
      String todayDateNow = DateFormat("yyyy-MM-dd").format(now);
      // print("Jammmm Masuk " + todayDateNow.toString());
      presensiToServer(todayDocID, widget.position, _imageFile, todayDateNow);
    }

    // HomeController().getTimeZone().then((result) {
    //   if (result != null) {
    //     responseTime = result.data['time'];

    //     // presensiToServer(responseTime, widget.position, _imageFile);
    //   } else {
    //     DateTime now = DateTime.now();
    //     String todayDocID = DateFormat.Hm().format(now);
    //     //  print(todayDocID.toString());
    //     //presensiToServer(responseTime, widget.position, _imageFile);
    //     Navigator.pop(context);
    //     UiUtils.errorMessage(
    //         "Terjadi Kesalahan Perikasa Kembali Jaringan Anda!", context);
    //     presensiToServer(todayDocID, widget.position, _imageFile);
    //   }
    // });
  }

  Future<void> presensiToServer(String? responseTime, Position positionLatLong,
      File? imageFileImages, String todayDateNow) async {
    HomeController()
        .postPresensiOut(responseTime, positionLatLong, imageFileImages,
            _noteController.text, widget.alamatKar)
        .then((result) {
      // print("Masuk Mana +" + result.data["status"].toString());
      if (result != null) {
        if (result.data["status"] == "success") {
          LocalStorageService.save(
              "statusAbsen", result.data["data"]["statusAbsen"]);

          Navigator.pop(context);

          showDialog(
            barrierDismissible: false,
            builder: (_) => WillPopScope(
                onWillPop: () async => false,
                child: CustomDialogStatus(
                  title: "Clock-Out Success",
                  subTittle: "You have successfully clocked-Out on",
                  messageData: responseTime,
                )),
            context: context,
          ).then((value) {
            if (value != null) {
              // Navigator.pop(context);

              Modular.to.popAndPushNamed('/home/');
            }
          });
        } else {
          UiUtils.errorMessage(
              "Sedang Terjadi Kesalahan Silahkan Coba Kembali", context);
          Navigator.of(context).pop();
          //  gotoOfflineDataBase(responseTime, positionLatLong, imageFileImages);
        }
      } else {
        gotoOfflineDataBase(responseTime, positionLatLong, imageFileImages);
      }
    });
  }

  void gotoOfflineDataBase(
      String? responseTime, Position positionLatLong, File? imageFileImages) {
    String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _dbHelper!.getAttendOnday().then((result) async {
      // print("asasasas " + jsonEncode(result));

      AttendOnday userToSave = AttendOnday(
        dayDate: currentDate,
        statusAbsen: 0,
        timeIn: result.timeIn,
        timeOut: responseTime,
        late: "",
        early: "",
        absent: "",
        totalAttendance: "",
      );

      AbsensiOffline absensiOffline = AbsensiOffline(
        dayDate: currentDate,
        statusAbsen: 0,
        waktu: responseTime,
        inLat: positionLatLong.latitude.toString(),
        inLong: positionLatLong.longitude.toString(),
        fotoUrl: imageFileImages!.path.toString(),
        status: 2,
        keterangan: "",
      );

      _dbHelper!.updateAttendOnday(userToSave, absensiOffline);

      LocalStorageService.save("statusAbsen", 2);
    });

    Navigator.pop(context);
    showDialog(
      barrierDismissible: false,
      builder: (_) => WillPopScope(
          onWillPop: () async => false,
          child: CustomDialogStatus(
            title: "Clock-Out Offline Succes ",
            subTittle: "Absen Pulang Berhasil Disimpan di Data Base",
            messageData: responseTime,
          )),
      context: context,
    ).then((value) {
      if (value != null) {
        // Navigator.pop(context);
        Modular.to.popAndPushNamed('/home/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(true);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xffFFFFFF),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: AppColor.primaryBlueColor(),
              ),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
            centerTitle: true,
            automaticallyImplyLeading: false,
            // leadingWidth: 15,
            title: TextWidget.appBarTitle(
              "Clock-Out",
              color: AppColor.primaryBlueColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        googleMapUI(),
                        // Image.asset(
                        //   'assets/images/dummy_map.png',
                        //   width: MediaQuery.of(context).size.width,
                        //   fit: BoxFit.cover,
                        // ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(defaultMargin),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CustomContainer(
                                      // height: 174,
                                      // width: 174,
                                      borderColor: Colors.transparent,
                                      radius: 4,
                                      child: Image.file(
                                        _imageFile!,
                                        width: 192,
                                        height: 235,
                                        fit: BoxFit.cover,
                                      ),
                                      // Image.asset(
                                      //   'assets/images/image_dummy.png',
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                  ),
                                  Container(
                                    // color: AppColor.redColor(),
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: defaultMargin),
                                    // height: MediaQuery.of(context).size.height,
                                    child: Column(
                                      children: [
                                        const TextWidget.bodyMedium(
                                          'Pastikan hasil foto terlihat degan jelas',
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(
                                          height: 32,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 20,
                                              child: const Divider(),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 8.0),
                                              child: TextWidget.bodyMedium(
                                                'Atau',
                                              ),
                                            ),
                                            Container(
                                              width: 20,
                                              child: const Divider(),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        CustomButton(
                                          isRounded: true,
                                          borderRadius: 4,
                                          backgroundColor:
                                              AppColor.secondaryColor(),
                                          width: double.infinity,
                                          text: TextWidget.labelLarge(
                                            'Retake',
                                            color: AppColor.primaryBlueColor(),
                                            fontWeight: boldWeight,
                                          ),
                                          leading: SvgPicture.asset(
                                            'assets/icons/ic_camera.svg',
                                            colorFilter: ColorFilter.mode(
                                              AppColor.primaryBlueColor(),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                            // Navigator.pushNamedAndRemoveUntil(
                                            //     context, '/main-screen', (route) => false);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomContainer(
                              padding: EdgeInsets.symmetric(
                                  horizontal: defaultMargin),
                              containerType: RoundedContainerType.noOutline,
                              backgroundColor: AppColor.whiteColor(),
                              radius: 6,
                              margin: const EdgeInsets.only(top: 6),
                              // height: 200,
                              child: TextField(
                                  cursorColor: AppColor.primaryBlueColor(),
                                  maxLines: 100 ~/ 20, // <--- maxLines
                                  controller: _noteController,
                                  decoration: InputDecoration(
                                    hintText: 'Optional Note',
                                    hintStyle: bodyLargeTextStyle.copyWith(
                                        color: AppColor.captionColor()),
                                    errorText: null,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide(
                                        color: AppColor.grey1Color(),
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  )),
                            ),
                          ],
                        ),

                        // Add more content widgets as needed
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  color: AppColor.redColor(),
                  child: CustomContainer(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultMargin,
                      vertical: defaultMargin,
                    ),
                    child: CustomButton(
                      isRounded: true,
                      borderRadius: 4,
                      backgroundColor: AppColor.secondaryColor(),
                      width: double.infinity,
                      text: TextWidget.labelLarge(
                        'Clock-Out',
                        color: AppColor.primaryBlueColor(),
                        fontWeight: boldWeight,
                      ),
                      leading: SvgPicture.asset(
                        'assets/icons/ic_clock_plus.svg',
                        colorFilter: ColorFilter.mode(
                          AppColor.primaryBlueColor(),
                          BlendMode.srcIn,
                        ),
                      ),
                      onPressed: () async {
                        showDialog(
                          barrierDismissible: false,
                          builder: (_) => const CustomDialogLoading(),
                          context: context,
                        );
                        await presensi();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
    //);
  }
}
