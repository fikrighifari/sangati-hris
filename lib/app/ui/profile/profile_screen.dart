// ignore_for_file: sort_child_properties_last, prefer_typing_uninitialized_variables, unused_local_variable, avoid_print

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sangati/app/controller/home_controller.dart';
import 'package:sangati/app/database/databse_helper.dart';
import 'package:sangati/app/models/profile_model.dart';
import 'package:sangati/app/service/local_storage_service.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/ui/dashboard/verifikasi_page.dart';
import 'package:sangati/app/widgets/reusable_components/reusable_components.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String? nameProfile = '';
  late String? deptProfile = '';
  late int? phoneNumberProfile = 0;
  late String? emailProfile = '';
  late String? avatarProfile = '';
  late int? statusVerified = 0;

  late Future<ProfileModels?> futureProfile;
  late DataProfile? dataProfile;
  DatabaseHelper? _dbHelper;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    fetchData();
  }

  void _showFeatureDialog() {
    showDialog(
      builder: (_) => const CustomDialog(
          title: 'Feature Access',
          message: 'Hi, fitur ini sedang dalam masa pengembangan.'),
      context: context,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      builder: (_) => AlertDialog(
        title: TextWidget.titleMedium(
          'Apakah Anda yakin ingin logout?',
          textAlign: TextAlign.center,
          color: AppColor.primaryBlueColor(),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  child: const Text('Batal'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: const BorderSide(color: Colors.green))),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: const BorderSide(color: Colors.red))),
                  onPressed: () {
                    LocalStorageService.remove("headerToken");

                    LocalStorageService.remove("statusVerif");
                    LocalStorageService.remove("statusAbsen");

                    Modular.to.popAndPushNamed('/auth/');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      context: context,
    );
  }

  fetchData() async {
    futureProfile = HomeController().getProfileAll();
    futureProfile.then((value) async {
      if (value != null) {
        if (value.status == "success") {
          dataProfile = value.dataProfile;
          nameProfile = value.dataProfile?.fullName;
          deptProfile = value.dataProfile?.deptName;
          phoneNumberProfile = value.dataProfile?.phone;
          emailProfile = value.dataProfile?.email;
          avatarProfile = value.dataProfile?.fotoUrl;
          statusVerified = value.dataProfile?.statusVerifId;

          await _dbHelper!.deleteTableUser();
          await _dbHelper!.insertProfileUser(dataProfile!);

          LocalStorageService.save(
              "statusVerif", value.dataProfile?.statusVerifId);
        } else {
          _dbHelper!.gelUserData().then((result) async {
            setState(() {
              nameProfile = result.fullName;
              deptProfile = result.deptName;
              phoneNumberProfile = result.phone;
              emailProfile = result.email;
              avatarProfile = result.fotoUrl;
              statusVerified = result.statusVerifId;
            });
          });
        }
      } else {
        _dbHelper!.gelUserData().then((result) async {
          setState(() {
            nameProfile = result.fullName;
            deptProfile = result.deptName;
            phoneNumberProfile = result.phone;
            emailProfile = result.email;
            avatarProfile = result.fotoUrl;
            statusVerified = result.statusVerifId;
          });
        });
      }
    });
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _refreshIndicatorKey.currentState!.show();
      fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    // authServices = Provider.of<AuthServices>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        rightWidget: GestureDetector(
            onTap: () {
              // _showLogoutDialog();
              Modular.to.pushNamed('/profile/setting_screen');
            },
            child: Icon(
              Icons.settings,
              weight: 50,
              color: AppColor.grey1Color(),
            )
            // TextWidget.titleMedium(
            //   'Log-out',
            //   color: AppColor.redColor(),
            // ),
            ),
      ),
      body: FutureBuilder<ProfileModels?>(
        future: futureProfile,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return const Text('Press button to start');
            case ConnectionState.active:
              return const Text('Press button to start.');
            case ConnectionState.waiting:
              return const ShimmerLoading();
            case ConnectionState.done:
              return RefreshIndicator(
                color: AppColor.secondaryColor(),
                key: _refreshIndicatorKey,
                onRefresh: _refreshProfile,
                child: WillPopScope(
                  onWillPop: () async {
                    // Disable the back button functionality
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          CustomContainer(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultMargin,
                              vertical: defaultMargin,
                            ),
                            child: Column(
                              children: [
                                //* Header
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 24),
                                      child: SizedBox(
                                        height: 96,
                                        width: 96,
                                        child: Stack(
                                          fit: StackFit.expand,
                                          //  overflow: Overflow.visible,
                                          children: [
                                            avatarProfile!.isNotEmpty
                                                ? CircleAvatar(
                                                    backgroundColor:
                                                        const Color(0xffF9F9F9),
                                                    backgroundImage:
                                                        NetworkImage(
                                                            avatarProfile!))
                                                : Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 24),
                                                    child: SvgPicture.asset(
                                                      'assets/icons/ic_avatar.svg',
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextWidget.titleMedium(
                                          nameProfile ?? 'Profile Name',
                                          color: AppColor.primaryBlueColor(),
                                        ),
                                        TextWidget.bodyMedium(deptProfile ??
                                            'Profile Department'),
                                        Row(
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                  right: 6,
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/icons/ic_phone.svg',
                                                  colorFilter: ColorFilter.mode(
                                                    AppColor.bodyColor(),
                                                    BlendMode.srcIn,
                                                  ),
                                                )),
                                            TextWidget.bodySmall(
                                              phoneNumberProfile.toString(),
                                              color: AppColor.bodyColor(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                  right: 6,
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/icons/ic_mail.svg',
                                                  colorFilter: ColorFilter.mode(
                                                    AppColor.bodyColor(),
                                                    BlendMode.srcIn,
                                                  ),
                                                )),
                                            TextWidget.bodySmall(
                                              emailProfile ??
                                                  'hris.app@sangati.co',
                                              color: AppColor.bodyColor(),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  child: Divider(
                                    color: AppColor.separatorColor(),
                                  ),
                                ),
                                statusVerified == 0
                                    ? Container()
                                    : statusVerified == 1
                                        ? Container()
                                        : Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  right: 8,
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/icons/ic_text_snippet.svg',
                                                  colorFilter: ColorFilter.mode(
                                                    AppColor.headingColor(),
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                              ),
                                              TextWidget.titleMedium(
                                                'My Request',
                                                color: AppColor.headingColor(),
                                              ),
                                            ],
                                          ),
                              ],
                            ),
                          ),

                          //* Profile Body Content
                          statusVerified == 0
                              ? CustomContainer(
                                  shadow: [
                                    BoxShadow(
                                        offset: const Offset(4, 4),
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.06))
                                  ],
                                  width: double.infinity,
                                  radius: 8,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  child: Column(
                                    children: [
                                      TextWidget.titleMedium(
                                        'Verification',
                                        color: AppColor.primaryBlueColor(),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      const TextWidget.bodyMedium(
                                          'Lakukan verifikasi untuk mengaktifkan akunmu dan akses ke semua fitur'),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          top: 16,
                                        ),
                                        child: CustomButton(
                                          isRounded: true,
                                          borderRadius: 4,
                                          leading: SvgPicture.asset(
                                            'assets/icons/ic_clock_plus.svg',
                                            colorFilter: ColorFilter.mode(
                                              AppColor.primaryBlueColor(),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          backgroundColor:
                                              AppColor.secondaryColor(),
                                          onPressed: () {
                                            availableCameras().then((value) =>
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            VerifikasiSreen(
                                                              cameras: value,
                                                            ))));
                                          },
                                          text: const TextWidget.button('OK'),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : statusVerified == 1
                                  ? CustomContainer(
                                      shadow: [
                                        BoxShadow(
                                            offset: const Offset(4, 4),
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.06))
                                      ],
                                      width: double.infinity,
                                      radius: 8,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: defaultMargin,
                                        vertical: defaultMargin,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                      child: Column(
                                        children: [
                                          TextWidget.titleMedium(
                                            'Verification Submitted',
                                            color: AppColor.primaryBlueColor(),
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          const TextWidget.bodyMedium(
                                              'Verifikasi telah dilakukan dan akan diproses oleh staff'),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        ProfileContentMenu(
                                          menuTitle: 'Presence Change Request',
                                          menuIcon: 'ic_clipboard',
                                          onTap: () {
                                            _showFeatureDialog();
                                          },
                                        ),
                                        ProfileContentMenu(
                                          menuTitle: 'Time-off Request',
                                          menuIcon: 'ic_work_off',
                                          onTap: () {
                                            _showFeatureDialog();
                                          },
                                        ),
                                        ProfileContentMenu(
                                          menuTitle: 'Office Trip Request',
                                          menuIcon: 'ic_office_trip',
                                          onTap: () {
                                            _showFeatureDialog();
                                          },
                                        ),
                                      ],
                                    ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomContainer(
          padding: EdgeInsets.all(defaultMargin),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 24),
                    child: SizedBox(
                      height: 96,
                      width: 96,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CustomContainer(
                            radius: 10,
                            height: 15,
                            width: 200,
                            backgroundColor: AppColor.whiteColor(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CustomContainer(
                            radius: 10,
                            height: 15,
                            width: 120,
                            backgroundColor: AppColor.whiteColor(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CustomContainer(
                            radius: 10,
                            height: 16,
                            width: 100,
                            backgroundColor: AppColor.whiteColor(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CustomContainer(
                            radius: 10,
                            height: 16,
                            width: 120,
                            backgroundColor: AppColor.whiteColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: Divider(
                  color: AppColor.separatorColor(),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: CustomContainer(
                        radius: 5,
                        height: 35,
                        width: 35,
                        backgroundColor: AppColor.whiteColor(),
                      ),
                    ),
                  ),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 10,
                      height: 16,
                      width: 120,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: CustomContainer(
            padding: EdgeInsets.symmetric(
              horizontal: defaultMargin,
              vertical: defaultMargin,
            ),
            margin: EdgeInsets.only(top: defaultMargin),
            width: double.infinity,
            // backgroundColor: AppColor.redColor(),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: CustomContainer(
                      radius: 5,
                      height: 35,
                      width: 35,
                      backgroundColor: AppColor.whiteColor(),
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: CustomContainer(
                    radius: 10,
                    height: 16,
                    width: 120,
                    backgroundColor: AppColor.whiteColor(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ProfileContentMenu extends StatelessWidget {
  final String? menuTitle;
  final String? menuIcon;
  final Function()? onTap;
  const ProfileContentMenu({
    super.key,
    this.menuTitle,
    this.menuIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomContainer(
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
          vertical: defaultMargin,
        ),
        radius: 8,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    height: 32,
                    width: 32,
                    margin: const EdgeInsets.only(
                      right: 12,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primaryBlueColor(),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/$menuIcon.svg',
                      colorFilter: ColorFilter.mode(
                        AppColor.whiteColor(),
                        BlendMode.srcIn,
                      ),
                    )),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 0.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextWidget.titleSmall(
                                menuTitle.toString(),
                                color: AppColor.primaryBlueColor(),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_arrow_next.svg',
                      colorFilter: ColorFilter.mode(
                        AppColor.separatorColor(),
                        BlendMode.srcIn,
                      ),
                    )
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
