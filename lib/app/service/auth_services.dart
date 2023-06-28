// ignore_for_file: unnecessary_new, avoid_print, deprecated_member_use

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sangati/app/config/variables.dart';
import 'package:sangati/app/models/profile_model.dart';

class AuthServices extends ChangeNotifier {
  //late RegisterModel _registerModel;

  // bool isLoggedIn = false;
  // bool isLoading = false;
  // Map message = {};

  // void setLoading(value) {
  //   isLoading = value;
  //   notifyListeners();
  // }

  // void setMessage(Map value) {
  //   message.addAll(value);
  //   notifyListeners();
  // }

  // // RegisterModel get registerData => _registerModel;

  // Map getMessage() => message;

  // bool get loading => isLoading;

  Future<ProfileModels?> loginProfile(BuildContext context, String phoneNumber,
      String password, String imaei) async {
    Map<String, dynamic> body = {
      "password": password,
      "phone": phoneNumber,
      "emei": imaei,
    };
    try {
      Dio dio = new Dio();
      Response response = await dio.post(postAPILogin,
          data: jsonEncode(body),
          options: Options(
            contentType: 'application/json',
          ));

      //print("response  Data $response");

      if (response.statusCode == 200) {
        ProfileModels homeRes = ProfileModels.fromJson(response.data);
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
}
