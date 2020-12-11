import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:iot_project_app/Models/ChartItem.dart';
import 'package:iot_project_app/Tools/ReformateIterativeData.dart';
import 'package:iot_project_app/Widgets/BarChart.dart';
import 'package:iot_project_app/Widgets/CardBarChartSensor.dart';
import 'package:iot_project_app/Widgets/CircularProgress.dart';
import 'package:iot_project_app/Routes/transition_route_observer.dart';
import 'package:iot_project_app/Widgets/arrow_control.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../sensor.dart';
import 'package:iot_project_app/Widgets/Slider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
class SensorVisualisationPage extends StatefulWidget {
  static const routeName = '/sensor_visualisation';
  @override
  _SensorVisualisationPageState createState() => _SensorVisualisationPageState();
}

class _SensorVisualisationPageState extends State<SensorVisualisationPage>
    with TransitionRouteAware, SingleTickerProviderStateMixin{
  final databaseReference = FirebaseDatabase.instance.reference();
  VideoPlayerController _controller;
  TabController _tabController;
  int tabIndex = 0;
  double distanceData = 0;
  double currentSliderValue = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference _sensorsRef = FirebaseDatabase.instance.reference().child('sensors');

  List<SensorItemChart> lastSensorData = List<SensorItemChart>.generate(20, (index) => SensorItemChart(0, index));
  /*
  List<SensorItemChart> lastSensorData = [
    new SensorItemChart(0, 1),
    new SensorItemChart(1, 2),
    new SensorItemChart(2, 3),
    new SensorItemChart(5, 4),
    new SensorItemChart(1, 5),
    new SensorItemChart(8, 6),
    new SensorItemChart(4, 7),
    new SensorItemChart(7, 8),
    new SensorItemChart(1, 9),
    new SensorItemChart(5, 10),
  ];
  */
  bool _signIn;
  Timer _timer;
  Duration videoLength;
  Duration videoPosition;
  SensorItemChart distanceGlobalValue = SensorItemChart(0, 15);
  double volume = 0.5;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _signIn = false;

    _controller = VideoPlayerController.network(
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'
        //'http://100.65.2.73:12345/video_feed'
        //'https://www.youtube.com/watch?v=9W8O6uOBuTA'
    )
      ..addListener(() => setState(() {
        videoPosition = _controller.value.position;
      }))
      ..initialize().then((_) => setState(() {
        videoLength = _controller.value.duration;
      }));
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (_signIn) {
        setState(() {});
      }
    });

    _signInAnonymously();
  }



  @override
  Widget build(BuildContext context) {
    return _signIn ? mainScaffold() : signInScaffold();
  }

  void updateServoData(value){
    databaseReference.child('actuators/Json').update({
      'angle': value
    });

  }

  Widget mainScaffold() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(MaterialCommunityIcons.diameter)),
                Tab(icon: Icon(FontAwesomeIcons.chartPie)),
              ],
            ),
            title: Text('Robot Control'),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  if (_controller.value.initialized) ...[
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),

                    VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      padding: EdgeInsets.all(10),
                    ),

                    Row(
                      children: <Widget>[

                        IconButton(
                          icon: Icon(_controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow),
                          onPressed: () {
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
                        ),
                        /*
                        Text(
                            '${convertToMinutesSeconds(videoPosition)} / ${convertToMinutesSeconds(videoLength)}'),
                        SizedBox(width: 10),

                        Icon(animatedVolumeIcon(volume)),
                        Slider(
                          value: volume,
                          min: 0,
                          max: 1,
                          onChanged: (_volume) => setState(() {
                            volume = _volume;
                            _controller.setVolume(_volume);
                          }),
                        ),
                        Spacer(),

                        IconButton(
                            icon: Icon(
                              Icons.loop,
                              color: _controller.value.isLooping
                                  ? Colors.green
                                  : Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _controller
                                    .setLooping(!_controller.value.isLooping);
                              });
                            }),
                        */
                      ],
                    )
                  ],
                  /*
                  CircularProgress(
                    child: Text("Distance"),
                    height: 200,
                    percentage: 70,
                  ),
                  */
                  Spacer(),
                  //SliderData(),
                  ArrowController(speed: 9, databaseReference: databaseReference),

                  Text("Angle Value"),
                  Slider(
                    value: currentSliderValue,
                    min: 0,
                    max: 180,
                    divisions: 180,
                    label: currentSliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        currentSliderValue = value;
                        updateServoData(currentSliderValue.toInt());
                      });
                    },
                  )
                ],
              ),

              // Data Tab
              Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                        stream: _sensorsRef.onValue,
                        builder: (context, snapshot) {
                          print(snapshot);
                          if (snapshot.hasData &&
                              !snapshot.hasError &&
                              snapshot.data.snapshot.value != null) {
                            var _sensors = Sensors.fromJson(snapshot.data.snapshot.value['Json']);
                            print("sensors: ${_sensors.distance}");
                            /*
                            for(int i = 0; i<lastSensorData.length;i++){
                              print(lastSensorData[i].value);
                            }*/
                            lastSensorData = reformatSensorData(lastSensorData, _sensors.distance);
                            /*
                            for(int i = 0; i<lastSensorData.length;i++){
                              print(lastSensorData[i].value);
                            }*/
                            //updateSensorDataChart(_sensors.distance);
                            return Column(
                              //index: tabIndex,
                              children: [
                                _distanceLayout(_sensors),
                                CardBarChartSensor(sensorData: lastSensorData)
                              ],
                            );

                          } else {
                            return Center(
                              child: Text("NO DATA YET"),
                            );
                          }
                        }),
                  ),
                  //CardBarChartSensor(sensorData: lastSensorData, newData:distanceGlobalValue.value)

                ],
              ),

            ],
          ),
        ),
      ),
    );

  }
  void updateSensorDataChart(double distance){
    setState(() {
      lastSensorData = reformatSensorData(lastSensorData, distance);
    });

  }

  String convertToMinutesSeconds(Duration duration) {
    final parsedMinutes = duration.inMinutes < 10
        ? '0${duration.inMinutes}'
        : duration.inMinutes.toString();

    final seconds = duration.inSeconds % 60;

    final parsedSeconds =
    seconds < 10 ? '0${seconds % 60}' : (seconds % 60).toString();
    return '$parsedMinutes:$parsedSeconds';
  }
  IconData animatedVolumeIcon(double volume) {
    if (volume == 0)
      return Icons.volume_mute;
    else if (volume < 0.5)
      return Icons.volume_down;
    else
      return Icons.volume_up;
  }
  Widget _distanceLayout(Sensors _sensors) {
    if(_sensors.distance != null){
        distanceData = 5;
    }

    return Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                "Gaz concentration",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 40),
              child: Text(
                "${(_sensors.distance).toStringAsFixed(2)}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            )
          ],
        ));
  }

  Widget signInScaffold() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SIMPLE FIREBASE FLUTTER APP",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: 50,
            ),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.red,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20),
                  side: BorderSide(color: Colors.red)),
              onPressed: () async {
                _signInAnonymously();
              },
              child: Text(
                "ANONYMOUS SIGN-IN",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signInAnonymously() async {
    final FirebaseUser user = (await _auth.signInAnonymously()).user;
    print("*** user isAnonymous: ${user.isAnonymous}");
    print("*** user uid: ${user.uid}");

    setState(() {
      if (user != null) {
        _signIn = true;
      } else {
        _signIn = false;
      }
    });
  }
}