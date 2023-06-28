import 'package:flutter_modular/flutter_modular.dart';
import 'package:sangati/app/config/auth_routes.dart';

class AuthModule extends Module {
  @override
  List<ModularRoute> get routes => authRoutes;
}
