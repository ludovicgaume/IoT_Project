import 'package:flutter/widgets.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:iot_project_app/constants.dart';

class GetAccountParameter extends StatefulWidget {

  final String fieldName;
  final IconData icon;
  final String hintText;
  const GetAccountParameter({
    this.fieldName,
    this.icon,
    this.hintText,
    Key key,}) : super(key: key);
  @override
  GetAccountParameterState createState() => new GetAccountParameterState();
}
class GetAccountParameterState extends State<GetAccountParameter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.fieldName,
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          decoration: kBoxDecorationStyle,
          height: 60,
          child: TextField(
            keyboardType: TextInputType.text,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                widget.icon,
                color: Colors.white,
              ),
              hintText: widget.hintText,
              hintStyle: kHintTextStyle,
            ),
          ),
        )
      ],
    );
  }
}
