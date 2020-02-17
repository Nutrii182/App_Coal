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
  DateTime _beginTime;
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
                      )),
                ));
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
							if(_entrada.isAfter(_beginTime) || _beginTime == DateTime.now()
              || _validaInicio() || _beginTime.isAfter(_salida)){
								Scaffold.of(context).showSnackBar(SnackBar(
										backgroundColor: Colors.blue,
										content: Text('Los Horarios son Inválidos')));
              } else{
                  _sendEmail();
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

    DateTime _v = DateTime.now();
    DateTime _u = _beginTime;

    String m = DateFormat("HH:mm").format(_v);
    String n = DateFormat("HH:mm").format(_u);
 
    final hora = m.substring(0).split(':');
    final i = hora[0];
    final j = hora[1];
    
    _v = DateTime.utc(1970,01,01,int.parse(i),int.parse(j));

    final hora1 = n.substring(0).split(':');
    final i1 = hora1[0];
    final j1 = hora1[1];

    _u = DateTime.utc(1970,01,01,int.parse(i1),int.parse(j1));

    if(_u.isBefore(_v))
      return false;
    return true;
  }

  void _sendEmail() async {

    String _s1 = DateFormat("HH:mm").format(_beginTime);
    String _user = "odont.coal@gmail.com";
    String _password = "CentroCoal";

    final smtpServer = gmail(_user, _password);

    final _message = Message()
      ..from = Address(_user, 'Sistema COAL')
      ..recipients.add('nutrii182@gmail.com')
      ..subject = 'Solicitud de Cita'
      ..text = 'Envío de Avisos mediante correo electrónico'
      ..html = '<h2>Solicitud de Cita</h2><p>El usuario ${pref.email} de nombre ${pref.name} solicitó una cita el día $_fecha a las $_s1 con motivo de $_motivo</p><br><p>Desea aceptarla cita especificada anteriormente..</p>';

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
