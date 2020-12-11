import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:iot_project_app/Models/ChartItem.dart';
class SensorBarChart extends StatefulWidget {
  final Widget child;
  final List<SensorItemChart> sensorItemChart;

  SensorBarChart({Key key, this.child, this.sensorItemChart}) : super(key: key);

  _SensorBarChartState createState() => _SensorBarChartState();
}


class _SensorBarChartState extends State<SensorBarChart> {
  List<charts.Series<SensorItemChart, String>> _seriesData;
  String changeNameValue(int value){
    return value.toString();
  }

  _generateData(stepWeekItemChart) {
    var chartStepData = stepWeekItemChart;
    _seriesData.add(
      charts.Series(
        domainFn: (SensorItemChart steps, _) => changeNameValue(steps.index),
        measureFn: (SensorItemChart steps, _) => steps.value,
        id: 'Gaz level',
        data: chartStepData,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (SensorItemChart color, _) =>
            charts.ColorUtil.fromDartColor(Color(0xff990099)),
      ),
    );

  }
  @override
  void initState() {

    super.initState();
    _seriesData = List<charts.Series<SensorItemChart, String>>();
    _generateData(widget.sensorItemChart);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: charts.BarChart(
        _seriesData,
        animate: true,
        barGroupingType: charts.BarGroupingType.grouped,
        //behaviors: [new charts.SeriesLegend()],
        animationDuration: Duration(seconds: 2),

      ),

    );
  }
}