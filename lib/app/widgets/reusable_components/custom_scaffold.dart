part of 'reusable_components.dart';

class CustomScaffold extends StatelessWidget {
  final Widget? child;
  final dynamic title;
  final bool centralize;
  final bool hideAppBar;
  final bool hideBackButton;
  final bool isScrolling;
  final bool centerTitle;
  final double elevation;
  final Widget? bottomNavigationBar;
  final List<Widget>? action;
  final Color backgroundColor;
  final GlobalKey? appbarKey;
  final bool isToHome;
  final Function()? onBack;

  const CustomScaffold({
    Key? key,
    this.appbarKey,
    this.child,
    this.title,
    this.elevation = 0,
    this.centerTitle = false,
    this.centralize = false,
    this.hideAppBar = false,
    this.hideBackButton = false,
    this.isScrolling = true,
    this.action,
    this.isToHome = false,
    this.backgroundColor = const Color(0xffF3F5F7),
    this.bottomNavigationBar,
    this.onBack,
  }) : super(key: key);

  const CustomScaffold.withAppBar({
    Key? key,
    Widget? child,
    String? title,
    Function()? onBack,
    bool isScrolling = true,
    bool centerTitle = true,
    bool hideBackButton = false,
    double elevation = 1,
    Widget? bottomNavigationBar,
    bool isToHome = false,
    List<Widget>? action,
    Color backgroundColor = const Color(0xffF3F5F7),
  }) : this(
          key: key,
          child: child,
          title: title,
          onBack: onBack,
          isScrolling: isScrolling,
          centerTitle: centerTitle,
          hideBackButton: hideBackButton,
          elevation: 1,
          isToHome: isToHome,
          bottomNavigationBar: bottomNavigationBar,
          action: action,
          backgroundColor: backgroundColor,
        );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        appBar: hideAppBar
            ? null
            : AppBar(
                key: appbarKey,
                backgroundColor: const Color(0xffFFFFFF),
                leading: hideBackButton
                    ? null
                    : IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColor.primaryBlueColor(),
                        ),
                        onPressed: () {
                          if (isToHome) {
                            // Modular.to.popUntil(ModalRoute.withName("/home/"));
                            // Navigator.pushNamedAndRemoveUntil(
                            //     context, '/home-screen', (route) => false);
                            Navigator.popUntil(context, (route) => false);
                          } else {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                elevation: elevation,
                actions: action,
                centerTitle: centerTitle,
                automaticallyImplyLeading: false,
                // leadingWidth: 15,
                title: title == null
                    ? null
                    : title.runtimeType.toString() == "String"
                        ? TextWidget.appBarTitle(
                            title!,
                            color: AppColor.primaryBlueColor(),
                            fontWeight: FontWeight.bold,
                          )
                        : title,
              ),
        body: SafeArea(
          child: centralize
              ? !isScrolling
                  ? child!
                  : Center(
                      child: SingleChildScrollView(
                        child: child!,
                      ),
                    )
              : !isScrolling
                  ? child!
                  : SingleChildScrollView(
                      child: child,
                    ),
        ));
  }
}
