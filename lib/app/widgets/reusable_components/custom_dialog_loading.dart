part of 'reusable_components.dart';

class CustomDialogLoading extends StatefulWidget {
  const CustomDialogLoading({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDialogLoading> createState() => _CustomDialogLoadingScreenState();
}

class _CustomDialogLoadingScreenState extends State<CustomDialogLoading> {
  String? bodyMessageff;
  @override
  void initState() {
    super.initState();
    // _imageFile = widget.picture;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Container(
          padding: const EdgeInsets.only(bottom: 20),
          child: Lottie.asset("assets/lottie/sand_timer.json",
              width: MediaQuery.of(context).size.width * 2.0),
        ),
      ),
    );
  }
}
