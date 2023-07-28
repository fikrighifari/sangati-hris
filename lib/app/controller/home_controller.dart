// ignore_for_file: non_constant_identifier_names, avoid_print, unnecessary_new, unused_local_variable, deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sangati/app/config/variables.dart';
import 'package:sangati/app/models/attendance_history_model.dart';
import 'package:sangati/app/models/history_detail_model.dart';
import 'package:sangati/app/models/home_model.dart';
import 'package:sangati/app/models/profile_model.dart';
import 'package:sangati/app/models/shift_model.dart';
import 'package:sangati/app/service/local_storage_service.dart';

class HomeController {
  Future<ProfileModels?> registerProfile(BuildContext context,
      String phoneNumber, String password, String imaei) async {
    Map<String, dynamic> body = {
      "password": password,
      "phone": phoneNumber,
      "emei": imaei,
    };
    try {
      Dio dio = new Dio();
      Response response = await dio.post(postAPIRegister,
          data: jsonEncode(body),
          options: Options(
            contentType: 'application/json',
          ));

      // print("response  Data $response");

      if (response.statusCode == 200) {
        ProfileModels homeRes = ProfileModels.fromJson(response.data);
        //    print("balikan ata " + '${homeRes}');
        return homeRes;
      }
      return null;

      //return ;
    } on DioError catch (e) {
      print(e);
      //RegistrasiModel homeRes1 = RegistrasiModel.fromJson(e.response.data);
      //  return "failed";
    }
    return null;
    // return null;
  }

  // Future<ProfileModels?> loginProfile(BuildContext context, String phoneNumber,
  //     String password, String imaei) async {
  //   Map<String, dynamic> body = {
  //     "password": password,
  //     "phone": phoneNumber,
  //     "emei": imaei,
  //   };
  //   try {
  //     Dio dio = new Dio();
  //     Response response = await dio.post(postAPILogin,
  //         data: jsonEncode(body),
  //         options: Options(
  //           contentType: 'application/json',
  //         ));

  //     print("response  Data $response");

  //     if (response.statusCode == 200) {
  //       ProfileModels homeRes = ProfileModels.fromJson(response.data);
  //       // print("balikan ata " + '${homeRes}');
  //       return homeRes;
  //     }
  //     return null;

  //     //return ;
  //   } on DioError catch (e) {
  //     print(e);
  //     //RegistrasiModel homeRes1 = RegistrasiModel.fromJson(e.response.data);
  //     //  return "failed";
  //   }
  //   return null;
  //   // return null;
  // }

  Future<ProfileModels?> getProfileAll() async {
    String? authToken = await LocalStorageService.load('headerToken');
    try {
      Dio dio = Dio();
      dio.options.contentType = 'JSON';
      dio.options.responseType = ResponseType.json;
      Response response = await dio.get(
        getAPIProfile,
        options: Options(
          contentType: 'application/json',
          headers: {
            'authorization': 'Bearer $authToken',
          },
        ),
      );
      // print('response profile data $response');
      if (response.statusCode == 200) {
        ProfileModels profileRes = ProfileModels.fromJson(response.data);

        return profileRes;
      }
      return null;
    } catch (e) {
      // print(e);
      return null;
    }
  }

  Future<HomeModel?> getHomeClass() async {
    String? authToken = await LocalStorageService.load("headerToken");
    // print("DAta ----------kkkk---->>>> " + authToken.toString());

    try {
      Dio dio = new Dio();
      dio.options.contentType = 'JSON';
      dio.options.responseType = ResponseType.json;
      Response response = await dio.get(
        getAPIHome,
        options: Options(
          contentType: 'application/json',
          headers: {
            "authorization": "Bearer $authToken",
          },
        ),
      );
      // print("response  Data Profile $response");
      if (response.statusCode == 200) {
        HomeModel homeRes = HomeModel.fromJson(response.data);
        //print("balikan ata " + '${profileRes}');

        return homeRes;
      }

      return null;
      // }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<HistoryDetailModel?> getDetailHistory([int? idHistory]) async {
    String? authToken = await LocalStorageService.load("headerToken");

    try {
      var params = {
        "attendance_id": idHistory,
      };
      //  print("DAta ----------kkkk---->>>> " + authToken.toString());

      Dio dio = new Dio();
      dio.options.contentType = 'JSON';
      dio.options.responseType = ResponseType.json;
      Response response = await dio.get(
        getAPIHistoryDetail,
        queryParameters: params,
        options: Options(
          contentType: 'application/json',
          headers: {
            "authorization": "Bearer $authToken",
          },
        ),
      );
      //print("DAta ----------kkkk---->>>> " + dataImage.toString());
      // print("response  Data HistoryDetailModel $response");
      if (response.statusCode == 200) {
        HistoryDetailModel homeRes = HistoryDetailModel.fromJson(response.data);
        //print("balikan ata " + '${profileRes}');

        return homeRes;
      }

      return null;
      // }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<ShiftModel?> getShift() async {
    String? authToken = await LocalStorageService.load("headerToken");
    try {
      Dio dio = new Dio();
      Response response = await dio.get(
        getAPIShift,
        options: Options(
          contentType: 'application/json',
          headers: {
            "authorization": "Bearer $authToken",
          },
        ),
      );
      // print("response  Data getShift $response");

      if (response.statusCode == 200) {
        ShiftModel homeRes = ShiftModel.fromJson(response.data);
        // print("balikan ata " + '${homeRes}');
        return homeRes;
      }
      return null;

      //return ;
    } on DioError catch (e) {
      print(e);
      //RegistrasiModel homeRes1 = RegistrasiModel.fromJson(e.response.data);
      //  return "failed";
    }
    return null;
    // return null;
  }

  Future<dynamic> getTimeZone() async {
    try {
      Dio dio = new Dio();
      Response response = await dio.get(
        "https://timeapi.io/api/Time/current/zone?timeZone=Asia/Jakarta",
        options: Options(
          contentType: 'application/json',
        ),
      );
      // print("response  Data $response");

      if (response.statusCode == 200) {
        String responseTime = response.data['time'];
        // print("balikan ata " + '${homeRes}');
        // Map<String, dynamic> data = json.decode(response.data);
        //  print("balikan ata " + '${responseToken}');
        return response;
      }

      return null;
    } on DioError catch (e) {
      print(e);
      //RegistrasiModel homeRes1 = RegistrasiModel.fromJson(e.response.data);
      //  return "failed";
    }

    return null;
  }

  Future<dynamic> postPresensiIn(String? responseTime, Position positionLatLong,
      File? imageFileImages) async {
    String? authToken = await LocalStorageService.load("headerToken");
    try {
      FormData formData = FormData.fromMap({
        "scan_in": responseTime,
        "in_lat": positionLatLong.latitude,
        "in_long": positionLatLong.longitude,
        "file_foto": imageFileImages != null
            ? MultipartFile(
                imageFileImages.openRead(), await imageFileImages.length(),
                filename: "profile.jpg")
            : "",
      });
      Dio dio = new Dio();
      Response response = await dio.post(
        postAPIPresensiIn,
        data: formData,
        options: Options(
          contentType: 'application/json',
          headers: {
            "authorization": "Bearer $authToken",
          },
        ),
      );
      print("response  Data Possss $response");

      if (response.statusCode == 200) {
        //  String responseTime = response.data;
        // print("balikan ata " + '${homeRes}');
        // Map<String, dynamic> data = json.decode(response.data);
        //  print("balikan ata " + '${responseToken}');

        return response;
      }

      return null;
    } on DioError catch (e) {
      print("response  Data Possss $e");
      //  print(e);
      //RegistrasiModel homeRes1 = RegistrasiModel.fromJson(e.response.data);
      //  return "failed";
      return null;
    }
  }

  Future<dynamic> postPresensiOut(String? responseTime,
      Position positionLatLong, File? imageFileImages) async {
    String? authToken = await LocalStorageService.load("headerToken");
    try {
      FormData formData = FormData.fromMap({
        "scan_out": responseTime,
        "out_lat": positionLatLong.latitude,
        "out_long": positionLatLong.longitude,
        "file_foto": imageFileImages != null
            ? MultipartFile(
                imageFileImages.openRead(), await imageFileImages.length(),
                filename: "profile.jpg")
            : "",
      });
      Dio dio = new Dio();
      Response response = await dio.post(
        postAPIPresensiOut,
        data: formData,
        options: Options(
          contentType: 'application/json',
          headers: {
            "authorization": "Bearer $authToken",
          },
        ),
      );
      print("response  Data Possss $response");

      if (response.statusCode == 200) {
        //  String responseTime = response.data;
        // print("balikan ata " + '${homeRes}');
        // Map<String, dynamic> data = json.decode(response.data);
        //  print("balikan ata " + '${responseToken}');

        return response;
      }

      return null;
    } on DioError catch (e) {
      print("response  Data Possss $e");
      //  print(e);
      //RegistrasiModel homeRes1 = RegistrasiModel.fromJson(e.response.data);
      //  return "failed";
    }

    return null;
  }

  Future<ProfileModels?> getProfile() async {
    String? authToken = await LocalStorageService.load('headerToken');
    try {
      Dio dio = new Dio();
      dio.options.contentType = 'JSON';
      dio.options.responseType = ResponseType.json;
      Response response = await dio.get(
        getAPIProfile,
        options: Options(
          contentType: 'application/json',
          headers: {
            'authorization': 'Bearer $authToken',
          },
        ),
      );
      // print('response profile data $response');
      if (response.statusCode == 200) {
        ProfileModels profileRes = ProfileModels.fromJson(response.data);

        return profileRes;
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<dynamic> postVerifikasi(File? imageFileImages) async {
    String? authToken = await LocalStorageService.load("headerToken");
    try {
      FormData formData = FormData.fromMap({
        "file_foto": imageFileImages != null
            ? MultipartFile(
                imageFileImages.openRead(), await imageFileImages.length(),
                filename: "profile.jpg")
            : "",
      });
      Dio dio = new Dio();
      Response response = await dio.post(
        postAPIVerifikasi,
        data: formData,
        options: Options(
          contentType: 'application/json',
          headers: {
            "authorization": "Bearer $authToken",
          },
        ),
      );
      print("response  Data Possss $response");

      if (response.statusCode == 200) {
        return response;
      }

      return null;
    } on DioError catch (e) {
      print("response  Data Possss $e");
      //  print(e);
      //RegistrasiModel homeRes1 = RegistrasiModel.fromJson(e.response.data);
      //  return "failed";
    }

    return null;
  }

  Future<AttendanceHistoryModel?> getAttendanceHistory(
    int currentPage,
    String? dateMM,
    String? dateYYYY,
  ) async {
    String? authToken = await LocalStorageService.load("headerToken");

    try {
      var params = {
        "page": currentPage,
        "per_page": 10,
        "sort": "desc",
        "status": "",
        "month": dateMM,
        "year": dateYYYY,
      };
      //  print("DAta ----------kkkk---->>>> " + authToken.toString());

      Dio dio = new Dio();
      dio.options.contentType = 'JSON';
      dio.options.responseType = ResponseType.json;
      Response response = await dio.get(
        getAPIAttendanceHistory,
        queryParameters: params,
        options: Options(
          contentType: 'application/json',
          headers: {
            "authorization": "Bearer $authToken",
          },
        ),
      );
      //print("DAta ----------kkkk---->>>> " + dataImage.toString());
      //print("response  Data HistoryDetailModel $response");
      if (response.statusCode == 200) {
        AttendanceHistoryModel homeRes =
            AttendanceHistoryModel.fromJson(response.data);
        //print("balikan ata " + '${profileRes}');

        return homeRes;
      }

      return null;
      // }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
