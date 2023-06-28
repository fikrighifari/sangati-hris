// ignore_for_file: non_constant_identifier_names, avoid_print, unnecessary_new

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PageIndexController {
  static Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      //return Future.error('Location services are disabled.');
      return {
        "message": "Tidak dapat mengambil GPS dari device ini",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          "message": "Izin menggunakan GPS ditolak.",
          "error": true,
        };
        //return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Pengaturan HP Anda tidak memperbolehkan untuk mengakses GPS. Ubah pada pengaturan HP Anda",
        "error": true,
      };
      //return Future.error(
      //'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    //print("POOOOOOOOOO--------------->>>>>>" + position.toString());
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device Anda",
      "error": false,
    };
  }

  static Widget loadingState() {
    return Container(
      // height: ScreenUtil().screenHeight,
      decoration: BoxDecoration(color: Colors.white.withOpacity(.5)),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
