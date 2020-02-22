import 'package:coal/src/shared/preferences_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:coal/src/widgets/drawer.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  String _conca = "";
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  CalendarController _calendarController;
  final dbReference = Firestore.instance;
  final pref = new PreferencesUser();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];
    _getEvents();
  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  Widget build(BuildContext context) {
    pref.lastPage = 'calendar';

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(title: Text('Calendario Coal')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              locale: 'es-MX',
              events: _events,
              formatAnimation: FormatAnimation.slide,
              calendarController: _calendarController,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                  centerHeaderTitle: true, formatButtonVisible: false),
              calendarStyle: CalendarStyle(
                  canEventMarkersOverflow: true,
                  holidayStyle: TextStyle().copyWith(color: Colors.red),
                  weekendStyle: TextStyle().copyWith(color: Colors.deepOrange)),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle().copyWith(color: Colors.deepOrange),
              ),
              onDaySelected: (date, events) {
                setState(() {
                  _selectedEvents = events;
                });
              },
              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                  margin: EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            ..._selectedEvents.map((event) => ListTile(
                  leading: Icon(Icons.event),
                  title: Text(event),
                ))
          ],
        ),
      ),
    );
  }

  DateTime _convierteFecha(String fecha) {
    final temp = fecha.substring(0).split('/');
    final dia = temp[0];
    final mes = temp[1];
    final anio = temp[2];

    return DateTime.utc(int.parse(anio), int.parse(mes), int.parse(dia), 0, 0);
  }

  Future<Map<DateTime, List>> _getEvents() async {
    var querySnapshot = await dbReference.collection('Citas').getDocuments();
    var items = querySnapshot.documents;

    setState(() {
      items.forEach((v) {
        _conca = "Cita " + " " + v["Hora"];
        if(_events[_convierteFecha(v['Fecha'])] != null)
          _events[_convierteFecha(v['Fecha'])].add(_conca);
        else
          _events[_convierteFecha(v['Fecha'])] = [_conca];
      });
    });
  }

}
