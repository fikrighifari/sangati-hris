// ignore_for_file: unused_local_variable, unused_field, use_build_context_synchronously, avoid_print, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiver/collection.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/database/databse_helper.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/ui/auth/dataface/imagecovertion.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as imglib;

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
  // final FaceDetector _faceDetector = FaceDetector(
  //   options: FaceDetectorOptions(
  //     enableContours: true,
  //     enableClassification: true,
  //   ),
  // );
  bool? _isCameraPermissionGranted = false;
  final bool _isCameraLocationjGranted = false;
  // CameraController? _cameraController;
  CameraController? camera;
  final bool _isRearCameraSelected = true;
  TextEditingController controller = TextEditingController();
  bool flash = false;
  bool isControllerInitialized = false;
  //List<Face> facesDetected = [];
  late Map<String, dynamic> dataResponse;
  bool? distanceVal = false;

  dynamic faceDetector;
  CameraLensDirection direction = CameraLensDirection.front;
  late CameraDescription description = widget.cameras![1];
  Interpreter? interpreter;
  bool faceFound = false;
  int? faceFoundCount = 0;
  CameraImage? img;
  bool isBusy = false;
  Directory? tempDir;
  File? jsonFile;
  dynamic data = {};
  dynamic scanresults;
  List? e1;
  double threshold = 1.0;
  DatabaseHelper? _dbHelper;
  bool _isCameraTakePicture = false;
  @override
  void dispose() {
    camera!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    final options = FaceDetectorOptions(
        enableClassification: false,
        enableContours: false,
        enableLandmarks: false,
        performanceMode: FaceDetectorMode.accurate);

    faceDetector = FaceDetector(options: options);

    // faceDetector = FaceDetector(
    //   options: FaceDetectorOptions(
    //     enableContours: true,
    //     enableLandmarks: true,
    //   ),
    // );
    getPermissionStatus();
  }

  Future<void> cameraFunction() async {
    // cameras = await availableCameras();
    loadModel();
    camera =
        CameraController(description, ResolutionPreset.low, enableAudio: false);

    await camera!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      camera!.startImageStream((image) => {
            if (!isBusy) {isBusy = true, img = image, doFaceDetectionOnFrame()}
          });
    });
  }

  Future loadModel() async {
    try {
      var interpreterOptions = InterpreterOptions();

      interpreter = await Interpreter.fromAsset('assets/mobilefacenet.tflite',
          options: interpreterOptions);
    } on Exception {
      print('Failed to load model.');
    }
  }

  doFaceDetectionOnFrame() async {
    tempDir = await getApplicationDocumentsDirectory();
    String embPath = '${tempDir!.path}/emb.json';
    jsonFile = File(embPath);
    if (jsonFile!.existsSync()) {
      data = json.decode(jsonFile!.readAsStringSync());
    }

    String resName;
    dynamic finalResult = Multimap<String, Face>();
    var frameImg = getInputImage();
    List<Face> faces = await faceDetector.processImage(frameImg);
    print("MAsukkkkkk Berapa--------------- " + faces.length.toString());
    if (faces.isEmpty) {
      faceFound = false;
    } else {
      faceFound = true;
      faceFoundCount = faces.length;
      // print("MAsukkkkkk Berapa--------------- " + faces.length.toString());
    }
    Face face;
    imglib.Image convertedImage = _convertCameraImage(img!, direction);
    for (face in faces) {
      var boundingBox1 = face.boundingBox;
      //  log(boundingBox1.toString());
      // print("MAsukkkkkk Berapa--------------- " + faces.length.toString());
      // final double? rotX = face.headEulerAngleX;
      // final double? rotY = face.headEulerAngleY;
      // final double? rotZ = face.headEulerAngleZ;
      double x, y, w, h;
      x = (face.boundingBox.left - 10);
      y = (face.boundingBox.top - 10);
      w = (face.boundingBox.width + 10);
      h = (face.boundingBox.height + 10);
      imglib.Image croppedImage = imglib.copyCrop(
        convertedImage,
        x.round(),
        y.round(),
        w.round(),
        h.round(),
      );
      croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
      resName = _recog(croppedImage);
      // print("Namamma-----------" + resName);

      finalResult.add(resName, face);
    }
    setState(() {
      scanresults = finalResult;
      isBusy = false;
    });
  }

  imglib.Image _convertCameraImage(CameraImage image, CameraLensDirection dir) {
    int width = image.width;
    int height = image.height;
    var img = imglib.Image(width, height);
    const int hexFF = 0xFF000000;
    final int uvyButtonStride = image.planes[1].bytesPerRow;
    final int? uvPixelStride = image.planes[1].bytesPerPixel;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex = uvPixelStride! * (x / 2).floor() +
            uvyButtonStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        img.data[index] = hexFF | (b << 16) | (g << 8) | r;
      }
    }
    var img1 = (dir == CameraLensDirection.front)
        ? imglib.copyRotate(img, -90)
        : imglib.copyRotate(img, 90);
    return img1;
  }

  String _recog(imglib.Image img) {
    List input = imageToByteListFloat32(img, 112, 128, 128);
    input = input.reshape([1, 112, 112, 3]);
    List output = List.filled(1 * 192, null, growable: false).reshape([1, 192]);
    // var input = [
    //   [1.23, 6.54, 7.81, 3.21, 2.22]
    // ];

    // var output = List.filled(1 * 2, 0).reshape([1, 2]);

    interpreter?.run(input, output);
    output = output.reshape([192]);
    e1 = List.from(output);
    //return compare(e1!).toUpperCase();
    return compare(e1!);
  }

  String compare(List currEmb) {
    // print("adooooooo --------------------------------->>>>>>>>> : " +
    //     currEmb.toString());
    if (data.length == 0) return "No Face saved";
    double minDist = 999;
    double currDist = 0.0;
    String predRes = "UNKNOWN2222";
    for (String label in data.keys) {
      // print("adooooooo kk --------------------------------->>>>>>>>> : " +
      //     data.toString());
      currDist = euclideanDistance(data[label], currEmb);
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        predRes = label;
      }
    }

    log(minDist.toString() + " " + predRes);
    return predRes;
  }

  InputImage getInputImage() {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in img!.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(
      img!.width.toDouble(),
      img!.height.toDouble(),
    );
    final camera = description;
    // final imageRotation =
    //     InputImageRotationValue.fromRawValue(camera.sensorOrientation);

    final imageRotation = _getInputImageRotation(camera.sensorOrientation);

    final inputImageFormat =
        InputImageFormatValue.fromRawValue(img!.format.raw);
    final plane = img!.planes.first;

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: imageRotation, // used only in Android
        format: inputImageFormat!, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );

    // widget.onImage(inputImage);

    return inputImage;
  }

  static InputImageRotation _getInputImageRotation(int sensorOrientation) {
    //log("sensorOrientation: ${sensorOrientation}");
    if (sensorOrientation == 0) return InputImageRotation.rotation0deg;
    if (sensorOrientation == 90) return InputImageRotation.rotation90deg;
    if (sensorOrientation == 180) {
      return InputImageRotation.rotation180deg;
    } else {
      return InputImageRotation.rotation270deg;
    }
  }

  Future takePicture() async {
    if (!_isCameraPermissionGranted!) {
      getPermissionStatus();
    } else {
      // print("MAsukkkkkk total--------------- " + faceFoundCount.toString());
      if (faceFoundCount! > 1) {
        // await camera!.stopImageStream();
        showDialog(
          barrierDismissible: false,
          builder: (_) => const CustomDialog(
            title: "Pemindai Wajah",
            message: 'Lebih Dari Satu Wajah yang Terditeksi',
          ),
          context: context,
        ).then((value) {
          setState(() {});
          _isCameraTakePicture = false;
          cameraFunction();
        });
        // if (value != null) {
        //   print(value);
        //   // DatetimeSetting.openSetting();
        // }
        // });
      } else {
        await camera!.stopImageStream();
        await camera!.setFlashMode(FlashMode.off);
        XFile? pictureTake = await camera!.takePicture();
        File? imageFile = File(pictureTake.path);

        final inputImage = InputImage.fromFilePath(imageFile.path);
        presensiToServer(imageFile, e1);
      }
    }
  }

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;
    // var statusLok = await Permission.location.status;

    if (status.isGranted) {
      // log('Camera Permission: GRANTED');
      //  initCamera(widget.cameras![1]);
      cameraFunction();
      setState(() {
        _isCameraPermissionGranted = true;
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

  Future<void> presensiToServer(
      File? imageFileImages, List? modelDataJes) async {
    String faceData = jsonEncode(modelDataJes.toString());

    print(modelDataJes);

    showDialog(
      barrierDismissible: false,
      builder: (_) => const CustomDialogLoading(),
      context: context,
    );
    HomeController().postVerifikasi(imageFileImages!, faceData).then((result) {
      if (result != null) {
        if (result.data["status"] == "success") {
          // LocalStorageService.save(
          //     "statusAbsen", result.data["data"]["statusAbsen"]);
          _dbHelper!.gelUserData().then((result) async {
            print("Nama " + result.fullName.toString());
          });
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
              _isCameraTakePicture = false;
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
            (_isCameraPermissionGranted!)
                ? CameraPreview(camera!)
                : Container(
                    color: Colors.black,
                    child: const Center(child: CircularProgressIndicator())),
            Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
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
                                  !_isCameraTakePicture
                                      ? Padding(
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
                                              color:
                                                  AppColor.primaryBlueColor(),
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
                                              if (faceFound) {
                                                setState(() {
                                                  _isCameraTakePicture = true;
                                                });
                                                takePicture();
                                              } else {
                                                showDialog(
                                                  barrierDismissible: false,
                                                  builder: (_) =>
                                                      const CustomDialog(
                                                    title: "Pemindai Wajah",
                                                    message:
                                                        'Wajah Tidak Terdeteksi,',
                                                  ),
                                                  context: context,
                                                ).then((value) {
                                                  if (value != null) {
                                                    setState(() {});

                                                    _isCameraTakePicture =
                                                        false;
                                                    cameraFunction();
                                                    // print(value);
                                                    // DatetimeSetting.openSetting();
                                                  }
                                                });
                                              }
                                              //  Modular.to.popAndPushNamed('/home/');
                                              // Navigator.pushNamedAndRemoveUntil(
                                              //     context, '/main-screen', (route) => false);
                                            },
                                          ))
                                      : const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20.0),
                                          child: SizedBox(
                                              child: CircularProgressIndicator(
                                            color: Colors.black,
                                            strokeWidth: 1.5,
                                          ))),
                                ]),
                          ))),
                ])),
          ]),
        ));
  }
}
