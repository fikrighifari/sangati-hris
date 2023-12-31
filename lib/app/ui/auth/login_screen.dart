// ignore_for_file: unused_field, prefer_interpolation_to_compose_strings, unused_element, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/database/databse_helper.dart';
import 'package:sangati/app/models/profile_model.dart';
import 'package:sangati/app/models/shift_model.dart';
import 'package:sangati/app/service/auth_services.dart';
import 'package:sangati/app/service/local_storage_service.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPhoneNumberError = false;
  bool _isPasswordError = false;
  bool _showPassword = true;
  late Future<ProfileModels?> futureRegister;
  late DataProfile? dataProfile;
  late List<ShiftData>? dataShift;
  bool isLoading = false;

  SnackBar? snackBar;
  String? _deviceId = "";
  DatabaseHelper? _databaseHelper;
  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
    _getDeviceId();
  }

  void simulateAsyncTask() {
    setState(() {
      isLoading = true;
    });

    // Simulate an asynchronous task
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
      // _login();
      // Perform the logic or navigate to a new screen
      // ...
    });
  }

  void _getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    if (Platform.isAndroid) {
      const androidId = AndroidId();
      deviceId = await androidId.getId();
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    }

    setState(() {
      _deviceId = deviceId;
    });
  }

  void _login(AuthServices authServices2) {
    setState(() {
      _isPhoneNumberError = _phoneNumberController.text.isEmpty;
      _isPasswordError = _passwordController.text.isEmpty;

      if (!_isPhoneNumberError && !_isPasswordError) {
        isLoading = true;
        authServices2
            .loginProfile(context, _phoneNumberController.text,
                _passwordController.text, _deviceId!)
            .then((result) async {
          if (result != null) {
            if (result.status == "success") {
              dataProfile = result.dataProfile;
              // dataShift = dataProfile!.shift;
              LocalStorageService.save("headerToken", result.token.toString());

              LocalStorageService.save(
                  "statusVerif", dataProfile!.statusVerifId);

              HomeController().getShift().then((result) async {
                if (result != null) {
                  if (result.status == "success") {
                    dataShift = result.shiftData;
                    await _databaseHelper!.deleteAll();

                    await _databaseHelper!
                        .insertProfile(dataProfile!, dataShift!);

                    Modular.to.popAndPushNamed('/home/');
                  }
                }
              });
            } else {
              isLoading = false;
              setState(() {});
              UiUtils.errorMessage(result.message!, context);
            }
          } else {
            isLoading = false;
            setState(() {});

            UiUtils.errorMessage(
                "Sedang Terjadi Kesalahan Silahkan Coba Kembali", context);
          }
        });
      }
    });
  }

  void showSnackBar(BuildContext context, message) {
    snackBar = SnackBar(
      content: Text(message.toString()),
      backgroundColor: AppColor.redColor(),
      behavior: SnackBarBehavior.floating,
      // margin: EdgeInsets.all(50),
      elevation: 30,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 20,
          left: 20),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar!);
  }

  @override
  Widget build(BuildContext context) {
    // AuthServices authServices = context.read<AuthServices>();
    var authServices = Provider.of<AuthServices>(context);
    return WillPopScope(
        onWillPop: () {
          return exit(0);
        },
        child: CustomScaffold(
          hideAppBar: true,
          centralize: true,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                padding: EdgeInsets.all(defaultMargin),
                child: Stack(
                  children: [
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          'assets/asset_logo_sangati.png',
                          width: 250,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 64,
                        ),
                        CustomTextField(
                          labelField: 'Phone Number',
                          controller: _phoneNumberController,
                          hintText: 'Phone Number',
                          keyboardType: TextInputType.number,
                        ),

                        _isPhoneNumberError &&
                                _phoneNumberController.text.isEmpty
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 5),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      child: SvgPicture.asset(
                                          'assets/icons/ic_warning.svg'),
                                    ),
                                    TextWidget.bodySmall(
                                      "Phonenumber can't be empty",
                                      color: AppColor.redColor(),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),

                        CustomTextField(
                          labelField: 'Password',
                          controller: _passwordController,
                          hintText: 'Password',
                          obscureText: _showPassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColor.primaryBlueColor(),
                            ),
                          ),
                        ),

                        //* Warning
                        _isPasswordError && _passwordController.text.isEmpty
                            ? Container(
                                margin: EdgeInsets.only(bottom: defaultMargin),
                                child: Row(
                                  children: [
                                    Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: SvgPicture.asset(
                                            'assets/icons/ic_warning.svg')),
                                    TextWidget.bodySmall(
                                      "Password can't be empty",
                                      color: AppColor.redColor(),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextWidget.labelLarge(
                              'Don’t have an account? ',
                              color: AppColor.bodyColor(),
                            ),
                            GestureDetector(
                              onTap: () {
                                Modular.to.pushNamed('/auth/register-screen/');
                              },
                              child: TextWidget.titleMedium(
                                'Register',
                                color: AppColor.blueTextColor(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomButton(
                          isRounded: true,
                          borderRadius: 4,
                          backgroundColor: AppColor.secondaryColor(),
                          width: double.infinity,
                          text: TextWidget.labelLarge(
                            'Sign In',
                            color: AppColor.primaryBlueColor(),
                            fontWeight: boldWeight,
                          ),
                          leading: SvgPicture.asset(
                            'assets/icons/ic_login.svg',
                            colorFilter: ColorFilter.mode(
                              AppColor.primaryBlueColor(),
                              BlendMode.srcIn,
                            ),
                          ),
                          onPressed: () {
                            _login(authServices);
                          },
                        ),
                      ],
                    ),
                    isLoading
                        ? UiUtils.customLoadingCircle(context)
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
