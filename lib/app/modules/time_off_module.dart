import 'package:flutter_modular/flutter_modular.dart';
import 'package:sangati/app/config/time_off_routes.dart';

class TimeOffModule extends Module {
  @override
  List<ModularRoute> get routes => timeOffRoutes;
}
