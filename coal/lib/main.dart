import 'package:flutter/material.dart';
import 'package:coal/src/pages/login_page.dart';
import 'package:coal/src/routes/routes.dart';
import 'package:coal/src/shared/preferences_user.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
 
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en','US'),
        const Locale('es' 'ES'),
      ],
      title: 'Coal',
      initialRoute: 'login',
      routes: getApplicationsRoutes(),
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
          builder: (BuildContext context) => LoginPage()
        );
      },
    );
  }
}