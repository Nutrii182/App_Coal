import 'package:coal/src/widgets/drawer.dart';
import 'package:flutter/material.dart';

class InstructivoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = new TextStyle(fontSize: 15.0);

    return Scaffold(
      drawer: DrawerWidget(),
      appBar: AppBar(
        title: Text('Instructivo Citas'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: ListView(
          children: <Widget>[
            _solicitarCita(textStyle),
            Divider(),
            _citaSolicitada(textStyle),
            Divider(),
            _cancelaCita(textStyle),
            Divider(),
            _estadoCita(textStyle),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _solicitarCita(TextStyle textStyle) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Solicitar Cita',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          Image(
            image: AssetImage('assets/solicita_cita.jpg'),
            height: 300.0,
            width: double.infinity,
          ),
          SizedBox(height: 5.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('- EL motivo es la necesidad que tiene (su malestar).',
                  style: textStyle),
              SizedBox(height: 5.0),
              Text('- La fecha y hora son cuando le gustaría ser atendid@.',
                  style: textStyle),
              SizedBox(height: 5.0),
              Text('Nota:'),
              Text('Atendemos de Lunes - Viernes de 9:00 am a 7:00 pm',
                  style: textStyle),
              Text('Los Sábados de 9:00 am a 2:00 pm', style: textStyle)
            ],
          )
        ],
      ),
    );
  }

  Widget _citaSolicitada(TextStyle textStyle) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Cita Agendada',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          Image(
            image: AssetImage('assets/calendario.jpg'),
          ),
          SizedBox(height: 5.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('- Los puntos en el calendario son citas agendadas.',
                  style: textStyle),
              SizedBox(height: 5.0),
              Text(
                  '- Las citas agendadas se verán en una lista debajo del calendario según el día seleccionado.',
                  style: textStyle),
              SizedBox(height: 5.0),
              Text(
                  '- Podrá ver la información más detallada al tocar un evento de la lista',
                  style: textStyle),
              SizedBox(height: 5.0),
              Text('Nota:'),
              Text(
                  'Sólo podrá ver la información detallada de las citas que haya solicitado',
                  style: textStyle),
            ],
          )
        ],
      ),
    );
  }

  Widget _cancelaCita(TextStyle textStyle) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Cancelar Cita',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          Image(
            image: AssetImage('assets/cancela_cita.jpg'),
          ),
          SizedBox(height: 5.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('- Puede Cancelar la cita en el momento que desee.',
                  style: textStyle),
              SizedBox(height: 5.0),
              Text('Nota:'),
              Text('La cancelación de una cita es definitiva.',
                  style: textStyle),
            ],
          )
        ],
      ),
    );
  }

  Widget _estadoCita(TextStyle textStyle) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Estado de la Cita',
              style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
          SizedBox(height: 10.0),
          Image(
            image: AssetImage('assets/cita_aceptada.jpg'),
          ),
          Image(
            image: AssetImage('assets/cita_cancelada.jpg'),
          ),
          SizedBox(height: 5.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Nota:', style: textStyle),
              Text('Su cita puede ser aceptada o rechazada, en caso de que obtenga la respuesta a su petición estando en la página principal recibirá un aviso como el mostrado anteriormente asegún la respuesta de COAL, sino recibirá una notificación normal.',
                  style: textStyle),
            ],
          )
        ],
      ),
    );
  }
}
