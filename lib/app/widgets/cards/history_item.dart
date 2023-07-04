import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sangati/app/models/history_model.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/ui/history/detail_history_screen.dart';
import 'package:sangati/app/widgets/constant/enums/rounded_container_type.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class HistoryItem extends StatelessWidget {
  final HistoryModel historyItem;
  const HistoryItem({
    super.key,
    required this.historyItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // print("-------" + historyItem.idHistory.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailHistoryScreen(historyItem: historyItem),
          ),
        );
      },
      child: CustomContainer(
        containerType: RoundedContainerType.noOutline,
        radius: 8,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        margin: EdgeInsets.only(bottom: defaultMargin),
        shadow: [
          BoxShadow(
              offset: const Offset(4, 4),
              blurRadius: 30,
              color: Colors.black.withOpacity(0.06))
        ],
        backgroundColor: AppColor.whiteColor(),
        child: Column(
          children: [
            Row(
              children: [
                // SvgPicture.asset(
                //   'assets/icons/ic_calendar.svg',
                //   colorFilter: ColorFilter.mode(
                //     AppColor.primaryBlueColor(),
                //     BlendMode.srcIn,
                //   ),
                // ),
                // const SizedBox(
                //   width: 5,
                // ),
                TextWidget.titleMedium(historyItem.dateTime.toString()),
                Expanded(child: Container()),
                CustomContainer(
                  containerType: RoundedContainerType.outlined,
                  radius: 6,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  backgroundColor: historyItem.status == 'Normal'
                      ? AppColor.completedColor().withOpacity(0.1)
                      : historyItem.status == 'Office Trip'
                          ? AppColor.secondaryColor().withOpacity(0.1)
                          : historyItem.status == 'MANGKIR'
                              ? AppColor.redColor().withOpacity(0.1)
                              : historyItem.status == 'Cuti'
                                  ? AppColor.primaryBlueColor().withOpacity(0.1)
                                  : historyItem.status == 'Izin'
                                      ? AppColor.primaryBlueColor()
                                          .withOpacity(0.1)
                                      : AppColor.separatorColor()
                                          .withOpacity(0.1),
                  borderColor: historyItem.status == 'Normal'
                      ? AppColor.completedColor()
                      : historyItem.status == 'Office Trip'
                          ? AppColor.secondaryColor()
                          : historyItem.status == 'MANGKIR'
                              ? AppColor.redColor()
                              : historyItem.status == 'Cuti'
                                  ? AppColor.primaryBlueColor()
                                  : historyItem.status == 'Izin'
                                      ? AppColor.primaryBlueColor()
                                      : AppColor.separatorColor(),
                  child: TextWidget.labelMedium(historyItem.status.toString()),
                ),
              ],
            ),
            Divider(
              color: AppColor.separatorColor(),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_clock_plus.svg',
                          colorFilter: ColorFilter.mode(
                            AppColor.secondaryColor(),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const TextWidget.labelMedium('In'),
                      ],
                    ),
                    historyItem.inClock == ''
                        ? const TextWidget.titleMedium('-')
                        : RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: historyItem.inClock,
                                    style: titleMediumTextStyle),
                                // TextSpan(
                                //   text: ' WIB',
                                //   style: bodySmallTextStyle.copyWith(
                                //     color: AppColor.bodyColor(),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(right: 24),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_clock_remove.svg',
                          colorFilter: ColorFilter.mode(
                            AppColor.redColor(),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const TextWidget.labelMedium('Out'),
                      ],
                    ),
                    historyItem.outClock == ''
                        ? const TextWidget.titleMedium('-')
                        : RichText(
                            text: TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                    text: historyItem.outClock,
                                    style: titleMediumTextStyle),
                                // TextSpan(
                                //   text: ' WIB',
                                //   style: bodySmallTextStyle.copyWith(
                                //     color: AppColor.bodyColor(),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(child: Container()),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_clock_remove.svg',
                          colorFilter: ColorFilter.mode(
                            AppColor.bodyColor(),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const TextWidget.labelMedium('Duration')
                      ],
                    ),
                    TextWidget.titleMedium(historyItem.duration.toString()),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
