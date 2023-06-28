import 'package:flutter_modular/flutter_modular.dart';
import 'package:sangati/app/ui/history/history_screen.dart';

List<ModularRoute> attendanceRoutes = [
  ChildRoute('/',
      child: (context, args) => HistoryScreen(
            isBack: false,
          )),
];
