import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TimeZones extends StatefulWidget {
  @override
  _TimeZonesState createState() => _TimeZonesState();
}

class _TimeZonesState extends State<TimeZones> {

  List _timeZones = [];
  List filteredNames = [];
  List _allTimeZonesNames = tz.timeZoneDatabase.locations.keys.toList();
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";

  _TimeZonesState() {
    _filter.addListener(
      (){
        if (_filter.text.isEmpty) {
          setState(() {
            _searchText = "";
            filteredNames = _allTimeZonesNames;            
          });
        }
        else {
          setState(() {
            _searchText = _filter.text;  
          });
        }
      }
    );
  }

  @override
  void initState() {
    super.initState();
    filteredNames = <tz.Location>[];
    filteredNames = _allTimeZonesNames;
  }
  
  Widget _buildOptionsList(_dw, _dh) {
    if (_searchText.isNotEmpty) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }

    return ListView.builder(
        itemCount: filteredNames.length,
        itemBuilder: /*1*/ (context, i) {
          return _buildOption(_dw, _dh, filteredNames[i]);
        });
  }


  Widget _buildOption(_dw, _dh, i){
    final _isAdded = _timeZones.contains(i);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: !_isAdded ? Colors.white : Colors.lightGreen[400],
        borderRadius: BorderRadius.all(Radius.circular(15))
      ),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(children: [
      Container(
        width: (_dw-90)*0.8,
        child: Text(i, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
      ),
      Container(
        width: (_dw-90)*0.2,
        child: IconButton(
          onPressed: (){
            if (_isAdded){
              setState(() {
                _timeZones.remove(i);                
              });
            }
            else {
              setState(() {
                _timeZones.add(i);                
              });
            }
          }, 
          icon: Icon(
            !_isAdded ? Icons.add : Icons.remove))
      ),
    ],));
  }

  final _colorSchemeBlue = Color.fromRGBO(67, 71, 187, 1);

  Widget _buildBody(BuildContext context) {
    _timeZones = ModalRoute.of(context).settings.arguments;
    final _dw = MediaQuery.of(context).size.width;
    final _dh = MediaQuery.of(context).size.height;
    return Container(
        padding: EdgeInsets.all(25),
        color: _colorSchemeBlue,
        height: _dh,
        width: _dw,
        child: Column(children: [
          Container(
            height: (_dw-50)*0.1,
            width: _dw,
            child: Text('Select your favorite time zones', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: (_dh-50)*0.01),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15))
            ),
            height: (_dh-50)*0.075,
            width: _dw,
            child: TextField(
              controller: _filter,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...'
        ),
            )
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: (_dh-50)*0.7,
            child: _buildOptionsList(_dw, _dh)
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(top: (_dw-50)*0.01),
                width: (_dw-50)*0.45,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: (){
                    setState(() {
                      _timeZones.clear();                
                    });
                  },
                  child: Text('Clear All', style: TextStyle(color: Colors.black),),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: (_dw-50)*0.01),
                width: (_dw-50)*0.1,),
              Container(
                margin: EdgeInsets.only(top: (_dw-50)*0.01),
                width: (_dw-50)*0.45,
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green[600])),
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, '/', arguments:_timeZones);
                  },
                  child: Text('Done', style: TextStyle(fontWeight: FontWeight.bold),),
                ),
              )
            ],
          )
        ],)
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }
}