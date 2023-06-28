import 'package:flutter/material.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/constant/enums/button_type.dart';
import 'package:sangati/app/widgets/reusable_components/custom_text.dart';

class CustomButton extends StatelessWidget {
  final TextWidget? text;
  final Color backgroundColor;
  final bool isRounded;
  final double? borderRadius;
  final ButtonType buttonType;
  final Function()? onPressed;
  final Color borderColor;
  final double height;
  final double width;
  final Widget? leading;
  final Widget? rightIcon;

  const CustomButton({
    Key? key,
    this.height = 43,
    this.width = 0,
    this.text,
    this.onPressed,
    this.borderColor = const Color(0xff000000),
    this.backgroundColor = const Color(0xffFFFFFF),
    this.borderRadius,
    this.buttonType = ButtonType.noOutLined,
    this.isRounded = false,
    this.leading,
    this.rightIcon,
  }) : super(key: key);

  OutlinedBorder getBorderType() {
    switch (buttonType) {
      case ButtonType.outLined:
        return RoundedRectangleBorder(
          side: BorderSide(width: 1, color: borderColor),
          borderRadius: isRounded
              ? BorderRadius.circular(borderRadius ?? 8)
              : BorderRadius.zero,
        );
      case ButtonType.noOutLined:
        return RoundedRectangleBorder(
          borderRadius: isRounded
              ? BorderRadius.circular(borderRadius ?? 8)
              : BorderRadius.zero,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: getBorderType(),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            leading ?? Container(),
            const SizedBox(
              width: 8,
            ),
            text!,
            const Expanded(child: SizedBox()),
            rightIcon ?? Container(),
          ],
        ),
      ),
    );
  }
}

class MyOutlineButton extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final EdgeInsets? padding;
  final Color? color, bacgroundColor;
  final Widget? prefixIcon;
  final Function()? onTap;
  final bool? active;
  final BorderRadius? borderRadius;

  const MyOutlineButton({
    Key? key,
    required this.text,
    this.style,
    this.padding,
    this.color,
    this.prefixIcon,
    this.onTap,
    this.active,
    this.borderRadius,
    this.bacgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: borderRadius != null
            ? RoundedRectangleBorder(
                borderRadius: borderRadius!,
              )
            : const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
        backgroundColor: bacgroundColor ?? AppColor.whiteColor(),
        elevation: 0,
        foregroundColor: color ?? AppColor.primaryColor(),
        padding: padding,
        side: BorderSide(
          color: color ?? AppColor.primaryColor(),
        ),
      ),
      onPressed: onTap ?? () {},
      child: prefixIcon != null
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                prefixIcon!,
                // Spacing(width: 8),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  text,
                  style: style,
                ),
              ],
            )
          : Text(
              text,
              style: style,
            ),
    );
  }
}
