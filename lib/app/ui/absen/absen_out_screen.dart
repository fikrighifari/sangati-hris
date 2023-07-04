// ignore_for_file: unused_local_variable, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/controller/page_index.dart';
import 'package:sangati/app/models/shift_model.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/ui/absen/clock_out_screen.dart';
import 'package:sangati/app/ui/absen/facedetection/face_detector_painter.dart';
import 'package:sangati/app/widgets/reusable_components/custom_button.dart';
import 'package:sangati/app/widgets/reusable_components/custom_container.dart';
import 'package:sangati/app/widgets/reusable_components/custom_dialog.dart';
import 'package:sangati/app/widgets/reusable_components/custom_text.dart';

class AbsenOutPage extends StatefulWidget {
  const AbsenOutPage(
      {Key? key, required this.cameras, this.statusAbsen, this.shiftData})
      : super(key: key);

  final List<CameraDescription>? cameras;
  final int? statusAbsen;
  final ShiftData? shiftData;
  @override
  State<AbsenOutPage> createState() => _AbsenOutPageState();
}

class _AbsenOutPageState extends State<AbsenOutPage> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  bool _isCameraPermissionGranted = false;
  bool _isTimeZonePermissionGranted = false;
  final bool _isCameraLocationjGranted = false;
  bool _isLocationjGranted = false;
  CameraController? _cameraController;
  final bool _isRearCameraSelected = true;
  TextEditingController controller = TextEditingController();
  bool flash = false;
  bool isControllerInitialized = false;
  List<Face> facesDetected = [];
  ShiftData? _shiftData;
  late Map<String, dynamic> dataResponse;
  late int? _statusAbsen;
  late bool? distanceVal = false;
  late bool? canMockLocation = false;

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _statusAbsen = widget.statusAbsen;
    _shiftData = widget.shiftData;
    getPermissionStatus();
    fetchData();
  }

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      // log('Camera Permission: GRANTED');
      initCamera(widget.cameras![1]);
      setState(() {
        _isCameraPermissionGranted = true;
        getLocationGrented();
      });
    } else {
      showDialog(
        barrierDismissible: false,
        builder: (_) => const CustomDialog(
          title: "Allow Camera",
          message: 'Silahkan Allow Camera Untuk Pengambilan Photo',
        ),
        context: context,
      ).then((value) {
        if (value != null) {
          getPermissionStatus();
        }
      });
    }
  }

  getLocationGrented() async {
    dataResponse = await PageIndexController.determinePosition();
    // print("sasasasas--------- " + dataResponse.toString());

    if (dataResponse["error"] != true) {
      Position position = dataResponse["position"];

      // List<Placemark> placemarks =
      //     await placemarkFromCoordinates(position.latitude, position.longitude);
      // // print(placemarks[0]);
      // String alamat =
      //     "${placemarks[0].street} , ${placemarks[0].subLocality} , ${placemarks[0].locality} , ${placemarks[0].subAdministrativeArea}";

      double distance = Geolocator.distanceBetween(
        double.parse(_shiftData!.outLat!),
        double.parse(_shiftData!.outLong!),
        // -6.176219003174864,
        // 106.82695509783385,
        position.latitude,
        position.longitude,
      );

      if (distance <= int.parse(_shiftData!.radius.toString())) {
        // print("------->>Di Dalam Area" + distance.toString());
        setState(() {
          distanceVal = false;
        });
      } else {
        // print("------->>Di Luar Area" + distance.toString());
        setState(() {
          distanceVal = true;
        });
      }
      _isLocationjGranted = true;
      dateTimeZone();
    } else {
      showDialog(
        barrierDismissible: false,
        builder: (_) => CustomDialog(
          title: "Allow Location",
          message: dataResponse["message"].toString(),
        ),
        context: context,
      ).then((value) {
        if (value != null) {
          getLocationGrented();
        }
      });
    }
  }

  Future<void> dateTimeZone() async {
    bool timeAuto = await DatetimeSetting.timeIsAuto();
    bool timezoneAuto = await DatetimeSetting.timeZoneIsAuto();
    // print(timeAuto);
    // print(timezoneAuto);

    if (!timezoneAuto || !timeAuto) {
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
      _isTimeZonePermissionGranted = true;
    }
  }

  fetchData() {
    // print("MAUKKKKSSSKSKS----------------------->>;");
    HomeController().getShift().then((result) async {
      if (result != null) {
        if (result.status == "success") {
          _shiftData = result.shiftData;
        }
      }
    });
  }

  Future takePicture() async {
    if (!_isCameraPermissionGranted) {
      getPermissionStatus();
    } else if (!_isTimeZonePermissionGranted) {
      dateTimeZone();
    } else if (!_isLocationjGranted) {
      getLocationGrented();
    } else {
      dataResponse = await PageIndexController.determinePosition();
      if (dataResponse["error"] != true) {
        Position position = dataResponse["position"];
        if (position.isMocked == true) {
          showDialog(
            builder: (_) => const CustomDialog(
                title: "Developer Options\nHP Anda Aktif!",
                message:
                    "Silahkan matikan Developer Options/Opsi Pengembang pada Pengaturan device Anda, lalu keluar dari aplikasi ini dan coba masuk kembali."),
            context: context,
          ).then((value) {
            Navigator.pop(context);
          });
        } else if (distanceVal!) {
          showDialog(
            barrierDismissible: false,
            builder: (_) => const CustomDialog(
              title: "Anda Berada Di luar Area ",
              message:
                  'Anda Berada Di luar Area jangkauan Absensi silahkan kembali ke titik Absensi',
            ),
            context: context,
          ).then((value) {
            Navigator.pop(context);
          });
        } else {
          try {
            await _cameraController!.setFlashMode(FlashMode.off);
            XFile? picture = await _cameraController!.takePicture();
            File? imageFile = File(picture.path);

            final inputImage = InputImage.fromFilePath(picture.path);
            processImage(inputImage, imageFile, position, _shiftData);
          } on CameraException catch (e) {
            debugPrint('Error occured while taking picture: $e');
            return null;
          }
        }
      }
    }
  }

  Future initCamera(CameraDescription cameraDescription) async {
    _cameraController = CameraController(
        cameraDescription, ResolutionPreset.high,
        enableAudio: false);

    try {
      await _cameraController!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  Future<void> processImage(InputImage inputImage, File imageFile,
      Position position, ShiftData? shiftData) async {
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      // _customPaint = CustomPaint(painter: painter);
    } else {
      int? faceDetect = 0;
      for (final face in faces) {
        //   text += 'face: ${face.boundingBox}\n\n';
        faceDetect = 1;
      }

      if (faceDetect! > 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ClockOutScreen(
                    picture: imageFile,
                    position: position,
                    shiftData: shiftData)));
      } else {
        showDialog(
          barrierDismissible: false,
          builder: (_) => const CustomDialog(
            title: "Pemindai Wajah",
            message: 'Wajah Tidak Terdeteksi',
          ),
          context: context,
        ).then((value) {
          if (value != null) {
            print(value);
            // DatetimeSetting.openSetting();
          }
        });
      }
    }
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
            "Clock-Out",
            color: AppColor.primaryBlueColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        body: SafeArea(
          child: Stack(children: [
            (_isCameraPermissionGranted)
                ? CameraPreview(_cameraController!)
                : Container(
                    color: Colors.black,
                    child: const Center(child: CircularProgressIndicator())),
            Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  Visibility(
                      visible: distanceVal!,
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: CustomContainer(
                              // height: 100,
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultMargin,
                                vertical: defaultMargin,
                              ),
                              radius: 8,
                              backgroundColor:
                                  AppColor.secondaryColor().withOpacity(0.2),
                              child: TextWidget(
                                'Anda sedang berada di luar jangkauan',
                                color: AppColor.primaryColor(),
                              ),
                            ),
                          ))),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Lottie.asset("assets/lottie/face_scanning.json",
                          width: MediaQuery.of(context).size.width * 2.0),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.20,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(24)),
                              color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/ic_faces.svg'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      TextWidget.titleSmall(
                                        'Pastikan posisi wajah tepat ditengah',
                                        color: AppColor.blackColor(),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0),
                                      child: CustomButton(
                                        isRounded: true,
                                        borderRadius: 4,
                                        backgroundColor:
                                            AppColor.secondaryColor(),
                                        width: double.infinity,
                                        text: TextWidget.labelLarge(
                                          'Take Pcture',
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
                                          takePicture();
                                          //  Modular.to.popAndPushNamed('/home/');
                                          // Navigator.pushNamedAndRemoveUntil(
                                          //     context, '/main-screen', (route) => false);
                                        },
                                      )),
                                ]),
                          ))),
                ])),
          ]),
        ));
  }
}
