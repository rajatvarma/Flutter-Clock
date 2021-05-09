import 'package:flutter/material.dart';
import 'dart:math' as math;

class Timer extends StatefulWidget {
  @override
  _TimerState createState() => _TimerState();
}

class _TimerState extends State<Timer> {

  final _colorSchemeBlue = Color(0xFF4D53DE);
  final _colorSchemePink = Color(0xFFFF5768);
  
  Widget _buildBody(BuildContext context) {

    final _dw = MediaQuery.of(context).size.width;
    final _dh = MediaQuery.of(context).size.height;

    List _clockStuff = <Widget>[];
  
    List _buildClockStuff() {
      for (var i = 0; i < 12; i++) {
        _clockStuff.add(
          Transform.rotate(
            angle: math.pi/6*i,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 13, 0, 0),
              alignment: Alignment.topCenter,
              height: (_dh-50)*0.275,
              width: (_dh-50)*0.275,
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                ),
            )
          )
      );
    }

    _clockStuff.add(
      Container(
        margin: EdgeInsets.all(_dh*0.065),
        decoration: BoxDecoration(
          color: Color(0xFF6268F7),
          shape: BoxShape.circle
        )
      )
    );

    //hours
    _clockStuff.add(
      Transform.rotate(
        angle: math.pi/6*(10),
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, _dh*0.055),
          width: 4,
          height: _dh*0.055,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))
          )
        ),
      )
    );

    //minutes
    _clockStuff.add(
      Transform.rotate(
        angle: math.pi/30*(0),
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, _dh*0.09),
          width: 3,
          height: _dh*0.09,
          decoration: BoxDecoration(
            color: _colorSchemePink,
            borderRadius: BorderRadius.all(Radius.circular(5))
          )
        ),
      )
    );

    //seconds
    _clockStuff.add(
      Transform.rotate(
        angle: math.pi/30*(0),
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, _dh*0.09),
          width: 2,
          height: _dh*0.09,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5))
          )
        ),
      )
    );
    
    //centerDot
    _clockStuff.add(
      Container(
        width: 10,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle
        )
      )
    );
    return _clockStuff;
  }
        
    return Container(
          width: _dw,
          height: _dh,
          padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
          decoration: BoxDecoration(
            color: _colorSchemeBlue,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: (_dw-30)*0.75,
                    height: (_dh-50)*0.1,
                    alignment: Alignment.centerLeft,
                    child: Text('Timer', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700),)
                  ),
                  Container(
                    width: (_dw-30)*0.05,
                    height: _dh*0.1,
                  ),
                  Container(
                    width: (_dw-30)*0.1,
                    height: (_dh-50)*0.1,
                    alignment: Alignment.center,
                    child:
                      CircleAvatar(
                        backgroundColor: Colors.black26,
                        child: IconButton(icon: Icon(Icons.settings, color: Colors.white, size: (_dw-50)*0.05,), onPressed: (){}, highlightColor: Colors.white,),
                        )
                  )
                ],
              ),
              Container(
                height: (_dh-50)*0.3,
                width: (_dh-50)*0.3,
                decoration: BoxDecoration(
                  border: Border.all(width: 8, color: Color(0xFFF8F8F9)),
                  borderRadius: BorderRadius.all(Radius.circular(_dw)),
                  ),
                child: Stack(
                  alignment: Alignment.center,
                  children: _buildClockStuff()
                ),
                ),
            ]
          ),
      );
    
  }
    
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:_buildBody(context),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height*0.1,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
            width: MediaQuery.of(context).size.width/4,
            child: IconButton(icon: Icon(Icons.alarm, color: Colors.black38), 
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/alarm');
            },),),
          Container(
            width: MediaQuery.of(context).size.width/4,
            child: IconButton(icon: Icon(Icons.language_outlined, color: _colorSchemeBlue), 
            onPressed: (){},),),
          Container(
            width: MediaQuery.of(context).size.width/4,
            child: IconButton(icon: Icon(Icons.timer, color: Colors.black38), 
            onPressed: (){},),)
        ],),
      ),
      );
  }
}