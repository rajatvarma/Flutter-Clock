import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'alarm.dart';


List _colors = <Color>[
  Color(0xFF4D53E0), 
  Color(0xFFFF5768), 
  Color(0xFF37D4E2), 
  Color(0xFFFE903F), 
  Color(0xFF854DE0)
];


class AddAlarm extends StatefulWidget {
  @override
  _AddAlarmState createState() => _AddAlarmState();
}

class _AddAlarmState extends State<AddAlarm> {
  Alarm tempAlarm = new Alarm(_colors[0], null, {'Mon':false, 'Tue':false, 'Wed':false, 'Thu':false, 'Fri':false, 'Sat':false, 'Sun':false}, true, DateTime.now(), null);
  final TextEditingController _title = new TextEditingController();

  List _buildDaysOptions(BuildContext context){
    final _dw = MediaQuery.of(context).size.width;
    final _dh = MediaQuery.of(context).size.height;
    List list = <Widget>[];
    List days = tempAlarm.daysActive.keys.toList();
    for (var i = 0; i < days.length; i++){
      final _isSelected = (tempAlarm.daysActive[days[i]]);
      if (i == 0){
        final _isNext = (tempAlarm.daysActive[days[i+1]]);
        list.add(
          Container(
            alignment: Alignment.center,
            width: (_dw-50)/days.length,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: (_dh-50)*0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(25),
                    right: _isNext ? Radius.zero : Radius.circular(25)
                    ),
                  color: _isSelected ? tempAlarm.color : null
                ),
                child: Text(days[i], style: TextStyle(color: _isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold),),
              ),
            onTap: (){
                setState(() {
                  tempAlarm.daysActive[days[i]] = !tempAlarm.daysActive[days[i]];                  
                });
              },
            ),
          )
        );
      }
      else if (i == days.length-1){
        final _isLast = (tempAlarm.daysActive[days[i-1]]);
        list.add(
          Container(
            alignment: Alignment.center,
            width: (_dw-50)/days.length,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: (_dh-50)*0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: _isLast ? Radius.zero : Radius.circular(25),
                    right: Radius.circular(25)),
                  color: _isSelected ? tempAlarm.color : null
                ),
                child: Text(days[i], style: TextStyle(color: _isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold),),
              ),
            onTap: (){
                setState(() {
                  tempAlarm.daysActive[days[i]] = !tempAlarm.daysActive[days[i]];                  
                });
              },
            ),
          )
        );
      }
      else{
        final _isBefore = (tempAlarm.daysActive[days[i-1]]);
        final _isAfter = (tempAlarm.daysActive[days[i+1]]);
        list.add(
          Container(
            alignment: Alignment.center,
            width: (_dw-50)/days.length,
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                height: (_dh-50)*0.05,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: !_isBefore ? Radius.circular(25) : Radius.zero,
                    right: !_isAfter ? Radius.circular(25) : Radius.zero,
                    ),
                  color: _isSelected ? tempAlarm.color : null
                ),
                child: Text(days[i], style: TextStyle(color: _isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold),),
              ),
              onTap: (){
                setState(() {
                  tempAlarm.daysActive[days[i]] = !tempAlarm.daysActive[days[i]];                  
                });
              },
            ),
          )
        );
      }
    }
    return list;
  }

  List _buildColorOptions(BuildContext context){
    final _dw = MediaQuery.of(context).size.width;
    //final _dh = MediaQuery.of(context).size.height;
    List list = <Widget>[];
    for (var color in _colors) {
      final _isSelected = (color == tempAlarm.color);
      list.add(
        Container(
          width: (_dw-50)/_colors.length,
          child: GestureDetector(
            onTap: (){
              setState((){
                //tempAlarm.title = _title.text;
                tempAlarm.color = color;
              });
            },
            child: CircleAvatar(
              radius: _isSelected ? (_dw-50)/_colors.length/5 : (_dw-50)/_colors.length/7,
              backgroundColor: color,
              child: _isSelected ? Icon(Icons.check, color: Colors.white, size: (_dw-50)/_colors.length/5,) : null,
              ),
          ),

        )
      );
    }
    return list;
  }
  
  Widget _buildBody(BuildContext context) {
    final _dw = MediaQuery.of(context).size.width;
    final _dh = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          Container(
            height: _dh*0.1,
            child: Row(children: [
              Container(
                height: (_dh-50)*0.1,
                alignment: Alignment.center,
                width: (_dw-50)*0.25,
                child: IconButton(
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, '/alarm');
                  },
                  icon: Icon(Icons.delete, color: _colors[0], size: (_dh-50)*0.04,),
                )
              ),
              Container(
                width: (_dw-50)*0.5,
                height: (_dh-50)*0.1,
                alignment: Alignment.center,
                child: Text('Add Alarm', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              ),
              Container(
                width: (_dw-50)*0.25,
                height: (_dh-50)*0.1,
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(Icons.save, color: _colors[0], size: (_dh-50)*0.04,),
                  onPressed: (){
                    setState(() {
                    tempAlarm.title = _title.text;
                    tempAlarm.isActive = true;
                    tempAlarm.ring = null;                      
                    });
                    Navigator.pushReplacementNamed(context, '/alarm', arguments: tempAlarm);
                  },)
              ),
            ],),
          ),
          Container(
            height: (_dh-50)*0.4,
            child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (DateTime t){
                  setState(() {
                    tempAlarm.time = t;                    
                  });
                },
                use24hFormat: true
                ,),
          ),
          Container(
            height: (_dh-50)*0.1,
            child: Row(children: _buildDaysOptions(context),),
          ),
          Container(
            height: (_dh-50)*0.1,
            child: TextField(
              controller: _title,
              decoration: InputDecoration(
                icon: Icon(Icons.create),
                hintText: 'Enter title',
                hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)
              ),
            ),
          ),
          Container(
            height: (_dh-50)*0.2,
            child: Column(children: [
              Container(
                width: _dw-50,
                child: Text('Select color: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                margin: EdgeInsets.only(bottom:15),
              ),
              Row(children: _buildColorOptions(context),)
            ],),
          ),
        ],
      )
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null) {
      try {
      tempAlarm = ModalRoute.of(context).settings.arguments;
      }
      catch (_TypeError) {
       print('omagus');
      }
    }
    return Scaffold(
      body: _buildBody(context),
    );
  }
}