import 'dart:async';
//import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


class AlarmStorage {

  /*setUpAll() async {
    final directory = await Directory.systemTemp.createTemp();

    const MethodChannel('plugins.flutter.io/path_provider').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplcationDocumentsDirectory') {
        return directory.path;
      }
      return null;
    });
  }*/

  
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  
  Future<File> get _localFile async {
    final path = await _localPath;
    return new File('$path/alarms.txt');
  }

  Future<String> readAlarms() async {
    final file = await _localFile;
    final String contents = await file.readAsString();
    return contents;
  }
  
  Future<File> writeAlarms(String alarms) async {
    final file = await _localFile;
    return file.writeAsString(alarms);
  }
}