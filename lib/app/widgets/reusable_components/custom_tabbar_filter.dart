// ignore_for_file: sized_box_for_whitespace, use_key_in_widget_constructors
part of 'reusable_components.dart';

class CustomTabbar extends StatelessWidget {
  final int? selectedIndex;
  final List<String>? titles;
  final Function(int)? onTap;

  const CustomTabbar({
    this.selectedIndex,
    this.titles,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: titles!
                .map(
                  (e) => Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: CustomContainer(
                      width: 130,
                      radius: 4,
                      containerType: RoundedContainerType.outlined,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      backgroundColor: (titles!.indexOf(e) == selectedIndex)
                          ? AppColor.secondaryColor().withOpacity(0.1)
                          : AppColor.whiteColor(),
                      borderColor: (titles!.indexOf(e) == selectedIndex)
                          ? AppColor.secondaryColor()
                          : AppColor.grey1Color(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                          SvgPicture.asset(
                            'assets/icons/ic_dropdown_filter.svg',
                            width: 16,
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
