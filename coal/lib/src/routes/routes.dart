
import 'package:coal/src/pages/cancela_cita_page.dart';
import 'package:coal/src/pages/instructivo_page.dart';
import 'package:coal/src/pages/registro_page.dart';
import 'package:coal/src/pages/calendar_page.dart';
import 'package:coal/src/pages/login_page.dart';
import 'package:coal/src/pages/cita_page.dart';
import 'package:coal/src/pages/info_page.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationsRoutes(){

  return <String, WidgetBuilder>{
    'login' : (BuildContext context) => LoginPage(),
    'calendar' : (BuildContext context) => CalendarPage(),
    'cita' : (BuildContext context) => CitaPage(),
    'cancela': (BuildContext context) => CancelaCitaPage(),
    'info' : (BuildContext context) => InfoPage(),
    'registro' : (BuildContext context) => RegistroPage(),
    'instructivo' : (BuildContext context) => InstructivoPage(),
  };
}