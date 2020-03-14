
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

    pref.lastPage = 'info';

    return Scaffold(
      appBar: AppBar(
        title: Text('Información Personal'),
      ),
      backgroundColor: Colors.white,
      drawer: DrawerWidget(),
      body: Container(
        padding: EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.account_box, color: Colors.blue),
              title: Text('Nombre: ${pref.name}'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.cake, color: Colors.blue),
              title: Text('Fecha de Nacimiento: ${pref.date}'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blue),
              title: Text('Género: ${pref.gender}'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.email, color: Colors.blue),
              title: Text('Correo: ${pref.email}'),
            ),
          ],
        ),
      )
    );
  }
}