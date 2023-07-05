// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:safe_device/safe_device.dart';

// class Research extends StatefulWidget {
//   const Research({super.key});

//   @override
//   State<Research> createState() => _ResearchState();
// }

// class _ResearchState extends State<Research> {
//   bool isJailBroken = false;
//   bool canMockLocation = false;
//   bool isRealDevice = true;
//   bool isOnExternalStorage = false;
//   bool isSafeDevice = false;
//   bool isDevelopmentModeEnable = false;

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   Future<void> initPlatformState() async {
//     await Permission.location.request();

//     if (!mounted) return;
//     try {
//       isJailBroken = await SafeDevice.isJailBroken;
//       canMockLocation = await SafeDevice.canMockLocation;
//       isRealDevice = await SafeDevice.isRealDevice;
//       isOnExternalStorage = await SafeDevice.isOnExternalStorage;
//       isSafeDevice = await SafeDevice.isSafeDevice;
//       isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
//       print('canMockLocation ---> $canMockLocation');
//     } catch (error) {
//       print(error);
//     }

//     setState(() {
//       isJailBroken = isJailBroken;
//       canMockLocation = canMockLocation;
//       isRealDevice = isRealDevice;
//       isOnExternalStorage = isOnExternalStorage;
//       isSafeDevice = isSafeDevice;
//       isDevelopmentModeEnable = isDevelopmentModeEnable;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Device Safe check'),
//         ),
//         body: Builder(
//           builder: (BuildContext context) {
//             return Center(
//               // Use the new context provided by Builder
//               child: Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     // ...
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Text('isJailBroken():'),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             '${isJailBroken ? "Yes" : "No"}',
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Text('canMockLocation():'),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             '${canMockLocation ? "Yes" : "No"}',
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Text('isRealDevice():'),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             '${isRealDevice ? "Yes" : "No"}',
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Text('isOnExternalStorage():'),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             '${isOnExternalStorage ? "Yes" : "No"}',
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Text('isSafeDevice():'),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             '${isSafeDevice ? "Yes" : "False"}',
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           Text('isDevelopmentModeEnable():'),
//                           SizedBox(
//                             width: 8,
//                           ),
//                           Text(
//                             '${isDevelopmentModeEnable ? "Yes" : "False"}',
//                             style: TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                         ],
//                       ),
//                       InkWell(
//                         onTap: () {
//                           // Navigator.push(
//                           //   context,
//                           //   MaterialPageRoute(
//                           //     builder: (context) => Research(),
//                           //   ),
//                           // );
//                         },
//                         child: Container(
//                           margin: EdgeInsets.only(top: 10),
//                           color: Colors.red,
//                           width: 200,
//                           height: 50,
//                           child: Text('pindah'),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:location/location.dart';

// class PhoneCheckScreen extends StatefulWidget {
//   @override
//   _PhoneCheckScreenState createState() => _PhoneCheckScreenState();
// }

// class _PhoneCheckScreenState extends State<PhoneCheckScreen> {
//   Location location = Location();
//   bool isMockLocationOn = false;

//   @override
//   void initState() {
//     super.initState();
//     checkMockLocation();
//   }

//   Future<void> checkMockLocation() async {
//     isMockLocationOn = await location.isMockEnabled();
//     setState(() {});
//   }

//   Future<void> openLocationSettings() async {
//     await location.requestService();
//   }

//   Future<void> showTurnOffMockLocationDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Turn Off Mock Location'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Please turn off the mock location feature.'),
//                 Text('Go to the Developer Options and disable the mock location setting.'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Phone Check'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Mock Location: ${isMockLocationOn ? 'On' : 'Off'}',
//               style: TextStyle(fontSize: 20.0),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               child: Text('Check Mock Location'),
//               onPressed: () async {
//                 await checkMockLocation();
//                 if (isMockLocationOn) {
//                   await showTurnOffMockLocationDialog();
//                 }
//               },
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               child: Text('Open Location Settings'),
//               onPressed: () {
//                 openLocationSettings();
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_device_type/flutter_device_type.dart';
// import 'package:settings/settings.dart';

// class PhoneCheckScreen extends StatefulWidget {
//   @override
//   _PhoneCheckScreenState createState() => _PhoneCheckScreenState();
// }

// class _PhoneCheckScreenState extends State<PhoneCheckScreen> {
//   bool isMockLocationOn = false;

//   @override
//   void initState() {
//     super.initState();
//     checkMockLocation();
//   }

//   Future<void> checkMockLocation() async {
//     if (Device.get().isAndroid) {
//       final bool? isMockLocationEnabled = await Settings().isMockLocationEnabled;
//       setState(() {
//         isMockLocationOn = isMockLocationEnabled ?? false;
//       });
//     }
//   }

//   Future<void> showTurnOffMockLocationDialog() async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Turn Off Mock Location'),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text('Please turn off the mock location feature.'),
//                 Text('Go to the Developer Options and disable the mock location setting.'),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Phone Check'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'Mock Location: ${isMockLocationOn ? 'On' : 'Off'}',
//               style: TextStyle(fontSize: 20.0),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               child: Text('Check Mock Location'),
//               onPressed: () async {
//                 await checkMockLocation();
//                 if (isMockLocationOn) {
//                   await showTurnOffMockLocationDialog();
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';

// class MyScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Left'),
//             VerticalDivider(
//               color: Colors.black, // Customize the color of the divider
//               thickness: 2, // Adjust the thickness of the divider
//               // height: 40, // Set the height of the vertical divider
//             ),
//             Text('Right'),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab View Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TabViewScreen(),
    );
  }
}

class TabViewScreen extends StatefulWidget {
  @override
  _TabViewScreenState createState() => _TabViewScreenState();
}

class _TabViewScreenState extends State<TabViewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tab View Example'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Content Before TabBarView',
              style: TextStyle(fontSize: 24),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Tab1Screen(),
                Tab2Screen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Tab1Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tab 1 Content',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class Tab2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Tab 2 Content',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
