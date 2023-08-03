// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/service/local_storage_service.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class SettingSreen extends StatelessWidget {
  const SettingSreen({super.key});

  @override
  Widget build(BuildContext context) {
    void showLogoutDialog() {
      showDialog(
        builder: (_) => AlertDialog(
          title: TextWidget.titleMedium(
            'Sign-Out',
            textAlign: TextAlign.center,
            color: AppColor.primaryBlueColor(),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const TextWidget.bodyMedium(
                'Apakah anda yakin ingin keluar dari akun anda?',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: defaultMargin,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: const BorderSide(color: Colors.green))),
                    child: TextWidget.titleSmall(
                      'No',
                      color: AppColor.whiteColor(),
                      fontWeight: boldWeight,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.secondaryColor(),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: TextWidget.titleSmall(
                      'Logout',
                      color: AppColor.blackColor(),
                      fontWeight: boldWeight,
                    ),
                    onPressed: () {
                      LocalStorageService.remove("headerToken");

                      LocalStorageService.remove("statusVerif");
                      LocalStorageService.remove("statusAbsen");

                      Modular.to.popAndPushNamed('/auth/');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        context: context,
      );
    }

    void showDeleteAccountDialog() {
      showDialog(
        builder: (_) => AlertDialog(
          title: TextWidget.titleMedium(
            'Delete Account',
            textAlign: TextAlign.center,
            color: AppColor.primaryBlueColor(),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const TextWidget.bodyMedium(
                'Apakah anda yakin ingin menghapus akun Sangati Absence milik anda?',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: defaultMargin,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: const BorderSide(color: Colors.green))),
                    child: TextWidget.titleSmall(
                      'No',
                      color: AppColor.whiteColor(),
                      fontWeight: boldWeight,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.secondaryColor(),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: TextWidget.titleSmall(
                      'Yes',
                      color: AppColor.blackColor(),
                      fontWeight: boldWeight,
                    ),
                    onPressed: () async {
                      showDialog(
                        barrierDismissible: true,
                        builder: (_) => const CustomDialogLoading(),
                        context: context,
                      );

                      bool balikanData = await HomeController().deleteProfile();

                      if (balikanData == true) {
                        LocalStorageService.remove("headerToken");
                        LocalStorageService.remove("statusVerif");
                        LocalStorageService.remove("statusAbsen");

                        Modular.to.popAndPushNamed('/auth/');
                      } else {
                        UiUtils.errorMessage(
                            "Sedang Terjadi Kesalahan Silahkan Coba Kembali",
                            context);
                        Navigator.of(context).pop();
                      }
                      // await
                      // do the process here;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        context: context,
      );
    }

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
        title: 'Account Setting',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      showLogoutDialog();
                    },
                    child: CustomContainer(
                      padding: EdgeInsets.all(defaultMargin),
                      margin: EdgeInsets.only(top: defaultMargin),
                      shadow: [
                        BoxShadow(
                            offset: const Offset(4, 4),
                            blurRadius: 20,
                            color: Colors.black.withOpacity(0.04))
                      ],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextWidget.titleMedium(
                            'Sign-Out',
                            color: AppColor.redColor(),
                            fontWeight: boldWeight,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: AppColor.grey1Color(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.sizeOf(context).height / 3,
                  ),
                  Opacity(
                    opacity: 0.4,
                    child: Image.asset(
                      "assets/asset_logo_sangati.png",
                      width: 250,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: AppColor.redColor(),
            child: CustomContainer(
              padding: EdgeInsets.symmetric(
                horizontal: defaultMargin,
                vertical: defaultMargin,
              ),
              child: CustomButton(
                isRounded: true,
                borderRadius: 4,
                backgroundColor: AppColor.redColor(),
                width: double.infinity,
                text: TextWidget.labelLarge(
                  'Delete Account',
                  color: AppColor.whiteColor(),
                  fontWeight: boldWeight,
                ),
                leading: SvgPicture.asset(
                  'assets/icons/ic_no_account.svg',
                  colorFilter: ColorFilter.mode(
                    AppColor.whiteColor(),
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () async {
                  showDeleteAccountDialog();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
