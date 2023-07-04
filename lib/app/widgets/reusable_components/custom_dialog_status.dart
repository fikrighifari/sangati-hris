part of 'reusable_components.dart';

class CustomDialogStatus extends StatefulWidget {
  const CustomDialogStatus({
    Key? key,
    this.title,
    this.subTittle,
    this.messageData,
  }) : super(key: key);
  final String? title;
  final String? subTittle;
  final String? messageData;
  @override
  State<CustomDialogStatus> createState() => _CustomDialogStatusScreenState();
}

class _CustomDialogStatusScreenState extends State<CustomDialogStatus> {
  String? bodyTittle;
  String? bodySubTittle;
  String? bodyMessage;
  @override
  void initState() {
    super.initState();
    bodyTittle = widget.title;
    bodyMessage = widget.messageData;
    bodySubTittle = widget.subTittle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center content horizontally
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultMargin,
                    vertical: defaultMargin,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //* Status Section
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Image.asset(
                          'assets/illustrations/clock_in.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: defaultMargin,
                      ),
                      TextWidget.titleLarge(
                        bodyTittle!,
                        color: AppColor.headingColor(),
                      ),
                      SizedBox(
                        height: defaultMargin,
                      ),
                      TextWidget.bodyMedium(
                        bodySubTittle!,
                        color: AppColor.bodyColor(),
                      ),
                      SizedBox(
                        height: defaultMargin,
                      ),
                      TextWidget.titleMedium(
                        bodyMessage!,
                        color: AppColor.headingColor(),
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
                    'OK',
                    color: AppColor.primaryBlueColor(),
                    fontWeight: boldWeight,
                  ),
                  // leading: SvgPicture.asset(
                  //   'assets/icons/ic_text_snippet.svg',
                  //   colorFilter: ColorFilter.mode(
                  //     AppColor.primaryBlueColor(),
                  //     BlendMode.srcIn,
                  //   ),
                  // ),
                  onPressed: () {
                    Navigator.pop(context, "ok");
                    //Logical process here
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
