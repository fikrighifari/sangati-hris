// ignore_for_file: unused_field, unused_local_variable, use_build_context_synchronously, sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/models/shift_model.dart';
import 'package:sangati/app/service/local_storage_service.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/constant/enums/rounded_container_type.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class ClockInScreen extends StatefulWidget {
  const ClockInScreen({
    Key? key,
    required this.picture,
    required this.position,
    this.shiftData,
  }) : super(key: key);
  final File? picture;

  final Position position;
  final ShiftData? shiftData;
  @override
  State<ClockInScreen> createState() => _ClockInScreenState();
}

class _ClockInScreenState extends State<ClockInScreen> {
  File? _imageFile;
  GoogleMapController? mapController;
  CameraPosition? cameraPosition;
  late LatLng startLocation;
  String location = "Location Name:";
  bool isShowPass = false;
  bool onError = false;
  late Map<String, dynamic> dataResponse;
  ShiftData? _shiftData;
  String? responseTime;
  bool? isLoading;
  @override
  void initState() {
    super.initState();
    _imageFile = widget.picture;
    _shiftData = widget.shiftData;
    startLocation = LatLng(widget.position.latitude, widget.position.longitude);
  }

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
    HomeController().getTimeZone().then((result) {
      if (result != null) {
        responseTime = result.data['time'];
        // print(responseTime.toString());
        presensiToServer(responseTime, widget.position, _imageFile);
      } else {
        DateTime now = DateTime.now();
        String todayDocID = DateFormat.Hm().format(now);
        //  print(todayDocID.toString());
        UiUtils.errorMessage(
            "Terjadi Kesalahan Perikasa Kembali Jaringan Anda!", context);
        Navigator.pop(context);
      }
    });

    // dataResponse = await PageIndexController.determinePosition();

    // if (dataResponse["error"] != true) {
    //   Position positionLtLong = dataResponse["position"];

    //   double distance = Geolocator.distanceBetween(
    //       double.parse(_shiftData!.inLat!),
    //       double.parse(_shiftData!.inLong!),
    //       positionLtLong.latitude,
    //       positionLtLong.longitude);
    //   int distanceVal = 0;

    //   if (distance <= int.parse(widget.shiftData!.radius.toString())) {
    //     //  print("------->>Di Dalam Area");
    //     distanceVal = 1;
    //   }
    //   // print("sasasasas: " + distanceVal.toString());
    //   bool canMockLocation = await SafeDevice.canMockLocation;
    //   if (!canMockLocation == false) {
    //     showDialog(
    //       builder: (_) => const CustomDialog(
    //           title: "Developer Options\nHP Anda Aktif!",
    //           message:
    //               "Silahkan matikan Developer Options/Opsi Pengembang pada Pengaturan device Anda, lalu keluar dari aplikasi ini dan coba masuk kembali."),
    //       context: context,
    //     ).then((value) {
    //       if (value != null) {
    //         //  print(value);
    //       }
    //     });
    //   } else if (distanceVal == 0) {
    //     showDialog(
    //       barrierDismissible: false,
    //       builder: (_) => const CustomDialog(
    //         title: "Anda Berada Di luar Area ",
    //         message:
    //             'Anda Berada Di luar Area jangkauan Absensi silahkan kembali ke titik Absensi',
    //       ),
    //       context: context,
    //     ).then((value) {
    //       if (value != null) {
    //         // print(value);
    //         // DatetimeSetting.openSetting();
    //       }
    //     });
    //   } else {
    //     HomeController().getTimeZone().then((result) {
    //       if (result != null) {
    //         responseTime = result.data['time'];

    //         presensiToServer(responseTime, positionLtLong, _imageFile);
    //       }
    //     });
    //   }
    // } else {
    //   //  Navigator.pop(context);
    // }
  }

  Future<void> presensiToServer(String? responseTime, Position positionLatLong,
      File? imageFileImages) async {
    showDialog(
      barrierDismissible: false,
      builder: (_) => const CustomDialogLoading(),
      context: context,
    );
    HomeController()
        .postPresensiIn(responseTime, positionLatLong, imageFileImages)
        .then((result) {
      if (result != null) {
        if (result.data["status"] == "success") {
          LocalStorageService.save(
              "statusAbsen", result.data["data"]["statusAbsen"]);

          Navigator.pop(context);
          showDialog(
            barrierDismissible: false,
            builder: (_) => CustomDialogStatus(
              title: "Clock-In Success",
              subTittle: "You have successfully clocked-in on",
              messageData: responseTime,
            ),
            context: context,
          ).then((value) {
            if (value != null) {
              // Navigator.pop(context);
              Modular.to.popAndPushNamed('/home/');
              // print(value);
              // DatetimeSetting.openSetting();
            }
          });
        } else {
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFFFFFF),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColor.primaryBlueColor(),
          ),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        // leadingWidth: 15,
        title: TextWidget.appBarTitle(
          "Clock-In",
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
                                    width: 130,
                                    // height: 235,
                                    fit: BoxFit.cover,
                                  ),
                                  // Image.asset(
                                  //   'assets/images/image_dummy.png',
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                // color: AppColor.redColor(),
                                width: MediaQuery.of(context).size.width / 2.5,
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
                                        Navigator.of(context).pop();
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
                          padding:
                              EdgeInsets.symmetric(horizontal: defaultMargin),
                          containerType: RoundedContainerType.noOutline,
                          backgroundColor: AppColor.whiteColor(),
                          radius: 6,
                          margin: const EdgeInsets.only(top: 6),
                          // height: 200,
                          child: TextField(
                              cursorColor: AppColor.primaryBlueColor(),
                              maxLines: 100 ~/ 20, // <--- maxLines
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
                    'Clock-In',
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
    );
  }
}
