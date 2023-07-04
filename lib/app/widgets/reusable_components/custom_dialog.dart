part of 'reusable_components.dart';

class CustomDialog extends StatefulWidget {
  const CustomDialog({
    Key? key,
    this.title,
    required this.message,
  }) : super(key: key);
  final String? title;
  final String message;
  @override
  State<CustomDialog> createState() => _CustomDialogScreenState();
}

class _CustomDialogScreenState extends State<CustomDialog> {
  String? bodyMessageff;
  @override
  void initState() {
    super.initState();
    bodyMessageff = widget.message;
    // _imageFile = widget.picture;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: TextWidget.titleMedium(
        widget.title.toString(),
        textAlign: TextAlign.center,
        color: AppColor.primaryBlueColor(),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextWidget.bodyMedium(
            widget.message.toString(),
            textAlign: TextAlign.center,
            color: AppColor.bodyColor(),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: <Widget>[
          //     FlatButton(
          //         onPressed: () {
          //           Navigator.of(context).pop();
          //         },
          //         child: Text("Cancel")),
          //     FlatButton(
          //         onPressed: () {
          //           Navigator.pop(context, _controller.text);
          //         },
          //         color: Colors.blue,
          //         child: Text(
          //           "Save",
          //           style: TextStyle(color: Colors.white),
          //         )),
          //   ],
          // ),
          Container(
            margin: const EdgeInsets.only(
              top: 44,
            ),
            child: CustomButton(
              isRounded: true,
              borderRadius: 4,
              width: MediaQuery.of(context).size.width,
              backgroundColor: AppColor.secondaryColor(),
              onPressed: () {
                //  Navigator.of(context,"1").pop();
                Navigator.pop(context, "ok");
              },
              text: const TextWidget.button('OK'),
            ),
          )
        ],
      ),
    );
  }
}
