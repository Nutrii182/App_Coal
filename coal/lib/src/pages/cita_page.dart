import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:coal/src/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CitaPage extends StatefulWidget {
  @override
  _CitaPageState createState() => _CitaPageState();
}

class _CitaPageState extends State<CitaPage> {
  String _fecha;
  DateTime _beginTime;
  DateTime _endTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerWidget(),
        appBar: AppBar(title: Text('Solicitar Cita')),
        body: Builder(
            builder: (context) => Center(
                  child: Container(
                      padding: EdgeInsets.all(20.0),
                      child: ListView(
                        children: <Widget>[
                          _createDate(context),
                          Divider(),
                          _createBeginTime(context),
                          Divider(),
                          _createEndTime(context),
                          SizedBox(height: 20.0),
                          _createButtons(context)
                        ],
                      )),
                )));
  }

  Widget _createDate(BuildContext context) {
    final format = DateFormat("dd-MM-yyyy");

    return DateTimeField(
      format: format,
			
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          labelText: 'Fecha de la Cita',
          icon: Icon(Icons.event)),
      onShowPicker: (BuildContext context, DateTime currentValue) {
        return showDatePicker(
          context: context,
          firstDate: DateTime.now(),
          initialDate: currentValue ?? DateTime.now(),
          lastDate: DateTime(2030),
        );
      },
      onChanged: (value) {
        _fecha = DateFormat("dd/MM/yyyy").format(value);
      },
    );
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

  Widget _createEndTime(BuildContext context) {
    final format = DateFormat("HH:mm");

    return DateTimeField(
      format: format,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        labelText: 'Término de la Cita',
        icon: Icon(Icons.timer_off),
      ),
      onShowPicker: (BuildContext context, DateTime currentValue) async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
        );
        return DateTimeField.convert(time);
      },
      onChanged: (value) {
        _endTime = value;
      },
    );
  }

  Widget _createButtons(BuildContext context) {

		DateTime _entrada = DateTime.parse('1970-01-01 18:57:00.000');
		DateTime _salida = DateTime.parse('1970-01-01 18:57:00.000');

    return Row(children: <Widget>[
      RaisedButton(
          color: Colors.blue,
          child: Text('Aceptar', style: TextStyle(color: Colors.white)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: () {
						print(_beginTime);
            if (_fecha == null || _beginTime == null || _endTime == null){
              Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.blue,
                  content: Text('No puede haber algún campo vacío')));
						} else{
							if(_endTime.isBefore(_beginTime) || _beginTime.isAfter(_endTime)
							|| _beginTime.isBefore(_entrada) || _endTime.isAfter(_salida))
								Scaffold.of(context).showSnackBar(SnackBar(
										backgroundColor: Colors.blue,
										content: Text('Los Horarios son Inválidos')));
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
}
