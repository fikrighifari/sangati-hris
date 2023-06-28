import 'package:flutter_modular/flutter_modular.dart';
import 'package:sangati/app/config/attendance_routes.dart';

class AttendanceModule extends Module {
  @override
  List<ModularRoute> get routes => attendanceRoutes;
}
