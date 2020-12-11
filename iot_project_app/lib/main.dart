import 'package:flutter/material.dart';

import 'Pages/sensor_visualisation.dart';
import 'package:iot_project_app/Routes/transition_route_observer.dart';
import 'package:iot_project_app/Pages/login_page.dart';
import 'package:iot_project_app/Pages/sensor_visualisation.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IOT Project',
      home: LoginPage(),
      navigatorObservers: [TransitionRouteObserver()],
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        SensorVisualisationPage.routeName: (context) => SensorVisualisationPage(),
        //NavigationPage.routeName: (context) => NavigationPage(),



      },
    );

  }
}