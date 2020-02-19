import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coal/src/shared/preferences_user.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:coal/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class CitaPage extends StatefulWidget {
  @override
  _CitaPageState createState() => _CitaPageState();
}

class _CitaPageState extends State<CitaPage> {

  String _motivo;
  String _fecha;
  DateTime temp;
  DateTime _beginTime;
  bool _band = false;
  final dbReference = Firestore.instance;
  DateTime _entrada = DateTime.parse('1970-01-01 09:00:00.000');
  DateTime _salida = DateTime.parse('1970-01-01 19:00:00.000');
  TextEditingController _editDate = new TextEditingController();
  final pref = new PreferencesUser();

  @override
  Widget build(BuildContext context) {

    pref.lastPage = 'cita';

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(title: Text('Solicitar Cita')),
      body: Builder(
        builder: (context) => Center(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                _createReason(context),
                Divider(),
                _createDate(context),
                Divider(),
                _createBeginTime(context),
                Divider(),
                SizedBox(height: 20.0),
                _createButtons(context)
              ],
            ),
          )
        ),
      )
    );
  }

  Widget _createReason(BuildContext context){

    return TextFormField(
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Motivo',
          hintText: 'Motivo de la Cita',
          icon: Icon(Icons.short_text)
      ),
      onChanged: (v) {
        setState(() {
          _motivo = v;
        });
      },
    );
  }

  Widget _createDate(BuildContext context) {
    return TextFormField(
      controller: _editDate,
      enableInteractiveSelection: false,
      keyboardType: TextInputType.datetime,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Fecha de la Cita',
          icon: Icon(Icons.event)),
      validator: (value) =>
          value.isEmpty ? 'La fecha no puede estar vacía' : null,
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
    );
  }

  void _selectDate(BuildContext context) async {
    String _dateFormat;

    DateTime picked = await showDatePicker(
        context: context,
        firstDate: new DateTime.now(),
        initialDate: new DateTime.now(),
        lastDate: new DateTime(2030),
        locale: Locale('es', 'ES'));

    if (picked != null) {
      setState(() {
        temp = picked;
        _dateFormat = DateFormat("dd/MM/yyyy").format(picked);
        _editDate.text = _dateFormat;
        _fecha = _dateFormat;
      });
    }
  }

  Widget _createBeginTime(BuildContext context) {
    final format = DateFormat("HH:mm");

    return DateTimeField(
      format: format,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Inicio de la Cita',
          icon: Icon(Icons.timer)),
      onShowPicker: (BuildContext context, DateTime currentValue) async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
        );
        return DateTimeField.convert(time);
      },
      onChanged: (value) {
        _beginTime = value;
      },
    );
  }

  Widget _createButtons(BuildContext context) {

    return Row(children: <Widget>[
      RaisedButton(
          color: Colors.blue,
          child: Text('Aceptar', style: TextStyle(color: Colors.white)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: () {
            if (_fecha == null || _beginTime == null || _motivo == null){
              Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.blue,
                  content: Text('No puede haber algún campo vacío')));
						} else{
							if(_validaInicio() || _beginTime.isAfter(_salida) || _beginTime.isBefore(_entrada)){
								Scaffold.of(context).showSnackBar(SnackBar(
										backgroundColor: Colors.blue,
										content: Text('Los Horarios son Inválidos')));
              } else{
                  _validaCita();
                  Future.delayed(Duration(seconds: 2), () {
                    if(_band == true){
                      Scaffold.of(context).showSnackBar(SnackBar(
										backgroundColor: Colors.blue,
										content: Text('El horario esta ocupado')));
                    } else{
                      _sendEmail();
                      _registraCita();
                      Scaffold.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text('Se solicitó la cita correctamente')));
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.pushReplacementNamed(context, 'calendar');
                      });
                    }
                  }
                );
              }
						}
          }),
      SizedBox(width: 15.0),
      RaisedButton(
          color: Colors.red,
          child: Text('Cancelar', style: TextStyle(color: Colors.white)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: () {
						Navigator.pushReplacementNamed(context, 'calendar');
					}),
    ]);
  }

  bool _validaInicio(){

    DateTime _hoy = DateTime.now();
    DateTime _cita = _beginTime;

    String m = DateFormat("HH:mm").format(_hoy);
    String n = DateFormat("HH:mm").format(_cita);
 
    final hora = m.substring(0).split(':');
    final i = hora[0];
    final j = hora[1];
    
    _hoy = DateTime.utc(1970,01,01,int.parse(i),int.parse(j));

    final hora1 = n.substring(0).split(':');
    final i1 = hora1[0];
    final j1 = hora1[1];

    _cita = DateTime.utc(1970,01,01,int.parse(i1),int.parse(j1));

    if(_cita.isBefore(_hoy) && temp.isBefore(DateTime.now()))
      return true;
    return false;
  }

  Future<void> _registraCita() async {

    final _dateFormat = DateFormat("HH:mm").format(_beginTime);

    return await dbReference.collection("Citas").add({
      'Nombre': pref.name,
      'Usuario': pref.email,
      'Fecha': _fecha,
      'Hora': _dateFormat,
      'Motivo': _motivo,
      'Estado': false,
    });
  }

  void _validaCita() async {

    final temp = DateFormat("HH:mm").format(_beginTime);

    await dbReference.collection("Citas").getDocuments().then((val){
      for (var i = 0; i < val.documents.length; i++) {
        if(val.documents[i].data["Fecha"] == _fecha && val.documents[i].data["Hora"] == temp){
          _band = true;
        }
      }
    });
  }

  void _sendEmail() async {

    String _s1 = DateFormat("HH:mm").format(_beginTime);
    String _user = "odont.coal@gmail.com";
    String _password = "CentroCoal";

    final smtpServer = gmail(_user, _password);

    final _message = Message()
      ..from = Address(_user, 'Sistema COAL')
      ..recipients.add('nart182@yahoo.com.mx')
      ..subject = 'Solicitud de Cita'
      ..text = 'Envío de Avisos mediante correo electrónico'
      ..html = '<h2>Solicitud de Cita</h2><p>El usuario ${pref.email} de nombre ${pref.name} solicitó una cita el día $_fecha a las $_s1 con motivo de $_motivo</p><br><p>Desea aceptar la cita especificada anteriormente..</p>';

    try{
      final sendMail = await send(_message, smtpServer);
      print('Message sent: ' + sendMail.toString());
    } on MailerException catch(e){
        for (var p in e.problems)
          print('Problem: ${p.code}: ${p.msg}');
    }

    var connection  = PersistentConnection(smtpServer);
    await connection.close();
  }
}
