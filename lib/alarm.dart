import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'dart:convert';
import 'fileHandler.dart';

class Alarm {
  DateTime time;
  String title;
  Map daysActive;
  bool isActive;
  Color color;
  var ring;

  Alarm(
    this.color,
    this.title,
    this.daysActive,
    this.isActive,
    this.time,
    this.ring,
  );

  Map toMap() {
    return {'title': title, 'color': color.toString(), 'days': daysActive, 'active': isActive, 'time': time.toString(), 'ring': ring};
  }

  Alarm.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        isActive = json['active'],
        daysActive = json['days'],
        time = DateTime.parse(json['time']).toLocal(),
        ring = json['ring'],
        color = new Color(int.parse(json['color'].split('(0x')[1].split(')')[0], radix: 16)); // kind of hacky..

}




class Alarms extends StatefulWidget {
  
  final AlarmStorage storage;

  Alarms({Key key, @required this.storage}) : super(key: key);

  @override
  _AlarmsState createState() => _AlarmsState();
}

class _AlarmsState extends State<Alarms> {

  bool bruh = false;

  var _alarms = [];

  Alarm sentForUpdate;

  @override 
  void initState() {
    super.initState();
    widget.storage.readAlarms().then((String str) {
      setState(() {
        _alarms = getAlarms(str);
      });
    });
  }

  Future<File> _saveAlarms(List<Alarm> alarms) async {
    String str = "";
    for (var alarm in alarms) {
      str += jsonEncode(alarm.toMap());
      str += "|";
    } 
    return widget.storage.writeAlarms(str);
  }

  List<Alarm> getAlarms(str) {
    List<Alarm> list = [];
    for (var i in str.split('|')) {
      try {
        final Map<String, dynamic> map = jsonDecode(i.toString());
        list.add(Alarm.fromJson(map));
      }
      catch(e){
        continue;
      }
    }
    return list;
  }

  /*Widget _something() {
    return FutureBuilder(
      future: getAlarms(),
      builder: (context, AsyncSnapshot<List> data){
        if (data.hasData) {
          _alarms = data.data;
          return _buildAlarms(context);
        }
        else {
          return Container(
            height: 100,
            width: MediaQuery.of(context).size.width*0.6,
            alignment: Alignment.center,
            child:Text('You have not set any alarms.\nUse the "+" button to add an alarm', textAlign: TextAlign.center));
          }
      },

    );
  }*/

  Widget _buildAlarms(context) {
    return ListView.builder(
      itemCount: _alarms.length,
      itemBuilder: (context, i) {
        return _buildAlarmCard(context, _alarms[i]);
      },
    );
  }

  List _buildDays(BuildContext context, item){
    final _dw = MediaQuery.of(context).size.width;
    //final _dh = MediaQuery.of(context).size.height;
    List list = <Widget>[];
    List days = item.daysActive.keys.toList();
    for (var i = 0; i < days.length; i++){
      final _isSelected = (item.daysActive[days[i]]);
      list.add(
        Container(
          width: (_dw-90)*0.1,
          alignment: Alignment.center,
          child: Text(days[i], style: TextStyle(fontSize: 11, color: _isSelected ? Colors.white : Colors.black54, fontWeight: _isSelected ? FontWeight.w900: FontWeight.w500),),
          )
      );
    }
    return list;
  }
  
  Widget _buildAlarmCard(context, i) {
    final _dw = MediaQuery.of(context).size.width;
    //final _dh = MediaQuery.of(context).size.height;    
    return Container(
      margin: EdgeInsets.only(left: 15, bottom:20, right:15),
      width: _dw*0.8,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: i.isActive ? i.color.withOpacity(0.3): Colors.grey[300], 
            blurRadius: 10,
            spreadRadius: 5
          )
        ],
        image: DecorationImage(
              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.05), BlendMode.dstATop),
              image: AssetImage('assets/images/Frame 1.png'),
              fit: BoxFit.cover,
              ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: i.isActive ? i.color : Colors.grey[700]
      ),
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            width: (_dw-60)*0.65,
            child: Column(children: [
              Container(width: (_dw-50-30)*0.7, child: Text(i.title, style: TextStyle(color: i.isActive ? Colors.white: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),),),
              Container(width: (_dw-50-30)*0.7, child: Text(DateFormat.Hm().format(i.time).toString() , style: TextStyle(color: i.isActive ? Colors.white: Colors.grey, fontSize: 30, fontWeight: FontWeight.w500),),),
              Container(width: (_dw-50-30)*0.7,
              child: Row(
                children: _buildDays(context, i),
                )
              ),
            ],),
          ),
          Container(
            alignment: Alignment.centerRight,
            width: (_dw-60)*0.35,
            child: Column(
              children: [
                Switch(
                  activeColor: i.color,
                  activeTrackColor: Colors.white,
                  inactiveThumbColor: Colors.grey[300],
                  inactiveTrackColor: Colors.grey[400],
                  onChanged:(value){
                    setState(() {
                      i.isActive = !i.isActive;
                    });
                    }, 
                  value: i.isActive
                  ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.delete_outlined, color: Colors.white, size: 20), 
                    onPressed: (){
                      setState(() {
                        _alarms.remove(i);
                        _saveAlarms(_alarms);
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white, size: 20), 
                    onPressed: (){
                      Navigator.pushNamed(context, '/addalarm', arguments: i);
                    },
                  )
              ],)
            ],
          ),
      )]
      ),
    );
  }
  
  Widget _buildBody(context){
    final _dw = MediaQuery.of(context).size.width;
    final _dh = MediaQuery.of(context).size.height;
    return Container(
      height: _dh*0.9,
      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
      ),
      child: Column(children: [
        Row(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 15),
              width: (_dw-30)*0.75,
              height: (_dh-50)*0.1,
              child: Text('Alarms', style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700),)
            ),
            Container(
              alignment: Alignment.center,
              width: (_dw-30)*0.1,
              height: (_dh-50)*0.1,
              child:
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(icon: Icon(Icons.add, color: Colors.black87, size: (_dw-50)*0.05), onPressed: (){
                    Navigator.pushNamed(context, '/addalarm', arguments: _alarms);
                  }, highlightColor: Colors.white,),
                  )
            ),
            Container(
              width: (_dw-30)*0.05,
              height: (_dh-50)*0.1,
            ),
            Container(
              width: (_dw-30)*0.1,
              height: (_dh-50)*0.1,
              child:
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(icon: Icon(Icons.settings, color: Colors.black87,size: (_dw-50)*0.05), onPressed: (){}, highlightColor: Colors.white,),
                  )
            )
          ],
        ),
        Container(
          height: (_dh-50)*0.8,
          child: _buildAlarms(_alarms),
        )
      ],)
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    final _colorSchemeBlue = Color.fromRGBO(67, 71, 187, 1);
    if (ModalRoute.of(context).settings.arguments != null){
      var newAlarm = ModalRoute.of(context).settings.arguments;
      if (!_alarms.contains(newAlarm)){
        print('added');
        setState(() {_alarms.add(newAlarm);});
      }
    }
    print(_alarms);
    _saveAlarms(_alarms);
    return Scaffold(
      body:_buildBody(context),
      bottomNavigationBar: Container(
        height: (MediaQuery.of(context).size.height)*0.1,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Container(
            width: MediaQuery.of(context).size.width/4,
            child: IconButton(icon: Icon(Icons.alarm, color: _colorSchemeBlue), 
            onPressed: (){
              
            },),),
          Container(
            width: MediaQuery.of(context).size.width/4,
            child: IconButton(icon: Icon(Icons.language_outlined, color: Colors.black38), 
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/');
            },),),
          Container(
            width: MediaQuery.of(context).size.width/4,
            child: IconButton(icon: Icon(Icons.timer, color: Colors.black38), 
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/timer');
            },),)
        ],),
      ),
    );
  }
}