import 'package:flutter/material.dart';
import 'package:iot_project_app/Tools/ReformateIterativeData.dart';
import 'package:iot_project_app/Widgets/CustomCard.dart';
import 'BarChart.dart';
import 'package:iot_project_app/Models/ChartItem.dart';
class CardBarChartSensor extends StatelessWidget {
  final List<SensorItemChart> sensorData;

  CardBarChartSensor._(this.sensorData);

  factory CardBarChartSensor({@required List<SensorItemChart> sensorData}) {

    List<SensorItemChart> valuesWithIds = [];
    //print("The new distance is $newData");
    //sensorData = reformatSensorData(sensorData, newData);
    sensorData.forEach((value) {
      SensorItemChart charItem =
      new SensorItemChart(value.value, value.index);

      valuesWithIds.add(charItem);
    });
    return new CardBarChartSensor._(valuesWithIds);
  }

  @override
  Widget build(BuildContext context) {
    return new CustomCard(
      child: Container(
        child: SensorBarChart(
          sensorItemChart: sensorData,

        ),
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 0),
      ),
      height: 300,
    );
  }
}