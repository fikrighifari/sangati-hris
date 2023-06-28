import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:sangati/app/modules/app_module.dart';
import 'package:sangati/app/service/auth_services.dart';
import 'package:sangati/app/ui/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthServices>(
        create: (context) => AuthServices(),
      ),
    ],
    child: ModularApp(module: AppModule(), child: const AppWidget()),
  ));
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // final alice = Alice();
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Modular.routerDelegate.setNavigatorKey(alice.getNavigatorKey());
//     return MaterialApp.router(
//       title: 'Sangati HRIS Apps',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       routerDelegate: Modular.routerDelegate,
//       routeInformationParser: Modular.routeInformationParser,
//     );
//   }
// }
