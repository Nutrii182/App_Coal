import 'package:coal/src/providers/push_notifications.dart';
import 'package:coal/src/shared/preferences_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:coal/src/shared/cita_class.dart';
import 'package:coal/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  Cita _cita;
  String _title, _subtitle;
  Map<DateTime, List<Cita>> _events;
  List<dynamic> _selectedEvents;
  CalendarController _calendarController;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final dbReference = Firestore.instance;
  final pref = new PreferencesUser();

  @override
  void initState() {
    super.initState();
    getUser().then((user){
      updateStorage(user.email);
    });
    _calendarController = CalendarController();
    _erasePast();
    _events = {};
    _selectedEvents = [];
    _getEvents();
    final pushNoti = PushNotifications();
    showAlertState(pushNoti);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(title: Text('Calendario Coal')),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              locale: 'es-MX',
              events: _events,
              formatAnimation: FormatAnimation.slide,
              calendarController: _calendarController,
              startingDayOfWeek: StartingDayOfWeek.sunday,
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
        trailing: Icon(Icons.keyboard_arrow_right),
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
            trailing: Icon(Icons.keyboard_arrow_right),
            title: Text("Cita ${event.hora}"),
            subtitle: Text('Aceptada', style: TextStyle(color: Colors.blue)),
            onTap: () =>
                Navigator.pushNamed(context, 'cancela', arguments: event),
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
                  Text('Rechazada', style: TextStyle(color: Colors.red)),
            );
          }
        }
      }
    }
  }

  void showAlertState(PushNotifications pushNoti) {
    pushNoti.initNotifications();
    pushNoti.message.listen((argument) {
      _title = argument['notification']['title'];
      _subtitle = argument['notification']['body'];

      if (_title == 'Cita Aceptada') {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: Container(
              padding: EdgeInsets.all(10.0),
              height: 105.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(_title,
                      style: TextStyle(color: Colors.blue, fontSize: 25.0)),
                  SizedBox(height: 10.0),
                  Text(_subtitle, style: TextStyle(color: Colors.black)),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text('Aceptar', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed('calendar');
                  }),
            ],
          ),
        );
      } else {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: Container(
              padding: EdgeInsets.all(10.0),
              height: 150.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(_title,
                      style: TextStyle(color: Colors.red, fontSize: 25.0)),
                  SizedBox(height: 10.0),
                  Text(_subtitle, style: TextStyle(color: Colors.black, )),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text('Aceptar', style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed('calendar');
                  }),
            ],
          ),
        );
      }
    });
  }

  bool _citaPasada(String fecha, String hora){

    final date = fecha.substring(0).split('/');
    final day = date[2];
    final month = date[1];
    final year = date[0];

    String fechaHoy = DateFormat("dd/MM/yyyy").format(DateTime.now());
    final dateNow = fechaHoy.substring(0).split('/');
    final dia = dateNow[2];
    final mes = dateNow[1];
    final anio = dateNow[0];

    DateTime newDate = DateTime.utc(int.parse(day), int.parse(month), int.parse(year));
    DateTime nowDate = DateTime.utc(int.parse(dia), int.parse(mes), int.parse(anio));

    if(newDate.isBefore(nowDate))
      return true;
    return false;
  }

  void deleteCita(String id){

    try{
      dbReference.collection('Citas').document(id).delete();
    }catch (e){
      print(e.toString());
    }
  }

  Future<void> _erasePast() async {

    try{
      await dbReference.collection('Citas').getDocuments().then((val){
        for(var i = 0; i < val.documents.length; i++){
          if(_citaPasada(val.documents[i].data["Fecha"], val.documents[i].data["Hora"]) == true || val.documents[i].data["Estado"] == 'Rechazada'){
            deleteCita(val.documents[i].documentID);
            print('Hola');
          }
        }
      });
    } catch(e){
      print(e.toString());
    }
  }

  Future <FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

  void updateStorage(String user) async {
    await dbReference
        .collection("Usuarios")
        .document(user)
        .get()
        .then((value) {
      pref.name = value.data['Nombre'];
      pref.date = value.data['Fecha de Nacimiento'];
      pref.gender = value.data['Genero'];
      pref.email = value.data['Correo'];
      pref.token = value.data['Token'];
    });
  }
}
