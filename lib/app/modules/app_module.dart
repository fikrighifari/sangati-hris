// ignore_for_file: unused_import

import 'package:flutter_modular/flutter_modular.dart';
import 'package:sangati/app/config/app_routes.dart';
import 'package:sangati/app/ui/splash_screen.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => appRoutes;
  // @override
  // final List<ModularRoute> routes = [
  //   ChildRoute('/', child: (context, args) => const SplashScreen()),
  // ];
}
