import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:coal/src/shared/preferences_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coal/src/pages/calendar_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:coal/src/pages/login_page.dart';
import 'package:coal/src/routes/routes.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = new PreferencesUser();
  await pref.initPref();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  final dbReference = Firestore.instance;
  bool _inicio = false;

  @override
  void initState() {
    super.initState();
    getUser().then((user){
      if(user != null)
        _inicio = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('es' 'ES'),
      ],
      title: 'Coal',
      initialRoute: 'login',
      routes: getApplicationsRoutes(),
      onGenerateRoute: (RouteSettings settings) {

        if(_inicio)
          return MaterialPageRoute(
            builder: (BuildContext context) => CalendarPage());
        else
          return MaterialPageRoute(
            builder: (BuildContext context) => LoginPage());
      },
    );
  }

  Future <FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }
}
