// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sangati/app/themes/app_themes.dart';
import 'package:sangati/app/ui/employee/employee_detail_screen.dart';
import 'package:sangati/app/widgets/reusable_components/custom_container.dart';
import 'package:sangati/app/widgets/reusable_components/custom_scaffold.dart';
import 'package:sangati/app/widgets/reusable_components/custom_text.dart';
import 'package:sangati/app/widgets/reusable_components/custom_text_form_field.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      hideAppBar: true,
      hideBackButton: true,
      centralize: true,
      child: Padding(
        padding: EdgeInsets.all(defaultMargin),
        child: CustomContainer(
          radius: 8,
          padding: EdgeInsets.all(defaultMargin),
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Lottie.asset("assets/lottie/under_maintenance.json",
                    width: MediaQuery.of(context).size.width * 4.0,
                    fit: BoxFit.cover),
                // SvgPicture.asset(
                //     'assets/illustrations/feature_development.svg',
                //     height: MediaQuery.of(context).size.height * 0.2,
                //     fit: BoxFit.cover),
              ),
              SizedBox(
                height: defaultMargin,
              ),
              TextWidget.titleLarge(
                'Feature Access',
                color: AppColor.headingColor(),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: defaultMargin,
              ),
              TextWidget.titleMedium(
                'Hi, fitur ini sedang dalam masa pengembangan.',
                color: AppColor.headingColor(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactItem extends StatelessWidget {
  ContactItem({
    super.key,
    this.contactName,
    this.contactDepartment,
    this.contactPhoto,
  });

  String? contactName;
  String? contactDepartment;
  String? contactPhoto;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EmployeeDetailScreen(),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: defaultMargin,
        ),
        margin: EdgeInsets.only(
          bottom: defaultMargin,
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 24),
              child: SvgPicture.asset(
                'assets/icons/ic_avatar.svg',
                width: 48,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidget.titleMedium(contactName!),
                TextWidget.bodySmall(contactDepartment!),
              ],
            ),
            const Spacer(),
            SvgPicture.asset('assets/icons/ic_whatsapp.svg')
          ],
        ),
      ),
    );
  }
}

class EmployeeDataList extends StatelessWidget {
  const EmployeeDataList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(defaultMargin),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidget.titleLarge('Employee Contact'),
              CustomTextField(
                hintText: 'Search',
                prefixIcon: Icon(
                  Icons.search,
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: AppColor.separatorColor(),
          thickness: 1,
        ),

        //* List Contact
        ContactItem(
          contactName: 'Fauzan',
          contactDepartment: 'IT Dev',
        ),
        ContactItem(
          contactName: 'Zidan',
          contactDepartment: 'HRD',
        )
      ],
    );
  }
}
