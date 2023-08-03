// ignore_for_file: unused_local_variable, unused_field, use_build_context_synchronously, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers, unnecessary_const, unused_catch_clause, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quiver/collection.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/controller/page_index.dart';
import 'package:sangati/app/database/databse_helper.dart';
import 'package:sangati/app/models/shift_model.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/ui/absen/clock_in_screen.dart';
import 'package:sangati/app/ui/auth/dataface/imagecovertion.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import 'package:image/image.dart' as imglib;

List<CameraDescription> cameras = [];

class AbsenInPage extends StatefulWidget {
  const AbsenInPage({
    Key? key,
    required this.cameras,
    this.statusAbsen,
    this.shiftData,
  }) : super(key: key);

  final List<CameraDescription>? cameras;
  final int? statusAbsen;
  final List<ShiftData>? shiftData;
  @override
  State<AbsenInPage> createState() => _AbsenInPageState();
}

class _AbsenInPageState extends State<AbsenInPage> {
  late bool? distanceVal = false;
  bool flash = false;
  bool isControllerInitialized = false;

  bool _isCameraPermissionGranted = false;
  bool _isTimeZonePermissionGranted = false;
  bool _isLocationjGranted = false;
  final bool _isRearCameraSelected = true;
  bool _isCameraTakePicture = false;
  CameraController? _cameraController;

  List<Face> facesDetected = [];
  List<ShiftData>? _shiftData;
  late Map<String, dynamic> dataResponse;
  late int? _statusAbsen;
  TextEditingController controller = TextEditingController();
  DatabaseHelper? _dbHelper;

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
  File? imageFileData;
  bool distanceCheck = false;
  String? alamatKar;
  @override
  void dispose() {
    _cameraController!.dispose();
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
        performanceMode: FaceDetectorMode.fast);

    faceDetector = FaceDetector(options: options);
    _dbHelper = DatabaseHelper.instance;
    _statusAbsen = widget.statusAbsen;
    _shiftData = widget.shiftData;
    getPermissionStatus();
    fetchData();
  }

  getPermissionStatus() async {
    await Permission.camera.request();
    var status = await Permission.camera.status;

    if (status.isGranted) {
      cameraFunction();
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

    if (dataResponse["error"] != true) {
      Position position = dataResponse["position"];
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      alamatKar =
          "${placemarks[0].street} , ${placemarks[0].subLocality} , ${placemarks[0].locality} , ${placemarks[0].subAdministrativeArea}";

      _shiftData!.forEach((dataOff) async {
        if (distanceCheck == false) {
          double distance = Geolocator.distanceBetween(
            double.parse(dataOff.inLat),
            double.parse(dataOff.inLong),
            position.latitude,
            position.longitude,
          );

          if (distance <= int.parse(dataOff.radius.toString())) {
            setState(() {
              distanceVal = false;
              distanceCheck = true;
            });
          } else {
            setState(() {
              //   print("------->>Di Luar Area " + distance.toString());
              distanceVal = true;
              distanceCheck = false;
            });
          }
        }
      });

      //  print("------->>Di Dalam Area distanceVal " + distanceVal.toString());

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
          setState(() {});
          _isCameraTakePicture = false;
          _cameraController!.startImageStream((image) => {
                if (!isBusy)
                  {isBusy = true, img = image, doFaceDetectionOnFrame()}
              });
          DatetimeSetting.openSetting();
        }
      });
    } else {
      _isTimeZonePermissionGranted = true;
    }
  }

  fetchData() {
    HomeController().getShift().then((result) async {
      if (result != null) {
        if (result.status == "success") {
          _shiftData = result.shiftData;
          await _dbHelper!.deleteTableShift();
          await _dbHelper!.insertShift(_shiftData!);
        } else {
          fetchDataBase();
        }
      } else {
        fetchDataBase();
      }
    });
  }

  fetchDataBase() {
    _dbHelper!.getShiftData().then((result) async {
      setState(() {
        _shiftData = result;
      });
    });
  }

  Future<void> cameraFunction() async {
    loadModel();
    _cameraController =
        CameraController(description, ResolutionPreset.low, enableAudio: false);

    await _cameraController!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      _cameraController!.startImageStream((image) => {
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
      // print('Failed to load model.');
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
      currDist = euclideanDistance(data[label], currEmb);
      if (currDist <= threshold && currDist < minDist) {
        minDist = currDist;
        predRes = label;
        // print("adooooooo kk --------------------------------->>>>>>>>> : " +
        //     data.toString());
      }
    }

    //  log(minDist.toString() + " " + predRes);
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
    // log('orientation: ${imageRotation.rawValue}');

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
    //  log("sensorOrientation: ${sensorOrientation}");
    if (sensorOrientation == 0) return InputImageRotation.rotation0deg;
    if (sensorOrientation == 90) return InputImageRotation.rotation90deg;
    if (sensorOrientation == 180) {
      return InputImageRotation.rotation180deg;
    } else {
      return InputImageRotation.rotation270deg;
    }
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
            await _cameraController!.stopImageStream();
            await _cameraController!.setFlashMode(FlashMode.off);
            XFile? picture = await _cameraController!.takePicture();
            setState(() {
              imageFileData = File(picture.path);
            });

            final inputImage = InputImage.fromFilePath(picture.path);
            processImage(inputImage, imageFileData!, position, _shiftData, e1);

            //   presensiToServer(imageFile, e1);
          } on CameraException catch (e) {
            debugPrint('Error occured while taking picture: $e');
            return null;
          }
        }
      }
    }
  }

  // Future initCamera(CameraDescription cameraDescription) async {
  //   _cameraController = CameraController(
  //       cameraDescription, ResolutionPreset.high,
  //       enableAudio: false);

  //   try {
  //     await _cameraController!.initialize().then((_) {
  //       if (!mounted) return;
  //       setState(() {});
  //     });
  //   } on CameraException catch (e) {
  //     debugPrint("camera error $e");
  //   }
  // }

  Future<void> processImage(InputImage inputImage, File imageFile,
      Position position, List<ShiftData>? shiftDataUser, List? e1Data) async {
    double minDist = 999;
    double currDist = 0.0;
    _dbHelper!.gelUserData().then((result) async {
      var a1 = result.modelData
          .toString()
          .substring(1, result.modelData!.length - 1);

      List ab = json.decode(a1).cast<double>().toList();
      //   print("Dara masuk  kakak-------- : " + e1Data.toString());
      //  // List? asas = jsonDecode(result.modelData);
      currDist = _euclideanDistance(ab, e1Data);
      //  print('users.currDist=>-------------->>> ${currDist}');
      if (currDist <= threshold && currDist < minDist) {
        //  print('users.modelData if ');
        minDist = currDist;
        //  predictedResult = u;
        // showDialog(
        //   barrierDismissible: false,
        //   builder: (_) => const CustomDialog(
        //     title: "Pemindai Wajah Sama",
        //     message: 'Wajah Sama',
        //   ),
        //   context: context,
        // ).then((value) {
        //   _isCameraTakePicture = false;
        // });

        // _cameraController!.startImageStream((image) => {
        //       if (!isBusy)
        //         {isBusy = true, img = image, doFaceDetectionOnFrame()}
        //     });
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClockInScreen(
                picture: imageFile,
                position: position,
                shiftData: shiftDataUser,
                alamatKar: alamatKar),
          ),
        );
        if (result == true) {
          setState(() {});
          _isCameraTakePicture = false;
          cameraFunction();
        }
        // print("Dattatstastats ---------- " + result.toString());
      } else {
        // print('users.modelData else => ');
        showDialog(
          barrierDismissible: false,
          builder: (_) => const CustomDialog(
            title: "Pemindai Wajah Tidak  Dikenali",
            message: 'Wajah Tidak Dikenali',
          ),
          context: context,
        ).then((value) {
          setState(() {});
          _isCameraTakePicture = false;
          _cameraController!.startImageStream((image) => {
                if (!isBusy)
                  {isBusy = true, img = image, doFaceDetectionOnFrame()}
              });
        });
      }
    });
  }

  double _euclideanDistance(List? e1, List? e2) {
    if (e1 == null || e2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.primaryBlueColor(),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: 'Clock-In',
      ),
      body: SafeArea(
        child: Stack(
          children: [
            (_isCameraPermissionGranted)
                ?
                // imageFileData != null
                //     ? Image.file(imageFileData!)
                CameraPreview(_cameraController!)
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
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
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
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
                                SvgPicture.asset('assets/icons/ic_faces.svg'),
                                const SizedBox(
                                  width: 10,
                                ),
                                TextWidget.titleSmall(
                                  'Pastikan posisi wajah tepat ditengah',
                                  color: AppColor.blackColor(),
                                ),
                              ],
                            ),
                            // Visibility(
                            //     visible: !_isCameraTakePicture,
                            //     child:
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
                                        if (faceFound) {
                                          setState(() {
                                            _isCameraTakePicture = true;
                                          });

                                          takePicture();
                                        } else {
                                          showDialog(
                                            barrierDismissible: false,
                                            builder: (_) => const CustomDialog(
                                              title: "Pemindai Wajah",
                                              message: 'Wajah Tidak Terdeteksi',
                                            ),
                                            context: context,
                                          ).then((value) {
                                            setState(() {});
                                            _isCameraTakePicture = false;
                                            // if (value != null) {
                                            //   // print(value);
                                            //   _isCameraTakePicture = false;
                                            //   // DatetimeSetting.openSetting();
                                            // }
                                          });
                                        }
                                      },
                                    ),
                                  )
                                : const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 20.0),
                                    child: SizedBox(
                                        child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 1.5,
                                    ))),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
