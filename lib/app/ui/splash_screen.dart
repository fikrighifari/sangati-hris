// ignore_for_file: unused_local_variable, library_private_types_in_public_api, unnecessary_null_comparison, prefer_interpolation_to_compose_strings, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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

  @override
  void initState() {
    // LocalStorageService.remove("headerToken1");
    Future.delayed(Duration(seconds: duration), () async {
      LocalStorageService.load("headerToken").then((value) {
        //    print("headerTokenValue :--------------->>> " + value.toString());
        if (value == null) {
          Modular.to.popAndPushNamed('/auth/');
          print("headerTokenValue is Null ");
        } else {
          Modular.to.popAndPushNamed('/home/');
          //Modular.to.popAndPushNamed('/auth/');
          print("headerTokenValue is There ");
        }
      });
      // LocalStorageService.check("headerToken").then((value) {
      //   if (value == true) {
      //     //  Modular.to.popAndPushNamed('/home/');
      //     print("headerTokenValue is There ");
      //   } else {
      //     // Modular.to.popAndPushNamed('/auth/');
      //   }
      // });
    });

    super.initState();
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
