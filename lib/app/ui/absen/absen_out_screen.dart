// ignore_for_file: unused_local_variable, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safe_device/safe_device.dart';
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
  CameraController? _cameraController;
  final bool _isRearCameraSelected = true;
  TextEditingController controller = TextEditingController();
  bool flash = false;
  bool isControllerInitialized = false;
  List<Face> facesDetected = [];
  ShiftData? _shiftData;
  late Map<String, dynamic> dataResponse;
  late int? _statusAbsen;
  int? distanceVal = 0;
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
    dateTimeZone();
    getLocationGrented();

    fetchData();
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
          print(value);
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
    // dateTimeZone();
    if (!_isCameraPermissionGranted) {
      getPermissionStatus();
    } else if (!_isTimeZonePermissionGranted) {
      dateTimeZone();
    } else {
      dataResponse = await PageIndexController.determinePosition();
      if (dataResponse["error"] != true) {
        Position position = dataResponse["position"];

        // List<Placemark> placemarks = await placemarkFromCoordinates(
        //     position.latitude, position.longitude);
        // // print(placemarks[0]);
        // String alamat =
        //     "${placemarks[0].street} , ${placemarks[0].subLocality} , ${placemarks[0].locality} , ${placemarks[0].subAdministrativeArea}";
        // await updatePosition(position, alamat);

        //cek distance between 2 koordinat / 2 posisi
        double distance = Geolocator.distanceBetween(
            double.parse(_shiftData!.outLat!),
            double.parse(_shiftData!.outLong!),
            position.latitude,
            position.longitude);
        int distanceVal = 0;

        if (distance <= int.parse(_shiftData!.radius.toString())) {
          distanceVal = 1;
        }

        // print(
        //     "Masuk ----------------------------- _isCameraLocationjGranted>>>>> " +
        //         alamat);
        // print(
        //     "Masuk ----------------------------- _isCameraLocationjGranted>>>>> " +
        //         position.latitude.toString());
        // print(
        //     "Masuk ----------------------------- _isCameraLocationjGranted>>>>> " +
        //         position.longitude.toString());
        // bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
        // // print(isDevelopmentModeEnable);
        // // print(
        // //     "Masuk ----------------------------- _isCameraLocationjGranted>>>>> " +
        // //         isDevelopmentModeEnable.toString());

        // bool isRealDevice = await SafeDevice.isRealDevice;
        bool canMockLocation = await SafeDevice.canMockLocation;
        //bool isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
        // final bool isMocked = await Geolocator.isLocationServiceEnabled();

        // bool a = !canMockLocation;
        // print("canMockLocation hhhhh----------------->>" + a.toString());
        // print("isDevelopmentModeEnable----------------->>" +
        //     isDevelopmentModeEnable.toString());
        // print(
        //     "canMockLocation----------------->>" + canMockLocation.toString());

        // print("cek is Mock");
        //print("isMocked----------------->>" + isMocked.toString());

        if (canMockLocation == true) {
          showDialog(
            builder: (_) => const CustomDialog(
                title: "Developer Options\nHP Anda Aktif!",
                message:
                    "Silahkan matikan Developer Options/Opsi Pengembang pada Pengaturan device Anda, lalu keluar dari aplikasi ini dan coba masuk kembali."),
            context: context,
          ).then((value) {
            if (value != null) {
              print(value);
            }
          });
        } else if (distanceVal == 0) {
          showDialog(
            barrierDismissible: false,
            builder: (_) => const CustomDialog(
              title: "Anda Berada Di luar Area ",
              message:
                  'Anda Berada Di luar Area jangkauan Absensi silahkan kembali ke titik Absensi',
            ),
            context: context,
          ).then((value) {
            if (value != null) {
              print(value);
              // DatetimeSetting.openSetting();
            }
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
    _cameraController =
        CameraController(cameraDescription, ResolutionPreset.high);

    try {
      await _cameraController!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        // _cameraController!.startImageStream((CameraImage image) async {
        //   if (_cameraController != null) {
        // if (_isDetecting) return;
        // _isDetecting = true;
        // dynamic finalResult = Multimap<String, Face>();

        // detect(image, getDetectionMethod()).then((dynamic result) async {
        //   if (result.length == 0 || result == null) {
        //     _faceFound = false;
        //     _predRes = 'Tidak dikenali';
        //   } else {
        //     _faceFound = true;
        //   }

        //   String res;
        //   Face _face;

        //   imglib.Image convertedImage =
        //       convertCameraImage(image, CameraLensDirection.front);

        //   for (_face in result) {
        //     double x, y, w, h;
        //     x = (_face.boundingBox.left - 10);
        //     y = (_face.boundingBox.top - 10);
        //     w = (_face.boundingBox.width + 10);
        //     h = (_face.boundingBox.height + 10);
        //     imglib.Image croppedImage = imglib.copyCrop(
        //         convertedImage, x.round(), y.round(), w.round(), h.round());
        //     croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
        //     res = recog(croppedImage);
        //     finalResult.add(res, _face);
        //   }

        //   _scanResults = finalResult;
        //   _isDetecting = false;
        //   setState(() {});
        // }).catchError(
        //   (_) async {
        //     print({'error': _.toString()});
        //     _isDetecting = false;
        //     if (_camera != null) {
        //       await _camera!.stopImageStream();
        //       await Future.delayed(const Duration(milliseconds: 400));
        //       await _camera!.dispose();
        //       await Future.delayed(const Duration(milliseconds: 400));
        //       _camera = null;
        //     }
        //     Navigator.pop(context);
        //   },
        // );
        // }
        // });
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;
    // var statusLok = await Permission.location.status;

    if (status.isGranted) {
      // log('Camera Permission: GRANTED');
      initCamera(widget.cameras![1]);
      setState(() {
        _isCameraPermissionGranted = true;
      });
    }
  }

  getLocationGrented() async {
    dataResponse = await PageIndexController.determinePosition();
    if (dataResponse["error"] != true) {
      Position position = dataResponse["position"];

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      // print(placemarks[0]);
      String alamat =
          "${placemarks[0].street} , ${placemarks[0].subLocality} , ${placemarks[0].locality} , ${placemarks[0].subAdministrativeArea}";
      // await updatePosition(position, alamat);

      //cek distance between 2 koordinat / 2 posisi
      double distance = Geolocator.distanceBetween(
          double.parse(_shiftData!.inLat!),
          double.parse(_shiftData!.inLong!),
          // -6.176219003174864,
          // 106.82695509783385,
          position.latitude,
          position.longitude);

      if (distance <= int.parse(_shiftData!.radius.toString())) {
        //  print("------->>Di Dalam Area");
        distanceVal = 1;
      }
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
                  distanceVal! == 0
                      ? Align(
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
                          ))
                      : Container(),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Lottie.asset("assets/lottie/face_scanning.json",
                          width: MediaQuery.of(context).size.width * 2.0),
                    ),
                  ),
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(bottom: 0),
                  //     child: Column(
                  //       children: [
                  //         // CustomContainer(
                  //         //   margin: EdgeInsets.only(
                  //         //     top: defaultMargin,
                  //         //     bottom: MediaQuery.of(context).size.height * 0.1,
                  //         //   ),
                  //         //   // height: 100,
                  //         //   padding: EdgeInsets.symmetric(
                  //         //     horizontal: defaultMargin,
                  //         //     vertical: defaultMargin,
                  //         //   ),
                  //         //   radius: 8,
                  //         //   backgroundColor:
                  //         //       AppColor.secondaryColor().withOpacity(0.2),
                  //         //   child: TextWidget(
                  //         //     'Anda sedang berada di luar jangkauan',
                  //         //     color: AppColor.redColor(),
                  //         //   ),
                  //         // ),
                  //         Lottie.asset("assets/lottie/face_scanning.json",
                  //             width: MediaQuery.of(context).size.width * 2.0),
                  //       ],
                  //     ),
                  //   ),
                  // ),

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
