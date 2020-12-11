import 'package:flutter/material.dart';
import 'package:iot_project_app/Models/ChartItem.dart';

List<SensorItemChart> reformatSensorData(List<SensorItemChart> previousData, double newData) {

  List<SensorItemChart> reformatedData =[];
  SensorItemChart reformatedItem;
  SensorItemChart rawDataindexed;
  int databaseElements;

  var listLength = previousData.length;

  for (int i = 0; i < listLength; i++){
    //databaseElements = listLength - i - 1;
    if(i < (listLength-1)) {

      reformatedData.add(previousData[i+1]);
      print(" value print: ${reformatedData[i]}");
      reformatedData[i].index = i;
      //print("steps = $steps & day = $dayWeek");

    } else {
      // TODO add a case if the user have not enough data to fill the graph
      reformatedData.add(SensorItemChart(newData, i));
      //reformatedData[i].index = i;
    }

  }
  reformatedItem = SensorItemChart(newData*100, listLength);
  //reformatedData.insert(listLength, SensorItemChart(newData, reformatedData.length-1));
  return reformatedData;
}
