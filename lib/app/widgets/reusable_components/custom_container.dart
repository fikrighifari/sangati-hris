import 'package:flutter/material.dart';
import 'package:sangati/app/widgets/constant/enums/rounded_container_type.dart';

class CustomContainer extends StatelessWidget {
  final RoundedContainerType containerType;
  final Widget? child;
  final Color borderColor;
  final Color backgroundColor;
  final List<BoxShadow>? shadow;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? height;
  final double? width;
  final double radius;
  final double borderDepth;

  const CustomContainer({
    Key? key,
    this.child,
    this.shadow,
    this.height,
    this.width,
    this.padding,
    this.margin,
    this.borderDepth = 1,
    this.backgroundColor = const Color(0xffFFFFFF),
    this.borderColor = const Color(0xff000000),
    this.radius = 0,
    this.containerType = RoundedContainerType.noOutline,
  }) : super(key: key);

  const CustomContainer.clean({
    Key? key,
    RoundedContainerType containerType = RoundedContainerType.clean,
    Widget? child,
    double? height,
    double? width,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color backgroundColor = Colors.transparent,
  }) : this(
          key: key,
          containerType: containerType,
          child: child,
          height: height,
          width: width,
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
        );

  const CustomContainer.mini({
    Key? key,
    RoundedContainerType containerType = RoundedContainerType.noOutline,
    Color backgroundColor = const Color(0xffFFFFFF),
    double radius = 0,
    double? height = 50,
    double? width = 50,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Widget? child,
  }) : this(
          key: key,
          containerType: containerType,
          backgroundColor: backgroundColor,
          radius: radius,
          height: height,
          width: width,
          margin: margin,
          padding: padding,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: containerType == RoundedContainerType.clean
            ? Colors.transparent
            : backgroundColor,
        boxShadow: containerType == RoundedContainerType.clean ? null : shadow,
        borderRadius: BorderRadius.circular(radius),
        border: containerType == RoundedContainerType.noOutline ||
                containerType == RoundedContainerType.clean
            ? null
            : Border.all(
                width: borderDepth,
                color: borderColor,
              ),
      ),
      child: child,
    );
  }
}
