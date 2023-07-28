// ignore_for_file: unused_local_variable, library_private_types_in_public_api, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, avoid_print, unused_field, avoid_function_literals_in_foreach_calls, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/database/databse_helper.dart';
import 'package:sangati/app/models/profile_model.dart';
import 'package:sangati/app/service/local_storage_service.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int duration = 2;
  late Future<ProfileModels?> futureProfile;
  DatabaseHelper? _dbHelper;
  @override
  void initState() {
    _dbHelper = DatabaseHelper.instance;
    // syncDatabaseToserver();
    // LocalStorageService.save("statusAbsen", 2);
    Future.delayed(Duration(seconds: duration), () async {
      LocalStorageService.load("headerToken").then((value) {
        //    print("headerTokenValue :--------------->>> " + value.toString());
        if (value == null) {
          Modular.to.popAndPushNamed('/auth/');
          // print("headerTokenValue is Null ");
        } else {
          fetchData();
          Modular.to.popAndPushNamed('/home/');
          //Modular.to.popAndPushNamed('/auth/');
          // print("headerTokenValue is There ");
        }
      });
    });

    // AttendOnday userToSave = AttendOnday(
    //   dayDate: "2023-07-10",
    //   statusAbsen: 0,
    //   timeIn: "08:15",
    //   timeOut: "08:15",
    //   late: "",
    //   early: "",
    //   absent: "",
    //   totalAttendance: "",
    // );

    // AbsensiOffline absensiOffline = AbsensiOffline(
    //   dayDate: "2023-07-10",
    //   statusAbsen: 0,
    //   waktu: "15:15",
    //   inLat: "-6.1655744",
    //   inLong: "106.8238948",
    //   fotoUrl: "/data/user/0/com.hris.sangati/cache/CAP3356541719864253882.jpg",
    //   status: 1,
    //   keterangan: "",
    // );

    // //print("asasasas kkk: " + jsonEncode(absensiOffline));

    // _dbHelper!.updateAttendOnday(userToSave, absensiOffline);

    super.initState();
  }

  fetchData() {
    futureProfile = HomeController().getProfileAll();
    futureProfile.then((value) {
      if (value != null) {
        if (value.status == "success") {
          LocalStorageService.save(
              "statusVerif", value.dataProfile?.statusVerifId);
          //  syncDatabaseToserver();
        }
      }
    });
  }

  // syncDatabaseToserver() async {
  //   // List<AbsensiOffline>? absenOff = await _dbHelper!.getAbsensi();
  //   var allRows = await _dbHelper!.getAbsensi();
  //   print("asasas KKKAKKAKAKK hhhh total " + allRows!.length.toString());
  //   if (allRows.length > 0) {
  //     allRows.forEach((dataOff) async {
  //       if (dataOff.status == 1) {
  //         //_dbHelper!.deleteAbsensiOffline(dataOff.id!);
  //         print("asasas KKKAKKAKAKK statsus " + dataOff.status.toString());
  //         presensiToServerIn(dataOff.dayDate, dataOff.waktu, dataOff.inLat,
  //             dataOff.inLong, dataOff.keterangan, dataOff.fotoUrl);
  //       } else {
  //         print("asasas KKKAKKAKAKK statsus " + dataOff.status.toString());
  //         // _dbHelper!.deleteAbsensiOffline(dataOff.id!);
  //         presensiToServerOut(dataOff.dayDate, dataOff.waktu, dataOff.inLat,
  //             dataOff.inLong, dataOff.keterangan, dataOff.fotoUrl);
  //       }
  //       // await nameProvider.sync(row['name'], _connectionStatus);
  //       // await _update(row['id'], row['name']);
  //     });
  //   }
  //   // if (absenOff!.length > 0) {
  //   //   int index = 0;
  //   //   for (AbsensiOffline absensiData in absenOff) {
  //   //     //index = index + 1;
  //   //     // print("asasas KKKAKKAKAKK " + absensiData.status.toString());
  //   //     // print("asasas KKKAKKAKAKK " + absensiData.status.toString());
  //   //   }
  //   // }
  // }

  // Future<void> presensiToServerIn(
  //   String? todayDateNow,
  //   String? responseTime,
  //   String? positionLat,
  //   String? positionLong,
  //   String? catatan,
  //   String? imageFileImages,
  // ) async {
  //   File? fileImages = File(imageFileImages!);
  //   HomeController()
  //       .postPresensiInOffline(todayDateNow, responseTime, positionLat,
  //           positionLong, catatan, fileImages)
  //       .then((result) {
  //     if (result != null) {
  //       if (result.data["status"] == "success") {
  //         print("Berhasil");
  //       } else {
  //         print("Gagal 1");
  //       }
  //     } else {
  //       print("Gagal 2");
  //     }
  //   });
  // }

  // Future<void> presensiToServerOut(
  //   String? todayDateNow,
  //   String? responseTime,
  //   String? positionLat,
  //   String? positionLong,
  //   String? catatan,
  //   String? imageFileImages,
  // ) async {
  //   File? fileImages = File(imageFileImages!);
  //   HomeController()
  //       .postPresensiOutOffline(todayDateNow, responseTime, positionLat,
  //           positionLong, catatan, fileImages)
  //       .then((result) {
  //     if (result != null) {
  //       if (result.data["status"] == "success") {
  //         print("Berhasil");
  //       } else {
  //         print("Gagal 1");
  //       }
  //     } else {
  //       print("Gagal 2");
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hideAppBar: true,
      hideBackButton: true,
      centralize: true,
      backgroundColor: AppColor.backgroundColor(),
      child: Image.asset(
        "assets/asset_logo_sangati.png",
        width: 250,
        fit: BoxFit.cover,
      ),
    );
  }
}
