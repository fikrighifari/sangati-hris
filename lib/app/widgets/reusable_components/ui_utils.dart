// ignore_for_file: non_constant_identifier_names, unnecessary_new, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/constant/enums/rounded_container_type.dart';
import 'package:sangati/app/widgets/reusable_components/custom_container.dart';
import 'package:shimmer/shimmer.dart';

class UiUtils {
  static errorMessage(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(message),
      backgroundColor: AppColor.redColor(),
      behavior: SnackBarBehavior.floating,
      elevation: 30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 20,
          left: 20),
    ));
  }

  static successMessage(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(message),
      backgroundColor: AppColor.completedColor(),
      behavior: SnackBarBehavior.floating,
      // margin: EdgeInsets.all(50),
      elevation: 30,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          right: 20,
          left: 20),
    ));
  }

  static errorMessageClose(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(message),
      backgroundColor: AppColor.grey2Color(),
      behavior: SnackBarBehavior.floating,
      elevation: 30,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      // margin: EdgeInsets.only(
      //     bottom: MediaQuery.of(context).size.height - 100,
      //     right: 20,
      //     left: 20),
    ));
  }

  static customLoadingCircle(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      // color: Colors.black.withOpacity(0.1),
      child: Center(
        child: Container(
          // padding: const EdgeInsets.only(bottom: 20),
          child: Lottie.asset(
            "assets/lottie/app_line_circle_loading.json",
            width: MediaQuery.of(context).size.width * 0.5,
            // width: 140,
          ),
          //     CircularProgressIndicator(
          //   color: AppColor.secondaryColor(),
          // ),
        ),
      ),
    );
  }

  static customLoadingSuccessAbsen(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.1),
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: Lottie.asset(
            "assets/lottie/sand_timer.json",
            width: MediaQuery.of(context).size.width * 0.6, fit: BoxFit.cover,
            // width: 140,
          ),
        ),
      ),
    );
  }

  static customShimmerHome(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: defaultMargin,
            vertical: defaultMargin,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      margin: const EdgeInsets.only(bottom: 5),
                      radius: 10,
                      height: 10,
                      width: 150,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      margin: const EdgeInsets.only(bottom: 5),
                      radius: 10,
                      height: 10,
                      width: 120,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      margin: const EdgeInsets.only(bottom: 5),
                      radius: 10,
                      height: 10,
                      width: 100,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ],
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        CustomContainer(
          padding: EdgeInsets.all(defaultMargin),
          radius: 4,
          // height: clockCardHeight,
          width: MediaQuery.of(context).size.width / 1.1,
          containerType: RoundedContainerType.noOutline,
          backgroundColor: AppColor.whiteColor(),
          shadow: [
            BoxShadow(
                offset: const Offset(4, 4),
                blurRadius: 30,
                color: Colors.black.withOpacity(0.06))
          ],
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      margin: const EdgeInsets.only(bottom: 5),
                      radius: 10,
                      height: 10,
                      width: 100,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      margin: const EdgeInsets.only(bottom: 5),
                      radius: 10,
                      height: 10,
                      width: 100,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 8,
                ),
                child: Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CustomContainer(
                        radius: 10,
                        height: 75,
                        width: 150,
                        backgroundColor: AppColor.whiteColor(),
                      ),
                    ),
                    const Spacer(),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CustomContainer(
                        radius: 10,
                        height: 75,
                        width: 150,
                        backgroundColor: AppColor.whiteColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: defaultMargin,
            horizontal: defaultMargin,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 6,
                      height: 64,
                      width: 64,
                      margin: const EdgeInsets.only(bottom: 5),
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 10,
                      width: 64,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 50,
              ),
              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 6,
                      height: 64,
                      width: 64,
                      margin: const EdgeInsets.only(bottom: 5),
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 10,
                      width: 64,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 50,
              ),
              Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 6,
                      height: 64,
                      width: 64,
                      margin: const EdgeInsets.only(bottom: 5),
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 10,
                      width: 64,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: AppColor.separatorColor(),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: defaultMargin,
            vertical: defaultMargin,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: CustomContainer(
                  radius: 10,
                  height: 10,
                  width: 150,
                  backgroundColor: AppColor.whiteColor(),
                ),
              ),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: CustomContainer(
                  radius: 10,
                  height: 10,
                  width: 100,
                  backgroundColor: AppColor.whiteColor(),
                ),
              ),
            ],
          ),
        ),
        CustomContainer(
          padding: EdgeInsets.all(defaultMargin),
          margin: EdgeInsets.symmetric(vertical: defaultMargin),
          radius: 4,
          // height: clockCardHeight,
          width: MediaQuery.of(context).size.width / 1.1,
          containerType: RoundedContainerType.noOutline,
          backgroundColor: AppColor.whiteColor(),
          shadow: [
            BoxShadow(
                offset: const Offset(4, 4),
                blurRadius: 30,
                color: Colors.black.withOpacity(0.06))
          ],
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 10,
                      width: 150,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 10,
                      width: 100,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Divider(
                color: AppColor.separatorColor(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 50,
                      width: 150,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 50,
                      width: 150,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        CustomContainer(
          padding: EdgeInsets.all(defaultMargin),
          margin: EdgeInsets.symmetric(vertical: defaultMargin),
          radius: 4,
          // height: clockCardHeight,
          width: MediaQuery.of(context).size.width / 1.1,
          containerType: RoundedContainerType.noOutline,
          backgroundColor: AppColor.whiteColor(),
          shadow: [
            BoxShadow(
                offset: const Offset(4, 4),
                blurRadius: 30,
                color: Colors.black.withOpacity(0.06))
          ],
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 10,
                      width: 150,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 10,
                      width: 100,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Divider(
                color: AppColor.separatorColor(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 50,
                      width: 150,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 50,
                      width: 150,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static customShimmerProfile(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          padding: EdgeInsets.all(defaultMargin),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 24),
                    child: SizedBox(
                      height: 96,
                      width: 96,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CustomContainer(
                            radius: 10,
                            height: 15,
                            width: 200,
                            backgroundColor: AppColor.whiteColor(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CustomContainer(
                            radius: 10,
                            height: 15,
                            width: 120,
                            backgroundColor: AppColor.whiteColor(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CustomContainer(
                            radius: 10,
                            height: 16,
                            width: 100,
                            backgroundColor: AppColor.whiteColor(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CustomContainer(
                            radius: 10,
                            height: 16,
                            width: 120,
                            backgroundColor: AppColor.whiteColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: Divider(
                  color: AppColor.separatorColor(),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CustomContainer(
                        radius: 5,
                        height: 35,
                        width: 35,
                        backgroundColor: AppColor.whiteColor(),
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 16,
                      width: 120,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: CustomContainer(
            padding: EdgeInsets.symmetric(
              horizontal: defaultMargin,
              vertical: defaultMargin,
            ),
            margin: EdgeInsets.only(top: defaultMargin),
            width: double.infinity,
            // backgroundColor: AppColor.redColor(),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 5,
                      height: 35,
                      width: 35,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: CustomContainer(
                    radius: 10,
                    height: 16,
                    width: 120,
                    backgroundColor: AppColor.whiteColor(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
