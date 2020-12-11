import 'package:flutter/material.dart';


class CustomCard extends StatelessWidget {
  final Widget child;
  final double height;

  CustomCard({this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
            margin: const EdgeInsets.only(left: 8, right: 8),
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: child,
            )),
        height: this.height);
  }
}