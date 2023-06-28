import 'package:flutter_modular/flutter_modular.dart';
import 'package:sangati/app/modules/attendance_module.dart';
import 'package:sangati/app/modules/auth_module.dart';
import 'package:sangati/app/modules/dashboard_module.dart';
import 'package:sangati/app/ui/splash_screen.dart';

List<ModularRoute> appRoutes = [
  ChildRoute('/', child: (context, args) => const SplashScreen()),
  ModuleRoute('/home/', module: DashboardModule()),
  ModuleRoute('/auth/', module: AuthModule()),
  ModuleRoute('/attendance/', module: AttendanceModule()),
];
