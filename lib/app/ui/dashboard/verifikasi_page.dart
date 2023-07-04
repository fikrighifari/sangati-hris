// ignore_for_file: unused_local_variable, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/ui/absen/facedetection/face_detector_painter.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

List<CameraDescription> cameras = [];

class VerifikasiSreen extends StatefulWidget {
  const VerifikasiSreen({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  final List<CameraDescription>? cameras;
  @override
  State<VerifikasiSreen> createState() => _VerifikasiSreenState();
}

class _VerifikasiSreenState extends State<VerifikasiSreen> {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  bool _isCameraPermissionGranted = false;
  final bool _isCameraLocationjGranted = false;
  CameraController? _cameraController;
  final bool _isRearCameraSelected = true;
  TextEditingController controller = TextEditingController();
  bool flash = false;
  bool isControllerInitialized = false;
  List<Face> facesDetected = [];
  late Map<String, dynamic> dataResponse;
  bool? distanceVal = false;
  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getPermissionStatus();
  }

  Future takePicture() async {
    if (!_isCameraPermissionGranted) {
      getPermissionStatus();
    } else {
      try {
        await _cameraController!.setFlashMode(FlashMode.off);
        XFile? picture = await _cameraController!.takePicture();
        File? imageFile = File(picture.path);

        final inputImage = InputImage.fromFilePath(picture.path);
        processImage(inputImage, imageFile);
      } on CameraException catch (e) {
        debugPrint('Error occured while taking picture: $e');
        return null;
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
    } else {
      showDialog(
        builder: (_) => const CustomDialog(
          title: "",
          message: '',
        ),
        context: context,
      ).then((value) {
        if (value != null) {
          print(value);
        }
      });
    }
  }

  Future<void> processImage(InputImage inputImage, File? imageFile) async {
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
        presensiToServer(imageFile);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => ClockInScreen(
        //             picture: imageFile,
        //             position: position,
        //             shiftData: shiftDataUser)));
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

  Future<void> presensiToServer(File? imageFileImages) async {
    showDialog(
      barrierDismissible: false,
      builder: (_) => const CustomDialogLoading(),
      context: context,
    );
    HomeController().postVerifikasi(imageFileImages!).then((result) {
      if (result != null) {
        if (result.data["status"] == "success") {
          // LocalStorageService.save(
          //     "statusAbsen", result.data["data"]["statusAbsen"]);

          Navigator.pop(context);
          showDialog(
            barrierDismissible: false,
            builder: (_) => const CustomDialogStatus(
              title: "Verifikasi Success",
              subTittle: "You have successfully verifikasi",
              messageData: "",
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
            "Verifikasi Data",
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
