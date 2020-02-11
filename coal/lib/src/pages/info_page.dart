
import 'package:flutter/material.dart';
import 'package:coal/src/widgets/drawer.dart';
import 'package:coal/src/shared/preferences_user.dart';

class InfoPage extends StatefulWidget {

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  final pref = new PreferencesUser();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Información Personal'),
      ),
      drawer: DrawerWidget(),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('Nombre: ${pref.name}'),
            ),
            Divider(),
            ListTile(
              title: Text('Fecha de Nacimiento: ${pref.date}'),
            ),
            Divider(),
            ListTile(
              title: Text('Género: ${pref.gender}'),
            ),
            Divider(),
            ListTile(
              title: Text('Correo: ${pref.email}'),
            ),
          ],
        ),
      )
    );
  }
}