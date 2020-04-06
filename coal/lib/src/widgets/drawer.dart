
import 'package:coal/src/shared/preferences_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final pref = new PreferencesUser();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/happy-tooth.jpg'),
              )
            ), 
          ),
          ListTile(
            leading: Icon(Icons.account_circle, color: Colors.lightBlue),
            title: Text('Información Personal', style: TextStyle(color: Colors.lightBlue)),
            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.lightBlue),
            onTap: () {
              Navigator.popAndPushNamed(context, 'info');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.event_available, color: Colors.lightBlue),
            title: Text('Solicitar Cita', style: TextStyle(color: Colors.lightBlue)),
            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.lightBlue),
            onTap: () {
              Navigator.popAndPushNamed(context, 'cita');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.calendar_today, color: Colors.lightBlue),
            title: Text('Calendario', style: TextStyle(color: Colors.lightBlue)),
            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.lightBlue),
            onTap: () {
              Navigator.popAndPushNamed(context, 'calendar');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.lightBlue),
            title: Text('Instructivo para Citas', style: TextStyle(color: Colors.lightBlue)),
            trailing: Icon(Icons.keyboard_arrow_right, color: Colors.lightBlue),
            onTap: () {
              Navigator.popAndPushNamed(context, 'instructivo');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.lightBlue),
            title: Text('Cerrar Sesión', style: TextStyle(color: Colors.lightBlue)),
            onTap: () async {
              await _auth.signOut();
              await Navigator.of(context).pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
            },
          ),
          Divider()
        ],
      ),
    );
  }

}