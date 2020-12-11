import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:iot_project_app/constants.dart';

class ArrowController extends StatefulWidget {
  final int speed;
  final databaseReference;
  const ArrowController({
    this.speed,
    this.databaseReference,

    
    Key key,}) : super(key: key);

  @override
  _ArrowControllerState createState() => _ArrowControllerState();
}

class _ArrowControllerState extends State<ArrowController> {

  bool _buttonPressed = false;
  bool _loopActive = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int speed = widget.speed;
    Move stop = Move(0, 0);
    void updateData(Move move){
      widget.databaseReference.child('actuators/Json').update({
        'motorSpeed': move.motorSpeed,
        'sens': move.sens,
      });
    }

    void onClickMove(move) async {

      if (_loopActive) return;
      _loopActive = true;

      while (_buttonPressed) {
        // do your thing
        setState(() {
          updateData(move);
        });
        // wait a bit
        await Future.delayed(Duration(milliseconds: 100));
      }
      setState(() {
        // stop state after leave the button
        updateData(stop);
      });
      _loopActive = false;
    }

    return Container(
      decoration: kBoxDecorationArrowControllerStyle,
      width: 350,
      child: Column(
        children: [
          /*RaisedButton(
              onPressed: () {
                onClickMove(Move(speed, 0));
              },
              child: Text('Up')
          ),*/
          Container(
            width: 70,
            child: Listener(
              onPointerDown: (details) {
                _buttonPressed = true;
                onClickMove(Move(speed, 0));
              },
              onPointerUp: (details) {
                _buttonPressed = false;
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(),
                    borderRadius: new BorderRadius.all(
                        const Radius.circular(20.0)
                    )),
                padding: EdgeInsets.all(16.0),
                child: Text('Up', textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Row(
            children: [
              padding(),
              /*RaisedButton(
                  onPressed: () {
              onClickMove(Move(0, -speed));
              },
                  child: Text('Left')
              ),*/
              Container(
                width: 70,

                child: Listener(
                  onPointerDown: (details) {
                    _buttonPressed = true;
                    onClickMove(Move(speed, 2));
                  },
                  onPointerUp: (details) {
                    _buttonPressed = false;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: new BorderRadius.all(
                            const Radius.circular(20.0)
                  )),
                    padding: EdgeInsets.all(16.0),
                    child: Text('Left', textAlign: TextAlign.center,),
                  ),
                ),
              ),
              SizedBox(width: 68,),
              Container(
                width: 70,
                child: Listener(
                  onPointerDown: (details) {
                    _buttonPressed = true;
                    onClickMove(Move(speed, 3));
                  },
                  onPointerUp: (details) {
                    _buttonPressed = false;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(),
                        borderRadius: new BorderRadius.all(
                            const Radius.circular(20.0)
                        )),
                    padding: EdgeInsets.all(16.0),
                    child: Text('Right', textAlign: TextAlign.center,),
                  ),
                ),
              ),
            ],
          ),
          /*RaisedButton(
              onPressed: () {
                onClickMove(Move(-speed, 0));
              },
              child: Text('Down')
          ),*/

          Container(
            width: 70,
            child: Listener(
              onPointerDown: (details) {
                _buttonPressed = true;
                onClickMove(Move(speed, 1));
              },
              onPointerUp: (details) {
                _buttonPressed = false;
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: new BorderRadius.all(
                     const Radius.circular(20.0)
                  ),
                ),
                padding: EdgeInsets.all(16.0),
                child: Text('Down', textAlign: TextAlign.center,),
              ),
            ),
          ),
        ],

      ),
    );
  }

}
Padding padding() {
  return new Padding(padding: EdgeInsets.only(left: 71));
}

class Move {
  int motorSpeed;
  int sens;
  Move(this.motorSpeed, this.sens);
}

