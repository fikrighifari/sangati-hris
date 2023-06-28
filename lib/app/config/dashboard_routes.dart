import 'package:flutter_modular/flutter_modular.dart';
import 'package:sangati/app/ui/dashboard/dashboard_screen.dart';

List<ModularRoute> dashboardRoutes = [
  ChildRoute('/', child: (context, args) => const DashboardScreen()),
];
