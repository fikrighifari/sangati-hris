import 'package:flutter_modular/flutter_modular.dart';
import 'package:sangati/app/ui/time_off/time_off_screen.dart';

List<ModularRoute> timeOffRoutes = [
  ChildRoute('/', child: (context, args) => const TimeOffScreen()),
];
