// ignore_for_file: unused_field

import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/models/profile_model.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/reusable_components/custom_button.dart';
import 'package:sangati/app/widgets/reusable_components/custom_scaffold.dart';
import 'package:sangati/app/widgets/reusable_components/custom_text.dart';
import 'package:sangati/app/widgets/reusable_components/custom_text_form_field.dart';
import 'package:sangati/app/widgets/reusable_components/ui_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  bool _isPhoneNumberError = false;
  bool _isPasswordError = false;
  bool _isPasswordConfirmationError = false;

  bool _showPassword = true;
  bool _showPasswordConfirmation = true;

  bool isLoading = false;
  late Future<ProfileModels?> futureRegister;
  DataProfile? dataProfile;
  String? _deviceId;

  @override
  void initState() {
    super.initState();
    _getDeviceId();
  }

  void _getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String? deviceId;

    if (kIsWeb) {
      final webBrowserInfo = await deviceInfo.webBrowserInfo;
      deviceId =
          '${webBrowserInfo.vendor ?? '-'} + ${webBrowserInfo.userAgent ?? '-'} + ${webBrowserInfo.hardwareConcurrency.toString()}';
    } else if (Platform.isAndroid) {
      const androidId = AndroidId();
      deviceId = await androidId.getId();
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId = iosInfo.identifierForVendor;
    } else if (Platform.isLinux) {
      final linuxInfo = await deviceInfo.linuxInfo;
      deviceId = linuxInfo.machineId;
    } else if (Platform.isWindows) {
      final windowsInfo = await deviceInfo.windowsInfo;
      deviceId = windowsInfo.deviceId;
    } else if (Platform.isMacOS) {
      final macOsInfo = await deviceInfo.macOsInfo;
      deviceId = macOsInfo.systemGUID;
    }

    setState(() {
      _deviceId = deviceId;
    });
  }

  void _register() {
    setState(() {
      _isPhoneNumberError = _phoneNumberController.text.isEmpty;
      _isPasswordError = _passwordController.text.isEmpty;
      _isPasswordConfirmationError = _passwordController.text.isEmpty;

      if (!_isPhoneNumberError &&
          !_isPasswordError &&
          !_isPasswordConfirmationError) {
        futureRegister = HomeController().registerProfile(context,
            _phoneNumberController.text, _passwordController.text, _deviceId!);

        isLoading = true;
        futureRegister.then((value) {
          if (value != null) {
            if (value.status == "success") {
              // dataProfile = value.dataProfile;
              UiUtils.successMessage(value.message!, context);
              Modular.to.popAndPushNamed('/auth/');
            } else {
              isLoading = false;
              setState(() {});
              UiUtils.errorMessage(value.message!, context);
            }
          } else {
            // SVProgressHUD.dismiss();
          }
        });

        // Perform register logic here
        // if register is successfull, navigate to next screen
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hideAppBar: true,
      centralize: true,
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: EdgeInsets.all(defaultMargin),
          child: Stack(
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/asset_logo_sangati.png',
                    width: 250,
                    fit: BoxFit.cover,
                  ),
                  CustomTextField(
                    labelField: 'Phone Number',
                    hintText: 'Phone Number',
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.number,
                  ),
                  _isPhoneNumberError && _phoneNumberController.text.isEmpty
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
                    hintText: 'Password',
                    obscureText: _showPassword,
                    controller: _passwordController,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                      icon: Icon(
                        _showPassword ? Icons.visibility_off : Icons.visibility,
                        color: AppColor.primaryBlueColor(),
                      ),
                    ),
                  ),

                  _passwordController.text !=
                          _passwordConfirmationController.text
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
                                'Password Confirmation is not matching',
                                color: AppColor.redColor(),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  CustomTextField(
                    labelField: 'Password Confirmation',
                    hintText: 'Password Confirmation',
                    obscureText: _showPasswordConfirmation,
                    controller: _passwordConfirmationController,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _showPasswordConfirmation =
                              !_showPasswordConfirmation;
                        });
                      },
                      icon: Icon(
                        _showPasswordConfirmation
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColor.primaryBlueColor(),
                      ),
                    ),
                  ),
                  _passwordController.text !=
                          _passwordConfirmationController.text
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
                                'Password Confirmation is not matching',
                                color: AppColor.redColor(),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget.subtitle(
                        'Minimum 6-character password',
                        textAlign: TextAlign.left,
                        color: AppColor.primaryBlueColor(),
                        fontSize: 12,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextWidget.labelLarge(
                        'Already have an account? ',
                        color: AppColor.bodyColor(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Modular.to.popAndPushNamed('/auth/');
                        },
                        child: TextWidget.titleMedium(
                          'Login',
                          color: AppColor.blueTextColor(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: defaultMargin,
                  ),
                  CustomButton(
                    isRounded: true,
                    borderRadius: 4,
                    backgroundColor: AppColor.secondaryColor(),
                    width: double.infinity,
                    text: TextWidget.labelLarge(
                      'Register',
                      color: AppColor.primaryBlueColor(),
                      fontWeight: boldWeight,
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/ic_register.svg',
                      colorFilter: ColorFilter.mode(
                        AppColor.primaryBlueColor(),
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      _passwordController.text !=
                              _passwordConfirmationController.text
                          ? Container()
                          : _register();
                      // Modular.to.popAndPushNamed('/auth/');
                      // Navigator.pushNamedAndRemoveUntil(
                      //     context, '/main-screen', (route) => false);
                    },
                  ),
                  // Expanded(child: Container()),
                ],
              ),
              isLoading ? UiUtils.customLoadingCircle(context) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
