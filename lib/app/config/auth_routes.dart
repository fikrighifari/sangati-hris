import 'package:flutter_modular/flutter_modular.dart';
import 'package:sangati/app/ui/auth/login_screen.dart';
import 'package:sangati/app/ui/auth/register_screen.dart';

List<ModularRoute> authRoutes = [
  ChildRoute('/', child: (context, args) => const LoginScreen()),
  ChildRoute('/register-screen/',
      child: (context, args) => const RegisterScreen()),
];
