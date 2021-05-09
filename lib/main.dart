import 'package:clock_app/addAlarms.dart';
import 'package:clock_app/timer.dart';
import 'package:flutter/material.dart';
import 'clock.dart';
import 'selectTZs.dart';
import 'alarm.dart';
import 'package:flutter/services.dart';
import 'fileHandler.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Cera Pro'
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Clock(),
        '/tzs': (context) => TimeZones(),
        '/alarm': (context) =>  Alarms(storage: AlarmStorage(),),
        '/addalarm': (context) => AddAlarm(),
        '/timer': (context) => Timer()
      },
    );
  }
}