import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sangati/app/themes/app_themes.dart';

Widget displayNone() => const SizedBox.shrink();

class CustomTextField extends StatelessWidget {
  final Widget? suffixIcon, prefixIcon;
  final Color? backgroundColor, textHintColor, textLabelColor;
  final EdgeInsets? padding, margin;
  final String? hintText, labelText, labelField;
  final FocusNode? focusNode;
  final Function(String)? onChange;
  final bool readOnly, obscureText;
  final VoidCallback? onTap;
  final int? maxLine, minLine;
  final TextEditingController? controller;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final TextInputType? keyboardType;

  const CustomTextField({
    Key? key,
    this.backgroundColor,
    this.prefixIcon,
    this.suffixIcon,
    this.padding,
    this.margin,
    this.textHintColor,
    this.textLabelColor,
    this.controller,
    this.focusNode,
    this.textStyle,
    this.labelStyle,
    this.labelField,
    this.hintText,
    this.labelText,
    this.maxLine,
    this.minLine,
    this.onChange,
    this.onTap,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelText != null
            ? Text(
                labelText.toString(),
                style: labelStyle ?? defaultTextStyle,
              )
            : displayNone(),
        const SizedBox(
          height: 6,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: backgroundColor ?? AppColor.whiteColor(),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLine ?? 1,
            minLines: minLine ?? 1,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            style: textStyle ?? const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              labelText: labelField,
              labelStyle: TextStyle(color: AppColor.grey2Color()),
              errorText: null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                  color: AppColor.grey1Color(),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              contentPadding: padding ??
                  const EdgeInsets.symmetric(horizontal: 16).copyWith(
                    top: 10,
                    bottom: 10,
                  ),
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              suffixIcon: suffixIcon,
              prefixIcon: prefixIcon,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor.secondaryColor(),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            cursorColor: Colors.grey,
            obscureText: obscureText,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class SuffixIconTextOutline extends StatelessWidget {
  final String url;
  final double? width;
  final VoidCallback? onTap;
  const SuffixIconTextOutline(
    this.url, {
    Key? key,
    this.onTap,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: .5,
        child: SvgPicture.asset(
          url,
          width: width,
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final EdgeInsets? padding;
  final Function()? onTap;
  const CustomTextButton({
    Key? key,
    required this.text,
    this.style,
    this.onTap,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(
          elevation: 0,
          // primary: AppColor.primayRedColor,
          padding: padding,
        ),
        onPressed: onTap ?? () {},
        child: Text(
          text,
          style: style,
        ));
  }
}

class OutlineTextField extends StatelessWidget {
  final Widget? suffixIcon;
  final Color? backgroundColor, textHintColor, textLabelColor;
  final EdgeInsets? padding, margin;
  final String? hintText, labelText, helperText;
  final double height;
  final int? maxLine, minLine;
  final TextInputType? keyboardType;
  final bool readOnly, obscureText, filled;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatter;

  const OutlineTextField({
    Key? key,
    this.backgroundColor,
    this.controller,
    this.focusNode,
    this.helperText,
    this.hintText,
    this.labelText,
    this.keyboardType,
    this.textLabelColor,
    this.textHintColor,
    this.onTap,
    this.suffixIcon,
    this.onChanged,
    this.minLine,
    this.validator,
    this.inputFormatter,
    this.padding,
    this.margin = const EdgeInsets.only(bottom: 12),
    this.filled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.height = 42,
    this.maxLine = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        // color: this.backgroundColor ?? AppColor.whiteColor,
      ),
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: TextFormField(
            inputFormatters: inputFormatter,
            focusNode: focusNode,
            obscureText: obscureText,
            controller: controller,
            onChanged: onChanged,
            onTap: onTap,
            readOnly: readOnly,
            keyboardType: keyboardType,
            maxLines: maxLine,
            minLines: minLine,
            validator: validator,
            decoration: InputDecoration(
              fillColor: readOnly ? AppColor.blackColor() : null,
              filled: readOnly && filled,
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor.whiteColor(),
                ),
              ),
              border: const OutlineInputBorder(),
              contentPadding: padding ??
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              hintText: hintText,
              hintStyle: TextStyle(
                color: textHintColor,
              ),
              labelStyle: TextStyle(
                color: textLabelColor,
              ),
              labelText: labelText,
              suffixIcon: suffixIcon,
              helperText: helperText,
            ),
          ))
        ],
      ),
    );
  }

  static Widget label(
    String label, {
    SuffixIconTextOutline? suffixIcon,
    int? maxline = 1,
    int? minline = 1,
    TextInputType? keyboardType,
    TextEditingController? controller,
    Function(String)? onChanged,
    Function()? onTap,
    bool obscureText = false,
    FormFieldValidator<String>? validator,
    bool readOnly = false,
    bool filled = true,
    FocusNode? focusNode,
    EdgeInsets? margin,
    List<TextInputFormatter>? inputFormatter,
    String? helperText,
    String? hintText,
  }) =>
      OutlineTextField(
        focusNode: focusNode,
        onTap: onTap,
        readOnly: readOnly,
        filled: filled,
        validator: validator,
        obscureText: obscureText,
        onChanged: onChanged,
        controller: controller,
        keyboardType: keyboardType,
        maxLine: maxline,
        minLine: minline,
        margin: margin ?? const EdgeInsets.only(bottom: 12),
        backgroundColor: AppColor.backgroundColor(),
        // textLabelColor: AppColor.primayRedColor,
        labelText: label,
        suffixIcon: suffixIcon,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ).copyWith(top: 14),
        inputFormatter: inputFormatter,
        helperText: helperText,
        hintText: hintText,
        // textHintColor: AppColor.primayRedColor,
      );
}
