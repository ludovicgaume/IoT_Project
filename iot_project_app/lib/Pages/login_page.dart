import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'package:iot_project_app/Pages/sensor_visualisation.dart';
import 'dart:async';
import 'package:iot_project_app/main.dart';
import 'package:iot_project_app/constants.dart';
import 'package:flutter/services.dart';
import '../Routes/transition_route_observer.dart';
import 'package:iot_project_app/Widgets/get_account_id.dart';


class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TransitionRouteAware{
  String _ip = 'Unknown';

  bool _rememberState = false;

  @override
  void initState() {
    super.initState();

  }

  Widget checkBoxRobotInfo(){
    return Container(
      height: 20.0,
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberState,
              checkColor: Colors.blue,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberState = value;
                });
              },
            ),
          ),
          Text("Want to stay connected ?", style: kLabelStyle,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF73AEF5),
                  Color(0xFF61A4F1),
                  Color(0xFF478DE0),
                  Color(0xFF398AE5),
                ],
                stops: [0.1, 0.4, 0.7, 0.9],
              )
            ),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 120.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Image(image: AssetImage('assets/logo.png'),),
                  Text("Scan-O-Bot",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 30.0),

                  GetAccountParameter(
                    fieldName: "Account ID",
                    icon: Icons.perm_identity,
                    hintText: "Google Account ID",
                  ),




                  SizedBox(height:30),
                  GetAccountParameter(
                    fieldName: "Password",
                    icon: Icons.lock_outline,
                    hintText: "Enter your password",
                  ),

                  HowFindRobotIP(),
                  checkBoxRobotInfo(),
                  SizedBox(height: 30.0),
                  SubmitButton(
                      pageName: "Sensor Visualisation",
                      routeName: SensorVisualisationPage.routeName
                  ),
                  /*
                  SubmitButton(
                      pageName: "Navigation Map",
                      routeName: NavigationPage.routeName
                  ),

                   */
                //Text("Ip value is $_ip")
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

}

class SubmitButton extends StatelessWidget {
  final String robotIP;
  final String deviceIP;
  final String routeName;
  final String pageName;
  const SubmitButton({
    this.robotIP,
    this.deviceIP,
    this.routeName,
    this.pageName,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          Navigator.pushNamed(
              context,
              this.routeName,
              arguments: RobotAndDeviceIP(robotIP: this.robotIP, deviceIP: this.deviceIP));
          print("Ip of the device is ${this.deviceIP}");
        },
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        color: Colors.white,
        child: Text(this.pageName,
            style: TextStyle(
              color: Color(0xFF527DAA),
              letterSpacing: 1.5,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans',
            ),
        ),
      ),

    );
  }
}

class HowFindRobotIP extends StatelessWidget {
  const HowFindRobotIP({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => null,
        child: Text(
          "Forgot password ?",
          style: kLabelStyle,
        ),
      ),
    );
  }
}

class RobotAndDeviceIP {
  String robotIP;
  String deviceIP;
  RobotAndDeviceIP({this.robotIP, this.deviceIP});
}
