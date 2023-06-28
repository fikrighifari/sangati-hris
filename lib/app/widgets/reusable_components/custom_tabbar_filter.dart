// ignore_for_file: sized_box_for_whitespace, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/constant/enums/rounded_container_type.dart';
import 'package:sangati/app/widgets/reusable_components/custom_container.dart';

class CustomTabbar extends StatelessWidget {
  final int? selectedIndex;
  final List<String>? titles;
  final Function(int)? onTap;

  const CustomTabbar({this.selectedIndex, this.titles, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Stack(
        children: [
          Container(
              // padding: EdgeInsets.only(top: 48),
              // height: 1,
              // color: AppColor.whiteColor(),
              ),
          Row(
            children: titles!
                .map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: CustomContainer(
                      radius: 4,
                      containerType: RoundedContainerType.outlined,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      backgroundColor: (titles!.indexOf(e) == selectedIndex)
                          ? AppColor.secondaryColor().withOpacity(0.1)
                          : Colors.transparent,
                      borderColor: (titles!.indexOf(e) == selectedIndex)
                          ? AppColor.secondaryColor()
                          : Colors.transparent,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (onTap != null) {
                                onTap!(titles!.indexOf(e));
                              }
                            },
                            child: Text(
                              e,
                              style: (titles!.indexOf(e) == selectedIndex)
                                  ? labelLargeTextStyle.copyWith(
                                      fontWeight: FontWeight.w600, fontSize: 12)
                                  : labelLargeTextStyle,
                            ),
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Container(
                          //   width: 40,
                          //   height: 3,
                          //   // margin: EdgeInsets.only(top: 13),
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(1.5),
                          //       color: (titles!.indexOf(e) == selectedIndex)
                          //           ? AppColor.secondaryColor()
                          //           : Colors.transparent),
                          // ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
