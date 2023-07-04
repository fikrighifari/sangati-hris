// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/models/attendance_history_model.dart';
import 'package:sangati/app/models/history_model.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/cards/history_item.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key? key, required this.isBack}) : super(key: key);

  bool isBack;
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedOption = '';
  final RefreshController _refreshController = RefreshController();

  late String formattedCurrentDate;
  late DateTime selectedDate;
  late TextEditingController dateController;
  late Future<AttendanceHistoryModel?> futureAttendanceHistory;
  late List<AttendanceHistory>? attendanceHistory = [];
  late String? dateMM;
  late String? dateYYYY;
  List data = [];
  int currentPage = 1;
  int selectedIndex = 0;
  bool isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   selectedDate = DateTime.now();
  //   dateController =
  //       TextEditingController(text: DateFormat.yMMMM().format(selectedDate));
  // }

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
    dateMM = DateFormat('MM').format(selectedDate);
    dateYYYY = DateFormat('yyyy').format(selectedDate);
    fetchData();
  }

  List<String> options = [
    'Cuti Dispensasi',
    'Cuti',
    'Cuti Bersama',
  ];

  List<String> filterCategory = [
    'All',
    'Normal',
    'Mangkir',
    'Cuti',
    'Izin',
    'Official Trip',
    'Libur Nasional',
  ];

  Future<void> _showMonthYearPicker(BuildContext context) async {
    showMonthPicker(
      context: context,
      initialDate: selectedDate,
      roundedCornersRadius: 8,
      firstDate: DateTime(DateTime.now().year - 1, 5),
      lastDate: DateTime(DateTime.now().year + 1, 9),
      backgroundColor: AppColor.whiteColor(),
      headerColor: AppColor.primaryBlueColor(),
      confirmWidget: TextWidget.titleMedium(
        'OK',
        color: AppColor.blueTextColor(),
      ),
      cancelWidget: TextWidget.titleMedium(
        'Cancel',
        color: AppColor.blueTextColor(),
      ),
      selectedMonthBackgroundColor: AppColor.secondaryColor(),
      unselectedMonthTextColor: AppColor.primaryBlueColor(),
      selectedMonthTextColor: AppColor.primaryBlueColor(),
    ).then((DateTime? pickedDate) {
      if (pickedDate != null) {
        setState(() {
          selectedDate = pickedDate;
        });
        isLoading = false;
        String formattedDate = DateFormat.yMMMM().format(pickedDate);
        dateMM = DateFormat('MM').format(pickedDate);
        dateYYYY = DateFormat('yyyy').format(pickedDate);
        fetchData();
        // print('Selected date: $formattedDate');
        // print('Selected date: $formattedDate3');
      }
    });
  }

  Future<void> _showModalFiler(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(150.0, 20.0, 150.0, 20.0),
              child: Container(
                height: 5.0,
                width: 80.0,
                decoration: const BoxDecoration(
                  color: Color(0xffD7D7D7),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: TextWidget.titleMedium(
                      'Filter',
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.close),
                //   onPressed: () => Navigator.pop(context),
                // ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextWidget.titleMedium('Cuti'),
                  Column(
                    children: options.map((option) {
                      return RadioListTile(
                        title: TextWidget.bodyMedium(option),
                        value: option,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value as String;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.trailing,
                      );
                    }).toList(),
                  ),
                  CustomButton(
                    width: MediaQuery.of(context).size.width,
                    backgroundColor: AppColor.secondaryColor(),
                    isRounded: true,
                    borderRadius: 4,
                    text: const TextWidget.button('Apply Filter'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  fetchData() {
    currentPage = 1;
    futureAttendanceHistory = HomeController().getAttendanceHistory(
      currentPage,
      dateMM,
      dateYYYY,
    );
    futureAttendanceHistory.then((value) {
      if (value != null) {
        if (value.status == "success") {
          attendanceHistory = value.attendanceHistory;
          data = attendanceHistory!;
          setState(() {});
          _refreshController.refreshCompleted();
          isLoading = true;
          // LocalStorageService.save("statusAbsen", attendOnday!.statusAbsen);
          // print("DAttttttttt" +
          //     DateTime("HH:mm:ss").format(DateTime.parse('00:00:00')).toString());
          // DateTime _dateTime = DateFormat("HH:mm").parse("04:00");
          // print("DAttttttttt" + _dateTime.toString());

          //  isLoading = true;
          // } else {
          //   isLoading = false;
        } else {
          setState(() {});
          _refreshController.refreshCompleted();
        }
      }
    });

    return futureAttendanceHistory;
  }

  void onLoading() async {
    if (!mounted) return;
    currentPage += 1;
    await HomeController()
        .getAttendanceHistory(currentPage, dateMM, dateYYYY)
        .then((value) {
      // print(value.data);
      if (value != null) {
        if (value.status == "success") {
          attendanceHistory = value.attendanceHistory;
          data.addAll(attendanceHistory!);
          setState(() {});
          _refreshController.loadComplete();
        } else {
          //  UiUtils.errorMessage(value.data["message"], context);
          setState(() {});
          _refreshController.loadComplete();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold.withAppBar(
      title: 'Attendance',
      hideBackButton: widget.isBack,
      onBack: () {
        Modular.to.pushNamed('/home/');
      },
      child: Container(
        padding: EdgeInsets.all(defaultMargin),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 14,
                    top: 14,
                  ),
                  child: CustomButton(
                    isRounded: true,
                    borderRadius: 4,
                    backgroundColor: AppColor.secondaryColor(),
                    width: double.infinity,
                    text: TextWidget.button(
                      DateFormat.yMMMM().format(selectedDate),
                    ),
                    leading: SvgPicture.asset(
                      'assets/icons/ic_calendar.svg',
                      colorFilter: ColorFilter.mode(
                        AppColor.primaryBlueColor(),
                        BlendMode.srcIn,
                      ),
                    ),
                    onPressed: () {
                      _showMonthYearPicker(context);
                    },
                  ),
                ),
                // Divider(
                //   color: AppColor.separatorColor(),
                // ),
              ],
            ),

            // //* Summary Accordion
            // ExpansionTile(
            //   childrenPadding: const EdgeInsets.symmetric(
            //     vertical: 10,
            //     horizontal: 10,
            //   ),
            //   backgroundColor: AppColor.whiteColor(),
            //   collapsedBackgroundColor: AppColor.whiteColor(),
            //   title: const TextWidget.labelLarge('Summary'),
            //   children: [
            //     Column(
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             CustomContainer(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 12, vertical: 17),
            //               margin: const EdgeInsets.only(
            //                 right: 12,
            //               ),
            //               containerType: RoundedContainerType.outlined,
            //               radius: 4,
            //               backgroundColor:
            //                   AppColor.completedColor().withOpacity(0.1),
            //               borderColor: AppColor.completedColor(),
            //               child: const Row(
            //                 children: [
            //                   TextWidget('Normal'),
            //                   SizedBox(
            //                     width: 5,
            //                   ),
            //                   TextWidget('12'),
            //                 ],
            //               ),
            //             ),
            //             CustomContainer(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 12, vertical: 17),
            //               margin: const EdgeInsets.only(
            //                 right: 12,
            //               ),
            //               containerType: RoundedContainerType.outlined,
            //               radius: 4,
            //               backgroundColor:
            //                   AppColor.secondaryColor().withOpacity(0.1),
            //               borderColor: AppColor.secondaryColor(),
            //               child: const Row(
            //                 children: [
            //                   TextWidget('Office \nTrip'),
            //                   SizedBox(
            //                     width: 5,
            //                   ),
            //                   TextWidget('12'),
            //                 ],
            //               ),
            //             ),
            //             CustomContainer(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 12, vertical: 17),
            //               containerType: RoundedContainerType.outlined,
            //               radius: 4,
            //               backgroundColor: AppColor.redColor().withOpacity(0.1),
            //               borderColor: AppColor.redColor(),
            //               child: const Row(
            //                 children: [
            //                   TextWidget('Mangkir'),
            //                   SizedBox(
            //                     width: 5,
            //                   ),
            //                   TextWidget('12'),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             CustomContainer(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 12, vertical: 17),
            //               margin: const EdgeInsets.only(
            //                 right: 12,
            //               ),
            //               containerType: RoundedContainerType.outlined,
            //               radius: 4,
            //               backgroundColor:
            //                   AppColor.primaryBlueColor().withOpacity(0.1),
            //               borderColor: AppColor.primaryBlueColor(),
            //               child: const Row(
            //                 children: [
            //                   TextWidget('Cuti'),
            //                   SizedBox(
            //                     width: 5,
            //                   ),
            //                   TextWidget('12'),
            //                 ],
            //               ),
            //             ),
            //             CustomContainer(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 12, vertical: 17),
            //               margin: const EdgeInsets.only(
            //                 right: 12,
            //               ),
            //               containerType: RoundedContainerType.outlined,
            //               radius: 4,
            //               backgroundColor:
            //                   AppColor.primaryBlueColor().withOpacity(0.1),
            //               borderColor: AppColor.primaryBlueColor(),
            //               child: const Row(
            //                 children: [
            //                   TextWidget('Izin'),
            //                   SizedBox(
            //                     width: 5,
            //                   ),
            //                   TextWidget('12'),
            //                 ],
            //               ),
            //             ),
            //             CustomContainer(
            //               padding: const EdgeInsets.symmetric(
            //                   horizontal: 12, vertical: 17),
            //               containerType: RoundedContainerType.outlined,
            //               radius: 4,
            //               backgroundColor:
            //                   AppColor.separatorColor().withOpacity(0.1),
            //               borderColor: AppColor.separatorColor(),
            //               child: const Row(
            //                 children: [
            //                   TextWidget('Libur \nNasional'),
            //                   SizedBox(
            //                     width: 5,
            //                   ),
            //                   TextWidget('12'),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ],
            //     )
            //   ],
            // ),

            // //* Filter Category
            // SizedBox(
            //   height: 40,
            //   width: double.infinity,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       CustomTabbar(
            //         titles: filterCategory,
            //         //  const [
            //         //   'All',
            //         //   'Normal',
            //         //   'Mangkir',
            //         //   'Cuti',
            //         //   'Izin',
            //         //   'Official Trip',
            //         //   'Libur Nasional',
            //         // ],
            //         selectedIndex: selectedIndex,
            //         onTap: (index) {
            //           setState(() {
            //             selectedIndex = index;
            //             _showModalFiler(context);
            //           });
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // Container(
            //   padding: EdgeInsets.only(top: defaultMargin),
            //   child: SingleChildScrollView(
            //     scrollDirection: Axis.horizontal,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Container(
            //           margin: const EdgeInsets.only(right: 10),
            //           child: CustomButton(
            //             width: MediaQuery.of(context).size.width / 3,
            //             height: 35,
            //             isRounded: true,
            //             buttonType: ButtonType.outLined,
            //             borderRadius: 4,
            //             backgroundColor: const Color(0xffF6EBC6),
            //             borderColor: AppColor.secondaryColor(),
            //             text: TextWidget(
            //               'All',
            //               color: AppColor.blackColor(),
            //             ),
            //             rightIcon: SvgPicture.asset(
            //               'assets/icons/ic_dropdown_filter.svg',
            //               width: 16,
            //             ),
            //             onPressed: () {},
            //           ),
            //         ),
            //         Container(
            //           margin: const EdgeInsets.only(right: 10),
            //           child: CustomButton(
            //             width: MediaQuery.of(context).size.width / 3,
            //             height: 35,
            //             isRounded: true,
            //             buttonType: ButtonType.outLined,
            //             borderRadius: 4,
            //             backgroundColor: const Color(0xffFFFFFF),
            //             borderColor: AppColor.grey1Color(),
            //             text: TextWidget(
            //               'Normal',
            //               color: AppColor.blackColor(),
            //             ),
            //             rightIcon: SvgPicture.asset(
            //               'assets/icons/ic_dropdown_filter.svg',
            //               width: 16,
            //             ),
            //             onPressed: () {},
            //           ),
            //         ),
            //         Container(
            //           margin: const EdgeInsets.only(right: 10),
            //           child: CustomButton(
            //             width: MediaQuery.of(context).size.width / 3,
            //             height: 35,
            //             isRounded: true,
            //             buttonType: ButtonType.outLined,
            //             borderRadius: 4,
            //             backgroundColor: const Color(0xffFFFFFF),
            //             borderColor: AppColor.grey1Color(),
            //             text: TextWidget(
            //               'Cuti',
            //               color: AppColor.blackColor(),
            //             ),
            //             rightIcon: SvgPicture.asset(
            //               'assets/icons/ic_dropdown_filter.svg',
            //               width: 16,
            //             ),
            //             onPressed: () {},
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            !isLoading
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                        color: AppColor.secondaryColor(),
                      ),
                    ),
                  )
                : SizedBox(
                    height: MediaQuery.of(context).size.height,
                    // padding: EdgeInsets.fromLTRB(
                    //     defaultMargin, 0, defaultMargin, 100),
                    child: data.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: SvgPicture.asset(
                                  "assets/illustrations/asset_no_data.svg",
                                  width: 100,
                                ),
                              ),
                              SizedBox(
                                height: defaultMargin,
                              ),
                              const TextWidget.title(
                                'You don’t have any attendance History',
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ],
                          )
                        : SmartRefresher(
                            controller: _refreshController,
                            enablePullUp: true,
                            enablePullDown: true,
                            onRefresh: () {
                              fetchData();
                            },
                            onLoading: onLoading,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: ((context, index) {
                                  var attendanceList = data[index];

                                  return Column(
                                    children: [
                                      CustomContainer(
                                        backgroundColor: Colors.transparent,
                                        child: HistoryItem(
                                          historyItem: HistoryModel(
                                              dateTime:
                                                  attendanceList.dayDateName,
                                              status: attendanceList
                                                  .statusAttendance,
                                              inClock: attendanceList.timeIn,
                                              outClock: attendanceList.timeOut,
                                              duration: attendanceList
                                                  .totalAttendance,
                                              idHistory:
                                                  attendanceList.attendanceId,
                                              inLat: attendanceList.inLat,
                                              inLong: attendanceList.inLong),
                                        ),
                                      ),
                                    ],
                                  );
                                })),
                          ),
                  ),

            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
