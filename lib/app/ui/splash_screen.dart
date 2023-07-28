// ignore_for_file: unused_field, library_private_types_in_public_api

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
    Future.delayed(Duration(seconds: duration), () async {
      LocalStorageService.load("headerToken").then((value) {
        if (value == null) {
          Modular.to.popAndPushNamed('/auth/');
        } else {
          fetchData();
          Modular.to.popAndPushNamed('/home/');
        }
      });
    });

    super.initState();
  }

  fetchData() {
    futureProfile = HomeController().getProfileAll();
    futureProfile.then((value) {
      if (value != null) {
        if (value.status == "success") {
          LocalStorageService.save(
              "statusVerif", value.dataProfile?.statusVerifId);
        }
      }
    });
  }

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
