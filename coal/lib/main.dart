import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:coal/src/providers/push_notifications.dart';
import 'package:coal/src/shared/preferences_user.dart';
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
  //String _title, _subtitle;

  @override
  void initState() {
    super.initState();
    // final pushNoti = PushNotifications();
    // pushNoti.initNotifications();
    // pushNoti.message.listen((argument) {
    //   _title = argument['notification']['title'];
    //   _subtitle = argument['notification']['body'];

    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       content: ListTile(
    //         title: Text(_title),
    //         subtitle: Text(_subtitle),
    //       ),
    //       actions: <Widget>[
    //         FlatButton(
    //           child: Text('Ok'),
    //           onPressed: () => Navigator.of(context).pop(),
    //         ),
    //       ],
    //     ),
    //   );

    // });
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
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginPage());
      },
    );
  }
}
