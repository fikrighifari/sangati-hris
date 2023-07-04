import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sangati/app/models/history_model.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/ui/absen/processing_screen.dart';
import 'package:sangati/app/widgets/cards/history_item.dart';
import 'package:sangati/app/widgets/constant/enums/rounded_container_type.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';

class RequestChangeScreen extends StatefulWidget {
  const RequestChangeScreen({super.key});

  @override
  State<RequestChangeScreen> createState() => _RequestChangeScreenState();
}

class _RequestChangeScreenState extends State<RequestChangeScreen> {
  final List<String> items = [
    'Waktu Clock-In tidak sesuai',
    'Option 2',
    'Option 3'
  ];
  String? selectedOption;
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
        title: 'Request Change',
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HistoryItem(
                              historyItem: HistoryModel(
                                  dateTime: 'Senin, 18 Januari 2023',
                                  status: 'Mangkir',
                                  inClock: '07.30',
                                  outClock: '17.00',
                                  duration: '8h 9m'),
                            ),
                            const TextWidget.titleMedium('Subject'),
                            CustomContainer(
                              containerType: RoundedContainerType.noOutline,
                              radius: 4,
                              backgroundColor: AppColor.whiteColor(),
                              margin: const EdgeInsets.only(top: 8),
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultMargin,
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: AppColor
                                      .whiteColor(), //Change the bottom color here
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: selectedOption,
                                    hint: const TextWidget.bodyLarge(
                                        'Select an option'),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedOption = newValue;
                                      });
                                    },
                                    items: items.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: TextWidget.bodyLarge(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: defaultMargin,
                            ),
                            const TextWidget.titleMedium('Note'),
                            CustomContainer(
                              containerType: RoundedContainerType.noOutline,
                              backgroundColor: AppColor.whiteColor(),
                              radius: 6,
                              margin: const EdgeInsets.only(top: 6),
                              // height: 200,
                              child: TextField(
                                  cursorColor: AppColor.primaryBlueColor(),
                                  maxLines: 200 ~/ 20, // <--- maxLines
                                  decoration: InputDecoration(
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
                                  )),
                            ),
                          ],
                        ),
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
                    'Submit Request',
                    color: AppColor.primaryBlueColor(),
                    fontWeight: boldWeight,
                  ),
                  leading: SvgPicture.asset(
                    'assets/icons/ic_clock_plus.svg',
                    colorFilter: ColorFilter.mode(
                      AppColor.primaryBlueColor(),
                      BlendMode.srcIn,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProcessingScreen(),
                      ),
                    );
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
