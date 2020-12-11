import 'package:flutter/material.dart';

class SliderData extends StatefulWidget {
  SliderData({Key key}) : super(key: key);

  @override
  _SliderDataState createState() => _SliderDataState();
}

/// This is the private State class that goes with SliderData.
class _SliderDataState extends State<SliderData> {
  double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentSliderValue,
      min: 0,
      max: 180,
      divisions: 180,
      label: _currentSliderValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }
}