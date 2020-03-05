import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:coal/src/shared/preferences_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:coal/src/shared/cita_class.dart';
import 'package:coal/src/widgets/drawer.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Cita _cita;
  Map<DateTime, List<Cita>> _events;
  List<dynamic> _selectedEvents;
  CalendarController _calendarController;
  final dbReference = Firestore.instance;
  final fcmReference = FirebaseMessaging();
  final pref = new PreferencesUser();

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _events = {};
    _selectedEvents = [];
    _getEvents();
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
            ..._selectedEvents.map((event) {
              return _showEvents(event);
            })
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
        _cita = Cita(v['Nombre'], v['Usuario'], v['Motivo'], v['Fecha'],
            v['Hora'], v['Estado'], v['Token']);
        if (_events[_convierteFecha(_cita.fecha)] != null)
          _events[_convierteFecha(_cita.fecha)].add(_cita);
        else
          _events[_convierteFecha(_cita.fecha)] = [_cita];
      });
    });
    return _events;
  }

  Widget _showEvents(Cita event) {
    if (event.estado == 'En Espera' && event.usuario == pref.email) {
      return ListTile(
        leading: Icon(Icons.event),
        title: Text("Cita ${event.hora}"),
        subtitle: Text('En Espera'),
        onTap: () => Navigator.pushNamed(context, 'cancela', arguments: event),
      );
    } else {
      if (event.estado == 'En Espera') {
        return ListTile(
          leading: Icon(Icons.event),
          title: Text("Cita ${event.hora}"),
          subtitle: Text('En Espera'),
        );
      } else {
        if (event.estado == 'Aceptada' && event.usuario == pref.email) {
          return ListTile(
            leading: Icon(Icons.event_available, color: Colors.blue),
            title: Text("Cita ${event.hora}"),
            subtitle: Text('Aceptada', style: TextStyle(color: Colors.blue)),
            onTap: () => Navigator.pushNamed(context, 'cancela', arguments: event),
          );
        } else {
          if (event.estado == 'Aceptada') {
            return ListTile(
              leading: Icon(Icons.event_available, color: Colors.blue),
              title: Text("Cita ${event.hora}"),
              subtitle: Text('Aceptada', style: TextStyle(color: Colors.blue)),
            );
          } else {
            return ListTile(
              leading: Icon(Icons.event_busy, color: Colors.red),
              title: Text("Cita ${event.hora}"),
              subtitle:
                  Text('Cancelada', style: TextStyle(color: Colors.redAccent)),
            );
          }
        }
      }
    }
  }
}
