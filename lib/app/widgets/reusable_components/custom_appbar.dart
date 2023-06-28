import 'package:flutter/material.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/reusable_components/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? rightWidget;
  final Widget? backButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.rightWidget,
    this.backButton,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      backgroundColor: const Color(0xffFFFFFF),
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          backButton ?? Container(),
          TextWidget.titleMedium(
            title,
            color: AppColor.blueTextColor(),
            fontWeight: boldWeight,
          ),
          rightWidget ?? Container(),
          // IconButton(
          //   icon: Icon(Icons.logout),
          //   onPressed: () {
          //     // Implement logout functionality here
          //   },
          // ),
        ],
      ),
    );
  }
}
