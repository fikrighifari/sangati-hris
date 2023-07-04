import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/models/history_detail_model.dart';
import 'package:sangati/app/models/history_model.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/widgets/constant/enums/rounded_container_type.dart';
import 'package:sangati/app/widgets/reusable_components/custom_appbar.dart';
import 'package:sangati/app/widgets/reusable_components/custom_button.dart';
import 'package:sangati/app/widgets/reusable_components/custom_container.dart';
import 'package:sangati/app/widgets/reusable_components/custom_text.dart';
import 'package:sangati/app/widgets/reusable_components/custom_text_form_field.dart';

class DetailHistoryScreen extends StatefulWidget {
  const DetailHistoryScreen({
    Key? key,
    required this.historyItem,
  }) : super(key: key);
  final HistoryModel historyItem;
  @override
  State<DetailHistoryScreen> createState() => _DetailHistoryScreenState();
}

class _DetailHistoryScreenState extends State<DetailHistoryScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  DataHistory? attendanceHistoryData;
  late Future<HistoryDetailModel?> futureHistoryDetail;
  late String? dateAttendance = '';
  late String? monthAttendance = '';
  late String? yearAttendance = '';

  late String? clockInImage = '';
  late String? clockInTime = '';
  late String? clockOutTime = '';
  late String? durationTime = '';

  late LatLng absentLocation;

  GoogleMapController? mapController;
  CameraPosition? cameraPosition;

  @override
  void initState() {
    fetchData(widget.historyItem.idHistory);

    var latAttendance = double.parse(widget.historyItem.inLat.toString());
    var longAttendance = double.parse(widget.historyItem.inLong.toString());

    absentLocation = LatLng(
      latAttendance,
      longAttendance,
    );

    super.initState();
  }

  fetchData(int? idHistoryData) {
    futureHistoryDetail = HomeController().getDetailHistory(idHistoryData);

    futureHistoryDetail.then((value) {
      if (value != null) {
        attendanceHistoryData = value.dataHistory!;

        var dateLastUpdate = DateTime.parse(attendanceHistoryData!.dayDate!);

        dateAttendance = DateFormat("d").format(dateLastUpdate);
        monthAttendance = DateFormat(
          "MMMM",
        ).format(dateLastUpdate);
        yearAttendance = DateFormat(
          "yyyy",
        ).format(dateLastUpdate);

        clockInTime = value.dataHistory!.timeIn;
        clockOutTime = value.dataHistory!.timeOut;
        clockInImage = value.dataHistory!.fotoIn;
        durationTime = value.dataHistory!.totalAttendance;
      }
    });

    return futureHistoryDetail;
  }

  Widget googleMapUI() {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      // height: MediaQuery.of(context).size.height / 1.8,
      height: MediaQuery.of(context).size.height / 3,
      width: width,
      child: Stack(
        children: <Widget>[
          Stack(children: [
            GoogleMap(
              //Map widget from google_maps_flutter package
              zoomGesturesEnabled: false,
              myLocationEnabled: false,
              zoomControlsEnabled: false,
              //enable Zoom in, out on map
              initialCameraPosition: CameraPosition(
                //innital position in map
                target: absentLocation, //initial position
                zoom: 14.0, //initial zoom level
              ),
              mapType: MapType.normal, //map type
              onMapCreated: (controller) {
                //method called when map is created
                setState(() {
                  mapController = controller;
                });
              },
              onCameraMove: (CameraPosition cameraPositiona) {
                cameraPosition = cameraPositiona; //when map is dragging
              },
              onCameraIdle: () async {
                //when map drag stops
                // List<Placemark> placemarks = await placemarkFromCoordinates(
                //     cameraPosition!.target.latitude,
                //     cameraPosition!.target.longitude);
                // setState(() {
                //   //get place name from lat and lang
                // location = placemarks.first.street.toString() +
                //     ', ' +
                //     placemarks.first.subAdministrativeArea.toString() +
                //     ',' +
                //     placemarks.first.locality.toString() +
                //     '-' +
                //     placemarks.first.postalCode.toString() +
                //     ',' +
                //     placemarks.first.administrativeArea.toString();
                // });
              },
            ),
            Center(
              //picker image on google map
              child: Image.asset(
                "assets/icons/ic_picker.png",
                width: 100,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Future<void> refreshlist() async {
    setState(() {
      _refreshIndicatorKey.currentState!.show();
      //  print("Masuk sini Home ffff ");
      fetchData(widget.historyItem.idHistory);
    });
    // _checkJaringan();
  }

  @override
  Widget build(BuildContext context) {
    // String formattedTime = formatTime(formattedClockInTime.toString());

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          backButton: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColor.primaryBlueColor(),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: 'History Detail',
        ),
        body: FutureBuilder<HistoryDetailModel?>(
          future: futureHistoryDetail,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                //  print("Masuk sini no");
                return const Text('Press button to start.');
              case ConnectionState.active:
                // print("Masuk sini kah");
                return const Text('Press button to start.');
              case ConnectionState.waiting:
                // print("Masuk sini kah 2");
                // return LoadingWidgetHome();
                return const Center(
                  child: CircularProgressIndicator(),
                );

              case ConnectionState.done:
                // print("Masuk sini kah 2");
                //return Text('Press button to start.');
                return RefreshIndicator(
                  color: AppColor.secondaryColor(),
                  key: _refreshIndicatorKey,
                  onRefresh: refreshlist,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Expanded(
                        //   child: SingleChildScrollView(
                        //     child:
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: defaultMargin,
                              vertical: defaultMargin),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Text(
                              //   'Formatted Time: $formattedTime',
                              //   style: TextStyle(fontSize: 20),
                              // ),
                              CustomContainer(
                                radius: 4,
                                width: MediaQuery.of(context).size.width,
                                backgroundColor:
                                    attendanceHistoryData!.statusAttendance ==
                                            'Normal'
                                        ? AppColor.completedColor()
                                        : AppColor.redColor(),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(defaultMargin),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(4),
                                            bottomLeft: Radius.circular(4)),
                                        color: AppColor.primaryBlueColor(),
                                      ),
                                      child: Row(
                                        children: [
                                          TextWidget.bodyLarge(
                                            '$dateAttendance',
                                            color: AppColor.whiteColor(),
                                            fontWeight: boldWeight,
                                            fontSize: 36,
                                          ),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            children: [
                                              TextWidget.labelLarge(
                                                '$monthAttendance',
                                                color: AppColor.whiteColor(),
                                              ),
                                              TextWidget.labelLarge(
                                                '$yearAttendance',
                                                color: AppColor.whiteColor(),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(defaultMargin),
                                      child: TextWidget.labelLarge(
                                        attendanceHistoryData!
                                            .statusAttendance!,
                                        fontSize: 24,
                                        color: AppColor.whiteColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Text(
                              //   'Formatted Time: $formattedTime',
                              //   style: TextStyle(fontSize: 20),
                              // ),

                              //* Clock In&Out Section
                              CustomContainer(
                                margin: EdgeInsets.only(top: defaultMargin),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 57,
                                  vertical: defaultMargin,
                                ),
                                containerType: RoundedContainerType.noOutline,
                                radius: 4,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
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
                                              width: 4,
                                            ),
                                            const TextWidget.titleMedium(
                                                'Clock-In'),
                                          ],
                                        ),
                                        clockInTime == ''
                                            ? TextWidget.headlineLarge(
                                                '-',
                                                color:
                                                    AppColor.primaryBlueColor(),
                                              )
                                            : TextWidget.headlineLarge(
                                                clockInTime.toString(),
                                                color:
                                                    AppColor.primaryBlueColor(),
                                              ),
                                        // TextWidget.bodyMedium(
                                        //   'WIB',
                                        //   color:
                                        //       AppColor.headingColor(),
                                        // )
                                      ],
                                    ),
                                    Column(
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
                                              width: 4,
                                            ),
                                            const TextWidget.titleMedium(
                                                'Clock-Out'),
                                          ],
                                        ),
                                        clockOutTime == ''
                                            ? TextWidget.headlineLarge(
                                                '-',
                                                color:
                                                    AppColor.primaryBlueColor(),
                                              )
                                            : TextWidget.headlineLarge(
                                                clockOutTime.toString(),
                                                color:
                                                    AppColor.primaryBlueColor(),
                                              ),
                                        // TextWidget.bodyMedium(
                                        //   'WIB',
                                        //   color:
                                        //       AppColor.headingColor(),
                                        // )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              //* Duration & Photo Section
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomContainer(
                                    height: 200,
                                    // width: 174,
                                    margin: EdgeInsets.only(
                                      top: defaultMargin,
                                      right: defaultMargin,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 42,
                                      vertical: defaultMargin,
                                    ),
                                    containerType:
                                        RoundedContainerType.noOutline,
                                    radius: 4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/ic_clipboard.svg',
                                              colorFilter: ColorFilter.mode(
                                                AppColor.primaryBlueColor(),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            const TextWidget.titleMedium(
                                                'Duration'),
                                          ],
                                        ),
                                        TextWidget.headlineLarge(
                                          durationTime.toString(),
                                          color: AppColor.completedColor(),
                                        ),
                                        TextWidget.bodyMedium(
                                          'Hour(s) Minute(s)',
                                          color: AppColor.headingColor(),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                            top: defaultMargin,
                                            // right: defaultMargin,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: attendanceHistoryData!
                                                    .fotoIn!.isNotEmpty
                                                ? Container(
                                                    width: 200,
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                          clockInImage!,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SvgPicture.asset(
                                                    'assets/images/default_photo.svg',
                                                    width: 200,
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Container(
                                margin: EdgeInsets.only(top: defaultMargin),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:

                                      // Image.asset(
                                      //   'assets/images/dummy_map.png',
                                      // ),
                                      googleMapUI(),
                                ),
                              ),
                              const CustomTextField(
                                readOnly: true,
                                hintText:
                                    'You have not written any additional note',
                              ),

                              // Add more content widgets as needed
                            ],
                          ),
                        ),
                        //   ),
                        // ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   color: AppColor.redColor(),
                        //   child: CustomContainer(
                        //     padding: EdgeInsets.symmetric(
                        //       horizontal: defaultMargin,
                        //       vertical: defaultMargin,
                        //     ),
                        //     child: CustomButton(
                        //       isRounded: true,
                        //       borderRadius: 4,
                        //       backgroundColor: AppColor.secondaryColor(),
                        //       width: double.infinity,
                        //       text: TextWidget.labelLarge(
                        //         'Create Request',
                        //         color: AppColor.primaryBlueColor(),
                        //         fontWeight: boldWeight,
                        //       ),
                        //       leading: SvgPicture.asset(
                        //         'assets/icons/ic_text_snippet.svg',
                        //         colorFilter: ColorFilter.mode(
                        //           AppColor.primaryBlueColor(),
                        //           BlendMode.srcIn,
                        //         ),
                        //       ),
                        //       onPressed: () {
                        //         // Navigator.push(
                        //         //   context,
                        //         //   MaterialPageRoute(
                        //         //     builder: (context) =>
                        //         //         const RequestChangeScreen(),
                        //         //   ),
                        //         // );
                        //       },
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

class OldDetailHistoryScreen extends StatelessWidget {
  const OldDetailHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColor.primaryBlueColor(),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: 'History Detail',
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: defaultMargin, vertical: defaultMargin),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Your content here
                      //* Status Section
                      CustomContainer(
                        radius: 4,
                        width: MediaQuery.of(context).size.width,
                        backgroundColor: AppColor.completedColor(),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(defaultMargin),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    bottomLeft: Radius.circular(4)),
                                color: AppColor.primaryBlueColor(),
                              ),
                              child: Row(
                                children: [
                                  TextWidget.bodyLarge(
                                    '7',
                                    color: AppColor.whiteColor(),
                                    fontWeight: boldWeight,
                                    fontSize: 36,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    children: [
                                      TextWidget.labelLarge(
                                        'Januari\n2023',
                                        color: AppColor.whiteColor(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(defaultMargin),
                              child: TextWidget.labelLarge(
                                'Normal',
                                fontSize: 24,
                                color: AppColor.whiteColor(),
                              ),
                            ),
                          ],
                        ),
                      ),

                      //* Clock In&Out Section
                      CustomContainer(
                        margin: EdgeInsets.only(top: defaultMargin),
                        padding: EdgeInsets.symmetric(
                          horizontal: 57,
                          vertical: defaultMargin,
                        ),
                        containerType: RoundedContainerType.noOutline,
                        radius: 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
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
                                      width: 4,
                                    ),
                                    const TextWidget.titleMedium('Clock-In'),
                                  ],
                                ),
                                TextWidget.headlineLarge(
                                  '07.45',
                                  color: AppColor.primaryBlueColor(),
                                ),
                                TextWidget.bodyMedium(
                                  'WIB',
                                  color: AppColor.headingColor(),
                                )
                              ],
                            ),
                            Column(
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
                                      width: 4,
                                    ),
                                    const TextWidget.titleMedium('Clock-Out'),
                                  ],
                                ),
                                TextWidget.headlineLarge(
                                  '17.00',
                                  color: AppColor.primaryBlueColor(),
                                ),
                                TextWidget.bodyMedium(
                                  'WIB',
                                  color: AppColor.headingColor(),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      //* Duration & Photo Section
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomContainer(
                              height: 174,
                              // width: 174,
                              margin: EdgeInsets.only(
                                top: defaultMargin,
                                right: defaultMargin,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 42,
                                vertical: defaultMargin,
                              ),
                              containerType: RoundedContainerType.noOutline,
                              radius: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/ic_clipboard.svg',
                                        colorFilter: ColorFilter.mode(
                                          AppColor.primaryBlueColor(),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const TextWidget.titleMedium('Duration'),
                                    ],
                                  ),
                                  TextWidget.headlineLarge(
                                    '8',
                                    color: AppColor.completedColor(),
                                  ),
                                  TextWidget.bodyMedium(
                                    'Hour(s)',
                                    color: AppColor.headingColor(),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: defaultMargin,
                                // right: defaultMargin,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  'assets/images/image_dummy.png',
                                  width: 174,
                                  height: 174,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      const Text(
                        'this section is an images of a dummy map 😃',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: defaultMargin),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/dummy_map.png',
                          ),
                        ),
                      ),
                      const CustomTextField(
                        hintText: 'You have not written any additional note',
                      ),

                      // Add more content widgets as needed
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              color: AppColor.redColor(),
              child: CustomContainer(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultMargin,
                  vertical: defaultMargin,
                ),
                child: CustomButton(
                  isRounded: true,
                  borderRadius: 4,
                  backgroundColor: AppColor.secondaryColor(),
                  width: double.infinity,
                  text: TextWidget.labelLarge(
                    'Create Request',
                    color: AppColor.primaryBlueColor(),
                    fontWeight: boldWeight,
                  ),
                  leading: SvgPicture.asset(
                    'assets/icons/ic_text_snippet.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.primaryBlueColor(),
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const RequestChangeScreen(),
                    //   ),
                    // );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
