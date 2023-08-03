import 'package:flutter_modular/flutter_modular.dart';
import 'package:sangati/app/ui/profile/profile_screen.dart';
import 'package:sangati/app/ui/profile/setting_screen.dart';

List<ModularRoute> profileRoutes = [
  ChildRoute('/', child: (context, args) => const ProfileScreen()),
  ChildRoute('/setting_screen', child: (context, args) => const SettingSreen()),
];
