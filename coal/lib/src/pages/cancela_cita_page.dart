
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coal/src/shared/cita_class.dart';
import 'package:coal/src/shared/preferences_user.dart';
import 'package:coal/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class CancelaCitaPage extends StatefulWidget {
  @override
  _CancelaCitaPageState createState() => _CancelaCitaPageState();
}

class _CancelaCitaPageState extends State<CancelaCitaPage> {
  
  final dbReference = Firestore.instance;
  final pref = new PreferencesUser();
  Cita _cita;

  @override
  Widget build(BuildContext context) {

    _cita = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Información de la Cita')
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Paciente: ${_cita.nombre}'),
              leading: Icon(Icons.account_circle, color: Colors.blue),
            ),
            Divider(),
            ListTile(
              title: Text('Motivo: ${_cita.motivo}'),
              leading: Icon(Icons.short_text, color: Colors.blue),
            ),
            Divider(),
            ListTile(
              title: Text('Fecha: ${_cita.fecha}'),
              leading: Icon(Icons.calendar_today, color: Colors.blue),
            ),
            Divider(),
            ListTile(
              title: Text('Hora: ${_cita.hora}'),
              leading: Icon(Icons.timer, color: Colors.blue),
            ),
            Divider(),
            ListTile(
              title: Text('Estado: ${_cita.estado}'),
              leading: Icon(Icons.av_timer, color: Colors.blue),
            ),
            SizedBox(height: 20.0),
            _crearBoton()
          ],
        ),
      )
    );
  }

  Widget _crearBoton() {

    return Row(
      children: <Widget>[
        SizedBox(width: 20.0),
        RaisedButton(
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0) 
          ),
          child: Text('Cancelar Cita', style: TextStyle(color: Colors.white)),
          onPressed: _cancelaCita,
        ),
      ],
    );
  }

  Future<void> _cancelaCita(){

    return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('¿Desea Cancelar la Cita?', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
        actions: <Widget>[
          Row(
            children: <Widget>[
              FlatButton(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Text('Aceptar', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  _eliminaId();
                  _sendEmail();
                  Navigator.pushReplacementNamed(context, 'calendar');
                },
              ),
              SizedBox(width: 10.0),
              FlatButton(
                color: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                ),
                child: Text('Cancelar', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
  }

  void _eliminaId() async {

    String _idCita = _cita.fecha.replaceAll('/', ':');

    try{
      dbReference.collection('Citas').document(_idCita+':'+_cita.hora).delete();
    }catch (e){
      print(e.toString());
    }
  }

  void _sendEmail() async {
    String _user = "nutrii182@gmail.com";
    String _password = "Nutriiburra182";

    final smtpServer = gmail(_user, _password);

    final _message = Message()
      ..from = Address(_user, 'Sistema COAL')
      ..recipients.add('nart182@yahoo.com.mx')
      ..subject = 'Solicitud de Cita'
      ..text = 'Envío de Avisos mediante correo electrónico'
      ..html =
          '<h2>Solicitud de Cita</h2><p>El usuario ${pref.email} de nombre ${pref.name} canceló su cita el día ${_cita.fecha} a las ${_cita.hora}</p><br><p>Desea aceptar la cita especificada anteriormente..</p>';

    try {
      final sendMail = await send(_message, smtpServer);
      print('Message sent: ' + sendMail.toString());
    } on MailerException catch (e) {
      for (var p in e.problems) print('Problem: ${p.code}: ${p.msg}');
    }

    var connection = PersistentConnection(smtpServer);
    await connection.close();
  }
}