part of 'reusable_components.dart';

class TextWidget extends StatelessWidget {
  final double? fontSize;
  final Color? color;
  final String? text;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final int? maxLines;
  final TextWidgetType textWidgetType;

  const TextWidget(
    this.text, {
    Key? key,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.textWidgetType = TextWidgetType.text,
  }) : super(key: key);

  const TextWidget.title(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign = TextAlign.center,
    FontWeight? fontWeight,
    double? fontSize,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.title,
        );

  const TextWidget.subtitle(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign = TextAlign.center,
    FontWeight? fontWeight,
    double? fontSize,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.subTitle,
        );

  const TextWidget.appBarTitle(
    String text, {
    Key? key,
    Color? color,
    TextAlign textAlign = TextAlign.center,
    FontWeight? fontWeight,
    double? fontSize,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontSize: fontSize,
          fontWeight: fontWeight,
          textWidgetType: TextWidgetType.title,
        );

  const TextWidget.button(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.button,
        );

  //* Display Style
  const TextWidget.displayLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.displayLarge,
        );

  const TextWidget.displayMedium(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.displayMedium,
        );

  const TextWidget.displaySmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.displaySmall,
        );

//* Headline Style
  const TextWidget.headlineLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.headlineLarge,
        );

  const TextWidget.headlineMedium(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.headlineMedium,
        );

  const TextWidget.headlineSmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.headlineSmall,
        );

//* Title Style
  const TextWidget.titleLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.titleLarge,
        );

  const TextWidget.titleMedium(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.titleMedium,
        );

  const TextWidget.titleSmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.titleSmall,
        );

//* Label Style
  const TextWidget.labelLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.labelLarge,
        );

  const TextWidget.labelMedium(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.labelMedium,
        );

  const TextWidget.labelSmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.labelSmall,
        );

//* Label Style
  const TextWidget.bodyLarge(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.bodyLarge,
        );

  const TextWidget.bodyMedium(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.bodyMedium,
        );

  const TextWidget.bodySmall(
    String text, {
    Key? key,
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) : this(
          text,
          key: key,
          color: color,
          textAlign: textAlign,
          fontWeight: fontWeight,
          fontSize: fontSize,
          textWidgetType: TextWidgetType.bodySmall,
        );

  TextStyle getStyleDefault(BuildContext context) {
    switch (textWidgetType) {
      case TextWidgetType.text:
        return defaultTextStyle;
      case TextWidgetType.title:
        return titleTextStyle;
      case TextWidgetType.subTitle:
        return subtitleTextStyle;
      case TextWidgetType.button:
        return labelLargeTextStyle.copyWith(
          color: AppColor.primaryBlueColor(),
          fontWeight: boldWeight,
        );

      //* Display Style
      case TextWidgetType.displayLarge:
        return displayLargeTextStyle;
      case TextWidgetType.displayMedium:
        return displayMediumTextStyle;
      case TextWidgetType.displaySmall:
        return displaySmallTextStyle;

      //* Headline Style
      case TextWidgetType.headlineLarge:
        return headlineLargeTextStyle;
      case TextWidgetType.headlineMedium:
        return headlineMediumTextStyle;
      case TextWidgetType.headlineSmall:
        return headlineSmallTextStyle;

      //* Title Style
      case TextWidgetType.titleLarge:
        return titleLargeTextStyle;
      case TextWidgetType.titleMedium:
        return titleMediumTextStyle;
      case TextWidgetType.titleSmall:
        return titleSmallTextStyle;

      //* Label Style
      case TextWidgetType.labelLarge:
        return labelLargeTextStyle;
      case TextWidgetType.labelMedium:
        return labelMediumTextStyle;
      case TextWidgetType.labelSmall:
        return labelSmallTextStyle;

      //* Body Style
      case TextWidgetType.bodyLarge:
        return bodyLargeTextStyle;
      case TextWidgetType.bodyMedium:
        return bodyMediumTextStyle;
      case TextWidgetType.bodySmall:
        return bodySmallTextStyle;

      // Theme.of(context).textTheme.button!;
      // case TextWidgetType.fieldLabel:
      //   return Theme.of(context).textTheme.subtitle1!.merge(
      //         const TextStyle(fontSize: 14),
      //       );
      default:
        throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    final styleDefault = getStyleDefault(context);
    return Text(
      text!,
      textAlign: textAlign,
      maxLines: maxLines ?? DefaultTextStyle.of(context).maxLines,
      style: styleDefault.apply(
        color: color,
        fontSizeFactor:
            fontSize == null ? 1 : fontSize! / styleDefault.fontSize!,
        fontWeightDelta: fontWeight == null
            ? 0
            : fontWeight!.index - styleDefault.fontWeight!.index,
      ),
    );
  }
}
